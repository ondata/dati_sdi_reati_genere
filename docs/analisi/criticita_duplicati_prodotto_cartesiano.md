# Criticità: Duplicati e Prodotto Cartesiano nel Dataset SDI Reati di Genere

**Dataset analizzato:** `data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx`

**Data analisi:** 2025-11-16

**Versione documento:** 1.0

## Executive Summary

L'analisi del dataset SDI ricevuto tramite FOIA ha rilevato **due problemi critici di qualità dei dati** che compromettono gravemente l'affidabilità statistica:

1. **49.4% di righe duplicate esatte** - errore di estrazione dati
2. **Prodotto cartesiano** tra denunciati e colpiti da provvedimento - struttura relazionale mal gestita

Questi problemi rendono il dataset **inutilizzabile per analisi statistiche affidabili** senza preventiva deduplica e comprensione della struttura relazionale.

## Problema 1: Duplicati Esatti Completi

### Descrizione del Problema

Il dataset contiene un numero molto elevato di righe completamente identiche (tutti i campi hanno gli stessi valori), chiaramente dovuto a un errore nell'estrazione o nella gestione dei dati dal sistema SDI.

### Statistiche

- **Righe totali nel file originale:** 5.124
- **Righe duplicate (tutti campi identici):** 2.534 (49.4%)
- **Righe uniche (dopo deduplica):** 3.329 (64.9%)
- **Gruppi di duplicati:** 798
- **Caso estremo:** 30 righe completamente identiche per lo stesso evento

### Query di Verifica

```sql
-- Query DuckDB per identificare duplicati esatti
WITH all_cols AS (
  SELECT *,
    count(*) OVER (
      PARTITION BY
        PROT_SDI, ART, COD_VITTIMA, COD_DENUNCIATO, TENT_CONS,
        RELAZIONE_AUTORE_VITTIMA, T_NORMA, RIF_LEGGE, DES_REA_EVE,
        DATA_INIZIO_FATTO, DATA_FINE_FATTO, DATA_DENUNCIA, STATO,
        REGIONE, PROVINCIA, COMUNE, LUOGO_SPECIF_FATTO,
        SESSO_DENUNCIATO, ETA_DENUNCIATO, NAZIONE_NASCITA_DENUNCIATO,
        COD_COLP_DA_PROVV, SEX_COLP_PROVV, ETA_COLP_PROVV,
        NAZIONE_NASCITA_COLP_PROVV, SEX_VITTIMA, ETA_VITTIMA,
        NAZIONE_NASCITA_VITTIMA, DES_OBIET
    ) as dup_count
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
)
SELECT count(*) as righe_duplicate_complete
FROM all_cols
WHERE dup_count > 1;

-- Risultato: 2534 righe duplicate
```

### Top 10 Casi di Duplicazione

```sql
-- Query per trovare i gruppi con più duplicati
SELECT
  PROT_SDI,
  ART,
  COD_VITTIMA,
  COD_DENUNCIATO,
  TENT_CONS,
  RELAZIONE_AUTORE_VITTIMA,
  count(*) as n
FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
GROUP BY
  PROT_SDI, ART, COD_VITTIMA, COD_DENUNCIATO,
  TENT_CONS, RELAZIONE_AUTORE_VITTIMA
HAVING count(*) > 1
ORDER BY n DESC
LIMIT 10;
```

**Risultati:**

| PROT_SDI | ART | Relazione | N° Duplicati |
|----------|-----|-----------|--------------|
| BSCS352024000004 | 572 | ALTRO PARENTE | 30 |
| BSPC012024000405 | 612 | EX FIDANZATO | 17 |
| GEPC022024200040 | 612 | EX FIDANZATO | 15 |
| TOPQ102023002574 | 572 | CONIUGE/CONVIVENTE | 15 |
| SPCC012024000026 | 572 | CONIUGE/CONVIVENTE | 13 |
| CRPQ102024600232 | 612 | EX FIDANZATO | 11 |
| MICS402024852604 | 572 | CONIUGE/CONVIVENTE | 11 |
| BSCS352024000004 | 572 | CONIUGE/CONVIVENTE | 10 |
| FGPQ102024000720 | 612 | EX CONIUGE/EX CONVIVENTE | 10 |
| PTCS152024850060 | 612 | VICINO DI CASA | 10 |

### Esempio Concreto: BSCS352024000004

Questo evento presenta **30 righe completamente identiche** con i seguenti valori:

- **Reato:** Art. 572 CP (Maltrattamenti)
- **Vittima:** COD_VITTIMA `20190929081006404063`
- **Denunciato:** COD_DENUNCIATO `19900227103530839342`
- **Relazione:** ALTRO PARENTE
- **Stato procedimento:** CONSUMATO

Tutti i 30 record hanno **esattamente gli stessi valori** in tutti i campi - chiaramente un errore di estrazione.

### Impatto

1. **Inflazione artificiale dei conteggi**: tutti i conteggi statistici sono sovrastimati del ~50%
2. **Impossibilità di analisi accurate**: senza deduplica preventiva, qualsiasi statistica è errata
3. **Rischio di doppio conteggio**: analisi aggregate producono risultati completamente inaffidabili
4. **Spreco di risorse**: 35% del file è ridondante

### Causa Probabile

L'errore è probabilmente dovuto a:

- Join errati tra tabelle relazionali del database SDI
- Esportazione multipla dello stesso record
- Errore nel processo di estrazione/trasformazione dati
- Problema nel sistema di query del database SDI

## Problema 2: Prodotto Cartesiano Denunciati × Colpiti da Provvedimento

### Descrizione del Problema

Anche **dopo rimozione dei duplicati esatti**, il dataset presenta una struttura a prodotto cartesiano: quando ci sono più denunciati E più "colpiti da provvedimento" (COD_COLP_DA_PROVV) nello stesso evento, ogni denunciato viene abbinato a OGNI persona colpita da provvedimento, generando righe artificiose senza relazione diretta.

### Esempio Concreto: PGPQ102023002369

Questo evento presenta **36 righe** (dopo deduplica) con la seguente struttura:

- **1 vittima:** `20220728121231234989`
- **1 reato:** Art. 572 CP (Maltrattamenti)
- **6 denunciati distinti**
- **6 persone colpite da provvedimento distinte**
- **Risultato:** 6 × 6 = **36 righe**

#### Query di Verifica

```sql
-- Analisi dell'evento PGPQ102023002369
WITH deduplicato AS (
  SELECT DISTINCT *
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
)
SELECT
  PROT_SDI,
  count(*) as n_righe_pulite,
  count(DISTINCT ART) as n_reati,
  count(DISTINCT COD_VITTIMA) as n_vittime,
  count(DISTINCT COD_DENUNCIATO) as n_denunciati,
  count(DISTINCT COD_COLP_DA_PROVV) as n_colpiti_provv
FROM deduplicato
WHERE PROT_SDI = 'PGPQ102023002369    '
GROUP BY PROT_SDI;
```

**Risultato:**

| PROT_SDI | Righe | Reati | Vittime | Denunciati | Colpiti Provv |
|----------|-------|-------|---------|------------|---------------|
| PGPQ102023002369 | 36 | 1 | 1 | 6 | 6 |

**Calcolo atteso:** 1 reato × 1 vittima × 6 denunciati = **6 righe**

**Calcolo reale:** 1 reato × 1 vittima × (6 denunciati × 6 colpiti_provv) = **36 righe**

#### Combinazioni Generate

I 6 denunciati sono:

1. `20010727191807614171` (M, 52 anni)
2. `20091223095159190320` (F, 50 anni)
3. `20210326132546251409` (F, 21 anni)
4. `20210824123245079219` (F, 23 anni)
5. `20231222115541946781` (F, 18 anni)
6. `20231222115917597660` (F, 16 anni)

Le 6 persone colpite da provvedimento sono le stesse 6 persone sopra (ogni denunciato è anche colpito da provvedimento).

Il dataset genera **tutte le 36 combinazioni possibili**, incluse quelle senza senso logico (es. denunciato A abbinato a provvedimento contro denunciato B).

### Statistiche Dataset Dedupli cato

Dopo rimozione duplicati esatti (3.329 righe uniche):

```sql
WITH deduplicato AS (
  SELECT DISTINCT *
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
),
gruppo_evento AS (
  SELECT
    PROT_SDI,
    count(*) as n_righe,
    count(DISTINCT ART) as n_reati,
    count(DISTINCT COD_VITTIMA) as n_vittime,
    count(DISTINCT COD_DENUNCIATO) as n_denunciati
  FROM deduplicato
  GROUP BY PROT_SDI
)
SELECT
  avg(n_righe) as media_righe_per_evento,
  max(n_righe) as max_righe_per_evento,
  sum(CASE WHEN n_righe = 1 THEN 1 ELSE 0 END) as eventi_con_1_riga,
  sum(CASE WHEN n_righe > 1 THEN 1 ELSE 0 END) as eventi_con_multiple_righe
FROM gruppo_evento;
```

**Risultati:**

- **Eventi totali:** 2.644
- **Media righe per evento:** 1.26
- **Max righe per evento:** 36 (PGPQ102023002369)
- **Eventi con 1 sola riga:** 2.255 (85%)
- **Eventi con righe multiple:** 389 (15%)

### Pattern Righe Multiple

Distribuzione dei pattern che generano righe multiple (389 eventi):

| Pattern | N° Eventi | Righe Totali |
|---------|-----------|--------------|
| Solo multi-reati | 144 | 325 |
| Solo multi-vittime | 80 | 192 |
| Altro pattern | 46 | 99 |
| Solo multi-denunciati | 45 | 201 |
| Multi-reati + Multi-denunciati | 33 | 94 |
| Multi-reati + Multi-vittime | 17 | 69 |
| Multi-vittime + Multi-denunciati | 16 | 53 |
| Multi-reati + Multi-vittime + Multi-denunciati | 8 | 41 |

**Query:**

```sql
WITH deduplicato AS (
  SELECT DISTINCT *
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
),
gruppo_evento AS (
  SELECT
    PROT_SDI,
    count(*) as n_righe,
    count(DISTINCT ART) as n_reati,
    count(DISTINCT COD_VITTIMA) as n_vittime,
    count(DISTINCT COD_DENUNCIATO) as n_denunciati
  FROM deduplicato
  GROUP BY PROT_SDI
  HAVING count(*) > 1
)
SELECT
  CASE
    WHEN n_reati > 1 AND n_vittime > 1 AND n_denunciati > 1
      THEN 'Multi-reati + Multi-vittime + Multi-denunciati'
    WHEN n_reati > 1 AND n_vittime > 1 THEN 'Multi-reati + Multi-vittime'
    WHEN n_reati > 1 AND n_denunciati > 1 THEN 'Multi-reati + Multi-denunciati'
    WHEN n_vittime > 1 AND n_denunciati > 1 THEN 'Multi-vittime + Multi-denunciati'
    WHEN n_reati > 1 THEN 'Solo multi-reati'
    WHEN n_vittime > 1 THEN 'Solo multi-vittime'
    WHEN n_denunciati > 1 THEN 'Solo multi-denunciati'
    ELSE 'Altro pattern'
  END as pattern,
  count(*) as n_eventi,
  sum(n_righe) as n_righe_totali
FROM gruppo_evento
GROUP BY pattern
ORDER BY n_eventi DESC;
```

### Impatto

1. **Granularità non documentata**: impossibile sapere se 1 riga = 1 evento, 1 reato, o 1 combinazione artificiale
2. **Conteggi inaffidabili**: contare le righe produce sovrastime per eventi con prodotto cartesiano
3. **Analisi errate**: senza conoscere la struttura, qualsiasi aggregazione può essere sbagliata
4. **Relazioni artificiose**: il prodotto cartesiano crea abbinamenti denunciato-provvedimento senza senso

### Causa Probabile

Il prodotto cartesiano è probabilmente dovuto a:

- Gestione errata di relazioni molti-a-molti nel database SDI
- Join senza condizioni di filtro appropriate
- Denormalizzazione mal implementata di tabelle relazionali
- Esportazione "flat" di struttura dati complessa senza documentazione

## Raccomandazioni

### Per l'Analisi dei Dati Attuali

1. **Deduplica obbligatoria**: rimuovere righe duplicate esatte prima di qualsiasi analisi
2. **Aggregazione per PROT_SDI**: per conteggi eventi, raggruppare sempre per PROT_SDI unico
3. **Attenzione ai conteggi soggetti**: usare DISTINCT su COD_VITTIMA e COD_DENUNCIATO
4. **Documentare aggregazioni**: specificare sempre quale unità di analisi si sta usando

### Query Deduplica

```sql
-- Dataset dedupli cato per analisi
CREATE TABLE dataset_pulito AS
SELECT DISTINCT *
FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet');

-- Verifica
SELECT
  count(*) as righe_totali,
  count(DISTINCT PROT_SDI) as eventi_unici
FROM dataset_pulito;
```

### Per il Ministero dell'Interno

1. **Correggere l'estrazione dati**: eliminare i duplicati esatti alla fonte
2. **Documentare la struttura**: fornire schema relazionale del database SDI
3. **Chiarire la granularità**: specificare cosa rappresenta 1 riga nel dataset
4. **Gestire prodotto cartesiano**:
   - O fornire tabelle separate per denunciati e colpiti da provvedimento
   - O documentare chiaramente la relazione tra questi campi
5. **Fornire metadati completi**: dizionario dati con definizione di ogni campo

## Script Riproducibili

### Verifica Completa Duplicati

```bash
# Usando DuckDB da linea di comando
duckdb -json -c "
WITH all_cols AS (
  SELECT *,
    count(*) OVER (
      PARTITION BY
        PROT_SDI, ART, COD_VITTIMA, COD_DENUNCIATO, TENT_CONS,
        RELAZIONE_AUTORE_VITTIMA, T_NORMA, RIF_LEGGE, DES_REA_EVE,
        DATA_INIZIO_FATTO, DATA_FINE_FATTO, DATA_DENUNCIA, STATO,
        REGIONE, PROVINCIA, COMUNE, LUOGO_SPECIF_FATTO,
        SESSO_DENUNCIATO, ETA_DENUNCIATO, NAZIONE_NASCITA_DENUNCIATO,
        COD_COLP_DA_PROVV, SEX_COLP_PROVV, ETA_COLP_PROVV,
        NAZIONE_NASCITA_COLP_PROVV, SEX_VITTIMA, ETA_VITTIMA,
        NAZIONE_NASCITA_VITTIMA, DES_OBIET
    ) as dup_count
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
)
SELECT count(*) as righe_duplicate_complete
FROM all_cols
WHERE dup_count > 1
"
```

### Analisi Prodotto Cartesiano

```bash
# Top 10 eventi con più righe (dopo deduplica)
duckdb -json -c "
WITH deduplicato AS (
  SELECT DISTINCT *
  FROM st_read('./data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx', layer='Sheet')
),
gruppo_evento AS (
  SELECT
    PROT_SDI,
    count(*) as n_righe,
    count(DISTINCT ART) as n_reati,
    count(DISTINCT COD_VITTIMA) as n_vittime,
    count(DISTINCT COD_DENUNCIATO) as n_denunciati
  FROM deduplicato
  GROUP BY PROT_SDI
  HAVING count(*) > 1
)
SELECT * FROM gruppo_evento
ORDER BY n_righe DESC
LIMIT 10
"
```

## Conclusioni

Il dataset `MI-123-U-A-SD-2025-90_6.xlsx` presenta **gravi problemi di qualità** che ne compromettono l'utilizzo per analisi statistiche:

1. **49.4% di duplicati esatti** - errore tecnico nell'estrazione
2. **Prodotto cartesiano** - struttura relazionale non documentata e mal gestita
3. **Assenza totale di metadati** - impossibile interpretare correttamente la granularità

**Il dataset è attualmente INUTILIZZABILE per analisi affidabili** senza:

- Deduplica preventiva
- Documentazione completa della struttura relazionale
- Chiarimenti dal Ministero su granularità e aggregazioni corrette

**Data ultima modifica:** 2025-11-16
