#!/bin/bash

declare -a titles
declare -a performers
declare -a tracks

CDIR=`pwd`

#REPORTFILE="${CDIR}/report.txt"
#mv ${REPORTFILE} ${REPORTFILE}.`date +%y%m%d%H%M%S`

logStr () {
   echo -e "$@" | tee -a "$REPORTFILE"
}

logINFO () {
   logStr "`date +%H:%M:%S`\033[1;37m INFO: $@\033[0m"
}

logWARN () {
   logStr "`date +%H:%M:%S`\033[1;33m WARN: $@\033[0m"
}

logFAIL () {
   logStr "`date +%H:%M:%S`\033[1;31m FAIL: $@\033[0m"
}

cueEnc () {
  cue="$@"
  cat "${cue}" | dos2unix > "${cue}.tmp" ; cmp "${cue}" "${cue}.tmp"
  if [ "$?" -ne "0" ] ; then
    rm "${cue}" ; mv "${cue}.tmp" "${cue}" ; logWARN "\"${cue}\" not in UNIX format"
  else
    rm "${cue}.tmp" ; logINFO "\"${cue}\" in UNIX format"
  fi
  cat "${cue}" | iconv -f utf-8 > /dev/null
  if [ "$?" -ne "0" ] ; then
    logFAIL "${cue} not in UTF-8 encoding"
    return 1
  else
    logINFO "${cue} in UTF-8 encoding"
    return 0
  fi
  # to test: cp1251, cp936, iso8859-1
}

#for i in `seq 30 39` ; do
#  echo -e "\033[1;${i}m $i $i $i\033[0m"
#done

#exit 0

#logINFO "*** Split CD images started."
echo -n "" > "${CDIR}/dirs.tmp"
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo | cut -c 3- | sort | while read dir ; do
  echo "$dir" >> "${CDIR}/dirs.tmp"
done
mkdir "${CDIR}/splitted"
cat "${CDIR}/dirs.tmp" | while read dir ; do
  cd "$dir"
  REPORTFILE=`pwd`"/split_report.txt"
  if [ "$?" -ne "0" ] ; then
    logFAIL "chdir to \"$dir\" failed"
  else
    pass_flag=1 ; logINFO "cd to \"$dir\""
    ret_val=0
    #year=`echo ${dir} | cut -d' ' -f 1 | cut -c 2-5`
    dir_date=`echo ${dir} | perl -e '$_=<>;m|^\[(\d\d\d\d)\] (.*)|;print$1'`
    if [[ ! -n "$dir_date" ]] || (( $dir_date < 1949 )) || (( $dir_date > `date +%Y` )) ; then
      logFAIL "Not valid year provided in '${dir}'"
      let ret_val=$ret_val+1
    else
      dir_perf=`echo ${dir} | perl -e '$_=<>;m|^\[\d\d\d\d\] (.*?) - (.*)|;print$1'`
      if [[ ! -n "$dir_perf" ]] ; then
        logFAIL "Not valid performer provided in '${dir}'"
        let ret_val=$ret_val+1
      else
        dir_album=`echo ${dir} | perl -e '$_=<>;m|\[\d\d\d\d\] .*? - (.*)|;print$1'`
        if [[ ! -n "$dir_album" ]] ; then
          logFAIL "Not valid album provided in '${dir}'"
          let ret_val=$ret_val+1
        else
          # ok, continue
          logINFO "date=\"${dir_date}\" perf=\"${dir_perf}\" album=\"${dir_album}\""
          #n_flacs=0 ; find . -mindepth 1 -maxdepth 1 -type f -print0 | xargs -r0 -n 1 echo | grep -i \.flac$ | cut -c 3- | while read flac ; do
          # ((n_flacs += 1)) ; echo $n_flacs > "n_flacs.tmp"
          #done
          #n_flacs=`cat "n_flacs.tmp"` ; rm "n_flacs.tmp"
          flcs=`find . -mindepth 1 -maxdepth 1 -type f -print0 | xargs -r0 -n 1 echo | grep -i "\.flac$" | cut -c 3-`
          n_flcs=`echo "$flcs" | wc -l`
          # echo "n_flacs=$n_flacs" >> "$REPORTFILE"
          if [ $n_flcs -ne 1 ] ; then
            logFAIL "No exactly one flac file (${n_flcs}) found in dir \"$dir\""
            let ret_val=$ret_val+1
          else
          #  sample_rate: 44100 Hz
          #  channels: 2
          #  bits-per-sample: 16
          meta=`metaflac --list "${flcs}"`
          srate=`echo "${meta}" | grep "sample_rate: " | rev | cut -d' ' -f 2 | rev`
          channels=`echo "${meta}" | grep "channels: " | rev | cut -d' ' -f 1 | rev`
          bits=`echo "${meta}" | grep "bits-per-sample: " | rev | cut -d' ' -f 1 | rev`
          if [[ "${srate}" != "44100" || "${channels}" != "2" || "${bits}" != "16" ]] ; then
            logFAIL "No CD flac found: sample_rate=${srate} channels=${channels} bits-per-sample=${bits}"
            let ret_val=$ret_val+1
          else
            # ok, continue
            cues=`find . -mindepth 1 -maxdepth 1 -type f -print0 | xargs -r0 -n 1 echo | grep -i "\.cue$" | cut -c 3-`
            n_cues=`echo "$cues" | wc -l`
            # echo "n_cues=$n_cues" >> "$REPORTFILE"
            if [[ -z "$cues" || "$cues" == "" || "$n_cues" != "1" ]] ; then
              logFAIL "No exactly one cue file (${n_cues}) found in dir \"$dir\""
              let ret_val=$ret_val+1
            else
              # ok, continue
              genre=`cat "$cues" | grep "^REM GENRE " | cut -c 11- | tr -d '"\n\r'`
              discid=`cat "$cues" | grep "^REM DISCID " | cut -c 12- | tr -d '"\n\r'`
              comment=`cat "$cues" | grep "^REM COMMENT " | cut -c 13- | tr -d '"\n\r'`
              cue_date=`cat "$cues" | grep "^REM DATE " | cut -c 10- | tr -d '"\n\r'`
              cue_album=`cat "$cues" | grep "^TITLE " | cut -c 7- | tr -d '"\n\r'`
              cue_perf=`cat "$cues" | grep "^PERFORMER " | cut -c 11- | tr -d '"\n\r'`
              logINFO "genre=\"${genre}\" discid=\"${discid}\" comment=\"${comment}\""
              logINFO "cue_date=\"${cue_date}\" cue_perf=\"${cue_perf}\" cue_album=\"${cue_album}\""
              if [[ -z "$cue_date" || "$cue_date" == "" ]] ; then
                logWARN "date not defined in cue file!"
                cue_date="${dir_date}"
              fi
              if [[ -z "$cue_album" || "$cue_album" == "" ]] ; then
                logWARN "album not defined in cue file!"
                cue_album="${dir_album}"
              fi
              if [[ -z "$cue_perf" || "$cue_perf" == "" ]] ; then
                logWARN "performer not defined in cue file!"
                cue_perf="${dir_perf}"
              fi
              if [[ "$cue_date" != "$dir_date" ]] ; then
                logFAIL "date in dir not equals date in cue!"
                let ret_val=$ret_val+1
              else
                if [[ "$cue_perf" != "$dir_perf" ]] ; then
                  logFAIL "performer in dir not equals performer in cue!"
                  let ret_val=$ret_val+1
                else
                  if [[ "$cue_album" != "$dir_album" ]] ; then
                    logWARN "album in dir not equals album in cue!"
                  else
                    true
                  fi
                  cat "$cues" | grep -v "^REM" | tac | head -n -3 | tac > "${cues}.tmp"
                  cueEnc "${cues}.tmp"
                  if [ "$?" -eq "0" ] ; then
                  #cat "${cues}.tmp" | dos2unix > "${cues}.tmp2" ; cmp "${cues}.tmp" "${cues}.tmp2"
                  #if [ "$?" -ne "0" ] ; then
                  #  rm "${cues}.tmp" ; mv "${cues}.tmp2" "${cues}.tmp" ; logWARN "\"${cues}\" not in UNIX format"
                  #else
                  #  rm "${cues}.tmp2" ; logINFO "\"${cues}\" in UNIX format"
                  #fi
                  #cat "${cues}.tmp" | iconv -f utf-8 > /dev/null
                  #if [ "$?" -ne "0" ] ; then
                  #  logFAIL "${cues} not in UTF-8 encoding"
                  #else
                  #  logINFO "${cues} in UTF-8 encoding"
                    cat "${cues}.tmp" | cut -c 5- | grep "^TITLE"    | cut -d' ' -f 2- | cut -d'"' -f 2 > "titles.tmp"
                    #titles=( `cat "titles.tmp"` ) ; rm "titles.tmp"
                    n_titles=`cat "titles.tmp" | wc -l`
                    cat "${cues}.tmp" | cut -c 5- | grep "^PERFORMER" | cut -d' ' -f 2- | cut -d'"' -f 2 > "performers.tmp"
                    #performers=( `cat "performers.tmp"` ) ; rm "performers.tmp"
                    n_perfs=`cat "performers.tmp" | wc -l`
                    indexes=( `cat "${cues}.tmp" | grep "INDEX 01"  | cut -c 14-` )
                    for pnum in $(seq 1 $n_perfs) ; do
                      performer=`head -n +$pnum "performers.tmp" | tail -n 1 | perl -e 'while(<>){$_=~s|/| & |g;print}' | tr -d '"\n\r'`
                      if [[ "$cue_perf" != "$performer" ]] ; then
                        logWARN "performer not equals: \"$cue_perf\" vs. \"$performer\""
                      fi
                    done
                    #for pnum in $(seq 0 $((${#performers[@]} - 1))) ; do
                    #  unesc_performer=`echo ${performers[$pnum]} | tr "\\\`" " " | perl -e 'while(<>){$_=~s|/| & |g;print}' | tr -d '"\n\r'`
                    #  if [[ "$cue_perf" != "$unesc_performer" ]] ; then
                    #    let ret_val=$ret_val+1
                    #    echo "WARN: performer not equals: \"$cue_perf\" vs. \"$unesc_performer\"" >> "$REPORTFILE"
                    #  fi
                    #done
                    #if [ "$ret_val" -eq "0" ] ; then
                      if [[ ${#indexes[@]} != $n_titles ]] ; then
                        logFAIL "Number of tracks not equals to number of titles"
                        let ret_val=$ret_val+1
                      else
                        echo "    INDEX 01 00:00:00" > "indexes.tmp" ; cat "${cues}.tmp" | grep "INDEX 01" | tail -n +2 >> "indexes.tmp"
                        #echo "    INDEX 01 00:00.000" > "indexes.tmp" ; cat "${cues}.tmp" | grep "INDEX 01" | tail -n +2 >> "indexes.tmp"
                        cp "$flcs" /tmp
                        shnsplit -f "indexes.tmp" -P dot -o flac "/tmp/$flcs" 2>&1 | tee -a "$REPORTFILE"
                        #false
                        if [ "$?" -ne "0" ] ; then
                          logFAIL "shnsplit failed for unknown reason"
                          let ret_val=$ret_val+1
                          rm split-track*.flac
                          rm "/tmp/$flcs"
                        else
                          rm "/tmp/$flcs"
                          logINFO "shnsplit passed ok"
                          #n_track=1
                          for num in `seq 1 $n_titles` ; do
                            n_track_wlz=$num
                            # TBD: to check total number of tracks if exceeding 99
                            if [ $num -lt 10 ] ; then
                              n_track_wlz="0"$num
                            fi
                            #$ echo "ddd/vvv" | perl -e 'while(<>){$_=~s|/| & |;print}'
                            #ddd & vvv
                            #title=`echo ${titles[$num]} | tr "\\\`" " " | perl -e 'while(<>){$_=~s|/|／|g;print}' | tr -d '"\n\r'`
                            title=`head -n +$num "titles.tmp" | tail -n 1 | perl -e 'while(<>){$_=~s|/|／|g;print}' | tr -d '"\n\r'`
                            #performer=`echo ${performers[$num]} | tr "\\\`" " " | perl -e 'while(<>){$_=~s|/| & |g;print}' | tr -d '"\n\r'`
                            performer=`head -n +$num "performers.tmp" | tail -n 1 | perl -e 'while(<>){$_=~s|/| & |g;print}' | tr -d '"\n\r'`
                            ss_name="split-track"$n_track_wlz".flac";
                            #echo "mv \"$c\" \"$k $performer - $title.flac\""
                            #perf="CHORALSCHOLA DER ABTEI MÜNSTERSCHWARZACH" ;
                            a_perf=( $performer )
                            echo -n > "performer.tmp"
                            for num2 in $(seq 0 $((${#a_perf[@]} - 1))) ; do
                              the_head=`echo ${a_perf[$num2]} | cut -c1-1 | tr [:lower:] [:upper:]`
                              the_tail=`echo ${a_perf[$num2]} | cut -c2- | tr [:upper:] [:lower:]`
                              echo -n "${the_head}${the_tail} " >> "performer.tmp"
                            done # $(seq 0 $((${#a_perf[@]} - 1)))
                            performer=`cat "performer.tmp" | tr -d '"\n\r'` ; rm "performer.tmp"
                            if [[ -z "$performer" || "$performer" == "" ]] ; then
                              performer="${cue_perf}"
                            fi
                            performer=`echo $performer | rev | rev`
                            metaflac --set-tag="TITLE=$title"      \
                              --set-tag="ALBUM=$cue_album"         \
                              --set-tag="ARTIST=$performer"        \
                              --set-tag="DATE=$cue_date"           \
                              --set-tag="TRACKNUMBER=$n_track_wlz" \
                              --set-tag="GENRE=$genre"             \
                              --set-tag="COMMENT=$comment"         \
                              --set-tag="DISCID=$discid" "$ss_name"
                            mv "$ss_name" "$n_track_wlz ${performer} - $title.flac"
                            if [ "$?" -ne "0" ] ; then
                              logFAIL "mv \"$ss_name\" \"$n_track_wlz $performer - $title.flac\" failed"
                              let ret_val=$ret_val+1
                            fi
                            #let n_track=$n_track+1
                          done # $(seq 0 $((${#titles[@]} - 1)))
                          if [ "$ret_val" -eq "0" ] ; then
                            logINFO "All passed Ok!"
                            rm "$flcs"
                            pass_flag=0
                          else
                            let ret_val=$ret_val+1
                            logFAIL "mv somewhere failed!"
                          fi
                        fi # shnsplit
                        rm "indexes.tmp"
                        rm "performers.tmp"
                        rm "titles.tmp"
                      fi # ${#indexes[@]} != ${#titles[@]}
                    #fi # "$cue_perf" != "${performers[$pnum]}"
                  fi # cue not in UTF
                  rm "${cues}.tmp"
                #fi # "$cue_album" != "$dir_album"
                fi # "$cue_perf" != "$dir_perf"
              fi # "$cue_date" != "$dir_date"
            fi # n_cues -ne 1
          fi # no CD
          fi # n_flacs -ne 1
        fi # ! -n "$dir_album"
      fi # ! -n "$dir_perf"
    fi # ! -n "$dir_date" ...
    if [ "$pass_flag" -ne "0" ] ; then
      cd "${CDIR}"
      logFAIL "not moving \"$dir\" to splitted/ Somewhere failed."
    else
      cd "${CDIR}"
      logINFO "splitted Ok!"
      mv "$dir" "splitted/"
    fi
  fi # "$?" -ne "0" after cd $dir
done
#logINFO "*** Split CD images finished."
rm dirs.tmp
exit 0
