#!/bin/sh

INFILE=$1
OUTFILE=$2

if [ x"$INFILE" == "x" -o x"$OUTFILE" == "x" ]; then
    echo "Usage: $0 <infile> <outfile>"
    exit 1
fi
	
mkfifo -m 600 stream.yuv
	
#-J logo=file=/home/kostya/deblogo.png:flip=1:grayout=1:posdef=4
	
( 
    echo "Starting first pass"
    transcode -R 1 -H 0 -f 25 -i stream.yuv -x yuv4mpeg,null -g 320x240 -z -w 350 -o $OUTFILE -y xvidraw,null &
    sleep 2
    mplayer -vop pp=tn:2:2:3/dr/hb:c/vb:c -noframedrop -vo yuv4mpeg -ao null -ac null -nosound $INFILE >/dev/null 2>&1
) && sleep 5 && (
    echo "Starting second pass"
    transcode -R 2 -H 0 -f 25 -i stream.yuv -x yuv4mpeg,null -g 320x240 -z -w 350 -o $OUTFILE -y xvidraw,null &
    sleep 2
    mplayer -vop pp=tn:2:2:3/dr/hb:c/vb:c -noframedrop -vo yuv4mpeg -ao null -ac null -nosound $INFILE > /dev/null 2>&1
) && sleep 5 && rm -f stream.yuv divx4.log
