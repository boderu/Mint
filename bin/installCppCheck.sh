#!/usr/bin/env bash

function CppCheckInstall
{
	sudo make install MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes \
	CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"
}


echo ; echo "Update CppCheck"

pushd $HOME

sudo apt-get install -y libpcre3-dev
git clone https://github.com/danmar/cppcheck.git
cd cppcheck

# gibt es eine Versionsinformation von einer vorhergehenden Installation?
if [ -f "$HOME/.cppcheck_version" ]
then
	# ja, CppCheck wurde schon einmal installiert
	# hat sich die Version des Repository geändert?
	if [[ $(cat "$HOME/.cppcheck_version") != $(git log --pretty="%H" -n 1) ]]
	then
		# ja, die Versionen sind unterschiedlich --> aktuelle Version merken und CppCheck installieren
		echo "neue CppCheck-Version vorhanden --> Update"
		git log --pretty="%H" -n 1 > "$HOME/.cppcheck_version"
		CppCheckInstall
	else
		echo "CppCheck-Versionen identisch --> keine Installation"
	fi
else
	# nein, CppCheck wurde noch nicht installiert
	echo "installierte CppCheck-Version nicht vorhanden --> neue Installation"
	git log --pretty="%H" -n 1 > "$HOME/.cppcheck_version"
	CppCheckInstall
fi
cd ..
sudo rm -Rf cppcheck
echo "CppCeck Version: $(cppcheck --version)"

popd

# EOF
