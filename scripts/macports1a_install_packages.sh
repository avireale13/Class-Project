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

if [ "$1" == "circleci" ]; then
  circleci=true
fi

function massage_output() {
	if [ $circleci ]; then
    # suppress progress bar
    "$@" | cat
  else
    "$@"
  fi
}

function port_install() {
  massage_output sudo port -N install "$@"
}

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
PREFIX=/opt/local
export PATH=$PREFIX/bin:$PATH

source ~/.profile

port_install python310
sudo port select --set python python310
sudo port select --set python3 python310
port_install icu
port_install openjpeg ilmbase json-c libde265 nasm x265
port_install util-linux xmlto py-cairo py-gobject3
port_install gtk-osx-application-gtk3
port_install libarchive libyaml
port_install lcms2 glib-networking poppler poppler-data fontconfig libmypaint mypaint-brushes1 libheif \
  aalib webp shared-mime-info iso-codes librsvg gexiv2 libwmf openexr libmng ghostscript
