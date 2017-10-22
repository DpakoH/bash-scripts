#/bin/bash

for what in ffmpeg wvunpack flac shnsplit cueprint ; do
  wch=`which $what`
  if [ ${wch:0:1} != "/" ]; then
  echo "You need $what"
  echo "On ArchLinux you can do pacman -S ffmpeg flac shntool cuetools enca"
  exit
  fi
done

if [ "$1" == "--help" ]; then
  echo "Usage: m2t [PATH]"
  exit
fi

if [ "$1" == '' ]; then
  shellDir="$PWD"
else
  shellDir="$1"
fi

cd "$shellDir"

find | while read dir ; do
  if [ -f "$dir" ]; then
    dirName="`dirname "$dir"`"
    cd "`dirname "$dir"`"
    tsFile=`echo "$dir" | sed -ne 's!^.*\/!!p'`
    ext=`echo "$dir" | sed -ne 's!^.*\.!!p' | tr '[:upper:]' '[:lower:]'` &> /dev/null
    base=`echo "$tsFile" | sed -e 's!\.[^.]*$!!'` &> /dev/null
    if [ "$ext" = "ape" ]; then
      ffmpeg -i "$tsFile" "$base.wav"
      flac "$base.wav"
      rm -f "$tsFile" "$base.wav"
    fi
    if [ "$ext" = "wv" ]; then
      wvunpack "$tsFile" "$base.wav"
      flac "$base.wav"
      rm -f "$tsFile" "$base.wav"
    fi
    if [ "$ext" = "bin" ]; then
      flac --force-raw-format --channels=2 --sample-rate=44100 --bps=16 --sign=signed --endian=little "$tsFile"
    fi
    if [ "$ext" = "wav" ]; then
      flac "$tsFile"
    fi
    cd "$shellDir"
  fi
done

find | while read dir ; do
  if [ -f "$dir" ]; then
    cd "`dirname "$dir"`"
    tsFile=`echo "$dir" | sed -ne 's!^.*\/!!p'`
    ext=`echo "$dir" | sed -ne 's!^.*\.!!p' | tr '[:upper:]' '[:lower:]'` &> /dev/null
    base=`echo "$dir" | sed -e 's!\.[^.]*$!!'` &> /dev/null
    if [ "$ext" = "cue" ]; then
      pathtoflac=`ls | grep .flac`
      mv "$pathtoflac" "tmp.flac"
      cat "$tsFile" | enca -x "UTF-8"  > "tmp.cue"
      rm -f "$tsFile"
      shnsplit -o wav "tmp.flac" -f "tmp.cue" -t '%n-%t'
      numTracks=`cueprint "tmp.cue" --disc-template %N`
      while (( numTracks > 0 )) ; do
        perfomer="`cueprint "tmp.cue" -n "$numTracks" --track-template %p`"
        title="`cueprint "tmp.cue" -n "$numTracks" --track-template %t`"
        album="`cueprint tmp.cue --disc-template %T`"
        if (( ${#numTracks} == 2 )); then
          flac --replay-gain --sign=signed --endian=little --best "$numTracks-$title.wav"
          splitname="$numTracks-$title.flac"
          rm -f "$numTracks-$title.wav"
        else
          flac --replay-gain --best "0$numTracks-$title.wav"
          splitname="0$numTracks-$title.flac"
          rm -f "0$numTracks-$title.wav"
        fi
        cueprint -n $numTracks -t 'ARRANGER=%A\nCOMPOSER=%C\nGENRE=%G\nMESSAGE=%M\nTRACKNUMBER=%n\nARTIST=%p\nTITLE=%t\nALBUM=%T\n' "tmp.cue" | egrep -v '=$' | metaflac "$splitname" --import-tags-from=-
        let "numTracks-=1"
      done
      rm -f "tmp.cue" "tmp.flac"
    fi
    cd "$shellDir"
  fi
done
