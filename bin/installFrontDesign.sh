#!/usr/bin/env bash

echo ; echo "Frontplattendesigner"

pushd $HOME

curl -s --insecure https://www.schaeffer-ag.de/frontplatten-designer#download | \
	grep -E -o 'https[^[:blank:]]*-amd64\.deb' | \
	sort -V | \
	tail --lines=1 | \
	wget -i -
sudo apt -f install ./FrontDesign*amd64.deb
rm -fv ./FrontDesign*amd64.deb

popd

# EOF
