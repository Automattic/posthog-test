#!/usr/bin/env bash
set -euf -o pipefail

while true
do
	echo "$(date '+%Y-%m-%d %H:%M:%S'),$(sudo docker exec posthog-clickhouse-1 clickhouse-client -d posthog -q 'select count(*) from events')" >> ch-counts.out
	sleep 10
done
