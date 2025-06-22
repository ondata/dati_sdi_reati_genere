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

done <"${folder}/../data/processing/comunicazioni_sdi.jsonl"

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
# Questo comando legge il CSV originale e produce un nuovo file con nomi colonna normalizzati
  duckdb --csv -c "FROM read_csv('${csv_file}',normalize_names=true)" >"${folder}"/tmp/tmp.csv

  # Sostituisce il file originale con la versione normalizzata
  mv "${folder}"/tmp/tmp.csv "${csv_file}"

  # Rinomina le colonne da _value a valore per uniformare la nomenclatura
  sed -i 's/,_value/,valore/g' "${csv_file}" # Escapes quotes in CSV files

  # Applica il sorting dei dati per facilitare l'analisi e le query
  mlr -I --csv sort -t anno,provincia,delitto,descrizione_reato,eta_alla_data_del_reato_vittima "${csv_file}"

  # Riordina le colonne per avere una struttura dati coerente tra i vari file
  mlr -I --csv reorder -f anno,provincia,delitto,descrizione_reato,eta_alla_data_del_reato_vittima "${csv_file}"

  # Estrae i nomi delle province per creare un elenco completo
  # Questo verrà utilizzato per la normalizzazione delle province
  mlr --c2n cut -f provincia then uniq -a "${csv_file}" >>"${folder}"/tmp/province.txt

done

# ===== FASE 4: NORMALIZZAZIONE PROVINCE =====
# Estrazione e normalizzazione dei codici provincia dai dati SDI

# Elabora e normalizza i nomi delle province trovate nei dati SDI
mlr --inidx --ocsv --ifs tab uniq -a then skip-trivial-records then label provinciauts "${folder}"/tmp/province.txt | grep -viP "non localizzata" >"${folder}"/tmp.txt

# Salva il file temporaneo come elenco delle province SDI
mv "${folder}"/tmp.txt "${folder}"/tmp/province_sdi.csv

# Aggiunge una colonna per i nomi corretti delle province (inizialmente uguale all'originale)
mlr -I --csv put '$provinciauts_corretto=$provinciauts' "${folder}"/tmp/province_sdi.csv

# Applica le correzioni ai nomi delle province utilizzando il file di mappatura JSONL
# che contiene le correzioni per i problemi noti nei nomi delle province
while IFS= read -r line; do
  # Estrae il nome originale e quello corretto dal file JSONL
  nome=$(jq -r '.nome' <<<"${line}")
  nome_corretto=$(jq -r '.nome_corretto' <<<"${line}")

  # Sostituisce il nome errato con quello corretto nel campo 'provinciauts_corretto'
  mlr -I --csv sub -f provinciauts_corretto "^${nome}$" "${nome_corretto}" "${folder}"/tmp/province_sdi.csv
done <"${folder}"/../resources/problemi_nomi_province.jsonl

# Estrae le colonne rilevanti dalle unità territoriali ISTAT e le salva in un file temporaneo
# per essere utilizzate nel join con le province SDI
mlr --csv cut -f codice_provinciauts,provinciauts,flag_tipo_uts,codice_provincia_storico,codice_regione,ripartizione_geografica,regione,sigla_automobilistica then uniq -a "${folder}"/../resources/unita_territoriali_istat.csv >>"${folder}"/tmp/province_istat.csv

# Effettua il join fuzzy tra le province SDI e quelle ISTAT utilizzando l'algoritmo Levenshtein
# con soglia di similarità 0.9 e join left-outer per mantenere tutte le province SDI
csvmatch "${folder}"/tmp/province_sdi.csv "${folder}"/tmp/province_istat.csv --fields1 provinciauts_corretto --fields2 provinciauts --fuzzy levenshtein -r 0.9 -i -a -n --join left-outer --output '1*' '2*' >"${folder}"/../resources/province_sdi_istat.csv

# Rinomina il campo 'provinciauts' in 'provincia' per uniformare la nomenclatura
mlr -I --csv rename provinciauts,provincia then uniq -a "${folder}"/../resources/province_sdi_istat.csv

# Arricchimento dei dati con le informazioni geografiche
# Per ogni file CSV (tranne 'omicidi_dcpc.csv'), esegue un join con il file delle province
# per aggiungere le informazioni geografiche (regione, codice provincia, ecc.)
find "${folder}/../data/processing/${file}" -type f -name "*.csv" ! -name "omicidi_dcpc.csv" | while read -r csv_file; do
  # Esegue il join tra i dati dei reati e le informazioni geografiche delle province
  # - --ul: usa un left join per mantenere tutte le righe del file di input
  # - unsparsify: riempie le celle vuote con valori di default
  # - sort/reorder: riorganizza i dati in modo coerente
  mlr --csv join --ul -j provincia -f "${csv_file}" then unsparsify then sort -t anno,provincia,delitto,descrizione_reato,eta_alla_data_del_reato_vittima then reorder -f anno,provincia,delitto,descrizione_reato,eta_alla_data_del_reato_vittima "${folder}"/../resources/province_sdi_istat.csv >"${folder}"/tmp/tmp.csv
  mv "${folder}"/tmp/tmp.csv "${csv_file}"
done

