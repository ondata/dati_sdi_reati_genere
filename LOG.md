# Log Attività Progetto Dati SDI Reati Genere

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