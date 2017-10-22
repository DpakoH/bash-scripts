#!/bin/bash

OUTFILE=out.pdf

#pdf2ps 1.pdf 1.ps
#cp 1.ps out.ps
#cp title.pdf $OUTFILE
#LIST="title.pdf"
LIST=""
for ((i=$1; i<=$2; i++))
do
    #pdf2ps $i.pdf $i.ps
    #echo $i.PDF
    #pdfinfo $i.PDF
    [ -f $i.PDF ] && LIST="$LIST $i.PDF"
    [ -f $i.pdf ] && LIST="$LIST $i.pdf"
done
echo "$LIST"
#psmerge -oout.ps $LIST
#ps2pdf out.ps $OUTFILE
gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf $LIST
pdfinfo out.pdf
