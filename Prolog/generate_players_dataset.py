import math
import requests
import json
import csv
from bs4 import BeautifulSoup
from datetime import datetime
from time import sleep

with open('player_stats.csv', 'w', encoding='utf-8') as f:
    pass

headers = {
    "authority": "api.sofascore.com",
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
    "accept-language": "en-US,en;q=0.6",
    "cache-control": 'max-age=0',
    "if-none-match": 'W/"3ce452c57a"',
    "sec-fetch-dest": "document",
    "sec-fetch-mode": 'navigate',
    "sec-fetch-site": "none",
    "sec-fetch-user": "?1",
    "sec-gpc": "1",
    "Referer": "https://www.sofascore.com/",
    "upgrade-insecure-requests": "1",
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36"
}

tournaments = [
    {
        'name':     'Serie A Tim',
        'tId':      '23',
        'seasonId': '42415',
        'prevSeasonId': '37475'
    },
    {
        'name':     'Premier League',
        'tId':      '17',
        'seasonId': '41886',
        'prevSeasonId': '37036'
    },
    {
        'name':     'Bundesliga',
        'tId':      '35',
        'seasonId': '42268',
        'prevSeasonId': '37166'
    },
    {
        'name':     'LaLiga Santander',
        'tId':      '8',
        'seasonId': '42409',
        'prevSeasonId': '37223'
    },
    {
        'name':     'Ligue 1 UberEats',
        'tId':      '34',
        'seasonId': '42273',
        'prevSeasonId': '37167'
    }
]

for c, tournament in enumerate(tournaments):
    teams = f"https://api.sofascore.com/api/v1/unique-tournament/{tournament['tId']}/season/{tournament['seasonId']}/standings/total"
    res = requests.get(teams, headers=headers)
    parsed = json.loads(res.text)
    teams = parsed['standings'][0]['rows']

    teamUrls = []
    for t in teams:
        teamUrls.append(f"https://www.sofascore.com/team/football/{t['team']['slug']}/{t['team']['id']}")

    for i, u in enumerate(teamUrls):
        res = requests.get(u, headers=headers)
        soup = BeautifulSoup(res.text,'html.parser')

        data = soup.findAll('script', id='__NEXT_DATA__')
        data = json.loads(data[0].text)
        players = data['props']['initialProps']['pageProps']['players']['players']
        teamName = data['props']['initialProps']['pageProps']['teamDetails']['name']
        print(f"Extracting info about {teamName} players...")
        for j, p in enumerate(players):
            player_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/unique-tournament/{tournament['tId']}/season/{tournament['prevSeasonId']}/statistics/overall"
            res = requests.get(player_url, headers=headers)
            playerStat = json.loads(res.text)
            res = requests.get(f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/last-year-summary", headers=headers)
            playerStat['missedForInjuries'] = len([x for x in res.json()['summary'] if x['type'] == 'missing'])
            if "error" in playerStat:
                player_season_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/statistics/seasons"
                res = requests.get(player_season_url, headers=headers)
                seasons = json.loads(res.text)
                if "error" not in seasons:
                    tPlayed = []
                    for t in seasons['uniqueTournamentSeasons']:
                        for s in t['seasons']:
                            if s['year'] == '21/22':
                                tPlayed.append({'name': t['uniqueTournament']['name'], 'country': t['uniqueTournament']['category']['name'], 'tId': t['uniqueTournament']['id'], 'sId': s['id']})
                    if len(tPlayed) > 1:
                        for k, t in enumerate(tPlayed):
                            player_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/unique-tournament/{t['tId']}/season/{t['sId']}/statistics/overall"
                            res = requests.get(player_url, headers=headers)
                            playerStatSeason = json.loads(res.text)
                            tPlayed[k]['appearances'] = playerStatSeason['statistics']['appearances']
                        tPlayed = sorted(tPlayed, key=lambda d: d['appearances'])
                        player_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/unique-tournament/{tPlayed[-1]['tId']}/season/{tPlayed[-1]['sId']}/statistics/overall"
                        res = requests.get(player_url, headers=headers)
                        playerStat = json.loads(res.text)
                        res = requests.get(f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/last-year-summary", headers=headers)
                        playerStat['missedForInjuries'] = len([x for x in res.json()['summary'] if x['type'] == 'missing'])
                    elif len(tPlayed) == 1:
                        player_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/unique-tournament/{tPlayed[0]['tId']}/season/{tPlayed[0]['sId']}/statistics/overall"
                        res = requests.get(player_url, headers=headers)
                        playerStat = json.loads(res.text)
                        res = requests.get(f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/last-year-summary", headers=headers)
                        playerStat['missedForInjuries'] = len([x for x in res.json()['summary'] if x['type'] == 'missing'])
            else:
                player_season_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/statistics/seasons"
                res = requests.get(player_season_url, headers=headers)
                seasons = json.loads(res.text)
                if "error" not in seasons:
                    tPlayed = []
                    for t in seasons['uniqueTournamentSeasons']:
                        for s in t['seasons']:
                            if s['year'] == '21/22':
                                tPlayed.append({'name': t['uniqueTournament']['name'], 'country': t['uniqueTournament']['category']['name'], 'tId': t['uniqueTournament']['id'], 'sId': s['id']})
                    if len(tPlayed) > 1:
                        for k, t in enumerate(tPlayed):
                            player_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/unique-tournament/{t['tId']}/season/{t['sId']}/statistics/overall"
                            res = requests.get(player_url, headers=headers)
                            playerStatSeason = json.loads(res.text)
                            tPlayed[k]['appearances'] = playerStatSeason['statistics']['appearances']
                        tPlayed = sorted(tPlayed, key=lambda d: d['appearances'])
            if 'preferredFoot' in p['player'] and 'height' in p['player'] and 'position' in p['player'] and 'position' in p['player'] and 'country' in p['player'] and "error" not in playerStat:
                pl_char_url = f"https://api.sofascore.com/api/v1/player/{p['player']['id']}/characteristics"
                res = requests.get(pl_char_url, headers=headers)
                plChars = json.loads(res.text)
                if len(plChars['positions']) > 0:
                    parsedObj = {
                        'name': p['player']['name'],
                        'team': teamName,
                        'competition': tournament['name'],
                        'age': int((datetime.now() - datetime.fromtimestamp(p['player']['dateOfBirthTimestamp'])).days / 365),
                        'preferredFoot': p['player']['preferredFoot'],
                        'height': p['player']['height'],
                        'role': p['player']['position'],
                        'mainPosition': plChars['positions'][0],
                        'secondPosition': plChars['positions'][1] if len(plChars['positions']) > 1 else 'None',
                        'country': p['player']['country']['name'],
                        'lastSeasonTournament': tPlayed[-1]['name'],
                        'lastSeasonTournamentCountry': tPlayed[-1]['country'],
                        **playerStat['statistics'],
                        'marketValue': p['player']['proposedMarketValue'] if 'proposedMarketValue' in p['player'] else 0,
                        'contractYearsLeft': int(math.ceil((datetime.fromtimestamp(p['player']['contractUntilTimestamp']) - datetime(2022, 6, 30, 23, 59, 59, 999999)).days / 365) if 'contractUntilTimestamp' in p['player'] else 2),
                        'missedForInjuries': playerStat['missedForInjuries']
                    }
                    if len(playerStat['statistics'].keys()) > 104:
                        if 'totalRating' in parsedObj: del parsedObj['totalRating']
                        if 'countRating' in parsedObj: del parsedObj['countRating']
                        if 'totalPasses' in parsedObj: del parsedObj['totalPasses']
                        if 'punches' in parsedObj: del parsedObj['punches']
                        if 'runsOut' in parsedObj: del parsedObj['runsOut']
                        if 'successfulRunsOut' in parsedObj: del parsedObj['successfulRunsOut']
                        if 'highClaims' in parsedObj: del parsedObj['highClaims']
                        if 'crossesNotClaimed' in parsedObj: del parsedObj['crossesNotClaimed']
                        if 'totwAppearances' in parsedObj: del parsedObj['totwAppearances']
                        if 'type' in parsedObj: del parsedObj['type']
                        if 'id' in parsedObj: del parsedObj['id']
                        if 'assists' not in parsedObj: 
                            app = parsedObj['appearances']
                            mv = parsedObj['marketValue']
                            cyl = parsedObj['contractYearsLeft']
                            mInj = parsedObj['missedForInjuries']
                            del parsedObj['appearances']
                            del parsedObj['marketValue']
                            del parsedObj['contractYearsLeft']
                            del parsedObj['missedForInjuries']
                            parsedObj['assists'] = 0
                            parsedObj['appearances'] = app
                            parsedObj['marketValue'] = mv
                            parsedObj['contractYearsLeft'] = cyl
                            parsedObj['missedForInjuries'] = mInj
                        for k, v in parsedObj.items():
                            if isinstance(v, str):
                                parsedObj[k] = parsedObj[k].replace(',', '')
                        with open('player_stats.csv', 'a', encoding='utf-8') as f:
                            w = csv.DictWriter(f, parsedObj.keys(), lineterminator="\n")
                            if c == 0 and i == 0 and j == 0:
                                w.writeheader()
                            w.writerow(parsedObj)
                            print(f"{p['player']['name']} added!")
                            sleep(3)