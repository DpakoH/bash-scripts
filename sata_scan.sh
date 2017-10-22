#!/bin/bash

for i in `ls /sys/class/scsi_host/` ; do
  echo -n "$i "
  echo "- - -" > /sys/class/scsi_host/$i/scan
  sleep 1
done
echo
