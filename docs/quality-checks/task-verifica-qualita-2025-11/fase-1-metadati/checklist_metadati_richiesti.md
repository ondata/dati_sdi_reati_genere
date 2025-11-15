# Checklist Metadati da Richiedere al Ministero

**Versione**: 1.0
**Data**: 2025-11-15
**Obiettivo**: Richiesta integrativa dati FOIA MI-123-U-A-SD-2025-90

## Istruzioni Uso

Questa checklist contiene 27 domande strutturate da porre al Ministero per integrare metadati mancanti FILE_5 e FILE_6.

**Legenda priorità**:

- 🔴 CRITICA: Necessaria per interpretazione/riutilizzo dati
- ⚠️ IMPORTANTE: Migliora qualità/usabilità dati
- ℹ️ UTILE: Documentazione best practices

---

## SEZIONE A: Metadati Temporali

### A1. Data Estrazione Dati (🔴 CRITICA)

**Domanda**:

Qual è la data di estrazione dei dati da SDI, SSD e DCPC per ciascun anno del periodo 2019-2024?

**Dettaglio richiesto**:

- [ ] Data estrazione anno 2019
- [ ] Data estrazione anno 2020
- [ ] Data estrazione anno 2021
- [ ] Data estrazione anno 2022
- [ ] Data estrazione anno 2023
- [ ] Data estrazione anno 2024

**Formato risposta atteso**:

```
Anno | Fonte | Data Estrazione
2019 | SDI   | YYYY-MM-DD
2019 | SSD   | YYYY-MM-DD
...
```

### A2. Definizione "Non Consolidato 2024" (🔴 CRITICA)

**Domanda**:

Cosa significa "dati non consolidati per l'anno 2024" e quando saranno consolidati?

**Dettaglio richiesto**:

- [ ] Definizione "consolidamento" (validazione? integrazione ritardata?)
- [ ] Data prevista consolidamento 2024
- [ ] Stime revisione attese (range % variazione)
- [ ] Stato consolidamento anni 2019-2023

**Formato risposta atteso**:

- Descrizione testuale processo consolidamento
- Data consolidamento: YYYY-MM o "in corso"
- Revisione attesa: ±X%

### A3. Periodo Copertura Esatto (⚠️ IMPORTANTE)

**Domanda**:

Qual è il periodo esatto di copertura dati?

**Dettaglio richiesto**:

- [ ] Data inizio: GG-MM-AAAA
- [ ] Data fine: GG-MM-AAAA
- [ ] Anno civile o fiscale?
- [ ] 2024 coperto fino a quale mese?

**Formato risposta atteso**:

- "1 gennaio 2019 - 31 dicembre 2024 (anno civile)"
- oppure "1 gennaio 2019 - 30 aprile 2024"

### A4. Frequenza Aggiornamento Prevista (ℹ️ UTILE)

**Domanda**:

Con quale frequenza i dati SDI/SSD verranno aggiornati e pubblicati?

**Dettaglio richiesto**:

- [ ] Cadenza aggiornamenti (annuale, semestrale, trimestrale?)
- [ ] Prossimo aggiornamento previsto

**Formato risposta atteso**:

- "Aggiornamento annuale, prossimo: maggio 2026"

---

## SEZIONE B: Metadati Tecnici Sistema SDI

### B1. Versione Schema SDI/SSD (🔴 CRITICA)

**Domanda**:

Quale versione dello schema database SDI/SSD è stata utilizzata per l'estrazione?

**Dettaglio richiesto**:

- [ ] Versione schema SDI (es. "v2.3.1")
- [ ] Data rilascio versione schema
- [ ] Changelog modifiche schema 2019-2024

**Formato risposta atteso**:

- "Schema SDI v3.1.0 (rilascio: gennaio 2024)"
- Changelog allegato o URL documentazione

### B2. Scope FILE_6 e Copertura Relazione V-A (🔴 CRITICA)

**Domanda**:

Quante comunicazioni SDI totali violenza genere esistono e quante hanno "relazione vittima-autore" codificata?

**Dettaglio richiesto**:

- [ ] N° comunicazioni SDI violenza genere TOTALI per anno (2019-2024)
- [ ] N° comunicazioni con relazione V-A codificata per anno
- [ ] % copertura (relazione V-A / totale) per anno
- [ ] % copertura per categoria reato (art. 558 bis, 583 quinquies, 387 bis, 612 ter, ecc.)

**Formato risposta atteso**:

```
Anno | SDI Totali | Con Relazione V-A | % Copertura
2019 | 10.000     | 1.200             | 12%
2020 | 12.000     | 1.500             | 12.5%
...

Reato          | SDI Totali | Con Relazione V-A | % Copertura
Art. 558 bis   | 50         | 10                | 20%
Art. 583 quin. | 200        | 30                | 15%
...
```

### B3. Criteri Codifica Relazione V-A (🔴 CRITICA)

**Domanda**:

Quali sono i criteri di compilazione del campo "relazione vittima-autore" in SDI?

**Dettaglio richiesto**:

- [ ] Compilazione obbligatoria o facoltativa?
- [ ] Per quali categorie reato è obbligatoria?
- [ ] Chi compila (FdO? PM? Operatore SDI)?
- [ ] Procedura validazione valore

**Formato risposta atteso**:

- Descrizione testuale procedura compilazione
- Elenco reati con compilazione obbligatoria

### B4. Lag Temporale Registrazione (🔴 CRITICA)

**Domanda**:

È stato effettuato un bulk update retroattivo SDI tra 2023-2024? Se sì, quando e perché?

**Dettaglio richiesto**:

- [ ] Conferm bulk update retroattivo (Sì/No)
- [ ] Se Sì: date aggiornamenti massivi
- [ ] Motivazione lag medio 5 anni (fatto 2019 → denuncia 2024)
- [ ] Distinzione DATA_FATTO, DATA_DENUNCIA, DATA_REGISTRAZIONE_SDI

**Formato risposta atteso**:

- "Bulk update effettuato: novembre 2023 - aprile 2024"
- "Motivazione: consolidamento retroattivo denunce pregresse"
- "DATA_DENUNCIA = data protocollazione denuncia, DATA_REGISTRAZIONE_SDI = data inserimento sistema"

---

## SEZIONE C: Metadati Strutturali Dataset

### C1. Chiave Primaria FILE_6 (🔴 CRITICA)

**Domanda**:

Qual è la chiave primaria corretta per FILE_6 dato che PROT_SDI non è univoco?

**Dettaglio richiesto**:

- [ ] Nome campo chiave primaria
- [ ] Semantica righe duplicate PROT_SDI (1 episodio con N vittime? N reati?)
- [ ] Campo univoco episodio vs campo univoco vittima

**Formato risposta atteso**:

- "Chiave primaria: PROT_SDI + COD_VITTIMA"
- "PROT_SDI duplicato = stesso episodio, vittime multiple"

### C2. Semantica Campi Ambigui (🔴 CRITICA)

**Domanda**:

Qual è la differenza tra DES_OBIET e LUOGO_SPECIF_FATTO in FILE_6?

**Dettaglio richiesto**:

- [ ] Definizione DES_OBIET
- [ ] Definizione LUOGO_SPECIF_FATTO
- [ ] Quale usare per geolocalizzazione?
- [ ] Spiegazione prevalenza "NON PREVISTO/ALTRO" (62.5%) in DES_OBIET

**Formato risposta atteso**:

- "DES_OBIET = descrizione obiettivo reato (es. furto portafoglio)"
- "LUOGO_SPECIF_FATTO = tipologia luogo (es. abitazione, strada pubblica)"
- "Per geolocalizzazione usare: COMUNE + LUOGO_SPECIF_FATTO"

### C3. Codebook Valori Ammessi (🔴 CRITICA)

**Domanda**:

Quali sono i valori ammessi per i campi codificati di FILE_6?

**Dettaglio richiesto**:

- [ ] RELAZIONE_AUTORE_VITTIMA: elenco completo valori
- [ ] SESSO_DENUNCIATO/VITTIMA: valori ammessi (M/F/altro?)
- [ ] TENT_CONS: T/C/altro?
- [ ] LUOGO_SPECIF_FATTO: elenco completo

**Formato risposta atteso**:

```
RELAZIONE_AUTORE_VITTIMA:
- CONIUGE
- EX CONIUGE
- CONVIVENTE
- FIGLIO/A
- GENITORE
- ...
(elenco completo con definizioni)
```

### C4. Gestione Valori Anomali (🔴 CRITICA)

**Domanda**:

Come interpretare valori anomali nel campo età (es. -2, 1930)?

**Dettaglio richiesto**:

- [ ] Significato -2, -1, 0
- [ ] Significato 1930, 1900
- [ ] Procedura pulizia dati per export

**Formato risposta atteso**:

- "-2 = età non disponibile"
- "1930 = errore sistema (ignorare)"
- "Valori validi: 0-120"

### C5. Metodologia Aggregazione FILE_5 (⚠️ IMPORTANTE)

**Domanda**:

Come sono stati aggregati i dati granulari SDI a livello provinciale per FILE_5?

**Dettaglio richiesto**:

- [ ] Criteri aggregazione temporale (anno fatto? anno denuncia?)
- [ ] Gestione duplicati (stessa vittima più reati?)
- [ ] Conteggio: episodi o comunicazioni SDI?
- [ ] Formula calcolo "incidenza vittime genere femminile"

**Formato risposta atteso**:

- "Aggregazione per anno DATA_FATTO, provincia LUOGO_FATTO"
- "Conteggio episodi (PROT_SDI univoco)"
- "Incidenza = (vittime femmine / vittime totali) * 100"

### C6. Formato Normalizzato FILE_5 (⚠️ IMPORTANTE)

**Domanda**:

È possibile fornire FILE_5 in formato normalizzato (anni come righe)?

**Dettaglio richiesto**:

- [ ] Versione FILE_5 con struttura: PROVINCIA | REATO | ANNO | VALORE

**Formato risposta atteso**:

- File FILE_5_normalizzato.xlsx allegato
- oppure "Non disponibile"

---

## SEZIONE D: Codici Standardizzati

### D1. Codici ISTAT Geografici (🔴 CRITICA)

**Domanda**:

È possibile aggiungere codici ISTAT per province e comuni?

**Dettaglio richiesto**:

- [ ] Nuova versione FILE_5 con COD_ISTAT_PROVINCIA
- [ ] Nuova versione FILE_6 con COD_ISTAT_PROVINCIA, COD_ISTAT_COMUNE
- [ ] Standard ISTAT anno di riferimento (es. 2024)

**Formato risposta atteso**:

- File aggiornati con codici ISTAT
- "Standard ISTAT 2024 utilizzato"

### D2. Codici ISO Nazioni (🔴 CRITICA)

**Domanda**:

È possibile aggiungere codici ISO 3166 per le nazioni di nascita?

**Dettaglio richiesto**:

- [ ] Nuova versione FILE_6 con COD_ISO_NAZIONE_DENUNCIATO
- [ ] COD_ISO_NAZIONE_COLP_PROVV
- [ ] COD_ISO_NAZIONE_VITTIMA
- [ ] Standard: ISO 3166-1 alpha-2

**Formato risposta atteso**:

- File FILE_6 aggiornato con codici ISO
- "Standard ISO 3166-1 alpha-2"

---

## SEZIONE E: Riconciliazione con Fonti Esterne

### E1. Discrepanze vs ISTAT (🔴 CRITICA)

**Domanda**:

Come si spiegano le discrepanze tra FILE_6 e il report ISTAT "Un anno di Codice Rosso" (agosto 2019 - agosto 2020) considerato che entrambi utilizzano fonte SDI-SSD?

**Dettaglio richiesto**:

- [ ] Documentazione differenza scope dati: FILE_6 (solo relazione vittima-autore) vs report Polizia (tutti i casi)
- [ ] Spiegazione 87 casi FILE_6 vs 1.741 report Polizia (art. 387 bis, 2020)
- [ ] Riconciliazione metodologie tra fonti ufficiali:
  - File Excel: `MI-123-U-A-SD-2025-90_6.xlsx` (foglio "Sheet")
  - Report Polizia: `Polizia_Un_anno_di_codice_rosso_2020.pdf`

**Formato risposta atteso**:

- Spiegazione tecnica discrepanze
- Eventuale correzione FILE_6
- Riferimento contatto ISTAT per chiarimenti

### E2. Criteri Inclusione Reati (⚠️ IMPORTANTE)

**Domanda**:

Quali reati esattamente sono inclusi in "violenza di genere" per FILE_5 e FILE_6?

**Dettaglio richiesto**:

- [ ] Elenco completo articoli codice penale inclusi
- [ ] Criteri selezione "riconducibili violenza genere"
- [ ] Perché mancano "molestie fisiche/psicologiche" richieste in FOIA?

**Formato risposta atteso**:

- Elenco articoli CP con descrizioni
- "Criteri: reati contro la persona con vittima prevalentemente femminile"

---

## SEZIONE F: Fonti Dati e Sistemi

### F1. Fonte DCPC vs SDI/SSD (⚠️ IMPORTANTE)

**Domanda**:

Qual è la relazione tra fonte DCPC (foglio Omicidi) e SDI/SSD (altri fogli)?

**Dettaglio richiesto**:

- [ ] DCPC è sistema separato da SDI/SSD?
- [ ] Perché omicidi hanno fonte specifica?
- [ ] Sovrapposizioni/discrepanze tra DCPC e SDI?

**Formato risposta atteso**:

- Descrizione DCPC: "Direzione Centrale Polizia Criminale - database omicidi dedicato"
- "Omicidi presenti sia in DCPC che SDI, ma DCPC più completo per questa categoria"

### F2. Software Generazione Dataset (⚠️ IMPORTANTE)

**Domanda**:

Qual è il software/procedura utilizzata per generare FILE_5 e FILE_6?

**Dettaglio richiesto**:

- [ ] Software export (nome, versione)
- [ ] Query SQL o script utilizzati
- [ ] Pipeline estrazione dati documentata

**Formato risposta atteso**:

- "Software: Apache POI v5.2.3 + script Python interno"
- Query SQL allegata (opzionale)

---

## SEZIONE G: Licenza e Pubblicazione

### G1. Licenza Riutilizzo (🔴 CRITICA)

**Domanda**:

Quale licenza si applica ai dati forniti per il riutilizzo?

**Dettaglio richiesto**:

- [ ] Licenza esplicita (CC0, CC-BY 4.0, IODL 2.0, altra)
- [ ] Condizioni riutilizzo (attribuzione richiesta?)
- [ ] Eventuali limitazioni uso

**Formato risposta atteso**:

- "Licenza: CC-BY 4.0 (attribuzione: Ministero dell'Interno - SDI/SSD)"
- oppure "Licenza IODL 2.0"

### G2. Pubblicazione Online (🔴 CRITICA)

**Domanda**:

I dati verranno pubblicati online come richiesto nella FOIA originale (art. 3, comma 1 D.Lgs. 33/2013)?

**Dettaglio richiesto**:

- [ ] Pubblicazione prevista (Sì/No)
- [ ] Se Sì: URL pubblicazione
- [ ] Se Sì: Data pubblicazione
- [ ] Se No: Motivazione (delibera Garante? sicurezza? altro?)

**Formato risposta atteso**:

- "Sì, pubblicazione prevista: dati.interno.gov.it/dataset/violenza-genere-2019-2024"
- "Data pubblicazione: giugno 2025"
- oppure "No, delibera Garante 515/2018 impedisce pubblicazione granulare"

---

## SEZIONE H: Metadati Descrittivi

### H1. Titolo e Descrizione Dataset (⚠️ IMPORTANTE)

**Domanda**:

Qual è il titolo e la descrizione ufficiale dei dataset FILE_5 e FILE_6?

**Dettaglio richiesto**:

- [ ] Titolo FILE_5
- [ ] Descrizione FILE_5 (max 500 caratteri)
- [ ] Titolo FILE_6
- [ ] Descrizione FILE_6 (max 500 caratteri)
- [ ] Keywords (almeno 5)

**Formato risposta atteso**:

```
FILE_5:
Titolo: "Reati violenza di genere Italia 2019-2024 - Aggregati provinciali"
Descrizione: "Dati aggregati a livello provinciale su reati riconducibili a violenza di genere..."
Keywords: violenza genere, reati spia, codice rosso, omicidi donne, SDI
```

### H2. Autore e Contatto (⚠️ IMPORTANTE)

**Domanda**:

Qual è l'ufficio responsabile della produzione dei dataset e il contatto tecnico per chiarimenti?

**Dettaglio richiesto**:

- [ ] Ufficio Ministero responsabile
- [ ] Referente tecnico (ruolo, no nome personale)
- [ ] Email contatto tecnico
- [ ] Numero telefono (opzionale)

**Formato risposta atteso**:

```
Ufficio: Direzione Centrale Polizia Criminale - Servizio Analisi Criminale
Referente: Ufficio Statistiche Reati
Email: statistiche.dcpc@interno.it
```

### H3. Riferimento Delibera Garante (⚠️ IMPORTANTE)

**Domanda**:

Qual è il contenuto dell'articolo 5 della delibera Garante 515/2018 citato per negare dati comunali FILE_5?

**Dettaglio richiesto**:

- [ ] Testo integrale art. 5 delibera 515/2018
- [ ] Motivazione applicabilità caso specifico
- [ ] Perché FILE_6 comunale è possibile e FILE_5 no?

**Formato risposta atteso**:

- Testo art. 5 citato
- "FILE_6 possibile perché dati granulari non aggregati rientrano in deroga art. 5.2"

### H4. Changelog Versioni (⚠️ IMPORTANTE)

**Domanda**:

Esiste un changelog delle modifiche apportate ai dataset tra creazione (28 apr - 6 mag) e invio (9 mag)?

**Dettaglio richiesto**:

- [ ] Versione dataset corrente (es. v1.0)
- [ ] Data versione
- [ ] Modifiche apportate rispetto a prima versione

**Formato risposta atteso**:

```
FILE_5 v1.0 (9 maggio 2025):
- Creazione iniziale: 28 aprile 2025
- Correzione encoding province: 2 maggio 2025
- Aggiunta foglio Omicidi DCPC: 9 maggio 2025
```

---

## SEZIONE I: Riepilogo Richiesta

### Totale Domande: 27

**Priorità**:

- 🔴 CRITICHE: 15 domande
- ⚠️ IMPORTANTI: 11 domande
- ℹ️ UTILI: 1 domanda

### Deliverable Attesi

**File da richiedere**:

1. FILE_5 con codici ISTAT province
2. FILE_6 con codici ISTAT province/comuni + ISO nazioni
3. FILE_5 normalizzato (opzionale)
4. Codebook valori ammessi (PDF/Excel)
5. Changelog schema SDI 2019-2024
6. Testo integrale delibera Garante 515/2018 art. 5

**Documenti da richiedere**:

1. Documento metadati strutturato (es. DCAT-AP_IT)
2. Metodologia aggregazione FILE_5
3. Spiegazione discrepanze vs ISTAT
4. Procedura compilazione relazione V-A

---

## Modalità Invio Richiesta

**Canali**:

1. **Email**: giulia.sudano@thinktankperiod.org (richiedente originale)
2. **PEC**: thinktankperiod@pec.it oppure dipps001.0120@pecps.interno.it

**Formato lettera**:

- Riferimento protocollo: MI-123-U-A-SD-2025-90
- Allegati: questa checklist + evidenze tecniche (analisi Rossella, confronto ISTAT)
- Tone: Costruttivo, non accusatorio
- Focus: Miglioramento qualità dati per ricerca/trasparenza

**Tempistiche**:

- Invio richiesta: entro 15 giorni da completamento Fase 4
- Risposta attesa: 30 giorni (termini FOIA)

---

## Note Utilizzo

**Per compilazione**:

- [ ] = Domanda da porre
- [x] = Risposta ricevuta
- [n/a] = Non applicabile

**Tracking risposte**:

- Creare file `risposte_ministero.md` in fase-4-comunicazione/
- Annotare data risposta, contenuto, file allegati
