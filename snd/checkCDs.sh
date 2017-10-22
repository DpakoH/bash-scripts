#!/bin/bash

CURDIR=`pwd`
WORKDIR="/mnt/raid/music/2check"
cd "$WORKDIR"
#WAVFILE="/mnt/hdb5/tmp.wav"
WAVFILE="$WORKDIR/tmp.wav"
REPORTFILE="$WORKDIR/report.txt"
declare -a a
echo "Analysis started." > "$REPORTFILE"
rm "$WAVFILE"
a=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.wav$ | tr ' ' '\`'` )
for i in ${a[*]} ; do
    b=`echo $i | tr '\`' ' '`
    echo "Checking $b ..." >> "$REPORTFILE"
    auCDtect -v "$b" >> "$REPORTFILE"
done
a=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.flac$ | tr ' ' '\`'` )
for i in ${a[*]} ; do
    b=`echo $i | tr '\`' ' '`
    echo -n "Checking $b ..." >> "$REPORTFILE"
    flac -t "$b" 2>/dev/null
    if [ "$?" -eq "0" ] ; then
      echo "ok." >> "$REPORTFILE"
      flac -d -c "$b" > "$WAVFILE" 2>/dev/null
      auCDtect -v "$WAVFILE" >> "$REPORTFILE" 2>/dev/null
      rm "$WAVFILE"
    else
      echo "failed." >> "$REPORTFILE"
    fi
    echo -n "."
done
echo "Analysis finished." >> $REPORTFILE

cd "$CURDIR"
