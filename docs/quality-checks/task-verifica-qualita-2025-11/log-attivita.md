# Log Attività: Verifica Qualità Dati Ministero

Log giornaliero attività macro-task verifica qualità. Entry più recenti in alto.

---

## 2025-11-15

### Setup Progetto (mattina)

- Creata struttura cartelle task-verifica-qualita-2025-11/
- Creato roadmap.md con piano 4 fasi
- Definiti deliverable per ciascuna fase
- Sottocartelle create: fase-1-metadati, fase-2-validazione-rossella, fase-3-audit-completo, fase-4-comunicazione
- Aggiornato roadmap con obiettivo finale: richiesta dati integrativa Ministero
- Documenti chiave identificati: doc FOIA PERIOD.pdf, risposta sudano.pdf

### Fase 1: Analisi Metadati (pomeriggio) - ✅ COMPLETATA

**Attività svolte**:

- Estrazione metadati Excel FILE_5 (openpyxl): 10 fogli, 1.11 MB, creato 28 apr, modificato 9 mag
- Estrazione metadati Excel FILE_6 (openpyxl): 1 foglio, 0.73 MB, 28 colonne, 5.124 righe dati
- Analisi PDF richiesta FOIA (18 apr 2025, Giulia Sudano - Period Think Tank)
- Analisi PDF risposta Ministero (9 mag 2025, protocollo MI-123-U-A-SD-2025-90)
- Identificazione 15 gap critici + 12 gap importanti
- Confronto vs standard DCAT-AP_IT: 22% conforme

**Deliverable prodotti**:

1. `fase-1-metadati/metadati_file5.md` (struttura 10 fogli, proprietà Excel, gap identificati)
2. `fase-1-metadati/metadati_file6.md` (schema 28 colonne, scope filtro relazione V-A, problemi noti)
3. `fase-1-metadati/analisi_pdf.md` (confronto richiesta vs risposta, timeline FOIA, requisiti soddisfatti/non soddisfatti)
4. `fase-1-metadati/gap_metadati.md` (15 critici, 12 importanti, confronto DCAT-AP_IT)
5. `fase-1-metadati/checklist_metadati_richiesti.md` (27 domande strutturate per Ministero)

**Gap critici identificati** (top 5):

1. Data estrazione SDI/SSD/DCPC: non specificata
2. Scope FILE_6: % copertura relazione V-A non documentata
3. Chiave primaria FILE_6: PROT_SDI duplicato (issue #1)
4. Discrepanze vs ISTAT: 100% missing art. CR 2019-2020 non spiegato
5. Codici ISTAT geo + ISO nazioni: assenti

**Stato**:

- ✅ Fase 1: COMPLETATA
- ⏸️ Fase 2: PENDING (pronta per iniziare)
- ⏸️ Fase 3-4: PENDING

**Note chiave**:

- FILE_5: Metadati Excel quasi tutti assenti (autore, titolo, descrizione, keywords)
- FILE_6: Autore "Apache POI", modifica "cla" (utente generico), suggerisce export automatizzato
- Risposta Ministero: 21 giorni (conforme termini FOIA), MA metadati inadeguati
- Pubblicazione online richiesta in FOIA: non fornita, non menzionata in risposta
- Conformità DCAT-AP_IT: solo 2/9 metadati obbligatori presenti (22%)

**Prossimi step**:

- Attendere conferma utente per procedere con Fase 2
- Fase 2: Validazione approfondita note Rossella (query SQL, confronto ISTAT, lag temporale)
