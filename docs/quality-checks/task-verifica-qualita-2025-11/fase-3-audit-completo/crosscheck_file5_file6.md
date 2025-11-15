# Cross-Check Coerenza FILE_5 vs FILE_6 Stesso Periodo

**Data**: 2025-11-15  
**Obiettivo**: Verificare coerenza aggregati tra comunicazioni SDI (FILE_5) e dati dettagliati (FILE_6)  
**Periodo analizzato**: 2019-2024  
**File**: 
- FILE_5: `data/processing/comunicazioni_sdi/delitti_commessi.csv`
- FILE_6: `data/processing/reati_sdi/reati_sdi.csv`

## Differenze Fondamentali tra Dataset

### Scope e Granularità

| Caratteristica | FILE_5 (Comunicazioni) | FILE_6 (Dettaglio) |
|----------------|------------------------|-------------------|
| **Periodo** | 2019-2024 completo | 2019-2025 (concentrato 2023-2024) |
| **Granularità** | Aggregato per provincia/anno | Record singolo con dettagli |
| **Tipologie reato** | 5 categorie principali | 28+ articoli CP specifici |
| **Record totali** | 3.210 (535×6 anni) | 3.329 record individuali |
| **Focus** | Statistiche comunicazioni ISTAT | Dettaglio investigativo SDI |

### Analisi Comparativa per Periodo 2019-2024

#### FILE_5: Statistiche Complete per Anno
| Anno | Record provincia | Casi totali | Media per provincia |
|------|------------------|-------------|---------------------|
| 2019 | 535 | 159.915 | 299 |
| 2020 | 535 | 142.950 | 267 |
| 2021 | 535 | 150.930 | 282 |
| 2022 | 535 | 154.746 | 289 |
| 2023 | 535 | 154.908 | 289 |
| 2024 | 535 | 164.301 | 307 |

#### FILE_6: Casi per Anno di Denuncia
| Anno | Record | Percentuale |
|------|--------|-------------|
| 2019 | 3 | 0.09% |
| 2020 | 5 | 0.15% |
| 2021 | 3 | 0.09% |
| 2022 | 9 | 0.27% |
| 2023 | 343 | 10.30% |
| 2024 | 2.743 | 82.38% |
| 2025 | 223 | 6.70% |

## Incoerenze Critiche Identificate

### 1. Divergenza Temporale Massiva

**Problema**: FILE_6 mostra distribuzione anomala concentrata nel 2024 (82.4%)

**Possibili Spiegazioni**:
- **Scope diverso**: FILE_6 potrebbe essere estrazione parziale
- **Retroattività registrazione**: lag 4-5 anni già identificato in Fase 2
- **Filtro applicato**: solo reati V-A (violenza-donne)
- **Sistema diverso**: SDI vs comunicazioni statistiche

### 2. Scala Numerica Incomparabile

**FILE_5**: ~928.000 casi totali 2019-2024  
**FILE_6**: 3.329 casi totali (0.36% di FILE_5)

**Rapporto**: 1 caso FILE_6 ogni 278 casi FILE_5

### 3. Classificazione Reati Diversa

#### FILE_5: Categorie Agreggate
- 5. TENTATI OMICIDI
- 8. LESIONI DOLOSE  
- 9. PERCOSSE
- 10. MINACCE
- 12. VIOLENZE SESSUALI

#### FILE_6: Articoli Codice Penale
- Art. 572: Maltrattamenti (1.457 casi)
- Art. 582: Lesioni personali (285 casi)
- Art. 612: Minacce/atti persecutori (580 casi)
- Art. 609: Violenza sessuale (153 casi)

### 4. Confronto Specifico: Percosse vs Lesioni

**FILE_5 - Percosse (Art. 581)**:
- 2019: 14.395 casi
- 2024: 18.035 casi
- Trend: +25.3% 2019→2024

**FILE_6 - Lesioni Personali (Art. 582)**:
- 2019-2022: 0-2 casi totali
- 2023: 67 casi
- 2024: 353 casi
- Trend: esplosione 2023-2024

## Analisi di Coerenza Parziale

### Pattern Simili Identificati

1. **Trend crescente 2023-2024**: entrambi i dataset mostrano aumento
2. **Focus violenza domestica**: maltrattamenti dominanti in FILE_6
3. **Distribuzione geografica**: entrambi per provincia (da verificare)

### Divergenze Attese vs Inattese

#### Attese (normali)
- **Granularità diversa**: aggregato vs dettaglio
- **Periodo diverso**: completo vs parziale
- **Classificazione diversa**: categorie vs articoli CP

#### Inattese (critiche)
- **Scala numerica**: differenza di 2 ordini di grandezza
- **Distribuzione temporale**: concentrazione anomala 2024
- **Retroattività**: quasi assenti dati 2019-2022 in FILE_6

## Ipotesi Spiegative

### 1. Scope Diverso Intenzionale
- **FILE_5**: Tutti reati comunicati a ISTAT
- **FILE_6**: Solo reati con vittima femminile (V-A)
- **Proporzione**: donne ~30% vittime violenza → scala ancora non spiegata

### 2. Estrazione Parziale/Sperimentale
- **FILE_6**: potrebbe essere test sistema SDI
- **Periodo limitato**: solo casi recenti completamente processati
- **Filtro tecnico**: solo procedimenti archiviati/certificati

### 3. Sistemi di Rilevazione Diversi
- **FILE_5**: Dati comunicazioni statistiche (rapido)
- **FILE_6**: Dati investigativi completi (lento)
- **Lag procedurale**: 4-5 anni tra fatto e registrazione

## Raccomandazioni

### Chiarimenti da Richiedere al Ministero

1. **Scope esatto FILE_6**: 
   - È solo violenza di genere?
   - È estrazione parziale?
   - Quali filtri applicati?

2. **Relazione con FILE_5**:
   - FILE_6 è subset di FILE_5?
   - Sono sistemi paralleli?
   - Come integrare i due dataset?

3. **Completezza temporale**:
   - Perché quasi assenti dati 2019-2022?
   - È dovuto a lag procedurale?
   - Quando saranno disponibili dati completi?

### Azioni Correttive

1. **Documentare differenze** nei metadati
2. **Creare mappatura** categorie FILE_5 ↔ articoli FILE_6
3. **Stabilire metodologia** integrazione dataset
4. **Definire periodo di riferimento** per analisi comparative

## Query Utilizzate

```sql
-- FILE_5: totali per anno
SELECT anno, COUNT(*) as records, SUM(valore) as total_cases 
FROM delitti_commessi.csv 
WHERE anno BETWEEN 2019 AND 2024 
GROUP BY anno ORDER BY anno;

-- FILE_6: casi per anno denuncia
SELECT EXTRACT(YEAR FROM data_denuncia) as anno, COUNT(*) as cases 
FROM reati_sdi.csv 
WHERE data_denuncia IS NOT NULL 
GROUP BY EXTRACT(YEAR FROM data_denuncia) 
ORDER BY anno;

-- Confronto percosse/lesioni
SELECT anno, SUM(valore) as percosse 
FROM delitti_commessi.csv 
WHERE delitto = '9. PERCOSSE' AND anno BETWEEN 2019 AND 2024 
GROUP BY anno ORDER BY anno;
```

## Conclusione

**Incoerenza strutturale**: FILE_5 e FILE_6 non sono direttamente comparabili:

- **Scale diverse**: 928.000 vs 3.329 casi
- **Periodi diversi**: completo vs concentrato 2024
- **Scope probabilmente diverso**: generale vs violenza di genere
- **Sistemi di rilevazione diversi**: comunicazioni vs investigativo

**Necessario chiarimento** dal Ministero su:
- Relazione tra i due dataset
- Scope e filtri applicati
- Completezza e rappresentatività

Senza questi chiarimenti, **impossibile utilizzare i dataset in modo integrato** per analisi statistiche affidabili.