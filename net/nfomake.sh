#!/bin/bash

NFOFILE="`pwd`/out.nfo"

echo "---------------------------------------------------------" > "$NFOFILE"
echo "            Artist-Discography-[LOSSLESS]                " >> "$NFOFILE"
echo "---------------------------------------------------------" >> "$NFOFILE"
echo >> "$NFOFILE"
echo >> "$NFOFILE"
echo >> "$NFOFILE"
echo >> "$NFOFILE"
echo >> "$NFOFILE"
echo >> "$NFOFILE"
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
     cut -c 3- | while read dir ; do
 cd "$dir"
 if [ "$?" -eq "0" ] ; then
  echo "$dir" >> "$NFOFILE"
  echo >> "$NFOFILE"
  year=`echo $dir | cut -c2-5`
  echo "# Release Date: $year" >> "$NFOFILE"
  echo "# Labels: " >> "$NFOFILE"
  echo >> "$NFOFILE"
  echo "Tracklist:" >> "$NFOFILE"
  find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.flac$ |
      cut -c 3- | sort | while read flac_file ; do
   samples=`metaflac --list "$flac_file" | grep "total samples:" | cut -d' ' -f 5`
   rate=`metaflac --list "$flac_file" | grep "sample_rate:" | cut -d' ' -f 4`
   mins=`echo "$samples/$rate/60" | bc -l | cut -d'.' -f 1`
   if [ "$mins" = "" ]; then mins="0"; fi
   secs=`echo "$samples/$rate-$mins*60" | bc -l | cut -d'.' -f 1`
   if [ "$secs" = "" ]; then secs="0"; fi
   if (( $secs < 10  )) ; then secs="0$secs" ; fi
   echo "$samples:$rate -> $mins:$secs"
   track_name=`echo $flac_file | rev | cut -d'.' -f 2- | rev`
   echo "$track_name [$mins:$secs]" >> "$NFOFILE"
  done
  cd ..
  echo "" >> "$NFOFILE"
  echo "Album Credits:" >> "$NFOFILE"
  echo "" >> "$NFOFILE"
  echo "" >> "$NFOFILE"
  echo "" >> "$NFOFILE"
  echo "" >> "$NFOFILE"
  echo "" >> "$NFOFILE"
 else
  echo "cd to \"$dir\" failed."
 fi
done
echo "*************************************************************" >> "$NFOFILE"
echo >> "$NFOFILE"
echo "Band History" >> "$NFOFILE"
echo >> "$NFOFILE"
