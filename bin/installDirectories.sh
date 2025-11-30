#!/usr/bin/env bash

echo "Create some directories"

pushd $HOME

mkdir -pv "$HOME/.config"
mkdir -pv "$HOME/.config/nemo"
mkdir -pv "$HOME/.local/share/fonts"
mkdir -pv "$HOME/.local/bin"
mkdir -pv "$HOME/Media/Stable Diffusion"
mkdir -pv "$HOME/Media/Assetts"
mkdir -pv "$HOME/Media/YouTube/VLogs"
mkdir -pv "$HOME/Scans"
mkdir -pv "$HOME/Warpinator"
mkdir -pv "$HOME/Frameworks"
mkdir -pv "$HOME/dwhelper"
mkdir -pv "$HOME/WsCCS"
mkdir -pv "$HOME/WsEclipse"
mkdir -pv "$HOME/WsFreeCAD"
mkdir -pv "$HOME/WsKiCAD"
mkdir -pv "$HOME/WsXilinx"
mkdir -pv "$HOME/WsXilinxSDK"
mkdir -pv "$HOME/WsVSCode"

touch "$HOME/.sudo_as_admin_successful"

popd

# EOF
