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

replace_factions=false
overwrite_output=false
dry_run=false
replace_results=false

# Process CLI parameters
ARGS=$(getopt -n $0 -o fFNr -l "factions,force,dry-run,results" -- "$@")
if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
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
        id=$(($id+1))
    done
    IFS="$OLDIFS"
}

# Replace faction name with numeral ID
if $replace_factions; then
    replace "$LEGEND_FACTIONS" 3 5
fi

if $replace_results; then
    replace "$LEGEND_RESULTS" 8
fi
