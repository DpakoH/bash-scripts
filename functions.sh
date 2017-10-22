#!/bin/bash

# there are common functions for all my shell scripts

# example of function returns string
capitalize_ichar ()          #  Capitalizes initial character
{                            #+ of argument string(s) passed.
  string0="$@"               # Accepts multiple arguments.
  firstchar=${string0:0:1}   # First character.
  string1=${string0:1}       # Rest of string(s).
  FirstChar=`echo "$firstchar" | tr a-z A-Z`
                             # Capitalize first character.
  echo "$FirstChar$string1"  # Output to stdout.
}
# newstring=`capitalize_ichar "every sentence."`

# get sorted list of flacs in current dir
get_files () {
  fr=" " ;  to="\`" ; ext="${1}"
  a=( `find . -mindepth 1 -maxdepth 1 -type f -print0 | xargs -r0 -n 1 echo | sort | grep -i "${ext}" | tr "${fr}" "${to}" | cut -c 3-` )
  echo "${a[@]}"
}

get_dirs () {
  fr=" " ; to="\`"
  a=( `find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo | sort | tr "${fr}" "${to}"| cut -c 3-` )
  echo "${a[@]}"
}

unscreen_var () {
  fr=" " ;  to="\`"
  var1="${1}"
  echo ${var1} | tr "${to}" "${fr}"
}

#for i in `get_files "\.flac$"` ; do
#  a=`unscreen_var "${i}"`
#  echo "$a -> $a"
#done
