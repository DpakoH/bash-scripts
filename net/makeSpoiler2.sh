#!/bin/bash

find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
     cut -c 3- | sort | while read dir ; do
 cd "$dir"
 if [ "$?" -eq "0" ] ; then
  newdir=`echo $dir | tr "[]" "()"`;
  echo "[spoiler=\"$newdir\"]"
  echo "[b]Tracklist:[/b]"
#  find . -type f -print0 | sort | xargs -r0 -n 1 echo | grep -i \.flac$ |
#      cut -c 3- | while read flac_file ; do
  find . -type f -print0 | xargs -0 -n 1 -I$ echo $ | grep -i \.flac$ |
      cut -c 3- | sort | while read flac_file ; do
   samples=`metaflac --list "$flac_file" | grep -a "total samples:" | cut -d' ' -f 5`
   rate=`metaflac --list "$flac_file" | grep -a "sample_rate:" | cut -d' ' -f 4`
   mins=`echo "$samples/$rate/60" | bc -l | cut -d'.' -f 1`
   if [ "$mins" = "" ]; then mins="0"; fi
   secs=`echo "$samples/$rate-$mins*60+0.5" | bc -l | cut -d'.' -f 1`
   if [ "$secs" = "" ]; then secs="0"; fi
   if (( $secs < 10  )) ; then secs="0$secs" ; fi
   #echo "$samples:$rate -> $mins:$secs"
   track=`echo $flac_file | rev | cut -d'.' -f 2- | rev`
   echo "$track ($mins:$secs)"
  done
  echo
  if [ -f "aucdtect_report.txt" ] ; then
    echo "[spoiler=\"Aucdtect log\"]"
    cat aucdtect_report.txt | grep "his track\|Checking "
    echo "[/spoiler]"
  else
    echo "[b]Sorry, no aucdtect log is provided[/b]"
  fi
#  echo
#  if [ -f *.log ] ; then
#    echo "[spoiler=\"EAC log\"]"
#    cat *.log | dos2unix | tr '[]' '{}'
#    echo "[b]EAC log in torrent[/b]"
#    echo "[/spoiler]"
#  else
#    echo "[b]Sorry, no EAC log provided[/b]"
#  fi
  echo "[/spoiler]"
  echo
  cd ..
 else
  echo "cd to \"$dir\" failed."
 fi
done
#exit 0
echo "----------------------------------------------------------------------"
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
     cut -c 3- | sort | while read dir ; do
 cd "$dir"
 if [ "$?" -eq "0" ] ; then
  newdir=`echo $dir | tr "[]" "()"`;
  if [ -f *.log ] ; then
    echo "[spoiler=\"$newdir\"]"
    cat *.log | dos2unix | iconv -f cp1251 | tr '[]' '{}'
    echo "[/spoiler]"
  else
    echo
  fi
  cd ..
 else
  echo "cd to \"$dir\" failed."
 fi
done
