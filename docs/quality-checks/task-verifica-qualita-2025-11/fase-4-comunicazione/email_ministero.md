# Email al Ministero dell'Interno - Proposta Collaborativa

**Oggetto**: Analisi collaborativa dati FOIA MI-123-U-A-SD-2025-90 - Proposta di miglioramento qualità

**Destinatario**: Dipartimento Pubblica Sicurezza - Ministero dell'Interno
**Mittente**: Period Think Tank / datiBeneComune
**Data**: 2025-11-15
**Protocollo Riferimento**: MI-123-U-A-SD-2025-90_4 del 15/10/2025

---

Spettabile Dipartimento Pubblica Sicurezza,

in riferimento alla vostra cortese risposta FOIA (protocollo MI-123-U-A-SD-2025-90_4), abbiamo condotto un'analisi dei file Excel ricevuti (`MI-123-U-A-SD-2025-90_5.xlsx` e `MI-123-U-A-SD-2025-90_6.xlsx`) e, nel nostro desiderio di contribuire costruttivamente al miglioramento della qualità dei dati su questi temi, vorremmo condividere alcune osservazioni che potrebbero risultare utili.

## Osservazioni Tecniche Preliminari

**Nota importante**: siamo consapevoli che la nostra analisi potrebbe contenere imprecisioni interpretative, data la complessità dei sistemi SDI. Per questo motivo ci presentiamo in uno spirito collaborativo, pronti ad ascoltare precisazioni e a correggere eventuali errate interpretazioni.

**Premessa metodologica**: valutiamo come "critiche" quelle osservazioni che potrebbero compromettere l'affidabilità statistica dei dati o rendere impossibile la loro corretta interpretazione da parte di ricercatori e analisti. Non si tratta di giudizi di merito sul vostro lavoro, ma di segnalazioni tecniche per migliorare l'usabilità dei dati.

### 1. Struttura dati PROT_SDI

Nel file `MI-123-U-A-SD-2025-90_6.xlsx` abbiamo notato che il campo PROT_SDI presenta alcune caratteristiche che riteniamo critiche o di difficile interpretazione:

- **5.124 record totali** con **2.644 PROT_SDI unici**
- **2.480 record (48.4%)** condividono lo stesso PROT_SDI
- **Esempio**: PGPQ102023002369 compare in 48 record con 6 autori diversi, 1 vittima, 1 tipo reato

**Perché è critico**: Dando per scontato che PROT_SDI identifichi più reati legati allo stesso episodio, riteniamo fondamentale ricevere insieme al file Excel una documentazione completa di tutti i campi. Senza possiamo fare ipotesi interpretative che potrebbero essere errate.

Saremmo grati se poteste fornire una documentazione tecnica che spieghi la struttura e il significato di tutti i campi del dataset.

### 2. Campo DES_OBIET

Abbiamo rilevato nel file `MI-123-U-A-SD-2025-90_6.xlsx` che anche il campo DES_OBIET presenta caratteristiche che lo rendono di difficile interpretazione:

- **3.205 record (62.5%)** con valore "NON PREVISTO/ALTRO"
- **1.841 record (35.9%)** con valore "PRIVATO CITTADINO"

**Perché è critico**: non abbiamo documentazione su questo campo. Potreste aiutarci a capire cosa rappresenta esattamente? Si tratta della vittima, del contesto, del luogo?

### 3. Distribuzione temporale

La distribuzione per anno di denuncia nel file `MI-123-U-A-SD-2025-90_6.xlsx` mostra una concentrazione che riteniamo critica per l'analisi temporale:

- 2019: 4 casi
- 2020: 5 casi
- 2021: 3 casi
- 2022: 13 casi
- 2023: 530 casi
- 2024: 4.277 casi

**Perché è critico**: Il 99.9% dei casi si concentra nel 2023-2024. Questa distribuzione rende il dataset inadeguato per analisi storiche o trend temporali, che sono fondamentali per valutare l'efficacia delle politiche di contrasto alla violenza di genere. Senza sapere se questo riflette l'implementazione progressiva del sistema SDI, una migrazione dati incompleta o altri fattori tecnici, qualsiasi analisi temporale rischia di essere fuorviante.

### 4. Dati mancanti per reati con relazione obbligatoria

Confrontando i dati con il report "Polizia_Un_anno_di_codice_rosso_2020.pdf" (che alleghiamo per vostra comodità), notiamo differenze che riteniamo critiche perché riguardano reati che per loro natura dovrebbero richiedere sempre una relazione identificata vittima-autore:

**Art. 387 bis (violazione provvedimenti allontanamento)**:

- File SDI 2020: 87 casi
- Report Polizia 2020: 1.741 casi
- **Dati mancanti: 1.654 casi (95%)**

**Art. 558 bis (costrizione matrimonio)**:

- File SDI 2019-2020: 0 casi
- Report Polizia 2020: 11 casi
- **Dati mancanti: 11 casi (100%)**

**Perché è critico**: Questi reati richiedono SEMPRE una relazione identificata vittima-autore (l'art. 387 bis si basa su provvedimenti giudiziari pre-esistenti, l'art. 558 bis per sua natura implica una relazione). Se il file SDI contiene solo casi con relazione identificata, questi dati dovrebbero essere presenti. La loro assenza suggerisce problemi sistematici di raccolta dati per categorie di reati fondamentali nel contrasto alla violenza di genere.

Comprendiamo che i perimetri analitici potrebbero essere diversi, ma per questi articoli specifici la differenza sembra indicare dati effettivamente mancanti. Sareste così gentili da aiutarci a capire questa discrepanza?

### 5. Dati mancanti omicidi partner/ex partner - Confronto file 5 vs file 6

Confrontando i dati tra i due file Excel ricevuti, notiamo un'altra discrepanza critica per omicidi che per loro natura richiedono sempre una relazione identificata vittima-autore:

**File 5 (foglio "Omicidi DCPC") - omicidi totali** (…di cui da partner/ex partner):

- 2019: 82 casi
- 2020: 73 casi
- 2021: 82 casi
- 2022: 70 casi

**File 6**:

- 2019-2021: 0 casi
- 2022: 1 caso

**Dati mancanti**: 237 casi su 307 (77% mancanti) nel periodo 2019-2022

**Perché è critico**: Gli omicidi da partner/ex partner richiedono SEMPRE una relazione identificata vittima-autore. Se il file 6 contiene solo casi con relazione identificata, dovremmo trovare la maggior parte di questi omicidi. La loro assenza suggerisce problemi sistematici di raccolta dati per la categoria più grave di violenza di genere.

Anche in questo caso, saremmo grati se poteste aiutarci a capire questa discrepanza.

### 6. Formato e struttura dei dati non idonei per elaborazioni automatiche

Il file `MI-123-U-A-SD-2025-90_5.xlsx` presenta caratteristiche di strutturazione che, pur rendendo i dati leggibili a schermo, li rendono estremamente difficili da elaborare automaticamente con strumenti di analisi dati:

#### 6.1 Righe di intestazione ridondanti usate come didascalie

Ogni foglio del file inizia con una riga di descrizione narrativa che precede le vere intestazioni di colonna:

**Esempio (foglio "Omicidi DCPC")**:

```
Riga 1: "Omicidi volontari consumati in Italia (fonte D.C.P.C. - dati operativi)"
Riga 2: [vuota] | 2019 | 2020 | 2021 | ...
Riga 3: "Omicidi commessi" | 321 | 287 | 312 | ...
```

**Esempio (foglio "Delitti - Commessi")**:

```
Riga 1: "Numero reati commessi in Italia disaggregati a livello provinciale
        (Dati di fonte SDI/SSD non consolidati per il 2024...)"
Riga 2: Provincia | Delitto | 2019 | 2020 | 2021 | ...
Riga 3: AGRIGENTO | 5. TENTATI OMICIDI | 14 | 10 | 11 | ...
```

**Perché è critico**: Le didascalie in riga 1 impediscono il parsing automatico dei dati. Qualsiasi software di analisi (R, Python, QGIS, ecc.) richiede che la prima riga contenga esclusivamente i nomi delle colonne. Attualmente è necessaria una pre-elaborazione manuale per rimuovere queste righe, introducendo rischio di errori e rallentando significativamente l'analisi.

#### 6.2 Utilizzo di formato wide invece di long

I dati sono organizzati in formato "wide" (anni come colonne separate) invece che "long" (anni come valori in una colonna):

**Formato attuale (wide)**:

```
Provincia   | Delitto              | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
AGRIGENTO   | 5. TENTATI OMICIDI   | 14   | 10   | 11   | 8    | 13   | 13
ALESSANDRIA | 5. TENTATI OMICIDI   | 3    | 5    | 10   | 2    | 5    | 5
```

**Formato raccomandato (long)**:

```
Provincia   | Delitto              | Anno | Valore
AGRIGENTO   | 5. TENTATI OMICIDI   | 2019 | 14
AGRIGENTO   | 5. TENTATI OMICIDI   | 2020 | 10
AGRIGENTO   | 5. TENTATI OMICIDI   | 2021 | 11
ALESSANDRIA | 5. TENTATI OMICIDI   | 2019 | 3
```

**Perché è critico**: Il formato wide è obsoleto e contrario alle best practice internazionali di data management (standard "tidy data"). Rende difficili o impossibili operazioni di base come:

- Filtrare dati per anno
- Calcolare medie temporali
- Creare serie storiche
- Aggregare dati su periodi personalizzati
- Incrociare con altre fonti temporali

Tutti gli standard moderni di dati aperti (W3C, Open Data Charter, AgID) raccomandano il formato long per dati con dimensione temporale.

#### 6.3 Assenza di codici standardizzati per entità geografiche

Le entità geografiche (province, regioni, comuni, stati) sono rappresentate solo attraverso denominazioni testuali, senza i corrispondenti codici standardizzati:

- **Regioni**: mancano i codici ISTAT regionali
- **Province**: mancano i codici ISTAT provinciali (codici a 3 cifre)
- **Comuni**: mancano i codici ISTAT comunali (codici a 6 cifre)
- **Stati**: mancano i codici ISO 3166-1 alpha-2 o alpha-3

**Perché è critico**: L'assenza di codici standardizzati costituisce una barriera significativa all'interoperabilità dei dati. I codici ISTAT per gli enti territoriali italiani e i codici ISO per gli stati esteri sono standard riconosciuti che permettono:

- **Incrocio preciso con altre fonti dati** (ISTAT, banche dati amministrative, open data regionali e comunali)
- **Eliminazione di ambiguità** dovute a varianti grafiche, abbreviazioni o errori di trascrizione (es. "Reggio Calabria" vs "Reggio Emilia", "Aosta" vs "Valle d'Aosta")
- **Analisi territoriali affidabili** senza rischi di errate aggregazioni
- **Conformità agli standard internazionali** di condivisione dati aperti

#### 6.4 Proposta: doppio formato XLSX + CSV

Comprendiamo che il formato XLSX attuale possa essere utile per visualizzazione diretta a schermo o stampa. Per questo proponiamo una soluzione che soddisfi entrambe le esigenze:

**File XLSX** (per visualizzazione umana):

- Mantenere il formato attuale con didascalie e layout wide se necessario
- Utile per consultazione rapida e presentazioni

**File CSV** (per elaborazioni automatiche):

- Formato long (tidy data) con colonna "anno"
- Prima riga con soli nomi di colonne (senza didascalie narrative)
- Codici geografici standardizzati ISTAT/ISO in colonne dedicate
- Encoding UTF-8 con BOM
- Separatore punto e virgola (standard italiano)

Questa soluzione rappresenta una best practice consolidata in ambito internazionale (es. Eurostat, OECD, UK ONS) e nazionale (ISTAT) e permetterebbe di rendere i dati immediatamente utilizzabili per analisi riproducibili senza pre-elaborazioni manuali.

Sarebbe possibile adottare questo doppio formato nei rilasci futuri?

## Proposta Collaborativa

Il nostro obiettivo non è critico ma costruttivo. Le osservazioni che abbiamo definito "critiche" lo sono perché potrebbero compromettere l'utilità dei dati per ricercatori, policymaker e società civile che si affidano a questi dati per comprendere e contrastare la violenza di genere.

### Obiettivo principale: pubblicazione online regolare

L'obiettivo per noi più importante, tuttavia, va oltre il miglioramento della qualità tecnica dei dati: **auspichiamo che il Dipartimento possa pubblicare questi dataset online in modo proattivo e continuativo**, non soltanto come risposte a richieste FOIA.

La violenza di genere è un fenomeno che si sviluppa in modo continuo e richiede monitoraggio costante. Per questo motivo suggeriamo:

- **Pubblicazione proattiva**: rendere disponibili i dati su un portale open data dedicato, accessibile a ricercatori, giornalisti, organizzazioni della società civile e cittadini
- **Frequenza trimestrale**: aggiornamenti ogni tre mesi invece che annuali, per permettere analisi tempestive e supportare interventi di policy più rapidi ed efficaci
- **Documentazione tecnica**: accompagnare i dati con metadati completi, dizionario dati e note metodologiche

Questa pratica è già consolidata in molti paesi europei (UK, Spagna, Francia) e permetterebbe all'Italia di allinearsi agli standard internazionali di trasparenza su un tema di rilevanza sociale così critica.

Siamo a vostra disposizione per:

- discutere queste osservazioni in un incontro
- collaborare allo sviluppo di documentazione più chiara
- aiutare a testare la qualità dei dataset prima della loro diffusione
- supportare tecnicamente l'implementazione di un sistema di pubblicazione regolare

## Allegati

Alleghiamo per vostra comodità:
- File Excel ricevuti: `MI-123-U-A-SD-2025-90_5.xlsx` e `MI-123-U-A-SD-2025-90_6.xlsx`
- Report Polizia di riferimento: `Polizia_Un_anno_di_codice_rosso_2020.pdf`
- Nostro report tecnico preliminare con query SQL riproducibili

## Contatti

Restiamo a vostra completa disposizione per qualsiasi chiarimento o approfondimento. Siamo convinti che un dialogo costruttivo possa portare a un miglioramento complessivo della qualità degli opendata sulla violenza di genere.

Ringraziandovi ancora per la disponibilità e l'attenzione, porgiamo distinti saluti.

**Period Think Tank / datiBeneComune**
[Contatto di riferimento]
[Email]
[Telefono]

---

**In allegato**:
- MI-123-U-A-SD-2025-90_5.xlsx
- MI-123-U-A-SD-2025-90_6.xlsx
- Polizia_Un_anno_di_codice_rosso_2020.pdf
- Report tecnico analisi preliminare
