#!/bin/bash

if [ -z "$1" ]; then
    echo "$0: should be one parameter: filename.flac to convert from."
    exit 1
fi
FLAC_FILE="$1"
#exit 0

MP3_FILE=`echo $FLAC_FILE | perl -e 'while(<>) { $_ =~ s/\.flac$/\.mp3/ ; print $_ }'`
flac -d -c "$FLAC_FILE" > tmp.wav
lame --preset studio -q 0 -v --vbr-new -V 0 -m s tmp.wav "$MP3_FILE"
rm tmp.wav
