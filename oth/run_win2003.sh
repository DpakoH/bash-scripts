#!/bin/bash

export QEMU_AUDIO_DRV=none
qemu -hda win2003.qcow -hdb fat:/opt/tmp/mirrors/qemu/this -localtime -net none
