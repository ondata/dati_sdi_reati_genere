# Violenza di genere: dati che servono a chi studia e contrasta il fenomeno

Grazie a una richiesta di accesso civico generalizzato (FOIA) presentata da Giulia Sudano in rappresentanza di **Period Think Tank**, il Dipartimento della Pubblica Sicurezza del Ministero dell'Interno ha rilasciato dei dati relativi ai reati collegati alla violenza di genere, commessi in Italia nel periodo 2019-2024.

È un'iniziativa che nasce con il sostegno e il contributo di **datiBeneComune**, un progetto che promuove la trasparenza e il riutilizzo dei dati pubblici.

La richiesta, inviata il 18 aprile 2025 e riscontrata il 9 maggio 2025, mirava ad acquisire informazioni statistiche su diverse tipologie di reato, sull'incidenza delle vittime di genere femminile, sulle denunce/arresti e sulle relazioni vittima-autore.

Il Dipartimento ha risposto trasmettendo due file Excel:

1. **Dati sui reati** (fonte *SDI - Sistema di Indagine / SSD - Sistema di Sorveglianza Dati*, non consolidati per il 2024) disaggregati a livello provinciale, con informazioni su:

    - Omicidi, tentati omicidi, lesioni dolose, percosse, minacce
    - Violenze sessuali, atti persecutori, maltrattamenti in famiglia
    - Reati specifici del Codice Rosso (es. costrizione al matrimonio, diffusione illecita di imagini, deformazione del viso, violazioni di allontanamento)
    - Incidenza delle vittime di sesso femminile
    - Denunce e arresti

    Una sezione specifica riguarda gli **omicidi con vittime donne**, distinti in:

    - Omicidi totali
    - Omicidi in ambito familiare/affettivo
    - Omicidi commessi da partner o ex partner

    Il Dipartimento chiarisce che non viene fornita una classificazione dei "femminicidi", in quanto il termine non corrisponde a una fattispecie giuridica codificata.

2. **Comunicazioni SDI con indicazione della relazione vittima-autore**, disaggregate fino al livello comunale, nei casi in cui tale relazione risulti compilata nel sistema.

I dati ottenuti sono resi disponibili pubblicamente e liberamente riutilizzabili da parte dell'iniziativa **datiBeneComune**, con l'obiettivo di favorire trasparenza, ricerca e consapevolezza sul fenomeno della violenza di genere in Italia.

## Dataset Processati

I dati grezzi sono stati processati e arricchiti con:

- **Codici ISTAT** per regioni, province e comuni (con fuzzy matching per normalizzare i nomi)
- **Codici ISO 3166-1 alpha-3** per gli stati delle nazioni di nascita
- **Normalizzazione nomi comuni** (es. `SALO'` → `Salò`)
- **Formato relazionale** ottimizzato per analisi

> 📋 **Documentazione problemi geografici**: Vedi [docs/problemi_nomi_geografici.md](docs/problemi_nomi_geografici.md) per un'analisi dettagliata dei 51 problemi identificati e risolti nei nomi di regioni, province e comuni.

### Output Disponibili

1. **Dataset Cartesiano** (`data/processed/dataset_cartesiano.csv`): prodotto cartesiano dedupplicato non aggregato
2. **Dataset Array** (`data/processed/dataset_array.csv`): un evento per riga con array per vittime/denunciati/colpiti
3. **Modello Relazionale** (`data/processed/relazionale_*.csv`): tabelle normalizzate
   - `relazionale_eventi.csv`: informazioni sull'evento
   - `relazionale_reati.csv`: reati associati agli eventi
   - `relazionale_vittime.csv`: vittime (con nazione nascita ISO)
   - `relazionale_denunciati.csv`: denunciati (con nazione nascita ISO)
   - `relazionale_colpiti_provv.csv`: colpiti da provvedimento (con nazione nascita ISO)
4. **Database DuckDB** (`data/processed/reati_sdi_relazionale.duckdb`): database relazionale pronto per query SQL

### Statistiche

- **2.644 eventi unici** (da 5.124 righe originali)
- **19 comuni corretti** tramite fuzzy matching (≥95% similarità)
- **105 stati mappati** con codici ISO alpha-3
- **100% dei record con nazione specificata** hanno codice ISO
