#!/bin/sh

query=$1

header="<?xml version=\"1.0\"?> <items>"
rt="<item uid=\"kill_ps_by_keyword\" arg=\"%s\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle></item>"
footer="</items>"

if [[ $query != "" ]]; then
    ps=$(ps -A -o pid,comm | grep -i "$query")
fi

#echo $header
#OLD_IFS=$IFS
#IFS=$'\n'
#for p in $ps
#do
    #ps_command=$(echo "$p" | awk '{for(i=2; i<=NF; ++i) {printf "%s ", $i} printf "\n"}')
    #app_name=$(echo "$ps_command" | awk -F '/' '{print $NF}')
    #ps_id=$(echo "$p" | awk '{print $1}')
    #echo $(printf "$rt" "$ps_id" "$app_name" "$ps_command")
#done
#IFS=$OLD_IFS
#echo $footer

echo $header
echo "$ps" | while read ps_id ps_command
do
    app_name=$(echo "$ps_command" | awk -F '/' '{print $NF}')
    printf "$rt" "$ps_id" "$app_name" "$ps_command"
done
echo $footer
