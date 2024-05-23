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

CNT=1	# Zähler zur Berechnung des Fortschritts

for ARG in "$@"
do
	let PROGRESS=$CNT*100/$#

	ARG_EXTENSION=${ARG##*.}

	echo $PROGRESS
#	echo "$(7z t $ARG -y)"
	echo -n "# $(basename $ARG)"
	echo " $ARG_EXTENSION"

	let CNT=CNT+1
	sleep 2
done | yad	--progress \
			--enable-log="Log" \
			--text="Extract archives" \
			--width=600 \
			--log-height=100 \
			--button=gtk-cancel \
			--log-expanded \
			--auto-close

#read -p "press Enter ..."

exit $EXITVALUE

# EOF
