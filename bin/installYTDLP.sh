#!/usr/bin/env bash

echo ; echo "yt-dlp virtual environment"

pushd $HOME

if [ ! -d "$HOME/.yt-dlp" ]
then
	python3 -m venv "$HOME/.yt-dlp"
fi

source "$HOME/.yt-dlp/bin/activate"

pip install -U yt-dlp
pip install -U yt-dlp-ejs

popd

# EOF
