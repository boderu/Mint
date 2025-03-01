#!/usr/bin/env bash

echo ; echo "DrawIO"

pushd $HOME

curl -s https://api.github.com/repos/jgraph/drawio-desktop/releases/latest | \
	grep browser_download_url | \
	grep '\.deb' | \
	cut -d '"' -f 4 | \
	wget -i -
sudo apt -f install ./drawio-amd64*.deb
rm -fv ./drawio*.deb

popd

# EOF
