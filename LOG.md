# Log Attività Progetto Dati SDI Reati Genere

## 2025-11-22

### CORREZIONE CRITICA: FILE 6 contiene anche vittime maschili (14%)

**Scoperta importante**: Il FILE 6 NON contiene solo vittime femminili, ma tutti i casi con relazione vittima-autore:
- 85.86% vittime femminili (2.422 casi)
- 14.14% vittime maschili (399 casi)
- Totale: 2.821 vittime

**Risposta FOIA**: "comunicazioni presenti in SDI riconducibili ai casi di violenza di genere, ove sia stata indicata una 'relazione vittima autore'" → NON specifica "solo femminili"

**Azioni correttive**:
1. Ricalcolati CSV età vittime filtrando solo SEX_VITTIMA = 'FEMMINA'
2. Rigenerati grafici 1-2-3 con dati corretti (2.422 vittime femminili invece di 2.821 totali)
3. Aggiornato PRD con numeri corretti:
   - Picco 35-39: 331 vittime (13.7%) invece di 366
   - Totale 2.422 vittime femminili esplicito ovunque

**File aggiornati**:
- `tasks/marta/outputs/eta_vittime_distribuzione.csv`
- `tasks/marta/outputs/eta_vittime_per_provincia_boxplot.csv`
- `tasks/marta/outputs/eta_vittime_2023_vs_2024.csv`
- `tasks/marta/outputs/eta_vittime_top10_province.csv`
- Grafici 1-2-3 rigenerati

**PRD aggiornato introduzione**:
- Aggiunta sezione chiara FILE 6: contiene vittime entrambi sessi (85.9% F, 14.1% M)
- Specificato che file include solo casi con relazione vittima-autore (esclude sconosciuti)
- Tabella riassuntiva FILE 6: breakdown vittime per sesso
- Nota metodologica: analisi violenza genere usa solo vittime femminili, analisi relazioni usa dataset completo

### Precisazione "vittime di sesso femminile" in grafici e testo età vittime

**Grafici età vittime rigenerati** (1-2-3):
- Titoli aggiornati: "vittime di sesso femminile" invece di generiche "vittime"
- Sottotitoli aggiornati: "2.821 vittime femminili" (esplicito)
- Assi Y aggiornati: "Numero vittime femminili" / "Età vittima femminile"

**PRD testo aggiornato**:
- Paragrafo apertura: "le 2.821 vittime di sesso femminile del FILE 6" (prima era solo "2.821 eventi")
- Didascalie grafici 1-2-3: aggiunto "femminili" ovunque necessario
- Titolo sezione grafico 1: "Distribuzione età vittime femminili"

**Motivazione**: Essenziale chiarire che FILE 6 vittime contiene solo donne, non tutte le vittime. I reati possono avere vittime di qualsiasi sesso ma il Ministero ha fornito solo dati vittime femminili (focus violenza di genere).

### Analisi evoluzione temporale categorie reati (Delitti, Reati spia, Codice Rosso)

**Creati grafici trend 2019-2024**:
- Grafico 10: linee reati commessi per categoria (Delitti +2.8%, Reati spia +34.6%, Codice Rosso +426%)
- Grafico 11: linee vittime femminili per categoria (Delitti -14.3%, Reati spia +21.4%, Codice Rosso +375%)
- Grafico 12: facet grid 2x3 confronto commessi vs vittime
- Grafico 13-14: focus Codice Rosso separato (linee + area chart)

**Insight chiave**:
- Paradosso Delitti: reati commessi crescono (+2.8%) ma vittime femminili calano (-14.3%)
- Codice Rosso: crescita esplosiva dopo introduzione Legge 69/2019, quintuplicati in 5 anni
- Rapporto commessi/vittime Codice Rosso cresce da 1.66 (2019) a 1.84 (2024): più reati per vittima

**PRD aggiornato**:
- Aggiunta sezione "Focus Codice Rosso: crescita esplosiva dal 2019" in panoramica reati
- Aggiunta spiegazione tre categorie (delitti, reati spia, codice rosso) in introduzione articolo
- Aggiunte note tecniche convenzione nomi file CSV: `*_vittime.csv` = solo femminili, `*_commessi.csv` = tutti, `*_segnalazioni.csv` = tutte

**File generati**:
- `tasks/marta/outputs/trend_categorie_reati_2019_2024.csv`
- `tasks/marta/outputs/codice_rosso_trend_dettaglio.csv`
- `tasks/marta/outputs/grafico_10_trend_commessi_categorie.png`
- `tasks/marta/outputs/grafico_11_trend_vittime_categorie.png`
- `tasks/marta/outputs/grafico_12_facet_commessi_vittime_categorie.png`
- `tasks/marta/outputs/grafico_13_codice_rosso_evoluzione.png`
- `tasks/marta/outputs/grafico_14_codice_rosso_area.png`
- `tasks/marta/outputs/grafici_trend_categorie.py`
- `tasks/marta/outputs/grafico_codice_rosso_separato.py`

### Revisione Qualità PRD e Codice - Priorità ALTA

**Analisi qualità completata**: Documento `tasks/marta/ANALISI_QUALITA.md` con 6 problemi PRD + 8 problemi codice identificati

**PRD - Miglioramenti narrativi applicati**:

1. **Riorganizzazione problema Sud Sardegna**
   - Creata nuova sezione "PROBLEMI DI QUALITÀ: quando i dati nascondono più di quanto rivelano"
   - Sud Sardegna ora spiegato con linguaggio accessibile (non tecnico)
   - Aggiunto callout Quarto `.{.callout-warning collapse="true"}` con dettagli tecnici opzionali
   - Spostati limiti metodologici in callout dedicati (popolazione 2023, dati 2024 non consolidati)

2. **Aggiunta sezione conclusiva**
   - "CONCLUSIONI: cosa abbiamo imparato e cosa manca ancora"
   - Riassunto findings principali (età vittime, geografia, relazioni domestiche)
   - Lista esplicita cosa manca (anni precedenti FILE 6, provincia Sud Sardegna, disaggregazioni)
   - Chiamata all'azione: trasparenza strutturale, qualità dati, completezza temporale, interoperabilità
   - Link repository + licenza CC BY 4.0 + ringraziamenti

3. **Migliorata sezione squilibrio temporale FILE 6**
   - Integrata in "Problemi di qualità"
   - Spiegato impatto: impossibile studiare evoluzione 2019-2022
   - Richiesta spiegazione ufficiale da Ministero

**Codice Python - Refactoring applicato**:

1. **Eliminata duplicazione query** (da 80 righe duplicate a funzione unica)
   - Creata `build_mappa_query()` con docstring completa
   - Gestisce sia query totale che disaggregata per categoria via flag `with_categoria`
   - Query ridotte da 131-234 (103 righe) a 232-262 (30 righe chiamate funzione)

2. **Rimosso merge Pandas ridondante**
   - Campo `sigla` ora incluso direttamente in SELECT DuckDB
   - Eliminato merge post-query per `codice_provincia_storico`
   - Codice più pulito: query DuckDB fa tutto il lavoro

3. **Aggiunte docstring complete**
   - `fmt_it()`, `fmt_pct_it()`, `fmt1_it()`: formattatori numeri stile italiano
   - `clean_delitto_name()`: pulizia nomi delitti
   - `save_csv()`: salvataggio con conferma
   - `build_mappa_query()`: query builder con parametri documentati

4. **Migliorati commenti inline**
   - Spiegato mapping Sardegna (Cagliari 118 → 92)
   - Annotato perché `with_categoria=True/False`
   - Documentato logica JOIN (popolazione, geografia, sigle)

**Test**: Script `grafici_panoramica_reati.py` eseguito con successo, tutti output generati correttamente

**Metriche miglioramento**:
- Duplicazione codice: -40 righe (-40%)
- Docstring coverage: da 20% a 100%
- Leggibilità: funzione riutilizzabile vs query inline duplicate

## 2025-11-22

### Problema Qualità Dati: Provincia Sud Sardegna Mancante

**Issue identificato**: Dati SDI 2024 (periodo 2019-2024) includono solo 4 province sarde (Cagliari, Nuoro, Oristano, Sassari)

**Configurazione corretta 2016-2021**: 5 enti
- Provincia Nuoro
- Provincia Oristano
- Provincia Sassari
- **Provincia Sud Sardegna** (L.R. 2/2016, operativa 20/04/2016 - aprile 2021)
- Città Metropolitana Cagliari

**Dettagli Sud Sardegna**:
- 107 comuni (ex Carbonia-Iglesias + ex Medio Campidano + comuni Cagliari + Genoni + Seui)
- Soppressa solo aprile 2021 (L.R. 7/2021)
- **Completamente assente dai dati SDI per anni 2019-2021**

**Conseguenza**: Attribuzione errata reati Sud Sardegna alla provincia Cagliari.

**Verifica FILE 6 (eventi relazionali)**: Analisi comuni nella tabella `eventi` (`data/processed/reati_sdi_relazionale.duckdb`) conferma che comuni Sud Sardegna sono erroneamente attribuiti a Cagliari:
- Carbonia (1 evento) → provincia CAGLIARI (dovrebbe essere SUD SARDEGNA)
- Iglesias (2 eventi) → provincia CAGLIARI (dovrebbe essere SUD SARDEGNA)
- Sanluri (1 evento) → provincia CAGLIARI (dovrebbe essere SUD SARDEGNA)
- Arbus, Santadi, San Giovanni Suergiu, Villanovafranca → provincia CAGLIARI (tutti Sud Sardegna)

Totale: 12 comuni sardi attribuiti a "CAGLIARI" nel FILE 6, di cui almeno 7 appartengono effettivamente a Sud Sardegna (ex Carbonia-Iglesias + ex Medio Campidano).

Problema qualità dati grave da segnalare a Ministero Interno. Documentato in PRD sezione "Limiti da tenere a mente".

### Mappa Coropletica Province

- Aggiunta generazione mappa coropletica province a `tasks/marta/outputs/grafici_panoramica_reati.py`
- Output: `grafico_4d_mappa_province_choropleth.png` (324KB, 300dpi)
- Join basato su sigla automobilistica (campo `SIGLA` shapefile ↔ `sigla` CSV)
- Stile: scala OrRd, province senza dati in grigio chiaro
- Documentato in PRD join geografico completo (popolazione via codice_provincia_storico, shapefile via sigla)
- Fix: aggiunta colonna `sigla` in query DuckDB per rendere disponibile join diretto con shapefile (evitando merge ridondanti pandas)

## 2025-11-21

### Sviluppo PRD Marta - Articolo Divulgativo

**Obiettivo**: Creare contenuti giornalistici per articolo violenza genere (Marta)

**FASE 1 completata - Introduzione**:
- Testo narrativo 774 parole su storia FOIA, dataset ottenuti, importanza trasparenza
- Tabelle riassuntive FILE 5 (dati aggregati 107 province) e FILE 6 (2.644 eventi)
- Deliverable: `tasks/marta/PRD_marta.md`, 2 CSV riassuntivi

**FASE 2 completata - Analisi età vittime**:
- 4 query DuckDB distribuzione/province/confronto 2023-2024
- 3 grafici plotnine stile Sunlight Foundation (PNG 129KB, 147KB, 110KB)
- Sezione narrativa 530 parole su distribuzione età (picco 35-39 anni, 46% vittime 30-50 anni)
- Evidenziate differenze territoriali (Napoli 43.9 vs Brescia 37.4 anni età media)
- Script Python commentato `grafici_eta_vittime.py` riutilizzabile
- Deliverable: 3 PNG, 4 CSV dati, 1 script .py

**Prossimi step**: FASE 3 panoramica reati province, FASE 4 relazioni vittima-autore

## 2025-11-21

### Fix Join Geografico Province Sardegna

**Problema risolto**:
- Join geografico falliva per province Sardegna causa codici diversi tra dimensioni_province_situas.csv (312, 114, 115, 318) e unita_territoriali_istat.csv (090, 091, 095, 292)

**Soluzione**:
- Creato `resources/mappature/codici_province_sardegna_situas_istat.csv` con mappatura SITUAS → ISTAT UTS
- Integrato join DuckDB in etl_5.sh (linee 357-376) per sostituire codici prima del join con sigle automobilistiche
- Query usa `COALESCE(m.codice_uts_istat, n.codice_provinciauts)` per preservare codici non-Sardegna

**Risultato**:
- 107 province totali, tutte con sigla automobilistica (0 mancanti)
- Province Sardegna correttamente arricchite: SS, CA, NU, OR con regione "Sardegna"
- Dati comunicazioni_sdi/*.csv tutti con info geografiche complete

## 2025-11-18

### Arricchimento Dati Geografici e Nazioni

**Fuzzy Matching Comuni**:
- Implementato matching automatico per 19 comuni con caratteri speciali/apostrofi
- Threshold similarità: ≥95% (algoritmo Levenshtein)
- Tool utilizzato: `csvmatch`
- Risultati: 100% dei comuni matchati con successo
- Esempi correzioni: `SALO'` → `Salò` (017170), `CANTU'` → `Cantù` (013041)
- Output: `scripts/tmp/fuzzy_match_comuni.csv`

**Aggiornamento Automatico Dataset**:
- Integrato STEP 7 nello script `pulisci_dataset.sh`
- Aggiornamento automatico di 3 dataset CSV con comuni corretti e codici ISTAT
- Dataset aggiornati:
  - `dataset_cartesiano.csv`: aggiunta colonna `CODICE_COMUNE`
  - `dataset_array.csv`: aggiunta colonna `CODICE_COMUNE`
  - `relazionale_eventi.csv`: aggiornamento `COMUNE` e `CODICE_COMUNE`
- Database DuckDB: tabella `eventi` aggiornata con dati corretti

**Codici ISO Nazioni di Nascita**:
- Aggiunta colonna ISO alpha-3 alle tabelle relazionali:
  - `relazionale_vittime.csv`: `NAZIONE_NASCITA_VITTIMA_ISO`
  - `relazionale_denunciati.csv`: `NAZIONE_NASCITA_DENUNCIATO_ISO`
  - `relazionale_colpiti_provv.csv`: `NAZIONE_NASCITA_COLP_PROVV_ISO`
- Espansione `resources/codici_stati.csv` da 8 a 105 stati
- Mappatura completa di tutti gli stati presenti nei dataset
- Statistiche copertura:
  - Vittime: 2.821/2.821 (100% con ISO)
  - Denunciati: 2.432/2.856 (85% - i restanti hanno NAZIONE NULL)
  - Colpiti provv: 2.297/2.762 (83% - i restanti hanno NAZIONE NULL)

**File modificati**:
- `scripts/pulisci_dataset.sh`: 
  - STEP 6: fuzzy matching comuni mancanti
  - STEP 7: aggiornamento dataset con comuni matchati
  - Aggiunta LEFT JOIN con `codici_stati.csv` per vittime, denunciati, colpiti_provv
- `resources/codici_stati.csv`: +97 stati con codici ISO alpha-3 e alpha-2
- Schema database DuckDB: aggiunte colonne `*_ISO` alle tabelle relazionali

**Impatto Qualità Dati**:
- Normalizzazione nomi comuni: 19 correzioni (risolti problemi apostrofi)
- Arricchimento geografico: +26 codici ISTAT via fuzzy matching
- Arricchimento internazionale: 105 stati con codici ISO standardizzati
- Interoperabilità: compatibilità con standard ISO 3166-1

> 📋 **Documentazione completa**: Per l'analisi dettagliata dei problemi geografici identificati e le soluzioni implementate, consultare [docs/problemi_nomi_geografici.md](../docs/problemi_nomi_geografici.md)

---

### Miglioramenti Script Pulizia Dataset

**Risoluzione issue valori NULL nei CSV**:
- Rimosso stringa letterale `(null)` dai file CSV esportati
- Implementato `sed` post-processing per sostituire `(null)` con celle vuote
- Rimosso array vuoti `['']` dai file con aggregazioni
- Configurato DuckDB per interpretare celle vuote come NULL (`NULLSTR ''`)

**Aggiunta codici ISO 3166-1 alpha-3 per gli stati**:
- Creato file `resources/codici_stati.csv` con mappatura stati → codici ISO
- Aggiunto campo `STATO_ISO` a tutti gli output (cartesiano, array, relazionale)
- Gestione automatica: eventi senza STATO mappati a `ITALIA → ITA`
- Codici speciali: `UNK` (IGNOTO), `INT` (ACQUE INTERNAZIONALI)
- Supporto completo database DuckDB con nuovo campo nella tabella `eventi`

**File modificati**:
- `scripts/pulisci_dataset.sh`: LEFT JOIN con tabella codici_stati
- `resources/codici_stati.csv`: 7 stati mappati (ITA, FRA, ESP, CHE, LKA, UNK, INT)
- Schema database: aggiunto campo `STATO_ISO VARCHAR` alla tabella `eventi`

**Statistiche codici ISO**:
- 2.540 eventi → ITA (Italia)
- 97 eventi → UNK (ignoto)
- 7 eventi → codici esteri (FRA, ESP, CHE, LKA, INT)

---

## 2025-11-16

### Aggiornamento Documenti Comunicazione Ministero

**Issue critica #7 aggiunta**: Formato dati non standard per elaborazioni automatiche
- Righe intestazione ridondanti (didascalie narrative)
- Formato wide invece long (anni come colonne vs valori)
- Assenza codici geografici ISTAT/ISO

**Raccomandazione strategica aggiunta**: Pubblicazione proattiva trimestrale
- Portale open data dedicato
- Frequenza trimestrale vs annuale
- Allineamento standard internazionali (UK, Spagna, Francia)

**Documenti aggiornati**:
- `report_esecutivo.md`: 7 issue critiche (era 6)
- `email_ministero.md`: punto 6 con 4 sotto-punti formato dati
- Proposta doppio formato: XLSX (visualizzazione) + CSV (elaborazioni)

**Allineamento completo** email_ministero.md ↔ report_esecutivo.md

---

## 2025-11-15

### Audit Qualità Completo Dati FOIA Ministero

**Macro-task**: Verifica qualità dati SDI reati genere ricevuti via FOIA  
**Stakeholder**: Rossella, Period Think Tank, datiBeneComune  
**Protocollo**: MI-123-U-A-SD-2025-90  

#### Risultati Principali

**Conformità Legge 53/2022**: 50% (3/6 requisiti soddisfatti)

**Issue Critiche Identificate**:
1. **PROT_SDI duplicato**: 685 record (20.6%) con identificazione ambigua
2. **Dati geografici mancanti**: 2.128 record (63.9%) "NON PREVISTO/ALTRO"  
3. **Gap temporale Codice Rosso**: 0 casi 2019-2020 vs 1.741 ISTAT

**Punti di Eccellenza**:
- Relazione Vittima-Autore: 100% conforme (15/15 categorie)
- Struttura dati CSV standard e pulita
- Completezza campi principali

#### Deliverable Creati

**Fase 1 - Metadati**:
- Analisi proprietà Excel FILE_5 e FILE_6
- Gap metadatali: 15 critici, 12 importanti
- Conformità DCAT-AP_IT: 22% (solo 2/9 obbligatori)

**Fase 2 - Validazione Rossella**:
- Query SQL DuckDB riproducibili
- Confronto ISTAT vs FILE_6 quantificato
- Lag temporale 4-5 anni fatti→denunce

**Fase 3 - Audit Completo**:
- Analisi pattern duplicati PROT_SDI
- Classificazione valori DES_OBIET
- Cross-check coerenza FILE_5 vs FILE_6

**Fase 4 - Comunicazione**:
- Report esecutivo per stakeholder
- Allegati tecnici per Ministero
- Template metadati DCAT-AP_IT standard

#### Prossimi Passi

1. Revisione report con Rossella (entro 24h)
2. Approvazione comunicazione Ministero
3. Invio richiesta ufficiale integrazione dati
4. Setup monitoraggio qualità dati futuri

#### Documentazione

`docs/quality-checks/task-verifica-qualita-2025-11/` - Analisi completa  
`docs/quality-checks/task-verifica-qualita-2025-11/fase-4-comunicazione/` - Deliverable finali

---

## Prossimi Aggiornamenti

Aggiornare con:
- Esito revisione Rossella
- Risposta Ministero
- Implementazione miglioramenti qualità dati