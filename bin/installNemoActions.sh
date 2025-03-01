#!/usr/bin/env bash

echo ; echo "Install additional Nemo actions"

# Test, ob das Verzeichnis noch ein Link ist
if [ -L "$HOME/.local/share/nemo" ]
then
	echo "$HOME/.local/share/nemo is still a link --> remove"
	rm -Rv "$HOME/.local/share/nemo"
	mkdir -p "$HOME/.local/share/nemo/actions"
	mkdir -p "$HOME/.local/share/nemo/scripts"
	mkdir -p "$HOME/.local/share/nemo/search-helpers"
fi

pushd "$HOME/.local/share/nemo/actions/"

if [ -e "$HOME/Mint/nemo-actions-download.conf" ]
then
	cat "$HOME/Mint/nemo-actions-download.conf" | grep -v '^#' | grep -v '^$' | \
	while read LINE
	do
		echo "$LINE"
		wget https://cinnamon-spices.linuxmint.com/files/actions/${LINE}.zip && \
		unzip -o ${LINE}.zip
		rm -f ${LINE}.zip
	done
fi

# eigene Nemo Actions verlinken - vorher defekte Links löschen
find -L "$HOME/.local/share/nemo/actions/" -type l -exec rm -f {} \;

ls "$HOME/Mint/NemoActions" |
while read FILE
do
	echo $FILE
	# sollte bereits ein Link oder eine Datei existieren -> löschen
	if [ -e "$HOME/.local/share/nemo/actions/${FILE}" ]
	then
		rm -fv "$HOME/.local/share/nemo/actions/${FILE}"
	fi

	# Link (neu) erstellen
	echo "Link $FILE"
	ln -s "$HOME/Mint/NemoActions/${FILE}" "$HOME/.local/share/nemo/actions/${FILE}"
	echo
done

popd

# EOF
