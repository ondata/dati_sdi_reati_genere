#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${folder}"/tmp
mkdir -p "${folder}"/../../data/processing/rapporto_commessi_vittime_femminili


declare -A fogli=(
  ["delitti_commessi"]="delitti_vittime"
  ["codice_rosso_commessi"]="codice_rosso_vittime"
  ["reati_spia_commessi"]="reati_spia_vittime"
)

for chiave in "${!fogli[@]}"; do
  valore="${fogli[${chiave}]}"
  echo "Fogli: ${chiave} -> ${valore}"

  name=$(echo "${chiave}" | sed 's/_commessi//;')

  mlr --csv rename descrizione_reato,delitto then filter -x 'is_null($codice_provinciauts)' then stats1 -a sum -f valore -g anno,codice_provinciauts,delitto then sort -t anno,codice_provinciauts,delitto then filter '$valore_sum > 0' then rename -r '"^(.+)(_sum)$",\1_commessi' "${folder}"/../../data/processing/comunicazioni_sdi/${chiave}.csv > "${folder}"/tmp/"${chiave}".csv

  mlr --csv rename descrizione_reato,delitto then filter -x 'is_null($codice_provinciauts)' then stats1 -a sum -f valore -g anno,codice_provinciauts,delitto then sort -t anno,codice_provinciauts,delitto then filter '$valore_sum > 0' then rename -r '"^(.+)(_sum)$",\1_vittime' "${folder}"/../../data/processing/comunicazioni_sdi/${valore}.csv > "${folder}"/tmp/"${valore}".csv

  mlr --csv join -j anno,codice_provinciauts,delitto -f "${folder}"/tmp/"${chiave}".csv then unsparsify then sort -t anno,codice_provinciauts,delitto "${folder}"/tmp/"${valore}".csv >"${folder}"/../../data/processing/rapporto_commessi_vittime_femminili/"${name}".csv

done
