#!/bin/bash
LIBMESA=/usr/lib/mesa

#LD_LIBRARY_PATH=$LIBMESA /usr/bin/compiz.real --replace $1 gconf &
#LD_LIBRARY_PATH=$LIBMESA /usr/bin/gnome-window-decorator &
#LD_LIBRARY_PATH=$LIBMESA 
killall gnome-window-decorator
killall metacity
gnome-window-decorator &
#LD_LIBRARY_PATH=$LIBMESA
LD_PRELOAD=$LIBMESA/libGL.so compiz --replace gconf decoration wobbly fade minimize cube rotate zoom scale move resize place switcher &

#exec gnome-session

#scale wobbly place switcher move cube resize fade minimize decoration rotate zoom
