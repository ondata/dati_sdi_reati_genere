# Verifica conformità liste controllate con Legge 53/2022

## RELAZIONE_AUTORE_VITTIMA

### Confronto dataset vs normativa

**Modalità richieste dalla Legge 53/2022, Art. 2, comma 2:**

1. coniuge/convivente
2. fidanzato
3. ex coniuge/ex convivente
4. ex fidanzato
5. altro parente
6. collega/datore di lavoro
7. conoscente/amico
8. cliente
9. vicino di casa
10. compagno di scuola
11. insegnante o persona che esercita un'attività di cura e/o custodia
12. medico o operatore sanitario
13. persona sconosciuta alla vittima
14. altro
15. autore non identificato

**Modalità presenti nel dataset (15 valori):**

1. ✅ `CONIUGE/CONVIVENTE` (2160 occorrenze)
2. ✅ `FIDANZATO` (211 occorrenze)
3. ✅ `EX CONIUGE/EX CONVIVENTE` (696 occorrenze)
4. ✅ `EX FIDANZATO` (452 occorrenze)
5. ✅ `ALTRO PARENTE` (871 occorrenze)
6. ✅ `COLLEGA/DATORE DI LAVORO` (33 occorrenze)
7. ✅ `CONOSCENTE/AMICO` (210 occorrenze)
8. ✅ `CLIENTE` (9 occorrenze)
9. ✅ `VICINO DI CASA` (142 occorrenze)
10. ✅ `COMPAGNO DI SCUOLA` (18 occorrenze)
11. ✅ `INSEGNANTE O PERSONA CHE ESERCITA UN'ATTIVITA' DI CURA E/O CUSTODIA` (27 occorrenze)
12. ✅ `MEDICO O OPERATORE SANITARIO` (2 occorrenze)
13. ✅ `PERSONA SCONOSCIUTA ALLA VITTIMA` (39 occorrenze)
14. ✅ `ALTRO` (250 occorrenze)
15. ✅ `AUTORE NON IDENTIFICATO` (4 occorrenze)

### Esito verifica: ✅ CONFORME

**Risultato:** Il campo `RELAZIONE_AUTORE_VITTIMA` è **completamente conforme** alla Legge 53/2022.

Tutte le 15 modalità previste dalla normativa sono presenti nel dataset.

**Note tecniche:**

- I valori nel dataset hanno **spazi di padding a destra** (lunghezza fissa 100 caratteri)
- Formato utilizzato: SCREAMING_SNAKE_CASE per i valori composti da più parole separate da slash o spazi
- La corrispondenza è perfetta sia in termini di contenuto che di numero di modalità

## LUOGO_SPECIF_FATTO

### Valori presenti nel dataset (13 valori)

1. `NON PREVISTO/ALTRO` (3750 occorrenze) - **73% del totale**
2. `ABITAZIONE` (969 occorrenze)
3. `PUBBLICA VIA` (287 occorrenze)
4. `LOCALE/ESERCIZIO PUBBLICO` (42 occorrenze)
5. `ISTITUTO DI ISTRUZIONE` (28 occorrenze)
6. `ESERCIZIO COMMERCIALE` (14 occorrenze)
7. `OSPEDALE` (9 occorrenze)
8. `UFFICIO PUBBLICO` (9 occorrenze)
9. `ISTITUTO O CASA DI CURA` (8 occorrenze)
10. `TRENO` (3 occorrenze)
11. `LUOGO DI CULTO` (2 occorrenze)
12. `APERTA CAMPAGNA/ZONA BOSCHIVA` (2 occorrenze)
13. `INTERNET CHAT` (1 occorrenza)

### Esito verifica: ⚠️ NON VERIFICABILE

**Problema:** La Legge 53/2022 **non specifica** una lista controllata per il luogo del fatto.

**Riferimento normativo:**

- Art. 5, comma 1: richiede di rilevare "le informazioni sul luogo dove il fatto è avvenuto"
- Art. 6, comma 1: richiede "i luoghi in cui è avvenuto il fatto"

La legge **non fornisce** un elenco di modalità prestabilite per questo campo.

**Osservazione critica:** L'alta percentuale di `NON PREVISTO/ALTRO` (73% dei casi) indica che:

- La granularità della classificazione potrebbe essere insufficiente
- Molti luoghi non rientrano nelle categorie previste
- Potrebbe essere utile rivedere/ampliare le categorie

**Raccomandazione:** Analizzare i casi `NON PREVISTO/ALTRO` per capire se servono nuove categorie (es. luogo di lavoro, auto, mezzo pubblico, parco pubblico, ecc.)

## Altri campi con liste controllate

### TENT_CONS

**Valori attesi:** TENTATO, CONSUMATO

**Verifica:** ✅ Standard, non richiesto specificamente dalla legge ma corretto per classificazione penale

### T_NORMA

**Valori attesi:** CP (Codice Penale), L (Legge speciale)

**Verifica:** ✅ Standard, corretto

### SESSO_DENUNCIATO / SEX_VITTIMA / SEX_COLP_PROVV

**Valori presenti:** MASCHIO, FEMMINA, (null)

**Riferimento normativo:** Art. 5, comma 1 e Art. 6, comma 1 richiedono "l'età e il genere degli autori e delle vittime"

**Verifica:** ✅ CONFORME - La legge richiede il genere, che è presente

**Nota:** Presenza di valori null in alcuni casi (es. autori non identificati)

## ART (Articoli di legge - reati rilevati)

### Riferimento normativo

**Legge 53/2022, Art. 5, comma 3** - Elenco di 27 fattispecie di reato per cui deve essere rilevata la relazione autore-vittima.

### Articoli richiesti dalla norma (articoli base)

1. Art. 575, 576, 577 - Omicidio e aggravanti
2. Art. 581 - Percosse
3. Art. 582, 583, **585** - Lesioni personali e aggravanti
4. Art. 609-bis/ter/octies/quater/quinquies - Violenza sessuale e varianti
5. Art. 572 - Maltrattamenti familiari
6. Art. 612, 612-bis, 612-ter - Minaccia, stalking, revenge porn
7. Art. 387-bis - Violazione provvedimenti
8. Art. 558-bis - Matrimonio forzato
9. Art. 583-bis, 583-quinquies - Mutilazioni genitali, acido
10. Art. 593-ter - Interruzione gravidanza forzata
11. Art. 605 - Sequestro persona
12. Art. 610 - Violenza privata
13. Art. 614 - Violazione domicilio
14. Art. 570, 570-bis - Violazione obblighi assistenza
15. Art. **600-bis** - Prostituzione minorile
16. Art. 591 - Abbandono minore
17. Art. 635 - Danneggiamento
18. Art. 629 - Estorsione
19. Art. 643 - Circonvenzione incapace
20. Art. 601 - Tratta persone
21. L. 75/1958 art. 3 - Favoreggiamento prostituzione

### Articoli presenti nel dataset (21 articoli)

✅ Presenti: 387, 558, 570, 572, 575, 576, 577, 581, 582, 583, 591, 593, 601, 605, 609, 610, 612, 614, 629, 635, 643

❌ **Mancanti (2 articoli):**

- **Art. 585** - Circostanze aggravanti delle lesioni personali
- **Art. 600** - Prostituzione minorile (600-bis)

### Esito verifica: ⚠️ QUASI CONFORME (91% copertura)

**Risultato:** Il dataset copre **21 su 23** articoli base richiesti (91% di copertura).

**Note tecniche:**

- Il dataset usa articoli base (es. `609`) che raggruppano tutte le varianti normative (609-bis, 609-ter, ecc.)
- Questo è un approccio corretto per semplificare la classificazione
- Il campo `DES_REA_EVE` contiene la descrizione dettagliata che specifica la variante esatta

**Raccomandazione:**

Valutare se integrare gli articoli mancanti:
- **Art. 585**: Lesioni aggravate (richiesto da Art. 5, comma 3, lettera c)
- **Art. 600**: Prostituzione minorile (richiesto da Art. 5, comma 3, lettera t)

Verificare se questi reati vengono rilevati con altra codifica o se effettivamente mancano.

## Sintesi finale

| Campo | Conformità Legge 53/2022 | Note |
|-------|-------------------------|------|
| `RELAZIONE_AUTORE_VITTIMA` | ✅ CONFORME AL 100% | Tutte le 15 modalità previste presenti |
| `ART` (Articoli reati) | ⚠️ QUASI CONFORME (91%) | 21/23 articoli presenti. Mancano: 585, 600 |
| `LUOGO_SPECIF_FATTO` | ⚠️ NON VERIFICABILE | Legge non specifica modalità. 73% "NON PREVISTO/ALTRO" |
| `SESSO_*/SEX_*` | ✅ CONFORME | Genere rilevato come richiesto |
| `TENT_CONS` | ✅ CORRETTO | Standard penale |
| `T_NORMA` | ✅ CORRETTO | Standard penale |

## Raccomandazioni

1. **RELAZIONE_AUTORE_VITTIMA**: Mantenere invariata, è conforme ✅

2. **LUOGO_SPECIF_FATTO**: Rivedere le categorie data l'alta percentuale (73%) di "NON PREVISTO/ALTRO":
   - Analizzare quali luoghi sono più frequenti nei casi "ALTRO"
   - Valutare aggiunta categorie: LUOGO_LAVORO, AUTOMOBILE, MEZZI_PUBBLICI, PARCHEGGIO, PARCO, ecc.
   - Distinguere meglio tra "NON PREVISTO" e "NON NOTO"

3. **Formattazione valori**: Rimuovere padding di spazi a destra per ottimizzare storage e elaborazione
