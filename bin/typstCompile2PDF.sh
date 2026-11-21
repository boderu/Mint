#!/usr/bin/env bash
set -u

# Typische Benutzer-Pfade ergänzen (z. B. falls typst via Cargo installiert wurde)
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# 1. Prüfung auf yad
if ! command -v yad >/dev/null 2>&1
then
    if command -v notify-send >/dev/null 2>&1
    then
        notify-send -u critical "Typst-Aktion fehlgeschlagen" "Das Tool 'yad' wurde nicht gefunden."
    fi
    exit 1
fi

# 2. Prüfung auf typst
if ! command -v typst >/dev/null 2>&1
then
    yad --error \
        --title="Fehlendes Werkzeug" \
        --text="Das Tool <b>typst</b> wurde im PATH nicht gefunden.\nBitte Installation oder PATH prüfen." \
        --button="OK:0"
    exit 1
fi

errors=""

# 3. Alle übergebenen Dateien kompilieren
for file in "$@"
do
    # Nur reguläre Dateien verarbeiten
    [[ -f "$file" ]] || continue

    dir=$(dirname "$file")
    base=$(basename "$file" .typ)
    out="$dir/$base.pdf"

    # Kompilieren und Fehlerausgabe (stderr & stdout) abfangen
    if ! output=$(typst compile "$file" "$out" 2>&1)
    then
        errors+="=== Fehler in: $file ===\n$output\n\n"
    fi
done

# 4. Bei Fehlern ein bestätigungspflichtiges Dialogfenster anzeigen
if [[ -n "$errors" ]]
then
    printf "%b" "$errors" | yad --text-info \
        --title="Typst Kompilierungsfehler" \
        --window-icon="dialog-error" \
        --text="<b>Beim Kompilieren sind Fehler aufgetreten:</b>" \
        --wrap \
        --width=750 \
        --height=450 \
        --button="OK:0"
    exit 1
fi

exit 0

# EOF
