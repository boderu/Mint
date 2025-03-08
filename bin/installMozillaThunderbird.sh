#!/usr/bin/env bash

pushd $HOME

echo ; echo "Copy Mozilla and Thunderbird settings"

if [ ! -d "$HOME/.mozilla" ]
then
	if [ -d "$HOME/SynologyDrive/.mint/.mozilla" ]
	then
		cp -frv "$HOME/SynologyDrive/.mint/.mozilla" "$HOME/"
	fi
fi
if [ ! -d "$HOME/.thunderbird" ]
then
	if [ -d "$HOME/SynologyDrive/.mint/.thunderbird" ]
	then
		cp -frv "$HOME/SynologyDrive/.mint/.thunderbird" "$HOME/"
	fi
fi

echo ; echo "FireFox Download Helper App"
curl -sSLf https://github.com/aclap-dev/vdhcoapp/releases/latest/download/install.sh | bash

popd

# EOF
