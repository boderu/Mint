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
#cargo install --locked zellij
cargo install --locked yazi-fm yazi-cli

popd

# EOF
