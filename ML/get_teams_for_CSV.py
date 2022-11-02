import requests
import json
import csv

with open('../ML/team_statistics.csv', 'w', encoding='utf-8') as f:
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


with open('../ML/team_statistics.csv', 'a', encoding='utf-8') as f:
    for c, tournament in enumerate(tournaments):
        teams = f"https://api.sofascore.com/api/v1/unique-tournament/{tournament['tId']}/season/{tournament['seasonId']}/standings/total"
        res = requests.get(teams)
        parsed = json.loads(res.text)
        teams = parsed['standings'][0]['rows']

        teamUrls = []
        for t in teams:
            teamUrls.append({
                "name": t["team"]["name"],
                "url": f"https://api.sofascore.com/api/v1/team/{t['team']['id']}/unique-tournament/{tournament['tId']}/season/{tournament['seasonId']}/statistics/overall"
            })

        for i, u in enumerate(teamUrls):
            res = requests.get(u["url"])
            data = json.loads(res.text)
            parsedObj = {
                'name': u['name'],
                **data['statistics'],
            }
            del parsedObj['awardedMatches']
            w = csv.DictWriter(f, parsedObj.keys(), lineterminator="\n")
            if c == 0 and i == 0:
                w.writeheader()
            w.writerow(parsedObj)
