#!/usr/bin/env bash

echo ; echo "Install Nerd Fonts"

pushd $HOME

# if [ ! -d "$HOME/.local/share/fonts/NerdFonts" ]
# then
# 	git clone https://github.com/ryanoasis/nerd-fonts.git
# 	cd nerd-fonts
# 	./install.sh
# 	cd ..
# 	sudo rm -R --force nerd-fonts
# else
# 	echo "Nerd Fonts already installed"
# fi

if [ ! -d "$HOME/.nerd-fonts" ]
then
	git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts .nerd-fonts
fi

cd "$HOME/.nerd-fonts"
git sparse-checkout add patched-fonts/Hack
./install.sh Hack

popd

# EOF
