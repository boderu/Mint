#!/usr/bin/env bash

pushd $HOME

echo ; echo "Check out or update frameworks"

if [ -d "$HOME/Frameworks/KiCAD" ]
then
	pushd "$HOME/Frameworks/KiCAD"
	git fetch --all
	git pull
	popd
else
	pushd "$HOME/Frameworks"
	git clone https://github.com/boderu/Framework.KiCAD.git KiCAD
	popd
fi

popd

# EOF
