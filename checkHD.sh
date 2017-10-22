#!/bin/bash

if [[ $1 ]]
then
  DRIVE="$1"
  BSIZE=`blockdev --getsize64 $DRIVE`
  if [ "$?" -ne "0" ] ; then
    echo "Script needs argument: /dev/sdN"
    exit 2
  fi
  TSIZE=`echo "${BSIZE}/1000000000" | bc -l | cut -d'.' -f 1`
  echo "drive=$DRIVE bsize=$BSIZE tsize=$TSIZE"
  TMPFREE=`df /tmp | tr -s ' ' | tail -n 1 | cut -d' ' -f 4`
  if (( "$TMPFREE" < 300000 )) ; then
    echo "Script needs 200MiB of free size on /tmp ramdisk"
    exit 1
  fi
  dd if=/dev/urandom of=/tmp/testfile bs=1000000 count=100
  MD1=`md5sum /tmp/testfile | cut -d' ' -f 1`
  for i in `seq $TSIZE -1 1` ; do
    dd if=/tmp/testfile of=$DRIVE bs=1000000 count=100 seek=${i}000
    if [ "$?" -ne "0" ] ; then
      echo "dd write failed"
      exit 3
    fi
    dd if=$DRIVE of=/tmp/testfile2 bs=1000000 count=100 skip=${i}000
    if [ "$?" -ne "0" ] ; then
      echo "dd read failed"
      exit 4
    fi
    MD2=`md5sum /tmp/testfile2 | cut -d' ' -f 1`
    if [ "$MD1" != "$MD2" ] ; then
      echo "md5 comparison failed"
      exit 5
    fi
    rm /tmp/testfile2
  done
  rm /tmp/testfile
else
  echo "Script needs argument: /dev/sdN"
fi
