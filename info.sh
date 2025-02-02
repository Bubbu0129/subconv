#!/bin/bash

if [ "$#" -ne 0 ]; then
    echo "Usage: info.sh"
    exit 1
fi

GB=1073741824
f='%b %d'
info=`curl -sI "${subURL}&flag=clash" | grep -i 'subscription-userinfo' | tr -d '\r'`

if [[ "$info" =~ ^subscription-userinfo:\ upload=([0-9]+)\;\ download=([0-9]+)\;\ total=([0-9]+)\;\ expire=([0-9]+)$ ]]; then
    upload=$((BASH_REMATCH[1]/GB))
    download=$((BASH_REMATCH[2]/GB))
    total=$((BASH_REMATCH[3]/GB))
    pct=$(((BASH_REMATCH[1]+BASH_REMATCH[2])*100/BASH_REMATCH[3]))
    expire=`date -d "@${BASH_REMATCH[4]}" +"$f"\ %Y`
    i=0
    while [[ `date -d "$expire -$i month" +%s` -gt "$(date +%s)" ]]; do
	((i++))
    done
    ((i--))
    refresh=`date -d "$expire -$i month" +"$f"`

    echo -e "Upload: ${upload}GB\tDownload: ${download}GB"
    echo -e "Total: ${total}GB\tUsed: ${pct}%"
    echo "Refresh: ${refresh} Expire: ${expire}"
else
    echo "Error: info=\"$info\""
    exit 1
fi
