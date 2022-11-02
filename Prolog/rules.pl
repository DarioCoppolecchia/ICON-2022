handleDivisionByZero(X1, X2, Y) :-
    X2 > 0,
    Y is X1 / X2.
handleDivisionByZero(X1, X2, Y) :-
    X2 < 0,
    Y is X1 / X2.
handleDivisionByZero(_, X2, Y) :-
    X2 = 0,
    Y is 0.

calc_max([], R, R). %end
calc_max([X|Xs], WK, R):- X >  WK, calc_max(Xs, X, R). %WK is Carry about
calc_max([X|Xs], WK, R):- X =< WK, calc_max(Xs, WK, R).
calc_max([X|Xs], R):- calc_max(Xs, X, R). %start

%%%%%%%% POSITIONS

is_goal_keeper(Id) :- role(Id, g).

is_defender_central(Id) :- mainPosition(Id, dc).

is_fullback(Id) :- mainPosition(Id, dr).
is_fullback(Id) :- mainPosition(Id, dl).
is_fullback(Id) :- mainPosition(Id, mr), secondPosition(Id, none).
is_fullback(Id) :- mainPosition(Id, ml), secondPosition(Id, none).
is_fullback(Id) :- secondPosition(Id, ml), mainPosition(Id, mr).
is_fullback(Id) :- secondPosition(Id, mr), mainPosition(Id, ml).
is_fullback(Id) :- secondPosition(Id, dr), mainPosition(Id, mr).
is_fullback(Id) :- secondPosition(Id, dl), mainPosition(Id, ml).
is_fullback(Id) :- secondPosition(Id, dr), mainPosition(Id, ml).

is_dm(Id) :- mainPosition(Id, dm).
is_dm(Id) :- secondPosition(Id, dm),  mainPosition(Id, mc).
is_dm(Id) :- secondPosition(Id, dc),  mainPosition(Id, mc).

is_mc(Id) :- mainPosition(Id, mc), \+secondPosition(Id, dc).
is_mc(Id) :- secondPosition(Id, mc), mainPosition(Id, am).
is_mc(Id) :- secondPosition(Id, mc), mainPosition(Id, ml).
is_mc(Id) :- secondPosition(Id, mc), mainPosition(Id, mr).

is_am(Id) :- mainPosition(Id, am), \+secondPosition(Id, ml), \+secondPosition(Id, mr).
is_am(Id) :- secondPosition(Id, am), mainPosition(Id, mc).
is_am(Id) :- secondPosition(Id, mc), mainPosition(Id, st).
is_am(Id) :- secondPosition(Id, mr), mainPosition(Id, am).
is_am(Id) :- secondPosition(Id, ml), mainPosition(Id, am).

is_st(Id) :- mainPosition(Id, st), \+secondPosition(Id, mc), \+secondPosition(Id, ml), \+secondPosition(Id, mr).

is_w(Id) :- mainPosition(Id, rw).
is_w(Id) :- mainPosition(Id, lw).
is_w(Id) :- mainPosition(Id, ml), \+secondPosition(Id, mc), \+secondPosition(Id, dc), \+secondPosition(Id, dl), \+secondPosition(Id, dr), \+secondPosition(Id, mr), \+secondPosition(Id, none).
is_w(Id) :- mainPosition(Id, mr), \+secondPosition(Id, mc), \+secondPosition(Id, dc), \+secondPosition(Id, dl), \+secondPosition(Id, dr), \+secondPosition(Id, ml), \+secondPosition(Id, none).
is_w(Id) :- mainPosition(Id, st), \+secondPosition(Id, am), \+secondPosition(Id, mc), \+secondPosition(Id, none).

%%%%%%%%%%% FEATURES GATHERER

get_all_rating([], []).
get_all_rating([H | T], Res_list) :-
    rating(H, Res),
    get_all_rating(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_redCards([], []).
get_all_redCards([H | T], Res_list) :-
    redCards(H, Res),
    get_all_redCards(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_penaltyConceded([], []).
get_all_penaltyConceded([H | T], Res_list) :-
    penaltyConceded(H, Res),
    get_all_penaltyConceded(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_ownGoals([], []).
get_all_ownGoals([H | T], Res_list) :-
    ownGoals(H, Res),
    get_all_ownGoals(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_errorLeadToGoal([], []).
get_all_errorLeadToGoal([H | T], Res_list) :-
    errorLeadToGoal(H, Res),
    get_all_errorLeadToGoal(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_saves([], []).
get_all_saves([H | T], Res_list) :-
    saves(H, Res),
    get_all_saves(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_cleanSheet([], []).
get_all_cleanSheet([H | T], Res_list) :-
    cleanSheet(H, Res),
    get_all_cleanSheet(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_savedShotsFromInsideTheBox([], []).
get_all_savedShotsFromInsideTheBox([H | T], Res_list) :-
    savedShotsFromInsideTheBox(H, Res),
    get_all_savedShotsFromInsideTheBox(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_savedShotsFromOutsideTheBox([], []).
get_all_savedShotsFromOutsideTheBox([H | T], Res_list) :-
    savedShotsFromOutsideTheBox(H, Res),
    get_all_savedShotsFromOutsideTheBox(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_goalsConcededInsideTheBox([], []).
get_all_goalsConcededInsideTheBox([H | T], Res_list) :-
    goalsConcededInsideTheBox(H, Res),
    get_all_goalsConcededInsideTheBox(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_goalsConcededOutsideTheBox([], []).
get_all_goalsConcededOutsideTheBox([H | T], Res_list) :-
    goalsConcededOutsideTheBox(H, Res),
    get_all_goalsConcededOutsideTheBox(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_goalsConceded([], []).
get_all_goalsConceded([H | T], Res_list) :-
    goalsConceded(H, Res),
    get_all_goalsConceded(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_minutesPlayed([], []).
get_all_minutesPlayed([H | T], Res_list) :-
    minutesPlayed(H, Res),
    get_all_minutesPlayed(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_age([], []).
get_all_age([H | T], Res_list) :-
    age(H, Res),
    get_all_age(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_height([], []).
get_all_height([H | T], Res_list) :-
    height(H, Res),
    get_all_height(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_penaltySaves([], []).
get_all_penaltySaves([H | T], Res_list) :-
    penaltySave(H, Res),
    get_all_penaltySaves(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_goals([], []).
get_all_goals([H | T], Res_list) :-
    goals(H, Res),
    get_all_goals(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_interceptions([], []).
get_all_interceptions([H | T], Res_list) :-
    interceptions(H, Res),
    get_all_interceptions(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_yellowCards([], []).
get_all_yellowCards([H | T], Res_list) :-
    yellowCards(H, Res),
    get_all_yellowCards(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_groundDuelsWonPercentage([], []).
get_all_groundDuelsWonPercentage([H | T], Res_list) :-
    groundDuelsWonPercentage(H, Res),
    get_all_groundDuelsWonPercentage(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_aerialDuelsWonPercentage([], []).
get_all_aerialDuelsWonPercentage([H | T], Res_list) :-
    aerialDuelsWonPercentage(H, Res),
    get_all_aerialDuelsWonPercentage(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_clearances([], []).
get_all_clearances([H | T], Res_list) :-
    clearances(H, Res),
    get_all_clearances(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_dispossessed([], []).
get_all_dispossessed([H | T], Res_list) :-
    dispossessed(H, Res),
    get_all_dispossessed(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_possessionLost([], []).
get_all_possessionLost([H | T], Res_list) :-
    possessionLost(H, Res),
    get_all_possessionLost(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_fouls([], []).
get_all_fouls([H | T], Res_list) :-
    fouls(H, Res),
    get_all_fouls(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_dribbledPast([], []).
get_all_dribbledPast([H | T], Res_list) :-
    dribbledPast(H, Res),
    get_all_dribbledPast(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_errorLeadToShot([], []).
get_all_errorLeadToShot([H | T], Res_list) :-
    errorLeadToShot(H, Res),
    get_all_errorLeadToShot(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_blockedShots([], []).
get_all_blockedShots([H | T], Res_list) :-
    blockedShots(H, Res),
    get_all_blockedShots(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_bigChancesCreated([], []).
get_all_bigChancesCreated([H | T], Res_list) :-
    bigChancesCreated(H, Res),
    get_all_bigChancesCreated(T, Res_down),
    append([Res], Res_down, Res_list).
    
get_all_accurateFinalThirdPasses([], []).
get_all_accurateFinalThirdPasses([H | T], Res_list) :-
    accurateFinalThirdPasses(H, Res),
    get_all_accurateFinalThirdPasses(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_keyPasses([], []).
get_all_keyPasses([H | T], Res_list) :-
    keyPasses(H, Res),
    get_all_keyPasses(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_penaltyWon([], []).
get_all_penaltyWon([H | T], Res_list) :-
    penaltyWon(H, Res),
    get_all_penaltyWon(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_possessionWonAttThird([], []).
get_all_possessionWonAttThird([H | T], Res_list) :-
    possessionWonAttThird(H, Res),
    get_all_possessionWonAttThird(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_wasFouled([], []).
get_all_wasFouled([H | T], Res_list) :-
    wasFouled(H, Res),
    get_all_wasFouled(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_assists([], []).
get_all_assists([H | T], Res_list) :-
    assists(H, Res),
    get_all_assists(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_passToAssist([], []).
get_all_passToAssist([H | T], Res_list) :-
    passToAssist(H, Res),
    get_all_passToAssist(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_penaltyConversion([], []).
get_all_penaltyConversion([H | T], Res_list) :-
    penaltyConversion(H, Res),
    get_all_penaltyConversion(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_successfulDribbles([], []).
get_all_successfulDribbles([H | T], Res_list) :-
    successfulDribbles(H, Res),
    get_all_successfulDribbles(T, Res_down),
    append([Res], Res_down, Res_list).

get_all_bigChancesMissed([], []).
get_all_bigChancesMissed([H | T], Res_list) :-
    bigChancesMissed(H, Res),
    get_all_bigChancesMissed(T, Res_down),
    append([Res], Res_down, Res_list).


% Max =.. [Max_Qualcosa], Max assumerà il valore della lista di elementi, in questo caso
% un solo elemento che è il valore contenuto in Max_Qualcosa
% fattibile tramite l'operatore "=.. List"

calc_and_assert_max_attr() :-

    % GK
    findall(Player, is_goal_keeper(Player), Players_gk),

    get_all_age(Players_gk, Age_list_gk),
    get_all_height(Players_gk, Height_list_gk),
    get_all_minutesPlayed(Players_gk, MinutesPlayed_list_gk),
    get_all_rating(Players_gk, Rating_list_gk),
    get_all_redCards(Players_gk, RedCards_list_gk),
    get_all_penaltyConceded(Players_gk, PenaltyConceded_list_gk),
    get_all_ownGoals(Players_gk, OwnGoals_list_gk),
    get_all_errorLeadToGoal(Players_gk, ErrorLeadToGoal_list_gk),
    get_all_cleanSheet(Players_gk, CleanSheet_list_gk),
    get_all_goalsConcededInsideTheBox(Players_gk, GoalsConcededInsideTheBox_list_gk),
    get_all_goalsConcededOutsideTheBox(Players_gk, GoalsConcededOutsideTheBox_list_gk),
    get_all_goalsConceded(Players_gk, GoalsConceded_list_gk),

    calc_max(Age_list_gk, Max_age_gk),
    calc_max(Height_list_gk, Max_height_gk),
    calc_max(MinutesPlayed_list_gk, Max_minutesPlayed_gk),
    calc_max(Rating_list_gk, Max_Rating_gk),
    calc_max(RedCards_list_gk, Max_RedCards_gk),
    calc_max(PenaltyConceded_list_gk, Max_PenaltyConceded_gk),
    calc_max(OwnGoals_list_gk, Max_OwnGoals_gk),
    calc_max(ErrorLeadToGoal_list_gk, Max_ErrorLeadToGoal_gk),
    calc_max(CleanSheet_list_gk, Max_CleanSheet_gk),
    calc_max(GoalsConcededInsideTheBox_list_gk, Max_GoalsConcededInsideTheBox_gk),
    calc_max(GoalsConcededOutsideTheBox_list_gk, Max_GoalsConcededOutsideTheBox_gk),
    calc_max(GoalsConceded_list_gk, Max_GoalsConceded_gk),

    assertz(get_max_age_gk(Max) :- Max =.. [Max_age_gk]),
    assertz(get_max_height_gk(Max) :- Max =.. [Max_height_gk]),
    assertz(get_max_minutesPlayed_gk(Max) :- Max =.. [Max_minutesPlayed_gk]),
    assertz(get_max_Rating_gk(Max) :- Max =.. [Max_Rating_gk]),
    assertz(get_max_RedCards_gk(Max) :- Max =.. [Max_RedCards_gk]),
    assertz(get_max_PenaltyConceded_gk(Max) :- Max =.. [Max_PenaltyConceded_gk]),
    assertz(get_max_OwnGoals_gk(Max) :- Max =.. [Max_OwnGoals_gk]),
    assertz(get_max_ErrorLeadToGoal_gk(Max) :- Max =.. [Max_ErrorLeadToGoal_gk]),
    assertz(get_max_CleanSheet_gk(Max) :- Max =.. [Max_CleanSheet_gk]),
    assertz(get_max_GoalsConcededInsideTheBox_gk(Max) :- Max =.. [Max_GoalsConcededInsideTheBox_gk]),
    assertz(get_max_GoalsConcededOutsideTheBox_gk(Max) :- Max =.. [Max_GoalsConcededOutsideTheBox_gk]),
    assertz(get_max_GoalsConceded_gk(Max) :- Max =.. [Max_GoalsConceded_gk]),

    % DC
    findall(Player, is_defender_central(Player), Players_dc),

    get_all_age(Players_dc, Age_list_dc),
    get_all_height(Players_dc, Height_list_dc),
    get_all_minutesPlayed(Players_dc, MinutesPlayed_list_dc),
    get_all_rating(Players_dc, Rating_list_dc),
    get_all_goals(Players_dc, Goals_list_dc),
    get_all_interceptions(Players_dc, Interceptions_list_dc),
    get_all_yellowCards(Players_dc, YellowCards_list_dc),
    get_all_redCards(Players_dc, RedCards_list_dc),
    get_all_clearances(Players_dc, Clearances_list_dc),
    get_all_errorLeadToGoal(Players_dc, ErrorLeadToGoal_list_dc),
    get_all_dispossessed(Players_dc, Dispossessed_list_dc),
    get_all_possessionLost(Players_dc, PossessionLost_list_dc),
    get_all_fouls(Players_dc, Fouls_list_dc),
    get_all_ownGoals(Players_dc, OwnGoals_list_dc),
    get_all_dribbledPast(Players_dc, DribbledPast_list_dc),
    get_all_penaltyConceded(Players_dc, PenaltyConceded_list_dc),
    get_all_errorLeadToShot(Players_dc, ErrorLeadToShot_list_dc),
    get_all_blockedShots(Players_dc, BlockedShots_list_dc),
    get_all_goalsConceded(Players_dc, GoalsConceded_list_dc),
    get_all_cleanSheet(Players_dc, CleanSheet_list_dc),

    calc_max(Age_list_dc, Max_age_dc),
    calc_max(Height_list_dc, Max_height_dc),
    calc_max(MinutesPlayed_list_dc, Max_minutesPlayed_dc),
    calc_max(Rating_list_dc, Max_Rating_dc),
    calc_max(Goals_list_dc, Max_Goals_dc),
    calc_max(Interceptions_list_dc, Max_Interceptions_dc),
    calc_max(YellowCards_list_dc, Max_YellowCards_dc),
    calc_max(RedCards_list_dc, Max_RedCards_dc),
    calc_max(Clearances_list_dc, Max_Clearances_dc),
    calc_max(ErrorLeadToGoal_list_dc, Max_ErrorLeadToGoal_dc),
    calc_max(Dispossessed_list_dc, Max_Dispossessed_dc),
    calc_max(PossessionLost_list_dc, Max_PossessionLost_dc),
    calc_max(Fouls_list_dc, Max_Fouls_dc),
    calc_max(OwnGoals_list_dc, Max_OwnGoals_dc),
    calc_max(DribbledPast_list_dc, Max_DribbledPast_dc),
    calc_max(PenaltyConceded_list_dc, Max_PenaltyConceded_dc),
    calc_max(ErrorLeadToShot_list_dc, Max_ErrorLeadToShot_dc),
    calc_max(BlockedShots_list_dc, Max_BlockedShots_dc),
    calc_max(GoalsConceded_list_dc, Max_GoalsConceded_dc),
    calc_max(CleanSheet_list_dc, Max_CleanSheet_dc),

    assertz(get_max_age_dc(Max) :- Max =.. [Max_age_dc]),
    assertz(get_max_height_dc(Max) :- Max =.. [Max_height_dc]),
    assertz(get_max_minutesPlayed_dc(Max) :- Max =.. [Max_minutesPlayed_dc]),
    assertz(get_max_Rating_dc(Max) :- Max =.. [Max_Rating_dc]),
    assertz(get_max_Goals_dc(Max) :- Max =.. [Max_Goals_dc]),
    assertz(get_max_Interceptions_dc(Max) :- Max =.. [Max_Interceptions_dc]),
    assertz(get_max_YellowCards_dc(Max) :- Max =.. [Max_YellowCards_dc]),
    assertz(get_max_RedCards_dc(Max) :- Max =.. [Max_RedCards_dc]),
    assertz(get_max_Clearances_dc(Max) :- Max =.. [Max_Clearances_dc]),
    assertz(get_max_ErrorLeadToGoal_dc(Max) :- Max =.. [Max_ErrorLeadToGoal_dc]),
    assertz(get_max_Dispossessed_dc(Max) :- Max =.. [Max_Dispossessed_dc]),
    assertz(get_max_PossessionLost_dc(Max) :- Max =.. [Max_PossessionLost_dc]),
    assertz(get_max_Fouls_dc(Max) :- Max =.. [Max_Fouls_dc]),
    assertz(get_max_OwnGoals_dc(Max) :- Max =.. [Max_OwnGoals_dc]),
    assertz(get_max_DribbledPast_dc(Max) :- Max =.. [Max_DribbledPast_dc]),
    assertz(get_max_PenaltyConceded_dc(Max) :- Max =.. [Max_PenaltyConceded_dc]),
    assertz(get_max_ErrorLeadToShot_dc(Max) :- Max =.. [Max_ErrorLeadToShot_dc]),
    assertz(get_max_BlockedShots_dc(Max) :- Max =.. [Max_BlockedShots_dc]),
    assertz(get_max_GoalsConceded_dc(Max) :- Max =.. [Max_GoalsConceded_dc]),
    assertz(get_max_CleanSheet_dc(Max) :- Max =.. [Max_CleanSheet_dc]),

    % FB
    findall(Player, is_fullback(Player), Players_fb),

    get_all_age(Players_fb, Age_list_fb),
    get_all_height(Players_fb, Height_list_fb),
    get_all_minutesPlayed(Players_fb, MinutesPlayed_list_fb),
    get_all_rating(Players_fb, Rating_list_fb),
    get_all_goals(Players_fb, Goals_list_fb),
    get_all_bigChancesCreated(Players_fb, BigChancesCreated_list_fb),
    get_all_accurateFinalThirdPasses(Players_fb, AccurateFinalThirdPasses_list_fb),
    get_all_keyPasses(Players_fb, KeyPasses_list_fb),
    get_all_interceptions(Players_fb, Interceptions_list_fb),
    get_all_yellowCards(Players_fb, YellowCards_list_fb),
    get_all_redCards(Players_fb, RedCards_list_fb),
    get_all_penaltyConceded(Players_fb, PenaltyConceded_list_fb),
    get_all_penaltyWon(Players_fb, PenaltyWon_list_fb),
    get_all_clearances(Players_fb, Clearances_list_fb),
    get_all_errorLeadToGoal(Players_fb, ErrorLeadToGoal_list_fb),
    get_all_dispossessed(Players_fb, Dispossessed_list_fb),
    get_all_possessionLost(Players_fb, PossessionLost_list_fb),
    get_all_possessionWonAttThird(Players_fb, PossessionWonAttThird_list_fb),
    get_all_wasFouled(Players_fb, WasFouled_list_fb),
    get_all_fouls(Players_fb, Fouls_list_fb),
    get_all_ownGoals(Players_fb, OwnGoals_list_fb),
    get_all_dribbledPast(Players_fb, DribbledPast_list_fb),
    get_all_assists(Players_fb, Assists_list_fb),
    get_all_errorLeadToShot(Players_fb, ErrorLeadToShot_list_fb),
    get_all_blockedShots(Players_fb, BlockedShots_list_fb),
    get_all_goalsConceded(Players_fb, GoalsConceded_list_fb),
    get_all_cleanSheet(Players_fb, CleanSheet_list_fb),

    calc_max(Age_list_fb, Max_age_fb),
    calc_max(Height_list_fb, Max_height_fb),
    calc_max(MinutesPlayed_list_fb, Max_minutesPlayed_fb),
    calc_max(Rating_list_fb, Max_Rating_fb),
    calc_max(Goals_list_fb, Max_Goals_fb),
    calc_max(BigChancesCreated_list_fb, Max_BigChancesCreated_fb),
    calc_max(AccurateFinalThirdPasses_list_fb, Max_AccurateFinalThirdPasses_fb),
    calc_max(KeyPasses_list_fb, Max_KeyPasses_fb),
    calc_max(Interceptions_list_fb, Max_Interceptions_fb),
    calc_max(YellowCards_list_fb, Max_YellowCards_fb),
    calc_max(RedCards_list_fb, Max_RedCards_fb),
    calc_max(PenaltyConceded_list_fb, Max_PenaltyConceded_fb),
    calc_max(PenaltyWon_list_fb, Max_PenaltyWon_fb),
    calc_max(Clearances_list_fb, Max_Clearances_fb),
    calc_max(ErrorLeadToGoal_list_fb, Max_ErrorLeadToGoal_fb),
    calc_max(Dispossessed_list_fb, Max_Dispossessed_fb),
    calc_max(PossessionLost_list_fb, Max_PossessionLost_fb),
    calc_max(PossessionWonAttThird_list_fb, Max_PossessionWonAttThird_fb),
    calc_max(WasFouled_list_fb, Max_WasFouled_fb),
    calc_max(Fouls_list_fb, Max_Fouls_fb),
    calc_max(OwnGoals_list_fb, Max_OwnGoals_fb),
    calc_max(DribbledPast_list_fb, Max_DribbledPast_fb),
    calc_max(Assists_list_fb, Max_Assists_fb),
    calc_max(ErrorLeadToShot_list_fb, Max_ErrorLeadToShot_fb),
    calc_max(BlockedShots_list_fb, Max_BlockedShots_fb),
    calc_max(GoalsConceded_list_fb, Max_GoalsConceded_fb),
    calc_max(CleanSheet_list_fb, Max_CleanSheet_fb),

    assertz(get_max_age_fb(Max) :- Max =.. [Max_age_fb]),
    assertz(get_max_height_fb(Max) :- Max =.. [Max_height_fb]),
    assertz(get_max_minutesPlayed_fb(Max) :- Max =.. [Max_minutesPlayed_fb]),
    assertz(get_max_Rating_fb(Max) :- Max =.. [Max_Rating_fb]),
    assertz(get_max_Goals_fb(Max) :- Max =.. [Max_Goals_fb]),
    assertz(get_max_BigChancesCreated_fb(Max) :- Max =.. [Max_BigChancesCreated_fb]),
    assertz(get_max_AccurateFinalThirdPasses_fb(Max) :- Max =.. [Max_AccurateFinalThirdPasses_fb]),
    assertz(get_max_KeyPasses_fb(Max) :- Max =.. [Max_KeyPasses_fb]),
    assertz(get_max_Interceptions_fb(Max) :- Max =.. [Max_Interceptions_fb]),
    assertz(get_max_YellowCards_fb(Max) :- Max =.. [Max_YellowCards_fb]),
    assertz(get_max_RedCards_fb(Max) :- Max =.. [Max_RedCards_fb]),
    assertz(get_max_PenaltyConceded_fb(Max) :- Max =.. [Max_PenaltyConceded_fb]),
    assertz(get_max_PenaltyWon_fb(Max) :- Max =.. [Max_PenaltyWon_fb]),
    assertz(get_max_Clearances_fb(Max) :- Max =.. [Max_Clearances_fb]),
    assertz(get_max_ErrorLeadToGoal_fb(Max) :- Max =.. [Max_ErrorLeadToGoal_fb]),
    assertz(get_max_Dispossessed_fb(Max) :- Max =.. [Max_Dispossessed_fb]),
    assertz(get_max_PossessionLost_fb(Max) :- Max =.. [Max_PossessionLost_fb]),
    assertz(get_max_PossessionWonAttThird_fb(Max) :- Max =.. [Max_PossessionWonAttThird_fb]),
    assertz(get_max_WasFouled_fb(Max) :- Max =.. [Max_WasFouled_fb]),
    assertz(get_max_Fouls_fb(Max) :- Max =.. [Max_Fouls_fb]),
    assertz(get_max_OwnGoals_fb(Max) :- Max =.. [Max_OwnGoals_fb]),
    assertz(get_max_DribbledPast_fb(Max) :- Max =.. [Max_DribbledPast_fb]),
    assertz(get_max_Assists_fb(Max) :- Max =.. [Max_Assists_fb]),
    assertz(get_max_ErrorLeadToShot_fb(Max) :- Max =.. [Max_ErrorLeadToShot_fb]),
    assertz(get_max_BlockedShots_fb(Max) :- Max =.. [Max_BlockedShots_fb]),
    assertz(get_max_GoalsConceded_fb(Max) :- Max =.. [Max_GoalsConceded_fb]),
    assertz(get_max_CleanSheet_fb(Max) :- Max =.. [Max_CleanSheet_fb]),

    % DM
    findall(Player, is_dm(Player), Players_dm),

    get_all_age(Players_dm, Age_list_dm),
    get_all_height(Players_dm, Height_list_dm),
    get_all_minutesPlayed(Players_dm, MinutesPlayed_list_dm),
    get_all_rating(Players_dm, Rating_list_dm),
    get_all_goals(Players_dm, Goals_list_dm),
    get_all_bigChancesCreated(Players_dm, BigChancesCreated_list_dm),
    get_all_keyPasses(Players_dm, KeyPasses_list_dm),
    get_all_interceptions(Players_dm, Interceptions_list_dm),
    get_all_yellowCards(Players_dm, YellowCards_list_dm),
    get_all_redCards(Players_dm, RedCards_list_dm),
    get_all_penaltyConceded(Players_dm, PenaltyConceded_list_dm),
    get_all_errorLeadToGoal(Players_dm, ErrorLeadToGoal_list_dm),
    get_all_dispossessed(Players_dm, Dispossessed_list_dm),
    get_all_possessionLost(Players_dm, PossessionLost_list_dm),
    get_all_fouls(Players_dm, Fouls_list_dm),
    get_all_ownGoals(Players_dm, OwnGoals_list_dm),
    get_all_dribbledPast(Players_dm, DribbledPast_list_dm),
    get_all_assists(Players_dm, Assists_list_dm),
    get_all_errorLeadToShot(Players_dm, ErrorLeadToShot_list_dm),
    get_all_blockedShots(Players_dm, BlockedShots_list_dm),
    get_all_goalsConceded(Players_dm, GoalsConceded_list_dm),
    get_all_cleanSheet(Players_dm, CleanSheet_list_dm),
    get_all_passToAssist(Players_dm, PassToAssist_list_dm),

    calc_max(Age_list_dm, Max_age_dm),
    calc_max(Height_list_dm, Max_height_dm),
    calc_max(MinutesPlayed_list_dm, Max_minutesPlayed_dm),
    calc_max(Rating_list_dm, Max_Rating_dm),
    calc_max(Goals_list_dm, Max_Goals_dm),
    calc_max(BigChancesCreated_list_dm, Max_BigChancesCreated_dm),
    calc_max(KeyPasses_list_dm, Max_KeyPasses_dm),
    calc_max(Interceptions_list_dm, Max_Interceptions_dm),
    calc_max(YellowCards_list_dm, Max_YellowCards_dm),
    calc_max(RedCards_list_dm, Max_RedCards_dm),
    calc_max(PenaltyConceded_list_dm, Max_PenaltyConceded_dm),
    calc_max(ErrorLeadToGoal_list_dm, Max_ErrorLeadToGoal_dm),
    calc_max(Dispossessed_list_dm, Max_Dispossessed_dm),
    calc_max(PossessionLost_list_dm, Max_PossessionLost_dm),
    calc_max(Fouls_list_dm, Max_Fouls_dm),
    calc_max(OwnGoals_list_dm, Max_OwnGoals_dm),
    calc_max(DribbledPast_list_dm, Max_DribbledPast_dm),
    calc_max(Assists_list_dm, Max_Assists_dm),
    calc_max(ErrorLeadToShot_list_dm, Max_ErrorLeadToShot_dm),
    calc_max(BlockedShots_list_dm, Max_BlockedShots_dm),
    calc_max(GoalsConceded_list_dm, Max_GoalsConceded_dm),
    calc_max(CleanSheet_list_dm, Max_CleanSheet_dm),
    calc_max(PassToAssist_list_dm, Max_PassToAssist_dm),

    assertz(get_max_age_dm(Max) :- Max =.. [Max_age_dm]),
    assertz(get_max_height_dm(Max) :- Max =.. [Max_height_dm]),
    assertz(get_max_minutesPlayed_dm(Max) :- Max =.. [Max_minutesPlayed_dm]),
    assertz(get_max_Rating_dm(Max) :- Max =.. [Max_Rating_dm]),
    assertz(get_max_Goals_dm(Max) :- Max =.. [Max_Goals_dm]),
    assertz(get_max_BigChancesCreated_dm(Max) :- Max =.. [Max_BigChancesCreated_dm]),
    assertz(get_max_KeyPasses_dm(Max) :- Max =.. [Max_KeyPasses_dm]),
    assertz(get_max_Interceptions_dm(Max) :- Max =.. [Max_Interceptions_dm]),
    assertz(get_max_YellowCards_dm(Max) :- Max =.. [Max_YellowCards_dm]),
    assertz(get_max_RedCards_dm(Max) :- Max =.. [Max_RedCards_dm]),
    assertz(get_max_PenaltyConceded_dm(Max) :- Max =.. [Max_PenaltyConceded_dm]),
    assertz(get_max_ErrorLeadToGoal_dm(Max) :- Max =.. [Max_ErrorLeadToGoal_dm]),
    assertz(get_max_Dispossessed_dm(Max) :- Max =.. [Max_Dispossessed_dm]),
    assertz(get_max_PossessionLost_dm(Max) :- Max =.. [Max_PossessionLost_dm]),
    assertz(get_max_Fouls_dm(Max) :- Max =.. [Max_Fouls_dm]),
    assertz(get_max_OwnGoals_dm(Max) :- Max =.. [Max_OwnGoals_dm]),
    assertz(get_max_DribbledPast_dm(Max) :- Max =.. [Max_DribbledPast_dm]),
    assertz(get_max_Assists_dm(Max) :- Max =.. [Max_Assists_dm]),
    assertz(get_max_ErrorLeadToShot_dm(Max) :- Max =.. [Max_ErrorLeadToShot_dm]),
    assertz(get_max_BlockedShots_dm(Max) :- Max =.. [Max_BlockedShots_dm]),
    assertz(get_max_GoalsConceded_dm(Max) :- Max =.. [Max_GoalsConceded_dm]),
    assertz(get_max_CleanSheet_dm(Max) :- Max =.. [Max_CleanSheet_dm]),
    assertz(get_max_PassToAssist_dm(Max) :- Max =.. [Max_PassToAssist_dm]),

    % MC
    findall(Player, is_mc(Player), Players_mc),

    get_all_age(Players_mc, Age_list_mc),
    get_all_height(Players_mc, Height_list_mc),
    get_all_minutesPlayed(Players_mc, MinutesPlayed_list_mc),
    get_all_rating(Players_mc, Rating_list_mc),
    get_all_goals(Players_mc, Goals_list_mc),
    get_all_bigChancesCreated(Players_mc, BigChancesCreated_list_mc),
    get_all_accurateFinalThirdPasses(Players_mc, AccurateFinalThirdPasses_list_mc),
    get_all_keyPasses(Players_mc, KeyPasses_list_mc),
    get_all_interceptions(Players_mc, Interceptions_list_mc),
    get_all_yellowCards(Players_mc, YellowCards_list_mc),
    get_all_redCards(Players_mc, RedCards_list_mc),
    get_all_penaltyConceded(Players_mc, PenaltyConceded_list_mc),
    get_all_errorLeadToGoal(Players_mc, ErrorLeadToGoal_list_mc),
    get_all_dispossessed(Players_mc, Dispossessed_list_mc),
    get_all_possessionLost(Players_mc, PossessionLost_list_mc),
    get_all_possessionWonAttThird(Players_mc, PossessionWonAttThird_list_mc),
    get_all_fouls(Players_mc, Fouls_list_mc),
    get_all_ownGoals(Players_mc, OwnGoals_list_mc),
    get_all_dribbledPast(Players_mc, DribbledPast_list_mc),
    get_all_assists(Players_mc, Assists_list_mc),
    get_all_errorLeadToShot(Players_mc, ErrorLeadToShot_list_mc),
    get_all_goalsConceded(Players_mc, GoalsConceded_list_mc),
    get_all_passToAssist(Players_mc, PassToAssist_list_mc),

    calc_max(Age_list_mc, Max_age_mc),
    calc_max(Height_list_mc, Max_height_mc),
    calc_max(MinutesPlayed_list_mc, Max_minutesPlayed_mc),
    calc_max(Rating_list_mc, Max_Rating_mc),
    calc_max(Goals_list_mc, Max_Goals_mc),
    calc_max(BigChancesCreated_list_mc, Max_BigChancesCreated_mc),
    calc_max(AccurateFinalThirdPasses_list_mc, Max_AccurateFinalThirdPasses_mc),
    calc_max(KeyPasses_list_mc, Max_KeyPasses_mc),
    calc_max(Interceptions_list_mc, Max_Interceptions_mc),
    calc_max(YellowCards_list_mc, Max_YellowCards_mc),
    calc_max(RedCards_list_mc, Max_RedCards_mc),
    calc_max(PenaltyConceded_list_mc, Max_PenaltyConceded_mc),
    calc_max(ErrorLeadToGoal_list_mc, Max_ErrorLeadToGoal_mc),
    calc_max(Dispossessed_list_mc, Max_Dispossessed_mc),
    calc_max(PossessionLost_list_mc, Max_PossessionLost_mc),
    calc_max(PossessionWonAttThird_list_mc, Max_PossessionWonAttThird_mc),
    calc_max(Fouls_list_mc, Max_Fouls_mc),
    calc_max(OwnGoals_list_mc, Max_OwnGoals_mc),
    calc_max(DribbledPast_list_mc, Max_DribbledPast_mc),
    calc_max(Assists_list_mc, Max_Assists_mc),
    calc_max(ErrorLeadToShot_list_mc, Max_ErrorLeadToShot_mc),
    calc_max(GoalsConceded_list_mc, Max_GoalsConceded_mc),
    calc_max(PassToAssist_list_mc, Max_PassToAssist_mc),

    assertz(get_max_age_mc(Max) :- Max =.. [Max_age_mc]),
    assertz(get_max_height_mc(Max) :- Max =.. [Max_height_mc]),
    assertz(get_max_minutesPlayed_mc(Max) :- Max =.. [Max_minutesPlayed_mc]),
    assertz(get_max_Rating_mc(Max) :- Max =.. [Max_Rating_mc]),
    assertz(get_max_Goals_mc(Max) :- Max =.. [Max_Goals_mc]),
    assertz(get_max_BigChancesCreated_mc(Max) :- Max =.. [Max_BigChancesCreated_mc]),
    assertz(get_max_AccurateFinalThirdPasses_mc(Max) :- Max =.. [Max_AccurateFinalThirdPasses_mc]),
    assertz(get_max_KeyPasses_mc(Max) :- Max =.. [Max_KeyPasses_mc]),
    assertz(get_max_Interceptions_mc(Max) :- Max =.. [Max_Interceptions_mc]),
    assertz(get_max_YellowCards_mc(Max) :- Max =.. [Max_YellowCards_mc]),
    assertz(get_max_RedCards_mc(Max) :- Max =.. [Max_RedCards_mc]),
    assertz(get_max_PenaltyConceded_mc(Max) :- Max =.. [Max_PenaltyConceded_mc]),
    assertz(get_max_ErrorLeadToGoal_mc(Max) :- Max =.. [Max_ErrorLeadToGoal_mc]),
    assertz(get_max_Dispossessed_mc(Max) :- Max =.. [Max_Dispossessed_mc]),
    assertz(get_max_PossessionLost_mc(Max) :- Max =.. [Max_PossessionLost_mc]),
    assertz(get_max_PossessionWonAttThird_mc(Max) :- Max =.. [Max_PossessionWonAttThird_mc]),
    assertz(get_max_Fouls_mc(Max) :- Max =.. [Max_Fouls_mc]),
    assertz(get_max_OwnGoals_mc(Max) :- Max =.. [Max_OwnGoals_mc]),
    assertz(get_max_DribbledPast_mc(Max) :- Max =.. [Max_DribbledPast_mc]),
    assertz(get_max_Assists_mc(Max) :- Max =.. [Max_Assists_mc]),
    assertz(get_max_ErrorLeadToShot_mc(Max) :- Max =.. [Max_ErrorLeadToShot_mc]),
    assertz(get_max_GoalsConceded_mc(Max) :- Max =.. [Max_GoalsConceded_mc]),
    assertz(get_max_PassToAssist_mc(Max) :- Max =.. [Max_PassToAssist_mc]),

    % AM
    findall(Player, is_am(Player), Players_am),

    get_all_age(Players_am, Age_list_am),
    get_all_height(Players_am, Height_list_am),
    get_all_minutesPlayed(Players_am, MinutesPlayed_list_am),
    get_all_rating(Players_am, Rating_list_am),
    get_all_goals(Players_am, Goals_list_am),
    get_all_bigChancesCreated(Players_am, BigChancesCreated_list_am),
    get_all_bigChancesMissed(Players_am, BigChancesMissed_list_am),
    get_all_accurateFinalThirdPasses(Players_am, AccurateFinalThirdPasses_list_am),
    get_all_keyPasses(Players_am, KeyPasses_list_am),
    get_all_interceptions(Players_am, Interceptions_list_am),
    get_all_yellowCards(Players_am, YellowCards_list_am),
    get_all_redCards(Players_am, RedCards_list_am),
    get_all_penaltyWon(Players_am, PenaltyWon_list_am),
    get_all_dispossessed(Players_am, Dispossessed_list_am),
    get_all_possessionLost(Players_am, PossessionLost_list_am),
    get_all_possessionWonAttThird(Players_am, PossessionWonAttThird_list_am),
    get_all_wasFouled(Players_am, WasFouled_list_am),
    get_all_assists(Players_am, Assists_list_am),
    get_all_passToAssist(Players_am, PassToAssist_list_am),

    calc_max(Age_list_am, Max_age_am),
    calc_max(Height_list_am, Max_height_am),
    calc_max(MinutesPlayed_list_am, Max_minutesPlayed_am),
    calc_max(Rating_list_am, Max_Rating_am),
    calc_max(Goals_list_am, Max_Goals_am),
    calc_max(BigChancesCreated_list_am, Max_BigChancesCreated_am),
    calc_max(BigChancesMissed_list_am, Max_BigChancesMissed_am),
    calc_max(AccurateFinalThirdPasses_list_am, Max_AccurateFinalThirdPasses_am),
    calc_max(KeyPasses_list_am, Max_KeyPasses_am),
    calc_max(Interceptions_list_am, Max_Interceptions_am),
    calc_max(YellowCards_list_am, Max_YellowCards_am),
    calc_max(RedCards_list_am, Max_RedCards_am),
    calc_max(PenaltyWon_list_am, Max_PenaltyWon_am),
    calc_max(Dispossessed_list_am, Max_Dispossessed_am),
    calc_max(PossessionLost_list_am, Max_PossessionLost_am),
    calc_max(PossessionWonAttThird_list_am, Max_PossessionWonAttThird_am),
    calc_max(WasFouled_list_am, Max_WasFouled_am),
    calc_max(Assists_list_am, Max_Assists_am),
    calc_max(PassToAssist_list_am, Max_PassToAssist_am),

    assertz(get_max_age_am(Max) :- Max =.. [Max_age_am]),
    assertz(get_max_height_am(Max) :- Max =.. [Max_height_am]),
    assertz(get_max_minutesPlayed_am(Max) :- Max =.. [Max_minutesPlayed_am]),
    assertz(get_max_Rating_am(Max) :- Max =.. [Max_Rating_am]),
    assertz(get_max_Goals_am(Max) :- Max =.. [Max_Goals_am]),
    assertz(get_max_BigChancesCreated_am(Max) :- Max =.. [Max_BigChancesCreated_am]),
    assertz(get_max_BigChancesMissed_am(Max) :- Max =.. [Max_BigChancesMissed_am]),
    assertz(get_max_AccurateFinalThirdPasses_am(Max) :- Max =.. [Max_AccurateFinalThirdPasses_am]),
    assertz(get_max_KeyPasses_am(Max) :- Max =.. [Max_KeyPasses_am]),
    assertz(get_max_Interceptions_am(Max) :- Max =.. [Max_Interceptions_am]),
    assertz(get_max_YellowCards_am(Max) :- Max =.. [Max_YellowCards_am]),
    assertz(get_max_RedCards_am(Max) :- Max =.. [Max_RedCards_am]),
    assertz(get_max_PenaltyWon_am(Max) :- Max =.. [Max_PenaltyWon_am]),
    assertz(get_max_Dispossessed_am(Max) :- Max =.. [Max_Dispossessed_am]),
    assertz(get_max_PossessionLost_am(Max) :- Max =.. [Max_PossessionLost_am]),
    assertz(get_max_PossessionWonAttThird_am(Max) :- Max =.. [Max_PossessionWonAttThird_am]),
    assertz(get_max_WasFouled_am(Max) :- Max =.. [Max_WasFouled_am]),
    assertz(get_max_Assists_am(Max) :- Max =.. [Max_Assists_am]),
    assertz(get_max_PassToAssist_am(Max) :- Max =.. [Max_PassToAssist_am]),

    % ST
    findall(Player, is_st(Player), Players_st),

    get_all_age(Players_st, Age_list_st),
    get_all_height(Players_st, Height_list_st),
    get_all_minutesPlayed(Players_st, MinutesPlayed_list_st),
    get_all_rating(Players_st, Rating_list_st),
    get_all_goals(Players_st, Goals_list_st),
    get_all_bigChancesCreated(Players_st, BigChancesCreated_list_st),
    get_all_accurateFinalThirdPasses(Players_st, AccurateFinalThirdPasses_list_st),
    get_all_keyPasses(Players_st, KeyPasses_list_st),
    get_all_yellowCards(Players_st, YellowCards_list_st),
    get_all_redCards(Players_st, RedCards_list_st),
    get_all_dispossessed(Players_st, Dispossessed_list_st),
    get_all_possessionLost(Players_st, PossessionLost_list_st),
    get_all_wasFouled(Players_st, WasFouled_list_st),
    get_all_assists(Players_st, Assists_list_st),

    calc_max(Age_list_st, Max_age_st),
    calc_max(Height_list_st, Max_height_st),
    calc_max(MinutesPlayed_list_st, Max_minutesPlayed_st),
    calc_max(Rating_list_st, Max_Rating_st),
    calc_max(Goals_list_st, Max_Goals_st),
    calc_max(BigChancesCreated_list_st, Max_BigChancesCreated_st),
    calc_max(AccurateFinalThirdPasses_list_st, Max_AccurateFinalThirdPasses_st),
    calc_max(KeyPasses_list_st, Max_KeyPasses_st),
    calc_max(YellowCards_list_st, Max_YellowCards_st),
    calc_max(RedCards_list_st, Max_RedCards_st),
    calc_max(Dispossessed_list_st, Max_Dispossessed_st),
    calc_max(PossessionLost_list_st, Max_PossessionLost_st),
    calc_max(WasFouled_list_st, Max_WasFouled_st),
    calc_max(Assists_list_st, Max_Assists_st),

    assertz(get_max_age_st(Max) :- Max =.. [Max_age_st]),
    assertz(get_max_height_st(Max) :- Max =.. [Max_height_st]),
    assertz(get_max_minutesPlayed_st(Max) :- Max =.. [Max_minutesPlayed_st]),
    assertz(get_max_Rating_st(Max) :- Max =.. [Max_Rating_st]),
    assertz(get_max_Goals_st(Max) :- Max =.. [Max_Goals_st]),
    assertz(get_max_BigChancesCreated_st(Max) :- Max =.. [Max_BigChancesCreated_st]),
    assertz(get_max_AccurateFinalThirdPasses_st(Max) :- Max =.. [Max_AccurateFinalThirdPasses_st]),
    assertz(get_max_KeyPasses_st(Max) :- Max =.. [Max_KeyPasses_st]),
    assertz(get_max_YellowCards_st(Max) :- Max =.. [Max_YellowCards_st]),
    assertz(get_max_RedCards_st(Max) :- Max =.. [Max_RedCards_st]),
    assertz(get_max_Dispossessed_st(Max) :- Max =.. [Max_Dispossessed_st]),
    assertz(get_max_PossessionLost_st(Max) :- Max =.. [Max_PossessionLost_st]),
    assertz(get_max_WasFouled_st(Max) :- Max =.. [Max_WasFouled_st]),
    assertz(get_max_Assists_st(Max) :- Max =.. [Max_Assists_st]),

    % W
    findall(Player, is_w(Player), Players_w),

    get_all_age(Players_w, Age_list_w),
    get_all_height(Players_w, Height_list_w),
    get_all_minutesPlayed(Players_w, MinutesPlayed_list_w),
    get_all_rating(Players_w, Rating_list_w),
    get_all_goals(Players_w, Goals_list_w),
    get_all_bigChancesCreated(Players_w, BigChancesCreated_list_w),
    get_all_accurateFinalThirdPasses(Players_w, AccurateFinalThirdPasses_list_w),
    get_all_keyPasses(Players_w, KeyPasses_list_w),
    get_all_yellowCards(Players_w, YellowCards_list_w),
    get_all_redCards(Players_w, RedCards_list_w),
    get_all_penaltyWon(Players_w, PenaltyWon_list_w),
    get_all_dispossessed(Players_w, Dispossessed_list_w),
    get_all_possessionLost(Players_w, PossessionLost_list_w),
    get_all_wasFouled(Players_w, WasFouled_list_w),
    get_all_assists(Players_w, Assists_list_w),
    get_all_cleanSheet(Players_w, CleanSheet_list_w),
    get_all_passToAssist(Players_w, PassToAssist_list_w),
    get_all_successfulDribbles(Players_w, SuccessfulDribbles_list_w),

    calc_max(Age_list_w, Max_age_w),
    calc_max(Height_list_w, Max_height_w),
    calc_max(MinutesPlayed_list_w, Max_minutesPlayed_w),
    calc_max(Rating_list_w, Max_Rating_w),
    calc_max(Goals_list_w, Max_Goals_w),
    calc_max(BigChancesCreated_list_w, Max_BigChancesCreated_w),
    calc_max(AccurateFinalThirdPasses_list_w, Max_AccurateFinalThirdPasses_w),
    calc_max(KeyPasses_list_w, Max_KeyPasses_w),
    calc_max(YellowCards_list_w, Max_YellowCards_w),
    calc_max(RedCards_list_w, Max_RedCards_w),
    calc_max(PenaltyWon_list_w, Max_PenaltyWon_w),
    calc_max(Dispossessed_list_w, Max_Dispossessed_w),
    calc_max(PossessionLost_list_w, Max_PossessionLost_w),
    calc_max(WasFouled_list_w, Max_WasFouled_w),
    calc_max(Assists_list_w, Max_Assists_w),
    calc_max(CleanSheet_list_w, Max_CleanSheet_w),
    calc_max(PassToAssist_list_w, Max_PassToAssist_w),
    calc_max(SuccessfulDribbles_list_w, Max_SuccessfulDribbles_w),

    assertz(get_max_age_w(Max) :- Max =.. [Max_age_w]),
    assertz(get_max_height_w(Max) :- Max =.. [Max_height_w]),
    assertz(get_max_minutesPlayed_w(Max) :- Max =.. [Max_minutesPlayed_w]),
    assertz(get_max_Rating_w(Max) :- Max =.. [Max_Rating_w]),
    assertz(get_max_Goals_w(Max) :- Max =.. [Max_Goals_w]),
    assertz(get_max_BigChancesCreated_w(Max) :- Max =.. [Max_BigChancesCreated_w]),
    assertz(get_max_AccurateFinalThirdPasses_w(Max) :- Max =.. [Max_AccurateFinalThirdPasses_w]),
    assertz(get_max_KeyPasses_w(Max) :- Max =.. [Max_KeyPasses_w]),
    assertz(get_max_YellowCards_w(Max) :- Max =.. [Max_YellowCards_w]),
    assertz(get_max_RedCards_w(Max) :- Max =.. [Max_RedCards_w]),
    assertz(get_max_PenaltyWon_w(Max) :- Max =.. [Max_PenaltyWon_w]),
    assertz(get_max_Dispossessed_w(Max) :- Max =.. [Max_Dispossessed_w]),
    assertz(get_max_PossessionLost_w(Max) :- Max =.. [Max_PossessionLost_w]),
    assertz(get_max_WasFouled_w(Max) :- Max =.. [Max_WasFouled_w]),
    assertz(get_max_Assists_w(Max) :- Max =.. [Max_Assists_w]),
    assertz(get_max_CleanSheet_w(Max) :- Max =.. [Max_CleanSheet_w]),
    assertz(get_max_PassToAssist_w(Max) :- Max =.. [Max_PassToAssist_w]),
    assertz(get_max_SuccessfulDribbles_w(Max) :- Max =.. [Max_SuccessfulDribbles_w]).

get_all_tournamentTeams(TournamentName, Teams) :-
    findall(Team, teamInTournament(TournamentName, Team), Teams).

is_team(Id, TeamName) :- team(Id, TeamName).
get_fullTeam(TeamName, Players) :-
    findall(Player, is_team(Player, TeamName), Players).

penaltyPercentage(Id, PanaltyPercentage) :-
    penaltySave(Id, PenaltySave),
    penaltyFaced(Id, PenaltyFaced),
    handleDivisionByZero(PenaltySave, PenaltyFaced, Y), 
    PanaltyPercentage is Y.

ownHalfPassesPercentage(Id, OwnHalfPassesPercentage) :-
    accurateOwnHalfPasses(Id, AccurateOwnHalfPasses),
    totalOwnHalfPasses(Id, TotalOwnHalfPasses),
    handleDivisionByZero(AccurateOwnHalfPasses, TotalOwnHalfPasses, Y),
    OwnHalfPassesPercentage is Y * 100.

oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage) :-
    accurateOppositionHalfPasses(Id, AccurateOppositionHalfPasses),
    totalOppositionHalfPasses(Id, TotalOppositionHalfPasses),
    handleDivisionByZero(AccurateOppositionHalfPasses, TotalOppositionHalfPasses, Y),
    OppositionHalfPassesPercentage is Y * 100.
    
eval_ageList(Age, Lower_bound, _, _, _, Eval) :-
    Age < Lower_bound,
    Eval is 0.
eval_ageList(Age, Lower_bound, Upper_bound, PercList, Max, Eval) :-
    Age < Upper_bound, Age >= Lower_bound,
    nth0(0, PercList, Perc),
    Eval is Age / Max * Perc.
eval_ageList(Age, _, Upper_bound, PercList, Max, Eval) :-
    Upper_bound =< Age,
    nth0(1, PercList, Perc),
    Eval is Age / Max * Perc.

eval_heightList(Height, Lower_bound, _, _, _, Eval) :-
    Height =< Lower_bound,
    Eval is 0.
eval_heightList(Height, Lower_bound, Upper_bound, PercList, Max, Eval) :-
    Height > Lower_bound,
    Height =< Upper_bound,
    nth0(0, PercList, Perc),
    Eval is Height / Max * Perc.
eval_heightList(Height, _, Upper_bound, PercList, Max, Eval) :-
    Height > Upper_bound,
    nth0(1, PercList, Perc),
    Eval is Height / Max * Perc.

eval_mpList(MinutesPlayed, Min_mp1, _, PercList, Max, Eval) :-
    MinutesPlayed < Min_mp1,
    nth0(0, PercList, Perc),
    Eval is MinutesPlayed / Max * Perc.
eval_mpList(MinutesPlayed, Min_mp1, Min_mp2, PercList, Max, Eval) :-
    MinutesPlayed >= Min_mp1,
    MinutesPlayed < Min_mp2,
    nth0(1, PercList, Perc),
    Eval is Min_mp2 / Max * Perc.
eval_mpList(MinutesPlayed, _, Min_mp2, PercList, Max, Eval) :-
    MinutesPlayed >= Min_mp2,
    nth0(2, PercList, Perc),
    Eval is Min_mp2 / Max * Perc.

eval_penaltyPercentage(PenaltySavedPerc, PenaltyFaced, Threshold, Perc, Eval) :-
    PenaltyFaced < Threshold,
    Eval is PenaltySavedPerc * Perc.
eval_penaltyPercentage(PenaltySavedPerc, PenaltyFaced, Threshold, _, Eval) :-
    PenaltyFaced >= Threshold,
    Eval is PenaltySavedPerc.

evaluate_all_gk(Gk) :-
    get_all_gk(Players),
    evaluate_all_gk(Players, Gk).
evaluate_all_gkBudget(Gk, Budget) :-
    get_all_gk(Budget, Players),
    evaluate_all_gk(Players, Gk).

evaluate_all_gk([], []).
evaluate_all_gk([H | T], Res) :-
    evaluation_gk(H, Eval_local),
    evaluate_all_gk(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_gk(Id, Eval) :-
    is_goal_keeper(Id),
    get_max_age_gk(Max_age),
    get_max_height_gk(Max_height),
    get_max_minutesPlayed_gk(Max_minutesPlayed),
    get_max_Rating_gk(Max_Rating),
    get_max_RedCards_gk(Max_RedCards),
    get_max_PenaltyConceded_gk(Max_PenaltyConceded),
    get_max_OwnGoals_gk(Max_OwnGoals),
    get_max_ErrorLeadToGoal_gk(Max_ErrorLeadToGoal),
    get_max_CleanSheet_gk(Max_CleanSheet),
    get_max_GoalsConcededInsideTheBox_gk(Max_GoalsConcededInsideTheBox),
    get_max_GoalsConcededOutsideTheBox_gk(Max_GoalsConcededOutsideTheBox),
    get_max_GoalsConceded_gk(Max_GoalsConceded),
    age(Id, Age),
    ageWeight(gk, AgeWeightList),
    eval_ageList(Age, 32, 35, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(gk, HeightWeightList),
    eval_heightList(Height, 179, 185, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    redCards(Id, RedCards),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(gk, MpList),
    eval_mpList(MinutesPlayed, 1000, 2500, MpList, Max_minutesPlayed, Eval_mp),
    penaltyConceded(Id, PenaltyConceded),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    ownGoals(Id, OwnGoals),
    errorLeadToGoal(Id, ErrorLeadToGoal),
    saves(Id, Saves),
    goalsConceded(Id, GoalsConceded),
    handleDivisionByZero(GoalsConceded, Saves, Saves_Eval),
    Eval_Saves is (1 - Saves_Eval),
    cleanSheet(Id, CleanSheet),
    penaltyPercentage(Id, PenaltyPercentage),
    penaltyFaced(Id, PenaltyFaced),
    eval_penaltyPercentage(PenaltyPercentage, PenaltyFaced, 3, 0.5, Eval_penaltyPercentage),
    savedShotsFromInsideTheBox(Id, SavedShotsFromInsideTheBox),
    savedShotsFromOutsideTheBox(Id, SavedShotsFromOutsideTheBox), 
    goalsConcededInsideTheBox(Id, GoalsConcededInsideTheBox),
    goalsConcededOutsideTheBox(Id, GoalsConcededOutsideTheBox),
    handleDivisionByZero(GoalsConcededInsideTheBox, SavedShotsFromInsideTheBox, SavesInside_Eval),
    Eval_InsideTheBox is (1 - SavesInside_Eval),
    handleDivisionByZero(GoalsConcededOutsideTheBox, SavedShotsFromOutsideTheBox, SavesOutside_Eval),
    Eval_OutsideTheBox is (1 - SavesOutside_Eval),

    ratingWeight(gk, RatingWeight),
    accuratePassesPercentageWeight(gk, AccuratePassesPercentageWeight),
    redCardsWeight(gk, RedCardsWeight),
    penaltyConcededWeight(gk, PenaltyConcededWeight),
    accurateLongBallsPercentageWeight(gk, AccurateLongBallsPercentageWeight),
    ownGoalsWeight(gk, OwnGoalsWeight),
    errorLeadToGoalWeight(gk, ErrorLeadToGoalWeightWeight),
    savesWeight(gk, SavesWeight),
    cleanSheetWeight(gk, CleanSheetWeight),
    penaltyPercentageWeight(gk, PenaltyPercentageWeight),
    insideTheBoxWeight(gk, InsideTheBoxWeight),
    outsiteTheBoxWeight(gk, OutsiteTheBoxWeight),
    goalsConcededInsideTheBoxWeight(gk, GoalsConcededInsideTheBoxWeight),
    goalsConcededOutsideTheBoxWeight(gk, GoalsConcededOutsideTheBoxWeight),
    goalsConcededWeight(gk, GoalsConcededWeight),

    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyConceded, Max_PenaltyConceded, PenaltyConceded_divided),
    handleDivisionByZero(OwnGoals, Max_OwnGoals, OwnGoals_divided),
    handleDivisionByZero(ErrorLeadToGoal, Max_ErrorLeadToGoal, ErrorLeadToGoal_divided),
    handleDivisionByZero(CleanSheet, Max_CleanSheet, CleanSheet_divided),
    handleDivisionByZero(GoalsConcededInsideTheBox, Max_GoalsConcededInsideTheBox, GoalsConcededInsideTheBox_divided),
    handleDivisionByZero(GoalsConcededOutsideTheBox, Max_GoalsConcededOutsideTheBox, GoalsConcededOutsideTheBox_divided),
    handleDivisionByZero(GoalsConceded, Max_GoalsConceded, GoalsConceded_divided),

    Eval is 
        Eval_age + 
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            RedCards_divided * RedCardsWeight +
            PenaltyConceded_divided * PenaltyConcededWeight +
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight +
            OwnGoals_divided * OwnGoalsWeight +
            ErrorLeadToGoal_divided * ErrorLeadToGoalWeightWeight +
            Eval_Saves * SavesWeight +
            CleanSheet_divided * CleanSheetWeight +
            Eval_penaltyPercentage * PenaltyPercentageWeight +
            Eval_InsideTheBox * InsideTheBoxWeight +
            Eval_OutsideTheBox * OutsiteTheBoxWeight +
            GoalsConcededInsideTheBox_divided * GoalsConcededInsideTheBoxWeight +
            GoalsConcededOutsideTheBox_divided * GoalsConcededOutsideTheBoxWeight +
            GoalsConceded_divided * GoalsConcededWeight
        ) * TournamentValue * Eval_mp.

evaluate_all_dc(Dc) :-
    get_all_dc(Players),
    evaluate_all_dc(Players, Dc).
evaluate_all_dcBudget(Dc, Budget) :-
    get_all_dc(Budget, Players),
    evaluate_all_dc(Players, Dc).

evaluate_all_dc([], []).
evaluate_all_dc([H | T], Res) :-
    evaluation_dc(H, Eval_local),
    evaluate_all_dc(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_dc(Id, Eval) :-
    is_defender_central(Id),
    get_max_age_dc(Max_age),
    get_max_height_dc(Max_height),
    get_max_minutesPlayed_dc(Max_minutesPlayed),
    get_max_Rating_dc(Max_Rating),
    get_max_Goals_dc(Max_Goals),
    get_max_Interceptions_dc(Max_Interceptions),
    get_max_YellowCards_dc(Max_YellowCards),
    get_max_RedCards_dc(Max_RedCards),
    get_max_Clearances_dc(Max_Clearances),
    get_max_ErrorLeadToGoal_dc(Max_ErrorLeadToGoal),
    get_max_Dispossessed_dc(Max_Dispossessed),
    get_max_PossessionLost_dc(Max_PossessionLost),
    get_max_Fouls_dc(Max_Fouls),
    get_max_OwnGoals_dc(Max_OwnGoals),
    get_max_DribbledPast_dc(Max_DribbledPast),
    get_max_PenaltyConceded_dc(Max_PenaltyConceded),
    get_max_ErrorLeadToShot_dc(Max_ErrorLeadToShot),
    get_max_BlockedShots_dc(Max_BlockedShots),
    get_max_GoalsConceded_dc(Max_GoalsConceded),
    get_max_CleanSheet_dc(Max_CleanSheet),
    age(Id, Age),
    ageWeight(dc, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(dc, HeightWeightList),
    eval_heightList(Height, 179, 184, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    interceptions(Id, Interceptions),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(dc, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    clearances(Id, Clearances),
    errorLeadToGoal(Id, ErrorLeadToGoal),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    fouls(Id, Fouls),
    ownGoals(Id, OwnGoals),
    dribbledPast(Id, DribbledPast),
    tacklesWonPercentage(Id, TacklesWonPercentage),
    ownHalfPassesPercentage(Id, OwnHalfPassesPercentage),
    penaltyConceded(Id, PenaltyConceded),
    errorLeadToShot(Id, ErrorLeadToShot),
    blockedShots(Id, BlockedShots),
    goalsConceded(Id, GoalsConceded),
    cleanSheet(Id, CleanSheet),

    ratingWeight(dc, RatingWeight),
    goalsWeight(dc, GoalsWeight),
    accuratePassesPercentageWeight(dc, AccuratePassesPercentageWeight),
    interceptionsWeight(dc, InterceptionsWeight),
    yellowCardsWeight(dc, YellowCardsWeight),
    groundDuelsWonPercentageWeight(dc, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(dc, AerialDuelsWonPercentageWeight),
    redCardsWeight(dc, RedCardsWeight),
    penaltyConcededWeight(dc, PenaltyConcededWeight),
    accurateLongBallsPercentageWeight(dc, AccurateLongBallsPercentageWeight),
    ownHalfPassesPercentageWeight(dc, OwnHalfPassesPercentageWeight),
    clearancesWeight(fb, ClearancesWeight),
    ownGoalsWeight(dc, OwnGoalsWeight),
    errorLeadToGoalWeight(dc, ErrorLeadToGoalWeightWeight),
    errorLeadToShotWeight(dc, ErrorLeadToShotWeight),
    blockedShotsWeight(dc, BlockedShotsWeight),
    dispossessedWeight(dc, DispossessedWeight),
    possessionLostWeight(dc, PossessionLostWeight),
    foulsWeight(dc, FoulsWeight),
    dribbledPastWeight(dc, DribbledPastWeight),
    tacklesWonPercentageWeight(dc, TacklesWonPercentageWeight),
    cleanSheetWeight(dc, CleanSheetWeight),
    goalsConcededWeight(dc, GoalsConcededWeight),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(Interceptions, Max_Interceptions, Interceptions_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(Clearances, Max_Clearances, Clearances_divided),
    handleDivisionByZero(ErrorLeadToGoal, Max_ErrorLeadToGoal, ErrorLeadToGoal_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(Fouls, Max_Fouls, Fouls_divided),
    handleDivisionByZero(OwnGoals, Max_OwnGoals, OwnGoals_divided),
    handleDivisionByZero(DribbledPast, Max_DribbledPast, DribbledPast_divided),
    handleDivisionByZero(PenaltyConceded, Max_PenaltyConceded, PenaltyConceded_divided),
    handleDivisionByZero(ErrorLeadToShot, Max_ErrorLeadToShot, ErrorLeadToShot_divided),
    handleDivisionByZero(BlockedShots, Max_BlockedShots, BlockedShots_divided),
    handleDivisionByZero(GoalsConceded, Max_GoalsConceded, GoalsConceded_divided),
    handleDivisionByZero(CleanSheet, Max_CleanSheet, CleanSheet_divided),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight + 
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight + 
            Interceptions_divided * InterceptionsWeight + 
            YellowCards_divided * YellowCardsWeight + 
            RedCards_divided * RedCardsWeight + 
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight + 
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight + 
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight + 
            Clearances_divided * ClearancesWeight + 
            ErrorLeadToGoal_divided * ErrorLeadToGoalWeightWeight + 
            Dispossessed_divided * DispossessedWeight + 
            PossessionLost_divided * PossessionLostWeight + 
            Fouls_divided * FoulsWeight + 
            OwnGoals_divided * OwnGoalsWeight + 
            DribbledPast_divided * DribbledPastWeight + 
            TacklesWonPercentage / 100 * TacklesWonPercentageWeight + 
            OwnHalfPassesPercentage / 100 * OwnHalfPassesPercentageWeight +
            PenaltyConceded_divided * PenaltyConcededWeight +
            ErrorLeadToShot_divided * ErrorLeadToShotWeight +
            BlockedShots_divided * BlockedShotsWeight +
            GoalsConceded_divided * GoalsConcededWeight +
            CleanSheet_divided * CleanSheetWeight
        ) * TournamentValue * Eval_mp.

evaluate_all_fb(Fb) :-
    get_all_fb(Players),
    evaluate_all_fb(Players, Fb).
evaluate_all_fbBudget(Fb, Budget) :-
    get_all_fb(Budget, Players),
    evaluate_all_fb(Players, Fb).

evaluate_all_fb([], []).
evaluate_all_fb([H | T], Res) :-
    evaluation_fb(H, Eval_local),
    evaluate_all_fb(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_fb(Id, Eval) :-
    is_fullback(Id),
    get_max_age_fb(Max_age),
    get_max_height_fb(Max_height),
    get_max_minutesPlayed_fb(Max_minutesPlayed),
    get_max_Rating_fb(Max_Rating),
    get_max_Goals_fb(Max_Goals),
    get_max_BigChancesCreated_fb(Max_BigChancesCreated),
    get_max_AccurateFinalThirdPasses_fb(Max_AccurateFinalThirdPasses),
    get_max_KeyPasses_fb(Max_KeyPasses),
    get_max_Interceptions_fb(Max_Interceptions),
    get_max_YellowCards_fb(Max_YellowCards),
    get_max_RedCards_fb(Max_RedCards),
    get_max_PenaltyConceded_fb(Max_PenaltyConceded),
    get_max_PenaltyWon_fb(Max_PenaltyWon),
    get_max_Clearances_fb(Max_Clearances),
    get_max_ErrorLeadToGoal_fb(Max_ErrorLeadToGoal),
    get_max_Dispossessed_fb(Max_Dispossessed),
    get_max_PossessionLost_fb(Max_PossessionLost),
    get_max_PossessionWonAttThird_fb(Max_PossessionWonAttThird),
    get_max_WasFouled_fb(Max_WasFouled),
    get_max_Fouls_fb(Max_Fouls),
    get_max_OwnGoals_fb(Max_OwnGoals),
    get_max_DribbledPast_fb(Max_DribbledPast),
    get_max_Assists_fb(Max_Assists),
    get_max_ErrorLeadToShot_fb(Max_ErrorLeadToShot),
    get_max_BlockedShots_fb(Max_BlockedShots),
    get_max_GoalsConceded_fb(Max_GoalsConceded),
    get_max_CleanSheet_fb(Max_CleanSheet),
    age(Id, Age),
    ageWeight(fb, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(fb, HeightWeightList),
    eval_heightList(Height, 176, 182, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    accurateFinalThirdPasses(Id, AccurateFinalThirdPasses),
    keyPasses(Id, KeyPasses),
    successfulDribblesPercentage(Id, SuccessfulDribblesPercentage),
    interceptions(Id, Interceptions),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    penaltyConceded(Id, PenaltyConceded),
    accurateCrossesPercentage(Id, AccurateCrossesPercentage),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(fb, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    penaltyWon(Id, PenaltyWon),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    clearances(Id, Clearances),
    errorLeadToGoal(Id, ErrorLeadToGoal),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    possessionWonAttThird(Id, PossessionWonAttThird),
    wasFouled(Id, WasFouled),
    fouls(Id, Fouls),
    ownGoals(Id, OwnGoals),
    dribbledPast(Id, DribbledPast),
    tacklesWonPercentage(Id, TacklesWonPercentage),
    ownHalfPassesPercentage(Id, OwnHalfPassesPercentage),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    errorLeadToShot(Id, ErrorLeadToShot),
    blockedShots(Id, BlockedShots),
    goalsConceded(Id, GoalsConceded),
    cleanSheet(Id, CleanSheet),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(AccurateFinalThirdPasses, Max_AccurateFinalThirdPasses, AccurateFinalThirdPasses_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(Interceptions, Max_Interceptions, Interceptions_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyConceded, Max_PenaltyConceded, PenaltyConceded_divided),
    handleDivisionByZero(PenaltyWon, Max_PenaltyWon, PenaltyWon_divided),
    handleDivisionByZero(Clearances, Max_Clearances, Clearances_divided),
    handleDivisionByZero(ErrorLeadToGoal, Max_ErrorLeadToGoal, ErrorLeadToGoal_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(PossessionWonAttThird, Max_PossessionWonAttThird, PossessionWonAttThird_divided),
    handleDivisionByZero(WasFouled, Max_WasFouled, WasFouled_divided),
    handleDivisionByZero(Fouls, Max_Fouls, Fouls_divided),
    handleDivisionByZero(OwnGoals, Max_OwnGoals, OwnGoals_divided),
    handleDivisionByZero(DribbledPast, Max_DribbledPast, DribbledPast_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),
    handleDivisionByZero(ErrorLeadToShot, Max_ErrorLeadToShot, ErrorLeadToShot_divided),
    handleDivisionByZero(BlockedShots, Max_BlockedShots, BlockedShots_divided),
    handleDivisionByZero(GoalsConceded, Max_GoalsConceded, GoalsConceded_divided),
    handleDivisionByZero(CleanSheet, Max_CleanSheet, CleanSheet_divided),

    ratingWeight(fb, RatingWeight),
    goalsWeight(fb, GoalsWeight),
    bigChancesCreatedWeight(fb, BigChancesCreatedWeight),
    accuratePassesPercentageWeight(fb, AccuratePassesPercentageWeight),
    accurateFinalThirdPassesWeight(fb, AccurateFinalThirdPassesWeight),
    keyPassesWeight(fb, KeyPassesWeight),
    successfulDribblesPercentageWeight(fb, SuccessfulDribblesPercentageWeight),
    interceptionsWeight(fb, InterceptionsWeight),
    yellowCardsWeight(fb, YellowCardsWeight),
    redCardsWeight(fb, RedCardsWeight),
    penaltyConcededWeight(fb, PenaltyConcededWeight),
    accurateCrossesPercentageWeight(fb, AccurateCrossesPercentageWeight),
    groundDuelsWonPercentageWeight(fb, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(fb, AerialDuelsWonPercentageWeight),
    penaltyWonWeight(fb, PenaltyWonWeight),
    accurateLongBallsPercentageWeight(fb, AccurateLongBallsPercentageWeight),
    clearancesWeight(fb, ClearancesWeight),
    errorLeadToGoalWeight(fb, ErrorLeadToGoalWeightWeight),
    dispossessedWeight(fb, DispossessedWeight),
    possessionLostWeight(fb, PossessionLostWeight),
    possessionWonAttThirdWeight(fb, PossessionWonAttThirdWeight),
    wasFouledWeight(fb, WasFouledWeight),
    foulsWeight(fb, FoulsWeight),
    ownGoalsWeight(fb, OwnGoalsWeight),
    dribbledPastWeight(fb, DribbledPastWeight),    
    tacklesWonPercentageWeight(fb, TacklesWonPercentageWeight),
    ownHalfPassesPercentageWeight(fb, OwnHalfPassesPercentageWeight),
    oppositionHalfPassesPercentageWeight(fb, OppositionHalfPassesPercentageWeight),
    assistsWeight(fb, AssistsWeight),
    errorLeadToShotWeight(fb, ErrorLeadToShotWeight),
    blockedShotsWeight(fb, BlockedShotsWeight),
    goalsConcededWeight(fb, GoalsConcededWeight),
    cleanSheetWeight(fb, CleanSheetWeight),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight +
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            AccurateFinalThirdPasses_divided * AccurateFinalThirdPassesWeight +
            KeyPasses_divided * KeyPassesWeight +
            SuccessfulDribblesPercentage / 100 * SuccessfulDribblesPercentageWeight +
            Interceptions_divided * InterceptionsWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            PenaltyConceded_divided * PenaltyConcededWeight + 
            AccurateCrossesPercentage / 100 * AccurateCrossesPercentageWeight +
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            PenaltyWon_divided * PenaltyWonWeight +
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight +
            Clearances_divided * ClearancesWeight +
            ErrorLeadToGoal_divided * ErrorLeadToGoalWeightWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            PossessionWonAttThird_divided * PossessionWonAttThirdWeight +
            WasFouled_divided * WasFouledWeight +
            Fouls_divided * FoulsWeight +
            OwnGoals_divided * OwnGoalsWeight +
            DribbledPast_divided * DribbledPastWeight +
            TacklesWonPercentage / 100 * TacklesWonPercentageWeight +
            OwnHalfPassesPercentage / 100 * OwnHalfPassesPercentageWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            Assists_divided * AssistsWeight +
            ErrorLeadToShot_divided * ErrorLeadToShotWeight +
            BlockedShots_divided * BlockedShotsWeight +
            GoalsConceded_divided * GoalsConcededWeight +
            CleanSheet_divided * CleanSheetWeight
        ) * TournamentValue * Eval_mp.

evaluate_all_dm(Dm) :-
    get_all_dm(Players),
    evaluate_all_dm(Players, Dm).
evaluate_all_dmBudget(Dm, Budget) :-
    get_all_dm(Budget, Players),
    evaluate_all_dm(Players, Dm).

evaluate_all_dm([], []).
evaluate_all_dm([H | T], Res) :-
    evaluation_dm(H, Eval_local),
    evaluate_all_dm(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_dm(Id, Eval) :-
    is_dm(Id),
    get_max_age_dm(Max_age),
    get_max_height_dm(Max_height),
    get_max_minutesPlayed_dm(Max_minutesPlayed),
    get_max_Rating_dm(Max_Rating),
    get_max_Goals_dm(Max_Goals),
    get_max_BigChancesCreated_dm(Max_BigChancesCreated),
    get_max_KeyPasses_dm(Max_KeyPasses),
    get_max_Interceptions_dm(Max_Interceptions),
    get_max_YellowCards_dm(Max_YellowCards),
    get_max_RedCards_dm(Max_RedCards),
    get_max_PenaltyConceded_dm(Max_PenaltyConceded),
    get_max_ErrorLeadToGoal_dm(Max_ErrorLeadToGoal),
    get_max_Dispossessed_dm(Max_Dispossessed),
    get_max_PossessionLost_dm(Max_PossessionLost),
    get_max_Fouls_dm(Max_Fouls),
    get_max_OwnGoals_dm(Max_OwnGoals),
    get_max_DribbledPast_dm(Max_DribbledPast),
    get_max_Assists_dm(Max_Assists),
    get_max_ErrorLeadToShot_dm(Max_ErrorLeadToShot),
    get_max_BlockedShots_dm(Max_BlockedShots),
    get_max_GoalsConceded_dm(Max_GoalsConceded),
    get_max_CleanSheet_dm(Max_CleanSheet),
    get_max_PassToAssist_dm(Max_PassToAssist),
    age(Id, Age),
    ageWeight(dm, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(dm, HeightWeightList),
    eval_heightList(Height, 176, 182, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    keyPasses(Id, KeyPasses),
    successfulDribblesPercentage(Id, SuccessfulDribblesPercentage),
    interceptions(Id, Interceptions),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    penaltyConceded(Id, PenaltyConceded),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(dm, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    errorLeadToGoal(Id, ErrorLeadToGoal),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    fouls(Id, Fouls),
    ownGoals(Id, OwnGoals),
    dribbledPast(Id, DribbledPast),
    tacklesWonPercentage(Id, TacklesWonPercentage),
    ownHalfPassesPercentage(Id, OwnHalfPassesPercentage),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    errorLeadToShot(Id, ErrorLeadToShot),
    blockedShots(Id, BlockedShots),
    goalsConceded(Id, GoalsConceded),
    cleanSheet(Id, CleanSheet),
    passToAssist(Id, PassToAssist),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(Interceptions, Max_Interceptions, Interceptions_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyConceded, Max_PenaltyConceded, PenaltyConceded_divided),
    handleDivisionByZero(ErrorLeadToGoal, Max_ErrorLeadToGoal, ErrorLeadToGoal_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(Fouls, Max_Fouls, Fouls_divided),
    handleDivisionByZero(OwnGoals, Max_OwnGoals, OwnGoals_divided),
    handleDivisionByZero(DribbledPast, Max_DribbledPast, DribbledPast_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),
    handleDivisionByZero(ErrorLeadToShot, Max_ErrorLeadToShot, ErrorLeadToShot_divided),
    handleDivisionByZero(BlockedShots, Max_BlockedShots, BlockedShots_divided),
    handleDivisionByZero(GoalsConceded, Max_GoalsConceded, GoalsConceded_divided),
    handleDivisionByZero(CleanSheet, Max_CleanSheet, CleanSheet_divided),
    handleDivisionByZero(PassToAssist, Max_PassToAssist, PassToAssist_divided),

    ratingWeight(dm, RatingWeight),
    goalsWeight(dm, GoalsWeight),
    bigChancesCreatedWeight(dm, BigChancesCreatedWeight),
    accuratePassesPercentageWeight(dm, AccuratePassesPercentageWeight),
    keyPassesWeight(dm, KeyPassesWeight),
    successfulDribblesPercentageWeight(dm, SuccessfulDribblesPercentageWeight),
    interceptionsWeight(dm, InterceptionsWeight),
    yellowCardsWeight(dm, YellowCardsWeight),
    redCardsWeight(dm, RedCardsWeight),
    penaltyConcededWeight(dm, PenaltyConcededWeight),
    groundDuelsWonPercentageWeight(dm, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(dm, AerialDuelsWonPercentageWeight),
    accurateLongBallsPercentageWeight(dm, AccurateLongBallsPercentageWeight),
    errorLeadToGoalWeight(dm, ErrorLeadToGoalWeightWeight),
    dispossessedWeight(dm, DispossessedWeight),
    possessionLostWeight(dm, PossessionLostWeight),
    tacklesWonPercentageWeight(dm, TacklesWonPercentageWeight),
    assistsWeight(dm, AssistsWeight),
    dribbledPastWeight(dm, DribbledPastWeight),
    ownHalfPassesPercentageWeight(dm, OwnHalfPassesPercentageWeight),
    oppositionHalfPassesPercentageWeight(dm, OppositionHalfPassesPercentageWeight),
    foulsWeight(dm, FoulsWeight),
    ownGoalsWeight(dm, OwnGoalsWeight),
    errorLeadToShotWeight(dm, ErrorLeadToShotWeight),
    blockedShotsWeight(dm, BlockedShotsWeight),
    passToAssistWeight(dm, PassToAssistWeight),
    goalsConcededWeight(dm, GoalsConcededWeight),
    cleanSheetWeight(dm, CleanSheetWeight),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight +
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            KeyPasses_divided * KeyPassesWeight +
            SuccessfulDribblesPercentage / 100 * SuccessfulDribblesPercentageWeight +
            Interceptions_divided * InterceptionsWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            PenaltyConceded_divided * PenaltyConcededWeight + 
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight +
            ErrorLeadToGoal_divided * ErrorLeadToGoalWeightWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            TacklesWonPercentage / 100 * TacklesWonPercentageWeight +
            Assists_divided * AssistsWeight +
            DribbledPast_divided * DribbledPastWeight +
            OwnHalfPassesPercentage / 100 * OwnHalfPassesPercentageWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            Fouls_divided * FoulsWeight +
            OwnGoals_divided * OwnGoalsWeight +
            ErrorLeadToShot_divided * ErrorLeadToShotWeight +
            BlockedShots_divided * BlockedShotsWeight +
            PassToAssist_divided * PassToAssistWeight +
            GoalsConceded_divided * GoalsConcededWeight +
            CleanSheet_divided * CleanSheetWeight
        ) * TournamentValue * Eval_mp.

evaluate_all_mc(Mc) :-
    get_all_mc(Players),
    evaluate_all_mc(Players, Mc).
evaluate_all_mcBudget(Mc, Budget) :-
    get_all_mc(Budget, Players),
    evaluate_all_mc(Players, Mc).

evaluate_all_mc([], []).
evaluate_all_mc([H | T], Res) :-
    evaluation_mc(H, Eval_local),
    evaluate_all_mc(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_mc(Id, Eval) :-
    is_mc(Id),
    get_max_age_mc(Max_age),
    get_max_height_mc(Max_height),
    get_max_minutesPlayed_mc(Max_minutesPlayed),
    get_max_Rating_mc(Max_Rating),
    get_max_Goals_mc(Max_Goals),
    get_max_BigChancesCreated_mc(Max_BigChancesCreated),
    get_max_AccurateFinalThirdPasses_mc(Max_AccurateFinalThirdPasses),
    get_max_KeyPasses_mc(Max_KeyPasses),
    get_max_Interceptions_mc(Max_Interceptions),
    get_max_YellowCards_mc(Max_YellowCards),
    get_max_RedCards_mc(Max_RedCards),
    get_max_PenaltyConceded_mc(Max_PenaltyConceded),
    get_max_ErrorLeadToGoal_mc(Max_ErrorLeadToGoal),
    get_max_Dispossessed_mc(Max_Dispossessed),
    get_max_PossessionLost_mc(Max_PossessionLost),
    get_max_PossessionWonAttThird_mc(Max_PossessionWonAttThird),
    get_max_Fouls_mc(Max_Fouls),
    get_max_OwnGoals_mc(Max_OwnGoals),
    get_max_DribbledPast_mc(Max_DribbledPast),
    get_max_Assists_mc(Max_Assists),
    get_max_ErrorLeadToShot_mc(Max_ErrorLeadToShot),
    get_max_GoalsConceded_mc(Max_GoalsConceded),
    get_max_PassToAssist_mc(Max_PassToAssist),
    age(Id, Age),
    ageWeight(mc, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(mc, HeightWeightList),
    eval_heightList(Height, 175, 181, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    accurateFinalThirdPasses(Id, AccurateFinalThirdPasses),
    keyPasses(Id, KeyPasses),
    successfulDribblesPercentage(Id, SuccessfulDribblesPercentage),
    interceptions(Id, Interceptions),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    penaltyConceded(Id, PenaltyConceded),
    accurateCrossesPercentage(Id, AccurateCrossesPercentage),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(mc, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    errorLeadToGoal(Id, ErrorLeadToGoal),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    possessionWonAttThird(Id, PossessionWonAttThird),
    fouls(Id, Fouls),
    ownGoals(Id, OwnGoals),
    dribbledPast(Id, DribbledPast),
    tacklesWonPercentage(Id, TacklesWonPercentage),
    ownHalfPassesPercentage(Id, OwnHalfPassesPercentage),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    errorLeadToShot(Id, ErrorLeadToShot),
    goalsConceded(Id, GoalsConceded),
    passToAssist(Id, PassToAssist),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(AccurateFinalThirdPasses, Max_AccurateFinalThirdPasses, AccurateFinalThirdPasses_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(Interceptions, Max_Interceptions, Interceptions_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyConceded, Max_PenaltyConceded, PenaltyConceded_divided),
    handleDivisionByZero(ErrorLeadToGoal, Max_ErrorLeadToGoal, ErrorLeadToGoal_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(PossessionWonAttThird, Max_PossessionWonAttThird, PossessionWonAttThird_divided),
    handleDivisionByZero(Fouls, Max_Fouls, Fouls_divided),
    handleDivisionByZero(OwnGoals, Max_OwnGoals, OwnGoals_divided),
    handleDivisionByZero(DribbledPast, Max_DribbledPast, DribbledPast_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),
    handleDivisionByZero(ErrorLeadToShot, Max_ErrorLeadToShot, ErrorLeadToShot_divided),
    handleDivisionByZero(GoalsConceded, Max_GoalsConceded, GoalsConceded_divided),
    handleDivisionByZero(PassToAssist, Max_PassToAssist, PassToAssist_divided),

    ratingWeight(mc, RatingWeight),
    goalsWeight(mc, GoalsWeight),
    bigChancesCreatedWeight(mc, BigChancesCreatedWeight),
    accuratePassesPercentageWeight(mc, AccuratePassesPercentageWeight),
    keyPassesWeight(mc, KeyPassesWeight),
    successfulDribblesPercentageWeight(mc, SuccessfulDribblesPercentageWeight),
    interceptionsWeight(mc, InterceptionsWeight),
    yellowCardsWeight(mc, YellowCardsWeight),
    redCardsWeight(mc, RedCardsWeight),
    accurateCrossesPercentageWeight(fb, AccurateCrossesPercentageWeight),
    penaltyConcededWeight(mc, PenaltyConcededWeight),
    groundDuelsWonPercentageWeight(mc, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(mc, AerialDuelsWonPercentageWeight),
    accurateLongBallsPercentageWeight(mc, AccurateLongBallsPercentageWeight),
    errorLeadToGoalWeight(mc, ErrorLeadToGoalWeightWeight),
    dispossessedWeight(mc, DispossessedWeight),
    possessionLostWeight(mc, PossessionLostWeight),
    tacklesWonPercentageWeight(mc, TacklesWonPercentageWeight),
    assistsWeight(mc, AssistsWeight),
    dribbledPastWeight(mc, DribbledPastWeight),
    ownHalfPassesPercentageWeight(mc, OwnHalfPassesPercentageWeight),
    oppositionHalfPassesPercentageWeight(mc, OppositionHalfPassesPercentageWeight),
    accurateFinalThirdPassesWeight(mc, AccurateFinalThirdPassesWeight),
    foulsWeight(mc, FoulsWeight),
    ownGoalsWeight(mc, OwnGoalsWeight),
    errorLeadToShotWeight(mc, ErrorLeadToShotWeight),
    passToAssistWeight(mc, PassToAssistWeight),
    goalsConcededWeight(mc, GoalsConcededWeight),
    possessionWonAttThirdWeight(mc, PossessionWonAttThirdWeight),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight +
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            KeyPasses_divided * KeyPassesWeight +
            SuccessfulDribblesPercentage / 100 * SuccessfulDribblesPercentageWeight +
            Interceptions_divided * InterceptionsWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            AccurateCrossesPercentage / 100 * AccurateCrossesPercentageWeight +
            PenaltyConceded_divided * PenaltyConcededWeight + 
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight +
            ErrorLeadToGoal_divided * ErrorLeadToGoalWeightWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            TacklesWonPercentage / 100 * TacklesWonPercentageWeight +
            Assists_divided * AssistsWeight +
            DribbledPast_divided * DribbledPastWeight +
            OwnHalfPassesPercentage / 100 * OwnHalfPassesPercentageWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            AccurateFinalThirdPasses_divided * AccurateFinalThirdPassesWeight +
            Fouls_divided * FoulsWeight +
            OwnGoals_divided * OwnGoalsWeight +
            ErrorLeadToShot_divided * ErrorLeadToShotWeight +
            PassToAssist_divided * PassToAssistWeight +
            GoalsConceded_divided * GoalsConcededWeight +
            PossessionWonAttThird_divided * PossessionWonAttThirdWeight
        ) * TournamentValue * Eval_mp.

attributeMalusOffRole(Id, MalusOffRole) :-
    mainPosition(Id, mc),
    MalusOffRole is 0.6.

attributeMalusOffRole(Id, MalusOffRole) :-
    secondPosition(Id, st),
    MalusOffRole is 0.7.
    
attributeMalusOffRole(Id, MalusOffRole) :-
    \+mainPosition(Id, mc),
    \+secondPosition(Id, st),
    MalusOffRole is 1.

evaluate_all_am(Am) :-
    get_all_am(Players),
    evaluate_all_am(Players, Am).
evaluate_all_amBudget(Am, Budget) :-
    get_all_am(Budget, Players),
    evaluate_all_am(Players, Am).

evaluate_all_am([], []).
evaluate_all_am([H | T], Res) :-
    evaluation_am(H, Eval_local),
    evaluate_all_am(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_am(Id, Eval) :-
    is_am(Id),
    get_max_age_am(Max_age),
    get_max_height_am(Max_height),
    get_max_minutesPlayed_am(Max_minutesPlayed),
    get_max_Rating_am(Max_Rating),
    get_max_Goals_am(Max_Goals),
    get_max_BigChancesCreated_am(Max_BigChancesCreated),
    get_max_BigChancesMissed_am(Max_BigChancesMissed),
    get_max_AccurateFinalThirdPasses_am(Max_AccurateFinalThirdPasses),
    get_max_KeyPasses_am(Max_KeyPasses),
    get_max_Interceptions_am(Max_Interceptions),
    get_max_YellowCards_am(Max_YellowCards),
    get_max_RedCards_am(Max_RedCards),
    get_max_PenaltyWon_am(Max_PenaltyWon),
    get_max_Dispossessed_am(Max_Dispossessed),
    get_max_PossessionLost_am(Max_PossessionLost),
    get_max_PossessionWonAttThird_am(Max_PossessionWonAttThird),
    get_max_WasFouled_am(Max_WasFouled),
    get_max_Assists_am(Max_Assists),
    get_max_PassToAssist_am(Max_PassToAssist),
    age(Id, Age),
    ageWeight(am, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(am, HeightWeightList),
    eval_heightList(Height, 175, 181, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    bigChancesMissed(Id, BigChancesMissed),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    accurateFinalThirdPasses(Id, AccurateFinalThirdPasses),
    keyPasses(Id, KeyPasses),
    successfulDribblesPercentage(Id, SuccessfulDribblesPercentage),
    interceptions(Id, Interceptions),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    accurateCrossesPercentage(Id, AccurateCrossesPercentage),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(am, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    penaltyWon(Id, PenaltyWon),
    accurateLongBallsPercentage(Id, AccurateLongBallsPercentage),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    possessionWonAttThird(Id, PossessionWonAttThird),
    wasFouled(Id, WasFouled),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    passToAssist(Id, PassToAssist),
    goalConversionPercentage(Id, GoalConversionPercentage),
    scoringFrequency(Id, ScoringFrequency),

    handleDivisionByZero(ScoringFrequency, MinutesPlayed, Scoring_Frequency_divided),
    Eval_Scoring_Frequency is (1 - (Scoring_Frequency_divided)),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(BigChancesMissed, Max_BigChancesMissed, BigChancesMissed_divided),
    handleDivisionByZero(AccurateFinalThirdPasses, Max_AccurateFinalThirdPasses, AccurateFinalThirdPasses_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(Interceptions, Max_Interceptions, Interceptions_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyWon, Max_PenaltyWon, PenaltyWon_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(PossessionWonAttThird, Max_PossessionWonAttThird, PossessionWonAttThird_divided),
    handleDivisionByZero(WasFouled, Max_WasFouled, WasFouled_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),
    handleDivisionByZero(PassToAssist, Max_PassToAssist, PassToAssist_divided),

    ratingWeight(am, RatingWeight),
    goalsWeight(am, GoalsWeight),
    bigChancesMissedWeight(am, BigChancesMissedWeight),
    bigChancesCreatedWeight(am, BigChancesCreatedWeight),
    keyPassesWeight(am, KeyPassesWeight),
    successfulDribblesPercentageWeight(am, SuccessfulDribblesPercentageWeight),
    interceptionsWeight(am, InterceptionsWeight),
    yellowCardsWeight(am, YellowCardsWeight),
    redCardsWeight(am, RedCardsWeight),
    accuratePassesPercentageWeight(am, AccuratePassesPercentageWeight),
    accurateCrossesPercentageWeight(am, AccurateCrossesPercentageWeight),
    groundDuelsWonPercentageWeight(am, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(am, AerialDuelsWonPercentageWeight),
    accurateLongBallsPercentageWeight(am, AccurateLongBallsPercentageWeight),
    dispossessedWeight(am, DispossessedWeight),
    possessionLostWeight(am, PossessionLostWeight),
    assistsWeight(am, AssistsWeight),
    penaltyWonWeight(am, PenaltyWonWeight),
    oppositionHalfPassesPercentageWeight(am, OppositionHalfPassesPercentageWeight),
    accurateFinalThirdPassesWeight(am, AccurateFinalThirdPassesWeight),
    passToAssistWeight(am, PassToAssistWeight),
    possessionWonAttThirdWeight(am, PossessionWonAttThirdWeight),
    wasFouledWeight(am, WasFouledWeight),
    goalConversionPercentageWeight(am, GoalConversionPercentageWeight),
    scoringFrequencyWeight(am, ScoringFrequencyWeight),

    attributeMalusOffRole(Id, MalusOffRole),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight * MalusOffRole + 
            Goals_divided * GoalsWeight * MalusOffRole +
            BigChancesMissed_divided * BigChancesMissedWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight * MalusOffRole +
            KeyPasses_divided * KeyPassesWeight * MalusOffRole +
            SuccessfulDribblesPercentage / 100 * SuccessfulDribblesPercentageWeight +
            Interceptions_divided * InterceptionsWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            AccurateCrossesPercentage / 100 * AccurateCrossesPercentageWeight +
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            AccurateLongBallsPercentage / 100 * AccurateLongBallsPercentageWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            Assists_divided * AssistsWeight * MalusOffRole +
            PenaltyWon_divided * PenaltyWonWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            AccurateFinalThirdPasses_divided * AccurateFinalThirdPassesWeight +
            PassToAssist_divided * PassToAssistWeight * MalusOffRole +
            PossessionWonAttThird_divided * PossessionWonAttThirdWeight +
            WasFouled_divided * WasFouledWeight +
            GoalConversionPercentage / 100 * GoalConversionPercentageWeight * MalusOffRole +
            Eval_Scoring_Frequency * ScoringFrequencyWeight * MalusOffRole
        ) * TournamentValue * Eval_mp.

evaluate_all_st(St) :-
    get_all_st(Players),
    evaluate_all_st(Players, St).
evaluate_all_stBudget(St, Budget) :-
    get_all_st(Budget, Players),
    evaluate_all_st(Players, St).

evaluate_all_st([], []).
evaluate_all_st([H | T], Res) :-
    evaluation_st(H, Eval_local),
    evaluate_all_st(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_st(Id, Eval) :-
    is_st(Id),
    get_max_age_st(Max_age),
    get_max_height_st(Max_height),
    get_max_minutesPlayed_st(Max_minutesPlayed),
    get_max_Rating_st(Max_Rating),
    get_max_Goals_st(Max_Goals),
    get_max_BigChancesCreated_st(Max_BigChancesCreated),
    get_max_AccurateFinalThirdPasses_st(Max_AccurateFinalThirdPasses),
    get_max_KeyPasses_st(Max_KeyPasses),
    get_max_YellowCards_st(Max_YellowCards),
    get_max_RedCards_st(Max_RedCards),
    get_max_Dispossessed_st(Max_Dispossessed),
    get_max_PossessionLost_st(Max_PossessionLost),
    get_max_WasFouled_st(Max_WasFouled),
    get_max_Assists_st(Max_Assists),
    age(Id, Age),
    ageWeight(st, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(st, HeightWeightList),
    eval_heightList(Height, 179, 185, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    bigChancesMissed(Id, BigChancesMissed),
    accurateFinalThirdPasses(Id, AccurateFinalThirdPasses),
    keyPasses(Id, KeyPasses),
    successfulDribblesPercentage(Id, SuccessfulDribblesPercentage),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(st, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    wasFouled(Id, WasFouled),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    goalConversionPercentage(Id, GoalConversionPercentage),
    scoringFrequency(Id, ScoringFrequency),
    totalShots(Id, TotalShots),

    handleDivisionByZero(ScoringFrequency, MinutesPlayed, Scoring_Frequency_divided),
    Eval_Scoring_Frequency is (1 - (Scoring_Frequency_divided)),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(BigChancesMissed, TotalShots, BigChancesMissed_divided),
    handleDivisionByZero(AccurateFinalThirdPasses, Max_AccurateFinalThirdPasses, AccurateFinalThirdPasses_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(WasFouled, Max_WasFouled, WasFouled_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),

    ratingWeight(st, RatingWeight),
    goalsWeight(st, GoalsWeight),
    bigChancesMissedWeight(st, BigChancesMissedWeight),
    bigChancesCreatedWeight(st, BigChancesCreatedWeight),
    keyPassesWeight(st, KeyPassesWeight),
    successfulDribblesPercentageWeight(st, SuccessfulDribblesPercentageWeight),
    yellowCardsWeight(st, YellowCardsWeight),
    redCardsWeight(st, RedCardsWeight),
    groundDuelsWonPercentageWeight(st, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(st, AerialDuelsWonPercentageWeight),
    dispossessedWeight(st, DispossessedWeight),
    possessionLostWeight(st, PossessionLostWeight),
    assistsWeight(st, AssistsWeight),
    oppositionHalfPassesPercentageWeight(st, OppositionHalfPassesPercentageWeight),
    accurateFinalThirdPassesWeight(st, AccurateFinalThirdPassesWeight),
    wasFouledWeight(st, WasFouledWeight),
    goalConversionPercentageWeight(st, GoalConversionPercentageWeight),
    scoringFrequencyWeight(st, ScoringFrequencyWeight),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight +
            BigChancesMissed_divided * BigChancesMissedWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight +
            KeyPasses_divided * KeyPassesWeight +
            SuccessfulDribblesPercentage / 100 * SuccessfulDribblesPercentageWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            Assists_divided * AssistsWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            AccurateFinalThirdPasses_divided * AccurateFinalThirdPassesWeight +
            WasFouled_divided * WasFouledWeight +
            GoalConversionPercentage / 100 * GoalConversionPercentageWeight +
            Eval_Scoring_Frequency * ScoringFrequencyWeight
        ) * TournamentValue * Eval_mp.

evaluate_all_w(W) :-
    get_all_w(Players),
    evaluate_all_w(Players, W).
evaluate_all_wBudget(W, Budget) :-
    get_all_w(Budget, Players),
    evaluate_all_w(Players, W).

evaluate_all_w([], []).
evaluate_all_w([H | T], Res) :-
    evaluation_w(H, Eval_local),
    evaluate_all_w(T, Eval_down),
    name(H, Name),
    append([[Name, Eval_local]], Eval_down, Res).

evaluation_w(Id, Eval) :-
    is_w(Id),
    get_max_age_w(Max_age),
    get_max_height_w(Max_height),
    get_max_minutesPlayed_w(Max_minutesPlayed),
    get_max_Rating_w(Max_Rating),
    get_max_Goals_w(Max_Goals),
    get_max_BigChancesCreated_w(Max_BigChancesCreated),
    get_max_AccurateFinalThirdPasses_w(Max_AccurateFinalThirdPasses),
    get_max_KeyPasses_w(Max_KeyPasses),
    get_max_YellowCards_w(Max_YellowCards),
    get_max_RedCards_w(Max_RedCards),
    get_max_PenaltyWon_w(Max_PenaltyWon),
    get_max_Dispossessed_w(Max_Dispossessed),
    get_max_PossessionLost_w(Max_PossessionLost),
    get_max_WasFouled_w(Max_WasFouled),
    get_max_Assists_w(Max_Assists),
    get_max_CleanSheet_w(Max_CleanSheet),
    get_max_PassToAssist_w(Max_PassToAssist),
    get_max_SuccessfulDribbles_w(Max_SuccessfulDribbles),
    age(Id, Age),
    ageWeight(w, AgeWeightList),
    eval_ageList(Age, 29, 32, AgeWeightList, Max_age, Eval_age),
    height(Id, Height),
    heightWeight(w, HeightWeightList),
    eval_heightList(Height, 179, 183, HeightWeightList, Max_height, Eval_height),
    lastTournamentPlayed(Id, Tournament),
    tournamentValue(Tournament, TournamentValue),
    rating(Id, Rating),
    Eval_Rating is (1 - (Max_Rating - Rating)),
    goals(Id, Goals),
    bigChancesCreated(Id, BigChancesCreated),
    bigChancesMissed(Id, BigChancesMissed),
    accuratePassesPercentage(Id, AccuratePassesPercentage),
    accurateFinalThirdPasses(Id, AccurateFinalThirdPasses),
    keyPasses(Id, KeyPasses),
    yellowCards(Id, YellowCards),
    redCards(Id, RedCards),
    accurateCrossesPercentage(Id, AccurateCrossesPercentage),
    groundDuelsWonPercentage(Id, GroundDuelsWonPercentage),
    aerialDuelsWonPercentage(Id, AerialDuelsWonPercentage),
    minutesPlayed(Id, MinutesPlayed),
    mpWeight(w, MpList),
    eval_mpList(MinutesPlayed, 1000, 2000, MpList, Max_minutesPlayed, Eval_mp),
    penaltyWon(Id, PenaltyWon),
    dispossessed(Id, Dispossessed),
    possessionLost(Id, PossessionLost),
    wasFouled(Id, WasFouled),
    oppositionHalfPassesPercentage(Id, OppositionHalfPassesPercentage),
    assists(Id, Assists),
    cleanSheet(Id, CleanSheet),
    passToAssist(Id, PassToAssist),
    totalShots(Id, TotalShots),
    successfulDribbles(Id, SuccessfulDribbles),
    goalConversionPercentage(Id, GoalConversionPercentage),

    handleDivisionByZero(Goals, Max_Goals, Goals_divided),
    handleDivisionByZero(BigChancesCreated, Max_BigChancesCreated, BigChancesCreated_divided),
    handleDivisionByZero(BigChancesMissed, TotalShots, BigChancesMissed_divided),
    handleDivisionByZero(AccurateFinalThirdPasses, Max_AccurateFinalThirdPasses, AccurateFinalThirdPasses_divided),
    handleDivisionByZero(KeyPasses, Max_KeyPasses, KeyPasses_divided),
    handleDivisionByZero(YellowCards, Max_YellowCards, YellowCards_divided),
    handleDivisionByZero(RedCards, Max_RedCards, RedCards_divided),
    handleDivisionByZero(PenaltyWon, Max_PenaltyWon, PenaltyWon_divided),
    handleDivisionByZero(Dispossessed, Max_Dispossessed, Dispossessed_divided),
    handleDivisionByZero(PossessionLost, Max_PossessionLost, PossessionLost_divided),
    handleDivisionByZero(WasFouled, Max_WasFouled, WasFouled_divided),
    handleDivisionByZero(Assists, Max_Assists, Assists_divided),
    handleDivisionByZero(CleanSheet, Max_CleanSheet, CleanSheet_divided),
    handleDivisionByZero(PassToAssist, Max_PassToAssist, PassToAssist_divided),
    handleDivisionByZero(SuccessfulDribbles, Max_SuccessfulDribbles, SuccessfulDribbles_divided),

    ratingWeight(w, RatingWeight),
    goalsWeight(w, GoalsWeight),
    bigChancesMissedWeight(w, BigChancesMissedWeight),
    bigChancesCreatedWeight(w, BigChancesCreatedWeight),
    accuratePassesPercentageWeight(w, AccuratePassesPercentageWeight),
    keyPassesWeight(w, KeyPassesWeight),
    penaltyWonWeight(w, PenaltyWonWeight),
    successfulDribblesWeight(w, SuccessfulDribblesWeight),
    yellowCardsWeight(w, YellowCardsWeight),
    redCardsWeight(w, RedCardsWeight),
    accurateCrossesPercentageWeight(w, AccurateCrossesPercentageWeight),
    groundDuelsWonPercentageWeight(w, GroundDuelsWonPercentageWeight),
    aerialDuelsWonPercentageWeight(w, AerialDuelsWonPercentageWeight),
    dispossessedWeight(w, DispossessedWeight),
    possessionLostWeight(w, PossessionLostWeight),
    assistsWeight(w, AssistsWeight),
    oppositionHalfPassesPercentageWeight(w, OppositionHalfPassesPercentageWeight),
    accurateFinalThirdPassesWeight(w, AccurateFinalThirdPassesWeight),
    passToAssistWeight(w, PassToAssistWeight),
    wasFouledWeight(w, WasFouledWeight),
    cleanSheetWeight(w, CleanSheetWeight),
    goalConversionPercentageWeight(w, GoalConversionPercentageWeight),

    Eval is
        Eval_age +
        Eval_height +
        (
            Eval_Rating * RatingWeight + 
            Goals_divided * GoalsWeight +
            BigChancesMissed_divided * BigChancesMissedWeight +
            BigChancesCreated_divided * BigChancesCreatedWeight +
            AccuratePassesPercentage / 100 * AccuratePassesPercentageWeight +
            KeyPasses_divided * KeyPassesWeight +
            PenaltyWon_divided * PenaltyWonWeight +
            SuccessfulDribbles_divided * SuccessfulDribblesWeight +
            YellowCards_divided * YellowCardsWeight +
            RedCards_divided * RedCardsWeight +
            AccurateCrossesPercentage / 100 * AccurateCrossesPercentageWeight +
            GroundDuelsWonPercentage / 100 * GroundDuelsWonPercentageWeight +
            AerialDuelsWonPercentage / 100 * AerialDuelsWonPercentageWeight +
            Dispossessed_divided * DispossessedWeight +
            PossessionLost_divided * PossessionLostWeight +
            Assists_divided * AssistsWeight +
            OppositionHalfPassesPercentage / 100 * OppositionHalfPassesPercentageWeight +
            AccurateFinalThirdPasses_divided * AccurateFinalThirdPassesWeight +
            PassToAssist_divided * PassToAssistWeight +
            WasFouled_divided * WasFouledWeight +
            CleanSheet_divided * CleanSheetWeight +
            GoalConversionPercentage / 100 * GoalConversionPercentageWeight
        ) * TournamentValue * Eval_mp.

%%%%%%%%%%% PREDIZIONE CLASSIFICHE

get_all_eval_from_players_list([], []).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_goal_keeper(H), !,
    evaluation_gk(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_defender_central(H),
    evaluation_dc(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_fullback(H), !,
    evaluation_fb(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_dm(H), !,
    evaluation_dm(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_mc(H), !,
    evaluation_mc(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_am(H), !,
    evaluation_am(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_st(H), !,
    evaluation_st(H, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).
get_all_eval_from_players_list([H | T], ResEvalList) :-
    is_w(H), !,
    evaluation_w(H,Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_all_eval_from_players_list(T, ResEvalListRec),
    append([Eval], ResEvalListRec, ResEvalList).

% take returns the first N element of the list Src
% Src: input list
% N: first N element of the list to return
% L: output list (first N elements)
take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).

sum([], 0).
sum([H | T], Sum) :-
    sum(T, SubSum),
    Sum is SubSum + H.

debugging(Msg, Variable, Sep) :-
    atomics_to_string(Variable, Sep, String),
    string_concat(Msg, String, Output),
    write(Output),
    nl.

getNamesFromListIdPlyers([], []).
getNamesFromListIdPlyers([H | T], Names) :-
    name(H, Name),
    getNamesFromListIdPlyers(T, SubNames),
    append([Name], SubNames, Names).

get_teams_evals_from_team_list([], []).
get_teams_evals_from_team_list([H | T], EvalTeams) :-
    get_fullTeam(H, Players),
    get_all_eval_from_players_list(Players, ResEvalList),
    get_teams_evals_from_team_list(T, SubResEvalList),
    sort(ResEvalList, Sorted),
    reverse(Sorted, Reversed),
    take(Reversed, 18, First18),
    sum(First18, SumFirst18),
    append([[H, SumFirst18]], SubResEvalList, EvalTeams).

% Ht = Head tournament
% Tt = Rest of the tournaments
% LastRank = List of the previous tournament calculated
% FinalRank = ranks in output
predict_tournaments_rank([], []).
predict_tournaments_rank([Ht | Tt], TotalRank) :-
    get_all_tournamentTeams(Ht, Teams), % Teams = list of teams for that tournament
    get_teams_evals_from_team_list(Teams, EvalsForTeams),
    sort(2, @>=, EvalsForTeams, Rank),
    predict_tournaments_rank(Tt, SubTotalRank),
    append([[Ht, Rank]], SubTotalRank, TotalRank).

%%%%%%%%%%%%%%%%%% COMPARAZIONE GIOCATORI

isInBudget(Id, Budget):- 
    marketValue(Id, MarketValue),
    Budget >= MarketValue.

get_all_gk(Gk_list) :- findall(Player, is_goal_keeper(Player), Gk_list).
get_all_gk(Budget, Gk_list) :- 
    findall(Player, isInBudget(Player, Budget), Gk_list1),
    findall(Player, is_goal_keeper(Player), Gk_list2),
    intersection(Gk_list1, Gk_list2, Gk_list).
get_all_dc(Dc_list) :- findall(Player, is_defender_central(Player), Dc_list).
get_all_dc(Budget, Dc_list) :- 
    findall(Player, isInBudget(Player, Budget), Dc_list1),
    findall(Player, is_defender_central(Player), Dc_list2),
    intersection(Dc_list1, Dc_list2, Dc_list).
get_all_fb(Fb_list) :- findall(Player, is_fullback(Player), Fb_list).
get_all_fb(Budget, Fb_list) :- 
    findall(Player, isInBudget(Player, Budget), Fb_list1),
    findall(Player, is_fullback(Player), Fb_list2),
    intersection(Fb_list1, Fb_list2, Fb_list).
get_all_dm(Dm_list) :- findall(Player, is_dm(Player), Dm_list).
get_all_dm(Budget, Dm_list) :- 
    findall(Player, isInBudget(Player, Budget), Dm_list1),
    findall(Player, is_dm(Player), Dm_list2),
    intersection(Dm_list1, Dm_list2, Dm_list).
get_all_mc(Mc_list) :- findall(Player, is_mc(Player), Mc_list).
get_all_mc(Budget, Mc_list) :- 
    findall(Player, isInBudget(Player, Budget), Mc_list1),
    findall(Player, is_mc(Player), Mc_list2),
    intersection(Mc_list1, Mc_list2, Mc_list).
get_all_am(Am_list) :- findall(Player, is_am(Player), Am_list).
get_all_am(Budget, Am_list) :- 
    findall(Player, isInBudget(Player, Budget), Am_list1),
    findall(Player, is_am(Player), Am_list2),
    intersection(Am_list1, Am_list2, Am_list).
get_all_st(St_list) :- findall(Player, is_st(Player), St_list).
get_all_st(Budget, St_list) :- 
    findall(Player, isInBudget(Player, Budget), St_list1),
    findall(Player, is_st(Player), St_list2),
    intersection(St_list1, St_list2, St_list).
get_all_w(W_list) :- findall(Player, is_w(Player), W_list).
get_all_w(Budget, W_list) :- 
    findall(Player, isInBudget(Player, Budget), W_list1),
    findall(Player, is_w(Player), W_list2),
    intersection(W_list1, W_list2, W_list).

compare_gk(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_gk(Id1, Eval1),
    evaluation_gk(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_dc(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_dc(Id1, Eval1),
    evaluation_dc(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_fb(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_fb(Id1, Eval1),
    evaluation_fb(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_dm(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_dm(Id1, Eval1),
    evaluation_dm(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_mc(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_mc(Id1, Eval1),
    evaluation_mc(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_am(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_am(Id1, Eval1),
    evaluation_am(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_st(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_st(Id1, Eval1),
    evaluation_st(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

compare_w(Name1, Name2, Perc1, Perc2) :- 
    name(Id1, Name1),
    name(Id2, Name2),
    evaluation_w(Id1, Eval1),
    evaluation_w(Id2, Eval2),
    PercSum is Eval1 + Eval2,
    Perc1 is Eval1 / PercSum,
    Perc2 is Eval2 / PercSum.

%%%%%%%%%%%%%%%%%%% TROVA DEBOLEZZE SQUADRA

get_average_last_third(List, Avg) :-
    length(List, Length),
    Index is round(Length * 2 / 3) + 1,
    nth0(Index, List, AvgPlayer),
    nth0(1, AvgPlayer, Avg).

% funzioni per filtrare una lista basandoci sul ruolo
get_gk_from_player_list([], []).
get_gk_from_player_list([Id | T], Gk_list) :-
    is_goal_keeper(Id), !,
    get_gk_from_player_list(T, Sub_Gk_list),
    append([Id], Sub_Gk_list, Gk_list).
get_gk_from_player_list([Id | T], Gk_list) :-
    \+ is_goal_keeper(Id), !,
    get_gk_from_player_list(T, Sub_Gk_list),
    append([], Sub_Gk_list, Gk_list).

get_dc_from_player_list([], []).
get_dc_from_player_list([Id | T], Dc_list) :-
    is_defender_central(Id), !,
    get_dc_from_player_list(T, Sub_Dc_list),
    append([Id], Sub_Dc_list, Dc_list).
get_dc_from_player_list([Id | T], Dc_list) :-
    \+ is_defender_central(Id), !,
    get_dc_from_player_list(T, Sub_Dc_list),
    append([], Sub_Dc_list, Dc_list).

get_fb_from_player_list([], []).
get_fb_from_player_list([Id | T], Fb_list) :-
    is_fullback(Id), !,
    get_fb_from_player_list(T, Sub_Fb_list),
    append([Id], Sub_Fb_list, Fb_list).
get_fb_from_player_list([Id | T], Fb_list) :-
    \+ is_fullback(Id), !,
    get_fb_from_player_list(T, Sub_Fb_list),
    append([], Sub_Fb_list, Fb_list).

get_dm_from_player_list([], []).
get_dm_from_player_list([Id | T], Dm_list) :-
    is_dm(Id), !,
    get_dm_from_player_list(T, Sub_Dm_list),
    append([Id], Sub_Dm_list, Dm_list).
get_dm_from_player_list([Id | T], Dm_list) :-
    \+ is_dm(Id), !,
    get_dm_from_player_list(T, Sub_Dm_list),
    append([], Sub_Dm_list, Dm_list).

get_mc_from_player_list([], []).
get_mc_from_player_list([Id | T], Mc_list) :-
    is_mc(Id), !,
    get_mc_from_player_list(T, Sub_Mc_list),
    append([Id], Sub_Mc_list, Mc_list).
get_mc_from_player_list([Id | T], Mc_list) :-
    \+ is_mc(Id), !,
    get_mc_from_player_list(T, Sub_Mc_list),
    append([], Sub_Mc_list, Mc_list).

get_am_from_player_list([], []).
get_am_from_player_list([Id | T], Am_list) :-
    is_am(Id), !,
    get_am_from_player_list(T, Sub_Am_list),
    append([Id], Sub_Am_list, Am_list).
get_am_from_player_list([Id | T], Am_list) :-
    \+ is_am(Id), !,
    get_am_from_player_list(T, Sub_Am_list),
    append([], Sub_Am_list, Am_list).

get_st_from_player_list([], []).
get_st_from_player_list([Id | T], St_list) :-
    is_st(Id), !,
    get_st_from_player_list(T, Sub_St_list),
    append([Id], Sub_St_list, St_list).
get_st_from_player_list([Id | T], St_list) :-
    \+ is_st(Id), !,
    get_st_from_player_list(T, Sub_St_list),
    append([], Sub_St_list, St_list).

get_w_from_player_list([], []).
get_w_from_player_list([Id | T], W_list) :-
    is_w(Id), !,
    get_w_from_player_list(T, Sub_W_list),
    append([Id], Sub_W_list, W_list).
get_w_from_player_list([Id | T], W_list) :-
    \+ is_w(Id), !,
    get_w_from_player_list(T, Sub_W_list),
    append([], Sub_W_list, W_list).

get_gk_of_team(Team, Gk_list) :- findall(Id, (team(Id, Team), is_goal_keeper(Id)), Gk_list).
    
filter_weak_players([], []).    
filter_weak_players([Id | T], Filtered) :-
    age(Id, Age),
    Age > 21,
    missedForInjuries(Id, MissedMatches),
    MissedMatches < 21, !,
    filter_weak_players(T, SubFiltered),
    append([Id], SubFiltered, Filtered).
filter_weak_players([Id | T], Filtered) :-
    age(Id, Age),
    Age =< 21,
    missedForInjuries(Id, MissedMatches),
    MissedMatches < 21, !,
    filter_weak_players(T, Filtered).
filter_weak_players([Id | T], Filtered) :-
    age(Id, Age),
    Age > 21,
    missedForInjuries(Id, MissedMatches),
    MissedMatches >= 21, !,
    filter_weak_players(T, Filtered).
filter_weak_players([Id | T], Filtered) :-
    age(Id, Age),
    Age =< 21,
    missedForInjuries(Id, MissedMatches),
    MissedMatches >= 21, !,
    filter_weak_players(T, Filtered).

filter_cond_player_if_1([], _, []).
filter_cond_player_if_1(_, Length, []) :- Length =< 1.
filter_cond_player_if_1(Gk_list, Length, Gk_list) :- Length > 1.

remove_gk_from_player_list([], []).
remove_gk_from_player_list([Id | T], Filtered) :-
    is_goal_keeper(Id), !,
    remove_gk_from_player_list(T, Filtered).
remove_gk_from_player_list([Id | T], Filtered) :-
    \+ is_goal_keeper(Id), !,
    remove_gk_from_player_list(T, SubFiltered),
    append([Id], SubFiltered, Filtered).

get_player_id_eval_weakness([], []).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_goal_keeper(Id), !,
    evaluation_gk(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_defender_central(Id), !,
    evaluation_dc(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_fullback(Id), !,
    evaluation_fb(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_dm(Id), !,
    evaluation_dm(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_mc(Id), !,
    evaluation_mc(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_am(Id), !,
    evaluation_am(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_st(Id), !,
    evaluation_st(Id, Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).
get_player_id_eval_weakness([Id | T], ResEvalList) :-
    is_w(Id), !,
    evaluation_w(Id,Eval),
    % after getting the evaluation, calculate recursively and than concatenate
    get_player_id_eval_weakness(T, ResEvalListRec),
    append([[Id, Eval]], ResEvalListRec, ResEvalList).

per_role_find_lowest_eval([], _, null).
per_role_find_lowest_eval(PlayerList, Avg, OutPlayer) :-
    sort(2, @=<, PlayerList, Sorted),
    nth0(0, Sorted, Player),
    nth0(1, Player, Eval),
    Eval < Avg, !,
    nth0(0, Player, Id),
    name(Id, OutPlayer).
per_role_find_lowest_eval(PlayerList, Avg, null) :- 
    sort(2, @=<, PlayerList, Sorted),
    nth0(0, Sorted, Player),
    nth0(1, Player, Eval),
    Eval >= Avg, !.

convert_list_name_eval_2_id_eval([], []).
convert_list_name_eval_2_id_eval([[Name, Eval] | T], Id_Eval_list) :-
    name(Id, Name),
    convert_list_name_eval_2_id_eval(T, Sub_Id_Eval_list), 
    append([Id, Eval], Sub_Id_Eval_list, Id_Eval_list).

team_weak_players(Team, [Weakest_Gk, Weakest_Dc, Weakest_Fb, Weakest_Dm, Weakest_Mc, Weakest_Am, Weakest_St, Weakest_W]) :-
    evaluate_all_gk(Eval_gk_list),
    evaluate_all_dc(Eval_dc_list),
    evaluate_all_fb(Eval_fb_list),
    evaluate_all_dm(Eval_dm_list),
    evaluate_all_mc(Eval_mc_list),
    evaluate_all_am(Eval_am_list),
    evaluate_all_st(Eval_st_list),
    evaluate_all_w(Eval_w_list),

    sort(2, @>=, Eval_gk_list, Eval_gk_listSorted),
    sort(2, @>=, Eval_dc_list, Eval_dc_listSorted),
    sort(2, @>=, Eval_fb_list, Eval_fb_listSorted),
    sort(2, @>=, Eval_dm_list, Eval_dm_listSorted),
    sort(2, @>=, Eval_mc_list, Eval_mc_listSorted),
    sort(2, @>=, Eval_am_list, Eval_am_listSorted),
    sort(2, @>=, Eval_st_list, Eval_st_listSorted),
    sort(2, @>=, Eval_w_list, Eval_w_listSorted),

    get_average_last_third(Eval_gk_listSorted, Avg_gk),
    get_average_last_third(Eval_dc_listSorted, Avg_dc),
    get_average_last_third(Eval_fb_listSorted, Avg_fb),
    get_average_last_third(Eval_dm_listSorted, Avg_dm),
    get_average_last_third(Eval_mc_listSorted, Avg_mc),
    get_average_last_third(Eval_am_listSorted, Avg_am),
    get_average_last_third(Eval_st_listSorted, Avg_st),
    get_average_last_third(Eval_w_listSorted, Avg_w),
    
    get_fullTeam(Team, Players),
    filter_weak_players(Players, FilteredPlayers),

    get_gk_from_player_list(FilteredPlayers, FilteredPlayers1),
    get_player_id_eval_weakness(FilteredPlayers1, Gk_List),
    sort(2, @>=, Gk_List, Eval_Gk_listSorted),
    nth0(0, Eval_Gk_listSorted, FirstGkEval),

    get_dc_from_player_list(FilteredPlayers, FilteredPlayers2),
    get_player_id_eval_weakness(FilteredPlayers2, Dc_List),

    get_fb_from_player_list(FilteredPlayers, FilteredPlayers3),
    get_player_id_eval_weakness(FilteredPlayers3, Fb_List),

    get_dm_from_player_list(FilteredPlayers, FilteredPlayers4),
    get_player_id_eval_weakness(FilteredPlayers4, Dm_List),

    get_mc_from_player_list(FilteredPlayers, FilteredPlayers5),
    get_player_id_eval_weakness(FilteredPlayers5, Mc_List),

    get_am_from_player_list(FilteredPlayers, FilteredPlayers6),
    get_player_id_eval_weakness(FilteredPlayers6, Am_List),

    get_st_from_player_list(FilteredPlayers, FilteredPlayers7),
    get_player_id_eval_weakness(FilteredPlayers7, St_List),

    get_w_from_player_list(FilteredPlayers, FilteredPlayers8),
    get_player_id_eval_weakness(FilteredPlayers8, W_List),
    
    per_role_find_lowest_eval([FirstGkEval], Avg_gk, Weakest_Gk),
    per_role_find_lowest_eval(Dc_List, Avg_dc, Weakest_Dc),
    per_role_find_lowest_eval(Fb_List, Avg_fb, Weakest_Fb),
    per_role_find_lowest_eval(Dm_List, Avg_dm, Weakest_Dm),
    per_role_find_lowest_eval(Mc_List, Avg_mc, Weakest_Mc),
    per_role_find_lowest_eval(Am_List, Avg_am, Weakest_Am),
    per_role_find_lowest_eval(St_List, Avg_st, Weakest_St),
    per_role_find_lowest_eval(W_List, Avg_w, Weakest_W).

/* Vincoli:
    - modulo
    - budget
    - età media
    - tot nazionalità
    - anni di contratto rimanenti
*/

count_nazionalita([], _, 0).
count_nazionalita([H | T], Nationality, Total) :-
    Nationality = H, !,
    count_nazionalita(T, Nationality, SubTotal),
    Total is SubTotal + 1.
count_nazionalita([H | T], Nationality, Total) :-
    not(Nationality = H), !,
    count_nazionalita(T, Nationality, SubTotal),
    Total is SubTotal + 0.

calcola_perm_rosa(Module, BudgetTot, MaxAvgAge, Nationality, MinNationality, MinYearContract, Team, IdGk, IdFb1, IdFb2, IdDc1, IdDc2, IdDm1, IdMc1, IdMc2, IdW1, IdW2, IdSt1) :-
    Module = '433',

    %%%% GoalKeeper
    team(IdGk, Team),
    contractYearsLeft(IdGk, YearsLeftGk),
    YearsLeftGk > MinYearContract,
    is_goal_keeper(IdGk),

    %%%% Fullback
    team(IdFb1, Team),
    contractYearsLeft(IdFb1, YearsLeftFb1),
    YearsLeftFb1 > MinYearContract,
    is_fullback(IdFb1),

    team(IdFb2, Team),
    contractYearsLeft(IdFb2, YearsLeftFb2),
    YearsLeftFb2 > MinYearContract,
    is_fullback(IdFb2),

    % assicuro che non siano lo stesso
    not(IdFb1 = IdFb2),
    
    %%%% Defender Central
    team(IdDc1, Team),
    contractYearsLeft(IdDc1, YearsLeftDc1),
    YearsLeftDc1 > MinYearContract,
    is_defender_central(IdDc1),

    team(IdDc2, Team),
    contractYearsLeft(IdDc2, YearsLeftDc2),
    YearsLeftDc2 > MinYearContract,
    is_defender_central(IdDc2),

    % assicuro che non siano lo stesso
    not(IdDc1 = IdDc2),

    %%%% Defensive mid fielder
    team(IdDm1, Team),
    contractYearsLeft(IdDm1, YearsLeftDm1),
    YearsLeftDm1 > MinYearContract,
    is_dm(IdDm1),

    %%%% Mid fielder Central
    team(IdMc1, Team),
    contractYearsLeft(IdMc1, YearsLeftMc1),
    YearsLeftMc1 > MinYearContract,
    is_mc(IdMc1),

    team(IdMc2, Team),
    contractYearsLeft(IdMc2, YearsLeftMc2),
    YearsLeftMc2 > MinYearContract,
    is_mc(IdMc2),

    % assicuro che non siano lo stesso
    not(IdMc1 = IdMc2),

    %%%% Wings
    team(IdW1, Team),
    contractYearsLeft(IdW1, YearsLeftW1),
    YearsLeftW1 > MinYearContract,
    is_w(IdW1),

    team(IdW2, Team),
    contractYearsLeft(IdW2, YearsLeftW2),
    YearsLeftW2 > MinYearContract,
    is_w(IdW2),

    % assicuro che non siano lo stesso
    not(IdW1 = IdW2),

    %%%% striker
    team(IdSt1, Team),
    contractYearsLeft(IdSt1, YearsLeftSt1),
    YearsLeftSt1 > MinYearContract,
    is_st(IdSt1),

    marketValue(IdGk, ValueGk),
    marketValue(IdFb1, ValueFb1),
    marketValue(IdFb2, ValueFb2),
    marketValue(IdDc1, ValueDc1),
    marketValue(IdDc2, ValueDc2),
    marketValue(IdDm1, ValueDm1),
    marketValue(IdMc1, ValueMc1),
    marketValue(IdMc2, ValueMc2),
    marketValue(IdW1, ValueW1),
    marketValue(IdW2, ValueW2),
    marketValue(IdSt1, ValueSt1),

    ValueTot is ValueGk + ValueFb1 + ValueFb2 + ValueDc1 + ValueDc2 + ValueDm1 + ValueMc1 + ValueMc2 + ValueW1 + ValueW2 + ValueSt1,
    ValueTot =< BudgetTot,
    %write(ValueTot), nl,

    age(IdGk, AgeGk),
    age(IdFb1, AgeFb1),
    age(IdFb2, AgeFb2),
    age(IdDc1, AgeDc1),
    age(IdDc2, AgeDc2),
    age(IdDm1, AgeDm1),
    age(IdMc1, AgeMc1),
    age(IdMc2, AgeMc2),
    age(IdW1, AgeW1),
    age(IdW2, AgeW2),
    age(IdSt1, AgeSt1),

    AgeAvg is ((AgeGk + AgeFb1 + AgeFb2 + AgeDc1 + AgeDc2 + AgeDm1 + AgeMc1 + AgeMc2 + AgeW1 + AgeW2 + AgeSt1) / 11),
    AgeAvg =< MaxAvgAge,
    %write(AgeAvg),

    country(IdGk, CountryGk),
    country(IdFb1, CountryFb1),
    country(IdFb2, CountryFb2),
    country(IdDc1, CountryDc1),
    country(IdDc2, CountryDc2),
    country(IdDm1, CountryDm1),
    country(IdMc1, CountryMc1),
    country(IdMc2, CountryMc2),
    country(IdW1, CountryW1),
    country(IdW2, CountryW2),
    country(IdSt1, CountrySt1),

    %write('Sto per calcolare le nazioni'), nl,

    count_nazionalita([CountryGk, CountryFb1, CountryFb2, CountryDc1, CountryDc2, CountryDm1, CountryMc1, CountryMc2, CountryW1, CountryW2, CountrySt1], Nationality, TotaleNazionalita),
    MinNationality =< TotaleNazionalita.

    %debugging('combinazione trovata: ', [IdGk, IdFb1, IdFb2, IdDc1, IdDm1, IdMc1, IdMc2, IdW1, IdW2, IdSt1], ', ').

calcola_perm_rosa(Module, BudgetTot, MaxAvgAge, Nationality, MinNationality, MinYearContract, Team, IdGk, IdFb1, IdFb2, IdDc1, IdDc2, IdDm1, IdDm2, IdW1, IdW2, IdSt1, IdSt2) :-
    Module = '442',

    %%%% GoalKeeper
    team(IdGk, Team),
    contractYearsLeft(IdGk, YearsLeftGk),
    YearsLeftGk > MinYearContract,
    is_goal_keeper(IdGk),

    %%%% Fullback
    team(IdFb1, Team),
    contractYearsLeft(IdFb1, YearsLeftFb1),
    YearsLeftFb1 > MinYearContract,
    is_fullback(IdFb1),

    team(IdFb2, Team),
    contractYearsLeft(IdFb2, YearsLeftFb2),
    YearsLeftFb2 > MinYearContract,
    is_fullback(IdFb2),

    % assicuro che non siano lo stesso
    not(IdFb1 = IdFb2),
    
    %%%% Defender Central
    team(IdDc1, Team),
    contractYearsLeft(IdDc1, YearsLeftDc1),
    YearsLeftDc1 > MinYearContract,
    is_defender_central(IdDc1),

    team(IdDc2, Team),
    contractYearsLeft(IdDc2, YearsLeftDc2),
    YearsLeftDc2 > MinYearContract,
    is_defender_central(IdDc2),

    % assicuro che non siano lo stesso
    not(IdDc1 = IdDc2),

    %%%% Defensive mid fielder
    team(IdDm1, Team),
    contractYearsLeft(IdDm1, YearsLeftDm1),
    YearsLeftDm1 > MinYearContract,
    is_dm(IdDm1),

    team(IdDm2, Team),
    contractYearsLeft(IdDm2, YearsLeftDm2),
    YearsLeftDm2 > MinYearContract,
    is_dm(IdDm2),

    % assicuro che non siano lo stesso
    not(IdDm1 = IdDm2),

    %%%% Wings
    team(IdW1, Team),
    contractYearsLeft(IdW1, YearsLeftW1),
    YearsLeftW1 > MinYearContract,
    is_w(IdW1),

    team(IdW2, Team),
    contractYearsLeft(IdW2, YearsLeftW2),
    YearsLeftW2 > MinYearContract,
    is_w(IdW2),

    % assicuro che non siano lo stesso
    not(IdW1 = IdW2),

    %%%% strikers
    team(IdSt1, Team),
    contractYearsLeft(IdSt1, YearsLeftSt1),
    YearsLeftSt1 > MinYearContract,
    is_st(IdSt1),

    team(IdSt2, Team),
    contractYearsLeft(IdSt2, YearsLeftSt2),
    YearsLeftSt2 > MinYearContract,
    is_st(IdSt2),

    % assicuro che non siano lo stesso
    not(IdSt1 = IdSt2),

    marketValue(IdGk, ValueGk),
    marketValue(IdFb1, ValueFb1),
    marketValue(IdFb2, ValueFb2),
    marketValue(IdDc1, ValueDc1),
    marketValue(IdDc2, ValueDc2),
    marketValue(IdDm1, ValueDm1),
    marketValue(IdDm2, ValueDm2),
    marketValue(IdW1, ValueW1),
    marketValue(IdW2, ValueW2),
    marketValue(IdSt1, ValueSt1),
    marketValue(IdSt2, ValueSt2),

    ValueTot is ValueGk + ValueFb1 + ValueFb2 + ValueDc1 + ValueDc2 + ValueDm1 + ValueDm2 + ValueW1 + ValueW2 + ValueSt1 + ValueSt2,
    ValueTot =< BudgetTot,

    age(IdGk, AgeGk),
    age(IdFb1, AgeFb1),
    age(IdFb2, AgeFb2),
    age(IdDc1, AgeDc1),
    age(IdDc2, AgeDc2),
    age(IdDm1, AgeDm1),
    age(IdDm2, AgeDm2),
    age(IdW1, AgeW1),
    age(IdW2, AgeW2),
    age(IdSt1, AgeSt1),
    age(IdSt2, AgeSt2),

    AgeAvg is ((AgeGk + AgeFb1 + AgeFb2 + AgeDc1 + AgeDc2 + AgeDm1 + AgeDm2 + AgeW1 + AgeW2 + AgeSt1 + AgeSt2) / 11),
    AgeAvg =< MaxAvgAge,

    country(IdGk, CountryGk),
    country(IdFb1, CountryFb1),
    country(IdFb2, CountryFb2),
    country(IdDc1, CountryDc1),
    country(IdDc2, CountryDc2),
    country(IdDm1, CountryDm1),
    country(IdDm2, CountryDm2),
    country(IdW1, CountryW1),
    country(IdW2, CountryW2),
    country(IdSt1, CountrySt1),
    country(IdSt2, CountrySt2),

    count_nazionalita([CountryGk, CountryFb1, CountryFb2, CountryDc1, CountryDc2, CountryDm1, CountryDm2, CountryW1, CountryW2, CountrySt1, CountrySt2], Nationality, TotaleNazionalita),
    MinNationality =< TotaleNazionalita.

calcola_perm_rosa(Module, BudgetTot, MaxAvgAge, Nationality, MinNationality, MinYearContract, Team, IdGk, IdFb1, IdFb2, IdDc1, IdDc2, IdDm1, IdDm2, IdW1, IdW2, IdAm1, IdSt1) :-
    Module = '4231',

    %%%% GoalKeeper
    team(IdGk, Team),
    contractYearsLeft(IdGk, YearsLeftGk),
    YearsLeftGk > MinYearContract,
    is_goal_keeper(IdGk),

    %%%% Fullback
    team(IdFb1, Team),
    contractYearsLeft(IdFb1, YearsLeftFb1),
    YearsLeftFb1 > MinYearContract,
    is_fullback(IdFb1),

    team(IdFb2, Team),
    contractYearsLeft(IdFb2, YearsLeftFb2),
    YearsLeftFb2 > MinYearContract,
    is_fullback(IdFb2),

    % assicuro che non siano lo stesso
    not(IdFb1 = IdFb2),
    
    %%%% Defender Central
    team(IdDc1, Team),
    contractYearsLeft(IdDc1, YearsLeftDc1),
    YearsLeftDc1 > MinYearContract,
    is_defender_central(IdDc1),

    team(IdDc2, Team),
    contractYearsLeft(IdDc2, YearsLeftDc2),
    YearsLeftDc2 > MinYearContract,
    is_defender_central(IdDc2),

    % assicuro che non siano lo stesso
    not(IdDc1 = IdDc2),

    %%%% Defensive mid fielder
    team(IdDm1, Team),
    contractYearsLeft(IdDm1, YearsLeftDm1),
    YearsLeftDm1 > MinYearContract,
    is_dm(IdDm1),

    team(IdDm2, Team),
    contractYearsLeft(IdDm2, YearsLeftDm2),
    YearsLeftDm2 > MinYearContract,
    is_dm(IdDm2),

    % assicuro che non siano lo stesso
    not(IdDm1 = IdDm2),

    %%%% Offensive Mid fielder
    team(IdAm1, Team),
    contractYearsLeft(IdAm1, YearsLeftIdAm1),
    YearsLeftIdAm1 > MinYearContract,
    is_mc(IdAm1),

    %%%% Wings
    team(IdW1, Team),
    contractYearsLeft(IdW1, YearsLeftW1),
    YearsLeftW1 > MinYearContract,
    is_w(IdW1),

    team(IdW2, Team),
    contractYearsLeft(IdW2, YearsLeftW2),
    YearsLeftW2 > MinYearContract,
    is_w(IdW2),

    % assicuro che non siano lo stesso
    not(IdW1 = IdW2),

    %%%% striker
    team(IdSt1, Team),
    contractYearsLeft(IdSt1, YearsLeftSt1),
    YearsLeftSt1 > MinYearContract,
    is_st(IdSt1),

    team(IdSt2, Team),
    contractYearsLeft(IdSt2, YearsLeftSt2),
    YearsLeftSt2 > MinYearContract,
    is_st(IdSt2),

    % assicuro che non siano lo stesso
    not(IdSt1 = IdSt2),

    marketValue(IdGk, ValueGk),
    marketValue(IdFb1, ValueFb1),
    marketValue(IdFb2, ValueFb2),
    marketValue(IdDc1, ValueDc1),
    marketValue(IdDc2, ValueDc2),
    marketValue(IdDm1, ValueDm1),
    marketValue(IdDm2, ValueDm2),
    marketValue(IdW1, ValueW1),
    marketValue(IdW2, ValueW2),
    marketValue(IdAm1, ValueAm1),
    marketValue(IdSt1, ValueSt1),

    ValueTot is ValueGk + ValueFb1 + ValueFb2 + ValueDc1 + ValueDc2 + ValueDm1 + ValueDm2 + ValueW1 + ValueW2 + ValueAm1 + ValueSt1,
    ValueTot =< BudgetTot,

    age(IdGk, AgeGk),
    age(IdFb1, AgeFb1),
    age(IdFb2, AgeFb2),
    age(IdDc1, AgeDc1),
    age(IdDc2, AgeDc2),
    age(IdDm1, AgeDm1),
    age(IdDm2, AgeDm2),
    age(IdW1, AgeW1),
    age(IdW2, AgeW2),
    age(IdAm1, AgeAm1),
    age(IdSt1, AgeSt1),

    AgeAvg is ((AgeGk + AgeFb1 + AgeFb2 + AgeDc1 + AgeDc2 + AgeDm1 + AgeDm2 + AgeW1 + AgeW2 + AgeAm1 + AgeSt1) / 11),
    AgeAvg =< MaxAvgAge,

    country(IdGk, CountryGk),
    country(IdFb1, CountryFb1),
    country(IdFb2, CountryFb2),
    country(IdDc1, CountryDc1),
    country(IdDc2, CountryDc2),
    country(IdDm1, CountryDm1),
    country(IdDm2, CountryDm2),
    country(IdW1, CountryW1),
    country(IdW2, CountryW2),
    country(IdAm1, CountryAm1),
    country(IdSt1, CountrySt1),

    count_nazionalita([CountryGk, CountryFb1, CountryFb2, CountryDc1, CountryDc2, CountryDm1, CountryDm2, CountryW1, CountryW2, CountryAm1, CountrySt1], Nationality, TotaleNazionalita),
    MinNationality =< TotaleNazionalita.

calcola_perm_rosa(Module, BudgetTot, MaxAvgAge, Nationality, MinNationality, MinYearContract, Team, IdGk, IdFb1, IdFb2, IdDc1, IdDc2, IdDc3, IdDm1, IdMc1, IdMc2, IdSt1, IdSt2) :-
    Module = '352',

    %%%% GoalKeeper
    team(IdGk, Team),
    contractYearsLeft(IdGk, YearsLeftGk),
    YearsLeftGk > MinYearContract,
    is_goal_keeper(IdGk),

    %%%% Fullback
    team(IdFb1, Team),
    contractYearsLeft(IdFb1, YearsLeftFb1),
    YearsLeftFb1 > MinYearContract,
    is_fullback(IdFb1),

    team(IdFb2, Team),
    contractYearsLeft(IdFb2, YearsLeftFb2),
    YearsLeftFb2 > MinYearContract,
    is_fullback(IdFb2),

    % assicuro che non siano lo stesso
    not(IdFb1 = IdFb2),
    
    %%%% Defender Central
    team(IdDc1, Team),
    contractYearsLeft(IdDc1, YearsLeftDc1),
    YearsLeftDc1 > MinYearContract,
    is_defender_central(IdDc1),

    team(IdDc2, Team),
    contractYearsLeft(IdDc2, YearsLeftDc2),
    YearsLeftDc2 > MinYearContract,
    is_defender_central(IdDc2),

    team(IdDc3, Team),
    contractYearsLeft(IdDc3, YearsLeftDc3),
    YearsLeftDc3 > MinYearContract,
    is_defender_central(IdDc3),

    % assicuro che non siano lo stesso
    not(IdDc1 = IdDc2),
    not(IdDc1 = IdDc3),
    not(IdDc2 = IdDc3),

    %%%% Defensive mid fielder
    team(IdDm1, Team),
    contractYearsLeft(IdDm1, YearsLeftDm1),
    YearsLeftDm1 > MinYearContract,
    is_dm(IdDm1),

    %%%% Mid fielder Central
    team(IdMc1, Team),
    contractYearsLeft(IdMc1, YearsLeftMc1),
    YearsLeftMc1 > MinYearContract,
    is_mc(IdMc1),

    team(IdMc2, Team),
    contractYearsLeft(IdMc2, YearsLeftMc2),
    YearsLeftMc2 > MinYearContract,
    is_mc(IdMc2),

    % assicuro che non siano lo stesso
    not(IdMc1 = IdMc2),

    %%%% striker
    team(IdSt1, Team),
    contractYearsLeft(IdSt1, YearsLeftSt1),
    YearsLeftSt1 > MinYearContract,
    is_st(IdSt1),

    team(IdSt2, Team),
    contractYearsLeft(IdSt2, YearsLeftSt2),
    YearsLeftSt2 > MinYearContract,
    is_st(IdSt2),

    % assicuro che non siano lo stesso
    not(IdSt1 = IdSt2),

    marketValue(IdGk, ValueGk),
    marketValue(IdFb1, ValueFb1),
    marketValue(IdFb2, ValueFb2),
    marketValue(IdDc1, ValueDc1),
    marketValue(IdDc2, ValueDc2),
    marketValue(IdDc3, ValueDc3),
    marketValue(IdDm1, ValueDm1),
    marketValue(IdMc1, ValueMc1),
    marketValue(IdMc2, ValueMc2),
    marketValue(IdSt1, ValueSt1),
    marketValue(IdSt2, ValueSt2),

    ValueTot is ValueGk + ValueFb1 + ValueFb2 + ValueDc1 + ValueDc2 + ValueDc3 + ValueDm1 + ValueMc1 + ValueMc2 + ValueSt1 + ValueSt2,
    ValueTot =< BudgetTot,

    age(IdGk, AgeGk),
    age(IdFb1, AgeFb1),
    age(IdFb2, AgeFb2),
    age(IdDc1, AgeDc1),
    age(IdDc2, AgeDc2),
    age(IdDc3, AgeDc3),
    age(IdDm1, AgeDm1),
    age(IdMc1, AgeMc1),
    age(IdMc2, AgeMc2),
    age(IdSt1, AgeSt1),
    age(IdSt2, AgeSt2),

    AgeAvg is ((AgeGk + AgeFb1 + AgeFb2 + AgeDc1 + AgeDc2 + AgeDc3 + AgeDm1 + AgeMc1 + AgeMc2 + AgeSt1 + AgeSt2) / 11),
    AgeAvg =< MaxAvgAge,

    country(IdGk, CountryGk),
    country(IdFb1, CountryFb1),
    country(IdFb2, CountryFb2),
    country(IdDc1, CountryDc1),
    country(IdDc2, CountryDc2),
    country(IdDc3, CountryDc3),
    country(IdDm1, CountryDm1),
    country(IdMc1, CountryMc1),
    country(IdMc2, CountryMc2),
    country(IdSt1, CountrySt1),
    country(IdSt2, CountrySt2),

    count_nazionalita([CountryGk, CountryFb1, CountryFb2, CountryDc1, CountryDc2, CountryDc3, CountryDm1, CountryMc1, CountryMc2, CountrySt1, CountrySt2], Nationality, TotaleNazionalita),
    MinNationality =< TotaleNazionalita.

calcola_perm_rosa(Module, BudgetTot, MaxAvgAge, Nationality, MinNationality, MinYearContract, Team, IdGk, IdFb1, IdFb2, IdDc1, IdDc2, IdDc3, IdDm1, IdDm2, IdW1, IdW2, IdSt1) :-
    Module = '343',

    %%%% GoalKeeper
    team(IdGk, Team),
    contractYearsLeft(IdGk, YearsLeftGk),
    YearsLeftGk > MinYearContract,
    is_goal_keeper(IdGk),

    %%%% Fullback
    team(IdFb1, Team),
    contractYearsLeft(IdFb1, YearsLeftFb1),
    YearsLeftFb1 > MinYearContract,
    is_fullback(IdFb1),

    team(IdFb2, Team),
    contractYearsLeft(IdFb2, YearsLeftFb2),
    YearsLeftFb2 > MinYearContract,
    is_fullback(IdFb2),

    % assicuro che non siano lo stesso
    not(IdFb1 = IdFb2),
    
    %%%% Defender Central
    team(IdDc1, Team),
    contractYearsLeft(IdDc1, YearsLeftDc1),
    YearsLeftDc1 > MinYearContract,
    is_defender_central(IdDc1),

    team(IdDc2, Team),
    contractYearsLeft(IdDc2, YearsLeftDc2),
    YearsLeftDc2 > MinYearContract,
    is_defender_central(IdDc2),

    team(IdDc3, Team),
    contractYearsLeft(IdDc3, YearsLeftDc3),
    YearsLeftDc3 > MinYearContract,
    is_defender_central(IdDc3),

    % assicuro che non siano lo stesso
    not(IdDc1 = IdDc2),
    not(IdDc1 = IdDc3),
    not(IdDc2 = IdDc3),

    %%%% Defensive mid fielder
    team(IdDm1, Team),
    contractYearsLeft(IdDm1, YearsLeftDm1),
    YearsLeftDm1 > MinYearContract,
    is_dm(IdDm1),

    team(IdDm2, Team),
    contractYearsLeft(IdDm2, YearsLeftDm2),
    YearsLeftDm2 > MinYearContract,
    is_dm(IdDm2),

    % assicuro che non siano lo stesso
    not(IdDm1 = IdDm2),

    %%%% Wings
    team(IdW1, Team),
    contractYearsLeft(IdW1, YearsLeftW1),
    YearsLeftW1 > MinYearContract,
    is_w(IdW1),

    team(IdW2, Team),
    contractYearsLeft(IdW2, YearsLeftW2),
    YearsLeftW2 > MinYearContract,
    is_w(IdW2),

    % assicuro che non siano lo stesso
    not(IdW1 = IdW2),

    %%%% striker
    team(IdSt1, Team),
    contractYearsLeft(IdSt1, YearsLeftSt1),
    YearsLeftSt1 > MinYearContract,
    is_st(IdSt1),

    marketValue(IdGk, ValueGk),
    marketValue(IdFb1, ValueFb1),
    marketValue(IdFb2, ValueFb2),
    marketValue(IdDc1, ValueDc1),
    marketValue(IdDc2, ValueDc2),
    marketValue(IdDc3, ValueDc3),
    marketValue(IdDm1, ValueDm1),
    marketValue(IdDm2, ValueDm2),
    marketValue(IdW1, ValueW1),
    marketValue(IdW2, ValueW2),
    marketValue(IdSt1, ValueSt1),

    ValueTot is ValueGk + ValueFb1 + ValueFb2 + ValueDc1 + ValueDc2 + ValueDc3 + ValueDm1 + ValueDm2 + ValueW1 + ValueW2 + ValueSt1,
    ValueTot =< BudgetTot,

    age(IdGk, AgeGk),
    age(IdFb1, AgeFb1),
    age(IdFb2, AgeFb2),
    age(IdDc1, AgeDc1),
    age(IdDc2, AgeDc2),
    age(IdDc3, AgeDc3),
    age(IdDm1, AgeDm1),
    age(IdDm2, AgeDm2),
    age(IdW1, AgeW1),
    age(IdW2, AgeW2),
    age(IdSt1, AgeSt1),

    AgeAvg is ((AgeGk + AgeFb1 + AgeFb2 + AgeDc1 + AgeDc2 + AgeDc3 + AgeDm1 + AgeDm2 + AgeW1 + AgeW2 + AgeSt1) / 11),
    AgeAvg =< MaxAvgAge,
    
    country(IdGk, CountryGk),
    country(IdFb1, CountryFb1),
    country(IdFb2, CountryFb2),
    country(IdDc1, CountryDc1),
    country(IdDc2, CountryDc2),
    country(IdDc3, CountryDc3),
    country(IdDm1, CountryDm1),
    country(IdDm2, CountryDm2),
    country(IdW1, CountryW1),
    country(IdW2, CountryW2),
    country(IdSt1, CountrySt1),

    count_nazionalita([CountryGk, CountryFb1, CountryFb2, CountryDc1, CountryDc2, CountryDc3, CountryDm1, CountryDm2, CountryW1, CountryW2, CountrySt1], Nationality, TotaleNazionalita),
    MinNationality =< TotaleNazionalita.