#!/bin/bash

for (( i=4; i<=70; i++ )) ; do
    a=$i
    if (( "$i" < 10   )) ; then a="0$a" ; fi
    if (( "$i" < 100  )) ; then a="0$a" ; fi
    convert g$a.tiff g$a.png
done
