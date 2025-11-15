# Gap Metadati: FILE_5 e FILE_6

**Analisi**: 2025-11-15
**Obiettivo**: Identificare metadati mancanti per richiesta integrativa Ministero

## Sintesi Esecutiva

**FILE_5 e FILE_6** presentano gravi carenze metadatali che impediscono:

- Valutazione completezza dati
- Interpretazione corretta valori
- Riproducibilità analisi
- Riutilizzo dataset

**Gap critici identificati**: 15 (🔴)
**Gap importanti identificati**: 12 (⚠️)

---

## 1. Gap Metadati Critici (🔴)

### 1.1 Data Estrazione Dati

**Assente**: Data estrazione dati da SDI/SSD/DCPC

**Impatto**:

- Impossibile sapere quando dati sono stati estratti
- Metadati Excel indicano solo data creazione file (28 apr - 6 mag 2025)
- Possibile lag tra estrazione SDI e generazione file non quantificabile

**Richiesto**:

- Data estrazione per ciascuna fonte (SDI, SSD, DCPC)
- Se estrazione multipla, date per ciascun anno 2019-2024

### 1.2 Versione Schema SDI/SSD

**Assente**: Versione schema database SDI/SSD utilizzata

**Impatto**:

- Schema SDI può cambiare nel tempo (nuovi campi, modifiche significato)
- FILE_6 ha 28 colonne: quale versione schema?
- Impossible riproducibilità query su SDI

**Richiesto**:

- Versione schema SDI/SSD (es. "v2.3.1 - gennaio 2024")
- Changelog modifiche schema 2019-2024

### 1.3 Significato "Non Consolidato 2024"

**Vago**: "Dati di fonte SDI/SSD non consolidati per l'anno 2024, quindi suscettibili di variazioni"

**Domande**:

- Cosa significa "consolidato"? (validazione? integrazione ritardata?)
- Quando saranno consolidati? (mese/anno)
- Quali revisioni attese? (ordini di grandezza: ±5%? ±20%?)
- Anche 2023 è consolidato? E 2022?

**Richiesto**:

- Definizione "consolidamento dati" SDI/SSD
- Tempistiche consolidamento 2024
- Stime revisione attese (range %)
- Stato consolidamento anni precedenti (2019-2023)

### 1.4 Scope FILE_6 (Filtro Relazione Vittima-Autore)

**Parzialmente documentato**: "ove sia stata indicata una 'relazione vittima autore'"

**Domande critiche**:

- Quante comunicazioni SDI violenza genere TOTALI (2019-2024)?
- Quante hanno relazione V-A codificata?
- % copertura FILE_6: ____ / ____ = ____%
- Quali reati tipicamente hanno/non hanno relazione V-A?
- Criteri compilazione obbligatori/facoltativi?

**Impatto**:

- FILE_6 è sottinsieme non quantificato di SDI
- Impossibile valutare completezza
- Discrepanze vs ISTAT (100% missing 2019-2020) non giustificabili

**Richiesto**:

- N° comunicazioni SDI violenza genere totali per anno
- N° comunicazioni con relazione V-A per anno
- % copertura relazione V-A per categoria reato
- Criteri codifica relazione V-A (obbligatorio per quali reati?)

### 1.5 Chiave Primaria FILE_6

**Problematica**: PROT_SDI non univoco (issue #1)

**Esempio**:

- PROT_SDI "BOPC042024000134" ripetuto 5 volte
- Non chiaro se: 1 episodio con 5 vittime? 5 reati distinti? Errore?

**Impatto**:

- Impossibile conteggio episodi reali
- Conteggio righe ≠ conteggio eventi
- Analisi aggregate errate

**Richiesto**:

- Chiave primaria corretta per FILE_6
- Semantica righe duplicate PROT_SDI
- Campo univoco episodio vs campo univoco vittima

### 1.6 Autore Dataset

**Assente**: Responsabile produzione dataset non indicato

**Metadati Excel**:

- FILE_5: Autore "Non specificato", Modifica da "Non specificato"
- FILE_6: Autore "Apache POI", Modifica da "cla" (utente generico)

**Richiesto**:

- Ufficio Ministero responsabile produzione dataset
- Referente tecnico per chiarimenti (nome/email)
- Software generazione (versione)

### 1.7 Licenza Dati

**Assente**: Licenza riutilizzo non specificata

**Richiesta FOIA**:

> "Si richiede, ove possibile, il rilascio dei dati in formato aperto e processabile, ai sensi dell'art. 7 del D.lgs. 33/2013."

**FOIA rispettata parzialmente**: Formato aperto (Excel) ✅, MA licenza riutilizzo ❌

**Richiesto**:

- Licenza esplicita (es. CC0, CC-BY 4.0, IODL 2.0)
- Condizioni riutilizzo (attribuzione richiesta?)

### 1.8 Codici ISTAT Geografici

**Assenti**: Codici ISTAT province, comuni

**FILE_5**: Solo nomi province (testuali)
**FILE_6**: Solo nomi province, comuni (testuali)

**Problemi**:

- Nomi province errati (es. Sardegna - vedi resources/problemi_province_sardegna.jsonl)
- JOIN impossibile con dataset ISTAT/altri
- Analisi territoriale complessa

**Richiesto**:

- Aggiungere campi: COD_ISTAT_PROVINCIA, COD_ISTAT_COMUNE
- Standard: Codici ISTAT aggiornati (es. 2024)

### 1.9 Codici ISO Nazioni

**Assenti**: Codici ISO 3166 per nazioni nascita (issue #17)

**FILE_6 campi**:

- NAZIONE_NASCITA_DENUNCIATO (testuale)
- NAZIONE_NASCITA_COLP_PROVV (testuale)
- NAZIONE_NASCITA_VITTIMA (testuale)

**Problemi**:

- Nomi nazioni non standardizzati
- Analisi nazionalità difficoltosa

**Richiesto**:

- Aggiungere campi: COD_ISO_NAZIONE_* (ISO 3166-1 alpha-2)
- Es: "ITALIA" → "IT", "ROMANIA" → "RO"

### 1.10 Semantica Campi Ambigui FILE_6

**Campi problematici** (issue #2):

- **DES_OBIET** vs **LUOGO_SPECIF_FATTO**: Differenza non documentata
- DES_OBIET: 62.5% = "NON PREVISTO/ALTRO" (poco utile)

**Richiesto**:

- Definizione semantica DES_OBIET
- Definizione semantica LUOGO_SPECIF_FATTO
- Quale usare per geolocalizzazione/analisi?
- Perché DES_OBIET prevalenza "NON PREVISTO/ALTRO"?

### 1.11 Valori Ammessi RELAZIONE_AUTORE_VITTIMA

**Non documentati**: Valori possibili campo RELAZIONE_AUTORE_VITTIMA

**Esempi osservati**: "CONIUGE", "EX CONIUGE", "CONVIVENTE", "FIGLIO/A", ...

**Richiesto**:

- Elenco completo valori ammessi
- Codebook con definizioni
- Criterio classificazione (chi decide? FdO? PM?)

### 1.12 Gestione Valori Anomali Età

**Problemi noti**:

- Età denunciato: -2, 1930 (impossibili)
- Età vittima: simili anomalie

**Richiesto**:

- Spiegazione valori anomali età
- Codebook: -2 = "non disponibile"? 1930 = errore sistema?
- Procedura pulizia dati per export

### 1.13 Lag Temporale Registrazione FILE_6

**Problema critico** (da analisi Rossella):

- 85% denunce 2019 registrate nel 2024 (lag 5 anni!)
- 59.7% totale FILE_6 = denunce registrate 2024

**Domande**:

- Bulk update retroattivo SDI tra 2023-2024?
- Date aggiornamenti massivi?
- Perché lag così elevato?
- Dato DATA_DENUNCIA è corretto? O è DATA_REGISTRAZIONE_SDI?

**Richiesto**:

- Spiegazione lag temporale
- Distinguere: DATA_FATTO, DATA_DENUNCIA, DATA_REGISTRAZIONE_SDI
- Date bulk update retroattivi (se esistenti)

### 1.14 Discrepanze vs ISTAT (Stessa Fonte!)

**Problema**: FILE_6 vs Report ISTAT "Un anno di Codice Rosso" (ago 2019 - ago 2020)

| Articolo | ISTAT (SDI-SSD) | FILE_6 (SDI) | Delta |
|----------|-----------------|--------------|-------|
| Art. 558 bis | 11 casi | 0 casi | -100% |
| Art. 583 quinquies | 56 casi | 0 casi | -100% |
| Art. 387 bis | 1.741 casi | 0 casi | -100% |

**ISTAT e FILE_6 hanno STESSA FONTE** (SDI-SSD dichiarato in report ISTAT)

**Richiesto**:

- Spiegazione discrepanze
- Riconciliazione con dati ISTAT
- Metodologia ISTAT vs metodologia export FILE_6

### 1.15 Data Pubblicazione Online

**Richiesta FOIA esplicita**:

> "Infine si invita l'amministrazione, ove non già adempiuto, a procedere anche alla pubblicazione online dei dati/documenti richiesti"

**Risposta Ministero**: Nessuna menzione pubblicazione online

**Richiesto**:

- Pubblicazione online prevista? (Sì/No)
- Se Sì: URL, tempistiche
- Se No: motivazione (delibera Garante? altro?)

---

## 2. Gap Metadati Importanti (⚠️)

### 2.1 Titolo, Descrizione, Keywords Dataset

**Assenti**: Metadati descrittivi dataset

**Metadati Excel**:

- Titolo: Non specificato
- Descrizione: Non specificato
- Keywords: Non specificato
- Soggetto: Non specificato
- Categoria: Non specificato

**Richiesto**: Metadati descrittivi base (es. Dublin Core)

### 2.2 Definizione "Incidenza Vittime Genere Femminile"

**Vago**: Fogli FILE_5 "Vittime"

**Domande**:

- % su totale vittime? Valore assoluto?
- Denominatore: vittime totali reato o popolazione femminile?

**Richiesto**: Formula calcolo "incidenza"

### 2.3 Metodologia Aggregazione FILE_5

**Non documentata**: Come dati granulari SDI aggregati a livello provinciale

**Domande**:

- Criteri aggregazione temporale (anno fatto? anno denuncia?)
- Gestione duplicati (stessa vittima più reati?)
- Conteggio: episodi o comunicazioni SDI?

**Richiesto**: Metodologia aggregazione dettagliata

### 2.4 Criteri Inclusione/Esclusione Reati

**Non specificati**: Quali reati inclusi in "violenza di genere"

**Esempio**:

- Richiesta FOIA: "tentativi femminicidio" → Non presente come categoria separata
- Richiesta: "molestie fisiche/psicologiche" → Non presenti

**Richiesto**:

- Elenco completo reati inclusi (articoli codice penale)
- Criteri selezione "riconducibili violenza genere"

### 2.5 Fonte DCPC vs SDI/SSD

**Confusione**:

- FILE_5 foglio "Omicidi": fonte DCPC
- Altri fogli FILE_5: fonte SDI/SSD
- FILE_6: fonte SDI

**Domande**:

- DCPC è sistema diverso da SDI/SSD?
- Perché omicidi fonte separata?
- Sovrapposizioni/discrepanze DCPC vs SDI?

**Richiesto**: Chiarimento fonti dati e relazioni

### 2.6 Formato FILE_5 Non Normalizzato

**Problema**: Anni come colonne (pivot)

**Impatto**:

- Analisi temporali richiedono trasposizione
- Non conforme best practices opendata
- Difficile integrazione con altri dataset

**Richiesto**: Versione FILE_5 normalizzata (anni come righe)

### 2.7 Changelog Versioni Dataset

**Assente**: Tracciamento modifiche

**Osservato**:

- FILE_5: creato 28 apr, modificato 9 mag (11 giorni modifica)
- FILE_6: creato 6 mag, modificato 9 mag (3 giorni modifica)

**Domande**:

- Cosa modificato tra 28 apr e 9 mag?
- Versione dataset corrente? (v1.0?)

**Richiesto**: Changelog con data, versione, modifiche

### 2.8 Riferimento Delibera Garante 515/2018

**Vago**: Citata per negare dati comunali FILE_5, MA:

- Solo "articolo 5" citato
- Contenuto art. 5 non riportato
- Applicabilità a FILE_5 non argomentata

**Richiesto**:

- Testo integrale art. 5 delibera 515/2018
- Motivazione applicabilità caso specifico
- Perché FILE_6 comunale possibile e FILE_5 no?

### 2.9 Software Generazione FILE_6

**Indicato**: "Apache POI" (libreria Java Excel)

**Domande**:

- Script automatizzato export SDI?
- Versione software?
- Query SQL utilizzate per estrazione?

**Richiesto**:

- Descrizione pipeline estrazione dati
- Versione software/librerie
- Query SQL (se applicabile)

### 2.10 Utente "cla" Modifica FILE_6

**Vago**: Ultima modifica da "cla" (utente generico)

**Richiesto**: Identificazione ruolo responsabile modifica

### 2.11 Periodo Copertura Dettagliato

**Generico**: "2019-2024"

**Domande**:

- Anno civile (1 gen - 31 dic)?
- Anno fiscale?
- 2024 fino a quale mese? (richiesta: 31 dic 2024, MA risposta: 9 mag 2025)

**Richiesto**: Date esatte copertura (es. "1 gen 2019 - 31 dic 2024")

### 2.12 Contatto Tecnico per Chiarimenti

**Assente**: Referente tecnico per domande

**Firmatario risposta**: Direttore Ufficio (ruolo amministrativo)

**Richiesto**:

- Contatto tecnico dataset (email)
- Canale supporto per chiarimenti

---

## 3. Riepilogo Gap per Priorità

### Priorità 1 - CRITICI (🔴)

**15 gap critici** che impediscono riutilizzo/interpretazione:

1. Data estrazione dati SDI/SSD/DCPC
2. Versione schema SDI/SSD
3. Significato "non consolidato 2024"
4. Scope FILE_6 (% copertura relazione V-A)
5. Chiave primaria FILE_6
6. Autore dataset
7. Licenza riutilizzo
8. Codici ISTAT geografici
9. Codici ISO nazioni
10. Semantica DES_OBIET vs LUOGO_SPECIF_FATTO
11. Valori ammessi RELAZIONE_AUTORE_VITTIMA
12. Gestione valori anomali età
13. Lag temporale registrazione
14. Discrepanze vs ISTAT
15. Pubblicazione online

### Priorità 2 - IMPORTANTI (⚠️)

**12 gap importanti** che riducono qualità/usabilità:

1. Titolo, descrizione, keywords
2. Definizione "incidenza vittime genere femminile"
3. Metodologia aggregazione FILE_5
4. Criteri inclusione/esclusione reati
5. Fonte DCPC vs SDI/SSD
6. Formato FILE_5 non normalizzato
7. Changelog versioni
8. Riferimento delibera Garante 515/2018
9. Software generazione
10. Utente modifica
11. Periodo copertura dettagliato
12. Contatto tecnico

---

## 4. Confronto vs Standard Opendata

### Standard: DCAT-AP_IT (Profilo italiano DCAT)

**Metadati obbligatori**:

| Metadato DCAT | FILE_5/FILE_6 | Stato |
|---------------|---------------|-------|
| Titolo | ❌ Assente | Non conforme |
| Descrizione | ❌ Assente | Non conforme |
| Editore | ⚠️ Parziale (Ministero generico) | Non conforme |
| Tema/Categoria | ❌ Assente | Non conforme |
| Data pubblicazione | ❌ Assente | Non conforme |
| Data modifica | ✅ Presente (metadati Excel) | Conforme |
| Licenza | ❌ Assente | Non conforme |
| Formato | ✅ Excel (MIME type) | Conforme |
| Distribuzione/URL | ❌ Assente (non pubblicato) | Non conforme |

**Metadati raccomandati**:

| Metadato DCAT | FILE_5/FILE_6 | Stato |
|---------------|---------------|-------|
| Punto contatto | ❌ Assente | Non conforme |
| Copertura temporale | ⚠️ Generico (2019-2024) | Parzialmente conforme |
| Copertura geografica | ⚠️ Vago ("Italia") | Parzialmente conforme |
| Frequenza aggiornamento | ❌ Assente | Non conforme |
| Keywords | ❌ Assente | Non conforme |
| Lingua | ⚠️ Implicitamente IT | Parzialmente conforme |

**Conformità globale**: 2/9 obbligatori = **22% conforme** ❌

---

## 5. Raccomandazioni

### Immediate (Richiesta Integrativa)

Richiedere al Ministero:

1. ✅ Data estrazione SDI (per anno/fonte)
2. ✅ Versione schema SDI + changelog
3. ✅ Definizione "non consolidato" + tempistiche
4. ✅ Scope FILE_6: N° totale SDI vs N° con relazione V-A
5. ✅ Chiave primaria FILE_6 corretta
6. ✅ Licenza riutilizzo esplicita
7. ✅ Codici ISTAT geo (nuova versione dataset)
8. ✅ Spiegazione discrepanze vs ISTAT
9. ✅ Pubblicazione online (URL + data)

### Breve Termine (Documentazione Interna)

Produrre internamente:

1. Codebook FILE_6 (valori ammessi campi)
2. Mapping province nome→ISTAT (già parziale in resources/)
3. Analisi lag temporale dettagliata
4. Confronto sistematico FILE_5 vs FILE_6 vs ISTAT

### Lungo Termine (Advocacy Trasparenza)

Proporre standard:

1. Template metadati Ministero per future FOIA
2. Adozione DCAT-AP_IT per dataset SDI
3. Pubblicazione periodica dati violenza genere (es. trimestrale)
4. API REST per accesso programmato SDI (aggregati)

---

## 6. Prossimi Step

1. ✅ Fase 1 completata: Gap metadati documentati
2. ⏭️ Fase 2: Validazione discrepanze Rossella
3. ⏭️ Fase 3: Audit qualità completo
4. ⏭️ Fase 4: Preparare richiesta integrativa con allegati

**Output Fase 1**:

- `metadati_file5.md` ✅
- `metadati_file6.md` ✅
- `analisi_pdf.md` ✅
- `gap_metadati.md` ✅ (questo file)
- `checklist_metadati_richiesti.md` ⏭️ (prossimo)
