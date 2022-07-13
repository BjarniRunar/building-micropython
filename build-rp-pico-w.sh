#!/bin/bash

# Make sure we have upagekite already
#
# git clone https://github.com/pagekite/upagekite


# Create/clean our build directory
#
rm -rf build.rpi-pico-w
mkdir -p build.rpi-pico-w
cd build.rpi-pico-w


# Prerequisites
sudo apt install build-essential cmake gcc-arm-none-eabi \
    libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib

# Fetching the code we need
#
git clone https://github.com/micropython/micropython.git
cd micropython
git submodule update --init -- lib/pico-sdk lib/tinyusb
cd ..


# Build Micropython tools
cd micropython
make -C mpy-cross

# Add upagekite to the ports/rp2/modules folder
cd ports/rp2/modules
cp -a ../../../../../upagekite/upagekite .
rm -f upagekite/{esp32,__main}*.py
#
# Your Code Here:
#
# cp -a /path/to/other/python/code .
#
cd ../../..

# Build the firmware itself
cd ports/rp2
make BOARD=PICO_W submodules
make BOARD=PICO_W clean
make BOARD=PICO_W


# Copy the firmware, giving it a descriptive name
TODAY=$(date +%Y%m%d)
cp -v build-PICO_W/firmware.uf2 \
    ../../../../micropython-picow-upagekite-$TODAY.uf2

