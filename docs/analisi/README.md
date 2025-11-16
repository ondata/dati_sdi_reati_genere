# Analisi conformità dataset SDI alla Legge 53/2022

Questa cartella contiene l'analisi di conformità del dataset fornito dal **Dipartimento della Pubblica Sicurezza - Ministero dell'Interno** (fonte SDI/SSD) rispetto ai requisiti della **Legge 21/04/2022 n. 53** - "Disposizioni in materia di statistiche in tema di violenza di genere".

## Contesto

**Dataset analizzato:** `MI-123-U-A-SD-2025-90_6.xlsx`

**Fonte:** Sistema di Indagine (SDI) / Sistema Statistico Dipartimentale (SSD)

**Ente fornitore:** Dipartimento della Pubblica Sicurezza - Ministero dell'Interno

**Base giuridica richiesta dati:** Istanza di accesso civico ai sensi D.Lgs. 33/2013

**Protocollo risposta:** MI-123-U-A-SD-2025-90 del 09/05/2025

**Base normativa obblighi Ministero Interno:** Legge 53/2022, Art. 5, comma 1

> "Il Ministero dell'interno provvede [...] a dotare il Centro elaborazione dati di cui all'articolo 8 della legge 1° aprile 1981, n. 121, di funzionalità che consentano di rilevare [...] ogni eventuale ulteriore informazione utile a definire la relazione autore-vittima [...] nonché, ove noti: l'età e il genere degli autori e delle vittime; le informazioni sul luogo dove il fatto è avvenuto; la tipologia di arma eventualmente utilizzata; se la violenza è commessa in presenza sul luogo del fatto dei figli degli autori o delle vittime; se la violenza è commessa unitamente ad atti persecutori."

## Documenti prodotti

### 1. Proposta al Dipartimento Pubblica Sicurezza

**File:** `proposta_dac_conformita_legge_53_2022.md`

**Contenuto:**
- Sintesi esecutiva gap normativi
- Analisi dati presenti vs dati mancanti richiesti dalla L. 53/2022
- Criticità strutturale (mancanza ID univoco riga)
- 9 integrazioni proposte con priorità
- Raccomandazioni implementative
- Benefici attesi

**Destinatario:** Dipartimento Pubblica Sicurezza - Ministero Interno

### 2. Schema dati tecnico proposto

**File:** `schema_dati_proposto.md`

**Contenuto:**
- **Campi esistenti v1.0** (28 campi attuali con documentazione completa)
- **Campi nuovi v2.0** (25 campi proposti per conformità)
- Convenzioni nomi (SCREAMING_SNAKE_CASE vs snake_case)
- Liste controllate complete con riferimenti normativi
- Indicazione quali liste sono fissate dalla legge
- Note implementative (privacy, valori nulli, campi multipli)
- Changelog versioni

**Formato:** Tabelle tecniche pronte per implementazione database

### 3. Verifica conformità liste controllate

**File:** `verifica_conformita_liste_controllate.md`

**Contenuto:**
- Confronto `RELAZIONE_AUTORE_VITTIMA` → ✅ 100% conforme (15/15 modalità)
- Confronto `ART` (reati) → ⚠️ 91% conforme (21/23 articoli, mancano 585, 600)
- Analisi `LUOGO_SPECIF_FATTO` → ⚠️ 73% classificato "NON PREVISTO/ALTRO"
- Verifica `SESSO_*/SEX_*` → ✅ Conforme
- Raccomandazioni per ogni campo

**Tabella riepilogo conformità**

### 4. Elenchi controllati normativi

**File:** `elenchi_controllati_normativi.md`

**Contenuto completo di TUTTI i 12 elenchi controllati richiesti dalla L. 53/2022:**

1. ✅ Relazione autore-vittima (esplicito, Art. 2 c.2)
2. ✅ Tipologia violenza (esplicito, Art. 4 c.2 lett.a)
3. ✅ Reati da rilevare (esplicito, Art. 5 c.3)
4. ✅ Età e genere (implicito, Art. 5 c.1)
5. ✅ Presenza figli luogo (implicito, Art. 5 c.1)
6. ✅ Violenza + stalking (implicito, Art. 5 c.1)
7. ⚠️ Tipologia arma (campo richiesto, non lista specificata)
8. ⚠️ Luogo fatto (campo richiesto, non lista specificata)
9. ✅ Indicatori rischio (per riferimento, DPCM 2017)
10. ⚠️ Misure protezione (categorie generali, Art. 5 c.5)
11. ✅ Autorità emittente (implicito, Art. 5 c.5)
12. ✅ Esito procedimento (implicito, Art. 5 c.5)

**Punteggio conformità dataset:** 2/12 (17%)

### 5. Enti raccolta dati

**File:** `enti_raccolta_dati_legge_53_2022.md`

**Contenuto:**
- Mappatura completa 8 tipologie enti raccoglitori L. 53/2022
- Ruoli e responsabilità specifiche
- Tempistiche raccolta (triennale, semestrale, continua)
- Flussi dati tra enti
- Sistema interministeriale Interno-Giustizia
- **Focus sul Ministero Interno (CED/SDI)** come fonte dataset analizzato

## Conformità dataset attuale

### ✅ Punti di forza

| Aspetto | Conformità | Note |
|---------|-----------|------|
| Relazione autore-vittima | ✅ 100% | Tutte 15 modalità normative presenti |
| Reati rilevati | ⚠️ 91% | 21/23 articoli (mancano 585, 600) |
| Età autore/vittima | ✅ 100% | Dato presente |
| Genere autore/vittima | ✅ 100% | Dato presente (MASCHIO/FEMMINA) |
| Nazionalità | ✅ Presente | Non richiesto ma utile |
| Dati geografici | ✅ Presente | Regione, provincia, comune |
| Dati temporali | ✅ Presente | Date inizio/fine fatto, denuncia |

### ❌ Criticità e lacune

| Aspetto | Stato | Priorità | Riferimento normativo |
|---------|-------|----------|----------------------|
| **ID univoco riga** | ❌ Assente | **MASSIMA** | Gestione dati |
| Tipologia violenza | ❌ Assente | ALTA | Art. 4 c.2 lett.a |
| Presenza figli luogo | ❌ Assente | ALTA | Art. 5 c.1 |
| Tipologia arma | ❌ Assente | ALTA | Art. 5 c.1 |
| Violenza + stalking | ❌ Assente | ALTA | Art. 5 c.1 |
| Misure protezione | ❌ Assente | ALTA | Art. 5 c.5 |
| Indicatori rischio | ❌ Assente | MEDIA | Art. 4 c.2 lett.c |
| Esito procedimento | ❌ Assente | MEDIA | Art. 5 c.5 |
| Recidiva autore | ❌ Assente | MEDIA | Art. 6 c.2 lett.b |
| Luogo fatto (efficace) | ⚠️ Inadeguato | MEDIA | 73% = "ALTRO" |

## Dati numerici chiave

- **Righe dataset:** 5.124
- **Eventi univoci (PROT_SDI):** 2.644
- **Rapporto righe/eventi:** 1,94 (stesso evento genera più righe)
- **Campi attuali:** 28
- **Campi proposti v2.0:** +25 (totale 53)
- **Periodo coperto:** 2019-2024
- **Nota:** Dati 2024 non consolidati (fonte: risposta MI)

## Conformità normativa complessiva

### Dataset attuale vs Legge 53/2022 Art. 5

| Requisito Art. 5 c.1 | Presente | Conforme |
|---------------------|----------|----------|
| Relazione autore-vittima | ✅ | ✅ 100% |
| Età autori/vittime | ✅ | ✅ |
| Genere autori/vittime | ✅ | ✅ |
| Luogo fatto | ⚠️ | ⚠️ 27% utile |
| Tipologia arma | ❌ | ❌ |
| Presenza figli luogo | ❌ | ❌ |
| Violenza + atti persecutori | ❌ | ❌ |

**Punteggio:** 3/7 requisiti pienamente soddisfatti (43%)

## Raccomandazioni prioritarie

### PRIORITÀ MASSIMA (Prerequisito tecnico)

1. **Introdurre campo `ID_RIGA`** - Identificativo univoco per ogni riga
   - Attualmente impossibile riferirsi univocamente a righe specifiche
   - Blocca qualsiasi aggiornamento/correzione mirata
   - Impedisce tracciabilità modifiche

### PRIORITÀ ALTA (Conformità normativa Art. 5)

2. **Aggiungere `TIPOLOGIA_VIOLENZA`** - 4 modalità normative (fisica/sessuale/psicologica/economica)
3. **Aggiungere `PRESENZA_FIGLI_LUOGO_FATTO`** - Violenza assistita
4. **Aggiungere `TIPOLOGIA_ARMA`** - Valutazione rischio letalità
5. **Aggiungere `VIOLENZA_CON_ATTI_PERSECUTORI`** - Flag stalking
6. **Aggiungere `MISURA_APPLICATA`** - Misure protezione (questore/AG)

### PRIORITÀ MEDIA (Completezza analisi)

7. **Rivedere categorie `LUOGO_SPECIF_FATTO`** - Ridurre 73% "ALTRO"
8. **Aggiungere indicatori rischio revittimizzazione** - DPCM 2017
9. **Completare articoli reati mancanti** - Art. 585, 600

## Utilizzo documenti

Questi documenti sono stati prodotti per:

1. **Supportare richiesta integrazioni** al Dipartimento Pubblica Sicurezza
2. **Fornire specifiche tecniche** per implementazione campi mancanti
3. **Documentare conformità normativa** attuale e target
4. **Facilitare dialogo tecnico** con ente fornitore dati
5. **Preparare eventuali analisi dati** future con schema completo

## Prossimi passi suggeriti

1. ✅ Analisi completata
2. ⏭️ Invio proposta formale a Dipartimento Pubblica Sicurezza
3. ⏭️ Discussione tecnica su modalità implementazione
4. ⏭️ Definizione roadmap integrazioni (graduale vs completa)
5. ⏭️ Formazione operatori inserimento dati
6. ⏭️ Aggiornamento modulistica/sistemi informativi
7. ⏭️ Raccolta dati integrati su nuovi eventi
8. ⏭️ Eventuale recupero retroattivo parziale (analisi testuale descrizioni)

## Riferimenti normativi

- **Legge 21/04/2022 n. 53** - "Disposizioni in materia di statistiche in tema di violenza di genere"
- **D.L. 14/08/2013 n. 93** (conv. L. 119/2013) - Contrasto violenza domestica
- **DPCM 24/11/2017** - Linee guida assistenza donne vittime violenza (All. B: indicatori rischio)
- **D.Lgs. 06/09/1989 n. 322** - Sistema statistico nazionale
- **L. 01/04/1981 n. 121** - Centro elaborazione dati Ministero Interno (Art. 8)

## Contatti tecnici

Per approfondimenti su questa analisi:
- Repository: dati_sdi_reati_genere
- Cartella analisi: `/docs/analisi/`
- Dataset: `/data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx`
