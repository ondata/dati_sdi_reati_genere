# Intro

L'obiettivo è cambiare la logica per l'aggiunta dei nomi geografici ISTAT nel processo ETL.

Due gli script da cambiare:

- scripts/etl_5.sh
- scripts/pulisci_dataset.sh

Prima di portare tutto in produzione, fare dei test in una cartella dedicata in tmp.

Usa gli strumenti cli usati già negli script

## etl_5.sh

✅ **COMPLETATO** - 2025-11-20

Cambiato il CSV di riferimento usando tasks/nomi_geo_istat/data/dimensioni_province_situas.csv

Modifiche applicate:

- Usa dimensioni_province_situas.csv come fonte principale per i codici provincia
- Creati file di mappatura separati per regioni e sigle automobilistiche
- Mantenuta compatibilità output con versione precedente
- Corretto sorting finale: anno, provincia, delitto, descrizione_reato, eta_alla_data_del_reato_vittima

## pulisci_dataset.sh

✅ **COMPLETATO** - 2025-11-20

Per questo script invece il file di riferimento è tasks/nomi_geo_istat/data/comuni_con_provincia.csv

Modifiche applicate:

- Sostituito il file ISTAT di riferimento con `comuni_con_provincia.csv`
- Creati tre CTE separati per regioni, province e comuni per un matching più preciso
- **Implementato split automatico dei nomi bilingue** (es. "Bolzano/Bozen" → "Bolzano" e "Bozen")
  - Questo permette di matchare correttamente i comuni dell'Alto Adige/Südtirol
- **Aggiunte 6 colonne con codici e nomi ufficiali ISTAT a TUTTI i dataset**:
  - `CODICE_REGIONE`, `CODICE_PROVINCIA`, `CODICE_COMUNE`: codici ISTAT
  - `REGIONE_NOME_ISTAT`, `PROVINCIA_NOME_ISTAT`, `COMUNE_NOME_ISTAT`: nomi ufficiali ISTAT
  - Le colonne originali (REGIONE, PROVINCIA, COMUNE) mantengono i nomi dai dati SDI
  - **Dataset aggiornati**: dataset_cartesiano.csv (35 col), dataset_array.csv (38 col), relazionale_eventi.csv (18 col)
- Mantenuto il file `unita_territoriali_istat.csv` solo per i nomi delle regioni
- Aggiornato `problemi_province_sardegna.jsonl` con le nuove denominazioni delle province sarde
  - "Sud Sardegna" → "Medio Campidano" e "Sulcis Iglesiente" secondo il nuovo file ISTAT
- Risultati finali del matching:
  - Codice regione: 100.0%
  - Codice provincia: 99.76%
  - Codice comune: **98.19%** (tutti i comuni con nome specificato nei dati hanno un codice!)
  - I comuni mancanti (1.81%) sono eventi con COMUNE=NULL nei dati originali
- Aggiunta correzione per "LIGNANO-SABBIADORO" → "Lignano Sabbiadoro" in `problemi_nomi_comuni.jsonl`
- Mantenuta compatibilità con tutto il flusso ETL esistente
