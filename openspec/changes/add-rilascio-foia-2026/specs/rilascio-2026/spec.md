## ADDED Requirements

### Requirement: Second FOIA release published alongside the first

The repository MUST publish the data of the 2026 FOIA release under dedicated `2026/` paths and MUST NOT move, rename or modify any file of the first release.

#### Scenario: Existing links keep working

- **WHEN** a user opens a raw link to `data/rawdata/MI-123-U-A-SD-2025-90_5.xlsx` or a CSV in `data/output/comunicazioni_sdi/`
- **THEN** the file is found at the same path with the same content as before the change

#### Scenario: New release is findable

- **WHEN** a user reads `README.md`
- **THEN** the README lists both releases with request and response dates and points to `data/output/2026/` for the new outputs

### Requirement: 2019-2025 provincial series

The repository MUST publish a provincial series 2019-2025 merging both releases, with a `rilascio` column, the most recent release's value for 2024, and a separate file with the 2024 differences between releases.

#### Scenario: No double counting of 2024

- **WHEN** the series is grouped by gruppo, misura, provincia, reato, fascia_eta, sesso_autore and anno
- **THEN** every combination appears at most once

#### Scenario: Revisions are traceable

- **WHEN** a user needs the 2024 value from the first release
- **THEN** `revisioni_2024.csv` gives both values, their difference and whether the combination exists in one release only

### Requirement: Reproducible pipelines

The 2026 pipelines MUST regenerate their outputs from scratch at every run, MUST produce identical files on consecutive runs, and MUST stop with an error when a code, province or crime label has no mapping.

#### Scenario: Idempotent run

- **WHEN** a pipeline runs twice in a row on the same inputs
- **THEN** the output files have identical checksums

#### Scenario: Unmapped province

- **WHEN** a province name in the input has no ISTAT code and no alias
- **THEN** the pipeline exits with an error naming the province
