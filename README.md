## Building MicroPython for the ESP32 / ESP32-CAM / Pico W

These are scripts I use to (re)build MicroPython for various chips / dev
modules. As of this writing there are scripts for:

   * Generic ESP32 modules
   * The ESP32-CAM, including the camera driver
   * The Raspberry Pi Pico W 

Note that the commands in the build-scripts are fully commented out,
running the script as-is will do nothing; this is deliberate, I use
these scripts during workshops/trainings and people are meant to read
the script and uncomment the bits they want to use.

Commenting out the download / setup sections is also a simple way to
save time during iterative development. I want a script for how I set
up the work environment, even if I don't do it every time.

(If you're in a rush you just uncomment everything and hope for the
best.)
