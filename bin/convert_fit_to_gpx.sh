#!/bin/env bash

# Geht durch jede Datei, die vom Dateimanager übergeben wurde
for FILE_FIT in "$@"; do
	# Prüft zur Sicherheit, ob es sich um eine .fit-Datei handelt
	if [[ "$FILE_FIT" == *.fit ]]
	then
		# Erstellt den neuen Dateinamen, indem ".fit" durch ".gpx" ersetzt wird
		FILE_GPX="${FILE_FIT%.fit}.gpx"

		# Führt den Konvertierungsbefehl aus
		gpsbabel -i garmin_fit -f "$FILE_FIT" -o gpx -F "$FILE_GPX"
	fi
done

# EOF
