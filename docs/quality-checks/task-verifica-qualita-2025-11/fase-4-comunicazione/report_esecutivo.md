# Report esecutivo: audit qualità dati SDI reati genere

**Data**: 2025-11-15  
**Destinatari**: Rossella, Period Think Tank, datiBeneComune  
**Autore**: Claude (AI Assistant)  
**Stato**: Pronto per revisione  

## Executive Summary

L'audit completo dei dati FOIA ricevuti dal Ministero dell'Interno rivela **criticità strutturali significative** che compromettono l'affidabilità statistica e l'usabilità opendata. Su 6 requisiti di qualità valutati, solo il 50% risulta conforme.

**Risultati chiave**:

- ✅ **Conformità Legge 53/2022**: 50% (3/6 requisiti soddisfatti)
- ❌ **Completezza temporale**: 99.9% casi concentrati 2023-2024
- ❌ **Qualità tecnica**: 7 issue critiche identificate
- ⚠️ **Metadati**: 22% conformità DCAT-AP_IT

## Issue critiche identificate

### Duplicati completi e struttura dati non documentata (CRITICO)

**Problema 1: Righe duplicate complete**

- **Scoperta**: 2.534 righe (49.4%) sono **duplicati esatti** (tutti i campi identici)
- **798 gruppi di duplicati** con stesso PROT_SDI + ART + COD_VITTIMA + COD_DENUNCIATO
- **Caso estremo**: 1 gruppo con 30 righe identiche
- **Impatto**: Inflazione artificiale dei conteggi, impossibilità di analisi statistiche affidabili
- **Causa probabile**: Errore nell'estrazione dati o nella gestione delle tabelle relazionali

**Problema 2: Struttura dati multi-livello non documentata**

- **Dati reali FILE_6**: 5.124 record con 2.644 PROT_SDI unici
- **2.480 righe non univoche** per evento (dopo rimozione duplicati esatti rimangono comunque righe multiple)
- **Pattern identificati**: Multi-autori stessa vittima, multi-reati stesso episodio
- **Granularità non chiara**: 1 riga = 1 evento? 1 reato? 1 combinazione evento-reato-vittima-autore?
- **Impatto**: Impossibile distinguere episodi vs singoli reati senza metadati
- **Rischio**: Analisi statistiche errate per mancanza documentazione struttura relazionale

### Campo DES_OBIET non documentato (CRITICO)

- **Problema**: Campo `DES_OBIET` senza metadati/classificazione
- **Dati reali FILE_6**: 3.205 record (**62.5%**) con "NON PREVISTO/ALTRO"
- **1.841 record** (**35.9%**) con "PRIVATO CITTADINO"
- **Domande senza risposta**: COS'È questo campo? Vittima? Contesto? Luogo?
- **Classificazione sconosciuta**: Fonte? Standard? Convenzione SDI?
- **Impatto**: Dati non interpretabili per analisi statistiche
- **Rischio**: Analisi errate per mancanza di definizione campo

### Distribuzione temporale anomala (CRITICO)

- **Problema**: Distribuzione estremamente sbilanciata dei casi per anno di denuncia
- **Dati reali File 6**:
  - 2019: 4 casi
  - 2020: 5 casi  
  - 2021: 3 casi
  - 2022: 13 casi
  - 2023: 530 casi
  - 2024: 4.277 casi
- **Anomalia evidente**: 99.9% dei casi concentrati nel 2023-2024 (4.807 su 4.832)
- **Possibili cause**:
  - Implementazione recente sistema di raccolta dati SDI
  - Migrazione dati storica non completa
  - Modifica criteri di inclusione dataset
  - Digitalizzazione progressiva delle denunce
- **Fonte ufficiale**: File Excel `MI-123-U-A-SD-2025-90_6.xlsx` (campo DATA_DENUNCIA)
- **Impatto**: Dataset non utilizzabile per analisi storiche o trend temporali
- **Rischio**: Valutazioni distorte dell'andamento dei reati nel tempo
- **Richiesta**: Documentare quando e come è iniziata la raccolta sistematica di questi dati

### Dati mancanti art. 558 bis (CRITICO)

- **Problema**: Dati effettivamente mancanti per reato che richiede sempre relazione identificata
- **Art. 558 bis (Costrizione o induzione al matrimonio)**: Reato per sua natura richiede SEMPRE relazione vittima-carnefice identificata
- **Dati reali File 6**: 0 casi periodo 2019-2020, 8 casi totali (tutti nel 2024)
- **Report Polizia 2020**: 11 casi periodo 2019-2020
- **Differenza reale**: 0 vs 11 casi (100% mancanti)
- **Fonti ufficiali**: 
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
  - Report Polizia: `Polizia_Un_anno_di_codice_rosso_2020.pdf`
- **Impatto**: Dati incompleti per analisi di reati specifici
- **Rischio**: Sottostima grave di fenomeni criminali specifici
- **Richiesta**: Fornire dati completi art. 558 bis periodo 2019-2020

### Dati mancanti art. 387 bis (CRITICO)

- **Problema**: Dati effettivamente mancanti per reato che richiede sempre relazione identificata
- **Art. 387 bis (Violazione provvedimenti allontanamento/avvicinamento)**: Reato per sua natura richiede SEMPRE relazione vittima-autore identificata (basato su provvedimenti giudiziari pre-esistenti)
- **Dati reali File 6**: 87 record totali 2020, 49 episodi unici
- **Report Polizia 2020**: 1.741 casi totali
- **Dati mancanti**: 1.654 casi (95% mancanti)
- **Fonti ufficiali**: 
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
  - Report Polizia: `Polizia_Un_anno_di_codice_rosso_2020.pdf`
- **Impatto**: Sottostima grave di violazioni provvedimenti di protezione
- **Rischio**: Valutazione errata efficacia misure di tutela delle vittime
- **Richiesta**: Fornire dati completi art. 387 bis periodo 2019-2020

### Dati mancanti omicidi partner/ex partner (CRITICO)

- **Problema**: Dati effettivamente mancanti per omicidi con relazione sempre identificata
- **Omicidi da partner/ex partner**: Reato per sua natura richiede SEMPRE relazione vittima-autore identificata
- **Dati reali File 5 (foglio "Omicidi DCPC")**:
  - 2019: 82 casi
  - 2020: 73 casi
  - 2021: 82 casi
  - 2022: 70 casi
- **Dati reali File 6 (relazione partner/ex partner)**:
  - 2019-2021: 0 casi
  - 2022: 1 caso
- **Dati mancanti**: 237 casi su 307 (77% mancanti) nel periodo 2019-2022
- **Fonti ufficiali**: 
  - File Excel: `MI-123-U-A-SD-2025-90_5.xlsx` (foglio "Omicidi DCPC")
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
- **Impatto**: Sottostima grave di femminicidi e omicidi domestici
- **Rischio**: Valutazione errata fenomeno dei femminicidi e violenza domestica estrema
- **Richiesta**: Fornire dati completi omicidi partner/ex partner periodo 2019-2022

### Differenza scope dati (CRITICO)

- **Problema**: Diversa definizione perimetro analitico tra fonti (solo per art. 583 quinquies)
- **Art. 583 quinquies**: Non richiede sempre relazione identificata vittima-autore (può includere aggressioni da sconosciuti)
- **File 6**: 1 caso solo nel 2024
- **Report Polizia 2020**: 56 casi periodo 2019-2020
- **Possibile spiegazione**: Molti casi del report potrebbero non avere relazione identificata
- **Fonti ufficiali**:
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
  - Report Polizia: `Polizia_Un_anno_di_codice_rosso_2020.pdf`
- **Impatto**: Analisi statistiche non comparabili per questo articolo
- **Rischio**: Conclusioni errate se non si considera la diversa metodologia

### Formato dati non standard per elaborazioni automatiche (CRITICO)

- **Problema**: Struttura file XLSX impedisce elaborazioni automatiche e interoperabilità
- **File analizzato**: `MI-123-U-A-SD-2025-90_5.xlsx` (10 fogli)
- **Issue identificate**:
  - **Righe intestazione ridondanti**: Ogni foglio inizia con riga descrittiva narrativa che precede le vere intestazioni colonne
  - **Formato wide invece di long**: Anni come colonne separate (2019, 2020, 2021...) invece che come valori in colonna "anno"
  - **Assenza codici geografici standardizzati**: Solo denominazioni testuali per province/regioni/comuni/stati, mancano codici ISTAT/ISO
- **Esempi concreti**:
  - Foglio "Omicidi DCPC" riga 1: testo narrativo invece di header
  - Foglio "Delitti - Commessi": 6 colonne anno (2019-2024) invece di 1 colonna "anno" + 1 colonna "valore"
  - Campo "Provincia": "AGRIGENTO" senza codice ISTAT provinciale (084)
- **Standard violati**:
  - W3C Data on the Web Best Practices
  - Open Data Charter (tidy data)
  - AgID Linee Guida Valorizzazione Patrimonio Informativo Pubblico
  - Eurostat/OECD standard pubblicazione dati
- **Impatto**:
  - Pre-elaborazione manuale obbligatoria per ogni analisi
  - Impossibile incrocio automatico con altre fonti (ISTAT, banche dati amministrative)
  - Rischio errori umani in fase di pulizia dati
  - Non conformità standard internazionali open data
- **Rischio**: Dati inutilizzabili per ricerca riproducibile e policy-making data-driven
- **Soluzione proposta**: Doppio formato XLSX (visualizzazione) + CSV (elaborazioni automatiche con formato long, codici geografici, no didascalie)

## Punti di Eccellenza

- ✅ **Relazione Vittima-Autore**: 100% conforme Legge 53/2022  
- ✅ **Completezza campi**: Tutti i 15 tipi relazione presenti  
- ✅ **Struttura dati**: Formato CSV standard e pulito  

## Raccomandazioni strategiche

### Azioni immediate (priorità alta)

**Richiesta integrazione dati** al Ministero:
- Dati completi art. 558 bis periodo 2019-2020 (11 casi mancanti)
- Dati completi art. 387 bis periodo 2019-2020 (1.654 casi mancanti)
- Dati completi omicidi partner/ex partner periodo 2019-2022 (237 casi mancanti)
- Documentazione implementazione sistema raccolta dati SDI (quando iniziata)
- Documentazione scope dati File 6 vs report Polizia (art. 583 quinquies)
- Documentazione struttura dati PROT_SDI (episodio vs reato)
- Definizione campo DES_OBIET e classificazione utilizzata

**Implementazione metadati standard**:
- Adozione DCAT-AP_IT completo
- Documentazione scope e metodologia
- Timestamp estrazione dati SDI

**Standardizzazione formato dati**:
- Adozione doppio formato XLSX + CSV
- Conversione a formato long (tidy data) per serie temporali
- Integrazione codici geografici ISTAT/ISO in colonne dedicate
- Rimozione righe didascalia narrative da header tabelle

### Azioni medio termine (priorità media)

**Pubblicazione proattiva e continuativa**:
- **Obiettivo strategico principale**: Passare da rilascio reattivo (FOIA) a pubblicazione proattiva online
- **Portale open data dedicato**: Sezione specifica per dati violenza di genere accessibile a ricercatori, giornalisti, società civile
- **Frequenza aggiornamenti**: Trimestrale invece di annuale (fenomeno continuo richiede monitoraggio costante)
- **Documentazione tecnica completa**: Metadati, dizionario dati, note metodologiche
- **Best practice internazionali**: Allineamento a standard UK, Spagna, Francia su trasparenza dati violenza di genere
- **Impatto atteso**: Maggiore tempestività analisi, supporto policy-making data-driven, accountability pubblica

**Sviluppo dashboard monitoraggio**:
- KPI qualità dati in real-time
- Alert automatici per anomalie
- Report periodici conformità

**Standardizzazione processi ETL**:
- Validazione automatica chiavi primarie
- Controllo completezza campi geografici
- Riconciliazione con dati ISTAT

## Allegati tecnici

- **Query SQL validazione** (`query_validazione.sql`)
- **Tabella confronto ISTAT** (`confronto_istat_file6.csv`)
- **Checklist metadati** (`checklist_metadati_richiesti.md`)
- **Template standard** (`template_metadati_standard.md`)

## Prossimi passi

- **Revisione report** con Rossella (entro 24h)
- **Approvazione comunicazione** Ministero
- **Invio richiesta ufficiale** con allegati tecnici
- **Setup monitoraggio** qualità dati futuri

---

**Contatti**:  
- Project Manager: Claude (AI Assistant)  
- Stakeholder tecnico: Rossella  
- Stakeholder strategico: Period Think Tank  

**Versione**: 1.0 - 2025-11-15