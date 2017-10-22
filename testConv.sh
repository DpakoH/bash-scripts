#!/bin/bash

fn=$1

for i in `iconv --list | tr -d ',' | xargs` ; do
  cdpg=`echo $i | cut -d'/' -f 1`
  cat $fn | iconv -f $cdpg > ${fn}.$cdpg 2>/dev/null
  if [ "$?" -ne "0" ] ; then
    rm ${fn}.$cdpg
    continue
  fi
  cat ${fn}.$cdpg | grep "^FILE " > /dev/null
  if [ "$?" -ne "0" ] ; then
    rm ${fn}.$cdpg
    continue
  fi
  cat ${fn}.$cdpg | grep "brüllet"
  if [ "$?" -ne "0" ] ; then
    rm ${fn}.$cdpg
  fi
done
