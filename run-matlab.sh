#!/bin/bash
# Copyright 2014 Emil Lundberg
#
# This file is part of Netcruncher.
#
# Netcruncher is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Netcruncher is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Netcruncher.  If not, see <http://www.gnu.org/licenses/>.

./preprocess.sh $@
matlab -nosplash -nodesktop -r "run('run_matlab'); exit;"
