#!/usr/bin/env bash

echo ; echo "Additional packages for TI Code Composer Studio 12"

#if [ 0 -eq $(cat /etc/apt/sources.list | grep -c 'deb http://cz.archive.ubuntu.com/ubuntu lunar main universe') ]
#then
#	sudo chmod ugo+w /etc/apt/sources.list
#	sudo echo 'deb http://cz.archive.ubuntu.com/ubuntu lunar main universe' >> /etc/apt/sources.list
#	sudo chmod ugo-w /etc/apt/sources.list
#	sudo apt update
#fi

sudo sed -i '/cz.archive.ubuntu.com/d' /etc/apt/sources.list

sudo apt install -y --install-recommends libc6-i386 libusb-0.1-4 libtinfo5

# EOF
