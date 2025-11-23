# Email al Ministero dell'Interno - Proposta Collaborativa

**Oggetto**: Analisi collaborativa dati FOIA MI-123-U-A-SD-2025-90 - Proposta di miglioramento qualità

**Destinatario**: Dipartimento Pubblica Sicurezza - Ministero dell'Interno
**Mittente**: Period Think Tank / datiBeneComune
**Data**: 2025-11-15
**Protocollo Riferimento**: MI-123-U-A-SD-2025-90_4 del 15/10/2025

---

Spettabile Dipartimento Pubblica Sicurezza,

in riferimento alla vostra cortese risposta FOIA (protocollo MI-123-U-A-SD-2025-90_4), abbiamo condotto un'analisi dei file Excel ricevuti (`MI-123-U-A-SD-2025-90_5.xlsx` e `MI-123-U-A-SD-2025-90_6.xlsx`) e, nel nostro desiderio di contribuire costruttivamente al miglioramento della qualità dei dati su questi temi, vorremmo condividere alcune osservazioni che potrebbero risultare utili.

## Osservazioni tecniche preliminari

**Nota importante**: siamo consapevoli che la nostra analisi potrebbe contenere imprecisioni interpretative, data la complessità dei sistemi SDI. Per questo motivo ci presentiamo in uno spirito collaborativo, pronti ad ascoltare precisazioni e a correggere eventuali errate interpretazioni.

**Premessa metodologica**: valutiamo come "critiche" quelle osservazioni che potrebbero compromettere l'affidabilità statistica dei dati o rendere impossibile la loro corretta interpretazione da parte di ricercatori e analisti. Non si tratta di giudizi di merito sul vostro lavoro, ma di segnalazioni tecniche per migliorare l'usabilità dei dati.

### Righe duplicate e prodotto cartesiano (CRITICO)

Nel file `MI-123-U-A-SD-2025-90_6.xlsx` abbiamo rilevato **due problemi importanti di qualità dei dati** che compromettono l'affidabilità statistica del dataset:

#### Duplicati esatti completi (49.4% del dataset)

Analizzando il file con elaborazione completa, abbiamo confermato che:

- **5.124 righe totali** nel file originale
- **2.534 righe (49.4%) sono duplicati esatti completi** - tutti i campi identici
- **798 gruppi di duplicati**, con casi estremi di **30 righe completamente identiche**
- Dopo rimozione duplicati: **3.329 righe uniche** e **2.644 eventi unici (PROT_SDI)**

**Esempio concreto**:
- PROT_SDI `BSCS352024000004`: 30 righe identiche (stesso evento, stesso reato, stessa vittima, stesso denunciato, tutti i campi uguali)
- PROT_SDI `BSPC012024000405`: 17 righe identiche

**Perché è critico**: Questi non sono duplicati dovuti a struttura relazionale (più reati o più vittime), ma **errori di estrazione dati** che inflazionano artificialmente tutti i conteggi statistici. Qualsiasi analisi su questi dati senza deduplica produce risultati completamente errati.

#### Prodotto cartesiano tra denunciati e "colpiti da provvedimento"

Anche dopo rimozione dei duplicati esatti, il dataset presenta una struttura a **prodotto cartesiano** che genera righe artificiose:

**Esempio PGPQ102023002369** (dopo deduplica):
- 1 vittima × 1 reato × 6 denunciati × 6 "colpiti da provvedimento" = **36 righe**
- Ogni denunciato viene abbinato a OGNI persona colpita da provvedimento
- Questo crea combinazioni senza relazione diretta tra i soggetti

**Dataset deduplicato (3.329 righe uniche)**:
- **2.644 eventi unici (PROT_SDI)** - confermato da tutti i nostri output
- 85% eventi con 1 sola riga
- 15% eventi con righe multiple dovute a:
  - Multi-reati (144 eventi)
  - Multi-vittime (80 eventi)
  - Multi-denunciati (45 eventi)
  - **Prodotto cartesiano denunciati × colpiti_da_provv** (causa principale delle righe multiple)

**Perché è critico**:

1. **Impossibile usare i dati per conteggi affidabili** senza una guida dettagliata su come aggregare
2. **La granularità del dataset non è documentata**: 1 riga = 1 evento? 1 reato? 1 combinazione artificiale?

**Domande**:
- I **duplicati esatti** sono un errore di estrazione? Possiamo aspettarci versioni corrette?
- Qual è la **granularità corretta** del dataset? Come dobbiamo aggregare per conteggi accurati?
- Esiste una **documentazione tecnica della struttura relazionale** del database SDI?

Senza questa documentazione, il dataset è **difficilmente utilizzabile per analisi statistiche affidabili**.

### Campo DES_OBIET

Abbiamo rilevato nel file `MI-123-U-A-SD-2025-90_6.xlsx` che anche il campo DES_OBIET presenta caratteristiche che lo rendono di difficile interpretazione:

- **1.654 eventi (62.5%)** con valore "NON PREVISTO/ALTRO"
- **950 eventi (35.9%)** con valore "PRIVATO CITTADINO"

**Perché è critico**: non abbiamo documentazione su questo campo. Potreste aiutarci a capire cosa rappresenta esattamente? **Si tratta della vittima, del contesto, del luogo**?

### Distribuzione temporale

La distribuzione per anno di denuncia nel file `MI-123-U-A-SD-2025-90_6.xlsx` mostra una concentrazione che riteniamo critica per l'analisi temporale:

- 2019: 3 casi (0.1%)
- 2020: 4 casi (0.2%)
- 2021: 3 casi (0.1%)
- 2022: 7 casi (0.3%)
- 2023: 234 casi (9.5%)
- 2024: 2.208 casi (89.8%)

**Perché è critico**: Il 99.3% dei casi si concentra nel 2023-2024. Questa distribuzione rende il dataset inadeguato per analisi storiche o trend temporali, che sono fondamentali per valutare l'efficacia delle politiche di contrasto alla violenza di genere. Senza sapere se questo riflette l'implementazione progressiva del sistema SDI, una migrazione dati incompleta o altri fattori tecnici, qualsiasi analisi temporale rischia di essere fuorviante.

### Dati mancanti per reati con relazione obbligatoria

Confrontando i dati con il report "Polizia_Un_anno_di_codice_rosso_2020.pdf" (che alleghiamo per vostra comodità), notiamo differenze che riteniamo critiche perché riguardano reati che per loro natura dovrebbero richiedere sempre una relazione identificata vittima-autore:

**Art. 387 bis (violazione provvedimenti allontanamento)**:

- File SDI 2020: 87 casi (confermato da output array)
- Report Polizia 2020: 1.741 casi
- **Dati mancanti: 1.654 casi (95%)**

**Art. 558 bis (costrizione matrimonio)**:

- File SDI 2019-2020: 0 casi (confermato da output array)
- Report Polizia 2020: 11 casi
- **Dati mancanti: 11 casi (100%)**

**Perché è critico**: Questi reati richiedono SEMPRE una relazione identificata vittima-autore (l'art. 387 bis si basa su provvedimenti giudiziari pre-esistenti, l'art. 558 bis per sua natura implica una relazione). Se il file SDI contiene solo casi con relazione identificata, questi dati dovrebbero essere presenti. La loro assenza suggerisce problemi sistematici di raccolta dati per categorie di reati fondamentali nel contrasto alla violenza di genere.

Comprendiamo che i perimetri analitici potrebbero essere diversi, ma per questi articoli specifici la differenza sembra indicare dati effettivamente mancanti. Sareste così gentili da aiutarci a capire questa discrepanza?

### Dati mancanti omicidi partner/ex partner - Confronto file 5 vs file 6

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

### Formato e struttura dei dati non idonei per elaborazioni automatiche

Il file `MI-123-U-A-SD-2025-90_5.xlsx` presenta caratteristiche di strutturazione che, pur rendendo i dati leggibili a schermo, li rendono estremamente difficili da elaborare automaticamente con strumenti di analisi dati:

#### Righe di intestazione ridondanti usate come didascalie

Ogni foglio del file inizia con una riga di descrizione narrativa che precede le vere intestazioni di colonna:

**Esempio (foglio "Delitti - Commessi")**:

```
Riga 1: "Numero reati commessi in Italia disaggregati a livello provinciale
        (Dati di fonte SDI/SSD non consolidati per il 2024...)"
Riga 2: Provincia | Delitto | 2019 | 2020 | 2021 | ...
Riga 3: AGRIGENTO | 5. TENTATI OMICIDI | 14 | 10 | 11 | ...
```

**Perché è critico**: Le didascalie in riga 1 impediscono il parsing automatico dei dati. Qualsiasi software di analisi (R, Python, QGIS, ecc.) richiede che la prima riga contenga esclusivamente i nomi delle colonne. Attualmente è necessaria una pre-elaborazione manuale per rimuovere queste righe, introducendo rischio di errori e rallentando significativamente l'analisi.

#### Utilizzo di formato wide invece di long

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

#### Assenza di codici standardizzati per entità geografiche

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

#### Province mancanti e nomenclatura obsoleta (CRITICO)

Analizzando i nomi delle province nel file `MI-123-U-A-SD-2025-90_5.xlsx` e confrontandoli con le fonti ufficiali (anagrafe ISTAT e shapefile amministrativi Istat), abbiamo rilevato **problemi critici di completezza e aggiornamento della nomenclatura geografica**:

**Provincia Sud Sardegna completamente assente**:

- Il file xlsx contiene solo 4 province sarde: CAGLIARI, NUORO, ORISTANO, SASSARI
- Manca completamente la provincia del **Sud Sardegna** (istituita con L.R. Sardegna 2/2016)
- Questa provincia è presente negli shapefile ufficiali Istat (ProvCM01012025_g) e nell'anagrafe comunale Istat
- Dato che il dataset include dati fino al 2024, **8 anni dopo l'istituzione della provincia**, questa assenza rappresenta un **grave problema di completezza territoriale**

**Nomenclatura obsoleta per altre province**:

Confrontando con le denominazioni ufficiali Istat, abbiamo rilevato 6 province con nomi non aggiornati o abbreviati:

- AOSTA → nome ufficiale: "Valle d'Aosta/Vallée d'Aoste"
- BOLZANO → nome ufficiale: "Bolzano/Bozen"
- FORLI' CESENA → nome ufficiale: "Forlì-Cesena" (apostrofo vs accento, spazio vs trattino)
- MASSA CARRARA → nome ufficiale: "Massa-Carrara" (manca trattino)
- REGGIO EMILIA → nome ufficiale: "Reggio nell'Emilia"
- VERBANIA → nome ufficiale: "Verbano-Cusio-Ossola" (nome abbreviato vs completo)

**Perché è critico**:

1. **Dati territorialmente incompleti**: L'assenza del Sud Sardegna significa che tutti gli eventi verificatisi in quella provincia dal 2016 al 2024 sono:
   - Completamente assenti dal dataset (causando sottostima statistica grave)
   - Oppure attribuiti erroneamente ad altre province sarde (causando errori di aggregazione territoriale)

2. **Impossibile georeferenziazione automatica**: La nomenclatura obsoleta o non standard impedisce il join automatico con:
   - Shapefile amministrativi ufficiali Istat
   - Database ISTAT di popolazione e territorio
   - Qualsiasi altra fonte dati che usi nomenclatura ufficiale aggiornata

3. **Rischio di errori di aggregazione**: Province con nomi simili (es. "Reggio Calabria" vs "Reggio Emilia") possono causare errori quando si elaborano i dati senza codici univoci

**Domande**:

- Gli eventi del Sud Sardegna sono presenti nel dataset ma attribuiti ad altre province? O sono completamente assenti?
- Quando sarà possibile avere un dataset con nomenclatura provinciale aggiornata alle denominazioni ufficiali Istat?
- È possibile includere nei prossimi rilasci i codici provincia Istat (COD_PROV) per eliminare ambiguità?

#### Proposta: doppio formato XLSX + CSV

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

#### Nota specifica per il file 6: gestione del prodotto cartesiano

Per il file `MI-123-U-A-SD-2025-90_6.xlsx`, che presenta il problema del prodotto cartesiano tra denunciati e "colpiti da provvedimento", proponiamo due soluzioni alternative:

**Opzione A: Documentazione esplicita del prodotto cartesiano**
- Mantenere il formato flat attuale
- Fornire documentazione tecnica che spieghi chiaramente:
  - Quando e perché si genera il prodotto cartesiano
  - Come aggregare correttamente i dati per conteggi affidabili
  - Qual è la granularità esatta del dataset (1 riga = 1 combinazione)

**Opzione B: Struttura relazionale multi-tabella (raccomandata)**
- Fornire i dati in formato relazionale con tabelle separate:
  - `eventi.csv` (dati principali dell'evento)
  - `vittime.csv` (anagrafiche vittime)
  - `denunciati.csv` (anagrafiche denunciati)
  - `colpiti_provv.csv` (persone colpite da provvedimento)
  - `reati.csv` (tipologie di reato)

Questa struttura elimina il problema del prodotto cartesiano alla fonte e rappresenta lo standard per database relazionali.

Questa soluzione rappresenta una *best practice* consolidata in ambito internazionale.

Sarebbe possibile adottare questo doppio formato nei rilasci futuri?

## Proposta collaborativa

Il nostro obiettivo non è critico ma costruttivo. Le osservazioni che abbiamo definito "critiche" lo sono perché potrebbero compromettere l'utilità dei dati per ricercatori, policymaker e società civile che si affidano a questi dati per comprendere e contrastare la violenza di genere.

### Pubblicazione online regolare

Un obiettivo per noi molto importante, tuttavia, va oltre il miglioramento della qualità tecnica dei dati: **auspichiamo che il Dipartimento possa pubblicare questi dataset online in modo proattivo e continuativo**, non soltanto come risposte a richieste FOIA.

La violenza di genere è un fenomeno che si sviluppa in modo continuo e richiede monitoraggio costante. Per questo motivo suggeriamo:

- **Pubblicazione proattiva**: rendere disponibili i dati su un portale open data dedicato, accessibile a ricercatori, giornalisti, organizzazioni della società civile e cittadini
- **Frequenza trimestrale**: aggiornamenti ogni tre mesi invece che annuali, per permettere analisi più continue e supportare interventi di *policy* più rapidi ed efficaci
- **Documentazione tecnica**: accompagnare i dati con metadati completi, dizionario dati e note metodologiche

Siamo a vostra disposizione per:

- discutere queste osservazioni in un incontro
- collaborare allo sviluppo di documentazione più chiara
- aiutare a testare la qualità dei dataset prima della loro diffusione
- supportare tecnicamente l'implementazione di un sistema di pubblicazione regolare

Ringraziandovi ancora per la disponibilità e l'attenzione, porgiamo distinti saluti.
