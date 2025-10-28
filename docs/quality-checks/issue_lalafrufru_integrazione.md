# Integrazione Issue lalafrufru nelle analisi

**Fonte**: GitHub issue #1 e #2 repository ondata/dati_sdi_reati_genere

**Autore**: lalafrufru

**Rilevanza**: Critica per task-002 (comunicazione Ministero)

---

## Issue #1: "Chiave del file 90_6"

### Osservazione originale

> Non mi è chiara la chiave del file in quanto sono presenti righe uguali ripetute es PROT_SDI "BOPC042024000134"

### Analisi estesa

Nel file_6, il campo `PROT_SDI` (Protocollo SDI) **è duplicato**. Significa:
- Una comunicazione SDI (PROT_SDI) può avere **più righe**
- Ogni riga rappresenta una **vittima diversa** dello stesso episodio
- Oppure **più reati commessi nello stesso episodio**

**Esempio dal file_6**:
```
PROT_SDI: RMPC212024000072 (Roma, gennaio 2024)
Riga 1: Art. 612 (minaccia/atti persecutori)
Riga 2: Art. 612 (identico reato, vittima identica?)
Riga 3: Art. 612 (ancora identico?)

→ Stessa comunicazione, 3 righe uguali
```

### Implicazione per data quality

🔴 **PROBLEMA**:
- **Non è chiara la chiave primaria** del file_6
- Contare righe ≠ contare episodi/comunicazioni
- Se conti righe: **sovracconti il fenomeno** (stesso episodio contato 3 volte)

**Esempio**: Se BOPC042024000134 è contato 5 volte nel file_6:
- Righe: 5
- Comunicazioni SDI uniche: 1
- Episodi reali: 1

### Raccomandazione per lettera Ministero

```
RICHIESTA: Fornire chiave primaria del file_6

Attualmente il campo PROT_SDI non è univoco (righe duplicate).
Necessario chiarire:
- PROT_SDI + quale colonna = record unico?
- Righe duplicate rappresentano vittime multiple? Reati multipli? Altro?
- Come contare correttamente gli episodi (non le righe)?

Allegato: Esempio PROT_SDI "BOPC042024000134" con 5 righe identiche
```

---

## Issue #2: "Significato DES_OBIET file 90_6"

### Osservazione originale

> Questo campo credo faccia riferimento all'impiego o della vittima o del denunciato, deve essere chiarito.

### Analisi dei valori

Nel file_6, colonna `DES_OBIET` contiene:

| Valore | Frequenza |
|--------|-----------|
| NON PREVISTO/ALTRO | 3.205 (62.5%) |
| PRIVATO CITTADINO | 1.841 (35.8%) |
| COMMERCIANTE | 11 |
| LIBERO PROFESSIONISTA | 4 |
| PERSONALE MEDICO | 1 |
| PROPRIETÀ PRIVATA | 8 |
| VEICOLO PRIVATO | 17 |
| PUBBLICO UFFICIALE | 6 |
| APPARTENENTE FORZE ORDINE | 1 |
| AMMINISTRATORE LOCALE | 1 |
| [ALTRI] | ~40 |

### Interpretazione

**DES_OBIET NON è "impiego di vittima o denunciato"**. 

Analizzando i valori, sembra rappresentare il **"luogo o oggetto della violenza"**:
- PRIVATO CITTADINO → episodio tra privati (36%)
- COMMERCIANTE → esercizio commerciale
- PROPRIETÀ PRIVATA → casa, terreno
- VEICOLO PRIVATO → episodio in auto
- PUBBLICO UFFICIALE → episodio che coinvolge PU
- SEQUESTRATO LIBERATO → ostaggi?

**Però**: Differisce da colonna `LUOGO_SPECIF_FATTO` che ha valori:
```
ABITAZIONE
PUBBLICO VIA
NON PREVISTO/ALTRO
PRIVATO CITTADINO
```

### Domanda non risolta

❓ **Qual è la differenza tra `DES_OBIET` e `LUOGO_SPECIF_FATTO`?**

Entrambi sembrano descrivere il **contesto/luogo**. Sono:
- Sinonimi (duplicazione)?
- Diversi livelli di granularità?
- Campi storici mantenuti per compatibilità?

### Implicazione per data quality

⚠️ **AMBIGUITÀ SEMANTICA**:
- Metadata mancante: definizione ufficiale di DES_OBIET
- 62.5% dei record hanno "NON PREVISTO/ALTRO" → campo poco utile
- Rischio: Usando campo sbagliato per georeferenziazione episodio

### Raccomandazione per lettera Ministero

```
RICHIESTA: Chiarire significato colonne geografiche/contesto

File_6 contiene più colonne potenzialmente sinonime:
- LUOGO_SPECIF_FATTO: "ABITAZIONE", "PUBBLICA VIA", etc.
- DES_OBIET: "PRIVATO CITTADINO", "COMMERCIANTE", etc.

Necessario:
1. Definizione ufficiale di ciascun campo
2. Quando usare quale colonna per analisi
3. Perché 62.5% ha "NON PREVISTO/ALTRO" in DES_OBIET?
4. Sono duplicati o rappresentano dimensioni diverse?
```

---

## Integrazione nelle analisi esistenti

### 1. Task-001 (Analisi qualità)

**Aggiungere Fase 1**:
- [ ] Verificare chiave primaria file_6 (PROT_SDI univoco?)
- [ ] Contare record vs comunicazioni uniche
- [ ] Mappare semantica DES_OBIET vs LUOGO_SPECIF_FATTO

### 2. Task-002 (Comunicazione Ministero)

**Aggiungere a richieste specifiche**:

#### Punto A.1: Chiave primaria file_6

```
Nel file con relazioni vittima-autore (file_6), il campo PROT_SDI 
presenta righe duplicate (es. BOPC042024000134 ripetuto 5 volte).

Necessario chiarire:
- PROT_SDI è la chiave primaria?
- Se sì, come interpretare righe duplicate?
- Se no, quale campo + combinazione forma chiave univoca?
- Esempio: PROT_SDI + ART? PROT_SDI + COD_VITTIMA?

Questo è critico per contare correttamente gli episodi
(non contare stesso episodio multiplo volte).
```

#### Punto B.1: Semantica campi geografici

```
File_6 contiene almeno due campi che sembrano descrivere 
il contesto/luogo dell'episodio:

1. LUOGO_SPECIF_FATTO: "ABITAZIONE", "PUBBLICA VIA", etc.
2. DES_OBIET: "PRIVATO CITTADINO", "COMMERCIANTE", etc.

Chiediamo:
- Differenza tra i due campi?
- Quale usare per geolocalizzazione?
- Perché 62.5% di DES_OBIET è "NON PREVISTO/ALTRO"?
- Sono campi legacy mantenuti per compatibilità?
```

---

## Tabella riassuntiva: Issue lalafrufru vs Scoperte nostre

| Tema | lalafrufru nota | Noi abbiamo confermato | Aggiuntiamo |
|------|---|---|---|
| **Chiave primaria file_6** | PROT_SDI duplicato | ✅ Confermato: righe uguali ripetute | Lag temporale: stesso PROT_SDI su anni diversi? |
| **DES_OBIET ambiguo** | Non chiaro significato | ⚠️ Non analizzato finora | 62.5% "NON PREVISTO": problema di dati? |
| **Conteggio episodi** | Come contare? | ❌ Siamo caduti nella trappola! | Abbiamo contato RIGHE, non comunicazioni uniche |
| **Granularità vittima** | Multi-vittima? | ✅ Confermato: stessa riga per più vittime | Deve essere chiarito |

---

## Impatto su analisi precedente (task-001)

**Scoperta critica**: Nel contare art. 387 bis nel file_6, abbiamo contato **RIGHE** (68), non **COMUNICAZIONI UNICHE**.

Se PROT_SDI duplicato per vittima:
- 68 righe potrebbe = 30-40 comunicazioni uniche
- **Conteggio reale ancora più basso** vs ISTAT

**Necessario ri-contare quando Ministero chiarisce chiave primaria**.

---

## Conclusione

Le issue di **lalafrufru sono FONDAMENTALI** per validare file_6:

1. ✅ **Chiave primaria assente** → Rende conteggio inaffidabile
2. ✅ **DES_OBIET non documentato** → Metadata mancante
3. ✅ **Implicazioni nostre**: Conteggi potrebbero essere **sopravvalutati** (righe duplicate)

Questi problemi **devono essere esposti nella lettera Ministero**, insieme alle osservazioni di Rossella.

---

## Link GitHub issue

- [Issue #1: Chiave del file 90_6](https://github.com/ondata/dati_sdi_reati_genere/issues/1)
- [Issue #2: Significato DES_OBIET](https://github.com/ondata/dati_sdi_reati_genere/issues/2)
