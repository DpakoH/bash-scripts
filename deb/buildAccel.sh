#!/bin/bash

####### apt-get install libpcre3-dev libssl-dev libnl2-dev

cd /usr/src
#rm -rf /usr/src/accel-ppp
#git clone git://accel-ppp.git.sourceforge.net/gitroot/accel-ppp/accel-ppp
rm -rf /usr/src/accel-ppp/build
cd /usr/src/accel-ppp
mkdir build
cd build
cmake -DBUILD_DRIVER=TRUE -DKDIR=/usr/src/linux -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_BUILD_TYPE=Debian -DLOG_PGSQL=FALSE -DSHAPER=TRUE ..
make
cp /etc/accel-ppp.conf /usr/src
cp /usr/share/accel-ppp/radius/dictionary /usr/src
/etc/init.d/accel-ppp stop ; rmmod pptp
checkinstall --pkgname=accel-ppp --install -D make install ; chmod +x /etc/init.d/accel-ppp
cp /usr/src/accel-ppp/build/accel-ppp_*.deb /usr/src
exit 0
cp /usr/src/accel-ppp.conf /etc ; cp /usr/src/dictionary /usr/share/accel-ppp
#exit 0
modprobe pptp ; /etc/init.d/accel-ppp superstart
