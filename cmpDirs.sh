#!/bin/bash

CDIR=`pwd`
if [[ $1 && $2 ]]
then
  DIR1="$1"
  DIR2="$2"
  cd "${DIR1}"
  find . -type f | while read fn ; do
    #echo "${fn}"
    ( md5sum "$fn" | cut -d' ' -f 1 > /tmp/md1 ) &
    ( md5sum "${DIR2}/$fn" | cut -d' ' -f 1 > /tmp/md2 ) &
    wait
    MD1=`cat /tmp/md1` ; MD2=`cat /tmp/md2`
    if [ "$MD1" != "$MD2" ] ; then
      echo -e "File \"$fn\" not equal\n  $MD1\n!=$MD2"
    fi
  done
else
  echo "Script needs two arguments: dir1 and dir2 for comparison"
fi
rm /tmp/md1
rm /tmp/md2
cd "$CDIR"
