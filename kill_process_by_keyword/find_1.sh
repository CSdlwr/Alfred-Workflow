#!/bin/sh

query=$1

header="<?xml version=\"1.0\"?> <items>"
rt="<item uid=\"kill_ps_by_keyword\" arg=\"%s\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle></item>"
footer="</items>"

if [[ $query != "" ]]; then
    ps=$(ps aux | grep -i "luminglv" | grep -i "$query" | grep -v "$0" | grep -v "grep")
fi

echo $header
for p in $ps
do
    app_info=$(echo "$p" | awk '{for(i=11; i<=NF; ++i) {printf "%s ", $i} printf "\n"}')
    app_name=$(echo "$app_info" | awk -F '/' '{print $NF}')
    ps_id=$(echo "$p" | awk '{print $2}')
    echo $(printf "$rt" "$ps_id" "$app_info" "$app_name" "$app_info")
done
echo $footer
