#!/bin/bash

OUTPUT_DIRECTORY=output
FILE="$OUTPUT_DIRECTORY/processed.csv"
LEGEND_FACTIONS="$OUTPUT_DIRECTORY/legend-factions.txt"
LEGEND_RESULTS="$OUTPUT_DIRECTORY/legend-results.txt"

if [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
    if ! mkdir "$OUTPUT_DIRECTORY"; then
        echo "Could not create output directory $OUTPUT_DIRECTORY, aborting..."
        exit 1
    fi
fi

replace_booleans=false
nuke_timestamps=false
replace_factions=false
overwrite_output=false
nuke_line_numbers=true
dry_run=false
replace_results=false
nuke_versions=false

# Process CLI parameters
ARGS=$(getopt -n $0 -o bfFNrtv -l "booleans,factions,force,dry-run,results,timestamps,versions" -- "$@")
if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
        -b|--booleans)
            replace_booleans=true
            ;;
        -f|--factions)
            replace_factions=true
            ;;
        -F|--force)
            overwrite_output=true
            ;;
        -N|--dry-run)
            dry_run=true
            ;;
        -r|--results)
            replace_results=true
            ;;
        -t|--timestamps)
            nuke_timestamps=true
            ;;
        -v|--versions)
            nuke_versions=true
            ;;
        --)
            shift
            break
    esac
    shift || break
done

if ! $dry_run && ! $overwrite_output; then
    if [[ -f "$FILE" ]]; then
        echo "File $FILE already exists, aborting..."
        exit 1
    fi
    if [[ $replace_factions && -f "$LEGEND_FACTIONS" ]]; then
        echo "File $LEGEND_FACTIONS already exists, aborting..."
        exit 1
    fi
    if [[ $replace_results && -f "$LEGEND_RESULTS" ]]; then
        echo "File $LEGEND_RESULTS already exists, aborting..."
        exit 1
    fi
fi

# Copy input file to output file
cp "$1" "$FILE"

# Function for replacing occurences of string values from given columns
# with numeral values
# Arg 1: legend file
# Args 2-: which columns' values to use for replacements
replace() {
    legend_file=$1
    shift
    id=0
    OLDIFS="$IFS"
    IFS=$'\n'
    for string in $(for c in "$@"; do tail -n+2 "$FILE" | cut -d , -f "$c"; done | sort -u); do
        echo "Replacing ${string} with ${id} ..."
        echo $id $string >> "$legend_file"
        if ! $dry_run; then
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
    while true; do
        header=$(head -n1 "$FILE" | cut -d , -f $i 2>/dev/null)
        if [ -n "$header" ]; then
            if [[ "$header" == $sought_header ]]; then
                echo $i
                return 0
            fi
            ((i++))
        else
            return 1
            break
        fi
    done
}

nuke_column() {
    col=$1
    tmpfile=$(mktemp) && cut -d , -f -$(($col-1)),$(($col+1))- "$FILE" > "$tmpfile" && cat "$tmpfile" > "$FILE" && rm "$tmpfile"
}

if $nuke_line_numbers; then
    echo "Nuking line numbers..."
    if ! $dry_run; then
        tmpfile=$(mktemp) && cut -d , -f 2- "$FILE" > "$tmpfile" && cat "$tmpfile" > "$FILE" && rm "$tmpfile"
    fi
fi

if $nuke_timestamps; then
    echo "Nuking timestamps..."
    if ! $dry_run; then
        for header in GameStart Duration; do
            c=$(colnum "$header")
            if [[ $? ]]; then
                nuke_column "$c"
            fi
        done
    fi
fi

if $nuke_versions; then
    echo "Nuking versions..."
    if ! $dry_run; then
        c=$(colnum Version)
        if [[ $? ]]; then
            nuke_column "$c"
        fi
    fi
fi

# Replace faction name with numeral ID
if $replace_factions; then
    replace "$LEGEND_FACTIONS" $(colnum Player_Faction) $(colnum Opponent_Faction)
fi

if $replace_results; then
    replace "$LEGEND_RESULTS" $(colnum Result)
fi

if $replace_booleans; then
    echo "Replacing false with 0 (case insensitive)..."
    if ! $dry_run; then
        sed -i 's#false#0#gi' "$FILE"
    fi

    echo "Replacing true with 1 (case insensitive)..."
    if ! $dry_run; then
        sed -i 's#true#1#gi' "$FILE"
    fi
fi
