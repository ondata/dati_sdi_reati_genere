# Analisi Classificazione DES_OBIET (Issue #2)

**Data**: 2025-11-15  
**Obiettivo**: Classificare valori DES_OBIET e identificare semantica ambigua  
**File**: `data/processing/reati_sdi/reati_sdi.csv` (3.329 record)

## Distribuzione Valori DES_OBIET

### Statistiche Generali
- **Valori unici**: 16 categorie diverse
- **Record con dati**: 3.329 (100%)
- **Valori dominanti**: 2 categorie coprono 98.5% dei casi

### Tabella Distribuzione Completa

| DES_OBIET | Frequenza | Percentuale | Classificazione |
|-----------|-----------|-------------|-----------------|
| NON PREVISTO/ALTRO | 2.128 | 63.92% | **Ambiguo** |
| PRIVATO CITTADINO | 1.151 | 34.57% | **Specifico** |
| VEICOLO PRIVATO | 14 | 0.42% | **Specifico** |
| PROPRIETA' PRIVATA | 8 | 0.24% | **Specifico** |
| SEQUESTRATO LIBERATO | 7 | 0.21% | **Specifico** |
| COMMERCIANTE | 6 | 0.18% | **Specifico** |
| VIAGGIATORE FS | 3 | 0.09% | **Specifico** |
| RAME/ALTRO OGGETTO | 3 | 0.09% | **Ambiguo** |
| LIBERO PROFESSIONISTA | 2 | 0.06% | **Specifico** |
| Altri 8 valori | 7 | 0.21% | **Specifico** |

## Problema Critico: "NON PREVISTO/ALTRO"

### Dimensione del Problema
- **2.128 record** (63.9%) etichettati come "NON PREVISTO/ALTRO"
- **Nessuna distinzione** tra "non previsto" e "altro"
- **Informazione geografica/perimetrale persa**

### Analisi Relazione Autore-Vittima per "NON PREVISTO/ALTRO"

| Relazione | Frequenza | Percentuale sul totale |
|-----------|-----------|------------------------|
| CONIUGE/CONVIVENTE | 1.094 | 51.4% |
| ALTRO PARENTE | 403 | 18.9% |
| EX CONIUGE/EX CONVIVENTE | 218 | 10.2% |
| ALTRO | 113 | 5.3% |
| EX FIDANZATO | 84 | 3.9% |
| FIDANZATO | 81 | 3.8% |
| CONOSCENTE/AMICO | 78 | 3.7% |
| Altre relazioni | 57 | 2.8% |

### Pattern Identificati

1. **Violenza domestica predominante** (80.5% casi "NON PREVISTO/ALTRO")
   - Coniuge/convivente: 51.4%
   - Parenti: 18.9%
   - Ex partner: 14.1%

2. **Luoghi fisici non specificati**
   - Abitazioni private non codificate
   - Spazi domestici non classificati
   - Luoghi di vita quotidiana

## Conformità Legge 53/2022 Art. 5

### Requisiti Violati
- **Informazioni sul luogo dove il fatto è avvenuto**: 63.9% mancanti
- **Tipologia di luogo**: non distinguibile in "NON PREVISTO/ALTRO"
- **Statistiche territoriali**: impossibili da calcolare

### Gap Critici
- **Dato geografico aggregato**: solo provincia/comune, non luogo specifico
- **Semantica ambigua**: "NON PREVISTO" vs "ALTRO" non distinguibili
- **Informazione perduta**: impossibile ricostruire contesto fisico

## Raccomandazioni

### Correzioni Immediate
1. **Separare "NON PREVISTO" da "ALTRO"** in due campi distinti
2. **Aggiungere campo LUOGO_SPECIFICO** con valori standardizzati
3. **Documentare regole classificazione** luoghi privati

### Standardizzazione Proposta

```
LUOGO_TIPO: [ABITAZIONE|LUOGO_LAVORO|LUOGO_PUBBLICO|VEICOLO|ALTRO|NON_RILEVABILE]
LUOGO_DESCRIZIONE: [testo libero per dettagli]
```

### Valori Standard per Luogo Specifico
- ABITAZIONE_PRIVATA
- ABITAZIONE_CONGIUNTA
- POSTO_LAVORO
- LUOGO_PUBBLICO
- VEICOLO_PRIVATO
- VEICOLO_PUBBLICO
- ISTITUTO_SCOLASTICO
- STRUTTURA_SANITARIA
- ALTRO_SPECIFICARE

## Impatto Statistico

### Dati Attuali vs Potenziali
- **Dati territoriali utilizzabili**: 36.1% (solo PRIVATO CITTADINO + specifici)
- **Dati contesto perse**: 63.9%
- **Analisi spaziale impossibile** nella maggioranza dei casi

### Consequenze per Policy
- **Difficile pianificazione territoriale** servizi antiviolenza
- **Impossibile analisi pattern** luoghi a rischio
- **Statistiche nazionali non comparabili** con altri paesi

## Query Utilizzate

```sql
-- Distribuzione generale
SELECT des_obiet, COUNT(*) as frequency,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reati_sdi.csv), 2) as percentage
FROM reati_sdi.csv 
GROUP BY des_obiet 
ORDER BY COUNT(*) DESC;

-- Analisi relazioni per NON PREVISTO/ALTRO
SELECT des_obiet, relazione_autore_vittima, COUNT(*) as cases
FROM reati_sdi.csv 
WHERE des_obiet = 'NON PREVISTO/ALTRO'
GROUP BY des_obiet, relazione_autore_vittima
ORDER BY COUNT(*) DESC;
```

## Prossimi Passi

1. **Proporre correzione schema** al Ministero
2. **Definire standard classificazione** luoghi
3. **Implementare validazioni** automatiche
4. **Creare mappatura** valori esistenti vs nuovo schema