#!/bin/bash

export QEMU_AUDIO_DRV=none
#KERNEL=/opt/tmp/mirrors/qemu/vmlinuz-2.6.14.gr
#INITRD=/opt/tmp/mirrors/qemu/initrd.img-2.6.14.gr2
#KERNEL=/opt/tmp/mirrors/qemu/vmlinuz-2.6.16.gr-grsec
#INITRD=/opt/tmp/mirrors/qemu/initrd.img-2.6.16.gr-grsec
KERNEL=vmlinuz-2.6.16-1-686
INITRD=initrd.img-2.6.16-1-686
qemu -hda debian.img -localtime -net none -kernel $KERNEL -initrd $INITRD -append "ro root=/dev/hda1 selinux=0"
#qemu -hda debian -localtime -net none -kernel $KERNEL -append "ro root=/dev/hda1 selinux=0 init=/bin/bash"
