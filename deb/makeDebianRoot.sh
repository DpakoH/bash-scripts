#!/bin/bash

sudo rm -rf /opt/tmp/etch-root
sudo debootstrap --include=mc,xfsprogs,xfsdump,reiserfsprogs,dosfstools,jfsutils,ntfsprogs,parted,smartmontools,hdparm,hddtemp,strace,ltrace,lsof,lynx,chkrootkit,zip,p7zip,unrar-free,usbutils,valgrind,whois,traceroute,testdisk,perl,smbclient,smbfs,lm-sensors,pciutils,cpio,catdoc,htop,hfsutils \
                 --exclude=vim-common,vim-tiny etch /opt/tmp/etch-root file:///mnt/loop1/debian
#sudo debootstrap --second-stage
