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
matches=csvread('preprocessed/data.csv', 1, 0);

addpath('preprocessed')

column_enumeration;
legend_results;

cardgamedb_colors;

factions_corp;
factions_runner;

Colormap_Corp = Colormap_Corp/max(max(Colormap_Corp));
Colormap_Runner = Colormap_Runner/max(max(Colormap_Runner));
