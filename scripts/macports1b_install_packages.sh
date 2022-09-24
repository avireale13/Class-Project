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
  massage_output $dosudo port -N install "$@"
}

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source ~/.profile
export PATH=$PREFIX/bin:$PATH

# Must be verbose because otherwise times out on circle ci
$dosudo port -v -N install rust
$dosudo port -v -N install llvm-15
echo "gcc12 being installed before gegl and gjs (via mozjs91)"
$dosudo sed -i -e 's/buildfromsource always/buildfromsource never/g' /opt/local/etc/macports/macports.conf
port_install gcc12
$dosudo sed -i -e 's/buildfromsource never/buildfromsource always/g' /opt/local/etc/macports/macports.conf

port_install gjs
port_install adwaita-icon-theme
port_install babl
port_install gegl +vala

massage_output $dosudo port upgrade outdated
