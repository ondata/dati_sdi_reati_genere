#!/bin/bash

# Script ETL per l'elaborazione dei dati SDI sui reati di genere
# Estrae e trasforma i dati da file Excel in formato CSV normalizzato

#set -x
set -e
set -u
set -o pipefail

# Ottiene il percorso assoluto della directory dello script
folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Crea le directory di lavoro necessarie
mkdir -p "${folder}/../data/processing"
mkdir -p "${folder}/tmp"

# Verifica che tutti i comandi necessari siano installati
for cmd in jq qsv mlr duckdb; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "Errore: il comando '${cmd}' non è installato. Installalo prima di eseguire lo script." >&2
    exit 1
  fi
done

file="comunicazioni_sdi"

mkdir -p "${folder}"/../data/processing/"${file}"

# ===== FASE 1: ESTRAZIONE DEI DATI DAL FILE EXCEL =====
# Estrae i metadati dei fogli Excel e li salva in formato JSONL
qsv excel --metadata json "${folder}"/../data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx | jq -c '.sheet[]' >"${folder}"/../data/processing/comunicazioni_sdi.jsonl

# Funzione per convertire i nomi dei fogli in snake_case
jq_snake_case() {
  jq -r '.name | gsub("[ .,\"-]+"; "_") | ascii_downcase'
}

# Ciclo per estrarre ogni foglio Excel come file CSV separato
while IFS= read -r line; do
  nome=$(printf '%s' "${line}" | jq_snake_case)
  index=$(echo "${line}" | jq -r '.index')

  echo "Elaborando foglio: ${nome}"

  # Estrae il foglio specifico in formato CSV
  qsv excel -Q --sheet "${index}" "${folder}"/../data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx >"${folder}"/../data/processing/"${file}"/"${nome}".csv

done < "${folder}/../data/processing/comunicazioni_sdi.jsonl"

# Lista dei file CSV generati dall'estrazione:
# codice_rosso_commessi.csv
# codice_rosso_segnalazioni.csv
# codice_rosso_vittime.csv
# delitti_commessi.csv
# delitti_segnalazioni.csv
# delitti_vittime.csv
# omicidi_dcpc.csv
# reati_spia_commessi.csv
# reati_spia_segnalazioni.csv
# reati_spia_vittime.csv

# ===== FASE 2: TRASFORMAZIONE DEI DATI =====
# Elabora ogni file CSV applicando le trasformazioni specifiche per tipologia
find "${folder}"/../data/processing/"${file}" -type f -name "*.csv" | while read -r csv_file; do
  file_name=$(basename "${csv_file}")

  # Rimuove righe vuote, pulisce asterischi e normalizza dati per anno
  if [[ "${file_name}" == "codice_rosso_commessi.csv" ]]; then

    # Filtra le righe vuote (seconda colonna null)
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    # Rimuove tutti gli asterischi dal file
    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    # Trasforma le colonne anno (formato YYYY) in righe con chiavi anno/value
    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: codice_rosso_segnalazioni.csv
  # Gestisce colonne per genere (FEMMINILE/MASCHILE) e le normalizza per anno
  elif [[ "$(basename "${csv_file}")" == "codice_rosso_segnalazioni.csv" ]]; then
    # Filtra le righe vuote
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    # Rinomina dinamicamente le colonne FEMMINILE/MASCHILE aggiungendo suffissi anno
    mlr -I --csv put '
      # Crea mappe per tenere traccia dei campi da rinominare
      fields_to_rename = {};

      # Prima passa: identifica tutti i campi che contengono "FEMMINILE" o "MASCHILE"
      for (field_name in $*) {
        if (field_name =~ "FEMMINILE") {
          # Se il campo è esattamente "FEMMINILE" o non ha già un suffisso anno
          if (field_name == "FEMMINILE" || !(field_name =~ "FEMMINILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "FEMMINILE";
          }
        }
        if (field_name =~ "MASCHILE") {
          # Se il campo è esattamente "MASCHILE" o non ha già un suffisso anno
          if (field_name == "MASCHILE" || !(field_name =~ "MASCHILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "MASCHILE";
          }
        }
      }

      # Seconda passa: rinomina i campi identificati
      for (old_name in fields_to_rename) {
        base_name = fields_to_rename[old_name];
        year = 2019;
        new_name = base_name . "_" . year;

        # Trova il primo anno disponibile
        while (is_present($[new_name])) {
          year += 1;
          new_name = base_name . "_" . year;
        }

        # Rinomina il campo
        $[new_name] = $[old_name];
        unset $[old_name];
      }
    ' "${folder}"/../data/processing/"${file}"/"${file_name}"

    # Trasforma la struttura dati da colonne per genere/anno a righe normalizzate
    mlr -I -S --csv reshape -r "_\d" -o item,value then put '$value=sub($value,"0","")' then filter -x 'is_null($value)' then nest --explode --values --across-fields -f item --nested-fs "_" then rename item_1,sesso,item_2,anno "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: codice_rosso_vittime.csv
  # Applica le stesse trasformazioni dei file "commessi" (rimozione righe vuote, asterischi e normalizzazione anni)
  elif [[ "$(basename "${csv_file}")" == "codice_rosso_vittime.csv" ]]; then

    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: delitti_commessi.csv
  # Trasformazione standard per file con colonne anno
  elif [[ "$(basename "${csv_file}")" == "delitti_commessi.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: delitti_segnalazioni.csv
  # Gestisce trasformazione di colonne per genere con logica simile a codice_rosso_segnalazioni.csv
  elif [[ "$(basename "${csv_file}")" == "delitti_segnalazioni.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv put '
      # Crea mappe per tenere traccia dei campi da rinominare
      fields_to_rename = {};

      # Prima passa: identifica tutti i campi che contengono "FEMMINILE" o "MASCHILE"
      for (field_name in $*) {
        if (field_name =~ "FEMMINILE") {
          # Se il campo è esattamente "FEMMINILE" o non ha già un suffisso anno
          if (field_name == "FEMMINILE" || !(field_name =~ "FEMMINILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "FEMMINILE";
          }
        }
        if (field_name =~ "MASCHILE") {
          # Se il campo è esattamente "MASCHILE" o non ha già un suffisso anno
          if (field_name == "MASCHILE" || !(field_name =~ "MASCHILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "MASCHILE";
          }
        }
      }

      # Seconda passa: rinomina i campi identificati
      for (old_name in fields_to_rename) {
        base_name = fields_to_rename[old_name];
        year = 2019;
        new_name = base_name . "_" . year;

        # Trova il primo anno disponibile
        while (is_present($[new_name])) {
          year += 1;
          new_name = base_name . "_" . year;
        }

        # Rinomina il campo
        $[new_name] = $[old_name];
        unset $[old_name];
      }
    ' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I -S --csv reshape -r "_\d" -o item,value then put '$value=sub($value,"0","")' then filter -x 'is_null($value)' then nest --explode --values --across-fields -f item --nested-fs "_" then rename item_1,sesso,item_2,anno "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: delitti_vittime.csv
  # Applica trasformazioni standard per file con colonne anno
  elif [[ "$(basename "${csv_file}")" == "delitti_vittime.csv" ]]; then

    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: omicidi_dcpc.csv
  # Applica solo filtro righe vuote e aggiunge etichetta categoria
  elif [[ "$(basename "${csv_file}")" == "omicidi_dcpc.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"
    mlr -I --csv label categoria "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: reati_spia_commessi.csv
  # Applica trasformazioni standard per file con colonne anno
  elif [[ "$(basename "${csv_file}")" == "reati_spia_commessi.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"
  # Elaborazione file: reati_spia_segnalazioni.csv
  # Applica le stesse trasformazioni dei file segnalazioni (gestione colonne per genere)
  elif [[ "$(basename "${csv_file}")" == "reati_spia_segnalazioni.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv put '
      # Crea mappe per tenere traccia dei campi da rinominare
      fields_to_rename = {};

      # Prima passa: identifica tutti i campi che contengono "FEMMINILE" o "MASCHILE"
      for (field_name in $*) {
        if (field_name =~ "FEMMINILE") {
          # Se il campo è esattamente "FEMMINILE" o non ha già un suffisso anno
          if (field_name == "FEMMINILE" || !(field_name =~ "FEMMINILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "FEMMINILE";
          }
        }
        if (field_name =~ "MASCHILE") {
          # Se il campo è esattamente "MASCHILE" o non ha già un suffisso anno
          if (field_name == "MASCHILE" || !(field_name =~ "MASCHILE_[0-9]{4}$")) {
            fields_to_rename[field_name] = "MASCHILE";
          }
        }
      }

      # Seconda passa: rinomina i campi identificati
      for (old_name in fields_to_rename) {
        base_name = fields_to_rename[old_name];
        year = 2019;
        new_name = base_name . "_" . year;

        # Trova il primo anno disponibile
        while (is_present($[new_name])) {
          year += 1;
          new_name = base_name . "_" . year;
        }

        # Rinomina il campo
        $[new_name] = $[old_name];
        unset $[old_name];
      }
    ' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I -S --csv reshape -r "_\d" -o item,value then put '$value=sub($value,"0","")' then filter -x 'is_null($value)' then nest --explode --values --across-fields -f item --nested-fs "_" then rename item_1,sesso,item_2,anno "${folder}"/../data/processing/"${file}"/"${file_name}"

  # Elaborazione file: reati_spia_vittime.csv
  # Applica trasformazioni standard per file con colonne anno
  elif [[ "$(basename "${csv_file}")" == "reati_spia_vittime.csv" ]]; then
    mlr -I --csv -N filter -x 'is_null($2)' "${folder}"/../data/processing/"${file}"/"${file_name}"

    sed -i 's/\*//g' "${folder}"/../data/processing/"${file}"/"${file_name}"

    mlr -I --csv reshape -r "\d{4}" -o anno,value "${folder}"/../data/processing/"${file}"/"${file_name}"
  else
    echo "ok"
  fi

done

# ===== FASE 3: NORMALIZZAZIONE =====
# Applica normalizzazione dei nomi delle colonne a tutti i file CSV generati
find "${folder}"/../data/processing/"${file}" -type f -name "*.csv" | while read -r csv_file; do

  # Utilizza DuckDB per normalizzare i nomi delle colonne (es. spazi -> underscore, minuscole)
  duckdb --csv -c "FROM read_csv('${csv_file}',normalize_names=true)" >"${folder}"/tmp/tmp.csv

  mv "${folder}"/tmp/tmp.csv "${csv_file}"

  # Rinomina le colonne s _value a value)
  sed -i 's/,_value/,valore/g' "${csv_file}"  # Escapes quotes in CSV files

  # applica il sorting
  mlr -I --csv sort -t anno,provincia,delitto,descrizione_reato,eta_alla_data_del_reato_vittima "${csv_file}"
done


