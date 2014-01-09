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

print_copyright() {
    cat << EOF
Copyright 2014 Emil Lundberg

This file is part of Netcruncher.

Netcruncher is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

Netcruncher is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Netcruncher.  If not, see <http://www.gnu.org/licenses/>.
EOF
}

if [[ $# < 1 ]]; then
    cat << EOF
Usage: $(basename $0) FILES...
EOF
    exit 1
fi

for file in "$@"; do
    # Make tmp file for building output incrementally
    tmpfile=$(mktemp tmp.$(basename $0).XXXXXXXXXX)
    chmod --reference="$file" "$tmpfile"
    if [[ $? -ne 0 ]]; then
        echo "Failed to create temporary file - skipping $file"
        continue
    fi
    extension=$(basename "$file" | grep -oE "\.([^.]*)$" | cut -d . -f 2)

    case $extension in
        m)
            row_prefix="% "
            ;;
        sh)
            row_prefix="# "
            ;;
    esac

    print_formatted_copyright() {
        # Add comment prefix and strip trailing spaces
        print_copyright | sed "s/^/${row_prefix}/" | sed 's/[[:space:]]*$//'
    }
    print_formatted_copyright >> "$tmpfile"
    cat "$file" >> "$tmpfile"

    mv "$tmpfile" "$file"
done
