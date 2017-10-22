#!/bin/bash

a=( `find . -type f -iname *.rar -print0 | xargs -r0 -n 1 echo | tr ' ' '~'` )
for i in ${a[*]} ; do
  b=`echo $i | tr '~' ' '`
  echo $b
  d=`echo $b | rev | cut -d\/ -f 2- | rev`
  echo $d
#  unzip -o -d "$d" "$b"
  rar x -o+ -w"$d" "$b"
  rm "$b"
done
