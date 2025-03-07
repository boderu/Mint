#!/usr/bin/env bash

echo ; echo "Install LazyGit"

pushd $HOME

LAZY_VER=$(	curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \
			grep -Po '"tag_name": "v\K[^"]*' \
		)
URL="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit"
curl -Lo lazygit.tar.gz "${URL}_${LAZY_VER}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
sudo rm -f lazygit.tar.gz
sudo rm -f lazygit

popd

# EOF
