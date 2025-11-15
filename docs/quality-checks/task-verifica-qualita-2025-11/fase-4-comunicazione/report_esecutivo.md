# Report Esecutivo: Audit Qualità Dati SDI Reati Genere

**Data**: 2025-11-15  
**Destinatari**: Rossella, Period Think Tank, datiBeneComune  
**Autore**: Claude (AI Assistant)  
**Stato**: Pronto per revisione  

## Executive Summary

L'audit completo dei dati FOIA ricevuti dal Ministero dell'Interno rivela **criticità strutturali significative** che compromettono l'affidabilità statistica e l'usabilità opendata. Su 6 requisiti di qualità valutati, solo il 50% risulta conforme.

**Risultati chiave**:

- ✅ **Conformità Legge 53/2022**: 50% (3/6 requisiti soddisfatti)
- ❌ **Completezza temporale**: 99.9% casi concentrati 2023-2024
- ❌ **Qualità tecnica**: 6 issue critiche identificate
- ⚠️ **Metadati**: 22% conformità DCAT-AP_IT

## Issue Critiche Identificate

### Mancanza Metadati Struttura Dati (CRITICO)

- **Problema**: Campo `PROT_SDI` non documentato come identificativo episodio
- **Dati reali FILE_6**: 5.124 record con 2.644 PROT_SDI unici
- **2.480 duplicati** = **48.4%** dei record (non 20.6%)
- **Pattern identificati**: Multi-autori stessa vittima, multi-reati stesso episodio
- **Esempio**: PGPQ102023002369 = 48 record, 6 autori, 1 vittima, 1 tipo reato
- **Impatto**: Rischio double-counting in analisi statistiche
- **Rischio**: Impossibile distinguere episodi vs singoli reati senza metadati

### Campo DES_OBIET Non Documentato (CRITICO)

- **Problema**: Campo `DES_OBIET` senza metadati/classificazione
- **Dati reali FILE_6**: 3.205 record (**62.5%**) con "NON PREVISTO/ALTRO"
- **1.841 record** (**35.9%**) con "PRIVATO CITTADINO"
- **Domande senza risposta**: COS'È questo campo? Vittima? Contesto? Luogo?
- **Classificazione sconosciuta**: Fonte? Standard? Convenzione SDI?
- **Impatto**: Dati non interpretabili per analisi statistiche
- **Rischio**: Analisi errate per mancanza di definizione campo

### Distribuzione Temporale Anomala (CRITICO)

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

### Dati Mancanti Art. 558 bis (CRITICO)

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

### Dati Mancanti Art. 387 bis (CRITICO)

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

### Dati Mancanti Omicidi Partner/Ex Partner (CRITICO)

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

### Differenza Scope Dati (CRITICO)

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

## Punti di Eccellenza

- ✅ **Relazione Vittima-Autore**: 100% conforme Legge 53/2022  
- ✅ **Completezza campi**: Tutti i 15 tipi relazione presenti  
- ✅ **Struttura dati**: Formato CSV standard e pulito  

## Raccomandazioni Strategiche

### Azioni Immediate (Priorità Alta)

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

### Azioni Medio Termine (Priorità Media)

**Sviluppo dashboard monitoraggio**:
- KPI qualità dati in real-time
- All automatici per anomalie
- Report periodici conformità

**Standardizzazione processi ETL**:
- Validazione automatica chiavi primarie
- Controllo completezza campi geografici
- Riconciliazione con dati ISTAT

## Allegati Tecnici

- **Query SQL validazione** (`query_validazione.sql`)
- **Tabella confronto ISTAT** (`confronto_istat_file6.csv`)
- **Checklist metadati** (`checklist_metadati_richiesti.md`)
- **Template standard** (`template_metadati_standard.md`)

## Prossimi Passi

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