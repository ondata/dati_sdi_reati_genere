# Violenza di genere: dati SDI 2019-2025

Dati sui reati collegati alla violenza di genere in Italia, rilasciati dal Dipartimento della Pubblica Sicurezza del Ministero dell'Interno a seguito di due richieste di accesso civico generalizzato (FOIA) presentate da Period Think Tank, nell'ambito della campagna #datiBeneComune.

| Rilascio | Richiesta | Risposta | Periodo dei dati | Dove |
|---|---|---|---|---|
| Primo | 18 aprile 2025 | 9 maggio 2025 (prot. MI-123-U-A-SD-2025-90) | 2019-2024 | `data/rawdata/`, `data/output/comunicazioni_sdi/`, `data/output/reati_sdi/` |
| Secondo | 16 aprile 2026 | 15 maggio 2026 (prot. MI-123-U-C-3-2-2026-88) | 2024-2025 | `data/rawdata/2026/`, `data/output/2026/` |

**Per i conteggi provinciali usare la serie 2019-2025** (`data/output/2026/serie_2019_2025/province_2019_2025.csv`), che unisce i due rilasci e contiene il 2024 consolidato. I CSV in `data/output/comunicazioni_sdi/` restano come documentazione del primo rilascio.

## Rilascio 2026

Stranezze dei dati, scelte di trattamento e domande aperte: [`docs/2026/note.md`](docs/2026/note.md).

### Contenuti

| Cartella | File | Contenuto |
|---|---|---|
| `data/output/2026/microdati_2025/` | `2025.csv` | Una riga per coppia vittima-autore e reato, 2025: 29.676 righe, 24.363 vittime. Reato, data, sesso, età e paese di nascita di vittima e presunto autore, relazione, luogo, arma, ammonimenti, misure di sicurezza, violazioni, con la descrizione accanto a ogni codice |
| `data/output/2026/aggregati_2024_2025/` | `aggregati_2024_2025.csv` | Reati commessi, vittime donne per fascia d'età e segnalazioni a carico dei presunti autori, per provincia, 2024-2025, in formato lungo |
| | `omicidi_dcpc_2024_2025.csv` | Omicidi volontari nazionali 2024-2025 (dati operativi DCPC) |
| `data/output/2026/serie_2019_2025/` | `province_2019_2025.csv` | Serie provinciale 2019-2025 dei due rilasci uniti, con la colonna `rilascio` |
| | `revisioni_2024.csv` | Confronto del 2024 tra primo e secondo rilascio |
| | `omicidi_dcpc_2019_2025.csv` | Serie nazionale degli omicidi volontari |
| `data/output/2026/legende/` | | Legende dei codici, elenco ISTAT delle province al 31/12/2025, alias di province e reati |
| `data/rawdata/2026/` | | xlsx aggregato 2024-2025 e query SQL di estrazione allegata dal Ministero |
| `scripts/2026/` | | Pipeline (`semestri.sh`, `aggregati.sh`, `serie_provinciale.sh`) e controllo `verifica_identificativi.sh` |

Tutti i CSV del rilascio 2026 hanno intestazioni in minuscolo. Nei conteggi provinciali **ogni analisi parte da un filtro su `gruppo` e `misura`**: le tre misure contano cose diverse e non vanno sommate tra loro.

### Cosa non è pubblicato, e perché

I due xlsx dei semestri 2025 inviati dal Ministero **non sono pubblicati**. Contengono il codice persona SDI della vittima, lo stesso codice presente nel file `MI-123-U-A-SD-2025-90_6.xlsx` del primo rilascio insieme al comune: pubblicarli permetterebbe di ricollegare le stesse persone tra i due file. In `2025.csv` il codice è sostituito da uno senza significato (`V00001`...), e la tabella di corrispondenza non è pubblica. Per questo `scripts/2026/semestri.sh` si può eseguire solo disponendo dei file originali; `aggregati.sh` e `serie_provinciale.sh` girano sui file pubblicati.

La sostituzione del codice non rende i dati anonimi: le altre colonne permettono ancora corrispondenze per somiglianza. Il dettaglio è in [`docs/2026/note.md`](docs/2026/note.md).

### Riprodurre i dati

```bash
./scripts/2026/aggregati.sh
./scripts/2026/serie_provinciale.sh

# solo con i file originali dei semestri, fuori dal repository
RAW_SEMESTRI=/percorso/xlsx CODICI_VITTIMA=/percorso/codici_vittima.csv ./scripts/2026/semestri.sh
```

Gli script rigenerano l'output da zero, danno file identici a ogni esecuzione e si fermano se un codice, una provincia o un reato non trovano corrispondenza. Al termine controllano che nell'output non compaiano codici persona SDI.

## Rilascio 2025 (dati 2019-2024)

Il Ministero ha rilasciato due file Excel:

- [MI-123-U-A-SD-2025-90_5.xlsx](https://raw.githubusercontent.com/ondata/dati_sdi_reati_genere/main/data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx)
- [MI-123-U-A-SD-2025-90_6.xlsx](https://raw.githubusercontent.com/ondata/dati_sdi_reati_genere/main/data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx)

### Statistiche provinciali sui reati (MI-123-U-A-SD-2025-90_5.xlsx)

I dati con disaggregazione a livello provinciale, in relazione ai reati commessi, all'incidenza delle vittime di genere femminile, nonché alle, segnalazioni riferite a persone denunciate/arrestate per:

- omicidi
- tentati omicidi
- lesioni dolose
- percosse
- minacce
- violenze sessuali
- atti persecutori
- maltrattamenti contro familiari e conviventi
- costrizione o induzione al matrimonio
- deformazione dell’aspetto della persona mediante lesioni permanenti al viso
- diffusione illecita di immagini o video sessualmente espliciti
- violazione dei provvedimenti di allontanamento dalla casa familiare e del divieto di avvicinamento ai luoghi frequentati dalla persona offesa

Si tratta di quelli commessi in Italia, per il periodo compreso tra il 2019 ed il 2024 (non consolidati per l’anno 2024, quindi suscettibili di variazioni).

**Fonte:** SDI (Sistema Di. Indagine) ed SSD (Sistema di Supporto alle Decisioni)

**Aggregazione:** Provinciale

**Contenuto:**

- Omicidi volontari consumati (con vittime donne, ambito familiare/affettivo, partner/ex partner)
- Delitti: lesioni dolose, minacce, percosse, tentati omicidi, violenze sessuali
- Reati spia: atti persecutori, maltrattamenti contro familiari e conviventi
- Codice Rosso: costrizione o induzione al matrimonio, deformazione dell'aspetto della persona mediante lesioni permanenti al viso, diffusione illecita di immagini o video sessualmente espliciti, violazione dei provvedimenti di allontanamento dalla casa familiare e del divieto di avvicinamento ai luoghi frequentati dalla persona offesa

**Disaggregazione:**

- 3 prospettive: reati commessi, vittime femminili, segnalazioni (autori per sesso ed età)
- 10 fogli Excel con dati aggregati per provincia e anno

### Comunicazioni SDI con relazione vittima-autore (MI-123-U-A-SD-2025-90_6.xlsx)

I casi di violenza di genere, ove sia stata indicata una "relazione vittima autore", disaggregati fino a livello "Comune" (luogo del fatto).

**Fonte:** SDI (Sistema Di. Indagine) ed SSD (Sistema di Supporto alle Decisioni)

**Aggregazione:** Comunale (quando disponibile)

**Contenuto:**

- Comunicazioni con relazione vittima-autore compilata
- Dati per evento: reato, vittime, denunciati, colpiti da provvedimento
- Informazioni: età, genere, nazionalità, relazione autore-vittima, luogo del fatto, date
- **Righe originali:** 5.124 → **Eventi unici:** 2.644

### Struttura del rilascio 2025

```
data/
├── rawdata/                    # Dati grezzi ricevuti
│   ├── MI-123-U-A-SD-2025-90_5.xlsx
│   ├── MI-123-U-A-SD-2025-90_6.xlsx
│   ├── richiesta.md
│   └── README.md
│
└── output/                     # Dati processati
    ├── comunicazioni_sdi/      # Output da file _5 (10 CSV + README)
    │   ├── delitti_*.csv       # commessi, vittime, segnalazioni
    │   ├── reati_spia_*.csv    # commessi, vittime, segnalazioni
    │   ├── codice_rosso_*.csv  # commessi, vittime, segnalazioni
    │   ├── omicidi_dcpc.csv
    │   └── README.md           # Schema dati e descrizione
    │
    └── reati_sdi/              # Output da file _6 (7 CSV + 1 DB + README)
        ├── dataset_cartesiano.csv          # Prodotto cartesiano dedupplicato
        ├── dataset_array.csv               # Aggregato con array
        ├── relazionale_eventi.csv          # Modello relazionale
        ├── relazionale_reati.csv           #   ↓
        ├── relazionale_vittime.csv         #   ↓
        ├── relazionale_denunciati.csv      #   ↓
        ├── relazionale_colpiti_provv.csv   #   ↓
        ├── reati_sdi_relazionale.duckdb    # Database DuckDB
        └── README.md                       # Guida uso e schema ER
```

### Output del rilascio 2025

#### Comunicazioni SDI (data/output/comunicazioni_sdi/)

**10 file CSV** con dati normalizzati e arricchiti:

- Colonne anno convertite in righe
- Codici ISTAT per regioni e province
- Nomi geografici standardizzati
- 3 categorie × 3 prospettive + omicidi DCPC

📋 [Vedi schema dati completo](data/output/comunicazioni_sdi/README.md)

#### Reati SDI (data/output/reati_sdi/)

**3 formati dati** per diverse esigenze analitiche:

1. **Cartesiano** (`dataset_cartesiano.csv`): 3.329 righe
   1 riga = 1 combinazione denunciato × vittima × reato × colpito_provv

2. **Array** (`dataset_array.csv`): 2.644 righe ✅
   1 riga = 1 evento, soggetti multipli in array

3. **Relazionale** (5 tabelle CSV + database DuckDB):
   Schema normalizzato con foreign keys e indici

**Arricchimenti:**

- Codici ISTAT per regioni, province, comuni (fuzzy matching)
- Codici ISO 3166-1 alpha-3 per nazioni di nascita
- Nomi comuni normalizzati (es. `SALO'` → `Salò`)
- Gestione duplicati (49.4% righe duplicate rimosse)

📊 [Vedi statistiche e guida uso](data/output/reati_sdi/README.md)

## Limitazioni

- **Dati 2024 non consolidati** (suscettibili di variazioni): la versione consolidata è nel rilascio 2026, le differenze in `data/output/2026/serie_2019_2025/revisioni_2024.csv`
- **No disaggregazione comunale per statistiche reati** (file _5: solo province per privacy - Delibera Garante n. 515/2018)
- **No classificazione "femminicidi"** nel rilascio 2025 (fattispecie autonoma solo dal 17 dicembre 2025, art. 577-bis c.p.); nel rilascio 2026 il codice c'è ma è accorpato agli omicidi

## Crediti

**Richiesta FOIA:** Period Think Tank
**Pubblicazione:** datiBeneComune
**Elaborazione dati:** datiBeneComune

Progetto nato con il sostegno di **datiBeneComune** per promuovere trasparenza e riutilizzo dei dati pubblici.

## Licenza

I dati sono rilasciati come **open data** e liberamente riutilizzabili per ricerca, con [licenza CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
