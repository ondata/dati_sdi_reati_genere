# Metadati FILE_6: MI-123-U-A-SD-2025-90_6.xlsx

**File**: `data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx`
**Analisi**: 2025-11-15

## Proprietà File Excel

**Dimensioni**:

- Byte: 770.306 (0.73 MB)
- Formato: Excel 2007+ (.xlsx)

**Metadati documento**:

- **Autore**: Apache POI
- **Ultima modifica da**: cla
- **Data creazione**: 2025-05-06 10:45:49
- **Data ultima modifica**: 2025-05-09 07:29:21
- **Titolo**: Non specificato
- **Soggetto**: Non specificato
- **Descrizione**: Non specificato
- **Keywords**: Non specificato
- **Categoria**: Non specificato

## Struttura Fogli

**Numero fogli**: 1

### Sheet (unico foglio)

- **Righe**: 5.125 (header + 5.124 dati)
- **Colonne**: 28
- **Colonne non vuote**: 28

**Contenuto**:

- Elenco comunicazioni SDI con "relazione vittima-autore" codificata
- Casi riconducibili a violenza di genere
- Disaggregazione geografica: fino a livello **comunale** (luogo del fatto)

## Schema Colonne (28 totali)

### Identificazione comunicazione

1. **PROT_SDI**: Protocollo comunicazione SDI
   - ⚠️ PROBLEMA NOTO: Non univoco (issue #1)
   - Esempio duplicazione: "BOPC042024000134" ripetuto 5 volte

2. **TENT_CONS**: Tentato/Consumato
   - Valori: T (tentato), C (consumato)

### Classificazione reato

3. **T_NORMA**: Tipo norma giuridica
4. **RIF_LEGGE**: Riferimento legge
5. **ART**: Articolo di legge
6. **DES_REA_EVE**: Descrizione reato/evento (full-text)
   - Es: "COSTRIZIONE O INDUZIONE AL MATRIMONIO" invece di "art. 558 bis"
   - ⚠️ PROBLEMA: Difficile parsing automatico

### Date

7. **DATA_INIZIO_FATTO**: Data inizio fatto reato (YYYY-MM-DD)
8. **DATA_FINE_FATTO**: Data fine fatto reato (YYYY-MM-DD)
9. **DATA_DENUNCIA**: Data denuncia (YYYY-MM-DD)
   - ⚠️ CRITICO: Lag medio 5 anni (2019→2024) - vedi analisi Rossella

### Luogo

10. **STATO**: Stato (es. ITALIA)
    - ⚠️ PROBLEMA: Spesso vuoto per Italia

11. **REGIONE**: Nome regione (testuale)
12. **PROVINCIA**: Nome provincia (testuale)
    - ❌ Codici ISTAT assenti (issue #27)
    - ⚠️ Errori nomi (es. Sardegna - vedi resources/problemi_province_sardegna.jsonl)

13. **COMUNE**: Nome comune (testuale)
    - ❌ Codici ISTAT assenti
    - ⚠️ Errori nomi

### Denunciato/Autore

14. **COD_DENUNCIATO**: Codice denunciato (anonimizzato)
15. **SESSO_DENUNCIATO**: Sesso denunciato (M/F)
16. **ETA_DENUNCIATO**: Età denunciato
    - ⚠️ PROBLEMA NOTO: Valori anomali (-2, 1930)

17. **NAZIONE_NASCITA_DENUNCIATO**: Nazione nascita denunciato (testuale)
    - ❌ Codici standard ISO assenti (issue #17)

### Colpito da provvedimento

18. **COD_COLP_DA_PROVV**: Codice colpito da provvedimento
19. **SEX_COLP_PROVV**: Sesso colpito da provvedimento (M/F)
20. **ETA_COLP_PROVV**: Età colpito da provvedimento
21. **NAZIONE_NASCITA_COLP_PROVV**: Nazione nascita

### Vittima

22. **COD_VITTIMA**: Codice vittima (anonimizzato)
23. **SEX_VITTIMA**: Sesso vittima (M/F)
24. **ETA_VITTIMA**: Età vittima
25. **NAZIONE_NASCITA_VITTIMA**: Nazione nascita vittima (testuale)

### Relazione e contesto

26. **RELAZIONE_AUTORE_VITTIMA**: Relazione tra autore e vittima
    - **FILTRO CRITICO**: Solo comunicazioni con questo campo valorizzato sono incluse in FILE_6
    - Scope FILE_6 determinato da questo criterio (non documentato in risposta)
    - Es. valori: "CONIUGE", "EX CONIUGE", "CONVIVENTE", "FIGLIO/A", ecc.

27. **DES_OBIET**: Descrizione obiettivo/oggetto
    - ⚠️ PROBLEMA NOTO: Semantica ambigua (issue #2)
    - 62.5% valori = "NON PREVISTO/ALTRO"
    - Differenza con LUOGO_SPECIF_FATTO non chiara

28. **LUOGO_SPECIF_FATTO**: Luogo specifico fatto
    - ⚠️ PROBLEMA: Sovrapposizione semantica con DES_OBIET

## Caratteristiche Strutturali

**Formato dati**:

- Struttura granulare: 1 riga = 1 comunicazione SDI
- Normalizzato (anni come righe, non colonne)
- ⚠️ PROBLEMA: Chiave primaria ambigua (PROT_SDI duplicato)

**Periodicità**:

- 2019-2024 (6 anni)
- **2024 NON consolidato**

**Fonte dati**:

- SDI (Sistema di Indagine)
- Solo comunicazioni con "relazione vittima-autore" codificata

**Aggregazione geografica**:

- Livello comunale (luogo del fatto)
- ✅ Conforme a richiesta FOIA (punto 2: "forma più granulare possibile")

## Scope FILE_6 (Critico)

**Filtro applicato** (da risposta Ministero pag. 2):

> "In relazione al punto 4 della richiesta, si trasmette un secondo file, in formato excel, contenente l'elenco delle comunicazioni presenti in SDI riconducibili ai casi di violenza di genere, **ove sia stata indicata una "relazione vittima autore"**, disaggregate fino a livello "Comune" (luogo del fatto)."

**Implicazioni**:

- FILE_6 è **sottinsieme filtrato** di SDI, non estratto completo
- Solo comunicazioni con campo RELAZIONE_AUTORE_VITTIMA valorizzato
- ⚠️ PROBLEMA: % copertura non documentata (quanti reati esclusi?)
- ⚠️ PROBLEMA: Criteri completezza codifica relazione V-A non specificati

**Discrepanze note vs ISTAT** (da analisi Rossella):

FILE_6 vs Report ISTAT "Un anno di Codice Rosso" (ago 2019 - ago 2020):

| Articolo | ISTAT | FILE_6 | Delta | Severità |
|----------|-------|--------|-------|----------|
| Art. 558 bis | 11 casi | 0 casi | -100% | 🔴 CRITICO |
| Art. 583 quinquies | 56 casi | 0 casi | -100% | 🔴 CRITICO |
| Art. 612 ter | 718 casi | ~8 casi | -98.9% | 🔴 CRITICO |
| Art. 387 bis | 1.741 casi | 0 casi | -100% | 🔴 CRITICO |

**Spiegazione parziale**: Filtro "relazione V-A" esclude molti casi, MA non giustifica 100% missing.

## Note Tecniche

**Software generazione**:

- Autore: "Apache POI" (libreria Java per Excel)
- Ultima modifica: "cla" (utente generico)
- Suggerisce: Export automatizzato da database SDI

**Periodo copertura**:

- Richiesta FOIA: 1 gennaio 2019 - 31 dicembre 2024
- Risposta: 2019-2024 (conforme)

## Gap Metadati Identificati

**Critici** (🔴):

- 🔴 **Scope FILE_6 non documentato**: % reati con relazione V-A codificata vs totale?
- 🔴 **Criteri inclusione relazione V-A**: Quali valori ammessi? Soglia completezza?
- 🔴 **Data estrazione SDI**: Non specificata (solo data modifica file: 9 maggio 2025)
- 🔴 **Versione schema SDI**: Non documentata
- 🔴 **Significato "non consolidato 2024"**: Non definito
- 🔴 **Chiave primaria dataset**: PROT_SDI duplicato - quale usare?
- 🔴 **Semantica righe duplicate PROT_SDI**: 1 episodio con N vittime? N reati? Errore?
- 🔴 **Licenza dati**: Non specificata
- 🔴 **Codici ISTAT geo**: Assenti (province, comuni)
- 🔴 **Codici ISO nazioni**: Assenti

**Importanti** (⚠️):

- ⚠️ Titolo/Descrizione file: Assenti
- ⚠️ Keywords: Assenti
- ⚠️ Definizione campi DES_OBIET vs LUOGO_SPECIF_FATTO: Non chiara
- ⚠️ Valori ammessi RELAZIONE_AUTORE_VITTIMA: Non documentati
- ⚠️ Gestione valori anomali età: Non spiegata (perché -2, 1930?)
- ⚠️ Changelog versioni: Assente (file creato 6 mag → modificato 9 mag)
- ⚠️ Lag temporale registrazione: Non documentato (bulk update 2023-2024?)

**Secondari** (ℹ️):

- ℹ️ Categoria documento: Assente
- ℹ️ Soggetto documento: Assente
- ℹ️ Link pubblicazione online: Assente

## Riferimenti

**Risposta Ministero**:

- Protocollo: MI-123-U-A-SD-2025-90
- Data: 9 maggio 2025
- Firmatario: Direttore Ufficio Affari Generali (Avizzano)

**Richiesta FOIA originale**:

- Data: 18 aprile 2025
- Richiedente: Avv. Giulia Sudano (Period Think Tank)
- Punto 4 richiesta: "dati riferiti al rapporto fra vittima e autore di reato se disponibile"

**Issue GitHub correlate**:

- #1: Chiave primaria FILE_6 (PROT_SDI duplicato)
- #2: Semantica campo DES_OBIET
- #17: Codici standard nazioni
- #27: Codici ISTAT province

**Analisi qualità esistenti**:

- `docs/quality-checks/feedback_revisione_rossella.md`
- `docs/quality-checks/validazione_note_rossella_file6.md`
- `docs/quality-checks/discrepanza_rossella_vs_xls.md`
