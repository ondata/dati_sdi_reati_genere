# Script di Elaborazione Dati SDI

## Panoramica rapida

- `etl_5.sh`: estrae i dieci fogli tematici del file `MI-123-U-A-SD-2025-90_5.xlsx`, applica pulizia (righe vuote, asterischi) e normalizza le serie temporali e, quando presenti, i campi per genere. Esegue tutte le elaborazioni in `data/processing/comunicazioni_sdi/`. Avvio: `bash scripts/etl_5.sh`.
- `etl_6.sh`: *(deprecato, sostituito da `pulisci_dataset.sh`)* - caricava il foglio unico di `MI-123-U-A-SD-2025-90_6.xlsx` con correzione nomi e codici ISTAT.
- `pulisci_dataset.sh`: **versione migliorata ed estesa di etl_6.sh** - carica il foglio unico di `MI-123-U-A-SD-2025-90_6.xlsx`, corregge nomi province/comuni, aggiunge codici ISTAT e risolve i problemi di qualità dati (duplicati e prodotto cartesiano). Genera dataset pulito con 1 riga = 1 evento. Avvio: `bash scripts/pulisci_dataset.sh`.

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

## etl_6.sh *(deprecato)*

> **⚠️ Questo script è stato sostituito da `pulisci_dataset.sh` che offre funzionalità migliorate e risolve i problemi di qualità dei dati.**

Script originale che caricava il file `MI-123-U-A-SD-2025-90_6.xlsx` e applicava correzioni base (nomi province/comuni, codici ISTAT).

**Perché è stato sostituito:**

Non gestiva i problemi critici di qualità dati:
- Duplicati esatti (49.4% delle righe)
- Prodotto cartesiano denunciati × colpiti da provvedimento

**Usa invece:** `pulisci_dataset.sh` (vedi sezione successiva)

---

## pulisci_dataset.sh

Script che risolve i problemi di qualità identificati nel dataset SDI delle comunicazioni con relazione vittima-autore.

**Problemi risolti:**

1. **Duplicati esatti completi** (49.4% delle righe nel dataset originale)
2. **Prodotto cartesiano** denunciati × colpiti da provvedimento

**Cosa fa:**

- Rimuove duplicati esatti usando `SELECT DISTINCT`
- Aggrega i dati per evento (`PROT_SDI`) eliminando il prodotto cartesiano
- Converte campi multipli (denunciati, vittime, colpiti) in array
- Genera conteggi affidabili per ogni tipologia di soggetto

**File generati:**

- `data/processed/dataset_pulito.csv` - Dataset pulito (1 riga = 1 evento)
- `data/processed/pulizia_log.txt` - Log delle operazioni di pulizia

**Struttura dataset pulito:**

Ogni riga rappresenta un evento unico identificato da `PROT_SDI`. I soggetti multipli sono aggregati in array:

- `COD_VITTIME`, `N_VITTIME`, `SESSO_VITTIME`, `ETA_VITTIME`
- `COD_DENUNCIATI`, `N_DENUNCIATI`, `SESSO_DENUNCIATI`, `ETA_DENUNCIATI`
- `COD_COLPITI_PROVV`, `N_COLPITI_PROVV`
- `RELAZIONI_AUTORE_VITTIMA`

**Come usarlo:**

```bash
bash scripts/pulisci_dataset.sh
```

**Vantaggi:**

1. 1 riga = 1 evento (granularità chiara)
2. Conteggi affidabili (`count(*)` = numero eventi reali)
3. Relazioni preservate (tutti i soggetti in array)
4. Riduzione ~48% righe senza perdita informazioni
5. Analisi corrette senza doppi conteggi

**Query esempio:**

```sql
-- Conteggio eventi per regione
SELECT REGIONE, count(*) as n_eventi
FROM read_csv('data/processed/dataset_pulito.csv')
GROUP BY REGIONE
ORDER BY n_eventi DESC;

-- Eventi con vittime multiple
SELECT PROT_SDI, N_VITTIME, N_DENUNCIATI
FROM read_csv('data/processed/dataset_pulito.csv')
WHERE N_VITTIME > 1
ORDER BY N_VITTIME DESC;

-- Unnest array vittime
SELECT PROT_SDI, unnest(COD_VITTIME) as cod_vittima
FROM read_csv('data/processed/dataset_pulito.csv');
```

**Requisiti tecnici:**

- DuckDB (con supporto spatial per `st_read`)
- Python 3 (per parsing JSON statistiche)

---

*Nota: I dati elaborati sono pronti per essere importati in strumenti di analisi come R, Python o software di business intelligence.*
