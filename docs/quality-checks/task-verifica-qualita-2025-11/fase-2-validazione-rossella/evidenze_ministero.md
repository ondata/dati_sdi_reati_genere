# Evidenze Tecniche per Comunicazione al Ministero dell'Interno

**Oggetto**: Richiesta chiarimenti su completezza e metadati FILE_6 (MI-123-U-A-SD-2025-90_6.xlsx)
**Riferimento FOIA**: MI-123-U-A-SD-2025-90
**Data validazione**: 2025-11-15

## Problema identificato

I dati forniti via FOIA (FILE_6) presentano **discrepanze critiche** rispetto al report ufficiale ISTAT "Violenza contro le donne – Un anno di Codice Rosso" (2020), che utilizza la stessa fonte dati (Sistema SDI-SSD).

**Periodo di riferimento**: Agosto 2019 - Agosto 2020

## Discrepanze quantificate

### Tabella comparativa

| Articolo c.p. | ISTAT (ago 2019 - ago 2020) | FILE_6 (ago 2019 - ago 2020) | Gap | % Copertura FILE_6 |
|---------------|----------------------------|------------------------------|-----|-------------------|
| **387 bis** (Violazione allontanamento) | 1.741 | 0 | -1.741 | 0% |
| **558 bis** (Costrizione matrimonio) | 11 | 0 | -11 | 0% |
| **583 quinquies** (Deformazione aspetto) | 56 | 0 | -56 | 0% |
| **TOTALE** | **1.808** | **0** | **-1.808** | **0%** |

**Fonte ISTAT**: Polizia di Stato, "Un anno di Codice Rosso" (febbraio 2020), pag. 14-16
**Fonte dati dichiarata ISTAT**: Sistema SDI-SSD

## Analisi lag temporale

FILE_6 mostra distribuzione temporale fortemente sbilanciata:

| Anno denuncia | Casi totali | % del totale |
|---------------|-------------|--------------|
| 2019 | 4 | 0.08% |
| 2020 | 5 | 0.10% |
| 2021 | 3 | 0.06% |
| 2022 | 13 | 0.27% |
| 2023 | 530 | 10.96% |
| **2024** | **4.277** | **88.53%** |

**Evidenza lag temporale massivo**:

- Fatti del 2019 denunciati nel 2024: 65 casi (lag medio: 1.842 giorni = 5.0 anni)
- Fatti del 2020 denunciati nel 2024: 45 casi (lag medio: 1.525 giorni = 4.2 anni)

**Interpretazione**: La maggior parte dei casi 2019-2020 appare essere stata registrata/denunciata nel 2024, con ritardo di 4-5 anni.

## Caso critico: Art. 387 bis c.p.

**Problema più grave**: Art. 387 bis (Violazione allontanamento dalla casa familiare)

- ISTAT riporta **1.741 casi** agosto 2019 - agosto 2020
- FILE_6 riporta **0 casi** nello stesso periodo
- FILE_6 contiene solo 68 casi totali, tutti concentrati nel 2023-2024

**Pattern anomalo**:

- Tutti i 68 casi FILE_6 sono fatti 2023-2024 (non 2019-2020 denunciati tardi)
- Lag medio: 1-3 giorni (denunce immediate, non retroattive)
- Assenza TOTALE di fatti 2019-2020

**Ipotesi**: Implementazione operativa tardiva art. 387 bis nel sistema SDI dopo agosto 2019.

## Domande per il Ministero

### 1. Completezza FILE_6

**Q1.1**: FILE_6 rappresenta un'estrazione completa del Sistema SDI-SSD o un subset filtrato?

**Q1.2**: Se è un subset, quali criteri di filtro sono stati applicati?

- Solo comunicazioni con "relazione vittima-autore" codificata?
- Solo determinati articoli di reato?
- Solo determinati periodi temporali?

**Q1.3**: Perché FILE_6 ha 0 casi nel periodo agosto 2019 - agosto 2020 quando il report ISTAT (stessa fonte SDI-SSD) ne riporta 1.808?

### 2. Implementazione Codice Rosso in SDI

**Q2.1**: Quando gli articoli Codice Rosso (L. 69/2019) sono stati implementati operativamente nel sistema SDI?

Specificare per:

- Art. 387 bis (Violazione allontanamento)
- Art. 558 bis (Costrizione matrimonio)
- Art. 583 quinquies (Deformazione aspetto)

**Q2.2**: I casi 2019-2020 di questi articoli sono stati registrati con codici precedenti?

Ad esempio:

- Art. 387 bis registrato come art. 650 c.p. (Inosservanza provvedimenti)?
- Altri mapping?

**Q2.3**: È stato effettuato recoding retroattivo? Se sì, quando?

### 3. Lag temporale registrazione

**Q3.1**: Come si spiega il lag medio di 4-5 anni tra data fatto (2019-2020) e data denuncia (2024)?

**Q3.2**: FILE_6 contiene denunce registrate retroattivamente nel sistema SDI nel 2023-2024?

**Q3.3**: Esiste una colonna "data_registrazione_SDI" che distingue quando la denuncia è stata RICEVUTA vs quando è stata INSERITA nel sistema?

### 4. Metadati richiesti

**Q4.1**: Data estrazione dati da sistema SDI per FILE_6

**Q4.2**: Versione software/schema database SDI utilizzato

**Q4.3**: Scope temporale esatto dell'estrazione:

- Per data denuncia?
- Per data fatto?
- Per data registrazione SDI?

**Q4.4**: Significato esatto colonne:

- `DATA_INIZIO_FATTO`: Data in cui il reato è iniziato
- `DATA_FINE_FATTO`: Data in cui il reato è terminato
- `DATA_DENUNCIA`: Data in cui la denuncia è stata presentata o data di registrazione in SDI?

## Metadati mancanti critici

Secondo standard DCAT-AP_IT (profilo metadati italiano per open data), FILE_6 manca di:

1. **Data estrazione/pubblicazione** (dcterms:issued)
2. **Data ultima modifica** (dcterms:modified)
3. **Copertura temporale** (dcterms:temporal) - scope preciso
4. **Metodologia raccolta dati** (dcterms:accrualMethod)
5. **Frequenza aggiornamento** (dcterms:accrualPeriodicity)
6. **Chiave primaria** (PROT_SDI duplicato in 2.158 casi su 5.124)
7. **Codebook campi** (es. semantica `DES_OBIET`, `RELAZIONE_AUTORE_VITTIMA`)

**Conformità DCAT-AP_IT**: 22% (2/9 metadati obbligatori presenti)

## Richieste specifiche

### Dataset integrativo richiesto

Estrazione completa Sistema SDI-SSD per periodo agosto 2019 - agosto 2020 contenente:

1. Tutti gli articoli Codice Rosso (L. 69/2019)
2. Colonne aggiuntive:
   - `DATA_REGISTRAZIONE_SDI` (quando inserito in database)
   - `CODICE_ORIGINALE` (se recoding effettuato)
   - `FLAG_RELAZIONE_VA` (se filtro applicato)

### Metadati richiesti

1. Documento tecnico che descriva:
   - Schema database SDI
   - Codifica articoli reato Codice Rosso
   - Timeline implementazione (agosto 2019 → oggi)
   - Criteri filtro FILE_6

2. Codebook completo per tutte le colonne FILE_6

3. Data dictionary con:
   - Tipo dato
   - Dominio valori
   - Vincoli integrità
   - Foreign keys

## Allegati tecnici

1. **confronto_istat_file6.csv**: Tabella comparativa esportabile
2. **query_validazione.sql**: Query SQL riproducibili per audit indipendente
3. **analisi_art387bis.md**: Analisi approfondita caso critico art. 387 bis

## Riferimenti normativi

- **FOIA**: D.Lgs. 33/2013 (art. 5, comma 2)
- **Open data**: D.Lgs. 36/2006, CAD art. 50-ter
- **Metadati**: Linee Guida AgID "Profilo DCAT-AP_IT" (2020)
- **Codice Rosso**: Legge 69/2019

---

**Richiesta**: Riscontro tecnico entro 30 giorni con chiarimenti puntuali su discrepanze identificate e fornitura metadati/dataset integrativo.

**Contatto**: [inserire riferimenti Period Think Tank / datiBeneComune]

**Validazione tecnica**: Analisi condotta con DuckDB SQL, query riproducibili disponibili su richiesta.
