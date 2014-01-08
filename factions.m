figure(fignum);

corp_faction_match_counts = zeros(size(Factions_Corp));
runner_faction_match_counts = zeros(size(Factions_Runner));

for corp_faction=Factions_Corp
    corp_faction_match_counts(corp_faction) = size(matches(matches(:,Player_Faction)==corp_faction,:),1);
end
for runner_faction=Factions_Runner
    runner_faction_match_counts(runner_faction) = size(matches(matches(:,Opponent_Faction)==runner_faction,:),1);
end

figure(fignum);
clf;
h=pie(corp_faction_match_counts);
align_pie_labels(h, Faction_Labels_Corp);
colormap(Colormap_Corp);

figure(fignum+1);
clf;
h=pie(runner_faction_match_counts);
align_pie_labels(h, Faction_Labels_Runner);
colormap(Colormap_Runner);
