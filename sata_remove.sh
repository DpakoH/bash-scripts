#!/bin/bash

drive="$1"
if [ -z "$drive" ]; then
  echo "$0: should be one parameter: sdX to remove"
  exit 1
fi

cat /proc/mounts | grep "/dev/$drive" > /dev/null
if [ $? -eq 0 ] ; then
  echo "/dev/$drive should be unmounted before removing"
  exit 2
fi

sync
#sleep 1
#hdparm -Y /dev/$1
sleep 1
echo "1" > /sys/block/$1/device/delete
#sleep 1
#hdparm -Y /dev/$1
