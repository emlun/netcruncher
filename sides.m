figure(fignum);
clf;
pie([sum(matches(:,Win)), sum(matches(:,Win)==0)], {'Corp wins', 'Runner wins'})
colormap([0,0,0.7;0.7,0,0]);
title('Overall win rate balance');
