#!/usr/bin/env bash

pushd $HOME

sudo chown -Rv _apt:root /var/cache/apt/archives/partial/
sudo chmod -Rv 700 /var/cache/apt/archives/partial/

echo "Add or delete additional PPAs"
echo ; sudo apt-get install -y --install-recommends ppa-purge
echo ; sudo add-apt-repository --y ppa:libreoffice/ppa
#echo ; sudo ppa-purge -y ppa:mozillateam/thunderbird-next
#echo ; sudo ppa-purge -y ppa:ubuntuhandbook1/shotwell
#echo ; sudo ppa-purge -y ppa:ubuntuhandbook1/darktable
#echo ; sudo ppa-purge -y ppa:freecad-maintainers/freecad-stable
echo ; sudo add-apt-repository -y ppa:tomtomtom/yt-dlp
#echo ; sudo ppa-purge -y ppa:longsleep/golang-backports
echo ; sudo add-apt-repository --y ppa:misery/ppa								# Ausweis App
echo ; sudo add-apt-repository --y ppa:aos1/diff-so-fancy
#echo ; sudo ppa-purge -y ppa:widelands-dev/widelands
#echo ; sudo ppa-purge -y ppa:nextcloud-devs/client
#echo ; sudo ppa-purge -y ppa:kicad/kicad-7.0-releases
#echo ; sudo ppa-purge -y ppa:kicad/kicad-8.0-releases


echo ; echo "Update existing Debian packages"
sudo apt update
sudo apt upgrade -y

echo ; echo "Remove Debian packages"
if [ -e "$HOME/.deb-remove.conf" ]
then
	cat "$HOME/.deb-remove.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		echo "Remove $LINE:"
		sudo apt remove -y $LINE
		echo
	done
fi

echo ; echo "Remove packages that are no longer required"
sudo apt autoremove -y


echo ; echo "Install Debian packages"
if [ -e "$HOME/.deb-install.conf" ]
then
	cat "$HOME/.deb-install.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		echo "Install $LINE:"
		sudo apt install -y --install-recommends $LINE
		echo
	done
fi

popd

# EOF
