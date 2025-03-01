#!/usr/bin/env bash

echo ; echo  "Install command-line fuzzy finder (fzf)"

pushd $HOME

if [ ! -d "$HOME/.fzf" ]
then
	echo "Install command-line fuzzy finder:"
	sudo apt install -y --install-recommends git
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all
else
	echo "Update command-line fuzzy finder:"
	pushd "$HOME/.fzf"
	git pull && ./install --all
	popd
fi

popd

# EOF
