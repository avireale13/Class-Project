#!/usr/bin/env bash
#####################################################################
 # macports_install_packages.sh: installs gimp dependencies         #
 #                                                                  #
 # Copyright 2022 Lukas Oberhuber <lukaso@gmail.com>                #
 #                                                                  #
 # This program is free software; you can redistribute it and/or    #
 # modify it under the terms of the GNU General Public License as   #
 # published by the Free Software Foundation; either version 2 of   #
 # the License, or (at your option) any later version.              #
 #                                                                  #
 # This program is distributed in the hope that it will be useful,  #
 # but WITHOUT ANY WARRANTY; without even the implied warranty of   #
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    #
 # GNU General Public License for more details.                     #
 #                                                                  #
 # You should have received a copy of the GNU General Public License#
 # along with this program; if not, contact:                        #
 #                                                                  #
 # Free Software Foundation           Voice:  +1-617-542-5942       #
 # 51 Franklin Street, Fifth Floor    Fax:    +1-617-542-2652       #
 # Boston, MA  02110-1301,  USA       gnu@gnu.org                   #
 ####################################################################

set -e;

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
PREFIX=/opt/local
export PATH=$PREFIX/bin:$PATH

sudo port -N install icu
sudo port -N install openjpeg ilmbase json-c libde265 nasm x265
sudo port -N install util-linux xmlto py-cairo py-gobject3
sudo port -N install gtk-osx-application-gtk3 # should have python included. Let's see if it matters
sudo port -N install libarchive libyaml
sudo port -N install lcms2 glib-networking poppler poppler-data fontconfig libmypaint mypaint-brushes1 libheif \
  aalib webp shared-mime-info iso-codes librsvg gexiv2 libwmf openexr libmng ghostscript
# dbus not properly listed as dependency for gjs
sudo port -N install dbus gjs
sudo port -N install adwaita-icon-theme

sudo port -N install babl

sudo sed -i -e 's/buildfromsource always/buildfromsource never/g' /opt/local/etc/macports/macports.conf
sudo port -N install libgcc12
sudo sed -i -e 's/buildfromsource never/buildfromsource always/g' /opt/local/etc/macports/macports.conf

sudo port -N install gegl +vala

