#!/usr/bin/env bash

pushd $HOME

echo ; echo "Install and remove Flatpaks"

echo ; sudo flatpak update -y --noninteractive

if [ -e "$HOME/.flatpak-remove.conf" ]
then
	cat "$HOME/.flatpak-remove.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		if [ 0 -ne $(flatpak list | grep $LINE | wc --lines) ]
		then
			echo "Remove Flatpak $LINE"
			sudo flatpak uninstall -y --noninteractive $LINE
		else
			echo "Flatpak $LINE already removed"
		fi
	done
fi

if [ -e "$HOME/.flatpak-install.conf" ]
then
	cat "$HOME/.flatpak-install.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		if [ 0 -eq $(flatpak list | grep $LINE | wc --lines) ]
		then
			echo "Install Flatpak $LINE"
			sudo flatpak install -y --noninteractive $LINE
		else
			echo "Flatpak $LINE already installed"
		fi
	done
fi

popd

# EOF
