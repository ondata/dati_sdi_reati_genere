#!/bin/bash
# Estende mapping Goal 1 con dati shapefile e situas
# Gestisce riforma province Sardegna (join su nome comune per Sardegna)

set -e
cd /home/aborruso/git/dati_sdi_reati_genere

echo "=== ESTENSIONE MAPPING CON SHAPEFILE E SITUAS ==="

# Step 1: Join mapping con shapefile
# Per Sardegna join su COMUNE (lowercase), altri su PRO_COM
duckdb -c "
INSTALL spatial; LOAD spatial;

CREATE TEMP TABLE mapping AS
SELECT
  regione_xlsx,
  comune_xlsx,
  regione_istat,
  comune_istat,
  PRO_COM,
  PRO_COM_T,
  COD_PROV_STORICO,
  SIGLA_AUTOMOBILISTICA,
  note,
  LOWER(TRIM(comune_istat)) as comune_norm
FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo.csv');

CREATE TEMP TABLE shp AS
SELECT
  PRO_COM as PRO_COM_shp,
  PRO_COM_T as PRO_COM_T_shp,
  TRIM(COMUNE) as COMUNE_shp,
  TRIM(COMUNE_A) as COMUNE_A_shp,
  COD_PROV as COD_PROV_shp,
  COD_REG as COD_REG_shp,
  LOWER(TRIM(COMUNE)) as comune_shp_norm
FROM st_read('data/geo/Com01012025_g/Com01012025_g_WGS84.shp');

-- Join: Sardegna su nome, altri su PRO_COM
COPY (
  SELECT
    m.*,
    s.PRO_COM_shp,
    s.PRO_COM_T_shp,
    s.COMUNE_shp,
    s.COMUNE_A_shp,
    s.COD_PROV_shp,
    s.COD_REG_shp,
    CASE
      WHEN m.regione_xlsx = 'SARDEGNA' THEN 'join_nome_sardegna'
      ELSE 'join_pro_com'
    END as join_method_shp
  FROM mapping m
  LEFT JOIN shp s
    ON (
      -- Sardegna: join su nome normalizzato
      (m.regione_xlsx = 'SARDEGNA' AND m.comune_norm = s.comune_shp_norm)
      OR
      -- Altri: join su PRO_COM
      (m.regione_xlsx != 'SARDEGNA' AND m.PRO_COM = s.PRO_COM_shp)
    )
  ORDER BY m.regione_xlsx, m.comune_xlsx
) TO 'tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_con_shp.csv' (HEADER);
"

echo "Mapping con shapefile creato"

# Step 2: Join con situas (sempre su PRO_COM situas, non shp)
duckdb -c "
CREATE TEMP TABLE mapping_shp AS
SELECT * FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_con_shp.csv');

CREATE TEMP TABLE situas AS
SELECT
  PRO_COM as PRO_COM_situas,
  COMUNE as COMUNE_situas,
  POP_LEG,
  ANNO_CENSIMENTO,
  AREA_KMQ,
  ANNO_AREA,
  POP_RES,
  ANNO_POP_RES
FROM read_csv('tasks/nomi_geo_istat/data/dimensioni_comuni_situas.csv');

-- Join su PRO_COM (del mapping originale, non dello shp)
COPY (
  SELECT
    m.regione_xlsx,
    m.comune_xlsx,
    m.regione_istat,
    m.comune_istat,
    m.PRO_COM,
    m.PRO_COM_T,
    m.COD_PROV_STORICO,
    m.SIGLA_AUTOMOBILISTICA,
    m.PRO_COM_shp,
    m.PRO_COM_T_shp,
    m.COMUNE_shp,
    m.COMUNE_A_shp,
    m.COD_PROV_shp,
    m.COD_REG_shp,
    s.POP_LEG,
    s.ANNO_CENSIMENTO,
    s.AREA_KMQ,
    s.ANNO_AREA,
    s.POP_RES,
    s.ANNO_POP_RES,
    m.note as note_mapping,
    m.join_method_shp
  FROM mapping_shp m
  LEFT JOIN situas s ON m.PRO_COM = s.PRO_COM_situas
  ORDER BY m.regione_xlsx, m.comune_xlsx
) TO 'tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo_xlsx_istat_shp_situas.csv' (HEADER);
"

echo
echo "=== MAPPING COMPLETO CREATO ==="
echo "File: tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo_xlsx_istat_shp_situas.csv"

# Verifica copertura
echo
echo "=== VERIFICA COPERTURA ==="
duckdb -c "
SELECT
  COUNT(*) as totale_comuni,
  COUNT(CASE WHEN PRO_COM_shp IS NOT NULL THEN 1 END) as con_shp,
  COUNT(CASE WHEN POP_RES IS NOT NULL THEN 1 END) as con_situas,
  COUNT(CASE WHEN PRO_COM_shp IS NULL THEN 1 END) as senza_shp,
  COUNT(CASE WHEN POP_RES IS NULL THEN 1 END) as senza_situas
FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo_xlsx_istat_shp_situas.csv');
"

echo
echo "Statistiche join method shapefile:"
mlr --csv --from tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo_xlsx_istat_shp_situas.csv \
  stats1 -a count -f join_method_shp -g join_method_shp
