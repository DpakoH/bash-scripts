#!/bin/bash

md5s=`readcd f=- | tee cd.iso | md5sum`
echo "Press enter to continue"
read
cdrecord.sh -sao -speed 6 cd.iso
readcd f=- | md5sum
echo $md5s
rm cd.iso
