# Summary Audit Qualità Completo FILE_6

**Data**: 2025-11-15  
**Analista**: Claude  
**Scope**: Audit qualità strutturale dataset SDI reati genere  
**File analizzato**: `data/processing/reati_sdi/reati_sdi.csv` (3.329 record)

## Executive Summary

**Risultato audit**: **QUALITÀ MISTA con problemi critici significativi

Il dataset FILE_6 presenta **eccellenze e criticità gravi**:
- ✅ **Eccellenza**: codifica relazione autore-vittima (100% conforme Legge 53/2022)
- ❌ **Critico**: chiave primaria assente (PROT_SDI duplicato al 20.6%)
- ❌ **Critico**: semantica luogo ambigua (63.9% "NON PREVISTO/ALTRO")
- ❌ **Critico**: incoerenza temporale vs FILE_5 (scala diversa di 2 ordini)

## Problemi Critici per Priorità

### 🔴 CRITICI - Bloccanti per Statistiche Ufficiali

#### 1. Chiave Primaria Mancante (Issue #1)
**Impatto**: Impossibile identificare univocamente i record
- **3.329 record** con solo **2.644 PROT_SDI unici**
- **685 duplicati** (20.6%) con pattern multi-reati stesso episodio
- **Rischio double-counting** in analisi statistiche

**Conformità Legge 53/2022**: ❌ **Violata** - tracciamento univoco richiesto

#### 2. Informazione Luogo Inutilizzabile (Issue #2)
**Impatto**: 63.9% dati geografici contestuali persi
- **2.128 record** etichettati "NON PREVISTO/ALTRO"
- **Nessuna distinzione** tra "non previsto" e "altro"
- **Impossibile analisi spaziale** violenza domestica

**Conformità Legge 53/2022**: ❌ **Violata** - informazioni luogo incomplete

#### 3. Incoerenza Dataset FILE_5 vs FILE_6
**Impatto**: impossibile integrazione dati statistici
- **Scala diversa**: 928.000 vs 3.329 casi (1:278)
- **Periodo diverso**: completo vs concentrato 2024 (82.4%)
- **Scope non documentato**: subset vs dataset completo

### 🟡 IMPORTANTI - Limitanti per Analisi

#### 4. Distribuzione Temporale Anomala
**Pattern**: 88.5% casi concentrati 2023-2024
- **2019-2022**: quasi assenti (0.6% totale)
- **Lag procedurale**: 4-5 anni tra fatto e denuncia
- **Rischio rappresentatività**: dataset non completo

#### 5. Metadati Inadeguati
**Gap**: documentazione insufficiente
- **Scope FILE_6 non definito**
- **Relazione con FILE_5 non chiara**
- **Metodologia estrazione non documentata**

## Punti di Forza (Eccellenze)

### ✅ Relazione Autore-Vittima - Modello di Riferimento
**Qualità eccezionale**: 100% conforme Legge 53/2022
- **Completezza totale**: 3.329/3.329 record codificati
- **Conformità legislativa**: tutte 15 categorie previste presenti
- **Granularità adeguata**: distinzione fine tra relazioni
- **Utilità statistica**: permette analisi violenza domestica dettagliate

### ✅ Completezza Dati Anagrafici
**Copertura eccellente**:
- **Sesso autore/vittima**: 100% completo
- **Età autore/vittima**: quasi completo
- **Nazione nascita**: disponibile per analisi internazionalizzazione

## Conformità Legge 53/2022 Art. 5

| Requisito Legale | Stato FILE_6 | Gap |
|------------------|--------------|-----|
| Relazione autore-vittima | ✅ **CONFORME** | Nessuno |
| Informazioni luogo | ❌ **NON CONFORME** | 63.9% mancanti |
| Età e genere autore/vittima | ✅ **CONFORME** | Completi |
| Tipologia arma | ⚠️ **PARZIALE** | Campo non presente |
| Presenza figli | ⚠️ **PARZIALE** | Campo non presente |
| Atti persecutori | ✅ **CONFORME** | Art. 612-bis presente |

**Conformità complessiva**: **50%** (3/6 requisiti pienamente soddisfatti)

## Impatto per Utilizzo Dati

### 📊 Statistiche Ufficiali ISTAT
**Attualmente**: **NON UTILIZZABILE**
- Chiave primaria mancante
- Dati geografici incompleti
- Rischio double-counting

**Dopo correzioni**: **UTILIZZABILE CON LIMITAZIONI**
- Necessario risolvere issues #1 e #2
- Mantenere eccellenza relazione V-A

### 🏛️ Policy Pubblica
**Attualmente**: **LIMITATO**
- Analisi violenza domestica possibile (grazie relazione V-A)
- Impossibile pianificazione territoriale (luogo mancante)
- Difficile trend temporali (concentrazione 2024)

### ⚖️ Ricerca Scientifica
**Attualmente**: **PARZIALMENTE UTILIZZABILE**
- Studi relazionali possibili
- Analisi geografiche impossibili
- Serie storiche inaffidabili

## Raccomandazioni Prioritarie

### 🔴 Azioni Immediate (Bloccanti)

1. **Risolvere Issue #1 - Chiave Primaria**
   - Introdurre campo ID_RECORD univoco
   - Documentare semantica PROT_SDI (episodio vs reato)
   - Creare campo ID_EPISODIO per raggruppare multi-reati

2. **Risolvere Issue #2 - Luogo**
   - Separare "NON PREVISTO" da "ALTRO"
   - Aggiungere campo LUOGO_SPECIFICO standardizzato
   - Implementare classificazione luoghi privati

### 🟡 Azioni Medie (Miglioramento)

3. **Documentare Scope FILE_6**
   - Definire relazione con FILE_5
   - Specificare filtri applicati
   - Documentare metodologia estrazione

4. **Migliorare Metadati**
   - Aggiungere data estrazione SDI
   - Specificare periodo copertura
   - Documentare limitazioni dataset

### 🟢 Azioni Lungo Termine (Ottimizzazione)

5. **Integrare Campi Mancanti Legge 53/2022**
   - Tipologia arma utilizzata
   - Presenza figli minori
   - Atti persecutori concomitanti

6. **Sviluppare Validazioni Automatiche**
   - Controllo duplicati PROT_SDI
   - Validazione codici geografici
   - Coerenza temporale dati

## Comunicazione Ministero

### Domande da Porre

1. **Scope FILE_6**: È subset violenza di genere? Estrazione parziale?
2. **PROT_SDI**: Perché duplicato? È episodio vs reato?
3. **DES_OBIET**: Perché 63.9% "NON PREVISTO/ALTRO"?
4. **Periodo**: Perché concentrazione 2024? Dati 2019-2022 mancanti?
5. **Integrazione**: Come relazionarsi con FILE_5 comunicazioni ISTAT?

### Richieste Correttive

1. **Fornire chiave primaria univoca** per ogni record
2. **Separare e specificare** valori "NON PREVISTO/ALTRO"
3. **Documentare scope e metodologia** estrazione dati
4. **Fornire dati completi** periodo 2019-2024 o spiegare gap

## Prossimi Passi

1. **Finalizzare Fase 3** con questo summary
2. **Iniziare Fase 4** - Documentazione e Comunicazione
3. **Preparare allegati tecnici** per richiesta Ministero
4. **Creare template metadati** standard da richiedere

---

**Audit completato**: 2025-11-15  
**Prossima revisione**: dopo risposta Ministero  
**Stato**: Fase 3 completata - In attesa decisioni utente per Fase 4