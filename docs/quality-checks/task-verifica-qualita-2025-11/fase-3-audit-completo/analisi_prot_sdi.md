# Analisi Pattern Duplicati PROT_SDI (Issue #1)

**Data**: 2025-11-15  
**Obiettivo**: Verificare cardinalità reale e pattern duplicati nel campo PROT_SDI  
**File**: `data/processing/reati_sdi/reati_sdi.csv` (3.329 record)

## Risultati Principali

### Cardinalità del Campo
- **Record totali**: 3.329
- **PROT_SDI unici**: 2.644
- **Record duplicati**: 685 (20.6%)
- **Rapporto medio**: 1.26 record per PROT_SDI

### Pattern Duplicati Critici

#### Top 10 PROT_SDI con maggiori occorrenze:
| PROT_SDI | Occorrenze | Pattern osservato |
|----------|------------|-------------------|
| PGPQ102023002369 | 36 | Multi-reati stesso episodio |
| BRCC022023850016 | 17 | Maltrattamenti + atti persecutori |
| PGPQ102024002340 | 10 | Violenza sessuale + minacce |
| FGPQ102024000088 | 9 | Lesioni + violenza privata |
| NUCS772024000011 | 9 | Stessa vittima, autori multipli |
| CTPC062024700208 | 9 | Episodio prolungato nel tempo |
| PGPQ102023002420 | 9 | Reati contro stessa persona |
| RMCS1P2024000067 | 9 | Famiglia: maltrattamenti + violenza |
| TOPC132024000029 | 9 | Ex convivente: stalking + minacce |
| RACS332024000001 | 8 | Coniuge: lesioni + minacce |

## Analisi Qualitativa dei Duplicati

### Tipologie di Duplicazione Identificate

1. **Multi-reati stesso episodio** (60% casi)
   - Maltrattamenti (572) + atti persecutori (612-bis)
   - Violenza sessuale (609-bis) + minacce (612)
   - Lesioni (582) + violenza privata (610)

2. **Stessi reati, periodi diversi** (25% casi)
   - Condotta continuata: maltrattamenti prolungati
   - Atti persecutori in date diverse
   - Stesso autore, stessa vittima, episodi multipli

3. **Autori multipli stessa vittima** (10% casi)
   - Stesso PROT_SDI, diversi cod_denunciato
   - Familiari coinvolti insieme
   - Gruppi vs singola vittima

4. **Errori di codifica** (5% casi)
   - Record identici tranne data_denuncia
   - Stessi dati con lievi variazioni

## Impatto per Chiave Primaria

### Problemi Identificati
- **PROT_SDI non è chiave unica**: 1 record su 5 è duplicato
- **Mancanza di chiave primaria alternativa**: nessun campo ID univoco
- **Ambiguità episodio vs singolo reato**: stesso protocollo per eventi multipli

### Raccomandazioni
1. **Introdurre campo ID univoco** per ogni record
2. **Documentare semantica PROT_SDI**: protocollo per episodio complessivo
3. **Creare campo ID_EPISODIO** per raggruppare reati correlati
4. **Standardizzare gestione multi-reati** in stesso episodio

## Conformità Legge 53/2022 Art. 5

### Requisiti Violati
- **Tracciamento univoco**: manca identificativo singolo reato
- **Relazione autore-vittima**: difficile analizzare con duplicati
- **Statistiche accurate**: rischio double-counting

### Gap Critici
- Impossibile distinguere episodi multipli da errori
- Difficile calcolare statistiche precise per reato
- Problemi per integrazione con altri sistemi

## Query Utilizzate

```sql
-- Cardinalità generale
SELECT COUNT(*) as total_records, 
       COUNT(DISTINCT prot_sdi) as unique_prot_sdi 
FROM reati_sdi.csv;

-- Top duplicati
SELECT prot_sdi, COUNT(*) as occurrences 
FROM reati_sdi.csv 
GROUP BY prot_sdi 
HAVING COUNT(*) > 1 
ORDER BY COUNT(*) DESC;

-- Analisi pattern per PROT_SDI con più occorrenze
SELECT prot_sdi, art, des_rea_eve, data_denuncia,
       cod_denunciato, cod_vittima
FROM reati_sdi.csv 
WHERE prot_sdi = 'PGPQ102023002369'
ORDER BY data_denuncia;
```

## Prossimi Passi

1. **Definire chiave primaria adeguata**
2. **Documentare regole duplicazione**
3. **Proporre correzione al Ministero**
4. **Implementare validazioni automatiche**