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

### ⚠️ La tua conclusione è PARZIALMENTE corretta:

> "Emerge una sproporzione tra i dati dei primi anni e quelli più recenti. 
> I valori appaiono comunque poco coerenti con quanto ci racconta ISTAT."

**Il tuo intuito è giusto, ma il motivo è più complesso di quello che hai identificato:**

**Quello che hai rilevato CORRETTAMENTE:**
- I dati 2019-2020 sono realmente "mancanti" in FILE_6 vs ISTAT ✅
- Il pattern 2019-2022 vs 2023-2024 è davvero anomalo ✅
- Ci sono problemi nel file che meritano chiarimento ✅

**Quello che hai confuso:**
- Hai confuso il "confronto dataset diversi" (che è vero, FILE_6 è filtrato)
- Con la "mancanza di dati effettiva" (che è anch'essa vera, ma per motivi diversi)

### ✅ La vera spiegazione:

FILE_6 NON è semplicemente "filtrato per relazione V-A" in modo coerente:

1. **Art. 558 bis e 583 quinquies NON richiedono legalmente relazione V-A**
   - Possono essere commessi da chiunque (padre, collega, estraneo)
   - Eppure compaiono in FILE_6 nel 2024 SOLO con relazione V-A
   - Nel 2019-2020: ZERO casi (dove sono?)

2. **Ipotesi più probabile:**
   - Il Ministero ha cambiato i criteri di classificazione nel 2023-2024
   - Prima (2019-2022): questi articoli erano forse registrati diversamente o non inclusi in "violenza di genere"
   - Dopo (2023-2024): registrati in FILE_6 solo quando c'è relazione V-A

3. **Conseguenza:**
   - La mancanza di dati non è solo "filtro", è anche "cambio classificatorio"
   - Il problema che hai rilevato è REALE, ma i motivi sono più complessi

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

## Cosa è DAVVERO importante verificare (e cosa hai scoperto CORRETTAMENTE)

### 1. **I criteri di inclusione/esclusione in FILE_6 NON sono documentati** ⚠️
   
Hai rilevato CORRETTAMENTE che i dati 2019-2020 per art. 558 bis, 583 quinquies, 387 bis sono "mancanti". 
Ma il vero problema è più profondo: **non sappiamo perché**.

Domande da fare al Ministero:
- Art. 558 bis e 583 quinquies richiedono legalmente relazione V-A? **NO**, ma compaiono in FILE_6 solo nel 2024 con relazione V-A
- Significa che il Ministero ha cambiato i criteri di classificazione nel 2023-2024?
- Se sì, dove sono i dati 2019-2020 di questi articoli? Sono nel sistema SDI ma esclusi da FILE_6? O non erano mai stati registrati?

### 2. **FILE_6 è coerente nel tempo?**
   
La sproporzione 2019-2022 vs 2023-2024 potrebbe indicare:
- ✅ Cambio criteri classificatori (FILE_6 non è coerente tra periodi)
- ✅ Retroimplementazione di dati nel 2023-2024
- ✅ Cambio nell'algoritmo di filtraggio

**Non** è semplicemente "maggiore sensibilizzazione", come suggerivamo prima.

### 3. **FILE_6 è "completo" per il suo scope?**

Una volta chiarito lo scope (vedi punto 1), possiamo verificare:
- Le righe duplicate per PROT_SDI sono corrette?
- Ci sono NULL inattesi nei campi critici?
- La codifica della relazione V-A è consistente nel tempo?

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

## Conclusione: hai scoperto un problema REALE, ma con metodo errato

**Il tuo lavoro di validazione è prezioso. Tu HAI RAGIONE sul fondo, ma il tuo metodo è impreciso.**

### Quello che hai trovato ✅:
- I dati 2019-2020 per alcuni articoli sono realmente "mancanti" in FILE_6
- Il pattern temporale è davvero anomalo (non è solo "maggiore sensibilizzazione")
- Il Ministero non ha documentato il scope e i criteri di FILE_6

### L'errore nel tuo metodo ❌:
- Hai confrontato FILE_6 con ISTAT come se fossero dati comparabili
- In realtà, il problema è più profondo: FILE_6 non ha criteri di inclusione/esclusione documentati
- La causa non è "ISTAT vs FOIA", è "quale è veramente lo scope di FILE_6?"

### Quello che suggerisco:

**Scrivi un addendum alla tua analisi che riveda le conclusioni:**

1. **Ribadisci il dato**: I dati 2019-2020 per art. 558 bis, 583 quinquies, 387 bis sono realmente "mancanti" in FILE_6 vs ISTAT
2. **Correggi il motivo**: Non è solo perché "FILE_6 è filtrato per relazione V-A" (anche se è vero), ma perché il Ministero ha probabilmente cambiato i criteri classificatori nel 2023-2024
3. **Identifica le domande critiche** che il Ministero deve rispondere (vedi sezione precedente)
4. **Mantieni il focus**: metadati, chiave primaria, scope documentato

Questo renderebbe l'analisi **MOLTO più forte** perché:
- ✅ Riconosce che hai trovato un vero problema
- ✅ Ma lo inquadra correttamente (non è ISTAT vs FOIA)
- ✅ Genera domande specifiche per il Ministero
- ✅ Dimostra pensiero critico: sapere quando ammettere nuove informazioni

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
