#!/bin/bash

unpackRars ()
{
  CDIR=`pwd`
  find . -print -type f | grep -i "\.rar$" | while read lne ; do
    #echo "$lne"
    fname=`basename "$lne" | rev | cut -d'.' -f 2- | rev`
    dname=`dirname "$lne"`
    #echo "\"$dname\" \"$fname\""
    cd "${CDIR}"
    mkdir "${dname}/${fname}"
    cd "${dname}/${fname}"
    mv "../${fname}.rar" .
    rar x "${fname}.rar"
    rm "${fname}.rar"
  done
}

unpackZips ()
{
  CDIR=`pwd`
  find . -print -type f | grep -i "\.zip$" | while read lne ; do
    #echo "$lne"
    fname=`basename "$lne"`
    fname2=`basename "$lne" | rev | cut -d'.' -f 2- | rev`
    dname=`dirname "$lne"`
    #echo "\"$dname\" \"$fname\""
    cd "${CDIR}"
    mkdir "${dname}/${fname2}"
    cd "${dname}/${fname2}"
    mv "../${fname}" .
    unzip "${fname}"
    rm "${fname}"
  done
}

#unpackRars
unpackZips
