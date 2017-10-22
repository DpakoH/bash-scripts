#!/bin/bash

CURDIR=`pwd`
#WORKDIR="/mnt/raid/tmp"
WORKDIR="/srv/stuff/temp"
#cd "$WORKDIR"

#if [ -f "$WORKDIR/growisofs.out" ] ; then
#  rm "$WORKDIR/growisofs.out"
#fi
#if [ -f "$WORKDIR/mkisofs.out" ] ; then
#  rm "$WORKDIR/mkisofs.out"
#fi
if [ -f "$WORKDIR/genisoimage.out" ] ; then
  rm "$WORKDIR/genisoimage.out"
fi
if [ -f "$WORKDIR/wodim.out" ] ; then
  rm "$WORKDIR/wodim.out"
fi
#if [ -f "$WORKDIR/cdrecord.out" ] ; then
#  rm "$WORKDIR/cdrecord.out"
#fi

DISK_DIR="$WORKDIR/disk"
#DISK_DIR="/mnt/music/from_180G/disc"
#DISK_DIR="/opt/tmp/isos/kolxo3_05"
#DISK_DIR=/opt/tmp/mirrors/.mldonkey/temp
#DISK_FILE="$WORKDIR/cd.iso"
DISK_FILE="$WORKDIR/cd.iso"
#DISK_FILE="/mnt/music/tmp.iso"
#DISK_FILE="/opt/tmp/tmp.iso"
WSPEED=64 # 8x
RSPEED=94 # 12x
DVDWSPEED=4 # 8x
DDRIVE="/dev/sr0"
#if [ -z "$1" ]; then
#    echo "$0: should be one parameter."
#    exit 1
####fi
####mkisofs -dvd-video -o cd.iso disk
if [ -f "$DISK_FILE" ] ; then
  rm "$DISK_FILE"
fi
md5s=`nice -n 19 genisoimage -J -joliet-long -R $DISK_DIR 2>"$WORKDIR/genisoimage.out" | tee $DISK_FILE | md5sum`
####md5s=`nice -n 19 genisoimage -D -udf -allow-limited-size $DISK_DIR 2>"$WORKDIR/genisoimage.out" | tee $DISK_FILE | md5sum`
#if [ $? = 1 ]; then
#    exit 1
#fi
blks=`cat "$WORKDIR/genisoimage.out" | grep extents | cut -d' ' -f 1`
#let trublks=blks-32
#md5s=`dd if=$DISK_FILE bs=2k skip=32 count=$trublks | md5sum`
#echo md5sum=$md5s;
#echo blocks=$blks;
if [ ! -s "$DISK_FILE" ] ; then
    echo "ATTENTION!!! FILE $DISK_FILE NOT CREATED!!!"
    echo "Press enter to continue "
    echo "(format and write)"
    read
fi
if [ $blks -gt 2295000 ] ; then
    echo "ATTENTION!!! FILE $DISK_FILE BIGGER THAN IT CAN!!!"
    echo "Press enter to continue "
    echo "(format and write)"
    read
fi
dvd+rw-format -force $DDRIVE
#cdrecord blank=fast
#cdrecord -sao -speed $SPEED $DISK_FILE 2>&1 | tee cdrecord.out
#growisofs -speed=$SPEED -dvd-compat -Z $DDRIVE=$DISK_FILE | tee growisofs.out
#wodim -sao -v "$DISK_FILE" speed=$WSPEED dev="$DDRIVE" 2>&1 | tee "$WORKDIR/wodim.out"
growisofs -dvd-compat -speed=$DVDWSPEED -Z $DDRIVE="$DISK_FILE" | tee growisofs.out
#wodim -fix -speed=$SPEED 2>&1 | tee -a wodim.out
#cdrecord-prodvd -sao -speed 4 cd.iso 2>&1 | tee cdrecord.out
#Track 01: Total bytes read/written: 4679368704/4679368704 (2284848 sectors).
#size=`cat cdrecord.out | grep "^Track 0" | cut -d'(' -f 2 | cut -d' ' -f 1`
#size=`cat growisofs.out | grep "^builtin_dd:" | cut -d' ' -f 2 | cut -d'*' -f 1`
#rm cdrecord.out
###########eject "$DDRIVE"
###########eject -t "$DDRIVE"
#readcd f=- sectors=32-$blks | md5sum
#readcd f=- sectors=0-$blks | md5sum
#dd if=$DDRIVE bs=2048 count=$blks 2>/dev/null | md5sum
readom f=- sectors=0-$blks speed=$RSPEED dev="$DDRIVE" | md5sum
echo "$md5s"
#eject
#NAME=BatmanBegins
#dd if=/opt/tmp/video/dvd/$NAME.iso of=/mnt/hdb5/$NAME.1.iso bs=2k count=2295104
#dd if=/opt/tmp/video/dvd/$NAME.iso of=/mnt/hdb5/$NAME.2.iso bs=2k skip=2295104
#cd "$CURDIR"
eject "$DDRIVE"
eject -t "$DDRIVE"
