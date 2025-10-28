# task-002-comunicazione-ministero

Status: in-progress | Priorità: high

## Descrizione

Comunicare al Dipartimento della Pubblica Sicurezza del Ministero dell'Interno le problematiche di data quality identificate nell'analisi dei dati FOIA (MI-123-U-A-SD-2025-90), con richieste concrete di integrazione metadati e riconciliazione dati storici.

## Contesto

- **FOIA**: richiesta inviata 18 aprile 2025 da Avv. Giulia Sudano (Period Think Tank)
- **Destinatario**: Dipartimento della Pubblica Sicurezza, Ministero dell'Interno
- **Riferimento**: Task-001 findings (undercount -90% fattispecie Codice Rosso vs ISTAT 2020)

## Brutture dati identificate

### 1. Undercount Fattispecie Codice Rosso (ago 2019 – ago 2020)

| Reato | ISTAT 2020 | FOIA ricevuto | Delta |
|-------|-----------|---|---|
| Art. 558 bis (matrimonio forzato) | 11 | 0-1 | **-90%** 🔴 |
| Art. 583 quinquies (deformazione viso) | 56 | 1 | **-98%** 🔴 |
| Art. 612 ter (revenge porn) | 718 | ~1.230 | -43% ⚠️ |
| Art. 387 bis (violazione allontanamento) | 1.741 | ~2.500 | +40% |

**Impatto**: Impossibile validazione vs benchmark ufficiale. Utenti ricerca pensano dati siano completi.

---

### 2. Mancanza Metadati Critici

**Non presenti nei file**:
- ❌ Data estrazione dal sistema SDI
- ❌ Data consolidamento dati
- ❌ Significato "non consolidato" (quali righe varieranno?)
- ❌ Versione schema SDI (retroactive updates?)
- ❌ Mapping codici reato ↔ articoli c.p.
- ❌ Granularità temporale (data inizio/fine fatto vs denuncia)
- ❌ Changelog versioni per anni 2019-2024

**Impatto**: Impossibile verificare affidabilità dati. Confusione su periodo di riferimento.

---

### 3. Mismatch Aggregazione Temporale

- **FOIA**: anno civile (2019, 2020, 2021...)
- **Report ISTAT Codice Rosso 2020**: anno fiscale (9 agosto 2019 – 8 agosto 2020)
- **Risultato**: Impossibile riconciliazione precisa

**Impatto**: Utenti non riescono a validare dati storici vs report ufficiali.

---

### 4. Problematiche Strutturali

| Problema | Dettaglio | Impatto |
|----------|-----------|--------|
| Descrizione reati full-text | "COSTRIZIONE O INDUZIONE AL MATRIMONIO" anziché "art. 558 bis" | Difficile parsing automatico, ambiguità |
| NULL geografici | 0.5-0.7% sparsità in campi provincia | Dati incompleti, non spiegato perché |
| File_5 vs File_6: mancanza chiave esterna | Non è possibile JOIN sicuro tra dataset | Cross-analisi impedita |
| Nomi colonne non standardizzati | "provinciauts_corretto", "codice_provincia_storico", "codice_provinciauts" | Confusione mappatura ISTAT |

---

### 5. Assenza Documentazione Qualità

- ❌ Data lineage (da quale sistema proviene ogni colonna?)
- ❌ Known issues log
- ❌ Roadmap consolidamento 2024 (quando dati saranno stabili?)
- ❌ Spiegazione variabilità "non consolidato"

---

## Sottoattività

### Fase 1: Preparazione
- [ ] Definire firmatari (Andrea? Period Think Tank? datiBeneComune?)
- [ ] Raccogliere contatti ufficio FOIA Ministero
- [ ] Stabilire canale comunicazione (mail, portale FOIA, GitHub?)
- [ ] Redigere bozza lettera

### Fase 2: Bozza Lettera
- [ ] Stesura professionale, non accusatoria
- [ ] Framing: "migliorare riuso dati pubblici" (non "errori")
- [ ] Richieste specifiche (integrate, non generiche)
- [ ] Tone: "apprezzamento trasparenza" + "aiutateci a completare il quadro"

### Fase 3: Allegati Tecnici
- [ ] `findings_rossella_validazione.md` (evidence)
- [ ] `analisi_temporale_codice_rosso.csv` (numeri)
- [ ] Template metadati proposto
- [ ] Mappatura richiesta (codici reato ↔ articoli)

### Fase 4: Invio e Tracking
- [ ] Invio comunicazione
- [ ] Tracking risposta (SLA?)
- [ ] Eventuale follow-up

---

## Richieste specifiche da indirizzare

### Riconciliazione dati storici

```
Richiesta: Per le fattispecie introdotte da Codice Rosso (art. 558 bis, 583 quinquies, 612 ter, 387 bis),
fornire dati periodo agosto 2019 – agosto 2020 riconciliati con report ufficiale ISTAT
"Violenza contro le donne – Un anno di Codice Rosso" (ottobre 2020), al fine di validare
completezza e affidabilità dataset.
```

### Metadati strutturali

```
Richiesta: Documento metadati per ogni foglio Excel, includente:
- Data estrazione dal sistema SDI (per ogni anno)
- Data consolidamento (quando dati divengono "ufficiali"?)
- Significato "non consolidato" per 2024 (quali righe varieranno?)
- Versione schema SDI (ci sono stati aggiornamenti?)
- Mapping colonne → sistema di origine
- Spiegazione NULL geografici (0.5-0.7% di sparsità)
```

### Granularità temporale

```
Richiesta: Se disponibili in SDI, fornire (o integrare nei file):
- data_inizio_fatto (quando è avvenuto il reato)
- data_denuncia (quando è stata sporta denuncia)
- data_registrazione_sdi (quando è stato registrato in SDI)
Questo permetterebbe di spiegare lag temporale e validare se denunce 2019-2020
sono state registrate post-hoc.
```

### Standardizzazione codici reato

```
Richiesta: Colonna aggiuntiva con codice articolo c.p. standardizzato (es. "558 bis", "387 bis")
anziché full-text description, per facilitare parsing e riconciliazione automatica.
```

### Roadmap consolidamento

```
Richiesta: Indicazione roadmap consolidamento dati 2024. Quando saranno disponibili dati stabili?
Prevedete aggiornamenti retroattivi su anni precedenti?
```

---

## Deliverable

- `docs/comunicazioni/lettera_ministero_draft.md` (bozza lettera)
- `docs/comunicazioni/checklist_allegati.md` (lista allegati)
- `docs/comunicazioni/template_metadati.csv` (proposta schema)
- Log tracking risposta

---

## Note

- **Tone critico**: è importante essere **chiari sulle problematiche** senza essere accusatori
- **Riconoscimento**: apprezzare sforzo trasparenza del Ministero
- **Utilità pubblica**: enfatizzare che metadati migliori = riuso migliore = valore pubblico
- **Non tecnico**: tradurre problematiche tecniche in linguaggio accessibile (ma preciso)

---

## Deliverable generati

✅ **Infrastruttura comunicazione**:
1. `lettera_ministero_draft.md` – Bozza lettera (versione esplorativa)
2. `template_metadati.md` – Proposta schema metadati da allegare
3. `checklist_allegati.md` – Guida allegati per diversi canali
4. `decision_tree_comunicazione.md` – Flowchart scelta canale + timing
5. `log_comunicazioni.md` – Tracking risposte

**Raccomandazione operativa**:
- **Stage 1**: Email esplorativa (leggera, no allegati pesanti)
  - Se positivo → Stage 2 (comunicazione formale con full docs)
  - Timeline: 10-20 giorni per risposta
  
- **Stage 2** (se necessario): Comunicazione PEC formale
  - Con allegati full package
  - SLA legale: 30 giorni

---

## Prossimi step concreti

### Azione 1: Definire mittente e contatti Ministero
- [ ] Chi firma? (Tu / Period Think Tank / Collettivo?)
- [ ] Trovare indirizzo email/PEC ufficio FOIA Ministero
- [ ] Trovare contatto Dipartimento Pubblica Sicurezza

### Azione 2: Personalizzare bozza lettera
- [ ] Adattare `lettera_ministero_draft.md` con dati specifici
- [ ] Verificare tone e professionalità
- [ ] Preparare link GitHub (verificare accessibilità)

### Azione 3: Invio Stage 1
- [ ] Inviare mail esplorativa
- [ ] Registrare in `log_comunicazioni.md`
- [ ] Impostare reminder calendario (giorno 14, 30)

### Azione 4: Monitoraggio
- [ ] Risposta positiva? → Procedi Stage 2
- [ ] Risposta parziale? → Follow-up specifico
- [ ] No risposta? → Valutare escalation giorno 45

---

## Domande aperte (per discussione)

1. **Chi dovrebbe firmare?** 
   - Opzioni: Tu personalmente / Period Think Tank / datiBeneComune / Collettivo
   - Consiglio: Period Think Tank (come richiedenti FOIA originali)

2. **Timeline prioritario?**
   - Se nessuna urgenza: Stage 1 + Stage 2 sequenziale
   - Se urgenza: Skip Stage 1, direttamente PEC formale

3. **Escalation policy**:
   - Se no risposta dopo 30 giorni: advocacy pubblica? Social media?
   - Oppure: mantieni riservatezza e contatta datiBeneComune partner?

4. **Budget comunicazione**:
   - Solo mail/GitHub (gratis)?
   - O anche physical mail / follow-up telefonico (paid)?
