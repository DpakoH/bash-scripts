#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: PERFORMER"
    exit 1
fi
PERFORMER="$1"

echo "REM GENRE ..."
echo "REM DATE ..."
echo "REM DISCID ..."
echo "PERFORMER \"$PERFORMER\""
echo "TITLE \"...\""
echo "FILE \"...\" WAVE"
i="1"
index="0"
find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.flac$ |
    cut -c 3- | while read flac_file ; do
  samples=`metaflac --list "$flac_file" | grep "total samples:" | cut -d' ' -f 5`
  rate=`metaflac --list "$flac_file" | grep "sample_rate:" | cut -d' ' -f 4`
  duration=`echo "$samples/($rate/100)+1" | bc -l | cut -d'.' -f 1`
  #echo "$samples/147" | bc -l
  #echo "($samples+147)/($rate/100)+1" | bc -l
  track_name=`echo $flac_file | rev | cut -c6- | rev | tr '_' ' '`
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
