maxGames=max(matches(:,Turns_Played));
bins=0:maxGames;

figure(fignum);
clf;
hist(matches(:,Turns_Played),bins);
title('Distribution of number of turns played');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])

figure(fignum+1);
clf;

subplot(2,4,1);
hist(matches(matches(:,Win)==1,Turns_Played),bins);
title('Corp win');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])

subplot(2,4,5);
hist(matches(matches(:,Win)==0,Turns_Played),bins);
title('Runner win');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])


subplot(2,4,2);
hist(matches(matches(:,Result)==AgendaVictory,Turns_Played),bins);
title('Corp agenda victory');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])

subplot(2,4,6);
hist(matches(matches(:,Result)==AgendaDefeat,Turns_Played),bins);
title('Runner agenda victory');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])


subplot(2,4,3);
hist(matches((matches(:,Result)==AgendaVictory | matches(:,Result)==AgendaDefeat),Turns_Played),bins);
title('Either agenda victory');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])


subplot(2,4,4);
hist(matches(matches(:,Result)==FlatlineVictory,Turns_Played),bins);
title('Flatline victory');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])

subplot(2,4,8);
hist(matches(matches(:,Result)==DeckDefeat,Turns_Played),bins);
title('R&D exhaustion');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])
