# Checklist Allegati – Comunicazione Ministero

## Allegati da includere nella comunicazione

### 📎 Allegati Tecnici (obbligatori)

- [ ] **findings_rossella_validazione.md**
  - Formato: PDF (stampabile) + MD (per repository)
  - Descrizione: Analisi dettagliata discrepanze FOIA vs ISTAT Codice Rosso 2020
  - Uso: Supporto evidence per undercount art. 558 bis, 583 quinquies
  - Size: ~5 KB

- [ ] **analisi_temporale_codice_rosso.csv**
  - Formato: CSV (tabulare) + visualizzazione Excel
  - Descrizione: Distribuzione temporale 2019-2024 per tipo reato
  - Uso: Dati numerici dimostrazione
  - Size: ~2 KB

- [ ] **template_metadati.md**
  - Formato: Markdown + Excel compilabile
  - Descrizione: Schema metadati proposto
  - Uso: Dimostrazione di cosa manca, proposta concreta
  - Size: ~15 KB

- [ ] **issue_lalafrufru_integrazione.md**
  - Formato: Markdown
  - Descrizione: Integrazione GitHub issue #1, #2 (chiave primaria, DES_OBIET ambiguo)
  - Uso: Evidenziare problematiche file_6 riportate dalla community
  - Size: ~8 KB

---

### 📋 Allegati Amministrativi (dipende da canale)

#### Se comunicazione formale (PEC/mail istituzionale):

- [ ] **Lettera_Ministero_FIRMATA.pdf**
  - Firma digitale o scansione firma autografa
  - Intestazione organizzazione (Period Think Tank / datiBeneComune)
  - Riferimento FOIA: MI-123-U-A-SD-2025-90

#### Se comunicazione mail esplorativa:

- [ ] **Lettera_Ministero_DRAFT.md**
  - Corpo mail (non file allegato)
  - Link a repository pubblico con allegati

---

### 🔗 Allegati di Riferimento (citare, non inviare)

- [ ] Link report ISTAT "Codice Rosso 2020"
  - URL: [come reperire dal sito ISTAT]
  - Uso: Benchmark validazione

- [ ] Link repository GitHub progetto
  - URL: [repository dati_sdi_reati_genere]
  - Uso: Full transparency, pubblicamente verificabile

- [ ] Link FOIA originale
  - Data richiesta: 18 aprile 2025
  - Richiedente: Avv. Giulia Sudano (Period Think Tank)

---

## VARIANTI PER CANALE

### Opzione A: Mail esplorativa (CONSIGLIATA per primo contatto)

**Destinatario**: Dipartimento della Pubblica Sicurezza + Servizio Analisi Criminale

**Allegati**:
- ❌ Niente (corpo mail + link)

**Corpo mail**: 
- Lettera sintetica (max 300 parole)
- Link GitHub con full analysis

**Vantaggio**: Leggero, non formale, room per feedback

**Follow-up**: Se positivo → versione formale con metadati

---

### Opzione B: Comunicazione formale PEC

**Destinatario**: protocollo@pec.interno.it (o indirizzo FOIA Ministero)

**Allegati**:
- ✅ Lettera_Ministero_FIRMATA.pdf (3 pagine)
- ✅ findings_rossella_validazione.md (PDF)
- ✅ analisi_temporale_codice_rosso.csv
- ✅ template_metadati.md (PDF)

**Protocollo**: 
- Numero protocollo: [auto-generato dal sistema]
- Allegati descritti in corpo lettera
- Richiesta ricevuta: "Si cortesemente di notificare ricezione"

**Vantaggio**: Tracciato, formale, SLA di legge

**Disadvantage**: Più lento, meno dialogo

---

### Opzione C: GitHub Issue (se Ministero ha repo pubblico)

**Se Ministero pubblica dati su GitHub** (attualmente non noto):

**Allegati**:
- ✅ Link a issue repository nostra
- ✅ Citazione dati con @mentions

**Vantaggio**: Trasparenza massima, community engagement

**Disadvantage**: Se Ministero non usa GitHub → non efficace

---

## TIMING E TRACKING

### Invio

- **Data prevista**: [definire]
- **Canale**: [scegliere A/B/C sopra]
- **Mittente**: [Andrea? Period Think Tank? Collettivo?]
- **Cc**: datiBeneComune, supporto tecnico (se rilevante)

### Tracking

| Fase | Timing | Azione |
|------|--------|--------|
| **Invio** | Giorno 0 | Spedizione comunicazione |
| **Ricezione** | Giorno 1-2 | Conferma ricezione (if PEC) |
| **Valutazione interna** | Giorno 1-30 | Ministero esamina richieste |
| **Primo feedback** | Giorno 30 | Atteso: risposta o "in valutazione" |
| **Follow-up** | Giorno 45 | Se non risposto: escalation |
| **Response deadline** | Giorno 60 | SLA standard FOIA (30 giorni) |

---

## GESTIONE RISPOSTA

### Scenario 1: Risposta positiva ✅

- **Se Ministero fornisce dati integrati**:
  - ✅ Procedere con task-003: validazione nuovi dati
  - ✅ Creazione report pubblico "Data validation report"
  - ✅ Feedback loop: comunicare risultati

- **Se Ministero fornisce chiarimenti**:
  - ✅ Aggiornare metadati repository
  - ✅ Correggere analisi se necessario
  - ✅ Pubblicare "Data quality improvements" changelog

### Scenario 2: Risposta parziale ⚠️

- **Se Ministero fornisce solo alcuni metadati**:
  - 📌 Valutare se sufficiente per scopo
  - 📌 Se no: follow-up specifico per items mancanti

### Scenario 3: Nessuna risposta ❌

- **A giorno 45**: Follow-up cortese
- **A giorno 60**: Valutare escalation
  - Contattare datiBeneComune per advocacy
  - Considerare FOIA transparency advocacy
  - Pubblicare "Analysis of government responsiveness"

---

## NOTE PER COMUNICAZIONE

### Tone guida

- ✅ **Professionale, costruttivo, non accusatorio**
- ✅ **Apprezzare sforzo trasparenza, poi evidenziare gap**
- ✅ **Proporre soluzioni concrete** (non solo problemi)
- ✅ **Framing**: "migliorare riuso dati" ≠ "errori ministeriali"

### Evitare

- ❌ Tono critico severo
- ❌ Accusare di negligenza
- ❌ Richieste generiche senza specifiche
- ❌ Minacce o escalation iniziale

### Enfatizzare

- ✅ Utilità pubblica (ricerca, policy, cittadini)
- ✅ Best practice internazionali (FAIR data)
- ✅ Facilità implementazione proposte
- ✅ Willingness a collaborare

---

## DOCUMENTI DI SUPPORTO INTERNO

**Per team**:

- [ ] Log comunicazioni (tracking risposta)
- [ ] Template risposta Ministero (se forniscono dati: come processarli?)
- [ ] Decision tree follow-up scenarios

---

## Prossimo passo

Una volta definiti:
1. Canale comunicazione (A/B/C)
2. Mittente/organizzazione
3. Date target

→ Procedi con **creazione final letter** e invio.
