import csv

t = []

with open("../datasets/player_stats.csv", "r", encoding="utf-8") as f:
    r = csv.DictReader(f)
    for row in r:
        tournament = f"{row['lastSeasonTournament']},{row['lastSeasonTournamentCountry']}"
        if tournament not in t:
            t.append(tournament)
with open('unique_tournaments.txt', "w", encoding="utf-8") as f:
    for tournament in t:
        f.write(f"{tournament}\n")