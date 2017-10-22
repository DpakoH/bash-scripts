#!/bin/bash

#tar -xjf linux-source-2.6.14.tar.bz2
cd linux
i=`date`
#fakeroot make-kpkg clean
cp ../.config.2.6.18 ./.config
#fakeroot make-kpkg --append-to-version=.sqshfs --config=menuconfig --initrd --added-patches \
#    reiser4,grsecurity2,vesafbtng,squashfs,debianlogo,badram \
#    kernel_image kernel_headers modules_image
fakeroot make-kpkg --config=menuconfig --initrd kernel_image kernel_headers modules_image
cp -f ./.config ../.config.2.6.18
echo "$i ->" `date`
cd ..
