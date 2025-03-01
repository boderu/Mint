#!/usr/bin/env bash

echo ; echo "VueScan"

pushd $HOME

FILE_VUESCAN=$( \
				curl -s https://www.hamrick.com/alternate-versions.html | \
				grep -o '"files/vuex64.*\.deb' | \
				sed 's/"files\///g' \
			)
wget https://www.hamrick.com/files/${FILE_VUESCAN}
if [ -f "$FILE_VUESCAN" ]
then
	sudo apt install -y "./$FILE_VUESCAN"
	rm -f "$FILE_VUESCAN"
fi

popd

# EOF
