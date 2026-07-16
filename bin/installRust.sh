#!/usr/bin/env bash

echo ; echo "Current Rust and additional (cargo) packages"

pushd $HOME

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
sed -i '/^\. "\$HOME\/.cargo\/env"/d' $HOME/.mint/.bashrc
sed -i '/^\. "\$HOME\/.cargo\/env"/d' $HOME/.mint/.profile

. "$HOME/.cargo/env"

cargo install du-dust
cargo install exa
cargo install eza
cargo install git-graph
cargo install fclones
cargo install typst-cli
#cargo install --locked zellij
cargo install deno --locked

#cargo install --locked yazi-fm yazi-cli
git clone https://github.com/sxyazi/yazi.git
cd yazi
cargo install --path yazi-fm --locked
cd ..
rm -R --force yazi

popd

# EOF
