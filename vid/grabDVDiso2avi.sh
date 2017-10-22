#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: filename.iso to grab from."
    exit 1
fi
ISO_FILE="$1"
# if file exists and has a size greater than zero
if [ ! -s "$ISO_FILE" ] ; then
    echo "ATTENTION!!! FILE $ISO_FILE NOT EXIST OR EQUAL TO ZERO!!!"
    exit 1
fi
TMP_DIR=`mktemp -d /tmp/grabiso-XXXXXXXX` || exit 1
TMP_OUT_DIR=`mktemp -d ./grabiso-XXXXXXXX` || exit 1
NAME=`echo $ISO_FILE | rev | cut -c 5- | rev`
echo "$NAME"
#ls -la "$TMP_DIR"
LOOP_DEVICE=`losetup -f`
losetup "$LOOP_DEVICE" "$ISO_FILE"
sudo mount "$LOOP_DEVICE" "$TMP_DIR" -t udf -o users
#ls -laR "$TMP_DIR"
#vobcopy -i "$TMP_DIR" -I
#vobcopy -i "$TMP_DIR" -l -o "$TMP_OUT_DIR" -t "$NAME"
sudo umount "$LOOP_DEVICE"
losetup -d "$LOOP_DEVICE"
#mount -o loop "$ISO_FILE" "$TMP_DIR"
#umount "$TMP_DIR"
rmdir "$TMP_DIR"

# mencoder.exe dvd://4 -dvd-device "e:\dvd\a1" -nosound -vf scale=656:384,crop=640:368:8:8 -lavcopts vcodec=mpeg4:vbitrate=2100:keyint=250:vpass=2 -ovc lavc -passlogfile "f:\temp\mencoder.log" -ffourcc DIVX -noodml -o f:\dvd\a1.avi
