player_ids = unique([matches(:,Corp_Player); matches(:,Runner_Player)]);
num_players = max(player_ids);

MIN_MATCHES = 4;
BINS = 10;

if 0
player_win_rates = nan(num_players,1);
corp_win_rates = nan(num_players,1);
runner_win_rates = nan(num_players,1);
for player=player_ids'
    player
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
