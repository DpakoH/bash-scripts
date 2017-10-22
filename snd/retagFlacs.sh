#!/bin/bash

declare -a titles
declare -a performers
declare -a tracks

CURDIR=`pwd`
REPORTFILE="${CURDIR}/report.txt"
echo "Tag flac file started." > "$REPORTFILE"
echo -n "" > "${CURDIR}/dirs.tmp"
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo | cut -c 3- | sort | while read dir ; do
 echo "$dir" >> "${CURDIR}/dirs.tmp"
done
#mkdir "tagged"
cat "${CURDIR}/dirs.tmp" | while read dir ; do
 cd "$dir"
 if [ "$?" -eq "0" ] ; then
  echo "PASS: chdir to \"$dir\"" >> "$REPORTFILE"
  year=`echo ${dir} | cut -d' ' -f 1 | cut -c 2-5`
  other=`echo ${dir} | cut -d' ' -f 2-`
  totalperf=`echo ${other} | perl -e '$_=<>;m|(.*?) - (.*)|;print$1'`
  album=`echo ${other} | perl -e '$_=<>;m|(.*?) - (.*)|;print$2'`
  numofcues=0
  find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.cue$ | cut -c 3- | while read cuesheet ; do
    ((numofcues += 1))
    echo $numofcues > "numofcues.tmp"
  done
  if [ -f "numofcues.tmp" ] ; then
    numofcues=`cat "numofcues.tmp"`
    rm "numofcues.tmp"
  fi
  if [ ${numofcues} -gt 1 ] ; then
    echo "FAIL: too much cuesheets found" >> "$REPORTFILE"
  else
    if [ ${numofcues} -eq 1 ] ; then
      cuesheet=`find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.cue$ | cut -c 3-`
      cat "$cuesheet" | dos2unix > "$cuesheet.tmp"
      cmp "$cuesheet" "$cuesheet.tmp"
      if [ "$?" -ne "0" ] ; then
        echo "PASS: $cuesheet not in UNIX format" >> "$REPORTFILE"
      else
        echo "PASS: $cuesheet in UNIX format" >> "$REPORTFILE"
      fi
      cat "$cuesheet.tmp" | iconv -f utf-8 > /dev/null
      if [ "$?" -ne "0" ] ; then
        echo "FAIL: $cuesheet is not in UTF-8 encoding" >> "$REPORTFILE"
      else
        echo "PASS: $cuesheet is in UTF-8 encoding" >> "$REPORTFILE"
        cue_date=`cat "$cuesheet.tmp"      | grep "^REM DATE "    | cut -c 10- | tr -d '"'`
        cue_genre=`cat "$cuesheet.tmp"     | grep "^REM GENRE "   | cut -c 11- | tr -d '"'`
        cue_discid=`cat "$cuesheet.tmp"    | grep "^REM DISCID "  | cut -c 12- | tr -d '"'`
        cue_comment=`cat "$cuesheet.tmp"   | grep "^REM COMMENT " | cut -c 13- | tr -d '"'`
        cue_album=`cat "$cuesheet.tmp"     | grep "^TITLE "       | cut -c 7-  | tr -d '"'`
        cue_performer=`cat "$cuesheet.tmp" | grep "^PERFORMER "   | cut -c 11- | tr -d '"'`
        cue_catalog=`cat "$cuesheet.tmp"   | grep "^CATALOG "     | cut -c 9-  | tr -d '"'`
      fi
      rm "$cuesheet.tmp"
    fi
    numofflacs=0
    find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.flac$ | cut -c 3- | sort | while read flac ; do
      #((numofflacs += 1))
      #echo $numofflacs > "numofflacs.tmp"
      tracknum=`echo ${flac}  | perl -e '$_=<>;m|(.*?) (.*?) - (.*)\.flac|i;print$1'`
      performer=`echo ${flac} | perl -e '$_=<>;m|(.*?) (.*?) - (.*)\.flac|i;print$2'`
      trackname=`echo ${flac} | perl -e '$_=<>;m|(.*?) (.*?) - (.*)\.flac|i;print$3'`
      echo "year=\"$year\" perf=\"$totalperf\" album=\"$album\"" >> "$REPORTFILE"
      echo "cue: date=\"$cue_date\" genre=\"$cue_genre\" discid=\"$cue_discid\" comment=\"$cue_comment\" "\
           "album=\"$cue_album\" performer=\"$cue_performer\" catalog=\"$cue_catalog\"" >> "$REPORTFILE"
      echo "tracknum=\"$tracknum\" performer=\"$performer\" trackname=\"$trackname\"" >> "$REPORTFILE"
      metaflac --remove-tag="TITLE" --remove-tag="ALBUM" --remove-tag="ARTIST" --remove-tag="DATE" --remove-tag="TRACKNUMBER" "$flac"
      metaflac --remove-tag="TITLE" --remove-tag="ALBUM" --remove-tag="ARTIST" --remove-tag="DATE" --remove-tag="TRACKNUMBER" "$flac"
      metaflac --set-tag="TITLE=$trackname"  \
               --set-tag="ALBUM=$album"      \
               --set-tag="ARTIST=$performer" \
               --set-tag="DATE=$year"        \
               --set-tag="TRACKNUMBER=$tracknum" "$flac"
      if [[ -n "$cue_genre" && "$cue_genre" != "" ]] ; then
        metaflac --remove-tag="GENRE" "$flac"
        metaflac --set-tag="GENRE=$cue_genre" "$flac"
      #else
      fi
      if [[ -n "$cue_discid" && "$cue_discid" != "" ]] ; then
        metaflac --remove-tag="DISCID" "$flac"
        metaflac --set-tag="DISCID=$cue_discid" "$flac"
      #else
      fi
      if [[ -n "$cue_comment" && "$cue_comment" != "" ]] ; then
        metaflac --remove-tag="COMMENT" "$flac"
        metaflac --set-tag="COMMENT=$cue_comment" "$flac"
      #else
      fi
      if [[ -n "$cue_catalog" && "$cue_catalog" != "" ]] ; then
        metaflac --remove-tag="CATALOG" "$flac"
        metaflac --set-tag="CATALOG=$cue_catalog" "$flac"
      #else
      fi
      # normalize tags
      metaflac --export-tags-to="tags.tmp" "$flac"
      cat "tags.tmp" | sort | uniq > "tags.tmp2"
      metaflac --remove-all-tags "$flac"
      metaflac --import-tags-from="tags.tmp2" "$flac"
      rm "tags.tmp"
      rm "tags.tmp2"
    done
    #echo "num_of_flacs=`cat numofflacs.tmp`"
    #rm "numofflacs.tmp"
  fi
  unset cue_genre
  unset cue_discid
  unset cue_comment
  unset cue_catalog
  cd ..
 else
  echo "FAIL: chdir to \"$dir\" failed" >> "$REPORTFILE"
 fi
done
echo "Tag flac files finished." >> "$REPORTFILE"
rm "${CURDIR}/dirs.tmp"
exit 0
