## 1. Preparation

- [x] 1.1 Create `data/rawdata/2026/`, `data/output/2026/{microdati_2025,aggregati_2024_2025,serie_2019_2025}/`, `scripts/2026/`, `docs/2026/` → verify: folders exist, no existing path modified (`git status` shows only additions)
- [x] 1.2 Copy the 2024-2025 aggregate xlsx and the extraction query into `data/rawdata/2026/` → verify: sha1 equal to the originals in `ondata/attivita`

## 2. Scripts

- [x] 2.1 Copy `semestri.sh`, `aggregati.sh`, `serie_provinciale.sh` into `scripts/2026/` and make input/output paths configurable (raw semester dir and code table via environment variables) → verify: each script runs from any working directory
- [x] 2.2 Point `serie_provinciale.sh` to `data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx` for the 2019-2024 release → verify: `province_2019_2025.csv` identical to the one in `ondata/attivita`
- [x] 2.3 Add territorial columns (`codice_provincia_storico`, `codice_regione`, `regione`, `ripartizione_geografica`) to the series → verify: no null codes except `NON LOCALIZZATA`, values equal to `comunicazioni_sdi/` for the same province
- [x] 2.4 Write `scripts/2026/verifica_identificativi.sh` and call it at the end of the pipelines → verify: exits 0 on the outputs, exits non-zero on a test file containing `2000-01-01-00.00.00.000000`

## 3. Outputs

- [x] 3.1 Generate all outputs into `data/output/2026/` → verify: row counts (2025.csv 29.676; aggregati 31.750; serie 127.780), two consecutive runs give identical files
- [x] 3.2 Copy legends (`legenda_reati.csv`, `legenda_codici.csv`, `province_istat.csv`, `province_alias.csv`, `reati_alias.csv`) → verify: pipelines stop if a code has no description
- [x] 3.3 Confirm that no raw semester xlsx and no `codici_vittima.csv` is in the working tree → verify: `git ls-files | grep -Ei "semestre|codici_vittima"` returns nothing

## 4. Documentation

- [x] 4.1 Copy `note.md` into `docs/2026/`, fixing relative links and removing references to private paths and real identifiers → verify: all relative links resolve, no SDI code pattern in the file
- [x] 4.2 Update `README.md`: title 2019-2025, timeline of both releases, 2026 contents, recommended series, why the raw semester files are not published → verify: existing raw links unchanged and working
- [x] 4.3 Lowercase all 2026 output headers → verify: `head -1` of every CSV under `data/output/2026/` has no uppercase letter
- [x] 4.4 Update `LOG.md` → verify: entry dated with the publication day
