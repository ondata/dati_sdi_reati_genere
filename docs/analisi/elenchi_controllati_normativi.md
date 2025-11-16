# Elenchi controllati previsti dalla Legge 53/2022

Analisi completa di tutti gli elenchi controllati esplicitamente o implicitamente richiesti dalla normativa.

## 1. RELAZIONE AUTORE-VITTIMA ✅ ESPLICITO

**Fonte normativa:** Art. 2, comma 2, ultimo periodo

**Testo:** "Con riguardo alla relazione autore-vittima l'elenco del set minimo di modalità che devono essere previste nelle rilevazioni dell'ISTAT è il seguente:"

**Elenco normativo OBBLIGATORIO (15 modalità):**

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

**Conformità dataset:** ✅ 100% CONFORME

---

## 2. TIPOLOGIA DI VIOLENZA ✅ ESPLICITO

**Fonte normativa:** Art. 4, comma 2, lettera a

**Testo:** "la tipologia di violenza, fisica, sessuale, psicologica o economica, esercitata sulla vittima"

**Elenco normativo OBBLIGATORIO (4 modalità):**

1. Violenza fisica
2. Violenza sessuale
3. Violenza psicologica
4. Violenza economica

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

**Nota:** La legge specifica esplicitamente queste 4 tipologie.

---

## 3. REATI DA RILEVARE ✅ ESPLICITO

**Fonte normativa:** Art. 5, comma 3

**Testo:** "La relazione autore-vittima [...] è rilevata, per i seguenti reati:"

**Elenco normativo OBBLIGATORIO (27 fattispecie):**

a) Art. 575 CP - Omicidio (anche tentato)
b) Art. 576 CP - Circostanze aggravanti omicidio
c) Art. 577 CP - Omicidio del coniuge
d) Art. 581 CP - Percosse
e) Art. 582 CP - Lesioni personali
f) Art. 583 CP - Circostanze aggravanti lesioni
g) Art. 585 CP - Lesioni personali aggravate ⚠️
h) Art. 609-bis CP - Violenza sessuale
i) Art. 609-ter CP - Violenza sessuale aggravata
j) Art. 609-octies CP - Violenza sessuale di gruppo
k) Art. 609-quater CP - Atti sessuali con minorenne
l) Art. 609-quinquies CP - Corruzione di minorenne
m) Art. 572 CP - Maltrattamenti familiari
n) Art. 612-bis CP - Atti persecutori
o) Art. 612-ter CP - Diffusione immagini/video (revenge porn)
p) Art. 387-bis CP - Violazione provvedimenti allontanamento
q) Art. 558-bis CP - Matrimonio forzato
r) Art. 583-bis CP - Mutilazioni genitali femminili
s) Art. 583-quinquies CP - Lesioni permanenti al viso (acido)
t) Art. 593-ter CP - Interruzione gravidanza non consensuale
u) Art. 605 CP - Sequestro di persona
v) Art. 610 CP - Violenza privata
w) Art. 614 CP - Violazione di domicilio
x) Art. 570 CP - Violazione obblighi assistenza familiare
y) Art. 570-bis CP - Violazione obblighi assistenza (separazione)
z) Art. 600-bis CP - Prostituzione minorile ⚠️
aa) Art. 591 CP - Abbandono minore/incapace
bb) Art. 635 CP - Danneggiamento
cc) Art. 629 CP - Estorsione
dd) Art. 612 CP - Minaccia
ee) L. 75/1958 art. 3 - Favoreggiamento prostituzione
ff) Art. 643 CP - Circonvenzione incapace
gg) Art. 601 CP - Tratta di persone

**Conformità dataset:** ⚠️ 91% CONFORME - Mancano Art. 585 e Art. 600

---

## 4. DATI ANAGRAFICI ✅ IMPLICITO

**Fonte normativa:** Art. 5, comma 1; Art. 6, comma 1

**Testo:** "l'età e il genere degli autori e delle vittime"

**Campi richiesti:**

- Età autore/vittima (numerico)
- Genere autore/vittima (MASCHIO/FEMMINA)

**Conformità dataset:** ✅ CONFORME

---

## 5. PRESENZA FIGLI SUL LUOGO DEL FATTO ✅ IMPLICITO

**Fonte normativa:** Art. 2, comma 2; Art. 4, comma 2, lettera b; Art. 5, comma 1

**Testo:** "violenza [...] anche alla presenza sul luogo del fatto dei figli degli autori o delle vittime"

**Lista controllata IMPLICITA:**

- Sì
- No
- Non noto

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## 6. VIOLENZA CON ATTI PERSECUTORI ✅ IMPLICITO

**Fonte normativa:** Art. 4, comma 2, lettera b; Art. 5, comma 1

**Testo:** "se la violenza è commessa unitamente ad atti persecutori"

**Lista controllata IMPLICITA:**

- Sì
- No

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## 7. TIPOLOGIA ARMA UTILIZZATA ⚠️ NON SPECIFICATO

**Fonte normativa:** Art. 5, comma 1; Art. 6, comma 1

**Testo:** "la tipologia di arma eventualmente utilizzata"

**Lista controllata:** NON specificata dalla legge

**Proposta dataset v2.0:**

- Arma da fuoco
- Arma bianca
- Oggetto contundente
- Sostanze chimiche/acidi
- Nessuna arma
- Altro
- Non noto

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## 8. LUOGO DEL FATTO ⚠️ NON SPECIFICATO

**Fonte normativa:** Art. 5, comma 1; Art. 6, comma 1

**Testo:** "le informazioni sul luogo dove il fatto è avvenuto"

**Lista controllata:** NON specificata dalla legge

**Dataset attuale:** 13 categorie proprietarie (73% = "NON PREVISTO/ALTRO")

**Conformità dataset:** ⚠️ PRESENTE MA POCO EFFICACE

---

## 9. INDICATORI RISCHIO REVITTIMIZZAZIONE ✅ PER RIFERIMENTO

**Fonte normativa:** Art. 4, comma 2, lettera c

**Testo:** "gli indicatori di rischio di revittimizzazione previsti dall'allegato B al decreto del Presidente del Consiglio dei ministri 24 novembre 2017"

**Lista controllata:** Definita in DPCM 24/11/2017, Allegato B

**Indicatori principali (estratto):**

1. Precedenti episodi di violenza
2. Escalation della violenza
3. Minacce di morte
4. Disponibilità di armi
5. Violenza durante gravidanza
6. Violenza sessuale
7. Gelosia/controllo estremo
8. Separazione recente
9. Problemi economici dell'autore
10. Abuso sostanze dell'autore
11. Depressione dell'autore
12. Comportamenti autolesionistici autore
13. Violazione misure protezione
14. Stalking
15. Minacce/violenza verso figli
16. Isolamento vittima
17. Dipendenza economica vittima
18. Paura della vittima

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0 parziale)

---

## 10. MISURE DI PROTEZIONE APPLICATE ⚠️ NON SPECIFICATO ELENCO

**Fonte normativa:** Art. 5, comma 5

**Testo:** "misure di prevenzione applicate dal questore o dall'autorità giudiziaria, misure precautelari, misure cautelari, ordini di protezione e misure di sicurezza"

**Lista controllata:** NON specificata (menzionate categorie generali)

**Proposta dataset v2.0:**

- Ammonimento questore
- Allontanamento casa familiare
- Divieto avvicinamento
- Ordine protezione
- Custodia cautelare
- Arresti domiciliari
- Divieto dimora
- Obbligo presentazione PG
- Altra misura
- Nessuna misura

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## 11. AUTORITÀ EMITTENTE MISURA ⚠️ IMPLICITO

**Fonte normativa:** Art. 5, comma 5

**Testo:** "misure [...] applicate dal questore o dall'autorità giudiziaria"

**Lista controllata IMPLICITA:**

- Questore
- GIP
- Tribunale (civile)
- Procura Repubblica
- Altra autorità

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## 12. STATO/ESITO PROCEDIMENTO ⚠️ IMPLICITO

**Fonte normativa:** Art. 5, comma 5

**Testo:** "i provvedimenti di archiviazione e le sentenze"

**Lista controllata IMPLICITA:**

- In corso
- Archiviato
- Condanna (vari gradi)
- Assoluzione (vari gradi)
- Patteggiamento
- Prescrizione

**Conformità dataset:** ❌ CAMPO MANCANTE (proposto in v2.0)

---

## Riepilogo conformità

| # | Elenco controllato | Specificato in legge | Presente dataset | Conformità |
|---|-------------------|---------------------|------------------|------------|
| 1 | Relazione autore-vittima | ✅ ESPLICITO | ✅ Sì | ✅ 100% |
| 2 | Tipologia violenza | ✅ ESPLICITO | ❌ No | ❌ Mancante |
| 3 | Reati da rilevare | ✅ ESPLICITO | ⚠️ Parziale | ⚠️ 91% |
| 4 | Età e genere | ✅ IMPLICITO | ✅ Sì | ✅ 100% |
| 5 | Presenza figli luogo | ✅ IMPLICITO | ❌ No | ❌ Mancante |
| 6 | Violenza + stalking | ✅ IMPLICITO | ❌ No | ❌ Mancante |
| 7 | Tipologia arma | ⚠️ Campo richiesto | ❌ No | ❌ Mancante |
| 8 | Luogo fatto | ⚠️ Campo richiesto | ⚠️ Inadeguato | ⚠️ 27% utile |
| 9 | Indicatori rischio | ✅ Per riferimento | ❌ No | ❌ Mancante |
| 10 | Misure protezione | ⚠️ Categorie generali | ❌ No | ❌ Mancante |
| 11 | Autorità emittente | ✅ IMPLICITO | ❌ No | ❌ Mancante |
| 12 | Esito procedimento | ✅ IMPLICITO | ❌ No | ❌ Mancante |

**Punteggio complessivo conformità:** 2/12 pienamente conformi (17%)

**Legenda:**
- ✅ ESPLICITO: Elenco dettagliato nella legge
- ✅ IMPLICITO: Valori deducibili dalla formulazione normativa
- ⚠️ Campo richiesto: Legge richiede il dato ma non specifica modalità
- ✅ Per riferimento: Rinvia a normativa esterna
