#!/usr/bin/env bash

SLEEP=900
COUNT=0
for GZ in part-*.gz
do
        echo "$GZ - $SLEEP"

        rm -rf "$GZ-split"
        mkdir "$GZ-split"
        zcat "$GZ" | split -l 100 -a 6 - "$GZ-split/events-"

        for F in $GZ-split/events-*
        do
                if ! curl -s -S -k -L --header "Content-Type: application/json" -d '{
                "api_key": "phc_XeEekYZ5upJ5FAod48ZDL0rO84EbP18t7P34nxqZOA1",
                "historical_migration": true,
                "batch": '"$(jq -s '.' < "$F")"'
                }' 'https://ec2-18-208-247-78.compute-1.amazonaws.com/batch/' > /dev/null
                then
                        echo "$F" >> insert-failed.txt
                else
                        COUNT="$((COUNT + 100))"
                        echo "$(date '+%Y-%m-%d %H:%M:%S'),$COUNT" >> insert-counts.out
                        echo -n '.'
                fi
                sleep "0.$SLEEP"
        done

        SLEEP="$((SLEEP - 100))"
done
