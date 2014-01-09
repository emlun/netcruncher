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

OUTPUT_DIRECTORY=preprocessed
FILE="$OUTPUT_DIRECTORY/data.csv"
LEGEND_RESULTS="$OUTPUT_DIRECTORY/legend_results.m"
FACTIONS_CORP="$OUTPUT_DIRECTORY/factions_corp.m"
FACTIONS_RUNNER="$OUTPUT_DIRECTORY/factions_runner.m"
COLUMN_ENUMERATION="$OUTPUT_DIRECTORY/column_enumeration.m"

replace_booleans=true
nuke_timestamps=true
replace_factions=true
overwrite_output=false
nuke_line_numbers=true
replace_nulls=true
dry_run=false
replace_results=true
nuke_versions=true

# Process CLI parameters
ARGS=$(getopt -n $0 -o bfFnNrtv -l "booleans,factions,force,nulls,dry-run,results,timestamps,versions" -- "$@")
if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
        -b|--booleans)
            replace_booleans=false
            ;;
        -f|--factions)
            replace_factions=false
            ;;
        -F|--force)
            overwrite_output=true
            ;;
        -n|--nulls)
            replace_nulls=false
            ;;
        -N|--dry-run)
            dry_run=true
            ;;
        -r|--results)
            replace_results=false
            ;;
        -t|--timestamps)
            nuke_timestamps=false
            ;;
        -v|--versions)
            nuke_versions=false
            ;;
        --)
            shift
            break
    esac
    shift || break
done

if [[ $# < 1 ]] ; then
    cat << EOF
Usage: $(basename $0) [options] input_file

Options:
    -F|--force
        Overwrite output files if they exist
    -N|--dry-run
        Print what would be done, but don't change any files
EOF
    exit 1
fi

if [[ -d "$OUTPUT_DIRECTORY" ]]; then
    if ! $dry_run && ! $overwrite_output; then
        echo "Directory ${OUTPUT_DIRECTORY} already exists, aborting..."
        exit 1
    fi
else
    if ! mkdir "$OUTPUT_DIRECTORY"; then
        echo "Could not create output directory $OUTPUT_DIRECTORY, aborting..."
        exit 1
    fi
fi


# Copy input file to output file
if $dry_run; then
    FILE="$1"
else
    cp "$1" "$FILE"
fi

# Function for replacing occurences of string values from given columns
# with numeral values
# Arg 1: legend file
# Args 2-: which columns' values to use for replacements
replace() {
    legend_file=$1
    $dry_run || rm -f $legend_file
    shift
    id=1
    OLDIFS="$IFS"
    IFS=$'\n'
    for string in $(for c in "$@"; do tail -n+2 "$FILE" | cut -d , -f "$c"; done | sort -u); do
        echo "Replacing ${string} with ${id} ..."
        if ! $dry_run; then
            echo $(echo $string | sed 's/"//g' | sed 's/ | /_/g' | sed 's/[^a-zA-Z0-9]/_/g')"=$id;" >> "$legend_file"
            sed -i "s#${string}#${id}#g" "$FILE"
        fi
        ((id++))
    done
    IFS="$OLDIFS"
}

# Outputs the first column whose header equals the argument.
# Exit code is 0 if the column was found, 1 otherwise.
colnum() {
    sought_header=$1
    i=1
    OLDIFS="$IFS"
    IFS=','
    for header in $(head -n1 "$FILE"); do
        if [[ "$header" == $sought_header ]]; then
            echo $i
            IFS="$OLDIFS"
            return 0
        fi
        ((i++))
    done
    IFS="$OLDIFS"
    return 1
}

nuke_column() {
    col=$1
    echo "Nuking column ${col}..."
    $dry_run || (tmpfile=$(mktemp) && cut -d , -f -$(($col-1)),$(($col+1))- "$FILE" > "$tmpfile" && cat "$tmpfile" > "$FILE" && rm "$tmpfile")
}

if $nuke_line_numbers; then
    echo "Nuking line numbers..."
    $dry_run || (tmpfile=$(mktemp) && cut -d , -f 2- "$FILE" > "$tmpfile" && cat "$tmpfile" > "$FILE" && rm "$tmpfile")
fi

if $nuke_timestamps; then
    echo "Nuking timestamps..."
    for header in GameStart Duration; do
        c=$(colnum "$header")
        if [[ $? ]]; then
            nuke_column "$c"
        fi
    done
fi

if $nuke_versions; then
    echo "Nuking versions..."
    c=$(colnum Version)
    if [[ $? ]]; then
        nuke_column "$c"
    fi
fi

# Replace faction name with numeral ID
if $replace_factions; then
    echo "Fixing Kit..."
    $dry_run || sed -i 's/"Shaper | Rielle ""Kit"" Peddler"/Shaper | Rielle "Kit" Peddler/g' "$FILE"

    echo "Replacing identity names with integers..."
    replace "$FACTIONS_CORP" $(colnum Player_Faction)
    replace "$FACTIONS_RUNNER" $(colnum Opponent_Faction)

    make_metadata() {
        side=$1
        output=$2
        if $dry_run; then
            src="$output"
        else
            src=$(mktemp)
            cp "$output" "$src"
        fi

        echo "Making list of ${side} identity integers..."
        $dry_run || echo "Factions_${side} = 1:$(wc -l $src | cut -d \  -f 1);" >> "$output"

        echo "Making ${side} colormap for coloring graphs..."
        if ! $dry_run; then
            echo "Colormap_${side} = [" >> "$output"
            cut -d = -f 1 "$src" \
                | sed "s/.*haas_bioroid.*/HAAS_BIOROID_COLOR;/i" \
                | sed "s/.*jinteki.*/JINTEKI_COLOR;/i" \
                | sed "s/.*nbn.*/NBN_COLOR;/i" \
                | sed "s/.*weyland_consortium.*/WEYLAND_COLOR;/i" \
                | sed "s/.*anarch.*/ANARCH_COLOR;/i" \
                | sed "s/.*criminal.*/CRIMINAL_COLOR;/i" \
                | sed "s/.*shaper.*/SHAPER_COLOR;/i" \
                >> "$output"
            echo '];' >> "$output"
        fi

        # Add faction loyalties to output
        make_faction_loyalty() {
            for faction in "$@"; do
                echo "Making list of ${faction} identities..."
                if ! $dry_run; then
                    echo "Factions_${faction} = [" >> "$output"
                    grep -Ei ".*${faction}.*=" "$src" | cut -d = -f 2 >> "$output"
                    echo "];" >> "$output"
                fi
            done
        }
        case "$side" in
            "Corp")
                make_faction_loyalty "Haas_Bioroid" "Jinteki" "NBN" "Weyland"
                ;;
            "Runner")
                make_faction_loyalty "Anarch" "Criminal" "Shaper"
                ;;
        esac

        echo "Making identity name labels..."
        if ! $dry_run; then
            echo "Faction_Labels_${side} = {" >> "$output"
            cut -d = -f 1 "$src" | sed 's/Haas_/Haas-/g' | sed 's/Weyland_/Weyland /' | sed 's/^[^_]*_//' | sed 's/_/ /g' | sed "s/.*/'\0';/" >> "$output"
            echo '};' >> "$output"
        fi

        $dry_run || rm "$src"
    }
    make_metadata Corp "$FACTIONS_CORP"
    make_metadata Runner "$FACTIONS_RUNNER"
fi

if $replace_results; then
    replace "$LEGEND_RESULTS" $(colnum Result)
fi

if $replace_booleans; then
    echo "Replacing false with 0 (case insensitive)..."
    $dry_run || sed -i 's#false#0#gi' "$FILE"

    echo "Replacing true with 1 (case insensitive)..."
    $dry_run || sed -i 's#true#1#gi' "$FILE"
fi

if $replace_nulls; then
    echo "Replacing NA with -1 ..."
    $dry_run || sed -i 's#NA#-1#g' "$FILE"
fi

echo "Writing column header enumeration..."
OLDIFS="$IFS"
IFS=','
i=1
$dry_run || rm -f "$COLUMN_ENUMERATION"
for c in $(head -n1 "$FILE"); do
    if ! $dry_run; then
        echo "$c=$i;" | sed 's/\./_/g' >> "$COLUMN_ENUMERATION"
    fi
    ((i++))
done
