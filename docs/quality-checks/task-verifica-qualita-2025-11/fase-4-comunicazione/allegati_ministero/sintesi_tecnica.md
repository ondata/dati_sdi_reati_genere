# Sintesi tecnica per comunicazione ministero

**Protocollo**: MI-123-U-A-SD-2025-90  
**Data**: 2025-11-15  
**Mittente**: Period Think Tank / datiBeneComune  
**Destinatario**: Dipartimento Pubblica Sicurezza - Ministero dell'Interno  

## Oggetto: richiesta integrazione e correzione dati FOIA

### Contesto

In riferimento alla risposta FOIA MI-123-U-A-SD-2025-90_4 del 15/10/2025, dopo analisi tecnica approfondita dei dati ricevuti, si riscontrano criticità che impattano l'affidabilità statistica e la conformità normativa.

### Issue tecniche identificate

#### Mancanza metadati struttura dati (CRITICO)
- **File**: MI-123-U-A-SD-2025-90_6.xlsx
- **Campo**: PROT_SDI 
- **Problema**: 5.124 record con 2.644 PROT_SDI unici, 2.480 duplicati (48.4%)
- **Pattern**: Multi-autori stessa vittima, multi-reati stesso episodio
- **Esempio**: PGPQ102023002369 = 48 record, 6 autori, 1 vittima, 1 tipo reato
- **Impatto**: Rischio double-counting analisi statistiche
- **Richiesta**: Documentare se PROT_SDI identifica episodio o singolo reato

#### Campo DES_OBIET non documentato (CRITICO)
- **File**: MI-123-U-A-SD-2025-90_6.xlsx
- **Campo**: DES_OBIET
- **Problema**: 3.205 record (62.5%) con "NON PREVISTO/ALTRO", 1.841 (35.9%) "PRIVATO CITTADINO"
- **Domande critiche**: Cos'è questo campo? Vittima? Contesto? Luogo?
- **Classificazione**: Fonte sconosciuta, standard non documentato
- **Impatto**: Dati non interpretabili per analisi statistiche
- **Richiesta**: Definizione campo e dizionario completo valori

#### Differenza scope dati (CRITICO)

- **File**: MI-123-U-A-SD-2025-90_6.xlsx (relazione vittima-autore)
- **Dati reali 2020**: 87 record totali, 49 episodi unici (PROT_SDI)
- **Report Polizia 2020**: 1.741 casi totali Codice Rosso
- **Differenza metodologica**: 
  - File 6: solo casi con relazione identificata vittima-autore
  - Report Polizia: tutti i casi Codice Rosso (art. 387bis, 558bis, 583quinquies, 612ter)
- **Fonti ufficiali**: 
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
  - Report Polizia: `Polizia_Un_anno_di_codice_rosso_2020.pdf`
- **Impatto**: Analisi statistiche non comparabili tra le due fonti
- **Richiesta**: Documentare metodologia e perimetro dati forniti

### Metadati mancanti

Secondo standard DCAT-AP_IT, risultano assenti:

- **Titolo dataset** (obbligatorio)
- **Descrizione completa** (obbligatorio) 
- **Data di estrazione SDI** (critico)
- **Periodo di riferimento esatto** (obbligatorio)
- **Metodologia di raccolta** (importante)
- **Limitazioni e note** (importante)

### Conformità legge 53/2022

**Requisiti soddisfatti (3/6)**:
- ✅ Tipi relazione V-A completi (15/15)
- ✅ Formato dati standard CSV
- ✅ Struttura campi coerente

**Requisiti mancanti (3/6)**:
- ❌ Completezza dati temporali
- ❌ Qualità geografica
- ❌ Metadati completi

### Allegati tecnici

- **Query SQL validazione** - Riproducibile con DuckDB
- **Tabella confronto ISTAT** - Dati mancanti 2019-2020
- **Checklist metadati** - Requisiti DCAT-AP_IT
- **Report audit completo** - Analisi dettagliata

### Richiesta formale

Si richiede formalmente:

- **Integrazione dati** periodo 2019-2020 per art. 387 bis
- **Documentazione struttura** dati PROT_SDI (episodio vs reato)
- **Definizione campo** DES_OBIET e classificazione utilizzata
- **Fornitura metadati** completi secondo DCAT-AP_IT

### Tempi e modalità

- **Preferibile**: Fornitura integrazione entro 30 giorni
- **Formato**: Excel/CSV con metadati completi
- **Contatto tecnico**: [specificare riferimento Ministero]

---

**Documentazione completa disponibile**: https://github.com/[repo]/docs/quality-checks/task-verifica-qualita-2025-11/