# Schema dati reati di genere - Tracciato proposto conforme a Legge 53/2022

## Informazioni generali

- **Versione schema:** 2.0 (proposta)
- **Dataset di riferimento:** MI-123-U-A-SD-2025-90_6.xlsx
- **Fonte dati:** SDI/SSD - Dipartimento Pubblica Sicurezza, Ministero Interno
- **Base normativa:** Legge 21/04/2022 n. 53, Art. 5 (Ministero Interno - CED)
- **Formato file:** CSV, XLSX
- **Encoding:** UTF-8
- **Separatore CSV:** virgola (,)
- **Formato date:** YYYY-MM-DD

## Convenzioni nomi campi

I nomi campi nel dataset originale utilizzano la convenzione **SCREAMING_SNAKE_CASE** (es. `PROT_SDI`, `DATA_INIZIO_FATTO`).

**Raccomandazione:** Si consiglia di adottare la convenzione **snake_case** minuscolo (es. `prot_sdi`, `data_inizio_fatto`) per i seguenti motivi:

- **Standard internazionale**: snake_case minuscolo è lo standard de facto per CSV, JSON e API REST
- **Interoperabilità**: facilita l'integrazione con sistemi esterni e tool di analisi dati (Python pandas, R, SQL)
- **Leggibilità**: migliore leggibilità nei linguaggi case-sensitive
- **Conformità**: allineamento con linee guida dati aperti (OGP, W3C Data on the Web Best Practices)
- **Manutenibilità**: riduce errori di battitura e facilita autocomplete negli IDE

**Nello schema seguente vengono mantenuti i nomi SCREAMING_SNAKE_CASE originali per coerenza con il dataset esistente.**

## Struttura e granularità del dataset

### ⚠️ CRITICITÀ: Duplicati e Prodotto Cartesiano

Il dataset presenta **due problemi critici di qualità**:

**1. Duplicati esatti completi (49.4% delle righe)**

- **5.124 righe totali nel file originale**
- **2.534 righe (49.4%) sono duplicati esatti** (tutti i campi identici)
- **798 gruppi di duplicati**, con casi estremi fino a 30 righe identiche
- Dopo deduplica: **3.329 righe uniche**

**2. Prodotto cartesiano tra denunciati e colpiti da provvedimento**

Il dataset crea un **prodotto cartesiano** quando ci sono più denunciati E più persone colpite da provvedimento nello stesso evento:

- **Esempio PGPQ102023002369**: 6 denunciati × 6 colpiti da provvedimento = 36 righe
- Ogni denunciato viene abbinato a OGNI persona colpita da provvedimento
- Questo genera righe "artificiose" senza relazione diretta tra i soggetti

**Granularità (dopo deduplica):** 1 riga = 1 combinazione evento-reato-vittima-denunciato-colpito_da_provv

**Dataset dedupli cato (3.329 righe uniche):**

- 2.644 eventi unici (`PROT_SDI`)
- Rapporto: 1.26 righe per evento in media
- 2.255 eventi (85%) con 1 sola riga
- 389 eventi (15%) con righe multiple

**Pattern righe multiple (dopo deduplica):**

- 144 eventi con **multi-reati** (stesso evento, articoli diversi)
- 80 eventi con **multi-vittime** (stesso evento, più persone offese)
- 45 eventi con **multi-denunciati** (stesso evento, più autori)
- 46 eventi con pattern non classificabile
- Pattern misti (combinazioni delle precedenti)

**Implicazioni per l'analisi:**

- **PRIMA** di qualsiasi analisi: **deduplica** righe identiche
- **ATTENZIONE** al prodotto cartesiano denunciati × colpiti_da_provv
- Per conteggio **eventi**: raggruppare per `PROT_SDI` unico
- Per conteggio **reati contestati**: `PROT_SDI` + `ART` distinti
- Per conteggio **vittime**: `COD_VITTIMA` univoci
- Per conteggio **denunciati**: `COD_DENUNCIATO` univoci
- **Documentare sempre** quale aggregazione si usa nell'analisi

## Campi esistenti (v1.0 - attuale)

### Identificazione evento

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `PROT_SDI` | string | Sì | Protocollo SDI dell'evento | Identifica l'evento (vedi sezione "Struttura e granularità del dataset") |
| `TENT_CONS` | string | Sì | Tentato/Consumato | Lista controllata: `TENTATO`, `CONSUMATO` |

### Informazioni reato

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `T_NORMA` | string | Sì | Tipo di norma | Lista controllata: `CP` (Codice Penale), `L` (Legge speciale) |
| `RIF_LEGGE` | string | No | Riferimento legislativo | Es. "L. 75/1958" per leggi speciali |
| `ART` | string | Sì | Articolo di legge violato | Es. "572", "612-bis" |
| `DES_REA_EVE` | string | Sì | Descrizione del reato/evento | Testo libero |

### Informazioni temporali

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `DATA_INIZIO_FATTO` | date | Sì | Data inizio fatto | Formato: YYYY-MM-DD |
| `DATA_FINE_FATTO` | date | No | Data fine fatto | Per reati protratti nel tempo |
| `DATA_DENUNCIA` | date | Sì | Data presentazione denuncia | Formato: YYYY-MM-DD |

### Localizzazione geografica

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `STATO` | string | Sì | Stato dove è avvenuto il fatto | **RACCOMANDATO:** Codifica ISO 3166-1 alpha-3 (ITA, FRA, DEU, ecc.) o denominazione standard ISO |
| `REGIONE` | string | Sì | Regione | **OBBLIGATORIO:** Denominazione ufficiale ISTAT + codice regione |
| `PROVINCIA` | string | Sì | Provincia | **OBBLIGATORIO:** Denominazione ufficiale ISTAT + sigla automobilistica o codice provincia |
| `COMUNE` | string | Sì | Comune | **OBBLIGATORIO:** Denominazione ufficiale ISTAT + codice catastale o codice ISTAT |
| `LUOGO_SPECIF_FATTO` | string | Sì | Luogo specifico del fatto | Lista controllata **NON normativa** (definita dal fornitore dati) |

**⚠️ RACCOMANDAZIONE CLASSIFICAZIONI GEOGRAFICHE:**

Per garantire **interoperabilità**, **geocodifica** e **analisi territoriali** corrette, si raccomanda fortemente l'adozione di classificazioni standard:

#### STATO - Standard ISO 3166-1

**Standard raccomandato:** ISO 3166-1 alpha-3 (codice a 3 lettere)

**Vantaggi:**
- Standard internazionale universalmente riconosciuto
- Evita ambiguità nelle denominazioni (es. "Repubblica Ceca" vs "Cechia")
- Compatibilità con sistemi internazionali
- Stabilità nel tempo (denominazioni cambiano, codici ISO rimangono)

**Esempi:**
- `ITA` - Italia
- `FRA` - Francia
- `DEU` - Germania
- `ROU` - Romania
- `MAR` - Marocco
- `ALB` - Albania

**Formato proposto campo:** `STATO_COD_ISO` (nuovo) + `STATO` (descrittivo)

**Riferimento:** https://www.iso.org/iso-3166-country-codes.html

#### REGIONE - Classificazione ISTAT

**Standard obbligatorio:** Elenco ufficiale Regioni ISTAT

**Codifica:** Codice regione ISTAT (2 cifre, 01-20)

**Formato proposto:**

| Codice | Denominazione ufficiale |
|--------|------------------------|
| 01 | Piemonte |
| 02 | Valle d'Aosta/Vallée d'Aoste |
| 03 | Lombardia |
| 04 | Trentino-Alto Adige/Südtirol |
| 05 | Veneto |
| 06 | Friuli-Venezia Giulia |
| 07 | Liguria |
| 08 | Emilia-Romagna |
| 09 | Toscana |
| 10 | Umbria |
| 11 | Marche |
| 12 | Lazio |
| 13 | Abruzzo |
| 14 | Molise |
| 15 | Campania |
| 16 | Puglia |
| 17 | Basilicata |
| 18 | Calabria |
| 19 | Sicilia |
| 20 | Sardegna |

**Campi proposti:**
- `REGIONE_COD_ISTAT` (nuovo): codice numerico ISTAT (es. "08")
- `REGIONE`: denominazione ufficiale ISTAT (es. "Emilia-Romagna")

**Riferimento:** ISTAT - Classificazione delle unità amministrative territoriali (Regioni)

#### PROVINCIA - Classificazione ISTAT

**Standard obbligatorio:** Elenco Province/Città metropolitane ISTAT

**Codifica doppia:**
- **Codice provincia ISTAT** (3 cifre): es. 037 per Bologna
- **Sigla automobilistica** (2 lettere): es. BO per Bologna

**Campi proposti:**
- `PROVINCIA_COD_ISTAT` (nuovo): codice numerico ISTAT (es. "037")
- `PROVINCIA_SIGLA` (nuovo): sigla automobilistica (es. "BO")
- `PROVINCIA`: denominazione ufficiale (es. "Bologna")

**Nota critica:** Dal 2014 esistono anche Città metropolitane (codice ISTAT CM + 3 cifre). Gestire entrambe le tipologie.

**Riferimento:** ISTAT - Elenco codici e denominazioni province

#### COMUNE - Classificazione ISTAT

**Standard obbligatorio:** Codice Catastale o Codice ISTAT Comune

**Codifica doppia:**
- **Codice catastale** (4 caratteri alfanumerici): es. A944 per Bologna
- **Codice ISTAT comune** (6 cifre): es. 037006 per Bologna

**Campi proposti:**
- `COMUNE_COD_ISTAT` (nuovo): codice ISTAT 6 cifre (es. "037006")
- `COMUNE_COD_CATASTALE` (nuovo): codice catastale (es. "A944")
- `COMUNE`: denominazione ufficiale ISTAT (es. "Bologna")

**Vantaggi codifica:**
- Univocità assoluta (evita omonimie: es. 45 comuni "San Giovanni")
- Tracciabilità fusioni/modifiche territoriali
- Join automatici con altri dataset ISTAT
- Compatibilità con sistemi GIS

**Riferimento:** ISTAT - Elenco codici comuni (aggiornamento annuale al 1° gennaio)

**IMPORTANTE:** Utilizzare elenco ISTAT aggiornato all'anno di riferimento del fatto, poiché ci sono fusioni/modifiche comunali annuali.

---

**Proposta campi aggiuntivi v2.0:**

| Nome campo | Tipo | Descrizione |
|------------|------|-------------|
| `STATO_COD_ISO` | string(3) | Codice ISO 3166-1 alpha-3 |
| `REGIONE_COD_ISTAT` | string(2) | Codice ISTAT regione |
| `PROVINCIA_COD_ISTAT` | string(3) | Codice ISTAT provincia |
| `PROVINCIA_SIGLA` | string(2) | Sigla automobilistica |
| `COMUNE_COD_ISTAT` | string(6) | Codice ISTAT comune |
| `COMUNE_COD_CATASTALE` | string(4) | Codice catastale |

**Benefici implementazione classificazioni:**
- ✅ Analisi territoriali immediate senza ambiguità
- ✅ Join con altri dataset pubblici (ISTAT, Ministero Salute, ecc.)
- ✅ Geocodifica automatica per mappe
- ✅ Aggregazioni territoriali corrette (es. per città metropolitana)
- ✅ Tracciabilità modifiche amministrative nel tempo
- ✅ Conformità linee guida Open Data (AGID)

**Lista controllata `LUOGO_SPECIF_FATTO`**

**ℹ️ ELENCO NON NORMATIVO** - La Legge 53/2022 richiede la rilevazione del luogo (Art. 5, comma 1; Art. 6, comma 1) ma non specifica modalità prestabilite. L'elenco seguente è quello attualmente utilizzato dal Dipartimento Analisi Criminale:

**⚠️ NOTA CRITICA**: Il 73% dei casi nel dataset è classificato come `NON_PREVISTO_ALTRO`, suggerendo la necessità di rivedere/ampliare le categorie.

- `ABITAZIONE`
- `PUBBLICA_VIA`
- `LOCALE_ESERCIZIO_PUBBLICO`
- `ISTITUTO_ISTRUZIONE`
- `ESERCIZIO_COMMERCIALE`
- `OSPEDALE`
- `UFFICIO_PUBBLICO`
- `ISTITUTO_CASA_CURA`
- `TRENO`
- `LUOGO_CULTO`
- `APERTA_CAMPAGNA_ZONA_BOSCHIVA`
- `INTERNET_CHAT`
- `ALTRO`
- `NON_NOTO`

### Informazioni autore/denunciato

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `COD_DENUNCIATO` | string | Sì | Codice anonimizzato denunciato | Identificativo univoco pseudonimizzato |
| `SESSO_DENUNCIATO` | string | Sì | Sesso denunciato | Lista controllata: `MASCHIO`, `FEMMINA`, `NON_NOTO` |
| `ETA_DENUNCIATO` | integer | No | Età denunciato al momento del fatto | Valore numerico |
| `NAZIONE_NASCITA_DENUNCIATO` | string | No | Nazione di nascita denunciato | Denominazione ufficiale ISO |

### Informazioni colpito da provvedimento

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `COD_COLP_DA_PROVV` | string | No | Codice anonimizzato colpito da provvedimento | Identificativo univoco pseudonimizzato |
| `SEX_COLP_PROVV` | string | No | Sesso colpito da provvedimento | Lista controllata: `MASCHIO`, `FEMMINA`, `NON_NOTO` |
| `ETA_COLP_PROVV` | integer | No | Età colpito da provvedimento | Valore numerico |
| `NAZIONE_NASCITA_COLP_PROVV` | string | No | Nazione nascita colpito da provvedimento | Denominazione ufficiale ISO |

### Informazioni vittima

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `COD_VITTIMA` | string | Sì | Codice anonimizzato vittima | Identificativo univoco pseudonimizzato |
| `SEX_VITTIMA` | string | Sì | Sesso vittima | Lista controllata: `MASCHIO`, `FEMMINA`, `NON_NOTO` |
| `ETA_VITTIMA` | integer | No | Età vittima al momento del fatto | Valore numerico |
| `NAZIONE_NASCITA_VITTIMA` | string | No | Nazione di nascita vittima | Denominazione ufficiale ISO |

### Relazione autore-vittima

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `RELAZIONE_AUTORE_VITTIMA` | string | Sì | Relazione tra autore e vittima | Lista controllata **FISSATA DALLA NORMA** (Legge 53/2022, Art. 2, comma 2, ultimo periodo) |

**Lista controllata `RELAZIONE_AUTORE_VITTIMA`**

**✅ ELENCO NORMATIVO OBBLIGATORIO** - Legge 53/2022, Art. 2, comma 2, ultimo periodo:

*"L'elenco del set minimo di modalità che devono essere previste nelle rilevazioni dell'ISTAT è il seguente: [...]"*

1. `CONIUGE_CONVIVENTE`
2. `FIDANZATO`
3. `EX_CONIUGE_EX_CONVIVENTE`
4. `EX_FIDANZATO`
5. `ALTRO_PARENTE`
6. `COLLEGA_DATORE_LAVORO`
7. `CONOSCENTE_AMICO`
8. `CLIENTE`
9. `VICINO_CASA`
10. `COMPAGNO_SCUOLA`
11. `INSEGNANTE_PERSONA_CURA_CUSTODIA`
12. `MEDICO_OPERATORE_SANITARIO`
13. `PERSONA_SCONOSCIUTA_VITTIMA`
14. `ALTRO`
15. `AUTORE_NON_IDENTIFICATO`

### Altri campi

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `DES_OBIET` | string | No | Descrizione oggetto (non chiaro di cosa si tratta) | Campo libero, semantica da chiarire con fonte dati |

## Campi nuovi proposti (v2.0)

### Tipologia di violenza (Art. 4, comma 2, lettera a)

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `TIPOLOGIA_VIOLENZA` | string | Sì | Tipologia di violenza esercitata | Lista controllata **FISSATA DALLA NORMA** (Legge 53/2022, Art. 4, comma 2, lettera a) - può essere multipla |

**Lista controllata `TIPOLOGIA_VIOLENZA`**

**✅ ELENCO NORMATIVO OBBLIGATORIO** - Legge 53/2022, Art. 4, comma 2, lettera a:

*"la tipologia di violenza, fisica, sessuale, psicologica o economica, esercitata sulla vittima"*

- `FISICA`
- `SESSUALE`
- `PSICOLOGICA`
- `ECONOMICA`

**Nota:** Se più tipologie sono presenti nello stesso evento, separare con punto e virgola (es. `FISICA;PSICOLOGICA`)

### Presenza figli e atti persecutori (Art. 4, comma 2, lettera b; Art. 5, comma 1)

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `PRESENZA_FIGLI_LUOGO_FATTO` | string | Sì | Presenza figli sul luogo del fatto | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `NUMERO_FIGLI_PRESENTI` | integer | No | Numero figli presenti (se applicabile) | Valore numerico, null se non applicabile |
| `PRESENZA_FIGLI_MINORI_RELAZIONE` | string | No | Presenza figli minori nella relazione | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `VIOLENZA_CON_ATTI_PERSECUTORI` | string | Sì | Violenza accompagnata da stalking | Lista controllata: `SI`, `NO` |

### Arma utilizzata (Art. 5, comma 1; Art. 6, comma 1)

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `TIPOLOGIA_ARMA` | string | Sì | Tipologia arma utilizzata | Lista controllata |

**Lista controllata `TIPOLOGIA_ARMA`:**

- `ARMA_FUOCO`
- `ARMA_BIANCA`
- `OGGETTO_CONTUNDENTE`
- `SOSTANZE_CHIMICHE_ACIDI`
- `NESSUNA_ARMA`
- `ALTRO`
- `NON_NOTO`

### Indicatori di rischio (Art. 4, comma 2, lettera c)

**⚠️ NOTA IMPORTANTE:** La Legge 53/2022, Art. 4, comma 2, lettera c, richiede "gli indicatori di rischio di revittimizzazione previsti dall'**Allegato B al decreto del Presidente del Consiglio dei ministri 24 novembre 2017**".

Gli indicatori seguenti sono **esempi comuni** usati per valutazione rischio violenza di genere. **L'elenco definitivo e obbligatorio deve essere verificato nell'Allegato B del DPCM 24/11/2017** (Linee guida nazionali assistenza donne vittime violenza).

**Campi proposti (da verificare con DPCM 2017, All. B):**

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `PRECEDENTI_EPISODI_STESSI_SOGGETTI` | string | No | Precedenti denunce/episodi tra stessi soggetti | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `ESCALATION_VIOLENZA` | string | No | Escalation della violenza documentata | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `MINACCE_MORTE` | string | No | Presenza minacce di morte | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `DISPONIBILITA_ARMI` | string | No | Disponibilità armi da parte autore | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `VIOLAZIONE_MISURE_PROTEZIONE` | string | No | Violazione precedenti misure | Lista controllata: `SI`, `NO`, `NON_APPLICABILE` |
| `DIPENDENZA_ECONOMICA_VITTIMA` | string | No | Dipendenza economica della vittima | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `ISOLAMENTO_SOCIALE_VITTIMA` | string | No | Isolamento sociale della vittima | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `LIVELLO_RISCHIO_COMPLESSIVO` | string | No | Valutazione rischio complessivo | Lista controllata: `BASSO`, `MEDIO`, `ALTO`, `NON_VALUTATO` |

**IMPORTANTE:** Consultare il DPCM 24/11/2017, Allegato B per l'elenco ufficiale completo e obbligatorio degli indicatori.

### Misure di protezione (Art. 5, comma 5)

**⚠️ NOTA:** I campi seguenti sono una **proposta di struttura**. In ogni caso, questi dati **devono essere rilevati** perché **obbligatori per legge** (Art. 5, comma 5): il sistema deve raccogliere "informazioni su denunce, misure di prevenzione applicate dal questore o dall'autorità giudiziaria, misure precautelari, misure cautelari, ordini di protezione e misure di sicurezza".

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `MISURA_APPLICATA` | string | No | Tipologia misura di protezione applicata | Lista controllata (può essere multipla) |
| `DATA_APPLICAZIONE_MISURA` | date | No | Data applicazione misura | Formato: YYYY-MM-DD |
| `AUTORITA_EMITTENTE_MISURA` | string | No | Autorità che ha emesso la misura | Lista controllata |
| `VIOLAZIONE_MISURA` | string | No | Violazione della misura | Lista controllata: `SI`, `NO`, `NON_APPLICABILE` |

**Lista controllata `MISURA_APPLICATA`:**

- `AMMONIMENTO_QUESTORE`
- `ALLONTANAMENTO_CASA_FAMILIARE`
- `DIVIETO_AVVICINAMENTO`
- `ORDINE_PROTEZIONE`
- `CUSTODIA_CAUTELARE`
- `ARRESTI_DOMICILIARI`
- `DIVIETO_DIMORA`
- `OBBLIGO_PRESENTAZIONE_PG`
- `ALTRA_MISURA`
- `NESSUNA_MISURA`

**Lista controllata `AUTORITA_EMITTENTE_MISURA`:**

- `QUESTORE`
- `GIP`
- `TRIBUNALE_CIVILE`
- `PROCURA_REPUBBLICA`
- `ALTRA_AUTORITA`

### Informazioni procedurali (Art. 5, comma 5)

**⚠️ NOTA:** I campi seguenti sono una **proposta di struttura**. In ogni caso, questi dati **devono essere rilevati** perché **obbligatori per legge** (Art. 5, comma 5): il sistema deve raccogliere informazioni sui "provvedimenti di archiviazione e le sentenze" in ogni grado del procedimento giudiziario.

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `STATO_PROCEDIMENTO` | string | No | Stato del procedimento penale | Lista controllata |
| `DATA_STATO_PROCEDIMENTO` | date | No | Data aggiornamento stato | Formato: YYYY-MM-DD |
| `ESITO_PROCEDIMENTO` | string | No | Esito finale (se concluso) | Lista controllata |

**Lista controllata `STATO_PROCEDIMENTO`:**

- `IN_CORSO`
- `ARCHIVIATO`
- `CONDANNA_PRIMO_GRADO`
- `CONDANNA_APPELLO`
- `CONDANNA_DEFINITIVA`
- `ASSOLUZIONE_PRIMO_GRADO`
- `ASSOLUZIONE_APPELLO`
- `ASSOLUZIONE_DEFINITIVA`
- `PATTEGGIAMENTO`

**Lista controllata `ESITO_PROCEDIMENTO`:**

- `CONDANNA`
- `ASSOLUZIONE`
- `ARCHIVIAZIONE`
- `PATTEGGIAMENTO`
- `PRESCRIZIONE`
- `ALTRO`
- `IN_CORSO`

### Recidiva autore (Art. 6, comma 2, lettera b)

**⚠️ NOTA:** I campi seguenti sono una **proposta di struttura**. In ogni caso, questi dati **devono essere rilevati** perché **obbligatori per legge** (Art. 6, comma 2, lettera b): il sistema deve rilevare "dati relativi a precedenti condanne a pene detentive e alla qualifica di recidivo" per indagati e imputati.

| Nome campo | Tipo | Obbligatorio | Descrizione | Note |
|------------|------|--------------|-------------|------|
| `PRECEDENTI_AUTORE_REATI_PERSONA` | string | No | Precedenti per reati contro la persona | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `PRECEDENTI_AUTORE_VIOLENZA_GENERE` | string | No | Precedenti per violenza di genere | Lista controllata: `SI`, `NO`, `NON_NOTO` |
| `AUTORE_RECIDIVO` | string | No | Qualifica di recidivo | Lista controllata: `SI`, `NO`, `NON_NOTO` |

## Note implementative

### Privacy e anonimizzazione

Tutti i codici identificativi (`COD_DENUNCIATO`, `COD_VITTIMA`, `COD_COLP_DA_PROVV`) devono essere:

- Pseudonimizzati con hash crittografico irreversibile
- Consistenti nel tempo per permettere analisi longitudinali
- Conformi al GDPR (Reg. UE 2016/679)

### Valori mancanti

- Campi obbligatori: non ammettono valori nulli
- Campi opzionali: usare `null` o campo vuoto (non stringhe come "N/A", "Non disponibile")
- Per liste controllate: usare valore specifico `NON_NOTO` quando applicabile

### Campi multipli

Per campi che possono avere valori multipli (`TIPOLOGIA_VIOLENZA`, `MISURA_APPLICATA`):

- Separare con punto e virgola (`;`)
- Esempio: `FISICA;PSICOLOGICA`
- Nessuno spazio prima/dopo il separatore

### Compatibilità retroattiva

Per mantenere compatibilità con dataset v1.0:

- Tutti i campi v1.0 restano invariati
- Campi v2.0 nuovi possono essere vuoti/null per dati storici
- Graduale popolamento retroattivo dove possibile mediante analisi testuale

### Allineamento ISTAT

Le liste controllate sono allineate con:

- Indagine ISTAT sulla sicurezza delle donne
- Classificazioni ISTAT territoriali
- Standard internazionali (dove applicabile)

## Riferimenti normativi

- Legge 21 aprile 2022, n. 53 - "Disposizioni in materia di statistiche in tema di violenza di genere"
- DPCM 24 novembre 2017 - Linee guida nazionali per assistenza donne vittime di violenza
- D.Lgs. 6 settembre 1989, n. 322 - Sistema statistico nazionale
- Regolamento UE 2016/679 (GDPR)

## Changelog

- **v2.0 (proposta 2025-11-16):** aggiunta campi conformità Legge 53/2022
- **v1.0 (attuale):** schema base Dipartimento Analisi Criminale
