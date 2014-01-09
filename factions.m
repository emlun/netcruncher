% Copyright 2014 Emil Lundberg
%
% This file is part of Netcruncher.
%
% Netcruncher is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 2 of the License, or
% (at your option) any later version.
%
% Netcruncher is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Netcruncher.  If not, see <http://www.gnu.org/licenses/>.
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
title('Corp identity prevalences');
align_pie_labels(h, Faction_Labels_Corp);
colormap(Colormap_Corp);

figure(fignum+1);
clf;
h=pie(runner_faction_match_counts);
title('Runner identity prevalences');
align_pie_labels(h, Faction_Labels_Runner);
colormap(Colormap_Runner);

%% Identities' win rates

corp_id_win_rates = zeros(length(Factions_Corp),1);
for corp_id=Factions_Corp
    win_corp_id = matches(matches(:,Player_Faction)==corp_id,Win);
    corp_id_win_rates(corp_id) = sum(win_corp_id)/size(win_corp_id,1);
end

runner_id_win_rates = zeros(length(Factions_Runner),1);
for runner_id=Factions_Runner
    win_runner_id = matches(matches(:,Opponent_Faction)==runner_id,Win);
    runner_id_win_rates(runner_id) = sum(win_runner_id==0)/size(win_runner_id,1);
end

figure(fignum+2);
clf;

subplot(1,2,1);
hold on;
plot([0.5,0.5],[0.5,Factions_Corp(end)+0.5],'r')

bar_faction(corp_id_win_rates, Factions_Haas_Bioroid, HAAS_BIOROID_COLOR);
bar_faction(corp_id_win_rates, Factions_Jinteki, JINTEKI_COLOR);
bar_faction(corp_id_win_rates, Factions_NBN, NBN_COLOR);
bar_faction(corp_id_win_rates, Factions_Weyland, WEYLAND_COLOR);

title('Corp identities'' win rates');
xlabel('Win rate');
set(gca, 'YTickLabel', Faction_Labels_Corp);
axis([0, 1, -Inf, Inf]);
axis ij

subplot(1,2,2);
hold on;
barh(runner_id_win_rates);
plot([0.5,0.5],[0.5,Factions_Runner(end)+0.5],'r')

bar_faction(runner_id_win_rates, Factions_Anarch, ANARCH_COLOR);
bar_faction(runner_id_win_rates, Factions_Criminal, CRIMINAL_COLOR);
bar_faction(runner_id_win_rates, Factions_Shaper, SHAPER_COLOR);

title('Runner identities'' win rates');
xlabel('Win rate');
set(gca, 'YTickLabel', Faction_Labels_Runner);
axis([0, 1, -Inf, Inf]);
axis ij
