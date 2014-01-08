matches=csvread('preprocessed/data.csv', 1, 0);

addpath('preprocessed')

column_enumeration;
legend_results;

cardgamedb_colors;

factions_corp;
factions_runner;

Colormap_Corp = Colormap_Corp/max(max(Colormap_Corp));
Colormap_Runner = Colormap_Runner/max(max(Colormap_Runner));
