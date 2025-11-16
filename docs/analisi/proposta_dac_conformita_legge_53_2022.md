# Proposta di integrazione dati per conformità alla Legge 53/2022

**Destinatario:** Dipartimento della Pubblica Sicurezza - Ministero dell'Interno

**Riferimento:** Dataset SDI/SSD - Protocollo MI-123-U-A-SD-2025-90 del 09/05/2025

**Data:** 2025-11-16

**Oggetto:** Integrazione tracciato dati SDI reati di genere in conformità alla Legge 21/04/2022 n. 53

## Sintesi esecutiva

Il dataset SDI/SSD attualmente fornito dal Dipartimento della Pubblica Sicurezza (file MI-123-U-A-SD-2025-90_6.xlsx, fornito in risposta ad istanza di accesso civico) rappresenta un ottimo punto di partenza per il monitoraggio della violenza di genere. Tuttavia, confrontando il tracciato con i requisiti della Legge 53/2022 "Disposizioni in materia di statistiche in tema di violenza di genere", emergono alcune lacune informative che limitano la piena conformità normativa e l'efficacia delle politiche di prevenzione e contrasto.

**Base normativa Ministero Interno:** Art. 5, comma 1 - Il Ministero dell'interno provvede a dotare il Centro elaborazione dati (CED) di funzionalità che consentano di rilevare informazioni utili a definire la relazione autore-vittima e altri dati obbligatori.

## Dati attualmente presenti (punti di forza)

Il dataset include già elementi fondamentali richiesti dalla normativa:

- **Relazione autore-vittima** (Art. 2, comma 2 e Art. 5, comma 1): presente con 15 modalità conformi
- **Caratteristiche anagrafiche**: sesso ed età di autore e vittima (Art. 5, comma 1 e Art. 6, comma 1)
- **Nazionalità**: paese di nascita di autore e vittima
- **Informazioni geografiche**: regione, provincia, comune
- **Informazioni temporali**: data inizio/fine fatto, data denuncia
- **Tipologia reato**: articolo di legge e descrizione

## Criticità strutturale del dataset (PRIORITÀ MASSIMA)

### Assenza di identificativo univoco di riga

**Problema:** Il dataset contiene **5124 righe** ma solo **2644 valori univoci di PROT_SDI**. Questo significa che lo stesso protocollo SDI può generare più righe quando:

- Sono contestati più reati contemporaneamente allo stesso evento
- Ci sono più vittime nello stesso evento
- Combinazione dei due casi precedenti

**Conseguenze:**

- **Impossibile riferirsi univocamente a una specifica riga** del dataset
- **Difficoltà nella gestione di aggiornamenti e correzioni**: quale riga va modificata?
- **Problemi di integrità referenziale** in sistemi database
- **Impossibilità di tracciare modifiche** nel tempo su righe specifiche
- **Ambiguità nelle analisi**: conteggi per evento vs conteggi per riga

**Proposta:** Introdurre campo `ID_RIGA` con identificativo univoco assoluto per ogni riga:

- Formato suggerito: `PROT_SDI` + progressivo (es. `RMPC212024000072_001`)
- Oppure: UUID autogenerato
- Oppure: Intero progressivo auto-incrementante

**Priorità:** **MASSIMA** - Questa è una precondizione per qualsiasi elaborazione avanzata dei dati e per la loro gestione nel tempo.

## Dati mancanti richiesti dalla Legge 53/2022

### 1. Tipologia di violenza (Art. 4, comma 2, lettera a)

**Normativa:** "la tipologia di violenza, fisica, sessuale, psicologica o economica, esercitata sulla vittima"

**Lacuna:** Il dataset non categorizza esplicitamente la tipologia di violenza. Questa informazione è deducibile solo indirettamente dall'articolo di legge violato.

**Proposta:** Aggiungere campo categorico che classifichi ogni evento secondo le 4 tipologie:

- Violenza fisica
- Violenza sessuale
- Violenza psicologica
- Violenza economica

**Beneficio:** Facilita analisi statistiche aggregate e confronti con l'indagine campionaria ISTAT triennale.

### 2. Presenza di figli sul luogo del fatto (Art. 2, comma 2; Art. 4, comma 2, lettera b; Art. 5, comma 1)

**Normativa:** "violenza [...] anche alla presenza sul luogo del fatto dei figli degli autori o delle vittime" (citato in almeno 4 articoli)

**Lacuna:** Dato completamente assente.

**Proposta:** Aggiungere campo binario o categorico:

- Presenza di figli minorenni sul luogo del fatto (Sì/No/Non noto)
- Eventualmente: numero di figli presenti (opzionale)

**Beneficio:** Consente di quantificare i casi di violenza assistita, fenomeno con gravi ripercussioni psicologiche sui minori e rilevante per l'applicazione di aggravanti.

### 3. Presenza di atti persecutori (Art. 4, comma 2, lettera b; Art. 5, comma 1)

**Normativa:** "se la violenza è commessa unitamente ad atti persecutori"

**Lacuna:** Non esiste un campo specifico che indica se la violenza è associata a stalking/atti persecutori (Art. 612-bis CP).

**Proposta:** Aggiungere campo binario:

- Violenza con atti persecutori (Sì/No)

**Nota:** Attualmente il dato è parzialmente deducibile solo quando l'Art. 612-bis compare come reato contestato, ma non nei casi in cui gli atti persecutori accompagnano altri reati.

### 4. Tipologia di arma utilizzata (Art. 5, comma 1; Art. 6, comma 1)

**Normativa:** "la tipologia di arma eventualmente utilizzata"

**Lacuna:** Dato assente.

**Proposta:** Aggiungere campo categorico:

- Arma da fuoco
- Arma bianca
- Oggetto contundente
- Sostanze chimiche/acidi
- Nessuna arma
- Altro
- Non noto

**Beneficio:** Fondamentale per valutazione del rischio e analisi della letalità potenziale degli episodi.

### 5. Indicatori di rischio di revittimizzazione (Art. 4, comma 2, lettera c)

**Normativa:** "gli indicatori di rischio di revittimizzazione previsti dall'allegato B al decreto del Presidente del Consiglio dei ministri 24 novembre 2017"

**Lacuna:** Gli indicatori di rischio non sono rilevati.

**⚠️ NOTA IMPORTANTE:** La Legge 53/2022 **rinvia al DPCM 24/11/2017, Allegato B** per l'elenco ufficiale degli indicatori. Non specifica quali indicatori, ma fa riferimento esplicito alle Linee guida nazionali per assistenza socio-sanitaria donne vittime violenza.

**Proposta:** Integrare gli indicatori **come definiti nell'Allegato B del DPCM 24/11/2017** (documento da acquisire per elenco vincolante).

A titolo indicativo, gli indicatori comuni includono:

- Precedenti denunce/episodi tra stessi soggetti
- Escalation della violenza
- Minacce di morte
- Disponibilità/uso armi
- Violazione misure protezione precedenti
- Dipendenza economica vittima
- Isolamento sociale vittima

**Azione preliminare:** Consultare DPCM 24/11/2017, Allegato B per elenco ufficiale completo.

**Beneficio:** Permette di identificare casi ad alto rischio e attivare misure di protezione urgenti secondo protocolli nazionali validati.

### 6. Informazioni procedurali (Art. 5, comma 5)

**Normativa:** "misure di prevenzione applicate dal questore o dall'autorità giudiziaria, misure precautelari, misure cautelari, ordini di protezione e misure di sicurezza"

**Lacuna:** Il dataset non include informazioni su:

- Misure applicate (ammonimento del questore, allontanamento, divieto di avvicinamento, ecc.)
- Data applicazione misure
- Violazioni delle misure (Art. 387-bis CP è presente come reato ma non c'è collegamento con la misura violata)

**Proposta:** Aggiungere campi relativi a:

- Tipologia misura applicata
- Data applicazione
- Eventuale violazione della misura (flag)

**Beneficio:** Consente di valutare l'efficacia delle misure di protezione e individuare criticità nel sistema di tutela.

## Integrazioni per interoperabilità e qualità dati

### Codifiche geografiche standard (PRIORITÀ ALTA)

Attualmente i campi geografici contengono solo denominazioni testuali. Per garantire **interoperabilità** con altri dataset pubblici, **geocodifica** accurata e **analisi territoriali** corrette, si raccomanda fortemente l'adozione di classificazioni standard ufficiali.

**Problema attuale:**
- Solo denominazioni testuali (es. "Bologna", "Emilia-Romagna")
- Possibili ambiguità (45 comuni "San Giovanni" in Italia)
- Impossibile join automatico con dataset ISTAT
- Difficoltà tracciamento fusioni comunali nel tempo

**Proposta:**

#### a) Stati - Standard ISO 3166-1

Aggiungere campo `STATO_COD_ISO` con codice ISO 3166-1 alpha-3:
- `ITA` per Italia
- `FRA` per Francia
- `ROU` per Romania
- ecc.

**Benefici:** Standard internazionale, evita ambiguità denominazioni, stabilità nel tempo

#### b) Regioni - Codifica ISTAT

Aggiungere campo `REGIONE_COD_ISTAT` (2 cifre):
- `08` per Emilia-Romagna
- `12` per Lazio
- ecc.

**Riferimento:** Elenco ufficiale 20 regioni ISTAT

#### c) Province - Codifica ISTAT

Aggiungere campi:
- `PROVINCIA_COD_ISTAT` (3 cifre, es. `037` per Bologna)
- `PROVINCIA_SIGLA` (2 lettere, es. `BO`)

**Nota:** Gestire anche Città metropolitane (post-2014)

#### d) Comuni - Codifica ISTAT

Aggiungere campi:
- `COMUNE_COD_ISTAT` (6 cifre, es. `037006` per Bologna)
- `COMUNE_COD_CATASTALE` (4 caratteri, es. `A944`)

**Benefici critici:**
- ✅ Univocità assoluta (no omonimie)
- ✅ Join automatici con dataset ISTAT (popolazione, indicatori socio-economici, ecc.)
- ✅ Geocodifica per mappe e analisi spaziali
- ✅ Tracciabilità fusioni/modifiche territoriali
- ✅ Conformità linee guida Open Data AGID

**Riferimenti:**
- ISTAT: Elenco codici e denominazioni unità territoriali (aggiornamento annuale)
- ISO 3166-1: Standard internazionale codici paesi
- AGID: Linee guida valorizzazione patrimonio informativo pubblico

## Altre integrazioni consigliate (non strettamente normative)

### 7. Esito del procedimento

Sebbene non esplicitamente richiesto per i dati del Ministero dell'Interno, sarebbe utile integrare:

- Stato del procedimento (in corso/archiviato/condanna/assoluzione)
- Data dell'esito

Questo dato è previsto dal sistema interministeriale (Art. 5, comma 4) ma gioverebbe anche alle analisi del Dipartimento.

### 8. Recidiva dell'autore

**Art. 6, comma 2, lettera b:** "dati relativi a precedenti condanne a pene detentive e alla qualifica di recidivo"

Campo che indica se l'autore:

- Ha precedenti per reati contro la persona
- Ha precedenti per reati di violenza di genere
- È recidivo

### 9. Presenza di figli minori nella relazione (non sul luogo del fatto)

**Art. 2, comma 2:** "con domande relative alla presenza di figli minori di età ovvero alla presenza in casa di figli minori di età"

Distinguere:

- Presenza figli minori sul luogo del fatto (violenza assistita)
- Presenza figli minori nella coppia/famiglia (anche se non presenti al fatto)

## Raccomandazioni implementative

1. **Gradualità:** implementare le integrazioni in modo progressivo, partendo dai dati più critici (tipologia violenza, presenza figli, arma)

2. **Formazione:** formare gli operatori che inseriscono i dati sulla corretta compilazione dei nuovi campi

3. **Retroattività limitata:** per i dati già raccolti, valutare la possibilità di recupero parziale tramite analisi testuale delle descrizioni (es. tipologia violenza deducibile dalla descrizione reato)

4. **Allineamento ISTAT:** coordinare con ISTAT per garantire che le categorie usate siano compatibili con l'indagine campionaria triennale (Art. 2, comma 1)

5. **Privacy:** garantire che i nuovi campi rispettino le normative GDPR, in particolare per dati sensibili come presenza di minori

6. **Interoperabilità:** assicurare che il tracciato sia compatibile con il sistema interministeriale di raccolta dati previsto dall'Art. 5, comma 4

## Benefici attesi

L'integrazione dei dati mancanti consentirà di:

- **Conformità normativa completa** alla Legge 53/2022
- **Migliore valutazione del rischio** e protezione delle vittime
- **Analisi più accurate** del fenomeno violenza di genere
- **Politiche di prevenzione più efficaci** basate su dati completi
- **Confrontabilità** con indagini ISTAT e dati internazionali
- **Monitoraggio efficacia** delle misure di protezione
- **Identificazione casi ad alto rischio** di femminicidio

## Conclusioni

Il dataset attuale costituisce una solida base informativa, ma necessita delle integrazioni sopra indicate per raggiungere la piena conformità alla Legge 53/2022 e per supportare efficacemente le politiche di contrasto alla violenza di genere.

Si propone l'avvio di un tavolo tecnico per definire modalità e tempi di implementazione delle integrazioni, con particolare priorità per:

**PRIORITÀ MASSIMA (criticità strutturale):**

1. **Identificativo univoco di riga** (`ID_RIGA`)

**PRIORITÀ ALTA (conformità normativa):**

2. Tipologia di violenza
3. Presenza di figli sul luogo del fatto
4. Tipologia di arma
5. Misure di protezione applicate

---

**Allegato:** Schema dati proposto in formato tecnico (file separato)
