#!/usr/bin/env bash

echo ; echo "Zellij"

pushd $HOME

case $(uname -m) in
	"x86_64"|"aarch64")
		ARCH=$(uname -m)
	;;
	"arm64")
		ARCH="aarch64"
	;;
	*)
		echo "Unsupported CPU arch: $(uname -m)"
		exit 2
	;;
esac

case $(uname -s) in
	"Linux")
		SYS="unknown-linux-musl"
	;;
	"Darwin")
		SYS="apple-darwin"
	;;
	*)
		echo "Unsupported system: $(uname -s)"
		exit 2
	;;
esac

URL="https://github.com/zellij-org/zellij/releases/latest/download/zellij-$ARCH-$SYS.tar.gz"
curl --location "$URL" | tar -C "$HOME" -xz

if [[ $? -eq 0 ]]
then
	chmod ugo+rx "$HOME/zellij"
	sudo chown root:root "$HOME/zellij"
	sudo mv "$HOME/zellij" "/usr/bin/"
fi

popd

# EOF
