#!/bin/bash

name=disk
speed=4
bkp="-c boot.catalog -b cdrom.img"
md5s=`mkisofs $bkp $name | tee $name.iso | md5sum`
cdrecord.sh blank=fast
cdrecord.sh -force -sao -speed $speed $name.iso 2>&1 | tee cdrecord.out
size=`cat cdrecord.out | grep "^Track 0" | cut -d'(' -f 2 | cut -d' ' -f 1`
rm cdrecord.out
readcd f=- sectors=0-$size | md5sum
echo $md5s
