#!/usr/bin/env bash

echo
echo "Install broot"

curl -o broot -L https://dystroy.org/broot/download/x86_64-linux/broot
sudo mv -f broot /usr/local/bin
sudo chmod +x /usr/local/bin/broot

# (re)install the broot launcher and clean the shell rc files
cat $HOME/.bashrc > $HOME/.bashrc.saved
cat $HOME/.zshrc > $HOME/.zshrc.saved
rm -R --force $HOME/.local/share/broot
broot --install
cat $HOME/.zshrc.saved > $HOME/.zshrc
cat $HOME/.bashrc.saved > $HOME/.bashrc
rm --force $HOME/.bashrc.saved
rm --force $HOME/.zshrc.saved

# EOF
