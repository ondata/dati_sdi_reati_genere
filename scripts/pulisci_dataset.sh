#!/bin/bash

# Script per pulizia dataset SDI reati di genere
# Genera 3 output:
# 1. Prodotto Cartesiano (dedupplicato non aggregato)
# 2. Tabella unica con array (soluzione attuale)
# 3. Modello relazionale (più tabelle)

set -e

INPUT_FILE="./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx"
OUTPUT_DIR="./data/processed"
TEMP_DIR="./scripts/tmp"

mkdir -p "${OUTPUT_DIR}"
mkdir -p "${TEMP_DIR}"

echo "=== Pulizia Dataset SDI Reati di Genere ==="
echo "Data: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# STEP 1: Statistiche originali
echo "STEP 1: Statistiche originali..."

duckdb -json -c "
WITH stats_originali AS (
  SELECT
    count(*) as righe_totali,
    count(DISTINCT PROT_SDI) as eventi_unici
  FROM st_read('${INPUT_FILE}', layer='Sheet')
)
SELECT * FROM stats_originali
" | python3 -c "
import json, sys
data = json.load(sys.stdin)[0]
print(f\"Righe originali: {data['righe_totali']}\")
print(f\"Eventi unici: {data['eventi_unici']}\")
"

# STEP 2: OUTPUT 1 - Prodotto Cartesiano (dedupplicato non aggregato)
echo ""
echo "STEP 2: OUTPUT 1 - Prodotto Cartesiano (dedupplicato non aggregato)..."

OUTPUT_CARTESIANO="${OUTPUT_DIR}/dataset_cartesiano.csv"

duckdb -c "
COPY (
  SELECT DISTINCT
    trim(d.PROT_SDI) as PROT_SDI,
    d.ART,
    trim(d.T_NORMA) as T_NORMA,
    trim(d.RIF_LEGGE) as RIF_LEGGE,
    trim(d.DES_REA_EVE) as DES_REA_EVE,
    trim(d.TENT_CONS) as TENT_CONS,
    trim(d.COD_VITTIMA) as COD_VITTIMA,
    trim(d.SEX_VITTIMA) as SEX_VITTIMA,
    d.ETA_VITTIMA,
    trim(d.NAZIONE_NASCITA_VITTIMA) as NAZIONE_NASCITA_VITTIMA,
    trim(d.COD_DENUNCIATO) as COD_DENUNCIATO,
    trim(d.SESSO_DENUNCIATO) as SESSO_DENUNCIATO,
    d.ETA_DENUNCIATO,
    trim(d.NAZIONE_NASCITA_DENUNCIATO) as NAZIONE_NASCITA_DENUNCIATO,
    trim(d.COD_COLP_DA_PROVV) as COD_COLP_DA_PROVV,
    trim(d.SEX_COLP_PROVV) as SEX_COLP_PROVV,
    d.ETA_COLP_PROVV,
    trim(d.NAZIONE_NASCITA_COLP_PROVV) as NAZIONE_NASCITA_COLP_PROVV,
    trim(d.RELAZIONE_AUTORE_VITTIMA) as RELAZIONE_AUTORE_VITTIMA,
    d.DATA_INIZIO_FATTO,
    d.DATA_FINE_FATTO,
    d.DATA_DENUNCIA,
    COALESCE(trim(d.STATO), 'ITALIA') as STATO,
    c.alpha_3 as STATO_ISO,
    trim(d.REGIONE) as REGIONE,
    trim(d.PROVINCIA) as PROVINCIA,
    trim(d.COMUNE) as COMUNE,
    trim(d.LUOGO_SPECIF_FATTO) as LUOGO_SPECIF_FATTO,
    trim(d.DES_OBIET) as DES_OBIET
  FROM st_read('${INPUT_FILE}', layer='Sheet') d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c 
    ON COALESCE(trim(d.STATO), 'ITALIA') = c.stato
) TO '${OUTPUT_CARTESIANO}' (HEADER, DELIMITER ',');
"

# Rimuovi le stringhe "(null)" dal CSV
sed -i 's/(null)//g' "${OUTPUT_CARTESIANO}"

echo "Output 1 salvato in: ${OUTPUT_CARTESIANO}"

# STEP 3: OUTPUT 2 - Tabella unica con array (soluzione attuale)
echo ""
echo "STEP 3: OUTPUT 2 - Tabella unica con array..."

OUTPUT_ARRAY="${OUTPUT_DIR}/dataset_array.csv"

duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  )
  SELECT
    trim(d.PROT_SDI) as PROT_SDI,
    -- Reato (unico per evento nella maggior parte dei casi)
    list(DISTINCT d.ART ORDER BY d.ART) as ARTICOLI,
    list(DISTINCT trim(d.T_NORMA) ORDER BY trim(d.T_NORMA)) as T_NORMA,
    list(DISTINCT trim(d.RIF_LEGGE) ORDER BY trim(d.RIF_LEGGE)) as RIF_LEGGE,
    list(DISTINCT trim(d.DES_REA_EVE) ORDER BY trim(d.DES_REA_EVE)) as DES_REA_EVE,
    list(DISTINCT trim(d.TENT_CONS) ORDER BY trim(d.TENT_CONS)) as TENT_CONS,
    -- Vittime
    list(DISTINCT trim(d.COD_VITTIMA) ORDER BY trim(d.COD_VITTIMA)) as COD_VITTIME,
    count(DISTINCT d.COD_VITTIMA) as N_VITTIME,
    list(DISTINCT trim(d.SEX_VITTIMA)) FILTER (WHERE d.SEX_VITTIMA IS NOT NULL) as SESSO_VITTIME,
    list(DISTINCT d.ETA_VITTIMA) FILTER (WHERE d.ETA_VITTIMA IS NOT NULL) as ETA_VITTIME,
    list(DISTINCT trim(d.NAZIONE_NASCITA_VITTIMA)) FILTER (WHERE d.NAZIONE_NASCITA_VITTIMA IS NOT NULL) as NAZIONI_NASCITA_VITTIME,
    -- Denunciati
    list(DISTINCT trim(d.COD_DENUNCIATO) ORDER BY trim(d.COD_DENUNCIATO)) as COD_DENUNCIATI,
    count(DISTINCT d.COD_DENUNCIATO) as N_DENUNCIATI,
    list(DISTINCT trim(d.SESSO_DENUNCIATO)) FILTER (WHERE d.SESSO_DENUNCIATO IS NOT NULL) as SESSO_DENUNCIATI,
    list(DISTINCT d.ETA_DENUNCIATO) FILTER (WHERE d.ETA_DENUNCIATO IS NOT NULL) as ETA_DENUNCIATI,
    list(DISTINCT trim(d.NAZIONE_NASCITA_DENUNCIATO)) FILTER (WHERE d.NAZIONE_NASCITA_DENUNCIATO IS NOT NULL) as NAZIONI_NASCITA_DENUNCIATI,
    -- Colpiti da provvedimento
    list(DISTINCT trim(d.COD_COLP_DA_PROVV) ORDER BY trim(d.COD_COLP_DA_PROVV)) FILTER (WHERE d.COD_COLP_DA_PROVV IS NOT NULL) as COD_COLPITI_PROVV,
    count(DISTINCT d.COD_COLP_DA_PROVV) FILTER (WHERE d.COD_COLP_DA_PROVV IS NOT NULL) as N_COLPITI_PROVV,
    list(DISTINCT trim(d.SEX_COLP_PROVV)) FILTER (WHERE d.SEX_COLP_PROVV IS NOT NULL) as SESSO_COLPITI_PROVV,
    list(DISTINCT d.ETA_COLP_PROVV) FILTER (WHERE d.ETA_COLP_PROVV IS NOT NULL) as ETA_COLPITI_PROVV,
    list(DISTINCT trim(d.NAZIONE_NASCITA_COLP_PROVV)) FILTER (WHERE d.NAZIONE_NASCITA_COLP_PROVV IS NOT NULL) as NAZIONI_NASCITA_COLPITI_PROVV,
    -- Relazione (può essere multipla se più denunciati)
    list(DISTINCT trim(d.RELAZIONE_AUTORE_VITTIMA) ORDER BY trim(d.RELAZIONE_AUTORE_VITTIMA)) FILTER (WHERE d.RELAZIONE_AUTORE_VITTIMA IS NOT NULL) as RELAZIONI_AUTORE_VITTIMA,
    -- Temporale
    first(d.DATA_INIZIO_FATTO) as DATA_INIZIO_FATTO,
    first(d.DATA_FINE_FATTO) as DATA_FINE_FATTO,
    first(d.DATA_DENUNCIA) as DATA_DENUNCIA,
    COALESCE(trim(first(d.STATO)), 'ITALIA') as STATO,
    first(c.alpha_3) as STATO_ISO,
    -- Geografico
    trim(first(d.REGIONE)) as REGIONE,
    trim(first(d.PROVINCIA)) as PROVINCIA,
    trim(first(d.COMUNE)) as COMUNE,
    trim(first(d.LUOGO_SPECIF_FATTO)) as LUOGO_SPECIF_FATTO,
    -- Altro
    trim(first(d.DES_OBIET)) as DES_OBIET
  FROM deduplicato d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c 
    ON COALESCE(trim(d.STATO), 'ITALIA') = c.stato
  GROUP BY d.PROT_SDI
) TO '${OUTPUT_ARRAY}' (HEADER, DELIMITER ',');
"

# Rimuovi le stringhe "(null)" e gli array vuoti dal CSV
sed -i -e 's/(null)//g' -e "s/\[''\]//g" "${OUTPUT_ARRAY}"

echo "Output 2 salvato in: ${OUTPUT_ARRAY}"

# STEP 4: OUTPUT 3 - Modello relazionale (più tabelle)
echo ""
echo "STEP 4: OUTPUT 3 - Modello relazionale..."

# Tabella eventi
OUTPUT_EVENTI="${OUTPUT_DIR}/relazionale_eventi.csv"
duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  ),
  regioni_corrections AS (
    SELECT * FROM read_json('resources/problemi_nomi_regioni.jsonl')
  ),
  province_corrections AS (
    SELECT * FROM read_json('resources/problemi_nomi_province.jsonl')
  ),
  comuni_corrections AS (
    SELECT * FROM read_json('resources/problemi_nomi_comuni.jsonl')
  ),
  sardegna_corrections AS (
    SELECT * FROM read_json('resources/problemi_province_sardegna.jsonl')
  ),
  istat_regioni AS (
    SELECT DISTINCT
      codice_regione,
      regione
    FROM read_csv('resources/unita_territoriali_istat.csv')
  ),
  istat_province AS (
    SELECT DISTINCT ON (COD_UTS)
      COD_UTS as codice_provinciauts,
      PROVINCIA as provinciauts
    FROM read_csv('tasks/nomi_geo_istat/data/comuni_con_provincia.csv')
    ORDER BY COD_UTS, PRO_COM_T
  ),
  istat_comuni AS (
    -- Tabella comuni con nomi bilingue splittati
    WITH base AS (
      SELECT * FROM read_csv('tasks/nomi_geo_istat/data/comuni_con_provincia.csv')
    ),
    nome_italiano AS (
      SELECT 
        PRO_COM_T as codice_comune_alfanumerico,
        CASE 
          WHEN COMUNE LIKE '%/%' THEN trim(split_part(COMUNE, '/', 1))
          ELSE COMUNE
        END as comune_dizione_italiana,
        PROVINCIA as provinciauts
      FROM base
    ),
    nome_altra_lingua AS (
      SELECT 
        PRO_COM_T as codice_comune_alfanumerico,
        trim(split_part(COMUNE, '/', 2)) as comune_dizione_italiana,
        PROVINCIA as provinciauts
      FROM base
      WHERE COMUNE LIKE '%/%'
    )
    SELECT * FROM nome_italiano
    UNION ALL
    SELECT * FROM nome_altra_lingua
  ),
  -- Applica correzione province Sardegna
  data_with_sardegna AS (
    SELECT 
      d.*,
      COALESCE(sc.provincia_corretta, d.PROVINCIA) as PROVINCIA_CORRETTA
    FROM deduplicato d
    LEFT JOIN sardegna_corrections sc
      ON UPPER(trim(d.PROVINCIA)) = UPPER(sc.provincia)
      AND UPPER(trim(d.COMUNE)) = UPPER(sc.comune)
  )
  SELECT
    trim(d.PROT_SDI) as PROT_SDI,
    trim(first(d.TENT_CONS)) as TENT_CONS,
    first(d.DATA_INIZIO_FATTO) as DATA_INIZIO_FATTO,
    first(d.DATA_FINE_FATTO) as DATA_FINE_FATTO,
    first(d.DATA_DENUNCIA) as DATA_DENUNCIA,
    COALESCE(trim(first(d.STATO)), 'ITALIA') as STATO,
    first(c.alpha_3) as STATO_ISO,
    trim(first(d.REGIONE)) as REGIONE,
    first(i_reg.codice_regione) as CODICE_REGIONE,
    trim(first(d.PROVINCIA)) as PROVINCIA,
    first(i_prov.codice_provinciauts) as CODICE_PROVINCIA,
    trim(first(d.COMUNE)) as COMUNE,
    first(i_com.codice_comune_alfanumerico) as CODICE_COMUNE,
    first(i_reg.regione) as REGIONE_NOME_ISTAT,
    first(i_prov.provinciauts) as PROVINCIA_NOME_ISTAT,
    first(i_com.comune_dizione_italiana) as COMUNE_NOME_ISTAT,
    trim(first(d.LUOGO_SPECIF_FATTO)) as LUOGO_SPECIF_FATTO,
    trim(first(d.DES_OBIET)) as DES_OBIET
  FROM data_with_sardegna d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c 
    ON COALESCE(trim(d.STATO), 'ITALIA') = c.stato
  LEFT JOIN regioni_corrections rc
    ON UPPER(trim(d.REGIONE)) = UPPER(rc.nome)
  LEFT JOIN istat_regioni i_reg
    ON UPPER(COALESCE(rc.nome_corretto, trim(d.REGIONE))) = UPPER(i_reg.regione)
  LEFT JOIN province_corrections pc
    ON UPPER(trim(d.PROVINCIA_CORRETTA)) = UPPER(pc.nome)
  LEFT JOIN istat_province i_prov
    ON UPPER(COALESCE(pc.nome_corretto, trim(d.PROVINCIA_CORRETTA))) = UPPER(i_prov.provinciauts)
  LEFT JOIN comuni_corrections cc
    ON UPPER(trim(d.COMUNE)) = UPPER(cc.nome)
  LEFT JOIN istat_comuni i_com
    ON UPPER(COALESCE(pc.nome_corretto, trim(d.PROVINCIA_CORRETTA))) = UPPER(i_com.provinciauts) 
    AND UPPER(COALESCE(cc.nome_corretto, trim(d.COMUNE))) = UPPER(i_com.comune_dizione_italiana)
  GROUP BY d.PROT_SDI
) TO '${OUTPUT_EVENTI}' (HEADER, DELIMITER ',');
"

sed -i 's/(null)//g' "${OUTPUT_EVENTI}"

# Tabella reati
OUTPUT_REATI="${OUTPUT_DIR}/relazionale_reati.csv"
duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  )
  SELECT DISTINCT
    trim(PROT_SDI) as PROT_SDI,
    ART,
    trim(T_NORMA) as T_NORMA,
    trim(RIF_LEGGE) as RIF_LEGGE,
    trim(DES_REA_EVE) as DES_REA_EVE
  FROM deduplicato
  WHERE ART IS NOT NULL
) TO '${OUTPUT_REATI}' (HEADER, DELIMITER ',');
"

sed -i 's/(null)//g' "${OUTPUT_REATI}"

# Tabella vittime
OUTPUT_VITTIME="${OUTPUT_DIR}/relazionale_vittime.csv"
duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  )
  SELECT DISTINCT
    trim(d.PROT_SDI) as PROT_SDI,
    trim(d.COD_VITTIMA) as COD_VITTIMA,
    trim(d.SEX_VITTIMA) as SEX_VITTIMA,
    d.ETA_VITTIMA,
    trim(d.NAZIONE_NASCITA_VITTIMA) as NAZIONE_NASCITA_VITTIMA,
    c.alpha_3 as NAZIONE_NASCITA_VITTIMA_ISO
  FROM deduplicato d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c
    ON trim(d.NAZIONE_NASCITA_VITTIMA) = c.stato
  WHERE d.COD_VITTIMA IS NOT NULL
) TO '${OUTPUT_VITTIME}' (HEADER, DELIMITER ',');
"

sed -i 's/(null)//g' "${OUTPUT_VITTIME}"

# Tabella denunciati
OUTPUT_DENUNCIATI="${OUTPUT_DIR}/relazionale_denunciati.csv"
duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  )
  SELECT DISTINCT
    trim(d.PROT_SDI) as PROT_SDI,
    trim(d.COD_DENUNCIATO) as COD_DENUNCIATO,
    trim(d.SESSO_DENUNCIATO) as SESSO_DENUNCIATO,
    d.ETA_DENUNCIATO,
    trim(d.NAZIONE_NASCITA_DENUNCIATO) as NAZIONE_NASCITA_DENUNCIATO,
    c.alpha_3 as NAZIONE_NASCITA_DENUNCIATO_ISO,
    trim(d.RELAZIONE_AUTORE_VITTIMA) as RELAZIONE_AUTORE_VITTIMA
  FROM deduplicato d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c
    ON trim(d.NAZIONE_NASCITA_DENUNCIATO) = c.stato
  WHERE d.COD_DENUNCIATO IS NOT NULL
) TO '${OUTPUT_DENUNCIATI}' (HEADER, DELIMITER ',');
"

sed -i 's/(null)//g' "${OUTPUT_DENUNCIATI}"

# Tabella colpiti da provvedimento
OUTPUT_COLPITI="${OUTPUT_DIR}/relazionale_colpiti_provv.csv"
duckdb -c "
COPY (
  WITH deduplicato AS (
    SELECT DISTINCT *
    FROM st_read('${INPUT_FILE}', layer='Sheet')
  )
  SELECT DISTINCT
    trim(d.PROT_SDI) as PROT_SDI,
    trim(d.COD_COLP_DA_PROVV) as COD_COLP_DA_PROVV,
    trim(d.SEX_COLP_PROVV) as SEX_COLP_PROVV,
    d.ETA_COLP_PROVV,
    trim(d.NAZIONE_NASCITA_COLP_PROVV) as NAZIONE_NASCITA_COLP_PROVV,
    c.alpha_3 as NAZIONE_NASCITA_COLP_PROVV_ISO
  FROM deduplicato d
  LEFT JOIN read_csv('./resources/codici_stati.csv') c
    ON trim(d.NAZIONE_NASCITA_COLP_PROVV) = c.stato
  WHERE d.COD_COLP_DA_PROVV IS NOT NULL
) TO '${OUTPUT_COLPITI}' (HEADER, DELIMITER ',');
"

sed -i 's/(null)//g' "${OUTPUT_COLPITI}"

echo "Output 3 salvato in:"
echo "  - Eventi: ${OUTPUT_EVENTI}"
echo "  - Reati: ${OUTPUT_REATI}"
echo "  - Vittime: ${OUTPUT_VITTIME}"
echo "  - Denunciati: ${OUTPUT_DENUNCIATI}"
echo "  - Colpiti provv: ${OUTPUT_COLPITI}"

# STEP 4.1: Database DuckDB con tabelle relazionali
echo ""
echo "STEP 4.1: Creazione database DuckDB relazionale..."

OUTPUT_DB="${OUTPUT_DIR}/reati_sdi_relazionale.duckdb"

# Rimuovi database esistente
rm -f "${OUTPUT_DB}"

duckdb "${OUTPUT_DB}" <<EOF
-- Creazione tabelle con tipi dati VARCHAR per gestire null
CREATE OR REPLACE TABLE eventi (
    PROT_SDI VARCHAR PRIMARY KEY,
    TENT_CONS VARCHAR,
    DATA_INIZIO_FATTO VARCHAR,
    DATA_FINE_FATTO VARCHAR,
    DATA_DENUNCIA VARCHAR,
    STATO VARCHAR,
    STATO_ISO VARCHAR,
    REGIONE VARCHAR,
    CODICE_REGIONE VARCHAR,
    PROVINCIA VARCHAR,
    CODICE_PROVINCIA VARCHAR,
    COMUNE VARCHAR,
    CODICE_COMUNE VARCHAR,
    REGIONE_NOME_ISTAT VARCHAR,
    PROVINCIA_NOME_ISTAT VARCHAR,
    COMUNE_NOME_ISTAT VARCHAR,
    LUOGO_SPECIF_FATTO VARCHAR,
    DES_OBIET VARCHAR
);

CREATE OR REPLACE TABLE reati (
    PROT_SDI VARCHAR,
    ART VARCHAR,
    T_NORMA VARCHAR,
    RIF_LEGGE VARCHAR,
    DES_REA_EVE VARCHAR,
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

CREATE OR REPLACE TABLE vittime (
    PROT_SDI VARCHAR,
    COD_VITTIMA VARCHAR,
    SEX_VITTIMA VARCHAR,
    ETA_VITTIMA VARCHAR,
    NAZIONE_NASCITA_VITTIMA VARCHAR,
    NAZIONE_NASCITA_VITTIMA_ISO VARCHAR,
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

CREATE OR REPLACE TABLE denunciati (
    PROT_SDI VARCHAR,
    COD_DENUNCIATO VARCHAR,
    SESSO_DENUNCIATO VARCHAR,
    ETA_DENUNCIATO VARCHAR,
    NAZIONE_NASCITA_DENUNCIATO VARCHAR,
    NAZIONE_NASCITA_DENUNCIATO_ISO VARCHAR,
    RELAZIONE_AUTORE_VITTIMA VARCHAR,
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

CREATE OR REPLACE TABLE colpiti_provv (
    PROT_SDI VARCHAR,
    COD_COLP_DA_PROVV VARCHAR,
    SEX_COLP_PROVV VARCHAR,
    ETA_COLP_PROVV VARCHAR,
    NAZIONE_NASCITA_COLP_PROVV VARCHAR,
    NAZIONE_NASCITA_COLP_PROVV_ISO VARCHAR,
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

-- Importazione dati con gestione null (celle vuote = NULL)
COPY eventi FROM '${OUTPUT_EVENTI}' (HEADER, DELIMITER ',', NULLSTR '', AUTO_DETECT TRUE);
COPY reati FROM '${OUTPUT_REATI}' (HEADER, DELIMITER ',', NULLSTR '', AUTO_DETECT TRUE);
COPY vittime FROM '${OUTPUT_VITTIME}' (HEADER, DELIMITER ',', NULLSTR '', AUTO_DETECT TRUE);
COPY denunciati FROM '${OUTPUT_DENUNCIATI}' (HEADER, DELIMITER ',', NULLSTR '', AUTO_DETECT TRUE);
COPY colpiti_provv FROM '${OUTPUT_COLPITI}' (HEADER, DELIMITER ',', NULLSTR '', AUTO_DETECT TRUE);

-- Creazione indici per performance
CREATE INDEX idx_reati_prot_sdi ON reati(PROT_SDI);
CREATE INDEX idx_vittime_prot_sdi ON vittime(PROT_SDI);
CREATE INDEX idx_denunciati_prot_sdi ON denunciati(PROT_SDI);
CREATE INDEX idx_colpiti_provv_prot_sdi ON colpiti_provv(PROT_SDI);
CREATE INDEX idx_eventi_regione ON eventi(REGIONE);
CREATE INDEX idx_eventi_data_denuncia ON eventi(DATA_DENUNCIA);
EOF

echo "Database DuckDB salvato in: ${OUTPUT_DB}"

# STEP 5: Statistiche finali
echo ""
echo "STEP 5: Statistiche finali..."

duckdb -json -c "
WITH cartesian_stats AS (
  SELECT count(*) as righe_cartesiano
  FROM read_csv('${OUTPUT_CARTESIANO}')
),
array_stats AS (
  SELECT
    count(*) as eventi_totali,
    avg(N_VITTIME) as media_vittime_per_evento,
    max(N_VITTIME) as max_vittime_per_evento,
    avg(N_DENUNCIATI) as media_denunciati_per_evento,
    max(N_DENUNCIATI) as max_denunciati_per_evento,
    avg(N_COLPITI_PROVV) as media_colpiti_provv_per_evento,
    max(N_COLPITI_PROVV) as max_colpiti_provv_per_evento
  FROM read_csv('${OUTPUT_ARRAY}')
),
relazionale_stats AS (
  SELECT
    (SELECT count(*) FROM read_csv('${OUTPUT_EVENTI}')) as n_eventi,
    (SELECT count(*) FROM read_csv('${OUTPUT_REATI}')) as n_reati,
    (SELECT count(*) FROM read_csv('${OUTPUT_VITTIME}')) as n_vittime,
    (SELECT count(*) FROM read_csv('${OUTPUT_DENUNCIATI}')) as n_denunciati,
    (SELECT count(*) FROM read_csv('${OUTPUT_COLPITI}')) as n_colpiti_provv
)
SELECT 
  cartesian_stats.*,
  array_stats.*,
  relazionale_stats.*
FROM cartesian_stats, array_stats, relazionale_stats
" | python3 -c "
import json, sys
data = json.load(sys.stdin)[0]
print(f\"Output 1 - Prodotto Cartesiano: {data['righe_cartesiano']} righe\")
print(f\"Output 2 - Array: {data['eventi_totali']} eventi\")
print(f\"  Media vittime/evento: {data['media_vittime_per_evento']:.2f}\")
print(f\"  Media denunciati/evento: {data['media_denunciati_per_evento']:.2f}\")
print(f\"  Media colpiti provv/evento: {data['media_colpiti_provv_per_evento']:.2f}\")
print(f\"Output 3 - Relazionale:\")
print(f\"  Eventi: {data['n_eventi']}\")
print(f\"  Reati: {data['n_reati']}\")
print(f\"  Vittime: {data['n_vittime']}\")
print(f\"  Denunciati: {data['n_denunciati']}\")
print(f\"  Colpiti provv: {data['n_colpiti_provv']}\")
"

echo ""
echo "=== Pulizia completata ==="

# STEP 6: Analisi fuzzy matching per comuni non matchati
echo ""
echo "STEP 6: Analisi fuzzy matching comuni mancanti..."

# Estrai comuni senza codice ISTAT
duckdb -c "
COPY (
  SELECT DISTINCT
    PROVINCIA,
    COMUNE
  FROM read_csv('${OUTPUT_DIR}/relazionale_eventi.csv', auto_detect=true)
  WHERE COMUNE IS NOT NULL 
    AND COMUNE != ''
    AND CODICE_COMUNE IS NULL
  ORDER BY PROVINCIA, COMUNE
) TO '${TEMP_DIR}/comuni_senza_codice.csv' (HEADER, DELIMITER ',');
"

# Prepara tabella ISTAT comuni per matching
duckdb -c "
COPY (
  SELECT DISTINCT
    provinciauts as PROVINCIA,
    comune_dizione_italiana as COMUNE,
    codice_comune_alfanumerico as CODICE_COMUNE
  FROM read_csv('resources/unita_territoriali_istat.csv')
  ORDER BY provinciauts, comune_dizione_italiana
) TO '${TEMP_DIR}/istat_comuni.csv' (HEADER, DELIMITER ',');
"

# Esegui fuzzy matching con csvmatch
echo "Esecuzione fuzzy matching (threshold 0.95)..."
csvmatch \
  "${TEMP_DIR}/comuni_senza_codice.csv" \
  "${TEMP_DIR}/istat_comuni.csv" \
  --fields1 PROVINCIA COMUNE \
  --fields2 PROVINCIA COMUNE \
  --fuzzy levenshtein \
  -r 0.95 \
  -i \
  -a \
  -n \
  --join left-outer \
  --output '1.PROVINCIA' '1.COMUNE' 2.COMUNE 2.CODICE_COMUNE \
  > "${TEMP_DIR}/fuzzy_match_comuni.csv"

# Rinomina colonne per chiarezza
mlr -I --csv rename 'COMUNE_2,COMUNE_ISTAT,CODICE_COMUNE_2,CODICE_COMUNE' "${TEMP_DIR}/fuzzy_match_comuni.csv"

# Conta risultati
TOTAL_UNMATCHED=$(wc -l < "${TEMP_DIR}/comuni_senza_codice.csv")
TOTAL_UNMATCHED=$((TOTAL_UNMATCHED - 1))  # Rimuovi header

FUZZY_MATCHED=$(mlr --csv filter "\$CODICE_COMUNE != \"\"" then count "${TEMP_DIR}/fuzzy_match_comuni.csv" 2>/dev/null || echo "0")

echo "Comuni senza codice ISTAT: ${TOTAL_UNMATCHED}"
echo "Comuni matchati con fuzzy (≥95%): ${FUZZY_MATCHED}"
echo ""
echo "Risultati fuzzy matching salvati in: ${TEMP_DIR}/fuzzy_match_comuni.csv"

# STEP 7: Aggiornamento dataset con comuni matchati da fuzzy
echo ""
echo "STEP 7: Aggiornamento dataset con comuni matchati da fuzzy..."

# Aggiorna dataset_cartesiano.csv
echo "Aggiornamento dataset_cartesiano.csv..."
duckdb -c "
COPY (
  SELECT 
    dc.PROT_SDI,
    dc.ART,
    dc.T_NORMA,
    dc.RIF_LEGGE,
    dc.DES_REA_EVE,
    dc.TENT_CONS,
    dc.COD_VITTIMA,
    dc.SEX_VITTIMA,
    dc.ETA_VITTIMA,
    dc.NAZIONE_NASCITA_VITTIMA,
    dc.COD_DENUNCIATO,
    dc.SESSO_DENUNCIATO,
    dc.ETA_DENUNCIATO,
    dc.NAZIONE_NASCITA_DENUNCIATO,
    dc.COD_COLP_DA_PROVV,
    dc.SEX_COLP_PROVV,
    dc.ETA_COLP_PROVV,
    dc.NAZIONE_NASCITA_COLP_PROVV,
    dc.RELAZIONE_AUTORE_VITTIMA,
    dc.DATA_INIZIO_FATTO,
    dc.DATA_FINE_FATTO,
    dc.DATA_DENUNCIA,
    dc.STATO,
    dc.STATO_ISO,
    dc.REGIONE,
    dc.PROVINCIA,
    COALESCE(fm.COMUNE_ISTAT, dc.COMUNE) as COMUNE,
    fm.CODICE_COMUNE as CODICE_COMUNE,
    dc.LUOGO_SPECIF_FATTO,
    dc.DES_OBIET
  FROM read_csv('${OUTPUT_CARTESIANO}', auto_detect=true) dc
  LEFT JOIN read_csv('${TEMP_DIR}/fuzzy_match_comuni.csv', auto_detect=true) fm
    ON dc.PROVINCIA = fm.PROVINCIA 
    AND dc.COMUNE = fm.COMUNE
    AND fm.CODICE_COMUNE IS NOT NULL
    AND fm.CODICE_COMUNE != ''
) TO '${OUTPUT_CARTESIANO}.new' (HEADER, DELIMITER ',');
"
mv "${OUTPUT_CARTESIANO}.new" "${OUTPUT_CARTESIANO}"

# Aggiorna dataset_array.csv
echo "Aggiornamento dataset_array.csv..."
duckdb -c "
COPY (
  SELECT 
    da.PROT_SDI,
    da.ARTICOLI,
    da.T_NORMA,
    da.RIF_LEGGE,
    da.DES_REA_EVE,
    da.TENT_CONS,
    da.COD_VITTIME,
    da.N_VITTIME,
    da.SESSO_VITTIME,
    da.ETA_VITTIME,
    da.NAZIONI_NASCITA_VITTIME,
    da.COD_DENUNCIATI,
    da.N_DENUNCIATI,
    da.SESSO_DENUNCIATI,
    da.ETA_DENUNCIATI,
    da.NAZIONI_NASCITA_DENUNCIATI,
    da.COD_COLPITI_PROVV,
    da.N_COLPITI_PROVV,
    da.SESSO_COLPITI_PROVV,
    da.ETA_COLPITI_PROVV,
    da.NAZIONI_NASCITA_COLPITI_PROVV,
    da.RELAZIONI_AUTORE_VITTIMA,
    da.DATA_INIZIO_FATTO,
    da.DATA_FINE_FATTO,
    da.DATA_DENUNCIA,
    da.STATO,
    da.STATO_ISO,
    da.REGIONE,
    da.PROVINCIA,
    COALESCE(fm.COMUNE_ISTAT, da.COMUNE) as COMUNE,
    fm.CODICE_COMUNE as CODICE_COMUNE,
    da.LUOGO_SPECIF_FATTO,
    da.DES_OBIET
  FROM read_csv('${OUTPUT_ARRAY}', auto_detect=true) da
  LEFT JOIN read_csv('${TEMP_DIR}/fuzzy_match_comuni.csv', auto_detect=true) fm
    ON da.PROVINCIA = fm.PROVINCIA 
    AND da.COMUNE = fm.COMUNE
    AND fm.CODICE_COMUNE IS NOT NULL
    AND fm.CODICE_COMUNE != ''
) TO '${OUTPUT_ARRAY}.new' (HEADER, DELIMITER ',');
"
mv "${OUTPUT_ARRAY}.new" "${OUTPUT_ARRAY}"

# Aggiorna relazionale_eventi.csv
echo "Aggiornamento relazionale_eventi.csv..."
duckdb -c "
COPY (
  SELECT 
    de.PROT_SDI,
    de.TENT_CONS,
    de.DATA_INIZIO_FATTO,
    de.DATA_FINE_FATTO,
    de.DATA_DENUNCIA,
    de.STATO,
    de.STATO_ISO,
    de.REGIONE,
    de.CODICE_REGIONE,
    de.PROVINCIA,
    de.CODICE_PROVINCIA,
    COALESCE(fm.COMUNE_ISTAT, de.COMUNE) as COMUNE,
    COALESCE(fm.CODICE_COMUNE, de.CODICE_COMUNE) as CODICE_COMUNE,
    de.REGIONE_NOME_ISTAT,
    de.PROVINCIA_NOME_ISTAT,
    COALESCE(fm.COMUNE_ISTAT, de.COMUNE_NOME_ISTAT) as COMUNE_NOME_ISTAT,
    de.LUOGO_SPECIF_FATTO,
    de.DES_OBIET
  FROM read_csv('${OUTPUT_EVENTI}', auto_detect=true) de
  LEFT JOIN read_csv('${TEMP_DIR}/fuzzy_match_comuni.csv', auto_detect=true) fm
    ON de.PROVINCIA = fm.PROVINCIA 
    AND de.COMUNE = fm.COMUNE
    AND fm.CODICE_COMUNE IS NOT NULL
    AND fm.CODICE_COMUNE != ''
) TO '${OUTPUT_EVENTI}.new' (HEADER, DELIMITER ',');
"
mv "${OUTPUT_EVENTI}.new" "${OUTPUT_EVENTI}"

# Aggiorna database DuckDB
echo "Aggiornamento database DuckDB..."
duckdb "${OUTPUT_DB}" <<EOF
-- Drop tutte le tabelle e indici esistenti nell'ordine corretto
DROP INDEX IF EXISTS idx_reati_prot_sdi;
DROP INDEX IF EXISTS idx_vittime_prot_sdi;
DROP INDEX IF EXISTS idx_denunciati_prot_sdi;
DROP INDEX IF EXISTS idx_colpiti_provv_prot_sdi;
DROP INDEX IF EXISTS idx_eventi_regione;
DROP INDEX IF EXISTS idx_eventi_data_denuncia;

DROP TABLE IF EXISTS reati;
DROP TABLE IF EXISTS vittime;
DROP TABLE IF EXISTS denunciati;
DROP TABLE IF EXISTS colpiti_provv;
DROP TABLE IF EXISTS eventi;

-- Crea tabella eventi aggiornata con fuzzy match
CREATE TABLE eventi AS
SELECT 
  de.PROT_SDI,
  de.TENT_CONS,
  de.DATA_INIZIO_FATTO,
  de.DATA_FINE_FATTO,
  de.DATA_DENUNCIA,
  de.STATO,
  de.STATO_ISO,
  de.REGIONE,
  de.CODICE_REGIONE,
  de.PROVINCIA,
  de.CODICE_PROVINCIA,
  COALESCE(fm.COMUNE_ISTAT, de.COMUNE) as COMUNE,
  COALESCE(fm.CODICE_COMUNE, de.CODICE_COMUNE) as CODICE_COMUNE,
  de.LUOGO_SPECIF_FATTO,
  de.DES_OBIET
FROM read_csv('${OUTPUT_EVENTI}', auto_detect=true) de
LEFT JOIN read_csv('${TEMP_DIR}/fuzzy_match_comuni.csv', auto_detect=true) fm
  ON de.PROVINCIA = fm.PROVINCIA 
  AND de.COMUNE = fm.COMUNE
  AND fm.CODICE_COMUNE IS NOT NULL
  AND fm.CODICE_COMUNE != '';

-- Ricrea altre tabelle
CREATE TABLE reati AS SELECT * FROM read_csv('${OUTPUT_REATI}', auto_detect=true);
CREATE TABLE vittime AS SELECT * FROM read_csv('${OUTPUT_VITTIME}', auto_detect=true);
CREATE TABLE denunciati AS SELECT * FROM read_csv('${OUTPUT_DENUNCIATI}', auto_detect=true);
CREATE TABLE colpiti_provv AS SELECT * FROM read_csv('${OUTPUT_COLPITI}', auto_detect=true);

-- Ricrea indici
CREATE INDEX idx_reati_prot_sdi ON reati(PROT_SDI);
CREATE INDEX idx_vittime_prot_sdi ON vittime(PROT_SDI);
CREATE INDEX idx_denunciati_prot_sdi ON denunciati(PROT_SDI);
CREATE INDEX idx_colpiti_provv_prot_sdi ON colpiti_provv(PROT_SDI);
CREATE INDEX idx_eventi_regione ON eventi(REGIONE);
CREATE INDEX idx_eventi_data_denuncia ON eventi(DATA_DENUNCIA);
EOF

echo "Dataset aggiornati con comuni corretti da fuzzy matching"
echo ""
echo "=== Aggiornamento completato ==="

# STEP 7.1: Aggiungi codici e nomi ISTAT a dataset_cartesiano e dataset_array
echo ""
echo "STEP 7.1: Aggiunta codici e nomi ISTAT agli altri output..."

# Aggiorna dataset_cartesiano con codici e nomi ISTAT
echo "Aggiornamento dataset_cartesiano con codici ISTAT..."
duckdb -c "
COPY (
  SELECT 
    dc.PROT_SDI,
    dc.ART,
    dc.T_NORMA,
    dc.RIF_LEGGE,
    dc.DES_REA_EVE,
    dc.TENT_CONS,
    dc.COD_VITTIMA,
    dc.SEX_VITTIMA,
    dc.ETA_VITTIMA,
    dc.NAZIONE_NASCITA_VITTIMA,
    dc.COD_DENUNCIATO,
    dc.SESSO_DENUNCIATO,
    dc.ETA_DENUNCIATO,
    dc.NAZIONE_NASCITA_DENUNCIATO,
    dc.COD_COLP_DA_PROVV,
    dc.SEX_COLP_PROVV,
    dc.ETA_COLP_PROVV,
    dc.NAZIONE_NASCITA_COLP_PROVV,
    dc.RELAZIONE_AUTORE_VITTIMA,
    dc.DATA_INIZIO_FATTO,
    dc.DATA_FINE_FATTO,
    dc.DATA_DENUNCIA,
    dc.STATO,
    dc.STATO_ISO,
    dc.REGIONE,
    dc.PROVINCIA,
    dc.COMUNE,
    dc.LUOGO_SPECIF_FATTO,
    dc.DES_OBIET,
    e.CODICE_REGIONE,
    e.CODICE_PROVINCIA,
    e.CODICE_COMUNE,
    e.REGIONE_NOME_ISTAT,
    e.PROVINCIA_NOME_ISTAT,
    e.COMUNE_NOME_ISTAT
  FROM read_csv('${OUTPUT_CARTESIANO}', auto_detect=true) dc
  LEFT JOIN read_csv('${OUTPUT_EVENTI}', auto_detect=true) e
    ON dc.PROT_SDI = e.PROT_SDI
) TO '${OUTPUT_CARTESIANO}.new' (HEADER, DELIMITER ',');
"
mv "${OUTPUT_CARTESIANO}.new" "${OUTPUT_CARTESIANO}"

# Aggiorna dataset_array con codici e nomi ISTAT
echo "Aggiornamento dataset_array con codici ISTAT..."
duckdb -c "
COPY (
  SELECT 
    da.PROT_SDI,
    da.ARTICOLI,
    da.T_NORMA,
    da.RIF_LEGGE,
    da.DES_REA_EVE,
    da.TENT_CONS,
    da.COD_VITTIME,
    da.N_VITTIME,
    da.SESSO_VITTIME,
    da.ETA_VITTIME,
    da.NAZIONI_NASCITA_VITTIME,
    da.COD_DENUNCIATI,
    da.N_DENUNCIATI,
    da.SESSO_DENUNCIATI,
    da.ETA_DENUNCIATI,
    da.NAZIONI_NASCITA_DENUNCIATI,
    da.COD_COLPITI_PROVV,
    da.N_COLPITI_PROVV,
    da.SESSO_COLPITI_PROVV,
    da.ETA_COLPITI_PROVV,
    da.NAZIONI_NASCITA_COLPITI_PROVV,
    da.RELAZIONI_AUTORE_VITTIMA,
    da.DATA_INIZIO_FATTO,
    da.DATA_FINE_FATTO,
    da.DATA_DENUNCIA,
    da.STATO,
    da.STATO_ISO,
    da.REGIONE,
    da.PROVINCIA,
    da.COMUNE,
    da.LUOGO_SPECIF_FATTO,
    da.DES_OBIET,
    e.CODICE_REGIONE,
    e.CODICE_PROVINCIA,
    e.CODICE_COMUNE,
    e.REGIONE_NOME_ISTAT,
    e.PROVINCIA_NOME_ISTAT,
    e.COMUNE_NOME_ISTAT
  FROM read_csv('${OUTPUT_ARRAY}', auto_detect=true) da
  LEFT JOIN read_csv('${OUTPUT_EVENTI}', auto_detect=true) e
    ON da.PROT_SDI = e.PROT_SDI
) TO '${OUTPUT_ARRAY}.new' (HEADER, DELIMITER ',');
"
mv "${OUTPUT_ARRAY}.new" "${OUTPUT_ARRAY}"

echo "Codici e nomi ISTAT aggiunti a tutti i dataset"
echo ""
echo "=== Arricchimento ISTAT completato ==="
