#!/bin/bash

get_textrel() {
    exe=$1
    #echo -- $exe --
    if file $exe | grep "ELF " >/dev/null  ; then
	readelf -d $exe 2>/dev/null | grep TEXTREL  2>&1>/dev/null && echo TEXTREL in exe $exe
	ldd $exe | awk '{print $3}' | while read lib; do
	    readelf -d $lib | grep TEXTREL 2>&1>/dev/null && echo TEXTREL library $lib exec $exe
	done
    fi
}

if [ "$1" = "" ]; then
    echo Usage: $0 "<path/filename>"
    #exit 1
    #paths=`echo ${PATH} | tr ':' '\n'`
fi

for exe in "$@" $paths ; do
    [ -f $exe ] && get_textrel $exe
    [ -d $exe ] && (
	for e in $exe/* ; do
	get_textrel $e
	done
    )
done
