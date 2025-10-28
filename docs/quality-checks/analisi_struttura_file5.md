# Analisi struttura File_5: Scoperta CRITICA

**Data**: 2025-10-28

**Conclusione**: ⚠️ File_5 è in **formato pivottato**, non tidy. Questo causa problematiche significative.

---

## Struttura File_5 (MI-123-U-A-SD-2025-90_5.xlsx)

### Formato attuale (PIVOTTATO)

```
Provincia    | Delitto              | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
-------------|----------------------|------|------|------|------|------|------
AGRIGENTO    | 5. TENTATI OMICIDI   | 14   | 10   | 11   | 8    | 13   | 13
AGRIGENTO    | 8. LESIONI DOLOSE    | 502  | 473  | 462  | 484  | 520  | 504
AGRIGENTO    | 9. PERCOSSE          | 105  | 98   | 78   | 97   | 117  | 145
```

**Caratteristiche**:
- ✅ Colonne per anno (2019, 2020, 2021, 2022, 2023, 2024)
- ✅ Righe per provincia + tipo delitto
- ✅ Valori: numero di casi per cella

### Formato tidy (CONSIGLIATO)

```
Provincia   | Delitto            | Anno | Valore
------------|-------------------|------|-------
AGRIGENTO   | 5. TENTATI OMICIDI | 2019 | 14
AGRIGENTO   | 5. TENTATI OMICIDI | 2020 | 10
AGRIGENTO   | 5. TENTATI OMICIDI | 2021 | 11
AGRIGENTO   | 8. LESIONI DOLOSE  | 2019 | 502
```

---

## Problemi del formato pivottato

### 1. **Difficile analisi temporale**
- Per analizzare trend 2019-2024 di un reato, bisogna leggere da sinistra a destra
- Query SQL/analitiche richiedono unpivoting manuale
- Impossibile fare SELECT WHERE anno = 2024

### 2. **Estensibilità futura**
- Se Ministero aggiunge 2025, bisogna aggiungere colonna
- Schema cambia ogni anno
- Difficile versioning

### 3. **Missing data handling**
- Non è chiaro se cella vuota = 0 oppure dato non disponibile
- Hard to distinguish: mancanza dato vs zero casi

### 4. **Aggregazione multidimensionale**
- Se vuoi aggregare per regione+anno, devi unpivotare prima
- Se vuoi filtro su provincia E anno, è complesso

### 5. **Performance query**
- Query semplice su tidy: `SELECT * FROM delitti WHERE anno = 2024 AND provincia = 'ROMA'`
- Query su pivottato: Devi specificare colonna `2024` – cambierà ogni anno

---

## Come abbiamo dovuto gestirlo

Nel nostro ETL (`scripts/etl_5.sh`), gli script **unpivotano il file**:

```bash
# ETL ripivotta il file da:
Provincia, Delitto, 2019, 2020, 2021, 2022, 2023, 2024

# A formato tidy:
anno, provincia, delitto, valore
2019, AGRIGENTO, OMICIDI, 2
2020, AGRIGENTO, OMICIDI, 3
```

**Però**: Questo è **lavoro extra** che il Ministero avrebbe dovuto fare.

---

## Impatto sulla lettera al Ministero

🔴 **NUOVO PUNTO DA AGGIUNGERE**:

```
### Formato dati pivottato (file_5)

File_5 è fornito in formato "pivottato" (anni come colonne):

Provincia | Delitto | 2019 | 2020 | 2021 | ... | 2024

Questo formato:
- Complica analisi temporale
- Rende difficile estensione futura (nuovo anno = nuova colonna)
- Richiede trasformazione (unpivoting) prima di qualsiasi analisi

Raccomandazione: Fornire file in formato "tidy" (tidy data):
- Una riga per provincia-delitto-anno
- Colonne: Provincia, Delitto, Anno, Valore

Questo è uno standard internazionale (FAIR data principles).
```

---

## Fogli in file_5 (10 fogli)

| Foglio | Contenuto | Formato |
|--------|-----------|---------|
| Omicidi DCPC | Omicidi volontari consumati | Pivottato (righe per categoria omicidio, colonne per anno) |
| Delitti - Commessi | Reati commessi | Pivottato |
| Delitti - Vittime | Vittime reati | Pivottato |
| Delitti - Segnalazioni | Segnalazioni | Pivottato (+ colonne per fascia età, sesso) |
| Reati spia - Commessi | Reati spia commessi | Pivottato |
| Reati spia - Vittime | Vittime reati spia | Pivottato |
| Reati spia - Segnalazioni | Segnalazioni reati spia | Pivottato |
| Codice Rosso - Commessi | Codice Rosso commessi | Pivottato |
| Codice Rosso - Vittime | Vittime Codice Rosso | Pivottato |
| Codice Rosso - Segnalazioni | Segnalazioni Codice Rosso | Pivottato |

---

## Conclusione

File_5 è **usabile ma non ottimale**. Il formato pivottato:
- ✅ È leggibile a occhio
- ❌ Non è "machine-friendly"
- ❌ Complica analisi quantitative
- ❌ È una scelta design subottimale

**Raccomandazione per Ministero**: Fornire entrambi i formati (pivottato per leggibilità umana, tidy per analisi).
