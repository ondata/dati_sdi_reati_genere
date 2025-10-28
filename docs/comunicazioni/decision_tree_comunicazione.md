# Decision Tree: Scelta canale comunicazione Ministero

## Flusso decisionale

```
┌─ INIZIO: Comunicazione a Ministero su FOIA data quality
│
├─ DOMANDA 1: Qual è l'obiettivo primario?
│  │
│  ├─ [A] Diagnosi rapida (feedback preliminare)
│  │  └─ → Canale: EMAIL ESPLORATIVA
│  │     Vantaggio: Veloce, dialogo aperto
│  │     Tempistica: 1-2 settimane risposta
│  │
│  ├─ [B] Documentazione formale per tracking FOIA
│  │  └─ → Canale: COMUNICAZIONE FORMALE (PEC)
│  │     Vantaggio: Tracciato, SLA di legge
│  │     Tempistica: 30 giorni per legge
│  │
│  └─ [C] Community engagement + Advocacy
│     └─ → Canale: GITHUB ISSUE (se Ministero ha repo)
│        Vantaggio: Trasparenza massima, community
│        Tempistica: Variabile
│
├─ DOMANDA 2: Chi deve firmare?
│  │
│  ├─ [A1] Individuo (Andrea)
│  │  └─ Formato: Mail / CV personale
│  │
│  ├─ [B1] Period Think Tank (richiedenti FOIA)
│  │  └─ Formato: Lettera intestata / PEC istituzionale
│  │
│  ├─ [C1] datiBeneComune (partner trasparenza)
│  │  └─ Formato: Lettera congiunta
│  │
│  └─ [D1] Collettivo (tutti sopra)
│     └─ Formato: Comunicato congiunto
│
├─ DOMANDA 3: Urgenza?
│  │
│  ├─ [LOW] Nessuna urgenza
│  │  └─ → Canale formale (PEC) ok
│  │
│  ├─ [MEDIUM] Feedback utile per proseguire task-001
│  │  └─ → Canale mail esplorativa (2-3 settimane max)
│  │
│  └─ [HIGH] Risultati urgenti per pubblicazione
│     └─ → Canale mail + phone call informale
│
├─ DOMANDA 4: Allegati?
│  │
│  ├─ Se EMAIL ESPLORATIVA:
│  │  └─ ❌ NO allegati pesanti
│  │     → Link a GitHub repository
│  │
│  └─ Se COMUNICAZIONE FORMALE:
│     └─ ✅ SÌ allegati strutturati
│        → findings + CSV + template metadati
│
└─ FINE: Esecuzione comunicazione
```

---

## Scenario raccomandato: Email esplorativa (STAGE 1)

**Perché**: 
- ✅ Conosci prima la disponibilità del Ministero
- ✅ Feedback rapido
- ✅ Meno formale, più dialogo
- ✅ Se positivo → poi comunicazione formale

**Chi firma**: Period Think Tank (come richiedenti originali FOIA)

**Destinatari**:
- A: ufficio.foia@interno.it (o indirizzo specifico Dipartimento)
- CC: datiBeneComune, supporto tecnico

**Corpo mail**: 

```
Spett.le Dipartimento della Pubblica Sicurezza,

Grazie per la risposta alla richiesta FOIA MI-123-U-A-SD-2025-90.

Nel corso dell'analisi del dataset, abbiamo rilevato alcune discrepanze 
tra i dati forniti e il report ufficiale ISTAT "Codice Rosso 2020".

Prima di procedere con una comunicazione formale, vorremmo verificare 
con voi se:

1. Disponibilità a discutere data quality issues?
2. Quando prevedete consolidamento dati 2024?
3. Possibilità fornire metadati su estrazione/consolidamento?

Rimaniamo disponibili per dialogo costruttivo.

Allegato: link GitHub con analisi tecnica
[link]

Cordiali saluti,
Andrea [cognome], Period Think Tank
```

**Allegati**: NESSUNO (solo link)

**Timeline attesa**: 10-20 giorni

---

## Scenario alternativo: Comunicazione formale (STAGE 2)

**Se Stage 1 non ha esito positivo**:
- A giorno 20-30 senza risposta → escalation a comunicazione formale
- Canale: PEC (tracciato legale)
- Allegati: full package (findings + CSV + template)

---

## Checklist Esecuzione

### PRE-INVIO

- [ ] Definire mittente (chi firma?)
- [ ] Definire destinatari (trovare indirizzo corretto Ministero)
- [ ] Rileggere mail per tone e chiarezza
- [ ] Preparare link GitHub (verificare che dati siano pubblici/visibili)
- [ ] Backup locale comunicazione inviata

### INVIO

- [ ] Invia mail
- [ ] Salva copia in `docs/comunicazioni/log_invii.txt`
- [ ] Nota data/ora/mittente

### TRACKING

- [ ] Aggiungi reminder calendario: giorno 14 (verifica risposta)
- [ ] Aggiungi reminder calendario: giorno 30 (eventuale follow-up)
- [ ] Monitora inbox per risposta

### POST-RISPOSTA

- [ ] Documenta risposta in log
- [ ] Se positiva: procedi con Stage 2 (metadati formali)
- [ ] Se negativa/nulla: valuta escalation

---

## Contatti Ministero (da verificare)

- **Ufficio FOIA generale**: [trovare indirizzo]
- **Dipartimento Pubblica Sicurezza**: [trovare indirizzo]
- **Servizio Analisi Criminale**: [trovare indirizzo]
- **PEC istituzionale**: [trovare]

**TODO**: Cercare sul sito Interno.it gli indirizzi corretti.

---

## Timeline consigliata

| Fase | Giorno | Azione |
|------|--------|--------|
| **Stage 1: Email** | 0 | Invio mail esplorativa |
| **Attesa** | 1-14 | Monitoraggio inbox |
| **Valutazione** | 15 | Decisione: proseguire Stage 2? |
| **Stage 2: Formale** | 16-30 | (se necessario) Comunicazione PEC |
| **SLA legge FOIA** | 30 | Termine per risposta formale |
| **Follow-up** | 45 | Escalation se no risposta |

---

## Note di stile

### Email esplorativa: TONO CONSIGLIATO

```
✅ "Grazie per la trasparenza"
✅ "Nel nostro audit abbiamo notato..."
✅ "Vorremmo capire se è dato incompleto o nostro errore"
✅ "Disponibili a collaborare"

❌ "I vostri dati sono sbagliati"
❌ "Dovete fornire..."
❌ "Faremo escalation"
❌ "È illegittimo"
```

### Comunicazione formale: TONE CONSIGLIATO

```
✅ "Apprezzamento per trasparenza"
✅ "Richieste costruttive e specifiche"
✅ "Allegati tecnici supportano richieste"
✅ "Dialogo win-win per utilità pubblica"

❌ Tono lamentoso
❌ Minacce
❌ Linguaggio legale aggressivo
```
