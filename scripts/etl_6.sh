#!/bin/bash

# Script ETL per l'elaborazione dei dati SDI sui reati di genere
# Estrae e trasforma i dati da file Excel in formato CSV normalizzato

set -x
set -e
set -u
set -o pipefail

# Ottiene il percorso assoluto della directory dello script
folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Crea le directory di lavoro necessarie
mkdir -p "${folder}"/../data/processing
mkdir -p "${folder}"/tmp

# Verifica che tutti i comandi necessari siano installati
for cmd in jq qsv mlr duckdb csvmatch; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Errore: il comando '${cmd}' non è installato. Installalo prima di eseguire lo script." >&2
    exit 1
  fi
done

file="reati_sdi"

mkdir -p "${folder}"/../data/processing/"${file}"

# Estrae il foglio specifico in formato CSV
qsv excel -Q --sheet 0 "${folder}"/../data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx >"${folder}"/tmp/"${file}".csv

# rimuovi la stringa (null) con sed
sed -i 's/(null)//g' "${folder}"/tmp/"${file}".csv
# porta in lowercase soltanto la prima riga con sed
sed -i '1s/.*/\L&/' "${folder}"/tmp/"${file}".csv

# rimuovi evetuali duplicati, righe vuote e colonne vuote, spazi bianchi inutili
mlr --csv uniq -a then remove-empty-columns then skip-trivial-records then clean-whitespace "${folder}"/tmp/"${file}".csv > "${folder}"/../data/processing/"${file}"/"${file}".csv
