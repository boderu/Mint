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

PASSWORDLIST="/home/boderu/UE/pwp.txt"

if [ -e "${PASSWORDLIST}.bckp" ]
then
	rm --force "${PASSWORDLIST}.bckp"
fi

if [ -e "${PASSWORDLIST}.work" ]
then
	rm --force "${PASSWORDLIST}.work"
fi

cp "$PASSWORDLIST" "${PASSWORDLIST}.bckp"

rm --force "$HOME/trash.list"

for ARG in "$@"
do
	OUTDIR=$(dirname "$ARG")

	echo "Archive: $ARG"
	echo "Outdir: $OUTDIR"

	PWLSTLINE=1
	cat "$PASSWORDLIST" | tr -d '\r' | \
	while IFS= read -r PW
	do 
		if [[ $(7z l -p"$PW" "$1" 2>&1 | grep --count "ERROR") == 0 ]]
		then
			echo -e "\tSuccess ($PWLSTLINE): $PW"
#			echo "7z x -p\"$PW\" -o\"$OUTDIR\" -y \"$1\""
			if 7z x -p"$PW" -o"$OUTDIR" -y "$ARG"
			then
				echo "$ARG" >> "$HOME/trash.list"
			fi

			echo "$PW" > "${PASSWORDLIST}.work"
			sed "${PWLSTLINE}d" "$PASSWORDLIST" >> "${PASSWORDLIST}.work"
			rm --force "$PASSWORDLIST"
			cp "${PASSWORDLIST}.work" "$PASSWORDLIST"

			break
		else
			echo -e "\tFailed ($PWLSTLINE):  $PW"
		fi
		let PWLSTLINE=PWLSTLINE+1
	done

	echo ; echo
done

while IFS= read -r FILE2TRASH
do
	trash -v -- "$FILE2TRASH"
done < "$HOME/trash.list"

read -p "press Enter ..."

exit $EXITVALUE

# EOF
