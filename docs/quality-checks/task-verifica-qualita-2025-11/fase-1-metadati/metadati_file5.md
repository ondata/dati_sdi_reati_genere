# Metadati FILE_5: MI-123-U-A-SD-2025-90_5.xlsx

**File**: `data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx`
**Analisi**: 2025-11-15

## Proprietà File Excel

**Dimensioni**:

- Byte: 1.166.835 (1.11 MB)
- Formato: Excel 2007+ (.xlsx)

**Metadati documento**:

- **Autore**: Non specificato
- **Ultima modifica da**: Non specificato
- **Data creazione**: 2025-04-28 09:15:03
- **Data ultima modifica**: 2025-05-09 07:29:36
- **Titolo**: Non specificato
- **Soggetto**: Non specificato
- **Descrizione**: Non specificato
- **Keywords**: Non specificato
- **Categoria**: Non specificato

## Struttura Fogli

**Numero fogli**: 10

### 1. Omicidi DCPC

- **Righe**: 9
- **Colonne**: 15
- **Contenuto**: Dati omicidi con vittime donne
- **Disaggregazione**: Suddivisione per:
  - Omicidi totali con vittime donne
  - Omicidi in ambito familiare/affettivo con vittime donne
  - Omicidi da partner/ex partner con vittime donne
- **Fonte dati**: DCPC (Direzione Centrale Polizia Criminale) - non consolidati (nota 3 risposta Ministero)

### 2. Delitti - Commessi

- **Righe**: 537
- **Colonne**: 8
- **Contenuto**: Reati commessi
- **Categorie reati**: Tentati omicidi, lesioni dolose, percosse, minacce, violenze sessuali
- **Disaggregazione**: Provinciale (107 province)

### 3. Delitti - Vittime

- **Righe**: 3.862
- **Colonne**: 9
- **Contenuto**: Incidenza vittime di genere femminile per delitti
- **Disaggregazione**: Provinciale

### 4. Delitti - Segnalazioni

- **Righe**: 4.010
- **Colonne**: 15
- **Contenuto**: Segnalazioni denunce/arresti per delitti
- **Disaggregazione**: Provinciale

### 5. Reati spia - Commessi

- **Righe**: 216
- **Colonne**: 8
- **Contenuto**: Reati commessi
- **Categorie**: Atti persecutori (stalking), Maltrattamenti familiari/conviventi
- **Disaggregazione**: Provinciale

### 6. Reati spia - Vittime

- **Righe**: 1.707
- **Colonne**: 9
- **Contenuto**: Incidenza vittime genere femminile per reati spia
- **Disaggregazione**: Provinciale

### 7. Reati spia - Segnalazioni

- **Righe**: 1.497
- **Colonne**: 15
- **Contenuto**: Segnalazioni denunce/arresti per reati spia
- **Disaggregazione**: Provinciale

### 8. Codice Rosso - Commessi

- **Righe**: 360
- **Colonne**: 9
- **Contenuto**: Reati Codice Rosso commessi
- **Categorie**:
  - Art. 558 bis: Costrizione/induzione al matrimonio
  - Art. 583 quinquies: Deformazione viso
  - Art. 612 ter: Diffusione illecita immagini/video intimi (revenge porn)
  - Art. 387 bis: Violazione allontanamento casa familiare
- **Disaggregazione**: Provinciale

### 9. Codice Rosso - Vittime

- **Righe**: 1.499
- **Colonne**: 9
- **Contenuto**: Incidenza vittime genere femminile Codice Rosso
- **Disaggregazione**: Provinciale

### 10. Codice Rosso - Segnalazioni

- **Righe**: 1.288
- **Colonne**: 15
- **Contenuto**: Segnalazioni denunce/arresti Codice Rosso
- **Disaggregazione**: Provinciale

## Caratteristiche Strutturali

**Formato dati**:

- Struttura "pivot": anni come colonne (2019, 2020, 2021, 2022, 2023, 2024)
- Non normalizzato: richiede trasposizione per analisi temporali

**Periodicità**:

- 2019-2024 (6 anni)
- **2024 NON consolidato** (fonte: nota 2 risposta Ministero)

**Fonte dati**:

- SDI (Sistema di Indagine)
- SSD (Sistema di Sorveglianza Dati)
- DCPC (solo foglio Omicidi)

**Aggregazione geografica**:

- Livello provinciale (107 province italiane)
- **Dati comunali NON forniti** per vincoli Garante Privacy (delibera 515/2018, art. 5)

## Note Tecniche

**Avvisi openpyxl**:

- `wmf image format is not supported so the image is being dropped`
- FILE_5 contiene immagini .wmf (Windows Metafile) non supportate da libreria Python
- Non impatta lettura dati tabulari

**Periodo copertura**:

- Richiesta FOIA: 1 gennaio 2019 - 31 dicembre 2024
- Risposta: 2019-2024 (conforme)

## Gap Metadati Identificati

**Critici** (🔴):

- 🔴 **Data estrazione dati da SDI/SSD**: Non specificata (solo data modifica file: 9 maggio 2025)
- 🔴 **Versione schema SDI/SSD**: Non documentata
- 🔴 **Significato "non consolidato 2024"**: Non definito (fino a quando? Quali revisioni attese?)
- 🔴 **Autore dataset**: Non specificato (Ministero/ufficio responsabile)
- 🔴 **Licenza dati**: Non specificata (riutilizzo?)
- 🔴 **Codici ISTAT province**: Assenti

**Importanti** (⚠️):

- ⚠️ Titolo/Descrizione file: Assenti
- ⚠️ Keywords: Assenti
- ⚠️ Metodologia aggregazione: Non documentata
- ⚠️ Criteri inclusione/esclusione reati: Non specificati
- ⚠️ Definizione "incidenza vittime genere femminile": Non chiara (% su totale? valore assoluto?)
- ⚠️ Changelog versioni: Assente (file modificato 28 apr → 9 mag)

**Secondari** (ℹ️):

- ℹ️ Categoria documento: Assente
- ℹ️ Soggetto documento: Assente
- ℹ️ Link pubblicazione online: Assente (richiesto in FOIA, non fornito)

## Riferimenti

**Risposta Ministero**:

- Protocollo: MI-123-U-A-SD-2025-90
- Data: 9 maggio 2025
- Firmatario: Direttore Ufficio Affari Generali (Avizzano)

**Richiesta FOIA originale**:

- Data: 18 aprile 2025
- Richiedente: Avv. Giulia Sudano (Period Think Tank)
