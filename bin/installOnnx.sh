#!/usr/bin/env bash

echo ; echo "Onnx AI"

pushd $HOME

# Stellt sicher, dass das Skript bei einem Fehler abbricht
set -e
set -o pipefail

# --- Konfiguration ---
OWNER="microsoft"
REPO="onnxruntime"
# KORRIGIERTES MUSTER: Stellt sicher, dass nach "x64-" eine Ziffer folgt.
# Das schließt die "-gpu_..." Versionen aus.
ASSET_PATTERN='onnxruntime-linux-x64-[0-9].*\.tgz$'

# --- Überprüfung der Abhängigkeiten ---
if ! command -v curl &> /dev/null; then
    echo "FEHLER: 'curl' ist nicht installiert. Bitte installieren Sie es (z.B. 'sudo apt install curl')."
    exit 1
fi
if ! command -v jq &> /dev/null; then
    echo "FEHLER: 'jq' ist nicht installiert. Bitte installieren Sie es (z.B. 'sudo apt install jq')."
    exit 1
fi

# --- Hauptlogik ---
echo "Suche nach der neuesten Version von ${OWNER}/${REPO}..."

# GitHub-API aufrufen, um die Download-URL der neuesten Version zu erhalten
API_URL="https://api.github.com/repos/${OWNER}/${REPO}/releases/latest"

# Das Muster wird sicher als Variable an jq übergeben
DOWNLOAD_URL=$(curl -s "$API_URL" | jq --arg pattern "$ASSET_PATTERN" -r '.assets[] | select(.name | test($pattern)) | .browser_download_url')

if [ -z "$DOWNLOAD_URL" ]; then
    echo "FEHLER: Konnte keine passende Download-URL für das Muster '${ASSET_PATTERN}' finden."
    exit 1
fi

# Sicherheitsprüfung: Stellen Sie sicher, dass nur eine URL gefunden wurde
if [ $(echo "$DOWNLOAD_URL" | wc -l) -ne 1 ]; then
    echo "FEHLER: Mehrere passende URLs gefunden. Das Skript wird beendet, um Fehler zu vermeiden."
    echo "$DOWNLOAD_URL"
    exit 1
fi

FILENAME=$(basename "$DOWNLOAD_URL")
# Entfernt die .tgz Endung, um den Verzeichnisnamen zu erhalten
DIRNAME="${FILENAME%.tgz}" 

echo "Neueste Version gefunden: ${DIRNAME}"
echo "Download-URL: ${DOWNLOAD_URL}"

# In ein temporäres Verzeichnis wechseln, um alles sauber zu halten
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "Wechsle in das temporäre Verzeichnis: ${TEMP_DIR}"

echo "Lade ${FILENAME} herunter..."
curl -L -o "$FILENAME" "$DOWNLOAD_URL"

echo "Datei wird entpackt..."
tar -xzvf "$FILENAME"

echo "Installiere Header- und Bibliotheksdateien nach /usr/local/..."
# Wechseln in das richtige, entpackte Verzeichnis
cd "$DIRNAME"
sudo cp -r include/* /usr/local/include/
sudo cp -r lib/* /usr/local/lib/

echo "Aktualisiere den System-Bibliotheks-Cache..."
sudo ldconfig

# Aufräumen
echo "Räume temporäres Verzeichnis auf..."
cd /
rm -rf "$TEMP_DIR"

echo "ONNX Runtime wurde erfolgreich installiert!"

popd

# EOF
