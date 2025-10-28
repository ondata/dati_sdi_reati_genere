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

Nel corso di un'analisi di validazione dei due file Excel forniti (MI-123-U-A-SD-2025-90_5.xlsx e MI-123-U-A-SD-2025-90_6.xlsx), abbiamo rilevato alcune **incongruenze rispetto al report ufficiale ISTAT "Violenza contro le donne – Un anno di Codice Rosso" (ottobre 2020)**, che rappresenta il benchmark pubblico disponibile per il periodo agosto 2019 – agosto 2020.

### Undercount significativo per fattispecie Codice Rosso

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

### Mancanza di metadati essenziali

I file Excel forniti mancano di informazioni critiche per la corretta interpretazione:

- **Data estrazione SDI**: non è specificato quando i dati sono stati estrapolati dal sistema SDI/SSD/DCPC per ogni anno (2019-2024)
- **Data consolidamento**: non è chiaro quando i dati divengono "ufficiali" e stabili
- **Significato "non consolidato" (2024)**: nella lettera di risposta FOIA si specifica che dati 2024 non sono consolidati. Quali righe sono soggette a variazione? Con quale frequenza verranno aggiornati?
- **Granularità temporale in file_6**: il file con relazioni vittima-autore (file_6.xlsx) fornisce `DATA_INIZIO_FATTO`, `DATA_FINE_FATTO`, `DATA_DENUNCIA` (granularità giornaliera), ma il file con dati aggregati (file_5.xlsx) fornisce solo `anno`. Come sono stati trasformati i dati granulari in aggregati?
- **Mapping codici reato**: la corrispondenza tra descrizioni full-text (es. "COSTRIZIONE O INDUZIONE AL MATRIMONIO") e articoli c.p. (es. art. 558 bis) non è esplicita in nessun foglio
- **Lineage dati**: quale sistema di origine (SDI vs SSD vs DCPC) per ogni colonna? Come sono stati trasformati i dati?

Questa assenza di metadati **limita significativamente il riuso** dei dati per scopi scientifici, organizzazioni della società civile e amministrazioni pubbliche.

---

### Mismatch di aggregazione temporale

I dati FOIA sono aggregati per **anno civile**, mentre il report ISTAT Codice Rosso utilizza **anno fiscale** (9 agosto 2019 – 8 agosto 2020). Questo rende **impossibile una validazione diretta**.

**Richiesta**: Fornire (o indicare dove reperire) dati per il periodo agosto 2019 – agosto 2020 in forma disaggregata, così da permettere riconciliazione precisa.

---

### Formato dati pivottato nel file_5

Il file con dati aggregati per provincia (MI-123-U-A-SD-2025-90_5.xlsx) è fornito in **formato pivottato**:

```
Provincia  | Delitto              | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
-----------|----------------------|------|------|------|------|------|------
AGRIGENTO  | 5. TENTATI OMICIDI   | 14   | 10   | 11   | 8    | 13   | 13
AGRIGENTO  | 8. LESIONI DOLOSE    | 502  | 473  | 462  | 484  | 520  | 504
```

**Problema**:
- Anni come intestazioni di colonna (non come data/dimensione)
- Rende difficile analisi temporale cross-anno
- Rende difficile estensione futura (nuovo anno = nuova colonna nel file)
- Standard internazionali (FAIR data) raccomandano formato "tidy" (una riga per anno)

**Formato tidy consigliato**:
```
Provincia  | Delitto              | Anno | Valore
-----------|----------------------|------|-------
AGRIGENTO  | 5. TENTATI OMICIDI   | 2019 | 14
AGRIGENTO  | 5. TENTATI OMICIDI   | 2020 | 10
AGRIGENTO  | 5. TENTATI OMICIDI   | 2021 | 11
```

Questo permetterebbe query standard come: "SELECT * WHERE Anno = 2024 AND Provincia = 'ROMA'" senza dipendere dalla struttura del file.

---

### Problematiche strutturali nel file con relazioni vittima-autore

Nel file con disaggregazione comunale e relazioni vittima-autore (MI-123-U-A-SD-2025-90_6.xlsx), abbiamo rilevato:

- **Descrizioni reati in full-text** (colonna DES_REA_EVE): "COSTRIZIONE O INDUZIONE AL MATRIMONIO", "DEFORMAZIONE DELL'ASPETTO...", etc. Impone parsing complesso. Sarebbe utile una colonna aggiuntiva con codice articolo c.p. standardizzato (es. "558 bis").
- **Codici geografici mancanti**: il file fornisce `REGIONE`, `PROVINCIA`, `COMUNE` (nomi in testo), ma senza corrispondenti codici ISTAT. Necessario per riconciliazione con database ISTAT ufficiali.
- **Chiave primaria ambigua** (segnalato dalla community): il campo `PROT_SDI` non è univoco – righe duplicate dello stesso protocollo. Come contare episodi unici vs righe duplicate?
- **Semantica campi geografici ambigua** (segnalato dalla community): significato di `DES_OBIET` non documentato (contiene "PRIVATO CITTADINO", "COMMERCIANTE", "NON PREVISTO/ALTRO" con 62.5% dei record). Differenza con `LUOGO_SPECIF_FATTO` ("ABITAZIONE", "PUBBLICA VIA", etc.) non chiara.

---

### Richieste specifiche

Vorremmo sottoporre le seguenti richieste, che ritengo possano **aumentare significativamente il valore pubblico** del dataset:

### Riconciliazione dati storici

Fornire, per le fattispecie introdotte da Codice Rosso (art. 558 bis, 583 quinquies, 612 ter, 387 bis), una tabella riconciliata con il report ISTAT relativa al periodo agosto 2019 – agosto 2020, spiegando eventuali discrepanze.

### Documento metadati strutturato

Allegare a ogni distribuzione futura un documento (formato: Excel o Markdown) con:
- Data estrazione SDI per ogni anno (2019-2024)
- Data consolidamento e previsione prossimi aggiornamenti
- Significato di "non consolidato" per 2024 (roadmap stabilizzazione?)
- Spiegazione NULL geografici
- Mapping colonne → sistema di origine SDI/SSD/DCPC
- Changelog versioni schema SDI (ci sono stati aggiornamenti rilevanti?)

### Granularità temporale (se disponibile in SDI)

Se il sistema SDI lo consente, integrare nei file (o fornire come separato dataset):
- `data_inizio_fatto`: data in cui è avvenuto il reato
- `data_denuncia`: data della denuncia
- `data_registrazione_sdi`: data di registrazione in SDI

Questo permetterebbe di **spiegare i lag temporali** tra fatto e registrazione, cruciale per interpretare correttamente i dati.

### Standardizzazione codici reato

Aggiungere colonna con codice articolo c.p. (es. "558 bis", "387 bis") accanto alle descrizioni full-text, per facilitare parsing e riconciliazione automatica con altre fonti normative.

### Chiarimento chiave primaria file_6

**Critico**: Nel file con relazioni vittima-autore (file_6), il campo `PROT_SDI` presenta righe duplicate. Necessario chiarire:
- Quale campo o combinazione di campi forma la **chiave primaria**?
- Righe duplicate di PROT_SDI rappresentano: vittime multiple? Reati multipli dello stesso episodio? Errore di registrazione?
- Come contare correttamente gli **episodi unici** (non righe duplicate)?

Esempio problematico: PROT_SDI "BOPC042024000134" è ripetuto 5 volte nel file. È un episodio con 5 vittime oppure un errore?

**Impatto**: Conteggio riga ≠ conteggio episodi. Analisi quantitative potrebbero essere sovrastimate. Questa ambiguità è stata segnalata anche dalla community GitHub.

### Significato campi geografici/contesto file_6

Nel file_6, non è chiaro il significato e l'uso di:
- `LUOGO_SPECIF_FATTO`: "ABITAZIONE", "PUBBLICA VIA", etc.
- `DES_OBIET`: "PRIVATO CITTADINO", "COMMERCIANTE", etc. (62.5% dei record ha "NON PREVISTO/ALTRO")

Domande:
- Qual è la differenza tra questi due campi?
- Quale usare per geolocalizzare l'episodio?
- Perché così alta percentuale di "NON PREVISTO"?
- Sono campi legacy mantenuti per compatibilità?

### Roadmap consolidamento dati 2024

Indicare **quando i dati 2024 saranno consolidati** e se sono preveduti aggiornamenti retroattivi su anni precedenti (2019-2023).

### Fornire file anche in formato tidy per file_5

Per il file con dati aggregati per provincia (file_5), fornire una versione in formato "tidy":
- Una riga per combinazione provincia-delitto-anno
- Colonne: Provincia, Delitto, Anno, Valore
- Questo standard facilita query, estensione futura e interoperabilità

Il formato pivottato attuale può essere mantenuto per leggibilità, ma il formato tidy sarebbe preferibile per analisi automatizzate e rispetto degli standard FAIR data.

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

Attualmente i file Excel forniti sono il punto di partenza per ulteriori analisi. Una risposta chiara su questi punti permetterebbe di:
- Validare l'affidabilità dei dati
- Riconciliarli con benchmark ufficiali ISTAT
- Enableare ricercatori a utilizzare i dati con consapevolezza dei loro limiti

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
