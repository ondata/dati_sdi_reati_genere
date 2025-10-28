# DISCREPANZA CRITICA: Note Rossella vs File XLS Originali

**Data**: 2025-10-28

**Conclusione**: ⚠️ Le note di Rossella e i dati attuali dei file XLS NON CORRISPONDONO

---

## Cosa Rossella ha detto

> Per la **fattispecie ex art. 558 bis c.p.**, i dati grezzi del Ministero non riportano casi (risultano solo 8 casi, però relativi all'annualità 2024), mentre il report ufficiale ne indica **11** per il periodo considerato.

> Per la **fattispecie ex art. 583 quinquies c.p.**, il file fornito segnala **un solo caso** (anch'esso riferito al 2024), mentre il report ministeriale ne riporta **56** tra agosto 2019 e agosto 2020.

> Infine, per l'**art. 387 bis c.p.**, il nostro file indica **69 casi** (riferiti però agli anni 2023–2024), ma **nessuno nel 2019–2020**, a fronte dei **1.741** casi segnalati nel report ministeriale per lo stesso periodo.

---

## Cosa dicono i file XLS ATTUALI

File: `MI-123-U-A-SD-2025-90_5.xlsx`, Foglio: `Codice Rosso - Commessi`

| Reato | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 |
|-------|------|------|------|------|------|------|
| **Art. 558 bis** | **7** | **8** | 24 | 14 | 29 | 25 |
| **Art. 583 quinquies** | **25** | **56** | 91 | 104 | 94 | 93 |
| **Art. 387 bis** | **658** | **1836** | 2181 | 2529 | 2575 | 3347 |

---

## Confronto periodo agosto 2019 – agosto 2020

### Art. 558 bis

| Fonte | Valore |
|-------|--------|
| Rossella | **0 casi** (2019-2020) |
| ISTAT | 11 casi |
| File XLS attuale | **7 (2019) + 8 (2020) = 15 casi** |
| **Delta Rossella vs XLS** | **-15 (100% differenza!)** |

### Art. 583 quinquies

| Fonte | Valore |
|-------|--------|
| Rossella | **0 casi** (2019-2020) |
| ISTAT | 56 casi |
| File XLS attuale | **25 (2019) + 56 (2020) = 81 casi** |
| **Delta Rossella vs XLS** | **-81 (100% differenza!)** |

### Art. 387 bis

| Fonte | Valore |
|-------|--------|
| Rossella | **0 casi** (2019-2020) |
| ISTAT | 1.741 casi |
| File XLS attuale | **658 (2019) + 1.836 (2020) = 2.494 casi** |
| **Delta Rossella vs XLS** | **-2.494 (100% differenza!)** |

---

## Possibili spiegazioni

### Ipotesi 1: Rossella ha usato file_6, non file_5

Rossella potrebbe aver contato dal file **file_6** (MI-123-U-A-SD-2025-90_6.xlsx - comunicazioni SDI con relazioni), non dal file_5 aggregato per provincia.

**File_6 è granulare** (una riga per comunicazione) e contiene date specifiche (DATA_INIZIO_FATTO, DATA_DENUNCIA).

Se ha filtrato per **anno di denuncia** (DATA_DENUNCIA) nel periodo agosto 2019 – agosto 2020, potrebbe aver trovato ZERO casi per queste fattispecie.

### Ipotesi 2: I dati sono stati aggiornati

File XLS ricevuti da Rossella potevano essere **diversi** da quelli attuali, oppure il Ministero ha fatto **aggiornamenti retroattivi** tra il momento delle sue verifiche e adesso.

### Ipotesi 3: Rossella ha applicato filtri complessi

Rossella cita:
> "Ho applicato un filtro (agosto 2019 – agosto 2020)"

Potrebbe aver usato filtri su:
- DATA_INIZIO_FATTO vs DATA_DENUNCIA (non solo anno)
- Periodo fisso agosto-agosto, non anno civile
- Conteggio su file_6 granulare, non su file_5 aggregato

---

## Raccomandazione

🔴 **CRITICA**: Prima di mandare lettera al Ministero, **chiarire con Rossella**:

1. Quale FILE ha usato? (file_5 o file_6?)
2. Quale COLONNA data ha usato? (DATA_INIZIO_FATTO o DATA_DENUNCIA?)
3. Quando ha fatto l'analisi? (I file sono stati aggiornati?)
4. Come ha conteggiato il periodo agosto 2019 – agosto 2020?

Senza questo chiarimento, la lettera al Ministero potrebbe contenere dati **inesatti rispetto ai file XLS attuali**.

---

## Conseguenza sulla lettera al Ministero

Se la lettera dice "i vostri dati non hanno art. 558 bis nel periodo ago19-ago20" ma il file XLS mostra 7+8=15 casi, il Ministero potrebbe rispondereche i NOSTRI dati sono sbagliati, non i loro.

**Necessario chiarire metodologia di Rossella PRIMA di inviare lettera.**
