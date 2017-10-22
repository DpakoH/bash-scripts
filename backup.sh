#!/bin/bash

#mkdir $2
if [[ $1 && $2 ]]
then
  FROM_DIR="$1"
  TO_DIR="$2"
  if [[ `echo "$FROM_DIR" | grep "^/" ` && -d "$FROM_DIR" && `echo "$TO_DIR" | grep "^/" ` ]]
  then
      find $1 -type d -print0 | xargs -0 -I! mkdir -p $2!
      find $1 -type f -print0 | xargs -0 -I! ln ! $2!
  else
    echo "Arguments should be full pathnames of directories starting with /"
  fi
else
  echo "Script needs two arguments: fromDir and ToDir"
fi
