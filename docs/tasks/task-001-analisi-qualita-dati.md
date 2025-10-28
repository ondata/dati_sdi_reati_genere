# task-001-analisi-qualita-dati

Status: in-progress | Priorità: high

## Descrizione

Mappare completezza, coerenza e anomalie nei dataset SDI/DCPC per fondare successive analisi su dati affidabili.

**Background critico**: Note di Rossella + report ISTAT "Codice Rosso 2020" rivelano discrepanze significative tra dati FOIA e report ufficiale (ago 2019 – ago 2020). Concentrazione anomala di dati in 2023-24 vs 2019-2022.

| Reato | ISTAT 2020 | FOIA (ago19-ago20) | Delta |
|-------|-----------|-------------------|-------|
| Art. 558 bis | 11 | 0 | ⚠️ -11 |
| Art. 583 quinquies | 56 | 1 | ⚠️ -55 |
| Art. 387 bis | 1.741 | 0 | ⚠️ -1.741 |

## Sottoattività

### Fase 1: Mappatura strutturale
- [ ] Verificare completezza: righe vs attese dai fogli Excel sorgente
- [ ] Validare integrità header (coerenza snake_case, assenza duplicati)
- [ ] Controllare tipo dati per colonna (anno numerico, codici provincia, valori conteggi)
- [ ] Identificare valori NULL/missing per colonna (qsv stats)

### Fase 2: Coerenza geografica
- [ ] Validare codici ISTAT provincia vs risorse mapping (province_sdi_istat.csv)
- [ ] Verificare ripartizione geografica coerente con regione
- [ ] Controllare Sardegna: problemi noti in problemi_province_sardegna.jsonl

### Fase 3: Coerenza temporale
- [ ] Validare anni 2019-2024 presenti
- [ ] Controllare dati 2024 non consolidati (segnalare variabilità potenziale)
- [ ] Verificare assenza di duplicati anno+provincia+delitto

### Fase 2.5 (NUOVA): Validazione temporale Codice Rosso
- [ ] Analizzare distribuzione anomala art. 387 bis (5→5→3→13→530→4.277)
- [ ] Estrarre data_denuncia da file_6.xlsx (comunicazioni SDI)
- [ ] Verificare se denunce 2019-2020 sono retroattivamente etichettate con anno posteriore
- [ ] Query DuckDB: JOIN timeline_fatto vs timeline_denuncia per art. 387 bis
- [ ] Localizzare 8 casi art. 558 bis in 2024 (quali province?)
- [ ] Confronto volume art. 387 bis: file_6.xlsx vs file_5.xlsx per periodo ago19-ago20

### Fase 4: Logica del dato
- [ ] Cross-check: commessi vs vittime vs segnalazioni (relazioni attese?)
- [ ] Validare segnalazioni >= vittime >= commessi (tendenzialmente)
- [ ] Controllare disaggregazioni per sesso (vittime femminili ragionevoli?)

### Fase 5: Profiling file_6.xlsx
- [ ] Verificare completezza campi: vittima (eta, genere, nazionalità), denunciato, relazione
- [ ] Validare disaggregazione comunale (vs provinciale in file_5)
- [ ] Controllare date: inizio/fine fatto vs denuncia (coerenza temporale)

## Deliverable

- DuckDB query results: `docs/quality-checks/analisi_temporale_codice_rosso.csv`
- Report markdown: `docs/quality-checks/findings_rossella_validazione.md`
- Update `resources/problemi_*.jsonl` se pattern ricorrente
- Timeline analysis: grafico distribuzione per anno+fattispecie

## Note

- Appoggiamento su CLI native: qsv stats, duckdb per query, rg per ricerche
- Questione core: è data quality o lag di consolidamento ministeriale?
- Questo task prepara terreno per task successivi (ETL robustezza, analisi fenomeno)

## Domande irrisolte

1. File Excel è draft o versione ufficiale dal Ministero?
2. SDI ha subito migrazione 2020-2023? Quali versioni di schema?
3. Qual è la semantica di "non consolidato"? Quali righe varieranno?
4. File_6 ha date granulari che potrebbero spiegare il lag temporale?
