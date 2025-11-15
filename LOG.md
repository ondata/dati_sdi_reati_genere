# Log Attività Progetto Dati SDI Reati Genere

## 2025-11-15

### Audit Qualità Completo Dati FOIA Ministero

**Macro-task**: Verifica qualità dati SDI reati genere ricevuti via FOIA  
**Stakeholder**: Rossella, Period Think Tank, datiBeneComune  
**Protocollo**: MI-123-U-A-SD-2025-90  

#### Risultati Principali

**Conformità Legge 53/2022**: 50% (3/6 requisiti soddisfatti)

**Issue Critiche Identificate**:
1. **PROT_SDI duplicato**: 685 record (20.6%) con identificazione ambigua
2. **Dati geografici mancanti**: 2.128 record (63.9%) "NON PREVISTO/ALTRO"  
3. **Gap temporale Codice Rosso**: 0 casi 2019-2020 vs 1.741 ISTAT

**Punti di Eccellenza**:
- Relazione Vittima-Autore: 100% conforme (15/15 categorie)
- Struttura dati CSV standard e pulita
- Completezza campi principali

#### Deliverable Creati

**Fase 1 - Metadati**:
- Analisi proprietà Excel FILE_5 e FILE_6
- Gap metadatali: 15 critici, 12 importanti
- Conformità DCAT-AP_IT: 22% (solo 2/9 obbligatori)

**Fase 2 - Validazione Rossella**:
- Query SQL DuckDB riproducibili
- Confronto ISTAT vs FILE_6 quantificato
- Lag temporale 4-5 anni fatti→denunce

**Fase 3 - Audit Completo**:
- Analisi pattern duplicati PROT_SDI
- Classificazione valori DES_OBIET
- Cross-check coerenza FILE_5 vs FILE_6

**Fase 4 - Comunicazione**:
- Report esecutivo per stakeholder
- Allegati tecnici per Ministero
- Template metadati DCAT-AP_IT standard

#### Prossimi Passi

1. Revisione report con Rossella (entro 24h)
2. Approvazione comunicazione Ministero
3. Invio richiesta ufficiale integrazione dati
4. Setup monitoraggio qualità dati futuri

#### Documentazione

`docs/quality-checks/task-verifica-qualita-2025-11/` - Analisi completa  
`docs/quality-checks/task-verifica-qualita-2025-11/fase-4-comunicazione/` - Deliverable finali

---

## Prossimi Aggiornamenti

Aggiornare con:
- Esito revisione Rossella
- Risposta Ministero
- Implementazione miglioramenti qualità dati