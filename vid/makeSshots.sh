#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: filename.avi to make sshots from."
    exit 1
fi
FILENAME="$1"
for i in `seq 0 59` ; do
  a=`printf %03d $i`
  mplayer -vo png:z=9 -ss $i:00 -frames 1 "$FILENAME"
  mv 00000001.png "${FILENAME}_${a}.png"
done
