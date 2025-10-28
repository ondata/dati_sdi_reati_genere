# Template Metadati – Dataset Violenza di Genere SDI/DCPC

**Proposta**: Schema metadati da allegare a ogni distribuzione futura.

---

## METADATI GENERALI

| Campo | Valore |
|-------|--------|
| **Nome Dataset** | Violenza di genere – Dati SDI/DCPC 2019-2024 |
| **Data estrazione** | [GGGG-MM-DD] |
| **Data consolidamento** | [GGGG-MM-DD] |
| **Periodo copertura** | 2019-01-01 / 2024-12-31 |
| **Sistema di origine** | SDI v[X.X], SSD, DCPC |
| **Responsabile** | Dipartimento della Pubblica Sicurezza – Servizio Analisi Criminale |
| **Frequenza aggiornamento** | [Annuale / Semestrale / Su richiesta] |
| **Note sulla consolidazione** | Dati 2024 non consolidati. Previsione consolidamento: [data] |

---

## DESCRIZIONE FILE

### File: MI-123-U-A-SD-2025-90_5.xlsx

**Scopo**: Dati sui reati disaggregati per provincia, anno, tipologia.

| Foglio | Descrizione | Granularità | Fonte | Note |
|--------|-------------|------------|-------|------|
| Omicidi DCPC | Omicidi volontari consumati in Italia | Provincia + anno | DCPC | Dati operativi, aggiornati continuamente |
| Delitti – Commessi | Reati commessi (omicidi, lesioni, percosse, minacce, ecc.) | Provincia + anno + tipo reato | SDI/SSD | Non consolidati 2024 |
| Delitti – Vittime | Vittime di reato, sesso femminile | Provincia + anno + tipo reato | SDI/SSD | Sesso = FEMMINILE solo |
| Delitti – Segnalazioni | Segnalazioni presunti autori, dati demografici | Provincia + anno + tipo reato + fascia età + sesso | SDI/SSD | Autori segnalati |
| Reati spia – Commessi | Reati specifici (atti persecutori, maltrattamenti familiari) | Provincia + anno + tipo reato | SDI/SSD | Subset "reati spia" |
| Reati spia – Vittime | Vittime reati spia, sesso femminile | Provincia + anno + tipo reato | SDI/SSD | Sesso = FEMMINILE solo |
| Reati spia – Segnalazioni | Segnalazioni reati spia, dati demografici | Provincia + anno + tipo reato + fascia età + sesso | SDI/SSD | Autori segnalati |
| Codice Rosso – Commessi | Fattispecie Codice Rosso (art. 558bis, 583quinquies, 612ter, 387bis) | Provincia + anno + tipo reato | SDI/SSD | **Attenzione**: dal 9 agosto 2019, ritardo implementazione? |
| Codice Rosso – Vittime | Vittime Codice Rosso, sesso femminile | Provincia + anno + tipo reato | SDI/SSD | Sesso = FEMMINILE solo |
| Codice Rosso – Segnalazioni | Segnalazioni Codice Rosso, dati demografici | Provincia + anno + tipo reato + fascia età + sesso | SDI/SSD | Autori segnalati |

---

### File: MI-123-U-A-SD-2025-90_6.xlsx

**Scopo**: Comunicazioni SDI con indicazione della relazione vittima-autore, disaggregate fino a livello comunale.

| Colonna | Tipo | Descrizione | Note |
|---------|------|-------------|------|
| `data_inizio_fatto` | DATE | Data inizio del fatto | Es: 2020-03-15 |
| `data_fine_fatto` | DATE | Data fine del fatto | Es: 2020-03-20, NULL se istantaneo |
| `data_denuncia` | DATE | Data della denuncia | Es: 2020-03-25 |
| `anno_registrazione_sdi` | INTEGER | Anno registrazione in SDI | YYYY (es: 2020) |
| `comune_fatto` | STRING | Comune luogo del fatto | Es: "Milano" |
| `provincia_fatto` | STRING | Provincia luogo del fatto | Es: "MI" |
| `descrizione_reato` | STRING | Descrizione tipo reato | Es: "MALTRATTAMENTI CONTRO FAMILIARI" |
| `articolo_cp` | STRING | Articolo c.p. standardizzato | Es: "art. 572 c.p." [AGGIUNGERE SE MANCANTE] |
| `tentato_consumato` | STRING | Reato tentato o consumato | "Consumato" / "Tentato" |
| `vittima_sesso` | STRING | Sesso vittima | "FEMMINILE" / "MASCHILE" |
| `vittima_eta` | STRING | Età vittima | Es: "25-30", "0-13", NULL se sconosciuta |
| `vittima_nazionalita` | STRING | Nazionalità vittima | Es: "ITALIANA", "STRANIERA", NULL |
| `autore_sesso` | STRING | Sesso autore denunciato | "FEMMINILE" / "MASCHILE" |
| `autore_eta` | STRING | Età autore denunciato | Es: "35-40", NULL se sconosciuta |
| `autore_nazionalita` | STRING | Nazionalità autore denunciato | Es: "ITALIANA", "STRANIERA", NULL |
| `relazione_vittima_autore` | STRING | Tipo relazione (se compilata) | Es: "PARTNER", "EX-PARTNER", "FAMILIARE", "CONOSCENTE", NULL |

---

## MAPPING CODICI REATO – ARTICOLI CODICE PENALE

### Reati generali (file_5)

| Descrizione FOIA | Articolo C.P. | Introduzione |
|------------------|---------------|-------------|
| OMICIDI | art. 575-576 c.p. | Codice penale base |
| TENTATI OMICIDI | art. 575 + 56 c.p. | Codice penale base |
| LESIONI DOLOSE | art. 582-583 c.p. | Codice penale base |
| PERCOSSE | art. 581 c.p. | Codice penale base |
| MINACCE | art. 612 c.p. | Codice penale base |
| VIOLENZE SESSUALI | art. 609 c.p. | Codice penale base |

### Reati spia (file_5)

| Descrizione FOIA | Articolo C.P. | Introduzione |
|------------------|---------------|-------------|
| ATTI PERSECUTORI | art. 612 bis c.p. | L. 38/2009 (stalking) |
| MALTRATTAMENTI CONTRO FAMILIARI | art. 572 c.p. | Codice penale base |

### Codice Rosso (file_5, legge 19 luglio 2019 n. 69)

| Descrizione FOIA | Articolo C.P. | Note |
|------------------|---------------|------|
| COSTRIZIONE O INDUZIONE AL MATRIMONIO | art. 558 bis c.p. | Introdotto da L. 69/2019 (9 agosto 2019) |
| DEFORMAZIONE DELL'ASPETTO DELLA PERSONA MEDIANTE LESIONI PERMANENTI AL VISO | art. 583 quinquies c.p. | Introdotto da L. 69/2019 |
| DIFFUSIONE ILLECITA DI IMMAGINI O VIDEO SESSUALMENTE ESPLICITI | art. 612 ter c.p. | Introdotto da L. 69/2019 |
| VIOLAZIONE DEI PROVVEDIMENTI DI ALLONTANAMENTO DALLA CASA FAMILIARE E DEL DIVIETO DI AVVICINAMENTO AI LUOGHI FREQUENTATI DALLA PERSONA OFFESA | art. 387 bis c.p. | Introdotto da L. 69/2019 |

---

## SPIEGAZIONE CAMPI CHIAVE

### `valore` (righe aggregate)

Numero di **casi/reati/vittime** a seconda del foglio.

**Interpretazione per foglio**:
- **Delitti – Commessi**: n. reati commessi
- **Delitti – Vittime**: n. vittime (sesso femminile)
- **Delitti – Segnalazioni**: n. segnalazioni presunti autori
- **Codice Rosso – Commessi**: n. reati commessi

**Note**: 
- Se `valore = 0` → nessun caso registrato
- Se cella vuota/NULL → dato non disponibile vs dato 0 (specificare)

---

### `provincia` e campi geografici

Disponibili tre versioni della provincia:

| Campo | Descrizione | Standard | Esempio |
|-------|-------------|----------|---------|
| `provincia` | Nome provincia (originale dati forniti) | UPPERCASE | "MILANO" |
| `provincia_uts` | Nome provincia standardizzato ISTAT | UPPERCASE | "Milano" |
| `codice_provinciauts` | Codice provincia UTS (ISTAT 2018+) | Numerico | "015" |
| `codice_provincia_storico` | Codice provincia precedente | Numerico | "015" |
| `sigla_automobilistica` | Sigla automobilistica | UPPERCASE | "MI" |

**Quale usare?** 
- Per riconciliazione con ISTAT attuali: `codice_provinciauts` + `provincia_uts`
- Per compatibilità storica: `codice_provincia_storico`

---

### NULL geografici (0.5-0.7% sparsità)

**Causa**: [SPECIFICARE DAL MINISTERO]

Ipotesi:
- Reati commessi in estero (stato = non Italia)
- Dati incompleti dalla fonte SDI
- Impossibilità di georeferenziare il fatto

**Azione**: Escludere da analisi per provincia oppure indicare esplicitamente "estero" o "dato mancante".

---

## NOTE SU CONSOLIDAMENTO E AGGIORNAMENTI

### Dati 2019-2023

✅ **Consolidati** (stabili)

- Data consolidamento: [specificate dal Ministero]
- Previsione: nessun aggiornamento retroattivo atteso

### Dati 2024

⚠️ **Non consolidati** (soggetti a variazione)

- Data estrazione: [data]
- Previsione consolidamento: [data]
- Frequenza aggiornamenti: [se nota]
- Delta atteso: ±[X]% (se stimabile)

**Raccomandazione**: 
- Non utilizzare dati 2024 per serie storiche fino a consolidamento
- Contattare Ministero per chiarimenti se necessario per analisi attuali

---

## CHANGELOG VERSIONI SCHEMA SDI

| Data | Versione SDI | Cambiamenti rilevanti | Note |
|------|--------------|----------------------|------|
| 09/08/2019 | [X.X] | Introduzione art. 558 bis, 583 quinquies, 612 ter, 387 bis | Legge 69/2019 Codice Rosso |
| [data] | [X.X] | [Specificare] | [Se ci sono stati aggiornamenti] |

---

## CONTATTI PER SUPPORTO

| Ruolo | Email | Telefono |
|-------|-------|----------|
| Responsabile dataset | [email] | [tel] |
| Supporto tecnico | [email] | [tel] |
| Supporto legal/FOIA | [email] | [tel] |

---

## RIFERIMENTI NORMATIVI

- **Legge 19 luglio 2019, n. 69**: "Modifiche al codice penale, al codice di procedura penale e altre disposizioni in materia di tutela delle vittime di violenza domestica e di genere" (Codice Rosso)
- **Decreto Delibera Garante n. 515 del 19/12/2018**: Privacy – limitazioni disaggregazione comunale dati reati
- **Report ISTAT ottobre 2020**: "Violenza contro le donne – Un anno di Codice Rosso" (benchmark)

---

**Proposta**: Allegare questo documento (versione Excel compilata) a ogni distribuzione futura del dataset.
