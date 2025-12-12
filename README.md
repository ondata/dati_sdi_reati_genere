# Violenza di genere: dati SDI 2019-2024

Dati sui reati collegati alla violenza di genere in Italia, rilasciati dal Dipartimento della Pubblica Sicurezza del Ministero dell'Interno a seguito di richiesta FOIA.

**Periodo:** 2019-2024 (dati 2024 non consolidati)
**Richiesta:** 18 aprile 2025 (Period Think Tank)
**Risposta:** 9 maggio 2025

## Contenuti

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

Quelli commessi in Italia, per il periodo compreso tra il 2019 ed il 2024 (non consolidati per l’anno 2024, quindi suscettibili di variazioni).

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

## Struttura Repository

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

## Output Disponibili

### Comunicazioni SDI (data/output/comunicazioni_sdi/)

**10 file CSV** con dati normalizzati e arricchiti:

- Colonne anno convertite in righe
- Codici ISTAT per regioni e province
- Nomi geografici standardizzati
- 3 categorie × 3 prospettive + omicidi DCPC

📋 [Vedi schema dati completo](data/output/comunicazioni_sdi/README.md)

### Reati SDI (data/output/reati_sdi/)

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

- **Dati 2024 non consolidati** (suscettibili di variazioni)
- **No disaggregazione comunale per statistiche reati** (file _5: solo province per privacy - Delibera Garante n. 515/2018)
- **No classificazione "femminicidi"** (non previsti come fattispecie giuridica autonoma)

## Crediti

**Richiesta FOIA:** Period Think Tank
**Pubblicazione:** datiBeneComune
**Elaborazione dati:** datiBeneComune

Progetto nato con il sostegno di **datiBeneComune** per promuovere trasparenza e riutilizzo dei dati pubblici.

## Licenza

I dati sono rilasciati come **open data** e liberamente riutilizzabili per ricerca, con [licenza CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
