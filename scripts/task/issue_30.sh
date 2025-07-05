#!/bin/bash

# Script per elaborare dati sui reati e creare rapporti comparativi tra reati commessi e vittime femminili
# Elabora tre categorie di dati: delitti generali, reati del codice rosso e reati spia
#
# Dipendenze:
# - mlr (Miller) per l'elaborazione dei file CSV

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Creazione delle cartelle di lavoro
mkdir -p "${folder}"/tmp
mkdir -p "${folder}"/../../data/processing/rapporto_commessi_vittime_femminili

# Mappa delle coppie di file da elaborare: file_commessi -> file_vittime
declare -A fogli=(
  ["delitti_commessi"]="delitti_vittime"
  ["codice_rosso_commessi"]="codice_rosso_vittime"
  ["reati_spia_commessi"]="reati_spia_vittime"
)

# Elabora ciascuna coppia di file (commessi/vittime) per le tre categorie di reati
for chiave in "${!fogli[@]}"; do
  valore="${fogli[${chiave}]}"
  echo "Fogli: ${chiave} -> ${valore}"

  # Estrae il nome base del file rimuovendo "_commessi" per creare il nome file di output
  name=$(echo "${chiave}" | sed 's/_commessi//;')

  # Elabora i dati dei reati commessi:
  # - Rinomina la colonna descrizione_reato in delitto
  # - Filtra le righe senza codice provincia
  # - Raggruppa per anno/provincia/delitto e calcola la somma
  # - Ordina i risultati
  # - Mantiene solo valori > 0
  # - Rinomina la colonna somma aggiungendo suffisso "_commessi"
  mlr --csv rename descrizione_reato,delitto then filter -x 'is_null($codice_provinciauts)' then stats1 -a sum -f valore -g anno,codice_provinciauts,delitto then sort -t anno,codice_provinciauts,delitto then filter '$valore_sum > 0' then rename -r '"^(.+)(_sum)$",\1_commessi' "${folder}"/../../data/processing/comunicazioni_sdi/${chiave}.csv > "${folder}"/tmp/"${chiave}".csv

  # Elabora i dati delle vittime femminili con la stessa logica ma rinomina la somma in "_vittime"
  mlr --csv rename descrizione_reato,delitto then filter -x 'is_null($codice_provinciauts)' then stats1 -a sum -f valore -g anno,codice_provinciauts,delitto then sort -t anno,codice_provinciauts,delitto then filter '$valore_sum > 0' then rename -r '"^(.+)(_sum)$",\1_vittime' "${folder}"/../../data/processing/comunicazioni_sdi/${valore}.csv > "${folder}"/tmp/"${valore}".csv

  # Unisce i due dataset tramite join sulle chiavi comune (anno, provincia, delitto)
  # - Applica unsparsify per riempire valori mancanti
  # - Ordina il risultato finale
  # - Salva il file combinato nella cartella di output
  mlr --csv join -j anno,codice_provinciauts,delitto -f "${folder}"/tmp/"${chiave}".csv then unsparsify then sort -t anno,codice_provinciauts,delitto "${folder}"/tmp/"${valore}".csv >"${folder}"/../../data/processing/rapporto_commessi_vittime_femminili/"${name}".csv

done
