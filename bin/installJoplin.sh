#!/usr/bin/env bash

echo ; echo "Joplin"

pushd $HOME

wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash

popd

# EOF
