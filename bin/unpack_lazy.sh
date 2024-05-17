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

# alle Kommandozeilenargumente verarbeiten
for ARG in "$@"
do
	echo $ARG
done

exit $EXITVALUE

# EOF
