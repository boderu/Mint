#!/usr/bin/env bash

echo ; echo "Install micro"

pushd $HOME

git clone https://github.com/zyedidia/micro
cd micro
make build
sudo mv micro /usr/bin/
cd ..
sudo rm -R --force micro

popd

# EOF
