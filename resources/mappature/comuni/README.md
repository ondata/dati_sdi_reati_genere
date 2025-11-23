# Mappatura Comuni xlsx → Istat → Shapefile → Situas

Mapping completo per associare i comuni del file `data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx` a:

- Codici Istat ufficiali
- Geometrie shapefile
- Dati demografici/territoriali situas

## Files principali

### Mapping finali

- **`mapping_completo_xlsx_istat_shp_situas.csv`**: mapping completo con geometrie e popolazione (1222 comuni)
- **`mapping_completo.csv`**: mapping base xlsx → Istat (1222 comuni)

### Script riproducibili

- **`create_mapping.sh`**: Goal 1 - mapping comuni xlsx → PRO_COM Istat
- **`extend_mapping_shp_situas.sh`**: Goal 2 - estensione con shapefile e situas

### Supporto

- **`mapping_regioni.csv`**: mapping COD_REG → nome REGIONE

## Utilizzo

### Script pulisci_dataset.sh

Il mapping viene usato automaticamente in `scripts/pulisci_dataset.sh` per generare codici geografici in `data/processed/relazionale_eventi.csv`:

```sql
-- Join semplificato (riga 192-194)
LEFT JOIN mapping_comuni m
  ON UPPER(trim(d.REGIONE)) = UPPER(m.regione_xlsx)
  AND UPPER(trim(d.COMUNE)) = UPPER(m.comune_xlsx)
```

### Associare eventi xlsx a geometrie

```bash
# Join eventi con mapping per ottenere PRO_COM_shp
mlr --csv join -f resources/mappature/comuni/mapping_completo_xlsx_istat_shp_situas.csv \
  -j REGIONE,COMUNE \
  -l regione_xlsx,comune_xlsx \
  data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx
```

### Query DuckDB con popolazione

```sql
-- Join con mapping per aggiungere popolazione
SELECT
  e.*,
  m.POP_RES,
  m.AREA_KMQ
FROM read_csv('data/processed/relazionale_eventi.csv') e
LEFT JOIN read_csv('resources/mappature/comuni/mapping_completo_xlsx_istat_shp_situas.csv') m
  ON e.REGIONE = m.regione_xlsx
  AND e.COMUNE = m.comune_xlsx
```

## Struttura mapping completo

Campi in `mapping_completo_xlsx_istat_shp_situas.csv`:

**Dati xlsx originali:**

- `regione_xlsx`, `comune_xlsx`

**Dati Istat:**

- `regione_istat`, `comune_istat`
- `PRO_COM`, `PRO_COM_T`
- `COD_PROV_STORICO`, `SIGLA_AUTOMOBILISTICA`

**Dati shapefile:**

- `PRO_COM_shp`, `PRO_COM_T_shp`
- `COMUNE_shp`, `COMUNE_A_shp`
- `COD_PROV_shp`, `COD_REG_shp`

**Dati situas popolazione/territorio:**

- `POP_LEG`, `POP_RES`, `ANNO_POP_RES`
- `AREA_KMQ`, `ANNO_AREA`
- `ANNO_CENSIMENTO`

**Metadati:**

- `note_mapping`: tipo mapping (exact_match, manual_apostrofo, manual_nome_bilingue, ecc.)
- `join_method_shp`: metodo join shapefile (join_pro_com, join_nome_sardegna)

## Statistiche

- Comuni totali: 1222
- Mappati automaticamente: 1181 (96.6%)
- Mappati manualmente: 41 (3.4%)
- Con geometrie shapefile: 1222 (100%)
- Con dati popolazione situas: 1222 (100%)

### Join shapefile

- Su PRO_COM: 1193 comuni
- Su nome (Sardegna): 29 comuni

## Casi speciali

### Sardegna

29 comuni sardi usano join su nome invece di PRO_COM per la riforma province 2016:

- Situas usa province storiche (VS, CA, CI, OT)
- Shapefile usa province attuali (111, 092, 090)

### Tipologie mapping manuale (41 comuni)

- Apostrofi: 19 (`CANTU'` → `Cantù`)
- Nomi bilingue: 13 (`BOLZANO` → `Bolzano/Bozen`)
- Altri: 9 (grafia, nomi ufficiali diversi, ecc.)

## Documentazione completa

Vedi `tasks/check_nomi/prd_check_nomi_comuni.md` per:

- Obiettivo finale
- Strategia Goal 1 + Goal 2
- Descrizione completa files
- Dettagli implementazione
