#!/bin/bash

for (( i=1; i<=38; i++ )) ; do
    a=$i
    if (( "$i" < 10   )) ; then a="0$a" ; fi
    if (( "$i" < 100  )) ; then a="0$a" ; fi
    convert -crop 930x1200+0x0 $a.tiff complete/$a.png
    convert -resize 320x400 complete/$a.png complete2/$a.png
    convert -rotate 90 complete2/$a.png complete3/$a.png
    #cjb2 -clean -dpi 150 complete/$a.pbm complete/$a.djvu
    #cpaldjvu -dpi 150 complete/$a.ppm complete/$a.djvu
    #if test -e complete/$a.djvu
    #then
    #    rm complete/$a.pbm
    #else
    #    echo "Problem with converting page image '$a'!"
    #fi
done
#djvm -c out.djvu `ls complete/*.djvu`
