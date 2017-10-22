#!/bin/bash

#MODNAME='ebt_snat'
MODNAME='ebt_log'
SRCDIR='/usr/src/kernel-source-2.4.20'
LIBDIR='/lib/modules/2.4.20.ebtables.030706'
cd $SRCDIR/net/bridge/netfilter
gcc -D__KERNEL__ -I$SRCDIR/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing      \
  -fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i686 -DMODULE -DMODVERSIONS  \
  -include $SRCDIR/include/linux/modversions.h  -nostdinc -iwithprefix include -DKBUILD_BASENAME=$MODNAME \
  -c -o $MODNAME.o $MODNAME.c
cp $MODNAME.o $LIBDIR/kernel/net/bridge/netfilter
/etc/init.d/ebtables stop
rmmod $MODNAME
lsmod
/etc/init.d/ebtables start
