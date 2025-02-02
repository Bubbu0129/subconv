#!/bin/bash

source "$(dirname "$(realpath "$0")")/src/env"
url="$ctlURL/configs"
prev=`curl -sG "$url" | jq -r .mode | tr -d '\r'`
mode="${1,,}"

if [ "$#" -eq 0 ]; then
    echo "$prev"
elif [ "$mode" = "global" ] || [ "$mode" = "rule" ] || [ "$mode" = "direct" ]; then
    curl -X PATCH "$url" -d "{\"mode\":\"$mode\"}"
    echo "$prev -> $mode"
else
    echo "Usage: mode.sh [Global|Rule|Direct]"
    exit 1
fi
