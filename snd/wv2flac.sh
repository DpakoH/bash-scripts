#!/bin/bash

declare -a wvs
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
  cut -c 3- | while read dir ; do
  cd "$dir"
  find . -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i \.wv$ |
    cut -c 3- | while read wv ; do
    wav=`echo $wv | perl -e 'while(<>) { $_ =~ s/\.wv$/\.wav/ ; print $_ }'`
    echo "$wv -> $wav"
    wvunpack -cc "$wv" -o "$wav"
    flac --best --replay-gain "$wav"
    rm "$wav"
  done
  cd ..
done
