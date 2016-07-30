#!/bin/sh

ps_keyword=$1

rt="<item uid=\"kill_ps_by_keyword\" arg=\"%s\"><title>%s</title> <icon></icon> <subtitle>%s</subtitle> </item>"

if [[ $ps_keyword != "" ]];then
    pid=$(ps aux | grep -i "luminglv" |  grep -i "$ps_keyword" | grep -v "$0" | grep -v "grep" | awk '{print $11}')
fi

echo "<?xml version=\"1.0\"?> <items>"

for p in $pid
do
    subtitle=$(echo $p | awk -F "/" '{print $NF}')
    echo $(printf "$rt" "$pid" "$subtitle" "$p")
done

echo "</items>"
