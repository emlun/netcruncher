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

replace_factions=true

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
