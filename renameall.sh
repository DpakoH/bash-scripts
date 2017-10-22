#!/bin/bash

declare -a a
a=( `find . -maxdepth 1 -mindepth 1 -type d -print0 | xargs -r0 -n 1 echo | sort | tr ' ' '_'` )

for i in ${a[*]} ; do
    b=`echo $i | tr '_' ' ' | cut -c 3-`
    y=`echo $b | cut -c 1-4`
    t=`echo $b | cut -c 6-`
    echo "mv \"$b\" \"[$y] $t\""
    mv "$b" "[$y] $t"
done
