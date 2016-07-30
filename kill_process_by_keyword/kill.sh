#!/bin/sh

ps_keyword=$1

if [[ $ps_keyword != "" ]];then
    pid=$(ps aux | grep -i "$ps_keyword" | grep -v "$0" | grep -v "grep")
fi

if [[ $pid != "" ]];then
    echo $pid | awk '{print $2}' | xargs kill -9
fi
