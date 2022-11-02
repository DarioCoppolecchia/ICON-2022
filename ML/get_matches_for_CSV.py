import requests
import json
import csv

with open('../ML/matches.csv', 'w', encoding='utf-8') as f:
    pass
with open('../ML/postponed_matches.txt', 'w', encoding='utf-8') as f:
    pass

tournaments = [
    {
        'name':     'Serie A Tim',
        'tId':      '23',
        'seasonId': '37475'
    },
    {
        'name':     'Premier League',
        'tId':      '17',
        'seasonId': '37036'
    },
    {
        'name':     'Bundesliga',
        'tId':      '35',
        'seasonId': '37166'
    },
    {
        'name':     'LaLiga Santander',
        'tId':      '8',
        'seasonId': '37223'
    },
    {
        'name':     'Ligue 1 UberEats',
        'tId':      '34',
        'seasonId': '37167'
    },
    {
        'name':     'Eredivisie',
        'tId':      '37',
        'seasonId': '36890'
    },
    {
        'name':     'Liga Portugal',
        'tId':      '238',
        'seasonId': '37358'
    },
    {
        'name':     'Pro League',
        'tId':      '38',
        'seasonId': '36894'
    },
    {
        'name':     '2. Bundesliga',
        'tId':      '44',
        'seasonId': '37168'
    },
    {
        'name':     'LaLiga 2',
        'tId':      '54',
        'seasonId': '37225'
    },
    {
        'name':     'Championship',
        'tId':      '18',
        'seasonId': '37154'
    },
    {
        'name':     'Serie B',
        'tId':      '53',
        'seasonId': '37642'
    },
    {
        'name':     'Ligue 2',
        'tId':      '182',
        'seasonId': '37169'
    }
]


with open('../ML/matches.csv', 'a', encoding='utf-8') as f:
    for c, tournament in enumerate(tournaments):
        for partition in range(12):
            teams = f"https://api.sofascore.com/api/v1/unique-tournament/{tournament['tId']}/season/{tournament['seasonId']}/events/last/{partition}"
            res = requests.get(teams)
            if res.status_code != 404:
                parsed = json.loads(res.text)
                for i, match in enumerate(parsed['events']):
                    if 'display' not in match['homeScore']:
                        with open('postponed_matches.txt', 'a') as f1:
                            f1.write(f"{match['homeTeam']['name']}-{match['awayTeam']['name']}\n")
                    else:
                        parsedObject = {
                            'homeTeam': match['homeTeam']['name'],
                            'awayTeam': match['awayTeam']['name'],
                            'homeScore': match['homeScore']['current'],
                            'awayScore': match['awayScore']['current']
                        }

                        w = csv.DictWriter(f, parsedObject.keys(), lineterminator="\n")
                        if c == 0 and partition == 0 and i == 0:
                            w.writeheader()
                        w.writerow(parsedObject)
