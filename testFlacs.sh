#!/bin/bash

#echo $1

CURDIR=`pwd`
TESTDIR="$1"
REPORTFILE="$CURDIR/${TESTDIR}_flacs_report.txt"
TMP_FILENAME="/tmp/testFlacs_${TESTDIR}.temp"
ERRORFILE="$CURDIR/${TESTDIR}_flacs_errors.txt"
rm "$REPORTFILE"
touch "$REPORTFILE"

find $TESTDIR -type f | while read fn ; do
  if [[ `echo $fn | grep -i \.flac$` ]] ; then
    flac -s -t "$fn" 2>${TMP_FILENAME}
    if [ $? == 0 ] ; then
       if [ -s ${TMP_FILENAME} ] ; then
         echo "$fn ...warned" | tee -a $REPORTFILE
         echo "????? $fn warnings:" | tee -a $ERRORFILE
         cat ${TMP_FILENAME} | tee -a $ERRORFILE
       else
         echo "$fn ...ok"
       fi
    else
      echo "$fn ...failed" | tee -a $REPORTFILE
      echo "!!!!! $fn errors:" | tee -a $ERRORFILE
      cat ${TMP_FILENAME} | tee -a $ERRORFILE
    fi
  fi
done
