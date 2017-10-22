#!/bin/bash

REPORTFILE="`pwd`/report.txt"

echo "`date` Convert apes, wvs, ttas and wavs to flacs started." | tee -a "$REPORTFILE"

decMfourA() {
  mfoura="$@"
  outwav=`echo "${mfoura}" | perl -e 'while(<>) { $_ =~ s/\.m4a$/\.wav/i ; print $_ }'`
  echo -n "Decompressing ${mfoura} -> ${outwav} ..."
  ffmpeg -nostdin -i "${mfoura}" -acodec pcm_s16le "${outwav}" >out.tmp 2>&1
  if [ "$?" -eq "0" ] ; then
    echo "ok. Removing ${mfoura}."
    rm "${mfoura}"
  else
    echo "failed. Removing ${outwav}."
    rm "${outwav}"
    cat out.tmp
  fi
  rm out.tmp
}

decFlc() {
  flac="$@"
  wav=`echo "$flac" | perl -e 'while(<>) { $_ =~ s/\.flac$/\.wav/i ; print $_ }'`
  echo "${wav}"
  metaflac --export-tags-to="${flac}.tags" "${flac}"
  #metaflac --list --except-block-type=SEEKTABLE "${flac}" > "${flac}_tags.txt"
  #if [ ! -s "${flac}_tags.txt" ] ; then
  #  rm "${flac}_tags.txt"
  #fi
  echo -n "Decompressing ${flac} -> ${wav} ..."
  flac -F -d "${flac}" -o "${wav}"
  flac -f --best --replay-gain "${wav}" -o "${flac}"
  metaflac --import-tags-from="${flac}.tags" "${flac}"
  rm "${flac}.tags"
  rm "$wav"
}

decApe() {
  ape="$@"
  wav=`echo "${ape}" | perl -e 'while(<>) { $_ =~ s/\.ape$/\.wav/i ; print $_ }'`
  # tags: $ strings "Divine - The Greatest Hits.ape" | tail -n 20
  # Year
  # 2005
  # Genre
  # Eurodance
  # Album
  # The Greatest Hits
  # Comment
  # Exact Audio CopyB
  # Title
  #D:\Downloads\Divine - The Greatest Hits\Divine - The Greatest HitsAPETAGEX
  strings "${ape}" | tail -n 200 | grep -A 100 "APETAGEX\|Track\|Year\|Title\|Artist\|Genre\|Album\|Comment\|Composer\|Copyright" > "${ape}_tags.txt"
  if [ ! -s "${ape}_tags.txt" ] ; then
    rm "${ape}_tags.txt"
  fi
  # decompress
  echo -n "Decompressing ${ape} -> ${wav} ..."
  wine MAC.exe "${ape}" "${wav}" -d >out.tmp 2>&1
  if [ "$?" -eq "0" ] ; then
    echo "ok. Removing ${ape}."
    rm "${ape}"
  else
    echo "failed. Removing ${wav}."
    rm "${wav}"
    cat out.tmp
  fi
  rm out.tmp
}

decWvp() {
  wvp="$@"
  echo "wv: ${wvp}"
  wav=`echo "${wvp}" | perl -e 'while(<>) { $_ =~ s/\.wv$/\.wav/i ; print $_ }'`
  wvunpack -y -ss "${wvp}" > "${wvp}_tags.txt"
  ntags=`cat "${wvp}_tags.txt" | grep "APEv2 tag items:" | rev | cut -d' ' -f 1 | rev`
  if [ "$ntags" != "" ] ; then
    cat "${wvp}_tags.txt" | grep -A ${ntags} "APEv2 tag items:" | tail -n "${ntags}" | while read tag ; do
      tagname=`echo "${tag}" | cut -d':' -f 1`
      isbyte=`echo "${tag}" | grep "${tagname}:" | grep "\-byte"`
      if [ "${isbyte}" != "" ] ; then
        wvunpack -y -x "${tagname}" "${wvp}" > "${wvp}_${tagname}.tag"
      fi
    done
  fi
  echo -n "Decompressing ${wvp} -> ${wav} ..."
  wvunpack -cc -w -y "${wvp}" -o "${wav}" >out.tmp 2>&1
  if [ "$?" -eq "0" ] ; then
    echo "ok. Removing ${wvp}."
    rm "${wvp}"
  else
    echo "failed. Removing ${wav}."
    rm "${wav}"
    cat out.tmp
  fi
  rm out.tmp
}

decTta() {
    tta="$@"
    echo "tta: $tta"
    return 0
    wav=`echo $tta | perl -e 'while(<>) { $_ =~ s/\.tta$/\.wav/i ; print $_ }'`
    echo -n "Decompressing $tta -> $wav ..." >> "$REPORTFILE"
    #wvunpack -cc -y "$wv" -o "$wav"
    ttaenc -d "$tta" -o "$wav"
    if [ "$?" -eq "0" ] ; then
      echo "ok." >> "$REPORTFILE"
      echo -n "Compressing $wav ..." >> "$REPORTFILE"
      flac --replay-gain --best "$wav"
      if [ "$?" -eq "0" ] ; then
        echo "ok." >> "$REPORTFILE"
        echo "Removing $tta." >> "$REPORTFILE"
        rm "$tta"
      else
        echo "failed." >> "$REPORTFILE"
      fi
    else
      echo "failed." >> "$REPORTFILE"
    fi
    echo "Removing $wav." >> "$REPORTFILE"
    rm "$wav"
}

encWav() {
  wav="$@"
  echo -n "Compressing ${wav} ..."
  is96k=`file "${wav}" | grep "96000 Hz"`
  if [ "$is96k" != "" ] ; then
    flac --best "$wav" >out.tmp 2>&1
  else
    flac --replay-gain --best "$wav" >out.tmp 2>&1
  fi
  if [ "$?" -eq "0" ] ; then
    echo "ok. Removing ${wav}."
    rm "$wav"
  else
    echo "failed."
    isrg=`cat out.tmp | grep "invalid sample rate" | grep "replay-gain"`
    if [ "$isrg" != "" ] ; then
      echo -n "Retrying without replay-gain ..."
      flac --best "${wav}" >out.tmp 2>&1
      if [ "$?" -eq "0" ] ; then
        echo "ok. Removing ${wav}."
        rm "$wav"
      else
        echo "failed. Unknown reason:"
        cat out.tmp
      fi
    else
      echo "Unknown reason:"
      cat out.tmp
    fi
  fi
  rm out.tmp
}

find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo | sort | cut -c 3- | while read dir ; do
  PREWD=`pwd`
  cd "$dir"
  if [ "$?" -eq "0" ] ; then
    find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.m4a$ | cut -c 3- | while read fname ; do
      decMfourA "${fname}" | tee -a "${REPORTFILE}"
    done
    find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.ape$ | cut -c 3- | while read ape ; do
      decApe "${ape}" | tee -a "${REPORTFILE}"
    done
    find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.wv$  | cut -c 3- | while read wvp ; do
      decWvp "${wvp}" | tee -a "${REPORTFILE}"
    done
#    find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.tta$ | cut -c 3- | while read tta ; do
#      decTta "${tta}" | tee -a "${REPORTFILE}"
#    done
    find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.wav$ | cut -c 3- | while read wav ; do
      encWav "${wav}" | tee -a "$REPORTFILE"
    done
    cd "$PREWD"
  else
    echo "cd to \"$dir\" failed." >> "$REPORTFILE"
  fi
done
echo "Convert apes,wvs,wavs to flacs finished." >> "$REPORTFILE"
