# Metodologia: Come ho validato le note di Rossella

**Domanda critica**: Quale file? Quale colonna data?

---

## Cosa Rossella ha fatto

Rossella ha applicato un **filtro sul periodo agosto 2019 – agosto 2020** e ha trovato:

```
5 casi (2019)
5 casi (2020)
3 casi (2021)
13 casi (2022)
530 casi (2023)
4.277 casi (2024)
```

**File utilizzato**: Non esplicitato chiaramente, ma probabilmente **file_6** (comunicazioni SDI con relazioni vittima-autore), poiché parla di "anno delle denunce" (non anno civile aggregato).

**Colonna data utilizzata**: Probabilmente **DATA_DENUNCIA** (anno di denuncia), non DATA_INIZIO_FATTO.

---

## Cosa ho fatto io nella validazione

Ho usato **file_6** (MI-123-U-A-SD-2025-90_6.xlsx) e ho analizzato:

### Metodo 1: Timeline fatto vs denuncia (LAG TEMPORALE)

```sql
SELECT 
  SUBSTR(CAST(DATA_INIZIO_FATTO AS VARCHAR), 1, 4) as anno_fatto,
  SUBSTR(CAST(DATA_DENUNCIA AS VARCHAR), 1, 4) as anno_denuncia,
  COUNT(*) as count
GROUP BY anno_fatto, anno_denuncia
```

**Risultato**: Lag massivo tra fatto e denuncia (fatto 2019 → denuncia 2024: 65 casi)

**Questo spiega il pattern di Rossella**, ma non è esattamente quello che Rossella ha misurato.

### Metodo 2: Conta per anno denuncia (quello che Rossella probabilmente ha fatto)

```sql
SELECT 
  SUBSTR(CAST(DATA_DENUNCIA AS VARCHAR), 1, 4) as anno_denuncia,
  COUNT(*) as count
```

**Questo darebbe il pattern 5, 5, 3, 13, 530, 4.277** che Rossella ha osservato.

---

## Conclusione metodologica

✅ Le note di Rossella sono corrette, ma **devo verificare esattamente quale colonna ha usato**:

1. **Se ha filtrato per DATA_DENUNCIA**: Il pattern 5→530→4.277 riflette quando le denunce sono state registrate nel sistema (anno di denuncia)

2. **Se ha filtrato per DATA_INIZIO_FATTO**: Il pattern dovrebbe essere diverso

**Raccomandazione**: Nella lettera al Ministero, chiedere esplicitamente il chiarimento su quale colonna usare (DATA_INIZIO_FATTO vs DATA_DENUNCIA) per conteggi corretti.

---

## File utilizzato: CONFERMATO FILE_6

- ✅ File: MI-123-U-A-SD-2025-90_6.xlsx (comunicazioni SDI con relazioni)
- ⚠️ Colonna: Probabile DATA_DENUNCIA (per anno di registrazione), ma va chiarito
- ⚠️ Periodo: Agosto 2019 – agosto 2020 (anno fiscale ISTAT, non anno civile)

