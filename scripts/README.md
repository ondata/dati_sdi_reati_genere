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

Script completo che risolve i problemi di qualità dei dati SDI e genera dataset arricchiti con codici geografici e internazionali.

**Problemi risolti:**

1. **Duplicati esatti completi** (49.4% delle righe nel dataset originale)
2. **Prodotto cartesiano** denunciati × colpiti da provvedimento
3. **Nomi comuni con caratteri speciali** (es. apostrofi non standard)
4. **Assenza codici ISTAT** per comuni non matchati direttamente
5. **Assenza codici ISO** per nazioni di nascita

**Pipeline di elaborazione (7 step):**

**STEP 1-3:** Generazione output base
- Prodotto cartesiano dedupplicato
- Dataset con array aggregati
- Modello relazionale (5 tabelle CSV)

**STEP 4:** Creazione database DuckDB relazionale

**STEP 5:** Statistiche finali

**STEP 6:** Fuzzy matching comuni mancanti
- Estrae comuni senza codice ISTAT da `relazionale_eventi.csv`
- Esegue fuzzy matching con tabella ISTAT (threshold ≥95%, algoritmo Levenshtein)
- Tool: `csvmatch`
- Output: `scripts/tmp/fuzzy_match_comuni.csv`

**STEP 7:** Aggiornamento dataset con comuni matchati
- Aggiorna nomi comuni con forma corretta ISTAT (es. `SALO'` → `Salò`)
- Aggiunge codici ISTAT ai comuni matchati
- Applica correzioni a tutti i dataset CSV e al database DuckDB

**File generati:**

1. **Dataset Cartesiano** - `data/processed/dataset_cartesiano.csv`
   - Prodotto cartesiano dedupplicato non aggregato
   - Include `CODICE_COMUNE` (aggiunto da fuzzy matching)

2. **Dataset Array** - `data/processed/dataset_array.csv`
   - 1 riga = 1 evento con array per soggetti multipli
   - Include `CODICE_COMUNE` (aggiunto da fuzzy matching)

3. **Modello Relazionale** - `data/processed/relazionale_*.csv`
   - `relazionale_eventi.csv`: eventi con codici ISTAT geografici
   - `relazionale_reati.csv`: reati associati
   - `relazionale_vittime.csv`: vittime con `NAZIONE_NASCITA_VITTIMA_ISO`
   - `relazionale_denunciati.csv`: denunciati con `NAZIONE_NASCITA_DENUNCIATO_ISO`
   - `relazionale_colpiti_provv.csv`: colpiti con `NAZIONE_NASCITA_COLP_PROVV_ISO`

4. **Database DuckDB** - `data/processed/reati_sdi_relazionale.duckdb`
   - Database relazionale con foreign keys
   - Indici per performance
   - Tabelle con codici ISO e ISTAT

**Arricchimenti dati:**

- **Codici ISTAT**: regioni, province, comuni (con fuzzy matching ≥95%)
- **Codici ISO 3166-1 alpha-3**: stati di nascita (105 stati mappati)
- **Normalizzazione nomi**: 19 comuni corretti (apostrofi e caratteri speciali)

**Struttura dataset relazionale:**

Tabella `eventi`:
- Identificazione: `PROT_SDI` (primary key)
- Temporale: `DATA_INIZIO_FATTO`, `DATA_FINE_FATTO`, `DATA_DENUNCIA`
- Geografica: `STATO`, `STATO_ISO`, `REGIONE`, `CODICE_REGIONE`, `PROVINCIA`, `CODICE_PROVINCIA`, `COMUNE`, `CODICE_COMUNE`
- Luogo: `LUOGO_SPECIF_FATTO`, `DES_OBIET`

Tabelle soggetti (con foreign key su `PROT_SDI`):
- `vittime`: `COD_VITTIMA`, `SEX_VITTIMA`, `ETA_VITTIMA`, `NAZIONE_NASCITA_VITTIMA`, `NAZIONE_NASCITA_VITTIMA_ISO`
- `denunciati`: `COD_DENUNCIATO`, `SESSO_DENUNCIATO`, `ETA_DENUNCIATO`, `NAZIONE_NASCITA_DENUNCIATO`, `NAZIONE_NASCITA_DENUNCIATO_ISO`, `RELAZIONE_AUTORE_VITTIMA`
- `colpiti_provv`: `COD_COLP_DA_PROVV`, `SEX_COLP_PROVV`, `ETA_COLP_PROVV`, `NAZIONE_NASCITA_COLP_PROVV`, `NAZIONE_NASCITA_COLP_PROVV_ISO`
- `reati`: `ART`, `T_NORMA`, `RIF_LEGGE`, `DES_REA_EVE`

**Come usarlo:**

```bash
bash scripts/pulisci_dataset.sh
```

**Statistiche output:**

- **2.644 eventi unici** (da 5.124 righe originali)
- **19 comuni corretti** tramite fuzzy matching (100% successo)
- **105 stati mappati** con codici ISO alpha-3
- **100% copertura ISO** per nazioni specificate

**Vantaggi:**

1. Dati geografici completi (ISTAT + fuzzy matching)
2. Codici ISO internazionali per analisi comparative
3. 3 formati output per diverse esigenze analitiche
4. Database relazionale ottimizzato per query SQL
5. Nomi normalizzati secondo standard ISTAT

**Query esempio:**

```sql
-- Eventi per nazione di nascita vittima (top 10)
SELECT
  NAZIONE_NASCITA_VITTIMA,
  NAZIONE_NASCITA_VITTIMA_ISO,
  COUNT(*) as n_vittime
FROM vittime
GROUP BY 1, 2
ORDER BY n_vittime DESC
LIMIT 10;

-- Comuni corretti da fuzzy matching
SELECT e.*
FROM eventi e
WHERE e.COMUNE IN (
  SELECT COMUNE_ISTAT
  FROM read_csv('scripts/tmp/fuzzy_match_comuni.csv')
  WHERE CODICE_COMUNE IS NOT NULL
);

-- Join eventi con vittime (modello relazionale)
SELECT
  e.REGIONE,
  e.PROVINCIA,
  e.COMUNE,
  v.NAZIONE_NASCITA_VITTIMA,
  v.NAZIONE_NASCITA_VITTIMA_ISO
FROM eventi e
INNER JOIN vittime v ON e.PROT_SDI = v.PROT_SDI
WHERE v.NAZIONE_NASCITA_VITTIMA != 'ITALIA';
```

**Requisiti tecnici:**

- DuckDB (con supporto spatial per `st_read`)
- Python 3 (per parsing JSON statistiche)
- csvmatch (per fuzzy matching comuni)
- mlr (Miller, per rinomina colonne)

**File di risorse richiesti:**

- `resources/unita_territoriali_istat.csv`: codici ISTAT ufficiali
- `resources/codici_stati.csv`: mappatura stati → ISO alpha-3 (105 stati)
