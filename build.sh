#!/bin/sh

specify -Nns rpm/*yaml || exit 1
printf building...
rm jolla-settings/translations/*.qm
rm -r icons/z*
rpmbuild -bb --build-in-place rpm/*.spec > build.log 2>&1
printf "exit: $?\n"
grep ^Wrote build.log
rm -f *.list
