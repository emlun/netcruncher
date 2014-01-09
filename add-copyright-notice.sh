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

    lines_before_copyright=0
    case $extension in
        m)
            row_prefix="% "
            ;;
        sh)
            row_prefix="# "
            if head -n1 "$file" | grep -qE "^#!"; then
                lines_before_copyright=1
            fi
            ;;
    esac

    head -n${lines_before_copyright} "$file" >> "$tmpfile"

    print_formatted_copyright() {
        # Add comment prefix and strip trailing spaces
        print_copyright | sed "s/^/${row_prefix}/" | sed 's/[[:space:]]*$//'
    }
    print_formatted_copyright >> "$tmpfile"

    # Check if target file already contains the first row of the copyright notice
    if grep -q "$(print_formatted_copyright | head -n1)" "$file"; then
        # Copyright notice already exists - replace it
        last_copyright_line=$(print_formatted_copyright | grep -n "$(tail -n1 $tmpfile)" | cut -d : -f 1)
        tail -n+$((last_copyright_line+1)) "$file" >> "$tmpfile"
    else
        # No previous copyright notice
        tail -n+$((lines_before_copyright+1)) "$file" >> "$tmpfile"
    fi

    mv "$tmpfile" "$file"
done
