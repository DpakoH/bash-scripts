#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: PERFORMER"
    exit 1
fi
PERFORMER="$1"

#REM GENRE Progressive Rock
#REM DATE 2008
#REM DISCID 6207DB08
#PERFORMER "Porcupine Tree"
#TITLE "We Lost The Skyline"
#FILE "Porcupine Tree - We Lost The Skyline.ape" WAVE
echo "REM GENRE ..."
echo "REM DATE ..."
echo "REM DISCID ..."
echo "PERFORMER \"$PERFORMER\""
echo "TITLE \"...\""
echo "FILE \"...\" WAVE"
i="1"
index="0"
find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.mp3$ |
    cut -c 3- | sort | while read mp3_file ; do
  dur=`mpginfo "$mp3_file" | grep "Estimated Duration" | cut -c 23-30 | tr '.' ':'`
  dur_mins=`echo $dur | cut -c1-2`
  dur_secs=`echo $dur | cut -c4-5`
  dur_huns=`echo $dur | cut -c7-8`
  #echo "$dur_mins $dur_secs $dur_huns"
  duration=`echo "$dur_mins*6000+$dur_secs*100+$dur_huns" | bc -l`
  #echo "$duration"
  track_name=`echo $mp3_file | rev | cut -c5- | rev | tr '_' ' '`
#  TRACK 01 AUDIO
#    TITLE "The Sky Moves Sideways"
#    INDEX 01 00:00:00
#  TRACK 02 AUDIO
#    TITLE "Even Less"
#    INDEX 01 04:02:53
  track_num="$i"
  if (( $i < 10  )) ; then track_num="0$i" ; fi
  ind_mins=`echo "$index/6000" | bc -l | cut -d'.' -f 1`
  if [ "$ind_mins" = "" ]; then ind_mins="0"; fi
  if (( $ind_mins < 10  )) ; then ind_mins="0$ind_mins" ; fi
  ind_secs=`echo "($index-$ind_mins*6000)/100" | bc -l | cut -d'.' -f 1`
  if [ "$ind_secs" = "" ]; then ind_secs="0"; fi
  if (( $ind_secs < 10  )) ; then ind_secs="0$ind_secs" ; fi
  ind_huns=`echo "($index-$ind_mins*6000-$ind_secs*100)" | bc -l | cut -d'.' -f 1`
  if [ "$ind_huns" = "" ]; then ind_huns="0"; fi
  if (( $ind_huns < 10  )) ; then ind_huns="0$ind_huns" ; fi
  echo "  TRACK $track_num AUDIO"
  echo "    TITLE \"$track_name\""
  echo "    PERFORMER \"$PERFORMER\""
  echo "    INDEX 01 $ind_mins:$ind_secs:$ind_huns"
  let i=$i+1
  let index=$index+$duration
done
