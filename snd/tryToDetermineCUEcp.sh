#!/bin/bash

for i in `iconv --list` ; do
  a=`echo $i | rev | cut -c 3- | rev`
  c=`echo $a | tr '/' '_'`
  cat "CDImage.cue.no_utf8" | iconv -f $a > "CDImage.cue.$c" 2>/dev/null
  if [ "$?" -eq "0" ] ; then
    if cat "CDImage.cue.$c" | grep "TRACK 01 AUDIO" >/dev/null  ; then
      echo $a
    else
      rm "CDImage.cue.$c"
    fi
  else
    rm "CDImage.cue.$c"
  fi
done
