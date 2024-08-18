#!/usr/bin/env bash

echo ; echo "Segger j-link & Ozone Debugger"

if [ -f "$HOME/Nextcloud/Apps/Mint/Segger/JLink_Linux_V794f_x86_64.deb" ]
then
	sudo apt purge -y jlink
	sudo apt install -y $HOME/Nextcloud/Apps/Mint/Segger/JLink_Linux_V794f_x86_64.deb
else
	echo "$HOME/Nextcloud/Apps/Mint/Segger/JLink_Linux_V794f_x86_64.deb not available"
fi

echo ; echo "Segger Ozone Debugger"
if [ -f "$HOME/Nextcloud/Apps/Mint/Segger/Ozone_Linux_V330d_x86_64.deb" ]
then
	sudo apt install -y $HOME/Nextcloud/Apps/Mint/Segger/Ozone_Linux_V330d_x86_64.deb
else
	echo "$HOME/Nextcloud/Apps/Mint/Segger/Ozone_Linux_V330d_x86_64.deb not available"
fi

# EOF
