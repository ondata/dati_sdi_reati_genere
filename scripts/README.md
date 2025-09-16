# Script di Elaborazione Dati SDI

## Panoramica rapida

- `etl_5.sh`: estrae i dieci fogli tematici del file `MI-123-U-A-SD-2025-90_5.xlsx`, applica pulizia (righe vuote, asterischi) e normalizza le serie temporali e, quando presenti, i campi per genere. Esegue tutte le elaborazioni in `data/processing/comunicazioni_sdi/`. Avvio: `bash scripts/etl_5.sh`.
- `etl_6.sh`: carica il foglio unico di `MI-123-U-A-SD-2025-90_6.xlsx`, corregge i nomi di province/comuni, aggiunge i codici ISTAT tramite i file in `resources/` e salva il dataset unico in `data/processing/reati_sdi/`. Avvio: `bash scripts/etl_6.sh`.

Assicurati che `jq`, `qsv`, `mlr`, `duckdb` e `csvmatch` siano nel PATH prima di lanciare gli script.

## etl_5.sh

Script che trasforma i dati grezzi dal file `MI-123-U-A-SD-2025-90_5.xlsx` in formati utilizzabile per analisi.

**Fonte dati:**

Il file sorgente è `MI-123-U-A-SD-2025-90_5.xlsx` che contiene 10 fogli Excel con dati sui reati di genere:

- Codice Rosso commessi
- Codice Rosso segnalazioni
- Codice Rosso vittime
- Delitti commessi
- Delitti segnalazioni
- Delitti vittime
- Omicidi DCPC
- Reati spia commessi
- Reati spia segnalazioni
- Reati spia vittime

**Cosa fa:**

- Estrae automaticamente tutti i fogli dal file Excel SDI in file CSV separati
- Pulisce i dati rimuovendo righe vuote e caratteri non necessari (asterischi)
- Normalizza la struttura dei dati convertendo le colonne degli anni in righe
- Gestisce in modo specifico i dati per genere (FEMMINILE/MASCHILE) trasformandoli in formato standard
- Standardizza i nomi delle colonne per renderli compatibili con strumenti di analisi
- Aggiunge i codici Istat di province e regioni e inserisce e corregge i nomi delle province

**File generati:**

- [`codice_rosso_commessi.csv`](../data/processing/comunicazioni_sdi/codice_rosso_commessi.csv) - Reati del codice rosso effettivamente commessi
- [`codice_rosso_segnalazioni.csv`](../data/processing/comunicazioni_sdi/codice_rosso_segnalazioni.csv) - Segnalazioni per reati del codice rosso
- [`codice_rosso_vittime.csv`](../data/processing/comunicazioni_sdi/codice_rosso_vittime.csv) - Dati sulle vittime di reati del codice rosso
- [`delitti_commessi.csv`](../data/processing/comunicazioni_sdi/delitti_commessi.csv) - Delitti effettivamente commessi
- [`delitti_segnalazioni.csv`](../data/processing/comunicazioni_sdi/delitti_segnalazioni.csv) - Segnalazioni di delitti
- [`delitti_vittime.csv`](../data/processing/comunicazioni_sdi/delitti_vittime.csv) - Dati sulle vittime di delitti
- [`omicidi_dcpc.csv`](../data/processing/comunicazioni_sdi/omicidi_dcpc.csv) - Dati sugli omicidi (formato speciale)
- [`reati_spia_commessi.csv`](../data/processing/comunicazioni_sdi/reati_spia_commessi.csv) - Reati spia effettivamente commessi
- [`reati_spia_segnalazioni.csv`](../data/processing/comunicazioni_sdi/reati_spia_segnalazioni.csv) - Segnalazioni di reati spia
- [`reati_spia_vittime.csv`](../data/processing/comunicazioni_sdi/reati_spia_vittime.csv) - Dati sulle vittime di reati spia

**Requisiti tecnici:**

- `jq` - per elaborare dati JSON
- `qsv` - per manipolare file Excel e CSV
- `mlr` (Miller) - per trasformazioni complesse sui dati
- `duckdb` - per normalizzazione finale delle colonne

**Come usarlo:**

```bash
bash scripts/etl_5.sh
```

Lo script elabora automaticamente il file Excel presente in `../data/rawdata/` e salva i risultati in `../data/processing/comunicazioni_sdi/`.

---

*Nota: I dati elaborati sono pronti per essere importati in strumenti di analisi come R, Python o software di business intelligence.*
