#!/bin/sh

pid=$1

if [[ $pid != "" ]]; then
    kill -9 $pid
fi
