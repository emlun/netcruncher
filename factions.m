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
