# Project Context

## Purpose

This project processes and analyzes gender-based violence crime data in Italy (2019-2024), obtained through FOIA request by Period Think Tank with support from datiBeneComune.

Main objectives:

- Extract and transform raw data from Excel files into clean, normalized CSV datasets
- Standardize geographic codes and names with ISTAT codes
- Enable data analysis on gender violence trends, victim profiles, perpetrator demographics
- Publish open data to promote transparency and research on gender violence in Italy

Data sources:

- SDI (Sistema di Indagine) / SSD (Sistema di Sorveglianza Dati) from Italian Ministry of Interior
- Includes crime types: homicides, sexual violence, stalking, domestic abuse, "Codice Rosso" offenses
- Provincial-level disaggregation with victim gender, arrests/reports, victim-perpetrator relationships

## Tech Stack

### Primary Tools

- **Bash**: Main scripting language for ETL pipelines
- **qsv**: Excel extraction, CSV manipulation
- **mlr (Miller)**: Data cleaning, transformation, deduplication
- **jq**: JSON processing for metadata
- **duckdb**: SQL queries and data analysis
- **csvmatch**: Fuzzy matching for geographic name standardization
- **Python 3** (via `python3`): Specialized data processing scripts
- **uv**: Python package installation

### Data Formats

- Input: Excel (.xlsx)
- Output: CSV (normalized, UTF-8)
- Metadata: JSONL

## Project Conventions

### Code Style

**Bash Scripts:**

- Strict error handling: `set -euo pipefail`
- Enable debugging: `set -x`
- Snake_case for file/variable names
- Absolute paths from script location: `folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"`
- Dependency checks before execution
- Comment sections with `===== PHASE N: DESCRIPTION =====`

**Markdown:**

- No numbered headings (hard to maintain)
- Empty line after colon before lists
- Empty line before/after code blocks (triple backticks)

**Data Conventions:**

- Lowercase column headers
- Remove `(null)` strings
- Clean whitespace, empty columns, trivial records
- Geographic names standardized to ISTAT conventions

### Architecture Patterns

**ETL Pipeline Structure:**

```
scripts/
  etl_5.sh                  # Process "comunicazioni_sdi" (victim-perpetrator relationships)
  etl_6.sh                  # Process "reati_sdi" (crime statistics)
  pulisci_dataset.sh        # General dataset cleaning utility
  find_unique_combinations.py  # Python script for data analysis
  task/                     # Task-specific scripts (e.g., issue_30.sh)
  tmp/                      # Temporary processing files

data/
  rawdata/     # Original Excel files from Ministry
  processing/  # Intermediate and final CSV outputs
```

**Processing Phases:**

1. Metadata extraction (sheet info to JSONL)
2. Excel to CSV conversion by sheet
3. Data cleaning (encoding, duplicates, whitespace)
4. Geographic standardization (province/region/municipality names + ISTAT codes)
5. Validation and quality checks

### Testing Strategy

No formal testing framework currently.

Quality assurance via:

- Data validation queries in docs/quality-checks/
- Manual review of output CSVs
- Comparison with ISTAT official geographic datasets
- Documentation of known data quality issues

### Git Workflow

**Branch Strategy:**

- `main`: primary development branch
- Feature branches for specific tasks/issues

**Commit Conventions:**

- Extremely concise messages (sacrifice grammar for brevity)
- Use `gh` CLI for GitHub operations
- Update `LOG.md` for important project changes (newest entries at top, YYYY-MM-DD format)

## Domain Context

### Gender Violence Data Categories

**"Reati Spia" (Indicator Crimes):**

- Stalking (Atti Persecutori)
- Domestic abuse (Maltrattamenti Familiari)
- 76% female victims
- Show consistent increase 2019-2024

**"Codice Rosso" Offenses:**

- Forced marriage
- Disfigurement
- Non-consensual intimate image sharing
- Violation of restraining orders
- 58% female victims, 94% male perpetrators

**Other Crimes:**

- Sexual violence (80% female victims)
- Homicides of women (categorized by family/partner relationship)
- Assaults, threats, injuries

### Key Analytical Challenges

- Gap between reported crimes and identified perpetrators (31-55% no suspect)
- Geographic concentration in metropolitan areas (Rome, Milan, Naples, Turin)
- Need for population-normalized rates (per 100k inhabitants)
- Victim-perpetrator age correlation analysis

## Important Constraints

### Data Quality Issues

**Structural Problems:**

- No ISTAT geographic codes in raw data
- Zeros represented as empty cells
- Duplicate rows and empty columns
- Typos in raw data ("fascie" vs "fasce")

**Value Quality:**

- Anomalous age values (negative numbers, 1930)
- Incorrect province/municipality names (especially Sardinia)
- Empty `stato` field for Italian records
- Encoding errors in geographic names (e.g., "VALLÃ‰E D'AOSTE")

**Temporal:**

- 2024 data provisional (not consolidated)

**Completeness:**

- "Homicides" category missing in victim dataset but present in reports
- Unclear data aggregation methodology

### Processing Constraints

- Must preserve data provenance (raw → processing pipeline → output)
- Geographic name standardization critical for analysis
- Cannot assume data completeness or accuracy without validation

## External Dependencies

### Geographic Reference Data

- ISTAT official province/municipality codes
- Custom correction mappings for province names (JSONL format)

### Command-line Tools (Required)

All scripts verify these are installed:

- jq
- qsv
- mlr (Miller)
- duckdb
- csvmatch
- python3/pip3

### Data Sources

- Italian Ministry of Interior (Dipartimento della Pubblica Sicurezza)
- SDI/SSD crime reporting system
- FOIA request: MI-123-U-A-SD-2025-90

### Organizations

- **Period Think Tank**: FOIA requestor
- **datiBeneComune**: Open data advocacy/publication
- **ISTAT**: Official statistics provider
