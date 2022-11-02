print('Avvio dell\'applicazione...')
import csv
import re
import json
import os
import tqdm
import pandas as pd
from pyswip import Prolog
from termcolor import colored
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_selection import SelectKBest, mutual_info_regression

SCELTE = """
1) Portieri
2) Difensori centrali
3) Terzini
4) Mediani
5) Centrali
6) Trequartisti
7) Punte
8) Ali
"""

char_to_replace = {
    " ": "_",
    "-": "_",
    "'": "_",
    "&": "and",
    "á": "a",
    "â": "a",
    "ã": "a",
    "ă": "a",
    "ă": "a",
    "ä": "a",
    "å": "a",
    "æ": "ae",
    "ą": "a",
    "à": "a",
    "č": "c",
    "ć": "c",
    "ç": "c",
    "đ": "d",
    "é": "e",
    "ë": "e",
    "ę": "e",
    "è": "e",
    "ğ": "g",
    "ï": "i",
    "í": "i",
    "ı": "i",
    "î": "i",
    "ī": "i",
    "ł": "l",
    "ñ": "n",
    "ń": "n",
    "ö": "o",
    "ó": "o",
    "ò": "o",
    "ô": "o",
    "ø": "o",
    "ř": "r",
    "ş": "s",
    "ș": "s",
    "š": "s",
    "þ": "th",
    "ü": "u",
    "ú": "u",
    "ü": "u",
    "ý": "y",
    "ž": "z",
    "ż": "z",
}

col_to_rem = [
    "goalsAssistsSum",
    "inaccuratePasses",
    "totalChippedPasses",
    "accurateChippedPasses",
    "penaltiesTaken",
    "totalLongBalls",
    "totalContest",
    "savesCaught",
    "savesParried",
    "lastSeasonTournamentCountry",
]

def filter_bad_strings(value: str, char_to_replace: dict) -> str:
    to_replace = re.search("^[0-9]+[.]*_* *", value)
    if to_replace is not None:
        to_replace = to_replace.group(0)
        value = (value.replace(to_replace, "")) + "_" + (to_replace.strip())
    value = value.lower().replace("i̇", "i").replace(" ", "_").replace(".", "")
    value = value.translate(str.maketrans(char_to_replace))
    return value

weight_dict = {}
with open("./datasets/unique_tournaments.csv") as f:
    csvr = csv.reader(f, delimiter=",")
    for row in csvr:
        val = row[0] + "_" + row[1]
        val = filter_bad_strings(val, char_to_replace)
        weight_dict[val] = row[2]

pl_kb = []

# inserting tournament values assertions
for k, v in weight_dict.items():
    k_swp = filter_bad_strings(k, char_to_replace)
    k_swp = re.sub("[_]{2,}", "_", k_swp)
    pl_kb.append(f"tournamentValue({k_swp}, {float(v) / 10}).")

with open("./datasets/player_stats.csv", "r", encoding="utf-8") as f:
    csvr = csv.reader(f, delimiter=",")
    header = next(csvr)
    last_team = ""
    team = ""
    for i, player in enumerate(csvr):
        j = 0
        for h in header:
            if h not in col_to_rem:
                pred = ""
                value = ""
                if j == 3:
                    last_team = re.sub("^[0-9]+[.]*_*", "", player[1])
                    last_team = filter_bad_strings(last_team, char_to_replace)
                    if last_team[0] == "_":
                        last_team = last_team[1:]
                if j == 10:
                    tournament = player[j]
                    country = player[j + 1]

                    value = tournament + "_" + country
                    value = filter_bad_strings(value, char_to_replace)
                    pred = "lastTournamentPlayed"
                else:
                    pred = h
                    value = player[j].lower().replace("i̇", "i").replace(" ", "_")
                    if j == 1:
                        value = re.sub("^[0-9]+[.]*_*", "", value)
                    value = value.translate(str.maketrans(char_to_replace))

                pl_kb.append(f"{pred}({i + 1},{value}).")
                if last_team != team:
                    team = filter_bad_strings(last_team, char_to_replace)
                    t = filter_bad_strings(player[2], char_to_replace)
                    pl_kb.append(f"teamInTournament({t},{team}).")
            j += 1

    with open("./Prolog/weightsAssertions.pl", "w", encoding="utf-8") as fout:
        weightsFile = open('./Prolog/weights.json')
        dataWeights = json.load(weightsFile)
        for roleWeight in dataWeights:
            for w in dataWeights[roleWeight]:
                fout.write(f"{w}Weight({roleWeight},{dataWeights[roleWeight][w]}).\n")

    pl_kb.sort()

    with open("./Prolog/dataset_preprocessed.pl", "w", encoding="utf-8") as fout:
        for line in pl_kb:
            fout.write(line + "\n")

        with open("./Prolog/rules.pl", "r", encoding="utf-8") as f:
            for line in f:
                fout.write(line)

prolog = Prolog()
prolog.consult("./Prolog/dataset_preprocessed.pl")
list_ids = f"[{', '.join([str(x) for x in range(1, 2353)])}]"
list(prolog.query('calc_and_assert_max_attr'))

common_features = [
    {"Età": "age"},
    {"Altezza": "height"},
    {"Media Voto": "rating"},
]

gk_features = common_features + [
    {"Salvataggi": "saves"},
    {"Clean Sheet": "cleanSheet"},
    {"Rigori Parati": "penaltyPercentage"},
]

dc_features = common_features + [
    {"Goal": "goals"},
    {"Intercetti": "interceptions"},
    {"Tiri Blocchati": "blockedShots"},
    {"Tackles Vinti": "tacklesWonPercentage"},
    {"Clean Sheet": "cleanSheet"},
    {"Percentuale di Palle Lunghe Accurate": "accurateLongBallsPercentage"},
]

fb_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Percentuale di Dribbling": "successfulDribblesPercentage"},
    {"Percentuale di Cross Accurati": "accurateCrossesPercentage"},
    {"Rigori Conquistati": "penaltyWon"},
    {"Tackles Vinti": "tacklesWonPercentage"},
    {"Assist": "assists"},
    {"Clean Sheet": "cleanSheet"},
]

dm_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Percentuale di Dribbling": "successfulDribblesPercentage"},
    {"Percentuale di Passaggi Accurati": "accuratePassesPercentage"},
    {"Intercetti": "interceptions"},
    {"Percentuale di Duelli a Terra Vinti": "groundDuelsWonPercentage"},
    {"Percentuale di Duelli Aerei Vinti": "aerialDuelsWonPercentage"},
    {"Percentuale di Palle Lunghe Accurate": "accurateLongBallsPercentage"},
    {"Tackles Vinti": "tacklesWonPercentage"},
]

mc_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Percentuale di Dribbling": "successfulDribblesPercentage"},
    {"Percentuale di Passaggi Accurati": "accuratePassesPercentage"},
    {"Percentuale di Cross Accurati": "accurateCrossesPercentage"},
    {"Percentuale di Palle Lunghe Accurate": "accurateLongBallsPercentage"},
    {"Tackles Vinti": "tacklesWonPercentage"},
    {"Assist": "assists"},
]

am_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Percentuale di Dribbling": "successfulDribblesPercentage"},
    {"Percentuale di Passaggi Accurati": "accuratePassesPercentage"},
    {"Percentuale di Cross Accurati": "accurateCrossesPercentage"},
    {"Percentuale di Palle Lunghe Accurate": "accurateLongBallsPercentage"},
    {"Assist": "assists"},
    {"Percentuale di Passaggi nella Metà Campo Avversaria": "oppositionHalfPassesPercentage"},
    {"Percentuale di Passaggi nella Trequarti Avversaria": "accurateFinalThirdPasses"},
    {"Frequenza di goal": "scoringFrequency"},
    {"Percentuale di Conversione Goal": "goalConversionPercentage"},
]

st_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Percentuale di Dribbling": "successfulDribblesPercentage"},
    {"Assist": "assists"},
    {"Percentuale di Passaggi nella Metà Campo Avversaria": "oppositionHalfPassesPercentage"},
    {"Percentuale di Passaggi nella Trequarti Avversaria": "accurateFinalThirdPasses"},
    {"Frequenza di goal": "scoringFrequency"},
    {"Percentuale di Conversione Goal": "goalConversionPercentage"},
]

w_features = common_features + [
    {"Goal": "goals"},
    {"Grandi Opportunità Create": "bigChancesCreated"},
    {"Passaggi Chiave": "keyPasses"},
    {"Rigori Conquistati": "penaltyWon"},
    {"Numero di Dribbling": "successfulDribbles"},
    {"Percentuale di Cross Accurati": "accurateCrossesPercentage"},
    {"Assist": "assists"},
    {"Percentuale di Passaggi nella Trequarti Avversaria": "accurateFinalThirdPasses"},
    {"Percentuale di Conversione Goal": "goalConversionPercentage"},
]

def cls():
    os.system('cls' if os.name=='nt' else 'clear')

def goBack(i: int):
    if i > 10:
        return ((int(i / 11) - 1) * 11)
    else:
        return 0

def goToPage(page: str):
    return ((int(page) - 1) * 11)

def goForward(i: int):
    return ((int(i / 11) + 1) * 11)

def paginateOutput(output: list):
    lines = int(len(output) / 10) + (1 if len(output) % 10 != 0 else 0)
    i = 0
    cls()
    currentPage = 0
    while currentPage < lines:
        if i % 11 == 0:
            cls()
            print('digitare il numero della pagina che si vuole mostrare, oppure "<" per la pagina precedente o ">" per quella successiva, e premere invio')
            print("\n".join(output[i - int(i / 11):i - int(i / 11) + 10] if i > 0 else output[i:i + 10]))
            i += 10
        else:
            if currentPage == lines - 1:
                scelta = input(f"< Prec {colored(lines, 'red')} Esc >\n")
                if scelta == "<":
                    i = goBack(i)
                    currentPage -= 1
                elif scelta == ">":
                    return
                else:
                    i = goToPage(scelta)
                    currentPage = int(scelta) - 1
            else:
                sceltaOut = "< Esc " if currentPage == 0 else "< Prec "
                sceltaOut += f"{colored(currentPage + 1, 'red')} "
                if currentPage < lines - 1:
                    sceltaOut += f"{currentPage + 2} "
                if currentPage < lines - 2:
                    sceltaOut += f"{currentPage + 3} "
                if currentPage < lines - 6:
                    sceltaOut += f"... "
                if currentPage < lines - 5:
                    sceltaOut += f"{lines - 2} "
                if currentPage < lines - 4:
                    sceltaOut += f"{lines - 1} "
                if currentPage < lines - 3:
                    sceltaOut += f"{lines} "
                scelta = input(f"{sceltaOut} Succ >\n")
            if scelta == "<":
                if currentPage > 0:
                    i = goBack(i)
                    currentPage -= 1
                else:
                    return
            elif scelta == ">":
                i = goForward(i)
                currentPage += 1
            else:
                try:
                    if(int(scelta) > 0 and int(scelta) <= lines):
                        i = goToPage(scelta)
                        currentPage = int(scelta) - 1
                    else:
                        i = goToPage(currentPage)
                except:
                    i = goToPage(currentPage)

def alterWeight(role: str, roleFeatures: list):
    scelte = [list(f.values())[0] for f in roleFeatures]
    while(True):
        cls()
        out = "Digitare il nome della caratteristica a cui si vuole dare maggiore importanza:\n"
        out += "\n".join([f"{i + 1}) {list(f.keys())[0]}" for i, f in enumerate(roleFeatures)])
        scelta = input(out + "\n0) Indietro\n> ")
        if int(scelta) > 0 and int(scelta) <= len(scelte):
            query = f"{scelte[int(scelta) - 1]}Weight({role}, Val)"
            weight = list(prolog.query(query))[0]["Val"]
            prolog.retractall(query)
            if scelte[int(scelta) - 1] != "age" and scelte[int(scelta) - 1] != "height":
                prolog.assertz(f"{scelte[int(scelta) - 1]}Weight({role}, {float(weight) * 3})")
            else:
                weight = [float(w) * 3 for w in list(weight)]
                prolog.assertz(f"{scelte[int(scelta) - 1]}Weight({role}, {weight})")
            input('Valore modificato correttamente! Premere per andare avanti')
        elif scelta == '0':
            return
        else:
            print('Scelta inserita non valida')
        cls()

def prettify_string(string: str) -> str:
    string = string.replace("_", " ")
    string = " ".join([word.capitalize() for word in string.lower().split(" ")])
    return string

def print_rank_role(role: str, budget: int = None):
    role_cap = role.capitalize()
    role_list = list(prolog.query(f"evaluate_all_{role}Budget({role_cap}, {budget})"))[0][role_cap] if budget else list(prolog.query(f"evaluate_all_{role}({role_cap})"))[0][role_cap]
    role_list.sort(key=lambda row: row[1], reverse=True)
    length_list = [len(str(element)) for row in role_list for element in row]
    column_width = max(length_list)
    rows = []
    for row in role_list:
        row[0] = prettify_string(row[0])
        row[1] = f"{row[1]:.2f}"
        row = "".join(str(element).ljust(column_width + 1) for element in row)
        rows.append(row)
    if len(rows) > 0:
        paginateOutput(rows)
    else:
        input('Nessun giocatore trovato! Premere per andare avanti')
        return

def visualizza_giocatori(budget: int = None):
    role_dict = {
        '1': 'gk',
        '2': 'dc',
        '3': 'fb',
        '4': 'dm',
        '5': 'mc',
        '6': 'am',
        '7': 'st',
        '8': 'w',
    }

    while(True):
        cls()
        scelta = input('Digitare un numero da 0 a 8 per i seguenti ruoli:' + SCELTE + '0) Indietro\n> ')
        if scelta in role_dict:
            print(scelta.upper())
            print_rank_role(role_dict[scelta], budget)
            input('Premere per andare avanti')
        elif scelta == '0':
            return
        else:
            print('Scelta inserita non valida')
        cls()


def modifica_features(budget: int):
    ### MODDING DELLE FEATURES DEI GIOCATORI
    while(True):
        cls()
        scelta = input('Digitare un numero da 0 a 8 per i seguenti ruoli:' + SCELTE + '9) Per effettuare le query\n0) Indietro\n> ')
        if scelta == '1':
            alterWeight('gk', gk_features)
        elif scelta == '2':
            alterWeight('dc', dc_features)
        elif scelta == '3':
            alterWeight('fb', fb_features)
        elif scelta == '4':
            alterWeight('dm', dm_features)
        elif scelta == '5':
            alterWeight('mc', mc_features)
        elif scelta == '6':
            alterWeight('am', am_features)
        elif scelta == '7':
            alterWeight('st', st_features)
        elif scelta == '8':
            alterWeight('w', w_features)
        elif scelta == '9':
            visualizza_giocatori(budget)
            input('Premere per andare avanti')
        elif scelta == '0':
            return

def visualizza_predizione():
    tournamentNames = ['Serie A Tim', 'Premier League', 'LaLiga Santander', 'Ligue 1 Ubereats', 'Bundesliga']
    tournaments = [t.replace(" ", "_").lower() for t in tournamentNames]
    query = f'predict_tournaments_rank({tournaments}, TotalRank)'.replace('\'', '')
    ranking = list(prolog.query(query))[0]['TotalRank']
    while(True):
        cls()
        out = "Digitiare un numero da 1 a 5 per scegliere il campionato di cui visualizzare la previsione della classifica:\n"
        out += "\n".join([f"{i + 1}) {t}" for i, t in enumerate(tournamentNames)]) + "\n0) Indietro\n> "
        scelta = int(input(out))
        if (scelta == 0):
            return
        if (scelta > 0 and scelta <= 5):
            cls()
        rankings = []
        for j, team in enumerate(ranking[scelta - 1][1]):
            teamConverted = team[0].replace("_", " ")
            teamConverted = " ".join([teamC.capitalize() for teamC in teamConverted.lower().split(" ")])    
            rankings.append(f"{j + 1}° {teamConverted}")
        else:
            print()
        paginateOutput(rankings)

### COMPARAZIONE GIOCATORI
def comparePlayers(func: str):
    p1 = input("Dammi il primo giocatore: ")
    p1Converted = p1
    p1Converted = p1Converted.replace(" ", "_")
    p1Converted = p1Converted.lower()
    p2 = input("Dammi il secondo giocatore: ")
    p2Converted = p2
    p2Converted = p2Converted.replace(" ", "_")
    p2Converted = p2Converted.lower()
    p1Converted = p1Converted.replace("\'", "")
    p2Converted = p2Converted.replace("\'", "")
    percs = list(prolog.query(f'{func}({p1Converted}, {p2Converted}, Perc1, Perc2)'))
    print(f'{p1} {percs[0]["Perc1"] * 100:.2f} % - {percs[0]["Perc2"] * 100:.2f} % {p2}')

def visualizza_comparazione():
    possible_choices = {
        'Portieri': 'gk', 
        'Difensori centrali': 'dc', 
        'Terzini': 'fb', 
        'Mediani': 'dm', 
        'Centrali': 'mc', 
        'Trequartisti': 'am', 
        'Punte': 'st', 
        'Ali': 'w',
    }
    cls()
    scelta = input("Scegli il ruolo da confrontare tra questi:\n" + '\n'.join([f'{i + 1}) {choice}' for i, choice in enumerate(possible_choices)]) + "\n0) Indietro\n> ")
    int_scelta = int(scelta)
    if int_scelta in range(1, len(possible_choices.keys()) + 1):
        comparePlayers(f'compare_{list(possible_choices.values())[int_scelta - 1]}')
    elif int_scelta == 0:
        return
    else:
        print('Scelta non valida')
    input('Premi invio per andare avanti')

### PUNTI DEBOLI DELLA SQUADRA
def visualizza_punti_deboli_squadra():
    cls()
    team = input("Inserisci la squadra che vuoi analizzare: ")
    teamConverted = team
    teamConverted = teamConverted.replace(" ", "_")
    teamConverted = teamConverted.lower()
    players = list(prolog.query(f"team_weak_players({teamConverted}, Weaks)"))
    if len(players) == 0:
        print('Nome squadra non valido')
        input('Permere invio per andare avanti')
        return

    players = players[0]['Weaks']

    roles = [
        'Portiere', 
        'Difensore centrale', 
        'Terzino', 
        'Mediano', 
        'Centrale', 
        'Trequartista', 
        'Punta', 
        'Ala',
    ]

    zipped_role = [list(zipped) for zipped in zip(roles, players)]
    already_found = set()
    for i, role in enumerate(zipped_role):
        name = role[1]
        if name in already_found:
            zipped_role[i][1] = 'null'
        else:
            already_found.add(name)
    
    zipped_role = [role for role in zipped_role if role[1] != 'null']

    if len(zipped_role) > 0:
        print('\n'.join([f'{weak_role[0]}: {prettify_string(weak_role[1])}' for weak_role in zipped_role]))
    else:
        print('Punti deboli non trovati')
    input('Premi invio per andare avanti')

def genera_formazione_titolare():
    vincoli = [
        {
            "testo": "Impostare il modulo",
            "valore": None
        },
        {
            "testo": "Impostare il budget",
            "valore": None
        },
        {
            "testo": "Impostare l'età media massima",
            "valore": None
        },
        {
            "testo": "Impostare la nazionalità",
            "valore": None
        },
        {
            "testo": "Impostare numero minimo di giocatori per nazionalità scelta",
            "valore": None
        },
        {
            "testo": "Impostare il numero di anni di contratto minimi",
            "valore": None
        },
        {
            "testo": "Impostare la squadra",
            "valore": None
        },
    ]
    while(True):
        cls()
        out = "Impostare i vincoli per la generazione della formazione titolare: \n"
        for i, v in enumerate(vincoli):
            out += f"{i + 1}) {v['testo']} ({v['valore'] if v['valore'] == None or i != 0 else list(v['valore'].keys())[0]})\n"
        scelta = input(f"{out}8) Effettuare l'operazione\n0) Indietro\n> ")
        if scelta == '0':
            return
        elif scelta == '1':
            cls()
            ruoli_moduli = [
                {'433': ["IdGk", "IdFb1", "IdFb2", "IdDc1", "IdDc2", "IdDm1", "IdMc1", "IdMc2", "IdW1", "IdW2", "IdSt1"]},
                {'442': ["IdGk", "IdFb1", "IdFb2", "IdDc1", "IdDc2", "IdDm1", "IdDm2", "IdW1", "IdW2", "IdSt1", "IdSt2"]},
                {'4231': ["IdGk", "IdFb1", "IdFb2", "IdDc1", "IdDc2", "IdDm1", "IdDm2", "IdW1", "IdW2", "IdAm1", "IdSt1"]},
                {'352': ["IdGk", "IdFb1", "IdFb2", "IdDc1", "IdDc2", "IdDc3", "IdDm1", "IdMc1", "IdMc2", "IdSt1", "IdSt2"]},
                {'343': ["IdGk", "IdFb1", "IdFb2", "IdDc1", "IdDc2", "IdDc3", "IdDm1", "IdDm2", "IdW1", "IdW2", "IdSt1"]}
            ]
            outSceltaModuli = "Selezionare il modulo: \n"
            for i, m in enumerate(ruoli_moduli):
                outSceltaModuli += f"{i + 1}) {list(m.keys())[0]}\n"
            sceltaModulo = int(input(f"{outSceltaModuli}0) Indietro\n> "))
            if sceltaModulo > 0 and sceltaModulo < 6:
                vincoli[0]['valore'] = ruoli_moduli[int(sceltaModulo) - 1]
        elif scelta == '2':
            cls()
            budget = input("Scegliere il budget: ")
            vincoli[1]['valore'] = budget
        elif scelta == '3':
            cls()
            eta = input("Scegliere l'età massima: ")
            vincoli[2]['valore'] = eta
        elif scelta == '4':
            cls()
            nazionalita = input("Scegliere la nazionalità (in inglese, es: france): ")
            vincoli[3]['valore'] = nazionalita.lower()
        elif scelta == '5':
            cls()
            nazionalitaMin = input("Scegliere il numero minimo di giocatori minimo per nazionalità scelta: ")
            vincoli[4]['valore'] = nazionalitaMin
        elif scelta == '6':
            cls()
            contrattoMin = input("Scegliere il numero di anni di contratto minimi: ")
            vincoli[5]['valore'] = contrattoMin
        elif scelta == '7':
            cls()
            squadra = input("Scegliere la squadra: ")
            squadraConvertita = squadra
            squadraConvertita = squadraConvertita.replace(" ", "_")
            squadraConvertita = squadraConvertita.lower()
            vincoli[6]['valore'] = squadraConvertita
        elif scelta == '8':
            query = "("
            queries = []
            for i, v in enumerate(vincoli):
                queries.append(f"\'{list(v['valore'].keys())[0]}\'" if i == 0 else v['valore'])
            query += ", ".join(queries) + ", " + ", ".join(vincoli[0]['valore'][list(vincoli[0]['valore'].keys())[0]]) + ")"
            print("In base ai vincoli scelti, l'operazione potrebbe richiedere alcuni minuti...")
            results = list(prolog.query('calcola_perm_rosa' + query))
            if len(results) > 0:
                results = [r for r in results if len(set(list(r.values()))) == 11]
                n_elem = len(results)
                print("Possibili formazioni trovate con i vincoli scelti: ", n_elem)
                max = sum(list(prolog.query(f'get_all_eval_from_players_list({list(results[i].values())}, ResEvalList)'))[0]['ResEvalList'])
                maxList = [prettify_string(list(prolog.query(f'name({id}, Name)'))[0]['Name']) for id in results[i].values()]
                for i in tqdm.tqdm(range(n_elem - 1)):
                    team = results[i + 1]
                    ids = list(team.values())
                    evalTeam = sum(list(prolog.query(f'get_all_eval_from_players_list({ids}, ResEvalList)'))[0]['ResEvalList'])
                    if evalTeam > max:
                        max = evalTeam
                        maxList = [prettify_string(list(prolog.query(f'name({id}, Name)'))[0]['Name']) for id in ids]
                print(f"11 titolari: {', '.join(maxList)}")
            else:
                print('Nessuna formazione trovata con i vincoli scelti!')
            input('Premi invio per andare avanti')

def testa_a_testa():
    print('Sto allenando il modello per la predizione...')

    df = pd.read_csv('./datasets/dataset_for_ML.csv')
    X = pd.get_dummies(df.drop(['result'], axis=1))
    y = df['result'].apply(lambda x: 2 if x == 'victory' else 1 if x == 'draw' else 0)
    X_train, _, y_train, _ = train_test_split(X, y, test_size=.1)

    hyperparams = {'bootstrap': True, 'max_depth': 110, 'max_features': 2, 'min_samples_leaf': 5, 'min_samples_split': 12, 'n_estimators': 1000}
    selector = SelectKBest(mutual_info_regression, k=87)
    X_new = selector.fit_transform(X_train, y_train)
    cols = selector.get_support(indices=True)
    X_new = X_train.iloc[:,cols]

    rf_final = RandomForestClassifier(**hyperparams)
    rf_final.fit(X_new, y_train)

    team1 = input("Dammi la prima squadra: ")
    team2 = input("Dammi la seconda squadra: ")

    df = pd.read_csv("./datasets/team_statistics.csv")
    features = []
    with open('./datasets/team_features.txt') as f:
        features = [line.replace('\n', '') for line in f.readlines()]
    rowTeam1 = df[df['name'] == prettify_string(team1)].copy()
    rowTeam2 = df[df['name'] == prettify_string(team1)].copy()

    for i, r in enumerate(rowTeam1):
        if i != 0:
            rowTeam1[r] = rowTeam1[r] / rowTeam1['matches']
    for i, r in enumerate(rowTeam2):
        if i != 0:
            rowTeam2[r] = rowTeam2[r] / rowTeam2['matches']

    newColumnsHome = {}
    newColumnsAway = {}
    for f in features:
        newColumnsHome[f] = f'home_{f}'
        newColumnsAway[f] = f'away_{f}'
    rowTeam1 = rowTeam1[features]
    rowTeam1.rename(columns=newColumnsHome, inplace=True)
    rowTeam2 = rowTeam2[features]
    rowTeam2.rename(columns=newColumnsAway, inplace=True)
    test = pd.merge(rowTeam1, rowTeam2, how="cross").iloc[:,cols]

    prediction = rf_final.predict(test)[0]
    print(f"Risultato: {f'vittoria {team1}' if prediction == 2 else 'pareggio' if prediction == 1 else f'vittoria {team2}'}")
    input('Premi invio per andare avanti')

def asserisci_pesi():
    with open("./Prolog/weightsAssertions.pl") as f:
        for line in f:
            prolog.assertz(line.replace("\n", "")[:-1])

def retract_pesi():
    with open("./Prolog/weights_retract.pl") as f:
        for line in f:
            prolog.retractall(line.replace("\n", "")[:-1])

def mainLoop():
    while(True):
        cls()
        scelta = input('''
Digitare un numero per effettuare una delle seguenti operazioni:
1) Visualizzare la classifica dei giocatori di un determinato ruolo
2) Visualizzare i giocatori suggeriti in base alle preferenze selezionate
3) Visualizzare la predizione della classifica di uno dei top cinque campionati europei
4) Confrontare due giocatori dello stesso ruolo
5) Trovare i punti deboli della squadra
6) Generare la formazione titolare di una determinata squadra
7) Predire il risultato di una partita
0) Uscire dall'applicazione
> '''
        )
        try:
            asserisci_pesi()
            if scelta == '0':
                return
            elif scelta == '1':
                visualizza_giocatori()
            elif scelta == '2':
                cls()
                budget = input("Specifica il budget disponibile: (es. 58000000): ")
                modifica_features(budget)
            elif scelta == '3':
                visualizza_predizione()
            elif scelta == '4':
                visualizza_comparazione()
            elif scelta == '5':
                visualizza_punti_deboli_squadra()
            elif scelta == '6':
                genera_formazione_titolare()
            elif scelta == '7':
                testa_a_testa()
            else:
                print('Scelta inserita non valida')
        except:
            print('Scelta inserita non valida')
            input('Premi invio per andare avanti')
        retract_pesi()

if __name__ == '__main__':
    mainLoop()

