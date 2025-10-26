#!/usr/bin/env bash

# https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html

echo ; echo "Install prerequisites for VSCode ESP-IDF (Espressif)"

# Step 1: Install Prerequisites
sudo apt install -y --install-recommends git wget flex bison gperf python3 python3-pip python3-venv cmake
sudo apt install -y --install-recommends ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

# Does the tools exist?
if [ -d $HOME/esp/esp-idf ]
then
	# Yes, the tools already exist. Update repository.
	pushd  $HOME/esp/esp-idf
	git pull --recurse-submodules
	popd
else
	# No, the tools do not yet exist.
	# Step 2: Get ESP-IDF
	mkdir -p $HOME/esp
	pushd  $HOME/esp
	git clone --recursive https://github.com/espressif/esp-idf.git
	popd
fi

# Step 3: Set up the Tools
pushd $HOME/esp/esp-idf
./install.sh esp32
popd

# Step 4: Set up the Environment Variables (Also executed in .profile!)
. $HOME/esp/esp-idf/export.sh

# EOF
