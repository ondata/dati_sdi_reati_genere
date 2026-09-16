## ADDED Requirements

### Requirement: No SDI person identifiers in the 2026 release

The repository MUST NOT publish, for the 2026 release, the original SDI victim code or any file from which it can be recovered, including the raw semester xlsx files and the victim code correspondence table.

#### Scenario: Microdata use meaningless codes

- **WHEN** a user reads `data/output/2026/microdati_2025/2025.csv`
- **THEN** `ID_VITTIMA` contains codes in the form `V00001` and no value in the form `YYYY-MM-DD-HH.MM.SS.ffffff`

#### Scenario: Raw semester files not tracked

- **WHEN** the tracked files are listed
- **THEN** no raw semester xlsx and no `codici_vittima.csv` is present

### Requirement: Automated identifier check

The repository MUST include a check that scans the 2026 published paths for SDI person code patterns and fails when one is found.

#### Scenario: Clean outputs

- **WHEN** the check runs on the published 2026 outputs
- **THEN** it exits with status 0

#### Scenario: Leaked identifier

- **WHEN** a file under a 2026 published path contains `2000-01-01-00.00.00.000000` or its 20-digit form `20000101000000000000`
- **THEN** the check exits with a non-zero status and names the file
