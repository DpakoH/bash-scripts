#!/bin/bash

cd /home/chroot
#APPS="bash screen strace mc ssh ldd irssi"
APPS="ls mkdir mv pwd rm id cat ping dircolors reset /usr/games/fortune locale date ldd ltrace host which telnet"

for pr in $APPS;  do
    prog=`which $pr`
    cp $prog .$prog

    # obtain a list of related libraries
    ldd $prog > /dev/null
    if [ "$?" = 0 ] ; then
        LIBS=`ldd $prog | awk '{ print $3 }'`
        for l in $LIBS; do
            mkdir .`dirname $l` > /dev/null 2>&1
            if ! [ -e .$l ] ; then
                cp $l .$l
            fi
        done
    fi
done
