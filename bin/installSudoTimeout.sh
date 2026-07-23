#!/usr/bin/env bash

pushd $HOME

RETURN_VALUE=0

echo ; echo "Setup sudo timout"

# Sicherstellen, dass das Skript mit Root-Rechten oder sudo ausgeführt wird
if [ "$(id -u)" -ne 0 ]
then
	echo "Dieses Skript muss mit sudo oder als root ausgeführt werden." >&2
	RETURN_VALUE=1
else
	# -- Konfiguration --
	# Name der Konfigurationsdatei
	CONFIG_FILENAME="custom_timeout"

	# Inhalt der Konfigurationsdatei
	CONFIG_CONTENT="Defaults timestamp_timeout=-1"
	# --- Ende der Konfiguration ---


	# Vollständiger Pfad zur Zieldatei
	TARGET_FILE="/etc/sudoers.d/${CONFIG_FILENAME}"

	# Temporäre Datei für die sichere Erstellung
	TEMP_FILE=$(mktemp)

	# Inhalt in die temporäre Datei schreiben
	echo "${CONFIG_CONTENT}" > "${TEMP_FILE}"

	# Syntax der temporären Datei mit visudo prüfen
	# Die Ausgabe von visudo wird unterdrückt, wir prüfen nur den Exit-Code.
	visudo -c -f "${TEMP_FILE}"
	if [ $? -eq 0 ]; then
		echo "Syntax ist korrekt. Datei wird installiert."

		# Datei an den Zielort verschieben
		mv "${TEMP_FILE}" "${TARGET_FILE}"

		# Korrekte Berechtigungen und Eigentümer setzen
		chmod 0440 "${TARGET_FILE}"
		chown root:root "${TARGET_FILE}"
		echo "Konfiguration erfolgreich unter ${TARGET_FILE} erstellt."
	else
		echo "FEHLER: Die Syntax der Konfiguration ist fehlerhaft. Es wurden keine Änderungen vorgenommen." >&2

		# Temporäre Datei aufräumen
		rm -f "${TEMP_FILE}"
		RETURN_VALUE=1
	fi

	# Wenn mv fehlschlägt, ist die temporäre Datei noch da. Hier sicherheitshalber aufräumen.
	rm -f "${TEMP_FILE}"

fi

popd

exit $RETURN_VALUE

# EOF
