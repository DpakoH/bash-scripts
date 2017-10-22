#!/bin/bash


if ! [[ $1 ]] ; then
  echo "Please, specify filename to convert from"
  exit 1
fi
fn="$1"
if ! [[ -f "${fn}" ]] ; then
  echo "File ${fn} not found"
  exit 1
fi
fn_lc=`echo "${fn}" | tr '[A-Z]' '[a-z]'`
if [[ "${fn_lc: -5}" != ".flac" ]] ; then
  echo "Please, specify flac to convert from..."
  exit 2
fi
fn_out=`echo "${fn}" | perl -e 'while(<>) { $_ =~ s/\.flac$/\.mp3/gi ; print $_ }'`
flac -F -d "${fn}" -o "./tmp.wav"
if [ "$?" -ne "0" ] ; then
  exit 3
fi
lame --preset studio -q 0 -v --vbr-new -V 0 -m s "./tmp.wav" "${fn_out}"
rm "./tmp.wav"
#outfn=``
exit 0

declare -a a
a=( `find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep \.flac$ | tr ' ' '_' | cut -c 3-` )
for i in ${a[*]} ; do
    b=`echo $i | tr '_' ' '`
    echo "$b"
    c=`echo $b | perl -e 'while(<>) { $_ =~ s/\.flac$/\.mp3/ ; print $_ }'`
    echo "$c"
    d="mp3s/`echo $c | rev | cut -d'/' -f 2- | rev`"
    mkdir -p "$d"
    flac -F -d "$b" -o "tmp.wav"
    lame --preset studio -q 0 -v --vbr-new -V 0 -m s tmp.wav "mp3s/$c"
    rm "tmp.wav"
done
