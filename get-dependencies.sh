#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake              \
    desktop-file-utils \
    kvantum            \
    libepoxy           \
    libmgba            \
    libzip             \
    lua                \
    lxqt-qtplugin      \
    qt6-multimedia     \
    qt6-tools          \
    qt6ct              \
    sdl2-compat        \
    vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

if [ "${DEVEL_RELEASE-}" = 1 ]; then
  echo "Building nightly version of mGBA..."
  echo "---------------------------------------------------------------"
  REPO="https://github.com/mgba-emu/mgba"
  VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
  git clone "$REPO" ./mgba
  echo "$VERSION" > ~/version

  cmake -S ./mgba -B build \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_MINIZIP=OFF
  cmake --build build --config Release
  cmake --install build
else
  pacman -S --noconfirm mgba-qt
  pacman -Q mgba-qt | awk '{print $2; exit}' > ~/version
fi
