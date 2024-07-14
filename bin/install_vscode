#!/usr/bin/env bash

echo ; echo "Visual Studio Code"

sudo apt install -y --install-recommends dirmngr software-properties-common apt-transport-https curl
if [ ! -e "/usr/share/keyrings/vscode.gpg" ]
then
	curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | \
		sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
fi
if [ ! -e "/etc/apt/sources.list.d/vscode.list" ]
then
	echo deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] \
		https://packages.microsoft.com/repos/vscode stable main | \
		sudo tee /etc/apt/sources.list.d/vscode.list
	sudo apt update
fi
sudo apt install -y --install-recommends code

# EOF
