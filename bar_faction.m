%% BAR_FACTION(win_rates, factions_list, face_color)
% Draw a bar graph of win_rates(factions_list) versus factions_list
% and set the bar color to face_color.
%
% See also barh

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
function bar_faction(win_rates, factions_list, face_color)
    h=barh(factions_list, win_rates(factions_list));
    set(h, 'FaceColor', face_color);
end
