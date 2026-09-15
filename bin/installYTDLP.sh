#!/usr/bin/env bash

echo ; echo "yt-dlp virtual environment"

pushd $HOME

curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
chmod a+rx ~/.local/bin/yt-dlp  # Make executable

popd

# EOF
