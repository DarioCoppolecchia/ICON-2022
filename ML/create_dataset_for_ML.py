import csv
from random import random

features = []
with open('./datasets/team_features.txt') as f:
    features = [line.replace('\n', '') for line in f.readlines()]

teams_stats = {}
with open('./datasets/team_statistics.csv') as f_stats:    
    csvr = csv.DictReader(f_stats)
    for team in csvr:
        teams_stats[team['name']] = []
        for feature in features:
            teams_stats[team['name']].append(float(team[feature]) / float(team['matches']))

stats_per_match = []
with open('./datasets/matches.csv') as f_match:
    csvr = csv.DictReader(f_match)
    for match in csvr:
        h_score = int(match['homeScore'])
        a_score = int(match['awayScore'])
        
        result = 'lose'
        if h_score > a_score: result = 'victory'
        elif h_score == a_score: result = 'draw'

        try:
            stats_per_match.append(teams_stats[match['homeTeam']] + teams_stats[match['awayTeam']] + [result])
        except:
            continue

header_out = ['home_' + f for f in features] + ['away_' + f for f in features] + ['result']

n_rows = 0
with open('./datasets/dataset_for_ML.csv', 'w') as f_out:
    csvw = csv.DictWriter(f_out, header_out, lineterminator='\n')
    for i, match in enumerate(stats_per_match):
        if i == 0:
            csvw.writeheader()
        match_dict = {header_out[i]: m for i, m in enumerate(match)}
        csvw.writerow(match_dict)
        n_rows = i

# dataset for randomforest
with open('./datasets/dataset_for_ML.csv', 'r') as f_NN:
    csvr = csv.DictReader(f_NN)
    with open('./datasets/dataset_for_prediction_train.csv', 'w') as f_train:
        csvw_train = csv.DictWriter(f_train, header_out, lineterminator='\n')
        csvw_train.writeheader()
        with open('./datasets/dataset_for_prediction_test.csv', 'w') as f_test:
            csvw_test = csv.DictWriter(f_test, header_out, lineterminator='\n')
            csvw_test.writeheader()
            max = n_rows * 0.1
            n = max
            test_row = []
            len_list = 0
            while len_list < n:
                n = max - len_list
                test_row += [int(random() * n_rows) for _ in range(int(n))]
                len_list = len(set(test_row))
            i = 0
            count = 0
            for match in csvr:
                if i in test_row:
                    count += 1
                    csvw_test.writerow(match)
                else:
                    csvw_train.writerow(match)
                i += 1
            