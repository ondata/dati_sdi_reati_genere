# Script Pulizia Dataset SDI

## Descrizione

Script `pulisci_dataset.sh` che risolve i due problemi critici identificati nel dataset SDI:

1. **Duplicati esatti completi** (49.4% delle righe)
2. **Prodotto cartesiano** denunciati × colpiti da provvedimento

## Utilizzo

```bash
cd /home/aborruso/git/dati_sdi_reati_genere
./scripts/pulisci_dataset.sh
```

## Output

Lo script genera:

- **CSV pulito**: `data/processed/dataset_pulito.csv`
- **Log operazioni**: `data/processed/pulizia_log.txt`

## Struttura Dataset Pulito

Ogni riga rappresenta **1 evento** identificato da `PROT_SDI`.

### Campi Aggregati

I campi multipli (denunciati, vittime, colpiti da provvedimento) sono aggregati in array:

- `COD_VITTIME`: array codici vittime
- `N_VITTIME`: conteggio vittime
- `SESSO_VITTIME`: array sessi vittime
- `ETA_VITTIME`: array età vittime
- `COD_DENUNCIATI`: array codici denunciati
- `N_DENUNCIATI`: conteggio denunciati
- `SESSO_DENUNCIATI`: array sessi denunciati
- `ETA_DENUNCIATI`: array età denunciati
- `COD_COLPITI_PROVV`: array codici colpiti da provvedimento
- `N_COLPITI_PROVV`: conteggio colpiti da provvedimento
- `RELAZIONI_AUTORE_VITTIMA`: array relazioni (può essere multipla)

### Esempio Output

```csv
PROT_SDI,ARTICOLI,N_VITTIME,N_DENUNCIATI,N_COLPITI_PROVV,...
BSCS352024000004,[572],1,1,0,...
PGPQ102023002369,[572],1,6,6,...
```

## Risoluzione Problemi

### Problema 1: Duplicati Esatti

Risolto con `SELECT DISTINCT` su tutti i campi.

**Prima**: 5.124 righe (2.534 duplicate)
**Dopo deduplica**: 3.329 righe uniche

### Problema 2: Prodotto Cartesiano

Risolto aggregando per `PROT_SDI` e usando `array_agg()` per raggruppare soggetti multipli.

**Esempio PGPQ102023002369**:

- Prima: 36 righe (6 denunciati × 6 colpiti = prodotto cartesiano)
- Dopo: 1 riga con array di 6 denunciati e 6 colpiti

## Vantaggi Dataset Pulito

1. **1 riga = 1 evento**: granularità chiara e documentata
2. **Conteggi affidabili**: `count(*)` = numero eventi reali
3. **Relazioni preservate**: tutti i soggetti mantenuti in array
4. **Efficienza**: da 5.124 a ~2.644 righe (48% riduzione)
5. **Analisi corrette**: nessun doppio conteggio artificiale

## Query Esempio

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

-- Distribuzione denunciati per evento
SELECT
  N_DENUNCIATI,
  count(*) as n_eventi
FROM read_csv('data/processed/dataset_pulito.csv')
GROUP BY N_DENUNCIATI
ORDER BY N_DENUNCIATI;
```

## Dipendenze

- DuckDB (con supporto spatial per `st_read`)
- Python 3 (per parsing JSON statistiche)

## Note

Gli array in CSV sono formattati come `[val1,val2,val3]`.

Per estrarre valori in DuckDB:

```sql
-- Unnest array vittime
SELECT PROT_SDI, unnest(COD_VITTIME) as cod_vittima
FROM read_csv('data/processed/dataset_pulito.csv');
```
