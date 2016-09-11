#!/bin/sh

query=$1

header="<?xml version=\"1.0\"?> <items>"
rt="<item uid=\"kill_ps_by_keyword\" arg=\"%s\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle></item>"
footer="</items>"

if [[ $query != "" ]]; then
    ps=$(ps -A -o pid,comm | grep -i "$query")
fi

echo $header
echo "$ps" | while read ps_id ps_command
do
    app_name=$(echo "$ps_command" | awk -F '/' '{print $NF}')
    printf "$rt" "$ps_id" "$app_name" "$ps_command"
done
echo $footer
