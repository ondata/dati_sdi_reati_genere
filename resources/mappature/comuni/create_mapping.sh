#!/bin/bash
# Crea mapping completo comuni xlsx -> Istat
# Gestisce apostrofi, nomi bilingue, trattini

set -e
cd /home/aborruso/git/dati_sdi_reati_genere

echo "=== CREAZIONE MAPPING COMUNI XLSX -> ISTAT ==="

# Step 1: Match esatti (già fatto, 1181 comuni)
duckdb -c "
CREATE TEMP TABLE comuni_xlsx AS
SELECT
  TRIM(REGIONE) as regione_xlsx,
  TRIM(COMUNE) as comune_xlsx,
  LOWER(TRIM(REGIONE)) as regione_norm,
  LOWER(TRIM(COMUNE)) as comune_norm
FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/regione_comune_xlsx.csv');

CREATE TEMP TABLE comuni_istat AS
SELECT
  TRIM(r.REGIONE) as regione_istat,
  TRIM(c.COMUNE) as comune_istat,
  LOWER(TRIM(r.REGIONE)) as regione_norm,
  LOWER(TRIM(c.COMUNE)) as comune_norm,
  c.PRO_COM,
  c.PRO_COM_T,
  c.COD_PROV_STORICO,
  c.SIGLA_AUTOMOBILISTICA
FROM read_csv('tasks/nomi_geo_istat/data/dimensioni_comuni_situas.csv') c
JOIN read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_regioni.csv') r
  ON c.COD_REG = r.COD_REG;

-- Match esatti
COPY (
  SELECT
    x.regione_xlsx,
    x.comune_xlsx,
    i.regione_istat,
    i.comune_istat,
    i.PRO_COM,
    i.PRO_COM_T,
    i.COD_PROV_STORICO,
    i.SIGLA_AUTOMOBILISTICA,
    'exact_match' as note
  FROM comuni_xlsx x
  JOIN comuni_istat i
    ON x.regione_norm = i.regione_norm
    AND x.comune_norm = i.comune_norm
  ORDER BY x.regione_xlsx, x.comune_xlsx
) TO 'tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_exact.csv' (HEADER);
"

echo "Match esatti: $(tail -n +2 tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_exact.csv | wc -l)"

# Step 2: Crea mapping manuale per i 41 casi rimanenti
cat > tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_manual.csv << 'EOF'
regione_xlsx,comune_xlsx,comune_istat,note
ABRUZZO,CITTA' SANT'ANGELO,Città Sant'Angelo,apostrofo
CALABRIA,CIRO' MARINA,Cirò Marina,apostrofo
CALABRIA,IONADI,Jonadi,grafia
CALABRIA,MONTEBELLO IONICO,Montebello Jonico,grafia
CALABRIA,REGGIO CALABRIA,Reggio di Calabria,nome_ufficiale
EMILIA ROMAGNA,FORLI',Forlì,apostrofo
EMILIA ROMAGNA,REGGIO EMILIA,Reggio nell'Emilia,nome_ufficiale
FRIULI VENEZIA GIULIA,LIGNANO-SABBIADORO,Lignano Sabbiadoro,trattino
FRIULI VENEZIA GIULIA,SAN DORLIGO DELLA VALLE,San Dorligo della Valle-Dolina,nome_bilingue
FRIULI VENEZIA GIULIA,TERZO DI AQUILEIA,Terzo d'Aquileia,apostrofo
LIGURIA,RICCO' DEL GOLFO DI SPEZIA,Riccò del Golfo di Spezia,apostrofo
LOMBARDIA,CANTU',Cantù,apostrofo
LOMBARDIA,GAMBOLO',Gambolò,apostrofo
LOMBARDIA,MUGGIO',Muggiò,apostrofo
LOMBARDIA,OSPITALETTO BRESCIANO,Ospitaletto,nome_semplificato
LOMBARDIA,PUEGNAGO SUL GARDA,Puegnago del Garda,preposizione
LOMBARDIA,SALO',Salò,apostrofo
LOMBARDIA,VILLA D'ALME',Villa d'Almè,apostrofo
PIEMONTE,SAN MICHELE MONDOVI',San Michele Mondovì,apostrofo
PIEMONTE,VIU',Viù,apostrofo
SARDEGNA,NUGHEDU DI SAN NICOLO',Nughedu San Nicolò,apostrofo
SICILIA,CANICATTI',Canicattì,apostrofo
TOSCANA,CASTELFRANCO PIANDISCO',Castelfranco Piandiscò,apostrofo
TRENTINO ALTO ADIGE,APPIANO SULLA STRADA DEL VINO,Appiano sulla strada del vino/Eppan an der Weinstraße,nome_bilingue
TRENTINO ALTO ADIGE,BOLZANO,Bolzano/Bozen,nome_bilingue
TRENTINO ALTO ADIGE,BRENNERO,Brennero/Brenner,nome_bilingue
TRENTINO ALTO ADIGE,CASTELBELLO CIARDES,Castelbello-Ciardes/Kastelbell-Tschars,nome_bilingue
TRENTINO ALTO ADIGE,DOBBIACO,Dobbiaco/Toblach,nome_bilingue
TRENTINO ALTO ADIGE,LAGUNDO,Lagundo/Algund,nome_bilingue
TRENTINO ALTO ADIGE,MERANO,Merano/Meran,nome_bilingue
TRENTINO ALTO ADIGE,MOSO IN PASSIRIA,Moso in Passiria/Moos in Passeier,nome_bilingue
TRENTINO ALTO ADIGE,RASUN ANTERSELVA,Rasun-Anterselva/Rasen-Antholz,nome_bilingue
TRENTINO ALTO ADIGE,ULTIMO,Ultimo/Ulten,nome_bilingue
TRENTINO ALTO ADIGE,VALLE AURINA,Valle Aurina/Ahrntal,nome_bilingue
TRENTINO ALTO ADIGE,VILLABASSA,Villabassa/Niederdorf,nome_bilingue
UMBRIA,CITTA' DELLA PIEVE,Città della Pieve,apostrofo
VALLE D'AOSTA,VERRES,Verrès,accento
VENETO,ERBE',Erbè,apostrofo
VENETO,FOSSO',Fossò,apostrofo
VENETO,MASERA' DI PADOVA,Maserada sul Piave,nome_diverso
VENETO,SCORZE',Scorzè,apostrofo
EOF

echo "Mappinmanuali aggiunti: 41"

# Step 3: Join mapping manuale con dati Istat
duckdb -c "
CREATE TEMP TABLE mapping_manual AS
SELECT * FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_manual.csv');

CREATE TEMP TABLE comuni_istat AS
SELECT
  TRIM(r.REGIONE) as regione_istat,
  TRIM(c.COMUNE) as comune_istat,
  c.PRO_COM,
  c.PRO_COM_T,
  c.COD_PROV_STORICO,
  c.SIGLA_AUTOMOBILISTICA
FROM read_csv('tasks/nomi_geo_istat/data/dimensioni_comuni_situas.csv') c
JOIN read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_regioni.csv') r
  ON c.COD_REG = r.COD_REG;

COPY (
  SELECT
    m.regione_xlsx,
    m.comune_xlsx,
    m.regione_xlsx as regione_istat,
    i.comune_istat,
    i.PRO_COM,
    i.PRO_COM_T,
    i.COD_PROV_STORICO,
    i.SIGLA_AUTOMOBILISTICA,
    'manual_' || m.note as note
  FROM mapping_manual m
  JOIN comuni_istat i
    ON m.regione_xlsx = i.regione_istat
    AND m.comune_istat = i.comune_istat
  ORDER BY m.regione_xlsx, m.comune_xlsx
) TO 'tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_manual_complete.csv' (HEADER);
"

# Step 4: Unisci tutti i mapping
duckdb -c "
COPY (
  SELECT * FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_exact.csv')
  UNION ALL
  SELECT * FROM read_csv('tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_manual_complete.csv')
  ORDER BY regione_xlsx, comune_xlsx
) TO 'tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo.csv' (HEADER);
"

echo
echo "=== MAPPING COMPLETO CREATO ==="
echo "File: tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo.csv"
echo "Totale comuni mappati: $(tail -n +2 tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo.csv | wc -l)"
echo
echo "Statistiche per tipo:"
mlr --csv --from tmp/check_nomi/goal_1_mapping_comuni_istat/mapping_completo.csv \
  stats1 -a count -f note -g note
