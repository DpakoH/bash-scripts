#!/bin/bash

rm out4/*
for (( i=0; i<=290; i++ )) ; do
    let x="$i*2"
    let y="$i*2+1"
    xx=$x
    yy=$y
    if (( $x < 10  )) ; then xx="0$xx" ; fi
    if (( $x < 100 )) ; then xx="0$xx" ; fi
    if (( $y < 10  )) ; then yy="0$yy" ; fi
    if (( $y < 100 )) ; then yy="0$yy" ; fi
    if [ -f out/$xx.tiff ]   ; then
        echo -n $xx ...
        convert out/$xx.tiff -rotate 270 out2/$xx.png
	#4586x3392
        convert out2/$xx.png -crop 2000x3200+200+0 out3/$xx.pbm
        convert out2/$xx.png -crop 2000x3200+2300+0 out3/$yy.pbm
	rm out2/$xx.png
	cjb2 -dpi 400 out3/$xx.pbm out4/$xx.djvu
	cjb2 -dpi 400 out3/$yy.pbm out4/$yy.djvu
	rm out3/$xx.pbm
	rm out3/$yy.pbm	
    fi
done
convert out/cover.tiff out/cover.ppm
rm out4/000.djvu
c44 -dpi 200 out/cover.ppm out4/000.djvu
rm out/cover.ppm
convert out/back.tiff out/back.ppm
rm out4/577.djvu
c44 -dpi 200 out/back.ppm out4/577.djvu
rm out/back.ppm
djvm -c out.djvu `ls out4/*.djvu`
