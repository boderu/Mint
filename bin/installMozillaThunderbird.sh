#!/usr/bin/env bash

pushd $HOME

echo ; echo "Copy Mozilla and Thunderbird settings"

if [ ! -d "$HOME/.mozilla" ]
then
	if [ -d "$HOME/SynologyDrive/Mint/.mozilla" ]
	then
		cp -frv "$HOME/SynologyDrive/Mint/.mozilla" "$HOME/"
	fi
fi
if [ ! -d "$HOME/.thunderbird" ]
then
	if [ -d "$HOME/SynologyDrive/Mint/.thunderbird" ]
	then
		cp -frv "$HOME/SynologyDrive/Mint/.thunderbird" "$HOME/"
	fi
fi

echo ; echo "FireFox Download Helper App"
curl -sSLf https://github.com/aclap-dev/vdhcoapp/releases/latest/download/install.sh | bash

popd

# EOF
