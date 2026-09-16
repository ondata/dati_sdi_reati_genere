## Context

The 2026 release was processed in `ondata/attivita` (private), folder `tasks/foia-violenza-genere-2026/9-pubblicazione/`: three pipelines (`semestri.sh`, `aggregati.sh`, `serie_provinciale.sh`), outputs in `dati/processed/`, code tables in `dati/legende/`, full documentation of data problems in `note.md`, a comparison with ISTAT and the publication narrative in `racconto/`.

This repository is public, CC-BY 4.0, and its 2019-2024 outputs are linked from outside (README raw links, Period Think Tank analysis platform).

Two facts constrain the design:

- `ID_VITTIMA` in the 2026 semester files is the SDI person code (`d.c_per_fis`). The same value, without separators, is `COD_VITTIMA` in `data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx`, already public, which also has the municipality. Matching the two gives 93 common victims and the municipality for 83 of them. The pipeline replaces the code with a meaningless one (`V00001`...); the correspondence table (`codici_vittima.csv`) exists only in the private repository.
- The province codes used here (`codice_provinciauts`, e.g. Torino 201, Roma 258, Cagliari 292) are the same UTS codes produced by the 2026 pipeline from SITUAS report 64 at 31/12/2025.

## Goals / Non-Goals

- Goals: publish the 2026 release next to the 2025 one; make the 2019-2025 series the recommended provincial dataset; keep scripts reproducible from published inputs where possible; guarantee that no SDI person code is published for the 2026 release.
- Non-Goals: modifying or re-processing the first release outputs; publishing the raw semester files; publishing the victim code correspondence table.

## Decisions

- Decision: add, never move. New material goes under `2026/` subfolders; existing paths stay as they are. Alternative considered: restructure by release (`data/rawdata/2025/`, `data/rawdata/2026/`). Rejected because it breaks external links.
- Decision: raw inputs of the microdata are not distributed. `scripts/2026/semestri.sh` reads its input directory and the code correspondence table from environment variables, and documents that the raw semester files are not public. `aggregati.sh` and `serie_provinciale.sh` run on published inputs (the 2024-2025 aggregate xlsx is published in `data/rawdata/2026/`; the 2019-2024 one is already in `data/rawdata/`).
- Decision: the 2019-2025 series (`province_2019_2025.csv`) is the recommended provincial dataset. The 2019-2024 CSVs in `comunicazioni_sdi/` stay as the record of the first release; the README says which one to use. The series keeps the value of the most recent release for 2024; differences go to `revisioni_2024.csv`.
- Decision: territorial columns aligned with the first release. The series gains `codice_provincia_storico`, `codice_regione`, `regione`, `ripartizione_geografica` from SITUAS report 64, next to `cod_provincia_istat`, `provincia_istat` and `perimetro_confrontabile` (false for the four Sardinian provinces, which follow the pre-2006 layout; see also `resources/problemi_province_sardegna.jsonl`).
- Decision: automated identifier check. A script scans `data/output/2026/` and `data/rawdata/2026/` for the SDI person code patterns (`YYYY-MM-DD-HH.MM.SS.ffffff` and the 20-digit form) and exits non-zero on any match. It runs at the end of the 2026 pipeline and can run in CI.

## Risks / Trade-offs

- Row-level 2025 microdata remain re-identifiable by similarity with the public 2025 file (age, country of birth, sex, dates) even without the code → documented in `docs/2026/note.md`; the decision to publish at row level was taken knowingly.
- `semestri.sh` is not fully reproducible by third parties → stated in the script header and in the README.
- Column names: all 2026 output headers are lowercase, following `openspec/project.md` (decided 16/09/2026). The mapping to the Ministry's uppercase names is documented in `docs/2026/note.md`.

## Migration Plan

Additive only. Rollback: remove the `2026/` folders and revert `README.md`.

## Resolved Questions

- Column headers: lowercase for every 2026 output (decided 16/09/2026).
- Publication narrative: not published for now; `docs/2026/` contains only the data documentation (decided 16/09/2026).
