#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${folder}"/data

dimensioni_province_situas="https://situas-servizi.istat.it/publish/reportspooljson?pfun=63&pdata=01/01/2048"
dimensioni_comuni_situas="https://situas-servizi.istat.it/publish/reportspooljson?pfun=74&pdata=04/11/2051"

# se non non esiste il file lo scarica
if [ ! -f "${folder}"/data/dimensioni_comuni_situas.json ]; then
  curl -kL "${dimensioni_comuni_situas}" -o "${folder}"/data/dimensioni_comuni_situas.json
fi
if [ ! -f "${folder}"/data/dimensioni_province_situas.json ]; then
  curl -kL "${dimensioni_province_situas}" -o "${folder}"/data/dimensioni_province_situas.json
fi

# converte in csv
for i in "${folder}"/data/dimensioni_*.json; do
  nome=$(basename "$i" .json)
  jq -c '.resultset[]' "$i" | mlr -S --ijsonl --ocsv cat > "${folder}"/data/"${nome}".csv
done

# crea join tra comuni e province
duckdb -c "
COPY (
  SELECT c.*, p.DEN_UTS AS PROVINCIA
  FROM read_csv_auto('${folder}/data/dimensioni_comuni_situas.csv') c
  LEFT JOIN read_csv_auto('${folder}/data/dimensioni_province_situas.csv') p
    ON c.COD_PROV_STORICO = p.COD_PROV_STORICO
  ORDER BY c.PRO_COM
) TO '${folder}/data/comuni_con_provincia.csv' (HEADER, DELIMITER ',')
"
