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

PLST="$HOME/.plst"

rm --force "$HOME/trash.list"
cat "$PLST" > "${PLST}.bckp"

# remove double passwords
sort -u "$PLST" > "${PLST}.work"
if [ $(cat "$PLST" | wc --lines) -ne $(cat "${PLST}.work" | wc --lines) ]
then
	cat "${PLST}.work" > "$PLST"
fi

CNTARCHIVES=0
CNTSUCCESS=0
CNTFAILED=0

# process all archives
for ARG in "$@"
do
	DIRARG=$(dirname "$ARG")
	let CNTARCHIVES=CNTARCHIVES+1
	SUCCESS=0

	echo "Archive:   $ARG"
	echo "Directory: $DIRARG"

	# try to extract without password
	if [[ $(7z l -p"" "$ARG" 2>&1 | grep --count "ERROR") == 0 ]]
	then
		# yes, this archive does not require a password
		echo -e "\tSuccess (no password)"

		# extract archive
		if 7z x -o"$DIRARG" -y "$ARG"
		then
			echo "$ARG" >> "$HOME/trash.list"
		fi

		let CNTSUCCESS=CNTSUCCESS+1
		SUCCESS=1
	else
		# no, this archive reqires a password
		LINEPLST=1
		while IFS= read -r PW
		do
			# does the password match?
			if [[ $(7z l -p"$PW" "$ARG" 2>&1 | grep --count "ERROR") == 0 ]]
			then
				# yes, the password has been found
				echo -e "\tSuccess ($LINEPLST): $PW"

				# extract archive
				if 7z x -p"$PW" -o"$DIRARG" -y "$ARG"
				then
					echo "$ARG" >> "$HOME/trash.list"
				fi

				# set the found password on top of the password list
				echo "$PW" > "${PLST}.work"
				sed "${LINEPLST}d" "$PLST" >> "${PLST}.work"
				cat "${PLST}.work" > "$PLST"

				let CNTSUCCESS=CNTSUCCESS+1
				SUCCESS=1
				break
			else
				# no, thw password does not match
				echo -e "\tFailed ($LINEPLST): $PW"
			fi

			let LINEPLST=LINEPLST+1

		done < <(cat "$PLST" | tr -d '\r')
	fi # if test without password

	if [[ $SUCCESS == 0 ]]
	then
		let CNTFAILED=CNTFAILED+1
		EXITVALUE=1
	fi

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

echo ; echo
echo "Summary:"
echo -e "\tArchives: $CNTARCHIVES"
echo -e "\tSuccess:  $CNTSUCCESS"
echo -e "\tFailed:   $CNTFAILED"

read -p "press Enter ..."

exit $EXITVALUE

# EOF
