#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: filename.srt to convert."
    exit 1
fi
SRT_FILE="Z:`pwd`/$1"
SRT_FILE2=`echo $SRT_FILE | tr '/' '\\\\'`
#echo $SRT_FILE2
wine "Z:\home\dmitry\bin\txt2vobsub.exe" "$SRT_FILE2" 0 4 0 14 0 30 -4 1 5 0 12 29 2 2
