#!/bin/bash

#exit 0

LAME_OPTS="--preset studio -q 0 --vbr-new -V 0 -m s"
#LAME_OPTS="--cbr -b 320 -q 0 -m s"
REPORTFILE="`pwd`/report.txt"

declare -a a
a=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep \.flac$ | tr ' ' '_' | cut -c 3-` )
#a=( `find . -type f -print0 | sort | xargs -r0 -n 1 echo | grep \.wav$ | tr ' ' '_'` )
#a=`find . -type f -print0`
#echo ${#a[*]}
for i in ${a[*]} ; do
    b=`echo $i | tr '_' ' '`
    echo "$b"
    c=`echo $b | perl -e 'while(<>) { $_ =~ s/\.flac$/\.mp3/ ; print $_ }'`
#   c=`echo $b | perl -e 'while(<>) { $_ =~ s/\.wav$/\.mp3/ ; print $_ }'`
    echo "$c"
    d="mp3s/`echo $c | rev | cut -d'/' -f 2- | rev`"
    mkdir -p "$d"
#    flac -t "$b"
    flac -d -c "$b" > tmp.wav
    lame $LAME_OPTS tmp.wav "mp3s/$c"
    rm tmp.wav
#    mpg123 -w - "mp3s/$c" > tmp.wav
    lame --decode "mp3s/$c" tmp.wav
    echo "Checking $c" >> "$REPORTFILE"
    auCDtect -v "tmp.wav" >> "$REPORTFILE" 2>/dev/null
    rm tmp.wav
#    lame -V 0 -m s "$b" "$c"
#    auCDtect -v tmp.wav >> report.txt
    #rm tmp.wav
#    rm "$b"
done
