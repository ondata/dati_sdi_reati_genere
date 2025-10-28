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

Nel corso di un'analisi di validazione dei due file Excel forniti (MI-123-U-A-SD-2025-90_5.xlsx e MI-123-U-A-SD-2025-90_6.xlsx), abbiamo rilevato alcune **questioni critiche sulla struttura, completezza e documentazione dei dati**, in particolare sul file_6 che contiene le comunicazioni SDI con relazioni vittima-autore.

### Struttura e scope del file_6: sottinsieme filtrato con scope non completamente documentato

Una prima considerazione tecnica è importante per la corretta interpretazione dei dati forniti:

**Il file_6 (comunicazioni SDI con relazioni vittima-autore) è un sottinsieme filtrato dei dati SDI**, contenente solo le comunicazioni dove sia stata codificata una "relazione vittima-autore" (partner, coniuge, parente, ecc.). Tuttavia, **il perimetro esatto di questo sottinsieme non è completamente documentato** e pone questioni critiche sulla completezza dei dati.

In particolare, la **definizione di quali reati includere in FILE_6 non è chiara**, soprattutto per articoli che legalmente NON richiedono una relazione vittima-autore:

- **Art. 558 bis (Costrizione al matrimonio)**: per legge può essere commesso da chiunque (padre, fratello, estraneo). Nel file_6 NON compaiono casi nel periodo agosto 2019–agosto 2020, ma compaiono 8 casi nel 2024 (tutti con "ALTRO PARENTE"). **Domanda**: dove sono i casi 2019-2020? Erano registrati nel sistema SDI ma esclusi da FILE_6? O non erano mai stati registrati?

- **Art. 583 quinquies (Deformazione del viso)**: per legge può essere commesso da chiunque (partner, collega, estraneo). Nel file_6 NON compaiono casi nel 2019-2020, ma compaiono 5 casi nel 2024 (tutti con "FIDANZATO"). **Domanda**: se nel 2024 compaiono solo quelli con fidanzato, dov'è la casistica con altri autori? Sono inclusi in FILE_6 o esclusi per scelta?

- **Art. 387 bis (Violazione allontanamento)**: questo sì richiede relazione V-A per definizione (violazione di provvedimento da violenza domestica). Nel file_6 compaiono 68 casi nel 2023-2024, contro 1.741 nel report ISTAT (periodo agosto 2019–agosto 2020). La differenza temporale è significativa.

**Conseguenza**: le differenze quantitative rispetto a fonti esterne (es. ISTAT) potrebbero riflettere **sia il filtro applicato che una mancanza effettiva di dati** nel periodo 2019-2022. Non è possibile distinguere senza chiarimenti dal Ministero.

### Sproporzione temporale nei dati: concentrazione anomala 2023-2024

Ulteriore elemento critico emerge dall'analisi della distribuzione temporale nei dati file_6 (comunicazioni SDI con relazioni vittima-autore):

| Anno | Denunce registrate |
|------|---|
| 2019 | 4 |
| 2020 | 5 |
| 2021 | 3 |
| 2022 | 13 |
| 2023 | 530 |
| 2024 | 4.277 |

**Interpretazione**: 
- 2019-2022: media 6,25 denunce/anno
- 2023: +8.480% (salto a 530)
- 2024: +707% ulteriore (salto a 4.277)

Sebbene parte della crescita sia spiegabile da **maggiore emersione del fenomeno negli ultimi anni** (combinazione di: aumentata sensibilizzazione, introduzione nuove fattispecie dal Codice Rosso nel 2019, migliore codifica della relazione V-A nel sistema), il pattern estremo della distribuzione pone questioni legittime sulla **completezza della codifica retrospettiva della relazione vittima-autore nel sistema SDI**.

In particolare:
- Nel periodo 2019-2022, file_6 contiene solo 26 comunicazioni complessivamente (media 6,5/anno)
- Nel 2023: salto a 530 (+20x)
- Nel 2024: ulteriore salto a 4.277 (+8x)

**Possibili spiegazioni**:
1. ✅ Aumento reale dei reati e della sensibilizzazione (plausibile)
2. ⚠️ Miglioramento significativo nella codifica della relazione V-A nel sistema SDI tra 2023-2024 (da verificare)
3. ❓ Retroimplementazione o sincronizzazione dati 2019-2022 effettuata tra 2023-2024 (richiede chiarimento)

**Domanda al Ministero**: È possibile distinguere quante comunicazioni nel file_6 per il periodo 2019-2022 siano **retroattivamente codificate** (cioè: fatto accaduto in 2019-2020, ma codificata la relazione V-A solo in 2023-2024)? Questo chiarimento permetterebbe di valutare se il pattern temporale riflette cambamenti reali nel fenomeno oppure evoluzioni nella completezza della codifica nel sistema SDI.

### Definizione e scope non documentati del file_6: quali criteri di inclusione/esclusione?

Emerge dall'analisi una questione ancora più fondamentale: **i criteri di inclusione e esclusione dei reati in FILE_6 non sono esplicitamente documentati**, creando ambiguità sulla rappresentatività dei dati.

In particolare:

**Domande critiche sulla definizione di scope**:

1. **Quali reati sono inclusi in FILE_6?**
   - Tutti gli articoli c.p. commessi da chi ha relazione V-A codificata (PARTNER, CONIUGE, PARENTE, ecc.)?
   - Oppure solo gli articoli che **per legge richiedono** una relazione V-A (es. art. 387 bis)?
   - Nel primo caso, dovrebbero esserci art. 558 bis e 583 quinquies anche nel 2019-2022 (ma non ci sono)
   - Nel secondo caso, la selezione è legale ma non documentata

2. **Perché art. 558 bis (costrizione al matrimonio) e 583 quinquies (deformazione viso) compaiono SOLO nel 2024?**
   - Questi articoli NON richiedono legalmente una relazione V-A predefinita
   - Nel 2024 compaiono entrambi, ma solo con relazione V-A codificata (ALTRO PARENTE, FIDANZATO)
   - **Ipotesi**: il Ministero ha cambiato nel 2023-2024 i criteri di classificazione, includendo questi articoli in FILE_6 solo quando c'è relazione V-A (scelta classificatoria)
   - **Conseguenza**: i casi 2019-2020 di questi articoli (incluso quelli senza relazione V-A) restano "invisibili" in FILE_6

3. **Quale è la completezza attesa della codifica della relazione V-A?**
   - Non tutti i reati di genere nel sistema SDI hanno relazione V-A codificata
   - È normale? È un problema di qualità? È una scelta di design?

**Impatto**: Senza chiarezza su questi criteri, è impossibile valutare se FILE_6 rappresenta:
- Un sottinsieme deliberato e coerente con una definizione di "violenza di genere con relazione V-A" (lecito, ma va documentato)
- Una mancanza reale di dati per il periodo 2019-2022 (problema di data quality)
- Una combinazione dei due (cambio criteri tra periodi)

---

### Mancanza di metadati essenziali

I file Excel forniti mancano di informazioni critiche per la corretta interpretazione:

- **Data estrazione SDI**: non è specificato quando i dati sono stati estrapolati dal sistema SDI/SSD/DCPC per ogni anno (2019-2024)
- **Data consolidamento**: non è chiaro quando i dati divengono "ufficiali" e stabili
- **Significato "non consolidato" (2024)**: nella lettera di risposta FOIA si specifica che dati 2024 non sono consolidati. Quali righe sono soggette a variazione? Con quale frequenza verranno aggiornati?
- **Granularità temporale in file_6**: il file con relazioni vittima-autore (file_6.xlsx) fornisce `DATA_INIZIO_FATTO`, `DATA_FINE_FATTO`, `DATA_DENUNCIA` (granularità giornaliera), ma il file con dati aggregati (file_5.xlsx) fornisce solo `anno`. Come sono stati trasformati i dati granulari in aggregati?
- **Corrispondenza codici reato**: la corrispondenza tra descrizioni testuali complete (es. "COSTRIZIONE O INDUZIONE AL MATRIMONIO") e articoli c.p. (es. art. 558 bis) non è esplicita in nessun foglio
- **Tracciabilità dati**: quale sistema di origine (SDI vs SSD vs DCPC) per ogni colonna? Come sono stati trasformati i dati?

Questa assenza di metadati **limita significativamente il riuso** dei dati per scopi scientifici, organizzazioni della società civile e amministrazioni pubbliche.

---

### Mismatch di aggregazione temporale

I dati FOIA sono aggregati per **anno civile**, mentre il report ISTAT Codice Rosso utilizza **anno fiscale** (9 agosto 2019 – 8 agosto 2020). Questo rende **impossibile una validazione diretta**.

**Richiesta**: Fornire (o indicare dove reperire) dati per il periodo agosto 2019 – agosto 2020 in forma disaggregata, così da permettere riconciliazione precisa.

---

### Formato dati con anni come colonne nel file_5

Il file con dati aggregati per provincia (MI-123-U-A-SD-2025-90_5.xlsx) è fornito con **anni come intestazioni di colonna**:

```
Provincia  | Delitto              | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
-----------|----------------------|------|------|------|------|------|------
AGRIGENTO  | 5. TENTATI OMICIDI   | 14   | 10   | 11   | 8    | 13   | 13
AGRIGENTO  | 8. LESIONI DOLOSE    | 502  | 473  | 462  | 484  | 520  | 504
```

**Problema**:
- Rende difficile analisi nel tempo (occorre leggere da sinistra a destra)
- Rende difficile estensione futura (nuovo anno = nuova colonna nel file)
- Standard internazionali raccomandano formato normalizzato (una riga per anno)

**Formato consigliato (normalizzato)**:
```
Provincia  | Delitto              | Anno | Valore
-----------|----------------------|------|-------
AGRIGENTO  | 5. TENTATI OMICIDI   | 2019 | 14
AGRIGENTO  | 5. TENTATI OMICIDI   | 2020 | 10
AGRIGENTO  | 5. TENTATI OMICIDI   | 2021 | 11
```

Questo permetterebbe ricerche standard senza dipendere dalla struttura del file.

---

### Problematiche strutturali nel file con relazioni vittima-autore

Nel file con disaggregazione comunale e relazioni vittima-autore (MI-123-U-A-SD-2025-90_6.xlsx), abbiamo rilevato:

- **Descrizioni reati in forma estesa** (colonna DES_REA_EVE): "COSTRIZIONE O INDUZIONE AL MATRIMONIO", "DEFORMAZIONE DELL'ASPETTO...", etc. Rende difficile l'analisi automatizzata. Sarebbe utile una colonna aggiuntiva con codice articolo c.p. standardizzato (es. "558 bis").
- **Codici geografici mancanti**: il file fornisce `REGIONE`, `PROVINCIA`, `COMUNE` (nomi in testo), ma senza corrispondenti codici ISTAT. Necessario per riconciliazione con database ISTAT ufficiali.
- **Chiave primaria ambigua** (segnalato dalla community): il campo `PROT_SDI` non è univoco – righe duplicate dello stesso protocollo. Come contare episodi unici vs righe duplicate?
- **Semantica campi geografici ambigua** (segnalato dalla community): significato di `DES_OBIET` non documentato (contiene "PRIVATO CITTADINO", "COMMERCIANTE", "NON PREVISTO/ALTRO" con 62.5% dei record). Differenza con `LUOGO_SPECIF_FATTO` ("ABITAZIONE", "PUBBLICA VIA", etc.) non chiara.

---

### Richieste specifiche

Vorremmo sottoporre le seguenti richieste, che ritengo possano **aumentare significativamente il valore pubblico** del dataset:

### Completezza della codifica della relazione vittima-autore

Fornire documentazione sulla **completezza attesa della codifica della relazione V-A** nel sistema SDI per il periodo 2019-2024. In particolare:
- Quale percentuale di comunicazioni SDI dovrebbe idealmente avere una relazione V-A codificata?
- Ci sono stati aggiornamenti nei criteri di codifica tra 2019 e 2024?
- È possibile identificare comunicazioni retroattivamente codificate?

Questo chiarimento permetterebbe di valutare se il pattern temporale nei dati (concentrazione 2023-2024) riflette un miglioramento nella completezza della codifica oppure variazioni reali nel fenomeno.

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

Aggiungere colonna con codice articolo c.p. (es. "558 bis", "387 bis") accanto alle descrizioni testuali, per facilitare l'analisi automatizzata e la riconciliazione con altre fonti normative.

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

### Fornire file anche in formato normalizzato per file_5

Per il file con dati aggregati per provincia (file_5), fornire una versione in formato normalizzato:
- Una riga per combinazione provincia-delitto-anno
- Colonne: Provincia, Delitto, Anno, Valore
- Questo formato facilita ricerche, estensione futura e interoperabilità

Il formato attuale con anni come colonne può essere mantenuto per leggibilità umana, ma il formato normalizzato sarebbe preferibile per analisi automatizzate e rispetto degli standard internazionali.

---

### Allegati

I seguenti documenti tecnici supportano le osservazioni contenute in questa comunicazione:

1. **analisi_struttura_file_6.md** (da allegare): analisi dettagliata della struttura e del scope del file_6
2. **analisi_temporale_codice_rosso.csv** (da allegare): distribuzione temporale delle comunicazioni SDI 2019-2024
3. **template_metadati.md** (da allegare): proposta di schema metadati per future distribuzioni

---

### Proposte costruttive

Comprendiamo che l'Open Data pubblico è un processo di evoluzione continua. Nel futuro, suggeriamo di:

- **Fornire sempre metadati** insieme ai dati (come best practice internazionale FAIR data)
- **Esplicitare periodicità di aggiornamento** e definire SLA per consolidamento
- **Pubblicare changelog** delle versioni SDI per trasparenza su evoluzioni schema
- **Fornire contatto tecnico** di supporto per chiarimenti su dati

---

### Prossimi passi

Rimaniamo **disponibili per dialogo costruttivo** e per supportare il Dipartimento nella documentazione dei dati, se utile. Riteniamo che una **migliore documentazione della struttura, scope e metodologia di estrazione dei dati** beneficerebbe l'intera comunità di utenti (ricercatori, NGO, pubblica amministrazione).

Attualmente i file Excel forniti rappresentano un importante contributo all'open data sulla violenza di genere. Una risposta chiara su questi punti permetterebbe di:
- Garantire l'affidabilità e l'interpretabilità corretta dei dati
- Permettere ai ricercatori di utilizzare il dataset con piena consapevolezza della sua struttura e dei filtri applicati
- Supportare analisi comparative con altre fonti dati (es. ISTAT)

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
