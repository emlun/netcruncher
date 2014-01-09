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
maxGames=max(matches(:,Turns_Played));
bins=0:maxGames;

figure(fignum);
clf;
hist(matches(:,Turns_Played),bins);
title('Distribution of number of turns played');
xlabel('Number of turns');
ylabel('Number of games');
axis([0, maxGames, 0, Inf])

print('-dpng', [FIGURES_DIR '/png/turns.png']);

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

print('-dpng', [FIGURES_DIR '/png/turns-details.png']);
