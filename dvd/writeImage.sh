#!/bin/bash

WSPEED=62   # 8x
DVDWSPEED=8 # 8x
RSPEED=94   # 12x
DDRIVE="/dev/sr0"

if [ -z "$1" ]; then
    echo "$0: should be one parameter: filename.iso to write."
    exit 1
fi
DISK_FILE="$1"
# if file exists and has a size greater than zero
if [ ! -s "$DISK_FILE" ] ; then
    echo "ATTENTION!!! FILE $DISK_FILE NOT EXIST OR EQUAL TO ZERO!!!"
    echo "Press enter to continue or ^C to cancel"
    echo "(format and write)"
    read
fi
DF_SIZE=`ls -l "$DISK_FILE" | cut -d' ' -f 5`
#MAX_SIZE=$((2280880*2048)) = 4671242240
BLK_SIZE=`echo "$DF_SIZE/2048" | bc`
NW_SIZE=`echo "$BLK_SIZE*2048" | bc`
if [[ $DF_SIZE -ne $DF_SIZE ]] ; then
    echo "SHIT HAPPENS"
    exit 0
fi
#if [[ $DF_SIZE -gt 4671242240 && $DF_SIZE -lt 5000000000 ]] ; then # so good on asus/philips
#if [[ $DF_SIZE -gt 4695818240 && $DF_SIZE -lt 5000000000 ]] ; then # so good on pioneer
#if [[ $DF_SIZE -gt 4703256576 && $DF_SIZE -lt 5000000000 ]] ; then # overburn? test it!
#:-( /dev/sr0: 2295104 blocks are free, 2437201 to be written!
# ...
# 4654825472/4700372992 (99.0%) @8.0x, remaining 0:04 RBU 100.0% UBU 100.0%
# 4691886080/4700372992 (99.8%) @8.0x, remaining 0:00 RBU  99.9% UBU 100.0%
#:-[ WRITE@LBA=230540h failed with SK=5h/INVALID ADDRESS FOR WRITE]: Invalid argument
if [[ $DF_SIZE -gt 4700372992 && $DF_SIZE -lt 5000000000 ]] ; then
  echo "ATTENTION!!! FILE $DISK_FILE BIGGER THAN IT CAN!!!"
  echo "Press enter to continue or ^C to cancel"
  echo "(format and write)"
  read
  growisofs -overburn -dvd-compat -speed=$DVDWSPEED -Z $DDRIVE="$DISK_FILE"
else
  #wodim -sao -v "$DISK_FILE" speed=$WSPEED dev="$DDRIVE" 2>&1
  growisofs -dvd-compat -speed=$DVDWSPEED -Z $DDRIVE="$DISK_FILE"
fi
eject "$DDRIVE"
eject -t "$DDRIVE"
echo "Sleeping for 2 seconds to roll up the disk"
sleep 2
readom f=- sectors=0-$BLK_SIZE speed=$RSPEED dev="$DDRIVE" | md5sum
md5sum "$DISK_FILE"
eject "$DDRIVE"
echo "Sleeping for 10 seconds to show you that work done"
sleep 10
eject -t "$DDRIVE"
