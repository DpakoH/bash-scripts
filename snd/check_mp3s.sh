#!/bin/bash

#exit 0

declare -a a

rm report.txt
touch report.txt

a=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.mp3$ | tr ' ' '^'` )
for i in ${a[*]} ; do
  b=`echo "$i" | tr '^' ' ' | cut -c 3-`
  d=`dirname "$b"`
  r=`checkmp3 "$b" 2>&1 | grep "BAD_FRAMES" | tr -s " " | cut -d" " -f 2`
  if [ $r != 0 ] ; then
    echo "$b failed." | tee -a report.txt
    if [ -d "$d" ] ; then
      mkdir -p "failed/$d"
    fi
    mv "$b" "failed/$b"
  else
    echo "$b"
  fi
done
