#!/usr/bin/env bash
#####################################################################
 # macports_install.sh: installs macports                           #
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

if [[ $(uname -m) == 'arm64' ]]; then
  build_arm64=true
  echo "*** Build: arm64"
else
  build_arm64=false
  echo "*** Build: x86_64"
fi

if [ ! $(command -v port &> /dev/null) ]; then
  echo "**install MacPorts"

  MACPORTS_INSTALLER=$HOME/macports
  mkdir -p $MACPORTS_INSTALLER
  pushd $MACPORTS_INSTALLER
  curl -L -O https://github.com/macports/macports-base/releases/download/v2.7.2/MacPorts-2.7.2-12-Monterey.pkg
  sudo installer -pkg MacPorts-2.7.2-12-Monterey.pkg -target /
  popd

  echo 'buildfromsource always' | sudo tee -a ${PREFIX}/etc/macports/macports.conf
  if [ "$build_arm64" = true ] ; then
    echo 'macosx_deployment_target 11.0' | sudo tee -a ${PREFIX}/etc/macports/macports.conf
    echo 'macosx_sdk_version 11.3' | sudo tee -a ${PREFIX}/etc/macports/macports.conf
  else
    echo 'macosx_deployment_target 10.12' | sudo tee -a ${PREFIX}/etc/macports/macports.conf
    echo 'macosx_sdk_version 10.12' | sudo tee -a ${PREFIX}/etc/macports/macports.conf
  fi
  echo '-x11 +no_x11 +quartz +python310 -python27 +no_gnome -gnome -gfortran' | sudo tee -a ${PREFIX}/etc/macports/variants.conf
  printf "file://${PROJECT_DIR}/ports\n$(cat ${PREFIX}/etc/macports/sources.conf)" | sudo tee ${PREFIX}/etc/macports/sources.conf

  rm -rf $MACPORTS_INSTALLER
fi

if [ "$build_arm64" = true ] ; then
    echo "*** Setup 11.3 SDK"
    cd /Library/Developer/CommandLineTools/SDKs
    if [ ! -d "MacOSX11.3.sdk" ]
    then
        sudo curl -L 'https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX11.3.sdk.tar.xz' | sudo tar -xzf -
    fi
    echo 'export SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX11.3.sdk' > ~/.profile
    echo 'export MACOSX_DEPLOYMENT_TARGET=11.0' >> ~/.profile
    echo 'export GIMP_ARM64=true' >> ~/.profile
else
    echo "*** Setup 10.12 SDK"
    cd /Library/Developer/CommandLineTools/SDKs
    if [ ! -d "MacOSX10.12.sdk" ]
    then
        sudo curl -L 'https://github.com/phracker/MacOSX-SDKs/releases/download/10.15/MacOSX10.12.sdk.tar.xz' | sudo tar -xzf -
    fi
    echo 'export SDKROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX10.12.sdk' > ~/.profile
    echo 'export MACOSX_DEPLOYMENT_TARGET=10.12' >> ~/.profile
fi

source ~/.profile

sudo port -v selfupdate
