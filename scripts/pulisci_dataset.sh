#!/bin/bash

# Script per pulizia dataset SDI reati di genere
# Genera 3 output:
# 1. Prodotto Cartesiano (dedupplicato non aggregato)
# 2. Tabella unica con array (soluzione attuale)
# 3. Modello relazionale (più tabelle)

set -e

INPUT_FILE="./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx"
OUTPUT_DIR="./data/processed"

mkdir -p "${OUTPUT_DIR}"

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
    trim(PROT_SDI) as PROT_SDI,
    ART,
    trim(T_NORMA) as T_NORMA,
    trim(RIF_LEGGE) as RIF_LEGGE,
    trim(DES_REA_EVE) as DES_REA_EVE,
    trim(TENT_CONS) as TENT_CONS,
    trim(COD_VITTIMA) as COD_VITTIMA,
    trim(SEX_VITTIMA) as SEX_VITTIMA,
    ETA_VITTIMA,
    trim(NAZIONE_NASCITA_VITTIMA) as NAZIONE_NASCITA_VITTIMA,
    trim(COD_DENUNCIATO) as COD_DENUNCIATO,
    trim(SESSO_DENUNCIATO) as SESSO_DENUNCIATO,
    ETA_DENUNCIATO,
    trim(NAZIONE_NASCITA_DENUNCIATO) as NAZIONE_NASCITA_DENUNCIATO,
    trim(COD_COLP_DA_PROVV) as COD_COLP_DA_PROVV,
    trim(SEX_COLP_PROVV) as SEX_COLP_PROVV,
    ETA_COLP_PROVV,
    trim(NAZIONE_NASCITA_COLP_PROVV) as NAZIONE_NASCITA_COLP_PROVV,
    trim(RELAZIONE_AUTORE_VITTIMA) as RELAZIONE_AUTORE_VITTIMA,
    DATA_INIZIO_FATTO,
    DATA_FINE_FATTO,
    DATA_DENUNCIA,
    trim(STATO) as STATO,
    trim(REGIONE) as REGIONE,
    trim(PROVINCIA) as PROVINCIA,
    trim(COMUNE) as COMUNE,
    trim(LUOGO_SPECIF_FATTO) as LUOGO_SPECIF_FATTO,
    trim(DES_OBIET) as DES_OBIET
  FROM st_read('${INPUT_FILE}', layer='Sheet')
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
    trim(PROT_SDI) as PROT_SDI,
    -- Reato (unico per evento nella maggior parte dei casi)
    list(DISTINCT ART ORDER BY ART) as ARTICOLI,
    list(DISTINCT trim(T_NORMA) ORDER BY trim(T_NORMA)) as T_NORMA,
    list(DISTINCT trim(RIF_LEGGE) ORDER BY trim(RIF_LEGGE)) as RIF_LEGGE,
    list(DISTINCT trim(DES_REA_EVE) ORDER BY trim(DES_REA_EVE)) as DES_REA_EVE,
    list(DISTINCT trim(TENT_CONS) ORDER BY trim(TENT_CONS)) as TENT_CONS,
    -- Vittime
    list(DISTINCT trim(COD_VITTIMA) ORDER BY trim(COD_VITTIMA)) as COD_VITTIME,
    count(DISTINCT COD_VITTIMA) as N_VITTIME,
    list(DISTINCT trim(SEX_VITTIMA)) FILTER (WHERE SEX_VITTIMA IS NOT NULL) as SESSO_VITTIME,
    list(DISTINCT ETA_VITTIMA) FILTER (WHERE ETA_VITTIMA IS NOT NULL) as ETA_VITTIME,
    list(DISTINCT trim(NAZIONE_NASCITA_VITTIMA)) FILTER (WHERE NAZIONE_NASCITA_VITTIMA IS NOT NULL) as NAZIONI_NASCITA_VITTIME,
    -- Denunciati
    list(DISTINCT trim(COD_DENUNCIATO) ORDER BY trim(COD_DENUNCIATO)) as COD_DENUNCIATI,
    count(DISTINCT COD_DENUNCIATO) as N_DENUNCIATI,
    list(DISTINCT trim(SESSO_DENUNCIATO)) FILTER (WHERE SESSO_DENUNCIATO IS NOT NULL) as SESSO_DENUNCIATI,
    list(DISTINCT ETA_DENUNCIATO) FILTER (WHERE ETA_DENUNCIATO IS NOT NULL) as ETA_DENUNCIATI,
    list(DISTINCT trim(NAZIONE_NASCITA_DENUNCIATO)) FILTER (WHERE NAZIONE_NASCITA_DENUNCIATO IS NOT NULL) as NAZIONI_NASCITA_DENUNCIATI,
    -- Colpiti da provvedimento
    list(DISTINCT trim(COD_COLP_DA_PROVV) ORDER BY trim(COD_COLP_DA_PROVV)) FILTER (WHERE COD_COLP_DA_PROVV IS NOT NULL) as COD_COLPITI_PROVV,
    count(DISTINCT COD_COLP_DA_PROVV) FILTER (WHERE COD_COLP_DA_PROVV IS NOT NULL) as N_COLPITI_PROVV,
    list(DISTINCT trim(SEX_COLP_PROVV)) FILTER (WHERE SEX_COLP_PROVV IS NOT NULL) as SESSO_COLPITI_PROVV,
    list(DISTINCT ETA_COLP_PROVV) FILTER (WHERE ETA_COLP_PROVV IS NOT NULL) as ETA_COLPITI_PROVV,
    list(DISTINCT trim(NAZIONE_NASCITA_COLP_PROVV)) FILTER (WHERE NAZIONE_NASCITA_COLP_PROVV IS NOT NULL) as NAZIONI_NASCITA_COLPITI_PROVV,
    -- Relazione (può essere multipla se più denunciati)
    list(DISTINCT trim(RELAZIONE_AUTORE_VITTIMA) ORDER BY trim(RELAZIONE_AUTORE_VITTIMA)) FILTER (WHERE RELAZIONE_AUTORE_VITTIMA IS NOT NULL) as RELAZIONI_AUTORE_VITTIMA,
    -- Temporale
    first(DATA_INIZIO_FATTO) as DATA_INIZIO_FATTO,
    first(DATA_FINE_FATTO) as DATA_FINE_FATTO,
    first(DATA_DENUNCIA) as DATA_DENUNCIA,
    trim(first(STATO)) as STATO,
    -- Geografico
    trim(first(REGIONE)) as REGIONE,
    trim(first(PROVINCIA)) as PROVINCIA,
    trim(first(COMUNE)) as COMUNE,
    trim(first(LUOGO_SPECIF_FATTO)) as LUOGO_SPECIF_FATTO,
    -- Altro
    trim(first(DES_OBIET)) as DES_OBIET
  FROM deduplicato
  GROUP BY PROT_SDI
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
  )
  SELECT
    trim(PROT_SDI) as PROT_SDI,
    trim(first(TENT_CONS)) as TENT_CONS,
    first(DATA_INIZIO_FATTO) as DATA_INIZIO_FATTO,
    first(DATA_FINE_FATTO) as DATA_FINE_FATTO,
    first(DATA_DENUNCIA) as DATA_DENUNCIA,
    trim(first(STATO)) as STATO,
    trim(first(REGIONE)) as REGIONE,
    trim(first(PROVINCIA)) as PROVINCIA,
    trim(first(COMUNE)) as COMUNE,
    trim(first(LUOGO_SPECIF_FATTO)) as LUOGO_SPECIF_FATTO,
    trim(first(DES_OBIET)) as DES_OBIET
  FROM deduplicato
  GROUP BY PROT_SDI
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
    trim(PROT_SDI) as PROT_SDI,
    trim(COD_VITTIMA) as COD_VITTIMA,
    trim(SEX_VITTIMA) as SEX_VITTIMA,
    ETA_VITTIMA,
    trim(NAZIONE_NASCITA_VITTIMA) as NAZIONE_NASCITA_VITTIMA
  FROM deduplicato
  WHERE COD_VITTIMA IS NOT NULL
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
    trim(PROT_SDI) as PROT_SDI,
    trim(COD_DENUNCIATO) as COD_DENUNCIATO,
    trim(SESSO_DENUNCIATO) as SESSO_DENUNCIATO,
    ETA_DENUNCIATO,
    trim(NAZIONE_NASCITA_DENUNCIATO) as NAZIONE_NASCITA_DENUNCIATO,
    trim(RELAZIONE_AUTORE_VITTIMA) as RELAZIONE_AUTORE_VITTIMA
  FROM deduplicato
  WHERE COD_DENUNCIATO IS NOT NULL
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
    trim(PROT_SDI) as PROT_SDI,
    trim(COD_COLP_DA_PROVV) as COD_COLP_DA_PROVV,
    trim(SEX_COLP_PROVV) as SEX_COLP_PROVV,
    ETA_COLP_PROVV,
    trim(NAZIONE_NASCITA_COLP_PROVV) as NAZIONE_NASCITA_COLP_PROVV
  FROM deduplicato
  WHERE COD_COLP_DA_PROVV IS NOT NULL
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
    REGIONE VARCHAR,
    PROVINCIA VARCHAR,
    COMUNE VARCHAR,
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
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

CREATE OR REPLACE TABLE denunciati (
    PROT_SDI VARCHAR,
    COD_DENUNCIATO VARCHAR,
    SESSO_DENUNCIATO VARCHAR,
    ETA_DENUNCIATO VARCHAR,
    NAZIONE_NASCITA_DENUNCIATO VARCHAR,
    RELAZIONE_AUTORE_VITTIMA VARCHAR,
    FOREIGN KEY (PROT_SDI) REFERENCES eventi(PROT_SDI)
);

CREATE OR REPLACE TABLE colpiti_provv (
    PROT_SDI VARCHAR,
    COD_COLP_DA_PROVV VARCHAR,
    SEX_COLP_PROVV VARCHAR,
    ETA_COLP_PROVV VARCHAR,
    NAZIONE_NASCITA_COLP_PROVV VARCHAR,
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
