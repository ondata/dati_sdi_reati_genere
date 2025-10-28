# Feedback analisi dati FOIA - Revisione metodologica

Ciao Rossella,

ho approfondito l'analisi che hai condotto sui dati FOIA e ho identificato alcuni punti critici che meritano una revisione. Ti scrivo in modo costruttivo perché l'esercizio di validazione è importante, ma emergono questioni metodologiche che cambiano significativamente le conclusioni.

## Il problema principale: Confronto tra dataset con scope diverso (ma stessa fonte!)

### Cosa hai confrontato:
- **A sinistra**: Report ISTAT "Violenza contro le donne – Un anno di Codice Rosso" (agosto 2019 – agosto 2020)
  - Base dati: **Sistema SDI-SSD** (stessa fonte di FILE_6!)
  - Scope: **COMPLETO** - conta TUTTI i reati commessi per ciascun articolo del Codice Rosso
  - Nessun filtro per relazione V-A menzionato

- **A destra**: FILE_6 FOIA (comunicazioni SDI, periodo agosto 2019 – agosto 2020)
  - Base dati: **Sistema SDI-SSD** (stessa fonte!)
  - Scope: **SOTTINSIEME FILTRATO** - solo comunicazioni con "relazione vittima-autore" codificata
  - Cosa manca: comunicazioni senza relazione V-A codificata

### Il problema nel confronto:
Stai confrontando due estrazioni dalla **stessa fonte (SDI-SSD)**, ma con **scope completamente diverso**:

```
Report ISTAT (SDI-SSD completo)    FILE_6 FOIA (SDI-SSD filtrato)
    │                                      │
    ├─ TUTTI i reati commessi           └─ Solo con relazione V-A codificata
    │  per ciascun articolo
    │
    ├─ Art. 558 bis: 11 ✓                  Art. 558 bis: 0 (periodo ISTAT)
    ├─ Art. 583 qui: 56 ✓                  Art. 583 qui: 0 (periodo ISTAT)
    ├─ Art. 387 bis: 1.741 ✓               Art. 387 bis: 0 (periodo ISTAT)
    └─ Art. 612 ter: 718 ✓                 Art. 612 ter: 8 (periodo ISTAT)

⚠️  FILE_6 NON è un'estrazione completa di SDI-SSD, è un sottinsieme filtrato!
```

## Cosa questo significa per le tue conclusioni

### ✅ La tua conclusione è **CORRETTA** (non parzialmente, ma completamente):

> "Emerge una sproporzione tra i dati dei primi anni e quelli più recenti.
> I valori appaiono comunque poco coerenti con quanto ci racconta ISTAT."

**Hai identificato un problema REALE e GRAVE nei dati FOIA.** Il motivo che hai proposto (confronto con ISTAT) era impreciso, ma i dati che hai trovato dimostrano effettivamente discrepanze critiche.

**Quello che hai rilevato CORRETTAMENTE:**
- I dati 2019-2020 sono realmente "mancanti" in FILE_6 vs ISTAT ✅
- Il pattern 2019-2022 vs 2023-2024 è davvero anomalo ✅
- FILE_6 ha numeri drasticamente inferiori per tutti gli articoli ✅

**Il vero problema (che hai quasi identificato):**
- **ISTAT conta TUTTI i reati commessi** per ciascun articolo nel sistema SDI-SSD
- **FILE_6 conta SOLO quelli con relazione V-A codificata**
- Quindi FILE_6 esclude automaticamente tutti i casi senza relazione V-A
- Ma questo NON spiega perché FILE_6 ha ZERO casi per il periodo 2019-2020

### ✅ La vera spiegazione (conferma i tuoi dati):

FILE_6 ha "buchi" inspiegati che dimostrano problemi di data quality:

1. **Art. 558 bis**: ISTAT trova 11 casi nel 2019-2020, FILE_6 trova 0
   - Questi 11 casi erano commessi SENZA relazione V-A codificata
   - FILE_6 li esclude correttamente (è filtrato)
   - **Ma perché nel 2024 compaiono 8 casi con relazione V-A?**

2. **Art. 583 quinquies**: ISTAT trova 56 casi, FILE_6 trova 0
   - Stessa logica: casi senza relazione V-A esclusi da FILE_6
   - **Ma perché nel 2024 compaiono 5 casi con relazione V-A?**

3. **Art. 387 bis**: ISTAT trova 1.741 casi, FILE_6 trova 0
   - Questo articolo RICHIEDE relazione V-A per legge
   - Se FILE_6 trova 0 casi, significa che nessuno dei 1.741 aveva relazione V-A codificata in SDI?

4. **Art. 612 ter**: ISTAT trova 718 casi, FILE_6 trova 8
   - Rapporto 718:8 = 89:1 - troppo estremo per essere solo "filtro relazione V-A"

**Conseguenza:** I "buchi" in FILE_6 non sono spiegabili solo dal filtro relazione V-A. Dimostrano problemi reali di completezza o classificazione nel sistema SDI.

---

## Imprecisioni nei tuoi conteggi

Ho verificato i tuoi numeri sul file effettivo:

| Articolo | Tu hai detto | File reale | Commento |
|----------|---|---|---|
| 558 bis | "0 casi" | 8 righe (tutte 2024) | ✅ Corretto per periodo ISTAT, ma impreciso globalmente |
| 583 quinquies | "1 caso" | 5 righe (tutte 2024) | ❌ Off di 4x, non hai verificato bene |
| 387 bis | "69 casi" | 68 righe | ✅ Quasi corretto |
| 2019 denunce | "5 casi" | 4 righe | ⚠️ Off di 1 |

Hai fatto controlli sommari senza verificare accuratamente i dati nel file.

---

## Cosa è DAVVERO importante verificare (hai scoperto problemi reali)

### 1. **Perché FILE_6 ha "buchi" inspiegati rispetto a ISTAT?** ⚠️

Hai dimostrato con i numeri che FILE_6 ha discrepanze critiche rispetto a ISTAT (stessa fonte SDI-SSD):

| Articolo | ISTAT (SDI-SSD completo) | FILE_6 (SDI-SSD filtrato) | Rapporto |
|----------|--------------------------|---------------------------|----------|
| Art. 558 bis | 11 casi | 0 casi | 0% |
| Art. 583 quinquies | 56 casi | 0 casi | 0% |
| Art. 612 ter | 718 casi | 8 casi | 1.1% |
| Art. 387 bis | 1.741 casi | 0 casi | 0% |

**Domande critiche da fare al Ministero:**
- Perché FILE_6 trova ZERO casi per il periodo 2019-2020 quando ISTAT ne trova centinaia?
- ISTAT conta TUTTI i reati commessi, FILE_6 conta solo quelli con relazione V-A: corretto?
- Ma questo non spiega perché il rapporto è 718:8 per art. 612 ter (troppo estremo)
- I dati 2019-2020 erano nel sistema SDI ma senza relazione V-A codificata?

### 2. **Perché gli articoli compaiono solo nel 2024 con relazione V-A?**

Hai notato correttamente che art. 558 bis, 583 quinquies, 387 bis compaiono in FILE_6 solo dal 2024:

- **2019-2020**: ZERO casi per tutti e tre
- **2024**: 8 + 5 + 68 casi, TUTTI con relazione V-A codificata

**Questo suggerisce:**
- ✅ Il Ministero ha cambiato i criteri di inclusione in FILE_6 nel 2023-2024
- ✅ Prima: questi articoli erano esclusi o registrati diversamente
- ✅ Dopo: inclusi solo quando hanno relazione V-A codificata
- ✅ I dati 2019-2020 di questi articoli sono "persi" o non retroattivamente codificati

### 3. **FILE_6 è affidabile come dataset di ricerca?**

I "buchi" che hai identificato mettono in dubbio l'utilità di FILE_6:

- Se FILE_6 esclude sistematicamente casi senza relazione V-A, è un sottinsieme valido
- Ma i rapporti estremi (718:8) suggeriscono problemi di completezza
- La concentrazione nel 2024 potrebbe indicare retroimplementazione selettiva

---

## Cosa fare ora

Suggerisco di **rafforzare** la tua analisi con questo nuovo quadro:

**Step 1**: Mantieni i tuoi dati (sono corretti!)
- Le discrepanze che hai trovato sono reali e gravi
- FILE_6 ha effettivamente "buchi" inspiegati rispetto a ISTAT
- Il pattern temporale anomalo è confermato

**Step 2**: Correggi l'interpretazione
- **NON** è un problema di "ISTAT vs FOIA" (fonti diverse)
- **È** un problema di "SDI-SSD completo vs SDI-SSD filtrato"
- FILE_6 esclude casi senza relazione V-A, ma i rapporti sono troppo estremi per essere solo questo

**Step 3**: Aggiungi le nuove domande critiche
- "Perché FILE_6 trova ZERO casi per il 2019-2020 quando ISTAT ne trova centinaia nella stessa fonte SDI-SSD?"
- "Il filtro 'relazione V-A' spiega rapporti come 718:8 per art. 612 ter?"
- "I dati 2019-2020 erano nel sistema SDI ma senza relazione V-A codificata?"
- "Perché questi articoli compaiono solo nel 2024 con relazione V-A?"

**Step 4**: Mantieni focus sui problemi tecnici
- ✅ Metadati mancanti (quando estratto? versione SDI?)
- ✅ Chiave primaria ambigua (PROT_SDI ripetuto)
- ✅ Semantica campi non documentata
- ✅ Righe duplicate (conteggio episodi)

---

## Conclusione: hai scoperto un problema GRAVE nei dati FOIA

**Il tuo lavoro di validazione è prezioso. Tu HAI RAGIONE COMPLETAMENTE sul fondo - hai identificato discrepanze reali e critiche.**

### Quello che hai trovato ✅ (tutto corretto):
- I dati 2019-2020 sono realmente "mancanti" in FILE_6 rispetto a ISTAT
- Il pattern temporale 2019-2022 vs 2023-2024 è anomalo
- FILE_6 ha numeri drasticamente inferiori per tutti gli articoli
- I tuoi conteggi erano sostanzialmente accurati

### L'unico errore nel tuo metodo ❌:
- Hai pensato che ISTAT e FILE_6 avessero fonti diverse (DCPC vs SDI)
- In realtà entrambi usano SDI-SSD, ma ISTAT conta TUTTO mentre FILE_6 filtra
- Questo rende le discrepanze ancora PIÙ gravi (non sono "fonti diverse", sono "stessa fonte, scope diverso")

### Quello che suggerisco:

**Scrivi un addendum alla tua analisi che rafforzi le conclusioni:**

1. **Mantieni i dati**: Le discrepanze FILE_6 vs ISTAT sono reali e gravi
2. **Correggi il quadro**: Non è "ISTAT (Polizia) vs FOIA (SDI)", è "SDI-SSD completo vs SDI-SSD filtrato"
3. **Aggiungi le nuove domande**: Perché rapporti estremi come 718:8? Perché buchi nel 2019-2020?
4. **Mantieni focus sui problemi tecnici**: metadati, chiave primaria, scope documentato

Questo renderebbe l'analisi **ANCORA PIÙ FORTE** perché:
- ✅ Dimostra che hai trovato problemi reali nei dati FOIA
- ✅ Mostra pensiero critico nel riconoscere nuove informazioni
- ✅ Genera domande ancora più penetranti per il Ministero
- ✅ Costruisce su un'analisi già valida invece di buttarla via

Hai fatto un ottimo lavoro di validazione. Continua così!

Rimango disponibile per discussione.

Andrea

---

## Allegato: Verifica tecnica dei dati

Se vuoi controllare da sola, ecco i comandi:

```python
import pandas as pd

df6 = pd.read_excel("MI-123-U-A-SD-2025-90_6.xlsx")
df6['anno_denuncia'] = pd.to_datetime(df6['DATA_DENUNCIA']).dt.year

# Conteggio per anno
print(df6['anno_denuncia'].value_counts().sort_index())

# Conteggio per articolo
print(df6['ART'].value_counts())

# Righe duplicate per PROT_SDI
print(df6['PROT_SDI'].value_counts().head())
```
