#!/usr/bin/env bash

echo ; echo "Install additional Mint applets"

pushd "$HOME/.local/share/cinnamon/applets/"

if [ -e "$HOME/Mint/mint-actions-download.conf" ]
then
	cat "$HOME/Mint/mint-actions-download.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		if [ ! -d "$LINE" ]
		then
			echo "$LINE"
			wget https://cinnamon-spices.linuxmint.com/files/applets/${LINE}.zip && \
			unzip ${LINE}.zip
			rm -f ${LINE}.zip
		else
			echo "$LINE already exists"
		fi
	done
fi

popd

# EOF
