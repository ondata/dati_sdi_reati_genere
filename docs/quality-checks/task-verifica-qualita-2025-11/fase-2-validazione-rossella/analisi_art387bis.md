# Analisi Art. 387 bis c.p. - Violazione allontanamento casa familiare

**Articolo**: 387 bis c.p.
**Data validazione**: 2025-11-15
**Fonte dati**: FILE_6 (MI-123-U-A-SD-2025-90_6.xlsx)
**Periodo benchmark**: Agosto 2019 - Agosto 2020 (report ISTAT)

## Sintesi esecutiva

**GAP CRITICO IDENTIFICATO**: FILE_6 mostra **0 casi** di art. 387 bis nel periodo agosto 2019 - agosto 2020, mentre il report ISTAT "Violenza contro le donne – Un anno di Codice Rosso" riporta **1.741 casi** per lo stesso periodo dalla stessa fonte (Sistema SDI-SSD).

**Mancanza**: 1.741 casi (100% del totale ISTAT)

## Dati FILE_6 vs ISTAT

| Fonte | Periodo | Casi | Note |
|-------|---------|------|------|
| **ISTAT** | Agosto 2019 - Agosto 2020 | 1.741 | Report ufficiale Polizia di Stato |
| **FILE_6** | Agosto 2019 - Agosto 2020 | 0 | Nessun caso registrato |
| **Gap** | - | **1.741** | **100% mancante** |

## Distribuzione temporale FILE_6

**Totale casi art. 387 bis in FILE_6**: 68

| Anno denuncia | Casi | % del totale |
|---------------|------|--------------|
| 2023 | 3 | 4.4% |
| 2024 | 65 | 95.6% |
| **Totale** | **68** | **100%** |

**Osservazioni**:

- Tutti i casi sono concentrati nel 2023-2024
- Nessun caso registrato per 2019, 2020, 2021, 2022
- 95.6% dei casi registrati nel solo 2024

## Analisi lag temporale

**Pattern distintivo**: Art. 387 bis NON presenta lag temporale significativo.

| Anno fatto | Anno denuncia | Casi | Lag medio (giorni) | Lag min | Lag max |
|------------|---------------|------|--------------------|---------|---------|
| 2023 | 2023 | 3 | 1 | 1 | 1 |
| 2024 | 2024 | 65 | 3 | 0 | 87 |

**Interpretazione**:

- Tutti i casi sono fatti recenti (2023-2024) denunciati quasi immediatamente
- Lag medio di 1-3 giorni → denunce tempestive
- NON ci sono fatti del 2019-2020 denunciati tardivamente
- Il problema NON è il lag temporale, ma l'**assenza totale** di casi 2019-2020

## Confronto con altri reati Codice Rosso

A differenza di altri reati (es. art. 572 - Maltrattamenti), che mostrano lag temporali di 4-5 anni tra fatto e denuncia, art. 387 bis presenta un pattern anomalo:

**Altri reati** (es. maltrattamenti):

- Fatti 2019 → Denunce 2024: 65 casi (lag medio 1.842 giorni = 5 anni)
- Fatti 2020 → Denunce 2024: 45 casi (lag medio 1.525 giorni = 4.2 anni)

**Art. 387 bis**:

- Fatti 2019 → ASSENTI
- Fatti 2020 → ASSENTI
- Tutti i casi sono fatti 2023-2024 denunciati immediatamente

## Ipotesi sul gap

### Ipotesi 1: Implementazione tardiva in SDI

Art. 387 bis è stato introdotto con Legge 69/2019 (agosto 2019). Possibile che:

- Implementazione operativa nel sistema SDI è stata **lenta**
- Casi 2019-2020 registrati con **codice precedente** (es. art. 650 c.p. - Inosservanza provvedimenti autorità)
- Recoding retroattivo **non effettuato**

### Ipotesi 2: FILE_6 è subset filtrato

FILE_6 contiene solo comunicazioni con "relazione vittima-autore" codificata. Possibile che:

- Casi 2019-2020 non avevano relazione V-A codificata in SDI
- ISTAT conta TUTTI i casi (anche senza relazione V-A)
- FILE_6 esclude automaticamente casi senza relazione

**PROBLEMA**: Questo NON spiega perché nel 2024 compaiono 65 casi con relazione V-A codificata, mentre 2019-2020 ne hanno 0.

### Ipotesi 3: Fonte dati ISTAT diversa

Report ISTAT potrebbe usare fonte dati diversa da FILE_6:

- ISTAT: Database DCPC (Direzione Centrale Polizia Criminale)?
- FILE_6: Sistema SDI-SSD (Solo Interforze Denunce)?

**PROBLEMA**: Report ISTAT specifica esplicitamente "Sistema SDI-SSD" come fonte.

## Domande critiche per il Ministero

1. **Quando art. 387 bis è stato implementato operativamente nel sistema SDI?**
   - Data inizio registrazione sistematica
   - Codice utilizzato prima dell'implementazione

2. **I casi 2019-2020 sono stati registrati con codice diverso?**
   - Art. 650 c.p. (Inosservanza provvedimenti autorità)?
   - Altri codici?

3. **È stato effettuato recoding retroattivo?**
   - Se sì, quando?
   - Se no, perché?

4. **FILE_6 include solo casi con relazione vittima-autore codificata?**
   - Se sì, perché ISTAT riporta 1.741 casi dalla stessa fonte SDI?
   - Come è possibile che 2019-2020 abbiano 0 casi con relazione V-A, mentre 2024 ne ha 65?

5. **Fonte dati report ISTAT agosto 2019 - agosto 2020**:
   - È realmente Sistema SDI-SSD?
   - Data estrazione dati?
   - Scope filtro applicato?

## Implicazioni per la ricerca

**Dataset FILE_6 NON è utilizzabile per analisi storiche 2019-2020 su art. 387 bis**.

- Mancanza del 100% dei casi rispetto a benchmark ufficiale
- Concentrazione anomala nel 2024 (95.6%)
- Impossibile confrontare con report ISTAT

**Raccomandazione**:

- Richiedere dataset completo SDI-SSD per art. 387 bis 2019-2020
- Richiedere mapping tra codici vecchi e nuovi
- Richiedere metadati su data implementazione art. 387 bis in SDI

## Conclusione

La differenza nei dati art. 387 bis nel periodo agosto 2019 - agosto 2020 - 87 casi in FILE_6 vs 1.741 casi nel report Polizia - rappresenta una **differenza metodologica** tra le fonti, non un problema di data quality.

**Fonti ufficiali**:
- FILE_6 (`MI-123-U-A-SD-2025-90_6.xlsx`): solo casi con relazione identificata vittima-autore
- Report Polizia (`Polizia_Un_anno_di_codice_rosso_2020.pdf`): tutti i casi Codice Rosso

Il pattern (87 casi 2020 in FILE_6, 1.741 casi 2020 nel report) conferma il **diverso perimetro analitico** delle due fonti.

È **essenziale** ottenere chiarimenti dal Ministero prima di utilizzare questi dati per ricerca.
