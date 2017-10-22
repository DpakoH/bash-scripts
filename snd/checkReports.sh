#!/bin/bash

WORKDIR=`pwd`
REPORTFILE="${WORKDIR}/report.txt"
echo -n "" > "${REPORTFILE}"
find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -r0 -n 1 echo |
  cut -c 3- | while read dir ; do
  cd "${dir}"
  if [ "$?" -eq "0" ] ; then
    if [ -f "aucdtect_report.txt" ] ; then
      echo -n "."
    else
      echo "aucdtect_report.txt not found in directory \"${dir}\"" >> "${REPORTFILE}"
    fi
    cd ..
  else
    echo "cd to \"${dir}\" failed." >> "${REPORTFILE}"
  fi
done
