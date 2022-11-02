from unittest import result
import pandas as pd
import itertools
from pgmpy.models import BayesianNetwork
from pgmpy.factors.discrete import TabularCPD
from pgmpy.inference.ExactInference import VariableElimination
from string import ascii_uppercase
from pandas import DataFrame

# Gathering data

nodes = [
    "home_goalsScored",
    "home_goalsConceded",
    "home_shots",
    "home_bigChances",
    "home_successfulDribbles",
    "home_accurateOppositionHalfPasses",
    "home_accurateCrosses",
    "home_errorsLeadingToShot",
    "home_possessionLost",
    "home_redCards",
    "away_goalsScored",
    "away_goalsConceded",
    "away_shots",
    "away_bigChances",
    "away_successfulDribbles",
    "away_accurateOppositionHalfPasses",
    "away_accurateCrosses",
    "away_errorsLeadingToShot",
    "away_possessionLost",
    "away_redCards",
    "result",
]
df = pd.read_csv("./datasets/dataset_for_ML.csv", usecols=nodes)

# apply discretization
N_BINS = 3

def equal_width(values, n_bins):
    min_val = min(values)
    max_val = max(values)
    interval_width = (max_val - min_val) / n_bins
    intervals = [min_val + interval_width * i for i in range(n_bins + 1)]
    return intervals


def count_per_interval(values, intervals):
    n_bins = len(intervals) - 1
    count_arr = [0 for _ in range(n_bins)]
    for j, val in enumerate(values):
        for i in range(n_bins):
            if intervals[i] <= val <= intervals[i + 1]:
                count_arr[i] += 1
                break
        else:
            print(j, val)
    return count_arr


def get_index_of_count(val: float, intervals: list) -> int:
    for i in range(len(intervals) - 1):
        if intervals[i] <= val <= intervals[i + 1]:
            return ascii_uppercase[i]


def create_dataframe(nodes: list, df: DataFrame, n_bins: int) -> dict:
    dataframe = {}
    for col in nodes[:-1]:
        values = df[col]
        intervals = equal_width(values, n_bins)
        dataframe[col] = [get_index_of_count(value, intervals) for value in values]
    return dataframe

def val_counter(cols: str, data: DataFrame) -> dict:
    val_count = {ascii_uppercase[i]: 0 for i in range(0, N_BINS)}
    for val in data[cols]:
        val_count[val] += 1
    return val_count

def multi_val_counter(cols: list, indexMatrix: str, data: DataFrame) -> int:
    val_count = 0
    for v in data.iloc:
        for i, c in enumerate(cols):
            if v[c] != indexMatrix[i]:
                break
        else:
            val_count += 1            
    return val_count

def generate_tuples(cols: list, indexLen: int):
    tup = [chr(ord("A") + c) for c in range(indexLen)]
    return [p for p in itertools.product(tup, repeat=len(cols))]
    
def calc_matrix_with_cols(cols: list, indexes: str):
    matrix = [[] for _ in range(len(indexes))]
    t = generate_tuples(cols, len(indexes))
    for i, index in enumerate(indexes):
        part = [p for p in t if p[0] == index]
        for p in part:
            matrix[i].append(multi_val_counter(cols, "".join(p), data))
    matrix_sum = []
    N_ROWS = len(matrix)
    for i in range(len(matrix[0])):
        sum_col = 0
        for j in range(N_ROWS):
            sum_col += matrix[j][i]
        matrix_sum.append(sum_col)
    for i, s in enumerate(matrix_sum):
        if s == 0:
            perc_temp = 1 / N_ROWS
            for j in range(len(matrix)):
                matrix[j][i] = perc_temp
        else:
            for j in range(len(matrix)):
                matrix[j][i] /= s
    return matrix

new_column = create_dataframe(nodes, df, N_BINS)
data = DataFrame(data=new_column)
results = {
    "victory": "A",
    "draw": "B",
    "lose": "C"
}
data["result"] = [results[r] for r in df["result"]]

# Setting the model

# set the structure
model = BayesianNetwork(
    [
        ("home_goalsConceded", "result"),
        ("home_goalsScored", "result"),
        ("home_bigChances", "home_goalsScored"),
        ("home_shots", "home_goalsScored"),
        ('home_successfulDribbles', 'home_bigChances'),
        ('home_accurateOppositionHalfPasses', 'home_shots'),
        ('home_accurateCrosses', 'home_shots'),
        ("home_redCards", "home_goalsConceded"),
        ('home_possessionLost', 'home_goalsConceded'),
        ("home_errorsLeadingToShot", "home_goalsConceded"),
        ("away_goalsConceded", "result"),
        ("away_goalsScored", "result"),
        ("away_bigChances", "away_goalsScored"),
        ("away_shots", "away_goalsScored"),
        ('away_successfulDribbles', 'away_bigChances'),
        ("away_errorsLeadingToShot", "away_goalsConceded"),
        ('away_accurateOppositionHalfPasses', 'away_shots'),
        ("away_redCards", "away_goalsConceded"),
        ('away_possessionLost', 'away_goalsConceded'),
        ('away_accurateCrosses', 'away_shots'),
    ]
)

total = len(df['result'])
features_count = {node: val_counter(node, data) for node in nodes[:-1]}

##################################### home

print('TabularCPD home_possessionLost')
home_possessionLost_cpd = TabularCPD(
    variable="home_possessionLost",
    variable_card=N_BINS,
    values=[
        [features_count['home_possessionLost']['A'] / total],  # A
        [features_count['home_possessionLost']['B'] / total],  # B
        [features_count['home_possessionLost']['C'] / total],  # C
    ],
)

print('TabularCPD home_accurateCrosses')
home_accurateCrosses_cpd = TabularCPD(
    variable="home_accurateCrosses",
    variable_card=N_BINS,
    values=[
        [features_count['home_accurateCrosses']['A'] / total],  # A
        [features_count['home_accurateCrosses']['B'] / total],  # B
        [features_count['home_accurateCrosses']['C'] / total],  # C
    ],
)

print('TabularCPD home_accurateOppositionHalfPasses')
home_accurateOppositionHalfPasses_cpd = TabularCPD(
    variable="home_accurateOppositionHalfPasses",
    variable_card=N_BINS,
    values=[
        [features_count['home_accurateOppositionHalfPasses']['A'] / total],  # A
        [features_count['home_accurateOppositionHalfPasses']['B'] / total],  # B
        [features_count['home_accurateOppositionHalfPasses']['C'] / total],  # C
    ],
)

print('TabularCPD home_successfulDribbles')
home_successfulDribbles_cpd = TabularCPD(
    variable="home_successfulDribbles",
    variable_card=N_BINS,
    values=[
        [features_count['home_successfulDribbles']['A'] / total],  # A
        [features_count['home_successfulDribbles']['B'] / total],  # B
        [features_count['home_successfulDribbles']['C'] / total],  # C
    ],
)

print('TabularCPD home_redCards')
home_redCards_cpd = TabularCPD(
    variable="home_redCards",
    variable_card=N_BINS,
    values=[
        [features_count['home_redCards']['A'] / total],  # A: 0.0, 0.1081081081081081
        [features_count['home_redCards']['B'] / total],  # B: 0.1081081081081081, 0.2162162162162162
        [features_count['home_redCards']['C'] / total],  # C: 0.2162162162162162, 0.3243243243243243
    ],
)
print('TabularCPD home_errorsLeadingToShot')
home_errorsLeadingToShot_cpd = TabularCPD(
    variable="home_errorsLeadingToShot",
    variable_card=N_BINS,
    values=[
        [features_count['home_errorsLeadingToShot']['A'] / total],  # A: 0.0, 0.14705882352941177
        [features_count['home_errorsLeadingToShot']['B'] / total],  # B: 0.14705882352941177, 0.29411764705882354
        [features_count['home_errorsLeadingToShot']['C'] / total],  # C: 0.29411764705882354, 0.4411764705882353
    ],
)
print('TabularCPD home_shots')
home_shots_cpd = TabularCPD(
    variable="home_shots",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["home_bigChances", "home_accurateCrosses", "home_accurateOppositionHalfPasses"], 'ABC'),
    evidence=["home_accurateCrosses", "home_accurateOppositionHalfPasses"],
    evidence_card=[N_BINS, N_BINS],
)
print('TabularCPD home_bigChances')
home_bigChances_cpd = TabularCPD(
    variable="home_bigChances",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["home_bigChances", "home_successfulDribbles"], 'ABC'),
    evidence=["home_successfulDribbles"],
    evidence_card=[N_BINS],
)

print('TabularCPD home_goalsScored')
home_goalsScored_cpd = TabularCPD(
    variable="home_goalsScored",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["home_goalsScored", "home_bigChances", "home_shots"], 'ABC'),
    evidence=["home_bigChances", "home_shots"],
    evidence_card=[N_BINS, N_BINS],
)
print('TabularCPD home_goalsConceded')
home_goalsConceded_cpd = TabularCPD(
    variable="home_goalsConceded",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["home_goalsConceded", "home_redCards", "home_errorsLeadingToShot", "home_possessionLost"], 'ABC'),
    evidence=["home_redCards", "home_errorsLeadingToShot", "home_possessionLost"],
    evidence_card=[N_BINS, N_BINS, N_BINS],
)

##################################### away

print('TabularCPD away_possessionLost')
away_possessionLost_cpd = TabularCPD(
    variable="away_possessionLost",
    variable_card=N_BINS,
    values=[
        [features_count['away_possessionLost']['A'] / total],  # A:
        [features_count['away_possessionLost']['B'] / total],  # B:
        [features_count['away_possessionLost']['C'] / total],  # C:
    ],
)

print('TabularCPD away_accurateCrosses')
away_accurateCrosses_cpd = TabularCPD(
    variable="away_accurateCrosses",
    variable_card=N_BINS,
    values=[
        [features_count['away_accurateCrosses']['A'] / total],  # A:
        [features_count['away_accurateCrosses']['B'] / total],  # B:
        [features_count['away_accurateCrosses']['C'] / total],  # C:
    ],
)

print('TabularCPD away_accurateOppositionHalfPasses')
away_accurateOppositionHalfPasses_cpd = TabularCPD(
    variable="away_accurateOppositionHalfPasses",
    variable_card=N_BINS,
    values=[
        [features_count['away_accurateOppositionHalfPasses']['A'] / total],  # A:
        [features_count['away_accurateOppositionHalfPasses']['B'] / total],  # B:
        [features_count['away_accurateOppositionHalfPasses']['C'] / total],  # C:
    ],
)

print('TabularCPD away_successfulDribbles')
away_successfulDribbles_cpd = TabularCPD(
    variable="away_successfulDribbles",
    variable_card=N_BINS,
    values=[
        [features_count['away_successfulDribbles']['A'] / total],  # A:
        [features_count['away_successfulDribbles']['B'] / total],  # B:
        [features_count['away_successfulDribbles']['C'] / total],  # C:
    ],
)

print('TabularCPD away_redCards')
away_redCards_cpd = TabularCPD(
    variable="away_redCards",
    variable_card=N_BINS,
    values=[
        [features_count['away_redCards']['A'] / total],  # A: 0.0, 0.1081081081081081
        [features_count['away_redCards']['B'] / total],  # B: 0.1081081081081081, 0.2162162162162162
        [features_count['away_redCards']['C'] / total],  # C: 0.2162162162162162, 0.3243243243243243
    ],
)
print('TabularCPD away_errorsLeadingToShot')
away_errorsLeadingToShot_cpd = TabularCPD(
    variable="away_errorsLeadingToShot",
    variable_card=N_BINS,
    values=[
        [features_count['away_errorsLeadingToShot']['A'] / total],  # A: 0.0, 0.14705882352941177
        [features_count['away_errorsLeadingToShot']['B'] / total],  # B: 0.14705882352941177, 0.29411764705882354
        [features_count['away_errorsLeadingToShot']['C'] / total],  # C: 0.29411764705882354, 0.4411764705882353
    ],
)
print('TabularCPD away_shots')
away_shots_cpd = TabularCPD(
    variable="away_shots",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["away_shots", "away_accurateCrosses", "away_accurateOppositionHalfPasses"], 'ABC'),
    evidence=["away_accurateCrosses", "away_accurateOppositionHalfPasses"],
    evidence_card=[N_BINS, N_BINS],
)
print('TabularCPD away_bigChances')
away_bigChances_cpd = TabularCPD(
    variable="away_bigChances",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["away_bigChances", "away_successfulDribbles"], 'ABC'),
    evidence=["away_successfulDribbles"],
    evidence_card=[N_BINS],
)
print('TabularCPD away_goalsScored')
away_goalsScored_cpd = TabularCPD(
    variable="away_goalsScored",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["away_goalsScored", "away_bigChances", "away_shots"], 'ABC'),
    evidence=["away_bigChances", "away_shots"],
    evidence_card=[N_BINS, N_BINS],
)
print('TabularCPD away_goalsConceded')
away_goalsConceded_cpd = TabularCPD(
    variable="away_goalsConceded",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["away_goalsConceded", "away_redCards", "away_errorsLeadingToShot", "away_possessionLost"], 'ABC'),
    evidence=["away_redCards", "away_errorsLeadingToShot", "away_possessionLost"],
    evidence_card=[N_BINS, N_BINS, N_BINS],
)

#################### result
print('TabularCPD result')
result_cpd = TabularCPD(
    variable="result",
    variable_card=N_BINS,
    values=calc_matrix_with_cols(["result", "home_goalsScored", "home_goalsConceded", "away_goalsScored", "away_goalsConceded"], 'ABC'),
    evidence=[
        "home_goalsScored",
        "home_goalsConceded",
        "away_goalsScored",
        "away_goalsConceded",
    ],
    evidence_card=[3, 3, 3, 3],
)

print('Adding cpds')
#################### aggiungo CPD
model.add_cpds(
    home_possessionLost_cpd,
    home_accurateCrosses_cpd,
    home_accurateOppositionHalfPasses_cpd,
    home_successfulDribbles_cpd,
    home_redCards_cpd,
    home_errorsLeadingToShot_cpd,
    home_shots_cpd,
    home_bigChances_cpd,
    home_goalsScored_cpd,
    home_goalsConceded_cpd,
    away_possessionLost_cpd,
    away_accurateCrosses_cpd,
    away_accurateOppositionHalfPasses_cpd,
    away_successfulDribbles_cpd,
    away_redCards_cpd,
    away_errorsLeadingToShot_cpd,
    away_shots_cpd,
    away_bigChances_cpd,
    away_goalsScored_cpd,
    away_goalsConceded_cpd,
    result_cpd,
)
#
# print(model.get_cpds())
#
# print(model.active_trail_nodes('away_redCards'))
# print(model.active_trail_nodes('away_errorsLeadingToShot'))
# print(model.active_trail_nodes('away_shots'))
# print(model.active_trail_nodes('away_bigChances'))
#
# print(model.local_independencies('away_goalsScored'))
# print(model.local_independencies('away_goalsConceded'))
#
# print(model.active_trail_nodes('away_redCards'))
# print(model.active_trail_nodes('away_errorsLeadingToShot'))
# print(model.active_trail_nodes('away_shots'))
# print(model.active_trail_nodes('away_bigChances'))
#
# print(model.local_independencies('away_goalsScored'))
# print(model.local_independencies('away_goalsConceded'))
#
# print(model.get_independencies())
#
# from pgmpy.estimators import BayesianEstimator
# est = BayesianEstimator(model, data)
#
# print(est.estimate_cpd('result', prior_type='BDeu', equivalent_sample_size=10))

print('calculating inference')
inference = VariableElimination(model)
#prob = inference.query(variables=["result"])
#print(prob)

max_n = 10
correct = 0
import numpy as np
import tqdm
for i, r in enumerate(tqdm.tqdm(data.iloc)):
    if i > max_n:
        break
    obj = {**r}
    corr_dict = {
        'A': 0,
        'B': 1,
        'C': 2,
    }
    expected_result = df.iloc[i]['result']
    del obj['result']
    obj = {k: corr_dict[v] for k, v in obj.items()}
    prob = inference.query(variables=["result"], evidence=obj, show_progress=False)
    str_int = {
        'victory': 0,
        'draw': 1,
        'lose': 2,
    }
    
    print(f'expected_result: {expected_result}, {np.argmax(prob)},\nactual_result: {prob}')
    if np.argmax(prob) == str_int[expected_result]:
        correct += 1

print(f"Accuracy: {correct / i}")
