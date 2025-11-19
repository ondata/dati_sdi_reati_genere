# Comunicazioni SDI - Dati Normalizzati

## Introduzione

Questa cartella contiene i dati estratti e normalizzati dal file Excel [`MI-123-U-A-SD-2025-90_5.xlsx`](../../rawdata/MI-123-U-A-SD-2025-90_5.xlsx), ottenuto tramite FOIA dal Dipartimento della Pubblica Sicurezza in risposta a richiesta di accesso civico generalizzato per dati su reati riconducibili alla violenza di genere (periodo 2019-2024). Il file originale conteneva 10 fogli con dati aggregati per provincia su diverse categorie di reati forniti in risposta a tale richiesta:

- **Delitti**: omicidi, lesioni dolose, percosse, minacce, violenze sessuali, atti persecutori, maltrattamenti, costrizione al matrimonio, deformazione aspetto, diffusione illecita immagini, violazione provvedimenti allontanamento
- **Reati spia**: delitti considerati indicatori di violenza di genere (atti persecutori, maltrattamenti, violenze sessuali) che fungono da "segnali di allarme" per situazioni a rischio
- **Codice rosso**: reati rientranti nella [legge n. 69/2019](https://www.normattiva.it/uri-res/N2Ls?urn:nir:stato:legge:2019-07-19;69) che introduce procedure urgenti per violenza domestica e di genere
- **Omicidi DCPC**: dati aggregati su omicidi totali, vittime femminili, ambito familiare

Per ogni categoria ci sono tre prospettive: Commessi, Vittime (solo femminile), Segnalazioni (autori per sesso ed età). I dati coprono il periodo 2019-2024 con struttura a colonne per anni e, per le segnalazioni, anche per sesso e fasce d'età.

Lo script ETL `scripts/etl_5.sh` trasforma questi dati in formato CSV normalizzato:

1. **Estrazione**: ogni foglio Excel diventa un file CSV separato
2. **Pulizia**: rimozione righe vuote, asterischi e normalizzazione testi
3. **Trasformazione**: conversione da formato wide a long (colonne anno → righe anno)
4. **Normalizzazione geografica**: arricchimento con codici ISTAT e informazioni territoriali
5. **Standardizzazione**: nomi colonne coerenti e ordinamento dati

Il risultato è un set di file CSV pronti per analisi statistiche e visualizzazioni, con chiavi geografiche standardizzate e struttura dati normalizzata.

## File CSV Generati

### [codice_rosso_commessi.csv](codice_rosso_commessi.csv)

Dati sui reati di codice rosso commessi per provincia e anno.

**Schema dati**:

- `anno` (integer): Anno di riferimento (2019-2024)
- `provincia` (string): Nome provincia (formato originale SDI)
- `descrizione_reato` (string): Descrizione del reato
- `provinciauts_corretto` (string): Nome provincia corretto
- `codice_regione` (integer): Codice ISTAT regione
- `codice_provincia_storico` (integer): Codice ISTAT provincia storico
- `codice_provinciauts` (integer): Codice ISTAT UTS provincia
- `ripartizione_geografica` (string): Ripartizione (Nord, Sud, Centro, Isole)
- `regione` (string): Nome regione
- `provincia_uts` (string): Nome provincia UTS ISTAT
- `flag_tipo_uts` (integer): Tipo UTS (4=Provincia, 5=Città Metropolitana)
- `sigla_automobilistica` (string): Sigla targa provincia

### [codice_rosso_segnalazioni.csv](codice_rosso_segnalazioni.csv)

Dati sulle segnalazioni di codice rosso per provincia, anno, sesso ed età della vittima.

**Schema dati**:

- `anno` (integer): Anno di riferimento (2019-2024)
- `provincia` (string): Nome provincia
- `descrizione_reato` (string): Descrizione del reato
- `eta_alla_data_del_reato_vittima` (string): Fascia d'età vittima
- `sesso` (string): Sesso vittima (FEMMINILE/MASCHILE)
- `provinciauts_corretto` (string): Nome provincia corretto
- `codice_regione` (integer): Codice ISTAT regione
- `codice_provincia_storico` (integer): Codice ISTAT provincia storico
- `codice_provinciauts` (integer): Codice ISTAT UTS provincia
- `ripartizione_geografica` (string): Ripartizione geografica
- `regione` (string): Nome regione
- `provincia_uts` (string): Nome provincia UTS ISTAT
- `flag_tipo_uts` (integer): Tipo UTS
- `sigla_automobilistica` (string): Sigla targa

### [codice_rosso_vittime.csv](codice_rosso_vittime.csv)

Dati sulle vittime di reati di codice rosso per provincia e anno.

**Schema dati**: Identico a `codice_rosso_commessi.csv`

### [delitti_commessi.csv](delitti_commessi.csv)

Dati sui delitti commessi per provincia e anno.

**Schema dati**:

- `anno` (integer): Anno di riferimento (2019-2024)
- `provincia` (string): Nome provincia
- `delitto` (string): Tipo di delitto
- `provinciauts_corretto` (string): Nome provincia corretto
- `codice_regione` (integer): Codice ISTAT regione
- `codice_provincia_storico` (integer): Codice ISTAT provincia storico
- `codice_provinciauts` (integer): Codice ISTAT UTS provincia
- `ripartizione_geografica` (string): Ripartizione geografica
- `regione` (string): Nome regione
- `provincia_uts` (string): Nome provincia UTS ISTAT
- `flag_tipo_uts` (integer): Tipo UTS
- `sigla_automobilistica` (string): Sigla targa

### [delitti_segnalazioni.csv](delitti_segnalazioni.csv)

Dati sulle segnalazioni di delitti per provincia, anno, sesso ed età.

**Schema dati**: Identico a `codice_rosso_segnalazioni.csv` con `delitto` al posto di `descrizione_reato`

### [delitti_vittime.csv](delitti_vittime.csv)

Dati sulle vittime di delitti per provincia e anno.

**Schema dati**: Identico a `delitti_commessi.csv`

### [omicidi_dcpc.csv](omicidi_dcpc.csv)

Dati aggregati sugli omicidi con dettagli su vittime femminili e ambito familiare/affettivo.

**Schema dati**:

- `categoria` (string): Categoria statistica
- `2019`, `2020`, `2021`, `2022`, `2023`, `2024` (integer): Valori annuali

*Nota: questo file mantiene la struttura originale a colonne per anni e non include normalizzazione geografica.*

### [reati_spia_commessi.csv](reati_spia_commessi.csv)

Dati sui reati spia (monitoraggio speciale) commessi per provincia e anno.

**Schema dati**: Identico a `codice_rosso_commessi.csv`

### [reati_spia_segnalazioni.csv](reati_spia_segnalazioni.csv)

Dati sulle segnalazioni di reati spia per provincia, anno, sesso ed età.

**Schema dati**: Identico a `codice_rosso_segnalazioni.csv`

### [reati_spia_vittime.csv](reati_spia_vittime.csv)

Dati sulle vittime di reati spia per provincia e anno.

**Schema dati**: Identico a `codice_rosso_commessi.csv`

## Note Tecniche

- Tutti i file (tranne `omicidi_dcpc.csv`) sono ordinati per `anno, provincia` e campo descrittivo (delitto/descrizione_reato)
- I nomi delle province sono stati normalizzati tramite *join fuzzy* con le unità territoriali ISTAT
- I codici ISTAT garantiscono l'univocità geografica e l'integrazione con altri dataset
