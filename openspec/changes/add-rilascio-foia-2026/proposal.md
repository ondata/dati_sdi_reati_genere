# Change: Add the 2026 FOIA release (2025 microdata, 2024-2025 aggregates, 2019-2025 series)

## Why

The Ministry of the Interior answered a second FOIA request on 15/05/2026 (prot. MI-123-U-C-3-2-2026-88), with two new kinds of data: 2025 microdata per victim-perpetrator pair and provincial aggregates 2024-2025. The repository currently documents only the first release (2019-2024). The new release was cleaned and documented in the private `ondata/attivita` repository and must now be published here, next to the first one, without breaking existing links and without exposing the SDI person identifiers.

## What Changes

- Add the second release under dedicated `2026/` paths: raw aggregate file, cleaned outputs, scripts, documentation.
- Publish three output groups: 2025 microdata (`2025.csv` with code descriptions), 2024-2025 aggregates (provincial long format + national homicides), 2019-2025 provincial series merging both releases (with the 2024 revisions file and the national homicides series).
- Keep every existing file and path of the first release unchanged (`data/rawdata/*.xlsx`, `data/output/comunicazioni_sdi/`, `data/output/reati_sdi/`).
- Do not publish the raw 2025 semester xlsx files: they contain the original `ID_VITTIMA`, the same SDI code published in `MI-123-U-A-SD-2025-90_6.xlsx` together with the municipality.
- Add an automated check that fails if any file under the 2026 paths contains an SDI person identifier.
- Update `README.md` (title 2019-2025, timeline of both releases, where to find what, which series to use). The publication narrative is not part of this change.
- Use lowercase column headers for every 2026 output.

## Impact

- Affected specs: `rilascio-2026` (new), `tutela-identificativi` (new)
- Affected code: new `scripts/2026/` (from `ondata/attivita` `9-pubblicazione/script/`), new `data/output/2026/`, new `data/rawdata/2026/`, new `docs/2026/`, `README.md`
- No breaking changes for existing consumers (e.g. the Period Think Tank platform using the 2019-2024 outputs)
