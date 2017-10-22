#!/bin/bash

CURDIR=`pwd`
REPORTFILE="$CURDIR/wav_md5s_report.txt"
rm "$REPORTFILE"
touch "$REPORTFILE"

find . -type f | while read fn ; do
  if [[ `echo $fn | grep -i \.flac$` ]] ; then
    len=`ls -la "$fn" | cut -d' ' -f 5`
    md5s=`metaflac --show-md5sum "$fn"`
    fn2=$CURDIR`echo $fn | cut -c3-`
    echo $md5s $len $fn2
  fi
done | tee $REPORTFILE
