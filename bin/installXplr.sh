#!/usr/bin/env bash

echo ; echo "Install xplr"

pushd $HOME

PLATFORM="linux"  # or "macos" / "linux-musl"
wget https://github.com/sayanarijit/xplr/releases/latest/download/xplr-${PLATFORM}.tar.gz
tar xzvf xplr-${PLATFORM}.tar.gz
sudo mv --force xplr /usr/local/bin/
rm --force xplr-${PLATFORM}.tar.gz

popd

# EOF
