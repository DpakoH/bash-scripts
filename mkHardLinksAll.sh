#!/bin/bash

for j in `find . -mindepth 1 -maxdepth 1 -type d | cut -c3- | grep -v ^all$` ; do
  cd "$j"
  # dirs
  for i in `find . -mindepth 1 -maxdepth 1 -type d | cut -c3- | tr ' ' '~'` ; do 
    dir=`echo $i | tr '~' ' '`
    echo "$dir"
    mkdir "../all/$dir"
    cd "$dir"
    for k in `find . -mindepth 1 -maxdepth 1 -type f | cut -c3- | tr ' ' '~'` ; do 
      file=`echo $k | tr '~' ' '`
      ln "$file" "../../all/$dir/$file"
    done
    cd ..
  done
  # files
  for i in `find . -mindepth 1 -maxdepth 1 -type f | cut -c3- | tr ' ' '~'` ; do 
    file=`echo $i | tr '~' ' '`
    echo "$file"
#ln "Pigface - Steamroller.mp3" "../all/Pigface - Steamroller.mp3"
    ln "$file" "../all/$file"
  done
  cd ..
done
# y=`echo $a | cut -c 1-4` ; o=`echo $a | cut -c 6-` ; mv "$a" "[$y] $o" ; 
