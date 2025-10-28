# Bozza: Lettera al Ministero dell'Interno – Data Quality Issues

**Destinatari**:
- Dipartimento della Pubblica Sicurezza, Ministero dell'Interno
- CC: Servizio Analisi Criminale
- CC: datiBeneComune, Period Think Tank

**Oggetto**: Richiesta chiarimenti e integrazione metadati – FOIA MI-123-U-A-SD-2025-90 (dati violenza genere 2019-2024)

---

## BOZZA LETTERA

Spett.le Dipartimento della Pubblica Sicurezza,

in riferimento alla risposta fornita il [data] alla richiesta di accesso civico generalizzato presentata dall'Avv. Giulia Sudano in data 18 aprile 2025, riguardante i dati sui reati di violenza di genere (MI-123-U-A-SD-2025-90), desideriamo sottoporre alcune osservazioni e richieste per migliorare l'utilità pubblica del dataset.

### Apprezzamento

Innanzitutto, desideriamo esprimere **apprezzamento per la trasparenza** dimostrata nel mettere a disposizione dati così rilevanti su un tema di importanza strategica per il Paese. La disponibilità di informazioni strutturate su violenza di genere rappresenta un contributo prezioso per ricerca, policy-making e consapevolezza pubblica.

### Osservazioni tecniche

Nel corso di un'analisi di validazione del dataset, abbiamo rilevato alcune **incongruenze rispetto al report ufficiale ISTAT "Violenza contro le donne – Un anno di Codice Rosso" (ottobre 2020)**, che rappresenta il benchmark pubblico disponibile per il periodo agosto 2019 – agosto 2020.

#### 1. Undercount significativo per fattispecie Codice Rosso

Il confronto tra i dati FOIA e il report ISTAT rivela **discrepanze critiche**:

| Reato | ISTAT (ago 2019–ago 2020) | FOIA ricevuto | Delta |
|-------|---------|---|---|
| Art. 558 bis (costrizione matrimonio) | 11 | 0-1 | **-90%** |
| Art. 583 quinquies (deformazione viso) | 56 | 1 | **-98%** |
| Art. 612 ter (revenge porn) | 718 | ~1.230 | -43% |

Questa discrepanza solleva dubbi sulla **completezza del dataset** per il periodo di riferimento e può indurre utenti in errore, che potrebbero pensare che tali reati fossero effettivamente poco diffusi nel 2019-2020.

**Domanda**: Potete fornire una riconciliazione di questi dati con il report ISTAT, spiegando se:
- Si tratta di snapshot parziale del sistema SDI?
- Ci sono stati aggiornamenti retroattivi dopo la pubblicazione del report ISTAT?
- Esiste una causa tecnica (es. ritardo nell'implementazione della codifica art. 387 bis)?

---

#### 2. Mancanza di metadati essenziali

I file Excel forniti mancano di informazioni critiche per la corretta interpretazione:

- **Data estrazione SDI**: non è specificato quando i dati sono stati estrapolati dal sistema
- **Data consolidamento**: non è chiaro quando i dati divengono "ufficiali" e stabili
- **Significato di "non consolidato" (2024)**: quali righe sono soggette a variazione? Con quale frequenza verranno aggiornate?
- **Granularità temporale**: sono disponibili date specifiche di inizio fatto e denuncia, oltre all'anno?
- **Mapping codici reato**: la corrispondenza tra testo descrittivo (es. "COSTRIZIONE O INDUZIONE AL MATRIMONIO") e articoli c.p. (es. art. 558 bis) non è sempre esplicita
- **Lineage dati**: quale sistema di origine per ogni colonna? Come sono stati trasformati?

Questa assenza di metadati **limita significativamente il riuso** dei dati per scopi scientifici, organizzazioni della società civile e amministrazioni pubbliche.

---

#### 3. Mismatch di aggregazione temporale

I dati FOIA sono aggregati per **anno civile**, mentre il report ISTAT Codice Rosso utilizza **anno fiscale** (9 agosto 2019 – 8 agosto 2020). Questo rende **impossibile una validazione diretta**.

**Richiesta**: Fornire (o indicare dove reperire) dati per il periodo agosto 2019 – agosto 2020 in forma disaggregata, così da permettere riconciliazione precisa.

---

#### 4. Problematiche strutturali minori

- **Descrizioni reati in full-text**: impone parsing complesso e errore-prone. Sarebbe utile una colonna aggiuntiva con codice articolo standardizzato.
- **NULL geografici**: circa 0.5-0.7% delle righe ha valori NULL in campi provincia. Per quale motivo?
- **Nomi colonne ridondanti**: colonne come "provinciauts_corretto", "codice_provincia_storico", "codice_provinciauts" creano confusione sulla mappatura ISTAT corretta da utilizzare.

---

### Richieste specifiche

Vorremmo sottoporre le seguenti richieste, che ritengo possano **aumentare significativamente il valore pubblico** del dataset:

#### A) Riconciliazione dati storici

Fornire, per le fattispecie introdotte da Codice Rosso (art. 558 bis, 583 quinquies, 612 ter, 387 bis), una tabella riconciliata con il report ISTAT relativa al periodo agosto 2019 – agosto 2020, spiegando eventuali discrepanze.

#### B) Documento metadati

Allegare a ogni distribuzione futura un documento (formato: Excel o Markdown) con:
- Data estrazione SDI per ogni anno (2019-2024)
- Data consolidamento e previsione prossimi aggiornamenti
- Significato di "non consolidato" per 2024 (roadmap stabilizzazione?)
- Spiegazione NULL geografici
- Mapping colonne → sistema di origine SDI/SSD/DCPC
- Changelog versioni schema SDI (ci sono stati aggiornamenti rilevanti?)

#### C) Granularità temporale (se disponibile)

Se il sistema SDI lo consente, integrare nei file (o fornire come separato dataset):
- `data_inizio_fatto`: data in cui è avvenuto il reato
- `data_denuncia`: data della denuncia
- `data_registrazione_sdi`: data di registrazione in SDI

Questo permetterebbe di **spiegare i lag temporali** tra fatto e registrazione, cruciale per interpretare correttamente i dati.

#### D) Standardizzazione codici reato

Aggiungere colonna con codice articolo c.p. (es. "558 bis", "387 bis") accanto alle descrizioni full-text, per facilitare parsing e riconciliazione automatica con altre fonti normative.

#### E) Chiarimento roadmap 2024

Indicare **quando i dati 2024 saranno consolidati** e se sono preveduti aggiornamenti retroattivi su anni precedenti (2019-2023).

---

### Allegati

Allego i seguenti documenti tecnici a supporto delle osservazioni:

1. **findings_rossella_validazione.md**: analisi dettagliata delle discrepanze FOIA vs ISTAT
2. **analisi_temporale_codice_rosso.csv**: distribuzione temporale fattispecie 2019-2024
3. **template_metadati.csv**: proposta di schema metadati

---

### Proposte costruttive

Comprendiamo che l'Open Data pubblico è un processo di evoluzione continua. Nel futuro, suggeriamo di:

- **Fornire sempre metadati** insieme ai dati (come best practice internazionale FAIR data)
- **Esplicitare periodicità di aggiornamento** e definire SLA per consolidamento
- **Pubblicare changelog** delle versioni SDI per trasparenza su evoluzioni schema
- **Fornire contatto tecnico** di supporto per chiarimenti su dati

---

### Prossimi passi

Rimaniamo **disponibili per dialogo costruttivo** e per supportare il Dipartimento nella documentazione dei dati, se utile. Riteniamo che una **riconciliazione trasparente** con il report ISTAT e una migliore documentazione beneficerebbe l'intera comunità di utenti (ricercatori, NGO, pubblica amministrazione).

Agradiremo risposta entro **30 giorni** da questa comunicazione.

Cordiali saluti,

---

**Firmatari suggeriti**:
- [Nome], [Affiliation]
- In nome di **Period Think Tank** / **datiBeneComune**

**Contatto**: [email]

**Data**: [data]

---

## NOTE PER ADATTAMENTO

### Versione formale (PEC)
- Aggiungere: numero di protocollo
- Formato: PDF firmato

### Versione mail esplorativa
- Tono più colloquiale
- Più breve (riassuntivo)
- Allegati come link a repository GitHub anziché file pesanti

### Per risposta positiva
- Preparare feedback loop (invio dati integrati → validazione nostra)

### Per risposta negativa/mancata
- Follow-up a 45 giorni
- Escalation (datiBeneComune, FOIA transparency advocacy?)
