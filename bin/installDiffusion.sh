#!/usr/bin/env bash

pushd $HOME

echo ; echo "Install Easy Diffusion"
if [ ! -d "$HOME/easy-diffusion" ]
then
	wget "https://github.com/cmdr2/stable-diffusion-ui/releases/latest/download/Easy-Diffusion-Linux.zip"
	unzip Easy-Diffusion-Linux.zip
	rm -f Easy-Diffusion-Linux.zip
fi


#echo ; echo "Install Automatic 1111"
#sudo apt install -y --install-recommends libgl1 libglib2.0-0
#wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
#chmod +x webui.sh
#./webui.sh
#rm -fv webui.sh

popd

# EOF
