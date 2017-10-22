#!/bin/bash

find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.flac$ | sort | cut -c 3- | while read flac ; do
  content=`dd if="$flac" bs=8 count=1 2>/dev/null | od`
  #echo "\"$content\""
  if [[ $content = "0000000" ]] ; then
    echo "$flac failed (empty)" | tee -a report.txt
  fi
  if [[ "$a" =~ "0000000 000000 000000 000000 000000" ]] ; then 
    echo "$flac failed (zeroes)" | tee -a report.txt
  fi
done
