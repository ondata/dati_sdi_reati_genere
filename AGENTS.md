<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Repository Guidelines

## Project Structure & Module Organization

Le fonti Excel ottenute via FOIA restano in `data/rawdata/`, sempre immutate. Gli output normalizzati sono suddivisi per tema in `data/processing/` (es. `comunicazioni_sdi/`, `reati_sdi/`, `rapporto_commessi_vittime_femminili/`). Gli script ETL e di supporto sono in `scripts/` e sfruttano le tabelle di riconciliazione in `resources/`. Documentazione operativa aggiuntiva va in `docs/` o nella radice del repo accanto a `README.md`.

## Build, Test, and Development Commands

- `bash scripts/etl_6.sh` – elabora `MI-123-U-A-SD-2025-90_6.xlsx`, pulendo anagrafiche, aggiungendo codici ISTAT e popolando `data/processing/reati_sdi/`.
- `bash scripts/etl_5.sh` – pipeline per i dieci fogli del file `..._90_5.xlsx`, produce i CSV tematici in `data/processing/comunicazioni_sdi/`.
- `python scripts/find_unique_combinations.py` – verifica con Polars la chiave minima per `reati_sdi.csv` (richiede `pip install polars`).
Prima di eseguire gli script, assicurati di avere `jq`, `qsv`, `mlr`, `duckdb` e `csvmatch` nel PATH.

## Coding Style & Naming Conventions

Negli script Bash mantieni `set -euo pipefail`, indentazione a due spazi e nomi snake_case. I CSV prodotti devono avere intestazioni lowercase coerenti con la denominazione istituzionale; usa nomi file descrittivi in italiano (`problemi_nomi_province.jsonl`). Per Python adotta Polars come libreria primaria e formatta con `black scripts/*.py`.

## Testing Guidelines

Esegui gli ETL in modalità verbosa e leggi gli avvisi stampati. Valida i CSV con `qsv stats <file>` confrontando righe/colonne attese dai fogli sorgente. Per controlli puntuali usa DuckDB, ad esempio `duckdb "SELECT COUNT(*) FROM 'data/processing/reati_sdi/reati_sdi.csv'"`, e allega le query in `docs/` quando aggiungi trasformazioni.

## Commit & Pull Request Guidelines

I commit esistenti sono sintetici, in italiano, con verbo d’azione e riferimenti a issue (`close #30`). Mantieni i cambi separati (ETL, analisi, documentazione) ed evita commit generici. Le pull request devono riassumere l’impatto, elencare eventuali nuove dipendenze CLI e includere screenshot o snippet quando cambiano i report.

## Security & Configuration Tips

Non distribuire i file Excel originali: conservali in `data/rawdata/` con permessi limitati e cita la provenienza nelle note. Gestisci eventuali credenziali via variabili d’ambiente o `.env` ignorati e documenta aggiornamenti alle mappe di `resources/` con fonte e data.
