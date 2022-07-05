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

port -N install icu
port -N install openjpeg ilmbase json-c libde265 nasm x265
port -N install getopt xmlto py-cairo py-gobject3
port -N install gtk-osx-application-gtk3 # should have python included. Let's see if it matters
port -N install libarchive libyaml
port -N install lcms2 glib-networking poppler poppler-data fontconfig libmypaint mypaint-brushes libheif \
  aalib libwebp shared-mime-info iso-codes librsvg-24 gexiv2 libwmf openexr libmng ghostscript
# left out webkit dependencies
port -N install babl gegl

# port -N install SuiteSparse_AMD SuiteSparse_CAMD SuiteSparse_CCOLAMD SuiteSparse_COLAMD SuiteSparse_CHOLMOD \
  # SuiteSparse_UMFPACK metis
