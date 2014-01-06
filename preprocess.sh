#!/bin/bash

OUTPUT_DIRECTORY=output
FILE="$OUTPUT_DIRECTORY/processed.csv"
LEGEND_FACTIONS="$OUTPUT_DIRECTORY/legend-factions.txt"

if [[ ! -d "$OUTPUT_DIRECTORY" ]]; then
    if ! mkdir "$OUTPUT_DIRECTORY"; then
        echo "Could not create output directory $OUTPUT_DIRECTORY, aborting..."
        exit 1
    fi
fi

replace_factions=false
overwrite_output=false

# Process CLI parameters
ARGS=$(getopt -n $0 -o fF -l "factions,force" -- "$@")
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
        --)
            shift
            break
    esac
    shift || break
done

if ! $overwrite_output; then
    if [[ -f "$FILE" ]]; then
        echo "File $FILE already exists, aborting..."
        exit 1
    fi
    if [[ $replace_factions && -f "$LEGEND_FACTIONS" ]]; then
        echo "File $LEGEND_FACTIONS already exists, aborting..."
        exit 1
    fi
fi

# Copy input file to output file
cp "$1" "$FILE"

# Replace faction name with numeral ID

if $replace_factions; then
    name_id=0
    OLDIFS="$IFS"
    IFS=$'\n'
    for name in $( (cut -d , -f 3 "$FILE"; cut -d , -f 5 "$FILE") | sort -u | grep -v Faction); do
    echo "Replacing ${name} with ${name_id} ..."
    echo $name_id $name >> "$LEGEND_FACTIONS"
    sed -i "s#${name}#${name_id}#g" "$FILE"
    name_id=$(($name_id+1))
    done
    IFS="$OLDIFS"
fi
