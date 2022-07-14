#!/bin/bash
#
# This is a script to rebuild the MicroPython binary for the Raspberry
# Pi Pico W module, including the the latest snapshot of upagekite.
#
# It is tested with MicroPython 1.19+ (github code as of 14.7.2022).
#
set -e -x            # Bail on errors, print commands before running them

### Cleanup/setup
#
# rm -rf build/rpi-pico-w
mkdir -p binaries build/rpi-pico-w               # Don't comment this out 
cd build/rpi-pico-w                              # Don't comment this out 
BUILDDIR=$(pwd)                                  # Don't comment this out 
TODAY=$(date +%Y%m%d)                            # Don't comment this out 


### Prerequisites; adapt to your OS as necessary
#
# See: https://github.com/micropython/micropython#external-dependencies
# See: https://github.com/raspberrypi/pico-sdk
#
# sudo apt-get install \
#   build-essential git cmake gcc-arm-none-eabi \
#   libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib


### Fetch the code we need
#
# cd $BUILDDIR
# git clone https://github.com/micropython/micropython.git
# git clone https://github.com/pagekite/upagekite.git


### Build Micropython tools
#
# cd $BUILDDIR/micropython
# make -C mpy-cross


### Add upagekite to the ports/rp2/modules folder
#
# cd $BUILDDIR/micropython/ports/rp2/modules
# cp -a $BUILDDIR/upagekite/upagekite .
# rm -f upagekite/{esp32,__main}*.py


### Your Code Here:
#
# cd $BUILDDIR/micropython/ports/rp2/modules
# cp -a /path/to/other/python/code .


### Build MicroPython firmware
#
# cd $BUILDDIR/micropython/ports/rp2
# make BOARD=PICO_W submodules
# make BOARD=PICO_W clean
# make BOARD=PICO_W


### Copy the firmware, giving it a descriptive name
#
# cd $BUILDDIR/micropython/ports/rp2
# cp -v build-PICO_W/firmware.uf2 \
#   $BUILDDIR/../../binaries/micropython-picow-upagekite-$TODAY.uf2


### Report results
#
set +x; echo; cd $BUILDDIR/../..
ls -l binaries/micropython-picow-upagekite-$TODAY.uf2


### Remind us how to flash the chip
#
cat <<tac

In order to flash the chip:

  1. Make sure the Pico W is unplugged
  2. Hold the Pico W reset button
  3. Plug it in to your laptop, it will appear as a USB drive
  4. Copy the .uf2 binary to the root of the USB drive

The board should reboot automatically when the .uf2 file has been
copied. That's it! Now go find a serial console and happy hacking!

tac

#EOF#
