#!/usr/bin/env bash

echo ; echo "Install biome"

pushd $HOME

curl -L https://github.com/biomejs/biome/releases/download/@biomejs/biome@2.3.0/biome-linux-x64 -o biome

chmod ugo+rx biome
sudo mv --force biome /usr/bin/

popd

# EOF
