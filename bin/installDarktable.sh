#!/usr/bin/env bash

echo ; echo "Darktable with AI"

pushd $HOME

# remove local repository
rm -rf darktable

# get darktable source
git clone --depth 1 https://github.com/darktable-org/darktable.git  
cd darktable  
git config submodule.src/tests/integration.update none

git clean -d -f -x
git pull
git submodule update --init --recursive

# remove old installation
sudo rm -f /usr/share/applications/org.darktable.darktable.desktop
sudo rm -rf /opt/darktable

# build and install darktable
./build.sh –-prefix /opt/darktable –-build-type Release –-install –-enable-ai --sudo
sudo cmake --build "./build" --target install -- -j8

# create a menu entry for the desktop
sudo ln -s	/opt/darktable/share/applications/org.darktable.darktable.desktop \
			/usr/share/applications/org.darktable.darktable.desktop

# installation done - remove local repository
cd ..
rm -rf darktable

# get new lens data
sudo lensfun-update-data

popd

# EOF
