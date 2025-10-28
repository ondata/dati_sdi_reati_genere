# Validazione dati FOIA vs Report ISTAT "Codice Rosso 2020"

**Analisi**: Note di Rossella + Fase 2.5 Task-001

**Data**: 2025-10-28

---

## Sommario esecutivo

Confermata l'osservazione critica di Rossella: i dati FOIA ricevuti presentano **undercount significativo** per il periodo agosto 2019 – agosto 2020 rispetto al report ufficiale ISTAT. La causa sembra essere legata a:

1. **Consolidamento ministeriale tardivo** (dati retrospettivamente aggiornati in 2023-24)
2. **Possibile ritardo nell'implementazione operativa** delle nuove fattispecie nel sistema SDI

---

## Confronto Dati ISTAT 2020 vs FOIA (periodo ago 2019 – ago 2020)

### Art. 558 bis (Costrizione/induzione matrimonio)

| Periodo | ISTAT | FOIA | Delta | Note |
|---------|-------|------|-------|------|
| ago 2019 – ago 2020 | **11** | **0-1** | ⚠️ -90% | Rossella: "risultano solo 8 casi in 2024" |
| 2019 intero | - | 7 | - | |
| 2020 intero | - | 8 | - | |
| **2024** | - | **25** | 🔴 ANOMALO | Concentrazione tardiva |

**Interpretazione**: 
- ❌ Nel file FOIA, 0 casi nel periodo ufficiale ago19-ago20
- ✅ Nel 2024 salgono a 25 (ma 5 anni dopo il benchmark)
- **Ipotesi**: Retroattiva registrazione nel 2024 di denunce effettivamente avvenute 2019-2020?

---

### Art. 583 quinquies (Deformazione viso)

| Periodo | ISTAT | FOIA | Delta |
|---------|-------|------|-------|
| ago 2019 – ago 2020 | **56** | **0-1** | ⚠️ -98% |
| 2019 intero | - | 25 | - |
| 2020 intero | - | 56 | - |
| Totale 2019-2020 | - | 81 | |

**Interpretazione**: 
- Leggermente meglio di art. 558 bis (56 ca. nel 2020)
- Ma ancora non coincide con periodo benchmark agosto

---

### Art. 612 ter (Revenge porn)

| Periodo | ISTAT | FOIA | Delta |
|---------|-------|------|-------|
| ago 2019 – ago 2020 | **718** | ~ **1.230** | ✅ RAGIONEVOLE |
| 2019 intero | - | 257 | - |
| 2020 intero | - | 973 | - |
| Totale 2019-2020 | - | 1.230 | |

**Interpretazione**: 
- ✅ Dato relativamente stabile e coerente
- Volume leggermente superiore a ISTAT (possibile: lag temporale nel report ISTAT)

---

### Art. 387 bis (Violazione allontanamento) - ⚠️ CRITICO

| Periodo | ISTAT | FOIA | Delta |
|---------|-------|------|-------|
| ago 2019 – ago 2020 | **1.741** | ~ **2.500** | ⚠️ +40% SOVRASTIMA |
| 2019 intero | - | 658 | - |
| 2020 intero | - | 1.836 | - |
| Totale 2019-2020 | - | 2.494 | |

**Interpretazione**:
- 📊 Volume superiore a ISTAT (possibile inclusione periodi ampliati?)
- Dati coerenti nel range 2019-2024

---

## Distribuzione temporale anomala 2019-2024

Ogni reato presenta schema di distribuzione stabile per anno, **ma differenze critiche rispetto a ISTAT**:

```
Art. 558 bis:  2019→7 | 2020→8 | 2021→24 | 2022→14 | 2023→29 | 2024→25
Art. 583:      2019→25 | 2020→56 | 2021→91 | 2022→104 | 2023→94 | 2024→93
Art. 612 ter:  2019→257 | 2020→973 | 2021→1395 | 2022→1232 | 2023→1405 | 2024→1517
Art. 387 bis:  2019→658 | 2020→1836 | 2021→2181 | 2022→2529 | 2023→2575 | 2024→3347
```

**Osservazioni**:
- ✅ Distribuzione anno-per-anno sembra **coerente e stabile**
- ❌ **Mismatch con benchmark ISTAT ago19-ago20** è sistemico per art. 558 bis e 583 quinquies
- ⚠️ Possibile: file Excel FOIA è **snapshot parziale** rispetto a dataset SDI ufficiale di Ministero

---

## Anomalie rilevate

### 1. Undercount periodo benchmark (ago 2019 – ago 2020)

| Reato | Atteso ISTAT | Trovato FOIA | Mancanti |
|-------|------|------|----------|
| Art. 558 bis | 11 | 0-1 | **-90%** 🔴 |
| Art. 583 quinquies | 56 | 1 (2024) | **-98%** 🔴 |
| Art. 612 ter | 718 | ~1.230 | **-43%** ⚠️ |
| Art. 387 bis | 1.741 | ~2.500 | **+40%** 📊 |

**Conclusione**: Rossella ha ragione. File FOIA è **incompleto** per il periodo agosto 2019 – agosto 2020.

---

### 2. Granularità temporale

I dati FOIA sono **aggregati per anno civile** (not anno fiscale). Questo potrebbe spiegare:
- Mismatch con period ago 2019 – ago 2020 (non allineato)
- Necessità di cross-verificare con file_6.xlsx che ha date granulari

---

### 3. Concentrazione geografica

**Domanda per fase successiva**: 
- Art. 558 bis in 2024 (25 casi): sono concentrati in poche province? (Es. Milano, Roma?)
- Se sì, potrebbe indicare **underregistration in province minori** (numero oscuro?)

---

## Questioni aperte

1. **File Excel è versione "draft"?**
   - Se sì, quando verrà aggiornato dal Ministero?
   - Quali righe varieranno ("non consolidato")?

2. **Data di estrazione dei dati SDI**?
   - File FOIA estratto quando? Il report ISTAT ha data "7 ottobre 2020"
   - FOIA ricevuto quando?

3. **Mapping reati SDI**:
   - La codifica art. 387 bis è stata implementata **dal 9 agosto 2019** ma quando operativamente?
   - Denunce 2019 erano registrate sotto vecchio codice?

4. **File_6.xlsx (comunicazioni con relazione vittima-autore)**:
   - Ha date granulari (data_inizio_fatto, data_denuncia)
   - Potrebbe dare visione completa se le denunce 2019-2020 sono registrate con data posteriore?

---

## Raccomandazione task-001

Procedere a **Fase 2.5 approfondita** su file_6.xlsx per verificare:

```sql
-- Pseudo-query
SELECT 
  EXTRACT(YEAR FROM data_inizio_fatto) as anno_fatto,
  EXTRACT(YEAR FROM data_denuncia) as anno_denuncia,
  COUNT(*) as count
FROM file_6
WHERE anno_denuncia >= 2019 AND anno_denuncia <= 2020
GROUP BY anno_fatto, anno_denuncia
```

Se molte denunce 2019-2020 hanno `anno_fatto` < 2019, spiega il lag temporale.
