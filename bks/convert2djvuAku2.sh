#!/bin/bash

CD=`pwd`
WD="/srv/stuff/tmp/Akupunktura2/out"
cd $WD
for (( i=1; i<=194; i++ )) ; do
  x=`printf "%04d" $i`
  xx="${x}_1L.tif"
  yy="${x}_2R.tif"
  # echo "$x"
  if [ -f "$xx" ]   ; then
    echo -n "$xx "
    convert $xx $xx.pbm
    cjb2 -dpi 600 $xx.pbm $xx.djvu
    rm $xx.pbm
  fi
  if [ -f "$yy" ]   ; then
    echo -n "$yy "
    convert $yy $yy.pbm
    cjb2 -dpi 600 $yy.pbm $yy.djvu
    rm $yy.pbm
  fi
done

convert .cover.tif .cover.ppm
c44 -dpi 600 .cover.ppm 0001_1L.tif.djvu
rm .cover.ppm
convert back.tif back.ppm
c44 -dpi 600 back.ppm 0194_2R.tif.djvu
rm back.ppm
djvm -c out.djvu `ls *.djvu`
cd $CD
exit 0
