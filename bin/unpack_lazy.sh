#!/usr/bin/env bash
# 120 chars/line utf-8 #################################################################################################
# Dieses Skript entpackt die in den Argumenten angegebenen Archive in das Verzeichnis der Archive. Nach dem Entpacken
# wird das Archivs in den Mülleimer verschoben. Bei verschlüsselten Archiven wird mit Hilfe einer Passwortliste
# versucht die Entschlüsselung durchzuführen.
# Der Name des gerade verarbeiteten Archivs wird über einen Dialog angezeigt.
#
# Aufruf:			unpack_lazy.sh Archiv {Archiv ...}
#
# Exit-Codes:		0:	Skript war erfolgreich
#
# Abhängigkeiten:	yad
#
########################################################################################################################

EXITVALUE=0

#CNT=1	# Zähler zur Berechnung des Fortschritts
#
#for ARG in "$@"
#do
#	let PROGRESS=$CNT*100/$#
#
#	ARG_EXTENSION=${ARG##*.}
#
#	echo $PROGRESS
#	echo "$(7z t $ARG -y)"
#	echo -n "# $(basename $ARG)"
#	echo " $ARG_EXTENSION"
#
#	let CNT=CNT+1
#	sleep 2
#done | yad	--progress \
#			--enable-log="Log" \
#			--text="Extract archives" \
#			--width=600 \
#			--log-height=100 \
#			--button=gtk-cancel \
#			--log-expanded \
#			--auto-close

PLST="$HOME/.plst"


rm --force "$HOME/trash.list"
cat "$PLST" > "${PLST}.bckp"

# remove double lines
sort -u "$PLST" > "${PLST}.work"
if [ $(cat "$PLST" | wc --lines) -ne $(cat "${PLST}.work" | wc --lines) ]
then
	cat "${PLST}.work" > "$PLST"
fi

# process all archives
for ARG in "$@"
do
	DIRARG=$(dirname "$ARG")

	echo "Archive:   $ARG"
	echo "Directory: $DIRARG"

	# try to extract without password
	if [[ $(7z l -p"" "$ARG" 2>&1 | grep --count "ERROR") == 0 ]]
	then
		# yes, this archive does not reqire a password
		echo -e "\tSuccess (no password)"

		# extract archive
		if 7z x -o"$DIRARG" -y "$ARG"
		then
			echo "$ARG" >> "$HOME/trash.list"
		fi
	else
		# no, this archive reqires a password
		LINEPLST=1
		cat "$PLST" | tr -d '\r' | \
		while IFS= read -r PW
		do
			# does the password match?
			if [[ $(7z l -p"$PW" "$ARG" 2>&1 | grep --count "ERROR") == 0 ]]
			then
				# yes, the password has been found
				echo -e "\tSuccess ($LINEPLST): $PW"
	#			echo "7z x -p\"$PW\" -o\"$OUTDIR\" -y \"$1\""

				# extract archive
				if 7z x -p"$PW" -o"$DIRARG" -y "$ARG"
				then
					echo "$ARG" >> "$HOME/trash.list"
				fi

				# set the found password on top of the password list
				echo "$PW" > "${PLST}.work"
				sed "${LINEPLST}d" "$PLST" >> "${PLST}.work"
				cat "${PLST}.work" > "$PLST"

				break
			else
				# no, thw password does not match
				echo -e "\tFailed ($LINEPLST): $PW"
			fi

			let LINEPLST=LINEPLST+1

		done # while passwords
	fi # if test without password

	echo ; echo

done # all archives

# put all processed archives into trash
if [ -e "$HOME/trash.list" ]
then
	while IFS= read -r FILE2TRASH
	do
		trash -v -- "$FILE2TRASH"
	done < "$HOME/trash.list"
fi

# remove all temporary files
rm -v --force "$HOME/trash.list"
rm -v --force "${PLST}.work"

read -p "press Enter ..."

exit $EXITVALUE

# EOF
