# Mappature geografiche

File di mappatura per risolvere discrepanze tra diverse fonti ISTAT e dati SDI.

## Struttura

- **`comuni/`**: mapping completi comuni xlsx → Istat → shapefile → situas
- **`province/`**: mapping province xlsx → Istat → shapefile
- File di supporto per casi speciali (Sardegna, regioni, sigle)

## codici_province_sardegna_situas_istat.csv

Mappatura tra codici provincia SITUAS e codici UTS ISTAT per province Sardegna.

**Problema**: Dimensioni Province SITUAS usa codici diversi da unita_territoriali_istat.csv per province Sardegna:

- SITUAS: 312, 114, 115, 318 per Sassari, Nuoro, Oristano, Cagliari
- ISTAT UTS: 090, 091, 095, 292 per le stesse province

**Soluzione**: Join con questa mappatura in etl_5.sh (linee 357-376) per sostituire codici SITUAS con codici ISTAT compatibili prima del join con sigle automobilistiche.

### Struttura

- `codice_uts_situas`: codice provincia in dimensioni_province_situas.csv
- `codice_uts_istat`: codice provincia compatibile con unita_territoriali_istat.csv
- `nome_provincia_mappatura`: nome provincia (documentazione)
- `sigla_mappatura`: sigla automobilistica (documentazione)
- `note`: informazioni aggiuntive

### Province mappate

Province storiche:

- 312 → 090 (Sassari - SS)
- 114 → 091 (Nuoro - NU)
- 115 → 095 (Oristano - OR)
- 318 → 292 (Cagliari - CA)

Province ripristinate 2025 (confluite in altre UTS):

- 113 → 090 (Gallura Nord-Est Sardegna → Sassari)
- 116 → 091 (Ogliastra → Nuoro)
- 117 → 111 (Medio Campidano → Sud Sardegna)
- 119 → 111 (Sulcis Iglesiente → Sud Sardegna)

## province_sardegna_soppresse.jsonl

Documentazione province sarde soppresse 2016 e ripristinate 2025.

Utilizzato per normalizzazione nomi in etl_5.sh prima del fuzzy matching.

Formato JSONL per facilità aggiornamento e documentazione.
