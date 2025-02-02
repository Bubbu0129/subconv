#!/bin/bash

if [ "$#" -ne 0 ]; then
    echo "Usage: update.sh"
    exit 1
fi

src="$(dirname "$(realpath "$0")")/src" 
source "$src/env"
dst="$HOME/.config/clash"
conf="$dst/config.yaml"

cat "$src/base.yaml" > "$conf"

printf 'Updating proxies: '
curl -s "$subURL" | \
    base64 -d | \
    $src/proxy.py "${codes[@]}" \
    >> "$conf"
echo 'Done.'

cat "$src/rules.yaml" >> "$conf"
echo 'Updating Rulesets:'
echo "  # Rules" >> "$conf"
for ruleset in "${rulesets[@]}"; do
    rule="${ruleset%%:*}"
    policy="${ruleset##*:}"
    echo "$rule: "
    curl "$ruleURL/$rule.txt" -# | $src/ruleset.py $rule $policy \
        >> "$conf"
done
printf '  - GEOIP,LAN,DIRECT\n  - GEOIP,CN,DIRECT\n  # White List\n  - MATCH,PROXY\n' \
    >> "$conf"

echo 'Done.'
