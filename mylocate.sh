#!/bin/bash

string=""

for argument in "$@" ; do
  if [ "$string" != "" ] ; then
    string="$string | grep -i \"$argument\""
  else
    string="locate -i \"$argument\""
  fi
done
echo "Executing $string"
eval "$string"
