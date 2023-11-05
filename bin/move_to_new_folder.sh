#!/bin/bash
# 120 chars/line utf-8 #################################################################################################
# Dieses Skript verschiebt die in den Argumenten angegebenen Dateien/Verzeichnisse in ein neues Verzeichnis.
# Der Name des neuen Verzeichnisses wird über einen Dialog angezeigt und abgefragt. Das Elternverzeichnis des neuen
# Verzeichnisses ist dabeidas Elternverzeichnis des ersten Arguments.
#
# Aufruf:			move_to_new_folder.sh FileOrDirToMove {FileOrDirToMove ...}
#
# Exit-Codes:		0:	Skript war erfolgreich
#					1:	Anzahl der Argumente war zu gering
#					2:	Das erste Argument ist keine Datei oder Verzeichnis
#					3:	Das Zielverzeichnis konnte nicht erstellt werden
#					4:	Das Zielverzeichnis existiert bereits
#					5:	Abbruch durch Anwender
#
# Abhängigkeiten:	yad
#
########################################################################################################################

# Prüfung der Argumente
# gibt es mindestens zwei Argumente?
if [ $# -ge 2 ]
then
	# ja, die Anzahl der Argumente ist für das Skript ausreichend
	# ist das erste Argument eine Datei oder Verzeichnis?
	if [ -e "$1" ]
	then
		# ja, das erste Argument ist eine Datei oder ein Verzeichnis
		# das Verzeichnis der ersten Datei ist das Elternverzeichnis für das neue Verzeichnis
		DIR_PARENT=$(dirname "$1")

		# Name für einen neues leeres Verzeichnis ermitteln
		DIR_NEW="New Folder"

		# existiert ein neuer Ordner mir dem Namen bereits?
		if [ -d "$DIR_PARENT/$DIR_NEW" ]
		then
			# ja, ein Verzeichnis mit diesem Namen existiert bereits
			echo "$DIR_PARENT/$DIR_NEW exists --> looking for a new name" ;

			# einen Index zum Verzeichnisnamen hinzufügen
			for IDX in {0..666}
			do
				# gibt es das Vezeichnis mit diesem Index bereits?
				if [ -d "$DIR_PARENT/$DIR_NEW $IDX" ]
				then
					# ja, ein Verzeichnis mit diesem Index gibt es bereits --> weitersuchen
					echo "$DIR_PARENT/$DIR_NEW $IDX exists"
				else
					# nein, ein Verzeichnis mit diesem Index gibt es noch nicht
					# --> Verzeichnis erstellen und Schleife verlassen
					DIR_NEW="$DIR_NEW $IDX"

					echo "$DIR_PARENT/$DIR_NEW"
					break
				fi
			done
		fi
	else
		# nein, das erste Argument ist keine Datei oder Verzeichnis
		echo "The first argument $1 is not a file or directory!"
		exit 2
	fi
else
	# nein, die Anzahl der Argumente reicht für dieses Skrikt nicht aus
	echo "The number of arguments is not sufficient for this script!"
	exit 1
fi


# dem User über yad das ermittelte Verzeichnis anbieten und Änderungen übernehmen
DIR_NEW=$(yad --title="Select a new directory!" --entry --directory --entry-text="$DIR_NEW" --width=300)

# Dialog abgebrochen?
if [ $? -ne 0 ]
then
	# ja, der Dialog wurde vom Anwender abgebrochen
	exit 5
else
	# nein, kein Abbruch durch den Anwender
	# gibt es das Verzeichnis schon?
	if [ -d "$DIR_PARENT/$DIR_NEW" ]
	then
		# ja, das Verzeichis exitsiert schon
		echo "The directory $DIR_PARENT/$DIR_NEW already exists!"
		yad	--center \
			--title="Directory already exists!" \
			--timeout=2 \
			--timeout-indicator=bottom \
			--width=400 \
			--button=gtk-cancel \
			--auto-kill \
			--auto-close
		exit 4
	else
		# nein, das Verzeichnis existiert noch nicht
		# Versuch das Verzeichnis zu erzeugen
		if mkdir -pv "$DIR_PARENT/$DIR_NEW"
		then
			# das Verzeichnis wurde erfolgreich erzeugt --> Dateien verschieben
			CNT_LOOP=1
			for FILE in "$@"
			{
				echo $(( $CNT_LOOP * 100 / $# ))	# der Fortschritt wird mit Zahlen 1..100 angegeben
				echo "#$FILE"						# die Ausgabe im Dialog
				mv --verbose --no-clobber "$FILE" "$DIR_PARENT/$DIR_NEW"
				CNT_LOOP=$(( $CNT_LOOP + 1 ))
			} | yad --progress --center --title="Move files..." --button=gtk-cancel --auto-kill --auto-close
		else
			echo "Failed to create $DIR_PARENT/$DIR_NEW!"
			yad	--center \
				--title="Directory could not be created!" \
				--timeout=2 \
				--timeout-indicator=bottom \
				--width=400 \
				--button=gtk-cancel \
				--auto-kill \
				--auto-close
			exit 3
		fi
	fi
fi

exit 0

# EOF
