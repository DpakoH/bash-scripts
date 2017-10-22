#!/bin/bash

WORKDIR=`pwd`
WAVFILE="/tmp/tmp.wav"
TOTAL_REPORT="$WORKDIR/total_report.txt"
REPORTFILE="./aucdtect_report.txt"
echo -n "" > "$TOTAL_REPORT"
declare -a files
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
  cut -c 3- | sort | while read dir ; do
  cd "$dir"
  if [ "$?" -eq "0" ] ; then
    echo "Analysis started." > "$REPORTFILE"
    echo "Analysis started for \"$dir\"" >> "$TOTAL_REPORT"
    files=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.wav$ | tr ' ' '\`'` )
    #echo "$files"
    for i in ${files[*]} ; do
      b=`echo $i | tr '\`' ' '`
      echo "Checking $b ..." >> "$REPORTFILE"
      auCDtect -v "$b" >> "$REPORTFILE"
    done
    files=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.flac$ | tr ' ' '\`'` )
    #echo "$files"
    for i in ${files[*]} ; do
      b=`echo $i | tr '\`' ' '`
      echo -n "Checking $b ..." >> "$REPORTFILE"
      echo -n "Checking $b ..." >> "$TOTAL_REPORT"
      flac -t "$b" 2>/dev/null
      if [ "$?" -eq "0" ] ; then
        echo "ok." >> "$REPORTFILE"
        echo "ok." >> "$TOTAL_REPORT"
        flac -d -c "$b" > "$WAVFILE" 2>/dev/null
        auCDtect -v "$WAVFILE" >> "$REPORTFILE" 2>/dev/null
        rm "$WAVFILE"
      else
        echo "failed." >> "$REPORTFILE"
        echo "failed." >> "$TOTAL_REPORT"
      fi
      #echo -n "."
    done
    echo "Analysis finished." >> "$REPORTFILE"
    cd ..
  else
    echo "Failed to chdir to \"$dir\"" >> "$TOTAL_REPORT"
  fi
done
