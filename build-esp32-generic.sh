#!/bin/bash
#
# This is a script to rebuild the MicroPython binary for ESP32 modules,
# including the latest snapshot of upagekite.
#
# It is tested with MicroPython 1.19+ (github code as of 14.7.2022).
#
set -e -x            # Bail on errors, print commands before running them


### Choose which board to build for
#
# Examples: GENERIC, GENERIC_C3, GENERIC_OTA, GENERIC_SPIRAM, ...
# Consult the MicroPython ports/esp32/boards/ directory for a full list.
#
export BOARD=GENERIC_SPIRAM


### Cleanup/setup
#
# rm -rf build/esp32-$BOARD
mkdir -p binaries build/esp32-$BOARD             # Don't comment this out 
cd build/esp32-$BOARD                            # Don't comment this out 
BUILDDIR=$(pwd)                                  # Don't comment this out 
TODAY=$(date +%Y%m%d)                            # Don't comment this out 


### Prerequisites; adapt to your OS as necessary
#
# See: https://github.com/micropython/micropython#external-dependencies
# See: https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/linux-setup.html#standard-setup-of-toolchain-for-linux
#
# sudo apt-get install \
#   git wget flex bison gperf python3 python3-pip python3-setuptools \
#   python3-virtualenv cmake ninja-build ccache libffi-dev libssl-dev \
#   dfu-util libusb-1.0-0


### Fetch the code we need
#
# git clone https://github.com/micropython/micropython.git
# git clone -b v4.4 --recursive https://github.com/espressif/esp-idf.git
# git clone https://github.com/pagekite/upagekite.git


### Set up the ESP32 SDK, import SDK environment variables
#
cd $BUILDDIR/esp-idf                             # Don't comment this out 
# ./install.sh
source ./export.sh                               # Don't comment this out 


### Build MicroPython tools
#
# cd $BUILDDIR/micropython
## git checkout BRANCH/TAG/...   # Optional: build a specific MicroPython
# make -C mpy-cross


### Add upagekite to the ports/rp2/modules folder
#
# cd $BUILDDIR/micropython/ports/esp32/modules
# cp -a $BUILDDIR/upagekite/upagekite .
# rm -f upagekite/{esp32,__main}*.py


### Your Code Here:
#
# cd $BUILDDIR/micropython/ports/esp32/modules
# cp -a /path/to/other/python/code .
#


### Build the firmware itself
#
# cd $BUILDDIR/micropython/ports/esp32
# make BOARD=$BOARD submodules
# make BOARD=$BOARD


### Copy the firmware, giving it a descriptive name
#
# cd $BUILDDIR/micropython/ports/esp32
# cp build-$BOARD/firmware.bin \
#   $BUILDDIR/../../binaries/micropython-esp32-$BOARD-upagekite-$TODAY.bin


### Report results
#
set +x; echo; cd $BUILDDIR/../..
ls -l binaries/micropython-esp32-$BOARD-upagekite-$TODAY.bin
echo


### Flash the chip
#
# set -x
# cd $BUILDDIR/../../binaries
# esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 erase_flash
# esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 \
#   write_flash -z 0x1000 micropython-esp32-$BOARD-upagekite-$TODAY.bin

#EOF#
