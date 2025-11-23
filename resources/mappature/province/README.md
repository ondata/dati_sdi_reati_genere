# Mapping Province

Questa cartella contiene i file di mappatura tra i nomi delle province presenti nei file Excel del Ministero dell'Interno e i codici/nomi ufficiali ISTAT e shapefile.

## File presenti

### `mapping_province_xlsx_istat.csv`

Mapping base tra nomi province Excel e dati ISTAT.

**Colonne**:

- `provincia_xlsx`: nome provincia come appare nel file `data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx`
- `provincia_istat`: nome ufficiale ISTAT
- `cod_prov_storico`: codice provincia ISTAT storico
- `sigla`: sigla automobilistica
- `note`: indica se il mapping è stato fatto manualmente

**Copertura**: 106 province (100%)

**Differenze mappate** (6 province con nomi diversi):

- AOSTA → Valle d'Aosta/Vallée d'Aoste
- BOLZANO → Bolzano/Bozen
- FORLI' CESENA → Forlì-Cesena
- MASSA CARRARA → Massa-Carrara
- REGGIO EMILIA → Reggio nell'Emilia
- VERBANIA → Verbano-Cusio-Ossola

### `mapping_province_xlsx_istat_shp.csv`

Mapping completo tra province Excel, ISTAT e shapefile.

**Colonne**:

- `provincia_xlsx`: nome provincia Excel
- `provincia_istat`: nome ufficiale ISTAT
- `cod_prov_storico`: codice provincia ISTAT
- `sigla`: sigla automobilistica ISTAT
- `den_uts_shp`: denominazione UTS nello shapefile
- `den_prov_shp`: denominazione provincia nello shapefile
- `cod_prov_shp`: codice provincia shapefile
- `sigla_shp`: sigla shapefile
- `tipo_uts`: tipo unità territoriale (Provincia, Città metropolitana, Libero consorzio)
- `note_istat`: note sul mapping ISTAT
- `note_shp`: note sul mapping shapefile

**Copertura**: 106 province (100%)

**Shapefile di riferimento**: `data/geo/ProvCM01012025_g/ProvCM01012025_g_WGS84.shp`

### `mapping_province_completo.csv`

Mapping arricchito con informazioni regionali, usato da `scripts/etl_5.sh`.

**Colonne**:

- `provincia`: nome provincia Excel (chiave di join)
- `provincia_uts`: nome ufficiale ISTAT
- `codice_provinciauts`: codice UTS ISTAT
- `codice_provincia_storico`: codice provincia storico
- `codice_regione`: codice regione ISTAT
- `regione`: nome regione
- `ripartizione_geografica`: ripartizione geografica (Nord-ovest, Nord-est, Centro, Sud, Isole)
- `sigla_automobilistica`: sigla provincia
- `provinciauts_corretto`: nome normalizzato
- `codice_ripartizione_geografica`: codice ripartizione (1-5)

**Copertura**: 106 province (100%)

### `mapping_province_con_popolazione.csv`

Mapping completo arricchito con dati popolazione e territorio 2023.

**Colonne aggiuntive** (oltre a quelle di `mapping_province_completo.csv`):

- `popolazione_residente`: popolazione residente 2023 (fonte ISTAT)
- `anno_popolazione`: anno di riferimento dati popolazione (2023)
- `area_kmq`: superficie provincia in km²
- `numero_comuni`: numero comuni nella provincia

**Copertura**: 106 province (100%)

**Uso consigliato**: calcolo tassi per 100k abitanti, densità, analisi territoriali

## Come sono stati generati

I file di mapping sono stati creati tramite un processo di analisi e validazione documentato in `tasks/check_nomi/prd_check_nomi.md`:

### Goal 1: Mapping province xlsx → ISTAT

1. **Estrazione province da Excel**: script `extract_province.py` estrae nomi unici da tutti i fogli
2. **Confronto con ISTAT**: script `check_province.py` confronta con `tasks/nomi_geo_istat/data/comuni_con_provincia.csv`
3. **Mapping manuale**: 6 province con nomi diversi mappate manualmente
4. **Validazione**: 106/106 province mappate correttamente (100%)

Output: `mapping_province_xlsx_istat.csv`

### Goal 2: Allineamento con shapefile

1. **Estrazione da shapefile**: script `compare_xlsx_shp.py` estrae province da `data/geo/ProvCM01012025_g/ProvCM01012025_g_WGS84.shp`
2. **Confronto xlsx-shp**: 4 province con nomi diversi identificate
3. **Mapping unificato**: script `create_mapping_completo.py` crea mapping xlsx→istat→shp
4. **Validazione**: 106/106 province mappate (100%)

Output: `mapping_province_xlsx_istat_shp.csv`

### Arricchimento con dati regionali

1. **Join con anagrafica ISTAT**: usa `resources/unita_territoriali_istat.csv`
2. **Aggiunta regioni e ripartizioni**: join su `codice_provincia_storico`
3. **Normalizzazione colonne**: riordino per compatibilità con ETL

Output: `mapping_province_completo.csv`

**Script DuckDB per `mapping_province_completo.csv`**:

```bash
duckdb -csv -c "
WITH mapping AS (
  SELECT * FROM read_csv('mapping_province_xlsx_istat_shp.csv', auto_detect=true)
),
unita AS (
  SELECT DISTINCT
    codice_provincia_storico,
    codice_provinciauts,
    codice_regione,
    regione,
    ripartizione_geografica,
    codice_ripartizione_geografica
  FROM read_csv('resources/unita_territoriali_istat.csv', auto_detect=true)
)
SELECT
  m.provincia_xlsx as provincia,
  m.provincia_istat as provincia_uts,
  u.codice_provinciauts,
  m.cod_prov_storico as codice_provincia_storico,
  u.codice_regione,
  u.regione,
  u.ripartizione_geografica,
  m.sigla as sigla_automobilistica,
  m.provincia_xlsx as provinciauts_corretto,
  u.codice_ripartizione_geografica
FROM mapping m
LEFT JOIN unita u ON m.cod_prov_storico = u.codice_provincia_storico
ORDER BY m.provincia_xlsx
" > mapping_province_completo.csv
```

**Script DuckDB per `mapping_province_con_popolazione.csv`**:

```bash
duckdb -csv -c "
WITH mapping AS (
  SELECT * FROM read_csv('mapping_province_completo.csv', auto_detect=true)
),
pop AS (
  SELECT
    CAST(COD_PROV_STORICO AS INT) as cod_prov_storico,
    CAST(POP_RES AS DOUBLE) as popolazione_residente,
    CAST(ANNO_POP_RES AS INT) as anno_popolazione,
    CAST(REPLACE(AREA_KMQ, ',', '.') AS DOUBLE) as area_kmq,
    CAST(N_COM AS INT) as numero_comuni
  FROM read_csv('tasks/nomi_geo_istat/data/dimensioni_province_situas.csv', auto_detect=true)
)
SELECT
  m.*,
  p.popolazione_residente,
  p.anno_popolazione,
  p.area_kmq,
  p.numero_comuni
FROM mapping m
LEFT JOIN pop p ON m.codice_provincia_storico = p.cod_prov_storico
ORDER BY m.provincia
" > mapping_province_con_popolazione.csv
```

## Utilizzo in ETL

Il file `mapping_province_completo.csv` è usato in `scripts/etl_5.sh` (FASE 4) per normalizzare i nomi delle province:

```bash
# Estrae province uniche dai dati SDI
mlr --inidx --ocsv --ifs tab uniq -a then skip-trivial-records then label provincia \
  "${folder}"/tmp/province.txt | grep -viP "non localizzata" > province_sdi.csv

# Join diretto con mapping completo
mlr --csv join -u -j provincia -f province_sdi.csv \
  resources/mappature/province/mapping_province_completo.csv \
  > resources/province_sdi_istat.csv
```

Questo sostituisce il processo precedente di 6+ operazioni (fuzzy match, join multipli, correzioni manuali).

## Note metodologiche

- **Province Sardegna soppresse**: le province Carbonia-Iglesias, Medio Campidano, Ogliastra, Olbia-Tempio non compaiono nel file Excel (probabilmente dati antecedenti al 2016)
- **Sud Sardegna**: presente nello shapefile ma non nel file Excel
- **NON LOCALIZZATA**: valore escluso dal mapping (non rappresenta una provincia geografica)
- **Validazione**: tutti i mapping sono stati verificati al 100% tramite confronto con fonti ufficiali ISTAT

## Manutenzione

Per aggiornare i mapping:

1. Modificare `mapping_province_xlsx_istat_shp.csv` con nuove corrispondenze
2. Rigenerare `mapping_province_completo.csv` con lo script DuckDB sopra
3. Rigenerare `mapping_province_con_popolazione.csv` con lo script DuckDB sopra (se cambia popolazione)
4. Verificare con: `mlr --csv stats1 -a count -g provincia mapping_province_completo.csv`
5. Testare ETL: `bash scripts/etl_5.sh`
6. Testare script Python: `python3 tasks/marta/outputs/grafici_panoramica_reati.py`

## Riferimenti

- Analisi completa: `tasks/check_nomi/prd_check_nomi.md`
- Script generazione: `tmp/check_nomi/goal_1_mapping_istat/` e `tmp/check_nomi/goal_2_allineamento_shp/`
- Anagrafica ISTAT: `resources/unita_territoriali_istat.csv`
- Shapefile province: `data/geo/ProvCM01012025_g/ProvCM01012025_g_WGS84.shp`
