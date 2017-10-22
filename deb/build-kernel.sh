#!/bin/bash

#tar -xjf cdfs.tar.bz2
#tar -xjf cloop.tar.bz2
#tar -xjf loop-aes-ciphers.tar.bz2
#tar -xjf loop-aes.tar.bz2
#tar -xjf lufs.tar.bz2
#tar -xjf shfs.tar.bz2
#tar -xjf translucency.tar.bz2
#tar -xjf unionfs.tar.bz2

#tar xzf linux-source-2.6.14.tar.gz
#cd linux-source-2.6.14
cd linux
cp ../.config-2.6.16 ./.config
#fakeroot make-kpkg clean
i=`date`
#PATCHES="grsecurity2,squashfs,debianlogo"
#PATCHES="reiser4,grsecurity2,squashfs,debianlogo,badram"
PATCHES="grsecurity2,squashfs"
fakeroot make-kpkg --config=menuconfig --initrd --added-patches $PATCHES kernel_image kernel_headers modules_image
cp ./.config ../.config-2.6.16
echo $i `date`
