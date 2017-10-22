#!/bin/bash
for str in `ls` ; do
    #echo $str
    str2=`echo $str | sed s/%3a/:/g`
    str2=`echo $str2 | sed s/%5f/_/g`
    if [ "$str" != "$str2" ]
    then
        echo "$str moved to $str2"
        mv $str $str2
    fi
done
