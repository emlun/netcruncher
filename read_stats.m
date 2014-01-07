% Corp_Player,Player_Faction,Runner_Player,Opponent_Faction,Result,Turns_Played,Win,Influence,OpInf,Corp_score,Runner_score,Agendas.Nr.,Corp.Deck.Size,Runner.Deck.Size
path(path,'output')

matches=csvread('processed.csv', 1, 0);

column_enumeration;
legend_factions;
legend_results;
factions_corp;
factions_runner;
