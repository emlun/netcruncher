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
player_ids = unique([matches(:,Corp_Player); matches(:,Runner_Player)]);
num_players = max(player_ids);

MIN_MATCHES = 4;
BINS = 10;
HEATMAP_BINS = {0:0.05:1, 0:0.05:1};

player_win_rates = nan(num_players,1);
corp_win_rates = nan(num_players,1);
runner_win_rates = nan(num_players,1);
for player=player_ids'
    corp_matches = matches(matches(:,Corp_Player)==player,:);
    runner_matches = matches(matches(:,Runner_Player)==player,:);
    num_corp_matches = size(corp_matches,1);
    num_runner_matches = size(runner_matches,1);
    if num_corp_matches >= MIN_MATCHES
        corp_win_rates(player) = sum(corp_matches(:,Win))/num_corp_matches;
    end
    if num_runner_matches >= MIN_MATCHES
        runner_win_rates(player) = sum(runner_matches(:,Win)==0)/num_runner_matches;
    end
    if num_corp_matches + num_runner_matches >= MIN_MATCHES
        player_win_rates(player) = (sum(corp_matches(:,Win)) + sum(runner_matches(:,Win)==0))/(num_corp_matches + num_runner_matches);
    end
end

% Draw histograms of win rates
figure(fignum);
clf;

subplot(1,3,1);
hist(player_win_rates, BINS);
title(['Player overall win rates (' num2str(MIN_MATCHES) '+ games)']);
xlabel('Win rate');
ylabel('Number of players');

subplot(1,3,2);
hist(corp_win_rates, BINS);
title(['Corp win rates (' num2str(MIN_MATCHES) '+ games)']);
xlabel('Win rate');
ylabel('Number of players');

subplot(1,3,3);
hist(runner_win_rates, BINS);
title(['Runner win rates (' num2str(MIN_MATCHES) '+ games)']);
xlabel('Win rate');
ylabel('Number of players');

print('-dpng', [FIGURES_DIR '/png/winrates.png']);

% Draw point cloud of players' win rates on the corp-rate/runner-rate plane
figure(fignum+1);
clf;
plot(corp_win_rates, runner_win_rates, 'x');
title(['Players'' win rates (' num2str(MIN_MATCHES) '+ games)']);
xlabel('Corp win rate');
ylabel('Runner win rate');
legend('One player');
axis equal;
axis([0 1 0 1]);

print('-dpng', [FIGURES_DIR '/png/winrates-cloud.png']);

% Draw heatmap of players' win rates on the corp-rate/runner-rate plane
figure(fignum+2);
clf;
colormap(hot);
imagesc(hist3([corp_win_rates,runner_win_rates], HEATMAP_BINS));
title(['Heatmap of players'' win rates (' num2str(MIN_MATCHES) '+ games)']);
xlabel('Corp win rate');
ylabel('Runner win rate');
colorbar
axis image xy
set(gca, 'XTick', linspace(1,length(HEATMAP_BINS{1}),11), 'XTickLabel', 0:0.1:1);
set(gca, 'YTick', linspace(1,length(HEATMAP_BINS{2}),11), 'YTickLabel', 0:0.1:1);

print('-dpng', [FIGURES_DIR '/png/winrates-heatmap.png']);
