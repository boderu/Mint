#!/usr/bin/env bash

# Funktion: erzeuge symbolische Links mit erweiterter Prüfung
# $1 Quelle:	Datei oder Verzeichnis welches verlinkt werden soll
# $2 Ziel:		der zu erzeugende symbolische Link
function fncLink
{
	echo
	# Exisitiert das Ziel?
	if [ -e "$2" ]
	then
		# ja, das Ziel existiert
		# ist das Ziel bereits ein symbolischer Link?
		if [ -L "$2" ]
		then
			# ja, das Ziel ist bereits ein symbolischer Link
			echo "$2 ist bereits ein symbolischer Link"

			# zeigt der symbolische Link nicht auf die Quelle?
			if [[ $(readlink "$2") != "$1" ]]
			then
				# ja, der symbolische Link zeigt nicht auf die Quelle
				echo "symbolischer Link $2 zeigt nicht auf die Quelle --> überschreiben"
				# existiert die Quelle?
				if [ -e "$1" ]
				then
					# ja, die Quelle existiert
					rm "$2"					# existierenden Link löschen
					ln -sv "$1" "$2"		# symbolischen Link erzeugen
				else
					# nein, die Quelle existiert nicht
					echo "Die Quelle existiert nicht!"
				fi
			fi
		else
			# nein, das Ziel ist kein symbolischer Link
			# existiert die Quelle?
			if [ -e "$1" ]
			then
				# ja, die Quelle existiert
				echo "$2 ist kein symbolischer Link --> existierende Datei oder Verzeichnis sichern"
				mv -fv "$2" "$2.saved"	# eine existierende Sicherung wird überschrieben
				rm -fRv "$2"			# vorhandene Datei oder Verzeichnis löschen
				ln -sv "$1" "$2"		# symbolischen Link erzeugen
			else
				# nein, die Quelle existiert nicht
				echo "Die Quelle existiert nicht!"
			fi
		fi
	else
		# nein, das Ziel existiert nicht
			# existiert die Quelle?
			if [ -e "$1" ]
			then
				# ja, die Quelle existiert
				rm -fRv "$2"			# vorhandenes Ziel löschen (evtl. fehlerhafter Link)
				ln -sv "$1" "$2"		# symbolischen Link erzeugen
			else
				# nein, die Quelle existiert nicht
				echo "Die Quelle $1 existiert nicht!"
			fi
	fi
} # fncLink()


pushd $HOME

fncLink "$HOME/Mint/.bashrc"								"$HOME/.bashrc"
fncLink "$HOME/Mint/.bash_logout"							"$HOME/.bash_logout"
fncLink "$HOME/Mint/.bash_aliases"							"$HOME/.bash_aliases"
fncLink "$HOME/Mint/.profile"								"$HOME/.profile"
fncLink "$HOME/Mint/.zshrc"									"$HOME/.zshrc"
fncLink "$HOME/Mint/.selected_editor"						"$HOME/.selected_editor"
fncLink "$HOME/Mint/bin"									"$HOME/bin"
fncLink "$HOME/Mint/.ne"									"$HOME/.ne"
fncLink "$HOME/Mint/.config/nemo/actions-tree.json"			"$HOME/.config/nemo/actions-tree.json"
fncLink "$HOME/Mint/.config/broot"							"$HOME/.config/broot"
fncLink "$HOME/Mint/.config/btop"							"$HOME/.config/btop"
fncLink "$HOME/Mint/.config/darktable"						"$HOME/.config/darktable"
fncLink "$HOME/Mint/.config/darktable"						"$HOME/.var/app/org.darktable.Darktable/config/darktable"
fncLink "$HOME/Mint/.config/git-graph"						"$HOME/.config/git-graph"
fncLink "$HOME/Mint/.config/htop"							"$HOME/.config/htop"
fncLink "$HOME/Mint/.config/kicad"							"$HOME/.config/kicad"
fncLink "$HOME/Mint/.config/lazygit"						"$HOME/.config/lazygit"
fncLink "$HOME/Mint/.config/micro"							"$HOME/.config/micro"
fncLink "$HOME/Mint/.config/vlc"							"$HOME/.config/vlc"
#fncLink "$HOME/Mint/.local/share/broot"					"$HOME/.local/share/broot"
fncLink "$HOME/Mint/.local/share/xed"						"$HOME/.local/share/xed"
fncLink "$HOME/Mint/.vuescan"								"$HOME/.vuescan"
fncLink "$HOME/Mint/Templates"								"$HOME/Vorlagen"

#fncLink "$HOME/SynologyDrive/Mint/.config/darktable"		"$HOME/.config/darktable"
#fncLink "$HOME/SynologyDrive/Mint/.config/darktable"		"$HOME/.var/app/org.darktable.Darktable/config/darktable"

fncLink "$HOME/SynologyDrive/Mint/.vuescanrc"				"$HOME/.vuescanrc"
fncLink "$HOME/SynologyDrive/Mint/.ssh"						"$HOME/.ssh"
fncLink "$HOME/SynologyDrive/Mint/.plst"					"$HOME/.plst"
fncLink "$HOME/SynologyDrive/Mint/.gitconfig"				"$HOME/.gitconfig"
fncLink "$HOME/SynologyDrive/Mint/.git-credentials"			"$HOME/.git-credentials"
fncLink "$HOME/SynologyDrive/Mint/.local/share/kicad"		"$HOME/.local/share/kicad"
fncLink "$HOME/SynologyDrive/Mint/.local/share/rhythmbox"	"$HOME/.local/share/rhythmbox"
fncLink "$HOME/SynologyDrive/Mint/.local/share/strawberry"	"$HOME/.local/share/strawberry"
fncLink "$HOME/SynologyDrive/Mint/.local/share/gnome-mines"	"$HOME/.local/share/gnome-mines"
fncLink "$HOME/SynologyDrive/Mint/.local/share/widelands"	"$HOME/.local/share/widelands"
fncLink "$HOME/SynologyDrive/Mint/.local/share/widelands"	"$HOME/.var/app/org.widelands.Widelands/.widelands"
fncLink "$HOME/SynologyDrive/Mint/.local/share/widelands"	"$HOME/.var/app/org.widelands.Widelands/data/widelands"

fncLink 	"$HOME/SynologyDrive/Mint/.local/bin/avr8-gnu-toolchain-linux_x86_64"	\
			"$HOME/.local/bin/avr8-gnu-toolchain-linux_x86_64"

fncLink "$HOME/SynologyDrive/Bilder"						"$HOME/Bilder"
fncLink "$HOME/SynologyDrive/Dokumente"						"$HOME/Dokumente"
fncLink "$HOME/SynologyDrive/Dokumente"						"$HOME/Documents"
fncLink "$HOME/SynologyDrive/Downloads"						"$HOME/Downloads"
fncLink "$HOME/SynologyDrive/Calibre-Bibliothek"			"$HOME/Calibre-Bibliothek"
fncLink "$HOME/SynologyDrive/Musik"							"$HOME/Musik"
#fncLink "$HOME/SynologyDrive/Scans"						"$HOME/Scans"

fncLink "/home/boderu/Nextcloud/Photos"						"$HOME/Photos"

# Autostart-Links nur für User boderu
egrep -i boderu /etc/passwd >/dev/null
if [ $? -eq 0 ]
then
#	fncLink "$HOME/Mint/.config/autostart"					"$HOME/.config/autostart"
	if [ -L "$HOME/Mint/.config/autostart" ]
	then
		rm -rf "$HOME/Mint/.config/_autostart"
		cp -r $("readlink -f $HOME/Mint/.config/autostart") "$HOME/Mint/.config/_autostart"
		rm -rf "$HOME/Mint/.config/autostart"
		mv "$HOME/Mint/.config/_autostart" "$HOME/Mint/.config/autostart"
	fi

	fncLink "$HOME/Mint/.config/cinnamon/spices"			"$HOME/.config/cinnamon/spices"
fi

popd

# EOF
