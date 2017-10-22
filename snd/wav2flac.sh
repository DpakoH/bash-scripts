#!/bin/bash

declare -a wavs
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
  cut -c 3- | sort | while read dir ; do
  cd "$dir"
  find . -type f -print0 | xargs -r0 -n 1 echo | grep -i \.wav$ |
    cut -c 3- | sort | while read wav ; do
    flac --best --replay-gain "$wav"
  done
  cd ..
done
