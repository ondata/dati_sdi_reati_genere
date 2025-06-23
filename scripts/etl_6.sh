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
mlr --csv uniq -a then remove-empty-columns then skip-trivial-records then clean-whitespace "${folder}"/tmp/"${file}".csv >"${folder}"/../data/processing/"${file}"/"${file}".csv

# Impostare stato a Italia, quando regione è valorizzato
mlr -I --csv --from "${folder}"/../data/processing/"${file}"/"${file}".csv put 'if($regione =~ ".+") { $stato="ITALIA" } else { $stato = $stato }'

# elaborazione codici geografici italiani

# correggi nomi province
while read -r line; do
  # Estrae il nome originale e quello corretto dal file JSONL
  nome=$(jq -r '.nome' <<<"${line}")
  nome_corretto=$(jq -r '.nome_corretto' <<<"${line}")

  # Sostituisce il nome errato con quello corretto nel campo 'provinciauts_corretto'
  mlr -I --csv sub -f provincia "^${nome}$" "${nome_corretto}" "${folder}"/../data/processing/"${file}"/"${file}".csv
done <"${folder}"/../resources/problemi_nomi_province.jsonl

# correggi nomi comuni
while read -r line; do
  # Estrae il nome originale e quello corretto dal file JSONL
  nome=$(jq -r '.nome' <<<"${line}")
  nome_corretto=$(jq -r '.nome_corretto' <<<"${line}")

  # Sostituisce il nome errato con quello corretto nel campo 'provinciauts_corretto'
  mlr -I --csv sub -f comune "^${nome}$" "${nome_corretto}" "${folder}"/../data/processing/"${file}"/"${file}".csv
done <"${folder}"/../resources/problemi_nomi_comuni.jsonl

# correggi province Sardegna
while read -r line; do
  # Estrae il nome originale e quello corretto dal file JSONL
  provincia=$(jq -r '.provincia' <<<"${line}")
  comune=$(jq -r '.comune' <<<"${line}")
  provincia_corretta=$(jq -r '.provincia_corretta' <<<"${line}")

  # Sostituisce il nome errato con quello corretto nel campo 'provinciauts_corretto'
  mlr -I --csv put 'if ($provincia=="'"$provincia"'" && $comune=="'"$comune"'") {$provincia="'"$provincia_corretta"'"} else {$provincia=$provincia}' "${folder}"/../data/processing/"${file}"/"${file}".csv
done <"${folder}"/../resources/problemi_province_sardegna.jsonl

mlr --csv cut -f regione,provincia,comune then uniq -a then sort -t regione,provincia,comune then skip-trivial-records "${folder}"/../data/processing/"${file}"/"${file}".csv >"${folder}"/tmp/"${file}"_geo.csv

mlr --csv cut -f regione then uniq -a then skip-trivial-records then sort -t regione "${folder}"/tmp/"${file}"_geo.csv >"${folder}"/tmp/"${file}"_geo_regione.csv

mlr --csv cut -f regione,codice_regione then uniq -a then skip-trivial-records then sort -t regione,codice_regione "${folder}"/../resources/unita_territoriali_istat.csv >"${folder}"/tmp/"${file}"_istat_regione.csv

mlr --csv cut -o -f provincia then uniq -a then skip-trivial-records then sort -t provincia "${folder}"/tmp/"${file}"_geo.csv >"${folder}"/tmp/"${file}"_geo_provincia.csv

mlr --csv cut -o -f provinciauts,codice_provincia_storico,codice_provinciauts then uniq -a then skip-trivial-records then sort -t provinciauts,codice_provincia_storico,codice_provinciauts "${folder}"/../resources/unita_territoriali_istat.csv >"${folder}"/tmp/"${file}"_istat_provincia.csv

mlr --csv cut -o -f provincia,comune then uniq -a then skip-trivial-records then sort -t provincia,comune then filter -x 'is_null($comune)' "${folder}"/tmp/"${file}"_geo.csv >"${folder}"/tmp/"${file}"_geo_comune.csv


mlr --csv cut -o -f provinciauts,comune_dizione_italiana,codice_comune_alfanumerico  then uniq -a then skip-trivial-records then sort -t provinciauts,comune_dizione_italiana,codice_comune_alfanumerico then rename provinciauts,provincia,comune_dizione_italiana,comune "${folder}"/../resources/unita_territoriali_istat.csv >"${folder}"/tmp/"${file}"_istat_comune.csv

csvmatch "${folder}"/tmp/reati_sdi_geo_comune.csv "${folder}"/tmp/reati_sdi_istat_comune.csv --fields1 provincia comune --fields2 provincia comune --fuzzy levenshtein -r 0.9 -i -a -n --join left-outer --output '1*' 2."codice_comune_alfanumerico" >"${folder}"/tmp/"${file}"_codici_comuni.csv

### aggiungi i codici istat comunali

mlr --csv join --ul -j provincia,comune -f "${folder}"/../data/processing/"${file}"/"${file}".csv then unsparsify then sort -t stato,regione,provincia,comune then reorder -f stato,regione,provincia,comune "${folder}"/tmp/"${file}"_codici_comuni.csv > "${folder}"/tmp/tmp.csv

mv "${folder}"/tmp/tmp.csv "${folder}"/../data/processing/"${file}"/"${file}".csv
