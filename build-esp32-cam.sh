#!/bin/bash
#
# This is a script to rebuild the MicroPython binary for the ESP32-CAM
# module, including the driver for the camera and the latest snapshot
# of upagekite.
#
# It is tested with MicroPython 1.19+ (github code as of 14.7.2022).
#
set -e -x            # Bail on errors, print commands before running them

### Cleanup/setup
#
# rm -rf build/esp32-cam
mkdir -p binaries build/esp32-cam                # Don't comment this out 
cd build/esp32-cam                               # Don't comment this out 
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
#
# git clone https://github.com/lemariva/micropython-camera-driver
# cd esp-idf/components
# git clone https://github.com/espressif/esp32-camera


### Tweak the micropython camera driver for MicroPython 1.19+
#
# cd $BUILDDIR/micropython-camera-driver/src
# perl -i.bkp -pe 's/, MODULE_CAMERA_ENABLED//' modcamera.c
### What changed?
# diff -u modcamera.c.bkp modcamera.c


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


### Add the camera driver board definitions
#
# cd $BUILDDIR/micropython/ports/esp32/boards
# cp -va ../../../../micropython-camera-driver/boards/ESP32_CAM/ .


### Add upagekite to the ports/rp2/modules folder
#
# cd $BUILDDIR/micropython/ports/esp32/modules
# cp -a ../../../../upagekite/upagekite .
# rm -f upagekite/{esp32,__main}*.py


### Your Code Here:
#
# cd $BUILDDIR/micropython/ports/esp32/modules
# cp -a /path/to/other/python/code .


### Build the firmware itself
#
# cd $BUILDDIR/micropython/ports/esp32
# make BOARD=ESP32_CAM submodules
# make \
#   USER_C_MODULES=$BUILDDIR/micropython-camera-driver/src/micropython.cmake\
#   BOARD=ESP32_CAM all


### Copy the firmware, giving it a descriptive name
#
# cd $BUILDDIR/micropython/ports/esp32
# cp build-ESP32_CAM/firmware.bin \
#   $BUILDDIR/../../binaries/micropython-esp32-cam-upagekite-$TODAY.bin


### Report results
#
set +x; echo; cd $BUILDDIR/../..
ls -l binaries/micropython-esp32-cam-upagekite-$TODAY.bin
echo


### Flash the chip
#
# set -x
# cd $BUILDDIR/../../binaries
# esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 erase_flash
# esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 \
#   write_flash -z 0x1000 micropython-esp32-cam-upagekite-$TODAY.bin

#EOF#
