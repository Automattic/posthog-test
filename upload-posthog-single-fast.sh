#!/usr/bin/env bash

JSONLGZ="$1"

rm -rf "$JSONLGZ-split"
mkdir "$JSONLGZ-split"
zcat "$JSONLGZ" | split -l 100 -a 6 - "$JSONLGZ-split/events-"

function _upload()
{
        curl -sSkL --header "Content-Type: application/json" -d '{
        "api_key": "phc_XeEekYZ5upJ5FAod48ZDL0rO84EbP18t7P34nxqZOA1",
        "historical_migration": true,
        "batch": '"$(jq -s '.' < "$1")"'
        }' 'https://ec2-18-208-247-78.compute-1.amazonaws.com/batch/' > /dev/null
        echo -n .
}

export -f _upload

ls $JSONLGZ-split/events-aaa* | xargs -I% -P 50 bash -c '_upload %'
