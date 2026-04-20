#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    kvantum       \
    lua           \
    lxqt-qtplugin \
    qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
if [ "${DEVEL_RELEASE-}" = 1 ]; then
  PRE_BUILD_CMDS='sed -i "\|io.mgba.mGBA.desktop|d" ./PKGBUILD' make-aur-package mgba-git
  pacman -Q mgba-qt-git | awk '{print $2; exit}' > ~/version
else
  package=mgba-qt
  pacman -S --noconfirm $package
  pacman -Q mgba-qt | awk '{print $2; exit}' > ~/version
fi
