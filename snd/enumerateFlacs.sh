#!/bin/bash

CURDIR=`pwd`
REPORTFILE="$CURDIR/wav_md5s_report.txt"
rm "$REPORTFILE"
touch "$REPORTFILE"

find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.flac$ | cut -c 3- | while read flac ; do
  md5s=`flac -d --until=100000 -c "$flac" 2>/dev/null | md5sum | cut -d' ' -f 1`
  # zero tracks check
  if [[ "$md5s" != "07f489d0251414e02f7b94f7dc10e04a" ]] ; then
    echo "$md5s $flac" | tee -a "$REPORTFILE"
  fi
done
