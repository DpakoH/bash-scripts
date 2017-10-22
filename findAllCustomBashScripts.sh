#/!bin/bash

find / -noleaf -type f -a \( -perm /u+x -o -perm /g+x -o -perm /o+x \) > allExecs.tmp
cat allExecs.tmp | grep -v "^/var/lib/dpkg/info/" | grep -v "^/opt/matlab/" | \
  grep -v "^/bin/" | grep -v "^/usr/bin/" | grep -v "^/sbin/" | \
  grep -v "^/usr/sbin/" | grep -v "^/usr/src/" | grep -v "^/usr/share/" | \
  grep -v "^/usr/local/" | grep -v "^/usr/lib/" | grep -v "/usr/games/" | \
  grep -v "/.gnome2/panel2.d/default/launchers/" | \
  grep -v "/.cedega/.default_configuration_profiles/" | \
  grep -v "/.cedega/.winex_ver/winex-5.2/winex/" | \
  grep -v "^/etc/cron." | grep -v "^/etc/init.d/" | grep -v "^/etc/init.none/" | \
  grep -v "/.transgaming_global/mozcontrol/" | \
  grep -v "/.mozilla/firefox/kc7i1pfg.Default User/extensions/" > AllExecs2.tmp
for i in `cat AllExecs2.tmp`
do
    file $i | grep "shell script text executable"
done
