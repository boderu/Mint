#!/usr/bin/env bash

echo ; echo "Install local AI (ollama)"

if ollama --version
then
	echo "ollama has already been installed."
else
	curl -fsSL https://ollama.com/install.sh | sh
fi

# EOF
