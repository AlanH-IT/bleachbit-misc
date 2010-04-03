#!/bin/bash

# Copyright (C) 2010 by Andrew Ziem.  All rights reserved.
# License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
#
# Unpack GTK+ Windows binaries and prepare for use
#

echo pre-clean
rm -rf bin etc lib manifest share

echo unzip
unzip -q atk_*zip
unzip -q cairo_*zip
unzip -q expat*zip
unzip -q fontconfig*
unzip -q freetype*
#unzip -q jpeg_*_win32.zip
unzip -q gettext-runtime-*zip
unzip -q glib*zip
unzip -q gtk+_2*zip
unzip -q libpng*zip
#unzip -q libtiff*zip
unzip -q pango*zip
unzip -q zlib*zip zlib1.dll

echo move/copy
mv zlib1.dll bin
cp gtkrc etc/gtk-2.0/

echo remove unnecessary
find \( -name atk10.mo -o -name glib20.mo -o -name gtk20-properties.mo \) -exec rm -f \{\} \+
find lib/gtk-2.0/2.10.0/loaders/ | grep dll$ | grep -v png | xargs rm -f 
rm -f bin/*exe
rm -f bin/libtiff-3.dll
rm -f bin/libtiffxx-3.dll
rm -f etc/gtk-2.0/gtk.immodules
rm -f lib/charset.alias
rm -f lib/gtk-2.0/2.10.0/engines/libpixmap.dll
rm -rf etc/pangoa/
rm -rf manifest
rm -rf share/doc
rm -rf share/themes/{Default,Emacs,Raleigh}/


echo strip
# warning: do not strip zlib1.dll
i686-pc-mingw32-strip --strip-debug --preserve-dates  -v bin/intl* bin/free* bin/lib*
find lib \( -iname '*dll' -o -iname '*exe' \) -exec i686-pc-mingw32-strip --strip-debug --discard-all --preserve-dates  -v \{\} \+

echo compress UPX
find \( -iname '*dll' -o -iname '*exe' \) -exec upx --best --crp-ms=999999 --nrv2e \{\} \+

