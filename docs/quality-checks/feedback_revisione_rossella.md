# Feedback analisi dati FOIA - Revisione metodologica

Ciao Rossella,

ho approfondito l'analisi che hai condotto sui dati FOIA e ho identificato alcuni punti critici che meritano una revisione. Ti scrivo in modo costruttivo perché l'esercizio di validazione è importante, ma emergono questioni metodologiche che cambiano significativamente le conclusioni.

## Il problema principale: Confronto tra dataset non comparabili

### Cosa hai confrontato:
- **A sinistra**: Report ISTAT "Violenza contro le donne – Un anno di Codice Rosso" (agosto 2019 – agosto 2020)
  - Base dati: **Polizia di Stato** (tutti i reati di genere registrati)
  - Fonte: DCPC (Dipartimento della Pubblica Sicurezza)
  - Scope: **Completo** (senza filtri particolari)

- **A destra**: FILE_6 FOIA (comunicazioni SDI, periodo agosto 2019 – agosto 2020)
  - Base dati: **Sistema Denunce (SDI)**
  - Scope: **SOTTINSIEME FILTRATO** (solo comunicazioni con "relazione vittima-autore" codificata)
  - Cosa manca: comunicazioni senza relazione V-A codificata, episodi non classificati

### Il problema nel confronto:
Non stai confrontando "mele con mele", ma due dataset con **scope completamente diverso**:

```
Report ISTAT                    FILE_6 FOIA
(Completo)                      (Filtrato)
    │                               │
    ├─ Tutti i reati di genere     └─ Solo reati con 
    │  della Polizia                 relazione V-A codificata
    │
    ├─ Art. 558 bis: 11 ✓           Art. 558 bis: 0 (periodo ISTAT)
    ├─ Art. 583 qui: 56 ✓           Art. 583 qui: 0 (periodo ISTAT)
    ├─ Art. 387 bis: 1.741 ✓        Art. 387 bis: 0 (periodo ISTAT)
    └─ Art. 612 ter: 718 ✓          Art. 612 ter: 8 (periodo ISTAT)

⚠️  È NORMALE che FILE_6 << ISTAT perché FILE_6 è un sottinsieme!
```

## Cosa questo significa per le tue conclusioni

### ❌ Conclusione sbagliata:
> "Emerge una sproporzione tra i dati dei primi anni e quelli più recenti. 
> I valori appaiono comunque poco coerenti con quanto ci racconta ISTAT."

Questa conclusione **non è valida** perché stai confrontando dataset con scope diverso.

### ✅ Cosa sarrebbe corretto dire:
"FILE_6 è un sottinsieme intenzionale di dati SDI con relazione V-A codificata. 
La differenza rispetto a ISTAT riflette il filtro applicato, non missing data."

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

## Cosa è DAVVERO importante verificare

Invece di confrontare FILE_6 con ISTAT, dovresti verificare:

### 1. **FILE_6 è coerente con se stesso?**
- ✅ Le righe duplicate per PROT_SDI sono corrette? (rappresentano vittime multiple?)
- ✅ La codifica della relazione V-A è completa e consistente?
- ✅ Ci sono valori NULL inattesi nei campi critici?

### 2. **FILE_6 è davvero un sottinsieme di SDI totale?**
- Se il Ministero dice "FILE_6 contiene comunicazioni SDI con relazione V-A"
- Allora: FILE_6 (periodo X) ≤ SDI totale (periodo X) ✓ (verificabile?)
- E: ogni riga in FILE_6 dovrebbe avere campi corretti ✓ (verificabile)

### 3. **La sproporzione temporale è anomala?**
Sì, ma forse per motivi diversi:
- Possibile: miglioramento nella codifica della relazione V-A nel 2023-2024
- Possibile: retroimplementazione dati 2019-2020 nel 2023-2024
- Domanda legittima: **quanto è "retroattivo" questo dataset?**

---

## Cosa fare ora

Suggerisco di revisionare la tua analisi:

**Step 1**: Riconoscere che FILE_6 è un sottinsieme filtrato
- Non è un'estrazione completa dello stesso periodo
- Non è direttamente comparabile con ISTAT
- La differenza quantitativa è **attesa**, non anomala

**Step 2**: Refocus su questioni reali
- ✅ Metadati mancanti (quando è stato estrapolato? quale versione SDI?)
- ✅ Chiave primaria ambigua (PROT_SDI ripetuto per vittime multiple)
- ✅ Semantica campi non documentata (DES_OBIET, LUOGO_SPECIF_FATTO)
- ✅ Righe duplicate (come contare episodi unici vs righe?)

**Step 3**: Fare domande corrette al Ministero
- "Potete spiegare il processo di codifica della relazione V-A nel sistema SDI?"
- "Quante comunicazioni 2019-2020 hanno subito retroimplementazione della relazione V-A in 2023-2024?"
- "Qual è la completezza attesa della codifica della relazione V-A?"
- "Come conteggiamo episodi unici quando PROT_SDI è ripetuto?"

---

## Conclusione

Il tuo lavoro di validazione è prezioso, ma **la metodologia ha un errore concettuale fondamentale** che invalida le conclusioni principali.

Ti chiedo di revisionare l'analisi con questa nuova prospettiva e scrivere un addendum che chiarisca:

1. Che FILE_6 è un sottinsieme deliberato, non un'estrazione completa
2. Che il confronto con ISTAT non è valido per questa ragione
3. Che le vere questioni sono su metadati, chiave primaria, e completezza della codifica

Questo renderebbe l'analisi **molto più forte** perché focalizzata su problemi reali, non su un confronto improprio.

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
