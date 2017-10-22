#!/bin/bash

cd "/var/ftp2/flacs(checked with aucdtect)"
i=`date +%Y%m%d%H%M`
echo $i
#find . -type f -print0 | sort | xargs -r0 sha1sum > "digest$i.sha1"
find . -type f -print0 | sort | xargs -r0 md5sum > "digest$i.md5sum"
