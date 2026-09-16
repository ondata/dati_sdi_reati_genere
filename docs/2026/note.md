# Note sui dati del FOIA 2026

I nomi delle colonne sono citati come compaiono nei file del Ministero (in maiuscolo); nei CSV pubblicati in `data/output/2026/` sono in minuscolo.

Stranezze e problemi trovati nei tre xlsx del riscontro del 15/05/2026 (prot. MI-123-U-C-3-2-2026-88), e cosa ne è stato fatto. Le sezioni fino a «ID_VITTIMA» riguardano i due xlsx dei semestri, per coppia vittima-autore: pipeline [`scripts/2026/semestri.sh`](../../scripts/2026/semestri.sh), output `data/output/2026/microdati_2025/2025.csv`, con le colonne `semestre` e `fonte` (nome dell'xlsx da cui viene ogni riga). L'ultima sezione riguarda il file aggregato.

Stato di ogni punto:

- **risolto**: corretto dalla pipeline
- **aperto**: presente anche nei dati processed; la sezione dice come trattarlo e cosa resta da chiedere al Ministero
- **nessun intervento necessario**: non è un problema dei dati

## Formato dei file

### Due file costruiti in modo diverso

I due semestri hanno le stesse 17 colonne, con gli stessi nomi e nello stesso ordine, ma sono stati salvati in modo diverso.

| Aspetto | 1° semestre | 2° semestre |
|---|---|---|
| Foglio dati | `Foglio1`, più `Foglio2` e `Foglio3` vuoti | `Sheet`, più `Sheet-SQL` con la query di estrazione |
| Valore mancante | cella vuota | testo `(null)` |
| Date | date di Excel | testo `gg.mm.aaaa` |
| Codici ed età | numeri | in parte testo |

**Risolto.** La pipeline esporta ogni foglio con il suo nome, legge tutto come testo e poi uniforma: `(null)` e celle vuote diventano valori mancanti, le date passano in formato ISO (`aaaa-mm-gg`), codici ed età diventano interi. Controllo: i campi valorizzati sono gli stessi prima e dopo (date del fatto 29.676, ammonimenti 240, misure di sicurezza 109, violazioni 925, relazioni 1.835, reati 29.455).

### Il 1° semestre non si legge con i tipi dedotti automaticamente

`read_xlsx` di DuckDB si ferma alla cella F83 (`Could not convert string 'EGITTO' to DOUBLE`): deduce il tipo di `NAZIONE_NASCITA_AUTORE` dalle prime righe, tutte vuote, e poi trova un testo. Lo stesso lettore mostra le celle vuote come `NULL`, che non è un valore presente nel file.

**Risolto.** L'estrazione da xlsx la fa `qsv excel`, e DuckDB legge i CSV con `all_varchar = true`.

### Date del 1° semestre convertite già da qsv

`qsv excel` scrive le date di Excel del 1° semestre come `2025-04-01`. È l'unica differenza tra l'export CSV del 1° semestre e l'xlsx.

**Risolto.** La pipeline accetta sia `aaaa-mm-gg` sia `gg.mm.aaaa`.

### Spazi in coda

`NAZIONE_NASCITA_VITTIMA` e `NAZIONE_NASCITA_AUTORE` hanno valori riempiti di spazi fino a 38 caratteri, `RELAZIONE_AUTORE_VITTIMA` fino a 100. Lo stesso paese compare quindi in due versioni: `ROMANIA` è scritto senza spazi in 454 righe e con gli spazi in 216 (1° semestre). Tolti gli spazi, le varianti coincidono: non ci sono grafie diverse dello stesso paese.

**Risolto.** La pipeline toglie gli spazi in testa e in coda da tutti i campi. Nell'output nessun valore ha spazi residui, e i paesi di nascita delle vittime distinti sono 137.

## Contenuto

### Codici reato diversi tra i due semestri

**Come nasce la colonna.** La query del 2° semestre ([`query_estrazione_2semestre2025_formattata.sql`](../../data/rawdata/2026/query_estrazione_2semestre2025_formattata.sql)) lavora in due passaggi distinti:

1. sceglie le righe in base all'indicatore di violenza di genere dei sistemi di polizia (`IN_VIOL_GEN = 'S'`), prendendo i reati consumati e, tra i tentati, solo gli omicidi; l'elenco dei reati qui non interviene;
2. assegna una lettera a ogni codice reato con una tabella di conversione (`CASE`: `572` → `F`, `635` → `V`, ecc.), che non ha una voce di riserva (`ELSE`). Un reato che non è nell'elenco resta nel file, con `REATI` vuoto.

Un reato vuoto quindi non è un dato perso: è un reato che la tabella di conversione non riconosceva. Il significato delle lettere è in [`data/output/2026/legende/legenda_reati.csv`](../../data/output/2026/legende/legenda_reati.csv), ricostruito dalla query; per `E`, `H`, `O` e `BB` è da confermare (colonna `REATI_INCERTO`).

**Cosa si vede.**

| | 1° semestre | 2° semestre |
|---|---|---|
| Codici reato distinti | 21 | 24 |
| `V` danneggiamento | 0 | 232 |
| `DD` tratta di persone | 0 | 5 |
| `O` art. 593-ter c.p. | 0 | 2 |
| Reato vuoto | 210 | 11 |

- I codici assenti nel 1° semestre sono esattamente `V`, `DD` e `O`. Gli altri hanno numeri simili nei due semestri (ad esempio `F` 5.909 e 6.291, `G` 2.464 e 2.611, `AA` 992 e 1.048).
- Il passaggio del danneggiamento da 0 a 232 casi non è plausibile come variazione reale.
- I 210 vuoti del 1° semestre sono dello stesso ordine di `V` + `DD` + `O` del 2° (239).
- Le righe vuote del 1° semestre hanno un profilo vicino a `V`: vittime maschi 43% contro 34%, età mediana 45 contro 43 anni. Per confronto, nei maltrattamenti (`F`) le vittime maschi sono il 14%.

**Ipotesi.** Il 1° semestre sembra estratto con una versione precedente della tabella di conversione, in cui danneggiamento, tratta e 593-ter non erano presenti. Se è così, le righe ci sono in entrambi i semestri, perché la selezione non dipende dall'elenco dei reati; nel 1° semestre manca solo l'etichetta. Non è verificabile: la query del 1° semestre non è stata inviata, 210 non coincide con 239, e tra i vuoti non si distinguono i danneggiamenti da altri reati non in elenco (che esistono: 11 nel 2° semestre).

Nella query il codice della tratta è scritto `'601A '`, con uno spazio finale. Se nel database il codice è `601A`, quei casi finirebbero tra i vuoti anche nel 2° semestre.

**Aperto.** Le righe con reato vuoto restano vuote: attribuire loro `V` sarebbe una ricostruzione non documentata. Danneggiamento, tratta e 593-ter non vanno confrontati tra i due semestri; le colonne `semestre` e `fonte` permettono di tenerli separati. Da chiedere al Servizio Analisi Criminale se il 1° semestre è stato estratto con una tabella di conversione diversa, e se possono inviare la query usata o una nuova estrazione con la tabella attuale.

### Autore quasi sempre non collegato

**Come la query arriva all'autore.** L'autore non è collegato direttamente al fatto: la query lo raggiunge solo attraverso la scheda della relazione autore-vittima.

```
vittima del fatto
  └─ TFP026_RELAZIONE_AUTORE_VITTIMA (g)   su fatto + vittima
       ├─ RELAZIONE_VITT_AUT (h)            → RELAZIONE_AUTORE_VITTIMA
       └─ TFP025_PRESUNTO_AUTORE (m)        su g.ID_DENUNCIATO
            ├─ genere                       → SESSO_AUTORE
            ├─ data di nascita              → ETA_AUTORE
            └─ TLG001_LUOGO (n)             → NAZIONE_NASCITA_AUTORE
```

Se la scheda della relazione manca, la query non vede nessun dato dell'autore, anche se nel sistema un denunciato può esserci. Nei commenti della query resta traccia di una strada alternativa non usata, il ruolo «COLP. DA PROVV.» (tabelle `q`, `q2`, `q3`), con l'annotazione `--- DUBBI SU SOGGETTO autore oppure colp. da provv.`.

**Cosa si vede.** I dati seguono esattamente questa struttura:

| Relazione | Sesso autore | Età autore | Paese di nascita autore | Righe |
|---|---|---|---|---|
| assente | 0 | assente | assente | 27.841 |
| presente | 1 o 2 | presente | presente | 1.585 |
| presente | 1 o 2 | presente | assente | 213 |
| presente | 1 o 2 | assente | presente o assente | 37 |

- Senza relazione non c'è nessun dato dell'autore; con la relazione c'è sempre il sesso dell'autore. `SESSO_AUTORE = 0` coincide esattamente con la relazione assente: 13.488 righe nel 1° semestre e 14.353 nel 2°, il 93,8% del totale.
- Nelle 37 righe con relazione ma senza età manca la data di nascita dell'autore. Nelle 249 righe con relazione ma senza paese di nascita, 213 hanno l'età: l'autore c'è, ma il luogo di nascita non trova corrispondenza nella tabella dei luoghi.
- La relazione è presente in 1.835 righe su 29.676 (6,2%), per 1.624 vittime distinte su 24.363.
- **Non è un ritardo di registrazione**: la quota di righe con relazione sta tra il 4,9% e il 7,1% in ogni mese, da gennaio a dicembre. Se le schede fossero compilate in seguito, i mesi più lontani dall'estrazione ne avrebbero di più.
- **Non dipende dal reato**: è bassa per tutti, anche per gli omicidi.

| Reato | Relazione presente |
|---|---|
| `A` omicidi | 10,8% |
| `F` maltrattamenti | 7,3% |
| `D` violenza sessuale | 5,9% |
| `G` atti persecutori | 5,7% |
| `I` violazione dei provvedimenti di allontanamento | 3,4% |

- Tra i valori della relazione ci sono `AUTORE NON IDENTIFICATO` (2 righe) e `PERSONA SCONOSCIUTA ALLA VITTIMA` (26): sono informazioni, diverse da una relazione assente.

**Lettura.** Mi pare che il 94% di righe senza autore misuri quanto è poco compilata la scheda della relazione, non quanti autori sono ignoti. Nel file le due cose non si distinguono.

**Come usare i dati.** Nessuna modifica nella pipeline. `SESSO_AUTORE = 0` non significa autore sconosciuto ma scheda della relazione assente. Le analisi su autore e relazione valgono solo per le 1.835 righe (1.624 vittime) con relazione. Sono anche le sole confrontabili con il primo FOIA, che conteneva solo casi con relazione (documentata nell'analisi del riscontro).

**Aperto.** Da chiedere al Servizio Analisi Criminale perché l'autore è raggiunto solo attraverso la scheda della relazione, e se è possibile estrarre i dati del denunciato anche quando la scheda manca.

### Esistenza e presenza dei figli minori: due concetti, un solo calcolo

Le due colonne dovrebbero descrivere cose diverse: `ESISTENZA_FIGLI_MINORI` se la vittima ha figli minori, `PRESENZA_FIGLI_MINORI` se erano presenti durante l'atto di violenza. Anche i commenti della query le distinguono (`---esistenza di figli minori` e `---PRESENZA DI FIGLI MINORI in casa`).

Nei dati però sono identiche in tutte le 29.676 righe (controllo fatto sui CSV grezzi, prima della pulizia). La causa è nella query: le due colonne sono calcolate con la stessa espressione, copiata due volte.

```sql
case
  when (K.IN_PRES_FIGLI_VITT = 'S' and b.in_presenza_minori = 'S'
        or (g.PRESENZA_FIGLI = 'S' and b.in_presenza_minori = 'S')) then 2
  when (K.IN_PRES_FIGLI_VITT = 'N' and g.PRESENZA_FIGLI = 'N') then 1
  else 0
end
```

L'espressione non corrisponde bene a nessuno dei due concetti:

| Valore | Condizione nella query | Righe |
|---|---|---|
| 2 | figli dichiarati nel profilo della vittima (`K`) o nella scheda della relazione (`g`), **e** minori presenti al fatto (`b.in_presenza_minori`) | 3.943 |
| 1 | nessun figlio sia nel profilo della vittima sia nella scheda della relazione | 1.173 |
| 0 | tutti gli altri casi | 24.560 |

Il valore 2 mescola esistenza e presenza. Il valore 0 raccoglie insieme casi molto diversi: figli esistenti ma non presenti al fatto, informazioni mancanti, informazioni discordanti tra le due fonti. Nessuna delle due colonne dice quindi se la vittima ha figli minori, né, da sola, se erano presenti.

**Aperto.** Le due colonne sono ancora entrambe nell'output, identiche; le colonne `ESISTENZA_FIGLI_MINORI_DESCRIZIONE` e `PRESENZA_FIGLI_MINORI_DESCRIZIONE` descrivono il valore per quello che misura («Figli minori dichiarati e minori presenti al fatto», «Nessun figlio minore dichiarato», «Altro o non noto»): vanno lette come un unico indicatore, non come esistenza e presenza. Da chiedere al Servizio Analisi Criminale le due informazioni separate, a partire dai campi di origine che la query già usa (`IN_PRES_FIGLI_VITT`, `PRESENZA_FIGLI`, `IN_PRESENZA_MINORI`).

### Righe duplicate

**Cosa sono.** Righe identiche in tutte le colonne: 283 righe in eccesso (137 nel 1° semestre, 146 nel 2°), in 275 gruppi, quasi tutti coppie (267) e 8 triple. Tra i due semestri non ci sono righe identiche.

Con la sola combinazione vittima + reato + data del fatto i gruppi diventano 388, con 411 righe in eccesso. In 118 di questi gruppi le righe differiscono in qualche colonna:

| Colonna che cambia nel gruppo | Gruppi |
|---|---|
| età dell'autore | 44 |
| figli minori | 41 |
| sesso dell'autore | 40 |
| relazione autore-vittima | 31 |
| luogo del fatto | 25 |
| violazioni | 20 |
| età della vittima | 0 |

**Da dove vengono.** Il file dovrebbe avere una riga per vittima e reato, ma la query unisce la vittima a più tabelle (presunti autori, relazioni, informative di polizia, persone colpite da provvedimento) e ogni corrispondenza in più genera una riga. Le colonne che distinguono quelle righe non sono state esportate, e manca la chiave dell'evento (`PROT_SDI`, presente nel rilascio 2025): righe diverse nel database arrivano identiche. Tre cause possibili:

1. **Più codici reato in una sola lettera.** Se lo stesso fatto è registrato, ad esempio, sia come `575` (omicidio) sia come `S577B` (femminicidio), nel file diventa due righe `A` identiche. I dati sono coerenti con questa causa: le lettere che raggruppano più codici SDI hanno il doppio dei duplicati di quelle con un codice solo (1,37% contro 0,66%), e i tassi più alti sono in `A` omicidi (4 codici, 5,4%) e `D` violenza sessuale (7 codici, 3,0%).
2. **Righe moltiplicate dalle unioni tra tabelle.** Anche le lettere con un solo codice hanno duplicati (ad esempio `F` maltrattamenti, 0,65%): più presunti autori non collegati, con i campi autore vuoti, o più informative o persone colpite da provvedimento per lo stesso fatto.
3. **Eventi davvero distinti**: due denunce per lo stesso reato, stessa vittima, stesso giorno. È la lettura più probabile quando cambia il luogo del fatto (25 gruppi).

Senza la chiave dell'evento non si distingue un doppione tecnico da un fatto reale ripetuto. Nei gruppi in cui cambiano i dati dell'autore, le righe sembrano legittime: un fatto con più autori.

**Trattamento.** Le righe non sono rimosse: cancellarle toglierebbe anche eventi veri. La pipeline aggiunge due colonne, calcolate sulle righe identiche in tutte le colonne:

- `n_copie`: quante righe identiche ha il gruppo (1, 2 o 3). Righe con `n_copie` = 1: 29.118; = 2: 534; = 3: 24.
- `copia`: progressivo della riga nel gruppo. Filtrando `copia = 1` restano 29.393 righe, una per gruppo.

Il numero di vittime distinte (`ID_VITTIMA`, 24.363) non dipende dai duplicati. Il numero di reati invece è sovrastimato di un valore compreso tra 283 e 411 righe, e lo è di più per omicidi e violenze sessuali.

**Aperto.** Da chiedere al Servizio Analisi Criminale la chiave dell'evento, o il codice SDI originale del reato accanto alla lettera.

### Età della vittima impossibili

**Nessuna documentazione.** Il file consegnato non dice come sono calcolate le età, né che cosa significa 0. Per capirlo bisogna leggere la query SQL incollata in una cella del foglio `Sheet-SQL` e poi la documentazione IBM di DB2, il database da cui i dati sono estratti. Per il 1° semestre la query non c'è. Chi riceve il file senza queste ricerche non ha modo di sapere se 0 è un'età, un valore mancante o un errore. È un esempio concreto di perché il dizionario dei dati, negato nel riscontro, serve.

**Come nasce l'età.** Non è inserita a mano: la query la calcola (righe 95-98 di [`query_estrazione_2semestre2025_formattata.sql`](../../data/rawdata/2026/query_estrazione_2semestre2025_formattata.sql); righe 76-79 per l'autore).

```sql
TIMESTAMPDIFF(
  256,
  TIMESTAMP(coalesce(b.D_TFAT_DA, B.D_INI_VAL_TFAT)) - TIMESTAMP(d.d_nas)
) AS ETA_vittima
```

- È la differenza tra la data del fatto e la data di nascita (`d.d_nas`): un'età strana indica una data di nascita strana nel database.
- La data del fatto è `D_TFAT_DA`, l'inizio del fatto, e solo in sua assenza `D_INI_VAL_TFAT`. Per un reato che dura nel tempo, come i maltrattamenti, l'età è quella all'inizio del periodo.
- `256` indica gli anni. Secondo la [documentazione IBM di `TIMESTAMPDIFF`](https://www.ibm.com/docs/en/db2-for-zos/12.0.0?topic=functions-timestampdiff), per gli anni il risultato è la sola parte "anni" della differenza tra le due date: mesi e giorni vengono ignorati. L'età è quindi quella in anni compiuti, e **0 significa meno di un anno**. Le approssimazioni che la stessa documentazione descrive (mesi da 30 giorni, anni da 365) riguardano la conversione in giorni, settimane o mesi, non il calcolo in anni.

**0 anni: non è un'anomalia.** Le righe con 0 anni sono 39, con 1 anno 38, con 2 anni 39, con 3 anni 50, con 4 anni 71: nessun picco sullo zero, come ci sarebbe se fosse un valore di comodo. Sono quasi tutti maltrattamenti in famiglia (`F`, 29) e lesioni (`C`, 6), con vittime maschi e femmine in parti simili. Neonati vittime di maltrattamenti sono plausibili.

**Oltre 100 anni: tre righe, una plausibile.**

| Età | Reato | Data del fatto | Paese di nascita | Lettura |
|---|---|---|---|---|
| 101 | `F` maltrattamenti | 22/12/2025 | Italia | plausibile |
| 125 | `D` violenza sessuale | 21/01/2025 | Romania | impossibile, nascita intorno al 1900 |
| 134 | `V` danneggiamento | 08/08/2025 | Italia | impossibile, nascita intorno al 1891 |

Nelle due righe impossibili non c'è autore collegato né relazione. Il codice originale della vittima contiene una data di pochi giorni o settimane dopo il fatto (22/01/2025 e 27/08/2025); se, come ipotizzato più avanti, è la data di registrazione della persona, la persona è stata registrata proprio per quella denuncia. Credo si tratti di date di nascita non note riempite con un valore di comodo (il 1900 è un segnaposto frequente) o di errori di battitura (1891 al posto di 1991 darebbe 34 anni). Non è possibile stabilire quale.

**Età dell'autore.** Va da 14 a 92 anni, senza valori anomali; gli autori minorenni sono 40.

**Trattamento.** `ETA_VITTIMA` resta come consegnata. La pipeline aggiunge la colonna `eta_vittima_anomala`, vera quando l'età supera i 110 anni: la soglia sta sopra l'età massima documentata in Italia, quindi segnala solo valori impossibili e lascia fuori i 101 anni. È vera in 2 righe, le due della tabella.

### Esiti: estratti in momenti diversi

**Cosa sono.** Le tre colonne vengono dalla tabella SDI delle informative di polizia (`TPS002_INFO_POL`), collegata al fatto. La query riporta la data dell'informativa (`d_st_inf`) in una colonna o nell'altra secondo il tipo:

| Colonna | Tipi di informativa | Righe |
|---|---|---|
| `AMMONIMENTI` | `AMMOM`, `AMMON`, `AMMOQ`, `AMMOS` | 240 |
| `MISURE_SICUREZZA` | `ASCOL`, `ASLAV`, `DIOST`, `DIRIT`, `DISOS`, `LIVIG`, `MENTE`, `RIFGI`, `RIMAN`, `RIREM` | 109 |
| `VIOLAZIONI` | `POLIN` sul reato `P387B` | 925 |

- **Un esito per riga.** Nessuna riga ha più di un esito valorizzato: un fatto con più informative produce più righe. Succede in 23 gruppi con stessa vittima, reato, data e autore; è una delle cause delle righe moltiplicate (vedi «Righe duplicate»).
- **`VIOLAZIONI` non è un esito successivo.** Le 925 date sono tutte su righe con reato `I` (art. 387-bis c.p., violazione dei provvedimenti di allontanamento): 534 cadono nello stesso giorno del fatto, e il 90% entro 9 giorni. È l'informativa sul reato stesso.
- **Nessun limite di data.** La query non fissa una data massima per le informative: prende quelle presenti nel database al momento dell'estrazione.

**Due estrazioni in due momenti.** La data di estrazione non è dichiarata. L'ultima data di un esito presente in ciascun file ne dà un limite minimo: l'estrazione è avvenuta in quel giorno o dopo.

| | 1° semestre | 2° semestre |
|---|---|---|
| Ultima data di un esito | 31/07/2025 | 03/03/2026 |
| Tempo minimo tra fatto ed estrazione | da 31 giorni (fatti del 30/06) a 211 (fatti del 01/01) | da 62 giorni (fatti del 31/12) a 245 (fatti del 01/07) |

Il 2° semestre ha avuto più tempo per registrare gli esiti. Quanto conta dipende da quanto tardi arriva l'esito:

| Esito | Giorni dal fatto, mediana: 1° / 2° semestre | Effetto della differenza |
|---|---|---|
| Violazioni | 0 / 0 | nullo |
| Ammonimenti | 32 / 40 | medio |
| Misure di sicurezza | 85,5 / 117 | forte |

Si vede mese per mese: le misure di sicurezza per i fatti di giugno 2025 sono 0, per quelli di dicembre 2025 sono 4, nei mesi con più tempo a disposizione arrivano a 12-20.

**Trattamento.** Il fatto più recente del 1° semestre ha avuto almeno 31 giorni prima dell'estrazione. Contando solo gli esiti arrivati **entro 30 giorni dal fatto**, tutte le righe dei due semestri sono alla pari; oltre quella soglia il confronto favorisce il 2° semestre. La pipeline aggiunge due colonne per applicare la regola senza calcoli:

- `giorni_ammonimento`: giorni tra il fatto e l'ammonimento. Entro 30 giorni: 50 nel 1° semestre, 59 nel 2°.
- `giorni_misura`: giorni tra il fatto e la misura di sicurezza. Entro 30 giorni: 7 nel 1° semestre, 10 nel 2°.

Per `VIOLAZIONI` non serve: coincide con il reato 387-bis.

**Aperto.** Da chiedere al Servizio Analisi Criminale la data di estrazione di ciascun file.

### Vittime presenti in entrambi i semestri

356 vittime (`ID_VITTIMA`) compaiono in tutti e due i file. Non sono duplicati: sono persone con fatti in entrambi i periodi.

**Nessun intervento necessario.**

### Stessa vittima con sesso diverso

**Cosa si vede.** 50 vittime (135 righe) hanno righe con `SEX_VITTIMA` diverso: in alcune risultano maschio, in altre femmina. Età e paese di nascita invece sono coerenti per tutte le vittime: nessuna ha paesi diversi, e l'età varia al massimo di un anno. Per questo la somma delle vittime donne (20.248) e uomini (4.165) dà 24.413, più delle 24.363 vittime distinte.

**Da dove viene.** Nella query il sesso non viene dall'anagrafe della persona, ma dal suo profilo nella singola comunicazione (`TSO019_PROF_COMU`, collegata per numero di comunicazione, ufficio e persona):

```sql
case
  when e.sex = 'M' then 1
  when e.sex = 'F' then 2
  else '0'
end as sex_vittima
```

Per 121 combinazioni di vittima, reato e data il sesso è lo stesso in tutte le righe; cambia tra un fatto e l'altro. In 6 casi cambia anche dentro lo stesso fatto. Credo che la stessa persona possa essere registrata con sesso diverso in comunicazioni diverse, per errore di compilazione. 15 di queste vittime compaiono in entrambi i semestri.

**Trattamento.** Nessuna correzione: non c'è modo di stabilire quale dei due valori sia giusto. Nei conteggi per sesso contare le righe, oppure attribuire a ogni vittima un solo valore dichiarando il criterio (ad esempio il valore più frequente); la differenza riguarda 50 vittime su 24.363.

**Aperto.** Da chiedere al Servizio Analisi Criminale perché il sesso della vittima è preso dal profilo della comunicazione e non dall'anagrafe della persona.

### Date del fatto concentrate sul primo del mese

**Cosa si vede.** Nelle righe senza duplicati (`copia = 1`) il giorno 1 del mese ha 2.287 fatti, contro una media di 922 per i giorni dal 2 al 28: il 7,8% dei fatti, dove una distribuzione uniforme darebbe circa il 3,3%. Succede in entrambi i semestri (7,6% e 8,0%).

La concentrazione cambia con il tipo di reato:

| Reato | Fatti il giorno 1 |
|---|---|
| `G` atti persecutori | 13,0% |
| `D` violenza sessuale | 8,1% |
| `F` maltrattamenti | 7,7% |
| `AA` minaccia | 6,1% |
| `C` lesioni | 4,3% |
| `A` omicidi | 3,4% |

**Lettura.** `DATA_ACCADIMENTO` è la data di inizio del fatto (`D_TFAT_DA`, vedi «Età della vittima impossibili»). Credo che, quando il giorno di inizio non è noto, venga registrato il primo del mese. È coerente con i numeri: la concentrazione è più alta nei reati che durano nel tempo e hanno un inizio incerto, come atti persecutori e maltrattamenti, ed è vicina al valore atteso negli omicidi, che hanno una data precisa.

**Trattamento.** Nessuna modifica: la data resta come consegnata. Le analisi per mese reggono; quelle per giorno, giorno della settimana o settimana no, perché il giorno 1 è sovrarappresentato.

**Aperto.** Da chiedere al Servizio Analisi Criminale come viene registrata la data di inizio quando il giorno non è noto.

### ID_VITTIMA: il codice della persona nel sistema, stabile tra rilasci

Le osservazioni di questa sezione riguardano il codice originale, quello dei file del Ministero. Nell'output della pipeline il codice è sostituito (vedi «Trattamento»).

**Cos'è.** Nella query è `d.c_per_fis as id_vittima`: il codice interno della persona fisica nell'anagrafe SDI (tabella `TSO001_PER_FIS`), la chiave con cui il sistema identifica una persona. Non è un codice creato per il FOIA. Il valore ha la forma di un istante (`aaaa-mm-gg-hh.mm.ss.microsecondi`), da `1900-01-26-…` a `2026-03-12-…`; tutti i 29.676 valori hanno questo formato, per 24.363 vittime distinte.

**Cosa rappresenta l'istante.** Non è documentato. Un'ipotesi è che sia il momento in cui la persona è stata registrata nel sistema; alcuni dati sono compatibili con questa lettura, ma nessuno la dimostra:

- le ore si distribuiscono in modo simile a un orario d'ufficio: più valori tra le 9 e le 12 (circa 1.900-2.250 persone per ora), meno alle 13 (1.464), di nuovo di più tra le 15 e le 17 (circa 1.500), pochi tra le 4 e le 6 (118-162);
- in 2.593 righe la data del codice è successiva al fatto, in 760 coincide con il giorno del fatto;
- le date aumentano nel tempo: 48 persone negli anni '70, 439 negli '80, 1.698 nei '90, 8.331 nei 2000, 6.938 nei 2010, 6.904 dal 2020.

Quattro persone hanno un codice del 1900, con età tra 45 e 73 anni: in quel caso la data non può essere di registrazione.

**Stesso codice nel primo FOIA.** Il disaggregato del FOIA 2025 ([`MI-123-U-A-SD-2025-90_6.xlsx`](../../data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx)) riporta la vittima in `COD_VITTIMA`, con lo stesso valore senza separatori (`AAAAMMGGhhmmssffffff`). Confrontando i due file:

- 93 vittime compaiono in entrambi (su 2.763 vittime del file 2025 e 24.363 del 2026);
- i dati delle coppie sono coerenti: paese di nascita uguale in 115 righe su 115, età compatibile con il tempo trascorso in 99, sesso uguale in 108;
- per 83 di queste vittime il file 2025 riporta il comune.

Il codice permette quindi di collegare le righe del 2026 alle stesse persone del 2025, e di recuperare il comune proprio per le righe da cui il Ministero lo ha tolto.

**Trattamento.** Nell'output `data/output/2026/microdati_2025/2025.csv` la pipeline sostituisce `ID_VITTIMA` con un codice senza significato, da `V00001` a `V24363`, uno per persona. La data contenuta nel codice originale non è documentata e non viene usata; il nuovo codice toglie anche il collegamento esatto con il file 2025.

- I codici sono assegnati in ordine casuale, così il loro ordine non riflette quello dei codici originali.
- La corrispondenza tra codice originale e nuovo è conservata privatamente da onData e **non è pubblicata**: permette di tornare ai codici originali. Viene riusata a ogni esecuzione, così la stessa persona riceve sempre lo stesso codice; se una vittima non ha un codice la pipeline si ferma. Per lo stesso motivo non sono pubblicati i due xlsx dei semestri, che contengono i codici originali.
- Si conservano il numero di vittime distinte (24.363) e le 356 vittime presenti in entrambi i semestri.

La sostituzione non rende i dati anonimi: le altre colonne (data del fatto, reato, sesso, età e paese di nascita) permettono ancora corrispondenze per somiglianza con il file 2025. È stato deciso di pubblicare comunque i dati a livello di riga (vedi [`README.md`](../../README.md)), sapendo che per i profili rari il rischio resta.

**Aperto.** Da chiedere al Servizio Analisi Criminale conferma del significato del codice, segnalando che un identificativo stabile tra rilasci diversi permette di ricollegare le persone da un file all'altro.

## File aggregato Dati esitati 2024-2025

Terzo xlsx del riscontro, undici fogli di conteggi 2024 e 2025. Dataset distinto da quello dei semestri: conta reati, vittime e segnalazioni, non righe per coppia vittima-autore. Pipeline: [`scripts/2026/aggregati.sh`](../../scripts/2026/aggregati.sh). Output: `data/output/2026/aggregati_2024_2025/aggregati_2024_2025.csv` (31.750 righe) e `data/output/2026/aggregati_2024_2025/omicidi_dcpc_2024_2025.csv` (12 righe).

### Fogli pensati per la lettura a schermo

Ogni foglio ha due o tre righe di titolo prima dell'intestazione vera, e in `Delitti - Segnalazioni` l'intestazione sta su due righe: l'anno sopra (2024, 2025), il sesso del presunto autore sotto (FEMMINILE, MASCHILE). I dati sono in formato largo, con un anno per colonna.

**Risolto.** `qsv excel --header-row` scarta titoli e intestazione, i nomi delle colonne sono rimessi in DuckDB, e i due anni diventano righe. I nove fogli provinciali condividono la stessa struttura di base (provincia, reato, anno, valore) e finiscono in un unico file in formato lungo, con le colonne `gruppo` (Delitti, Reati spia, Codice Rosso) e `misura` (reati commessi, vittime, segnalazioni) a dire da quale foglio viene ogni riga. Filtrando su quelle due colonne si ritrova il singolo foglio. Le colonne che non si applicano restano vuote: `num_ordine` solo nei Delitti, `fascia_eta` in vittime e segnalazioni, `sesso_autore` solo nelle segnalazioni.

Controllo: per ciascuno dei nove fogli la somma dei valori nel file lungo coincide con quella del foglio grezzo (Delitti 327.149 reati commessi, 114.202 vittime, 79.670 segnalazioni; Reati spia 101.488, 72.526, 61.123; Codice Rosso 10.216, 5.410, 36).

### I valori delle diverse misure non si sommano

`sum(valore)` senza filtri non ha significato: mette insieme reati, vittime e segnalazioni a carico dei presunti autori, che contano cose diverse.

Non si sommano nemmeno i gruppi tra loro: maltrattamenti e atti persecutori stanno nei Reati spia, ma alcune fattispecie compaiono anche altrove, e il Codice Rosso raccoglie reati introdotti da quella legge. Ogni analisi parte da un filtro su `gruppo` e `misura`.

### Omicidi in un file a parte

Il foglio `Omicidi DCPC` non è stato unito agli altri: è nazionale, senza provincia né reato, le sue righe sono indicatori annidati con dei «di cui» e la fonte dichiarata è diversa, «D.C.P.C. - dati operativi» contro «SDI/SSD consolidati» degli altri nove. Tenerlo insieme avrebbe invitato a sommare o confrontare dati operativi e dati consolidati.

L'annidamento è sciolto in due colonne: `ambito` (tutti gli omicidi, ambito familiare o affettivo, partner o ex partner) e `vittime` (tutte, femminili). L'attribuzione dei livelli è **una nostra interpretazione dei rientri**, perciò il file conserva anche `etichetta_originale`, il testo della riga nel foglio.

### Codice ISTAT della provincia, e Sud Sardegna che manca

**Nei dati del Ministero il codice ISTAT della provincia non c'è.** La provincia è solo un nome scritto in maiuscolo (`AGRIGENTO`, `FORLI' CESENA`), senza il codice che l'ISTAT assegna a ogni unità territoriale. È una barriera di interoperabilità di base: senza codice il dato non si aggancia a nessun altro dato territoriale (popolazione, confini, altri archivi) se non ricostruendo a mano la corrispondenza dei nomi, e sei nomi su 106 non coincidono con la denominazione ufficiale. La corrispondenza va rifatta, e riverificata, da chiunque riusi i dati.

**Risolto in pipeline.** Aggiunte le colonne `cod_provincia_istat` e `provincia_istat` (denominazione ufficiale), prese dall'elenco delle province e UTS attive al 31/12/2025, il report 64 del SITUAS dell'ISTAT, scaricato con la CLI `opensituas` in [`data/output/2026/legende/province_istat.csv`](../../data/output/2026/legende/province_istat.csv).

Sei nomi sono scritti in modo diverso da ISTAT e sono ricondotti con [`data/output/2026/legende/province_alias.csv`](../../data/output/2026/legende/province_alias.csv): `AOSTA` (Valle d'Aosta/Vallée d'Aoste), `BOLZANO` (Bolzano/Bozen), `FORLI' CESENA` (Forlì-Cesena), `MASSA CARRARA` (Massa-Carrara), `REGGIO EMILIA` (Reggio nell'Emilia), `VERBANIA` (Verbano-Cusio-Ossola). Se una provincia resta senza codice la pipeline si ferma. Le uniche righe senza codice sono le 174 di `NON LOCALIZZATA`.

### Sardegna con la suddivisione provinciale di prima del 2006

Dal confronto con l'elenco ISTAT risulta assente **Sud Sardegna** (codice `111`): le province nel file sono 106 delle 107 attive nel periodo dei dati, più `NON LOCALIZZATA` (174 righe, 570 casi).

Il territorio però non manca: è attribuito alle province sarde di prima del 2006. Nel disaggregato del FOIA 2025, che riporta il comune, i comuni oggi in Sud Sardegna stanno sotto `CAGLIARI` (Carbonia 9 righe, Iglesias 8, Sanluri 1) e Olbia sta sotto `SASSARI`.

Le variazioni, dai report 112 e 113 del SITUAS:

| Data | Variazione |
|---|---|
| 01/01/2006 | nascono Olbia-Tempio, Ogliastra, Medio Campidano e Carbonia-Iglesias, da Sassari, Nuoro e Cagliari |
| 28/04/2016 | le quattro sono soppresse e nasce Sud Sardegna (codice `111`), da Cagliari, Oristano, Ogliastra, Medio Campidano e Carbonia-Iglesias |
| 01/01/2026 | Sud Sardegna è soppressa a sua volta: nascono Ogliastra, Medio Campidano e Sulcis Iglesiente, e una parte torna a Cagliari e Nuoro |

Per la Sardegna i dati usano quindi le quattro province Cagliari, Nuoro, Oristano e Sassari, con i perimetri precedenti al 2006. I loro valori non sono confrontabili con quelli di altre fonti riferite alle stesse denominazioni, perché comprendono un territorio più ampio.

**Questa è una deduzione, non un'informazione ricevuta.** Il file consegnato non dichiara a quale assetto amministrativo si riferiscono le province, e l'aggregato 2024-2025 non contiene i comuni: la ricostruzione si regge sul disaggregato del FOIA 2025, prodotto dallo stesso ufficio, e sulla storia delle variazioni ISTAT. È un altro difetto della consegna, della stessa natura dei codici ISTAT mancanti: chi riusa i dati deve dedurre, e può dedurre male.

Nel rilascio 2026 le colonne `codice_provincia_storico`, `codice_regione`, `regione` e `ripartizione_geografica` vengono dall'elenco ISTAT al 31/12/2025, con gli stessi nomi di colonna del rilascio 2019-2024. I valori coincidono con quelli del rilascio 2019-2024 per tutte le province tranne le quattro sarde, per il codice storico: nei file 2019-2024 Cagliari, Nuoro, Oristano e Sassari hanno i codici introdotti con il riordino del 2026 (118, 114, 115, 112), qui quelli validi alla fine del 2025 (092, 091, 095, 090), coerenti con il periodo dei dati.

**Trattamento.** La pipeline aggiunge la colonna `perimetro_confrontabile`, falsa per le quattro province sarde (1.178 righe, 18.623 casi), vera per le altre 102, vuota per `NON LOCALIZZATA`. Il codice ISTAT di Cagliari, Nuoro, Oristano e Sassari resta valorizzato, ma identifica un perimetro più piccolo di quello dei dati.

**Aperto.** Da chiedere al Servizio Analisi Criminale il codice ISTAT della provincia nei prossimi rilasci, a quale assetto amministrativo si riferiscono le province, e conferma che il territorio di Sud Sardegna è dentro Cagliari, Nuoro e Oristano.

### Omicidi assenti dai fogli provinciali

Il reato `3. OMICIDI VOLONTARI CONSUMATI` compare solo in `Delitti - Segnalazioni` (368 righe). Nei fogli dei reati commessi e delle vittime non c'è: a livello provinciale non sono stati forniti né gli omicidi commessi né le loro vittime, che restano solo nei totali nazionali del foglio DCPC.

**Aperto.** Da chiedere al Servizio Analisi Criminale gli omicidi commessi e le vittime a livello provinciale.

### Sesso della vittima dichiarato solo in due fogli su tre

I titoli dei fogli «Vittime» e «Segnalazioni» dicono che riguardano vittime di sesso femminile. Il titolo dei fogli «Commessi» non lo dice: «Numero reati commessi in Italia disaggregati a livello provinciale». Non sappiamo quindi se i reati commessi siano tutti o solo quelli con vittima donna.

**Aperto.** Da chiedere al Servizio Analisi Criminale a quale insieme si riferiscono i fogli dei reati commessi.

### Altri elementi da tenere presenti

- **Zeri e celle vuote.** Le celle vuote del foglio non diventano righe; gli zeri espliciti sì (3.261 righe con valore 0). Uno zero e una riga assente non sono la stessa cosa: la riga assente può voler dire che la combinazione non è stata prodotta.
- **Età in fasce.** `fascia_eta` usa otto classi (`0-13`, `14-17`, `18-24`, `25-34`, `35-44`, `45-54`, `55-64`, `65 e oltre`), diverse dall'età in anni dei file per coppia vittima-autore.
- **Reati con altra classificazione.** Gli undici reati sono scritti per esteso e raggruppati in modo diverso dai codici a lettere di `2025.csv`: i due file non si confrontano riga per riga.

## Serie provinciale 2019-2025 e revisioni del 2024

I due rilasci FOIA degli aggregati si sovrappongono. Il primo (istanza 18/04/2025, risposta 09/05/2025, dati pubblicati in [github.com/ondata/dati_sdi_reati_genere](https://github.com/ondata/dati_sdi_reati_genere)) copre il 2019-2024; il secondo copre il 2024-2025. Lo script [`scripts/2026/serie_provinciale.sh`](../../scripts/2026/serie_provinciale.sh) li unisce in `data/output/2026/serie_2019_2025/province_2019_2025.csv` (127.780 righe), con in più le colonne `rilascio` (2025 o 2026) e `anno_parziale`. Per il 2024, presente in entrambi, il file tiene il valore del rilascio più recente.

Controlli: le somme per anno e foglio coincidono con i fogli grezzi; nessuna combinazione ripetuta; tutte le province hanno il codice ISTAT; due esecuzioni danno file identici.

### Il 2024 cambia tra un rilascio e l'altro

Nel primo rilascio il 2024 era dichiarato non consolidato. `data/output/2026/serie_2019_2025/revisioni_2024.csv` confronta i due valori per ogni combinazione di gruppo, misura, provincia, reato, fascia d'età e sesso dell'autore.

| Esito | Combinazioni |
|---|---|
| invariato | 11.495 |
| rivisto | 4.028 |
| presente solo nel primo rilascio | 3.683 |
| presente solo nel secondo | 352 |

Per misura, totali 2024 a confronto:

| Misura | Primo rilascio | Secondo rilascio | Variazione |
|---|---|---|---|
| reati commessi | 218.971 | 219.972 | +1.001 (+0,5%) |
| vittime | 95.828 | 96.769 | +941 (+1,0%) |
| segnalazioni | 83.038 | 70.945 | **-12.093 (-14,6%)** |

Reati commessi e vittime crescono di poco, come ci si aspetta da un consolidamento. Le segnalazioni a carico dei presunti autori invece calano di oltre un settimo, e il calo si concentra nei maltrattamenti con autore maschio nelle province grandi (Roma 35-44 anni: da 468 a 365; Milano 25-34: da 237 a 146). Un consolidamento che toglie segnalazioni in questa misura non si spiega da solo.

**Aperto.** Da chiedere al Servizio Analisi Criminale perché le segnalazioni del 2024 calano del 14,6% tra i due rilasci, e cosa distingue le 3.683 combinazioni presenti solo nel primo rilascio.

### Gli omicidi del 2024 hanno tre valori diversi

Lo stesso indicatore, omicidi volontari consumati nel 2024, vale:

| Fonte | Omicidi | Vittime donne |
|---|---|---|
| primo FOIA (maggio 2025) | 320 | 113 |
| report pubblico del Servizio Analisi Criminale (gennaio 2026) | 335 | 118 |
| secondo FOIA (maggio 2026) | 336 | 119 |

Sono dati dichiarati «operativi», quindi rivedibili, e le tre date sono diverse. Resta che chi cita un numero deve dire da quale documento viene e a quale data. La serie 2019-2025 è in `data/output/2026/serie_2019_2025/omicidi_dcpc_2019_2025.csv`, con la colonna `rilascio`.

### Una provincia con due nomi nel primo rilascio

Nel foglio `Reati spia - Segnalazioni` del primo rilascio la stessa provincia compare sia come `PESARO E URBINO` (14 righe) sia come `PESARO` (1 riga, maltrattamenti, autore maschio 18-24 anni, 2 segnalazioni nel 2024). Le due voci sono ricondotte allo stesso nome con [`data/output/2026/legende/province_alias.csv`](../../data/output/2026/legende/province_alias.csv) e i valori sommati.

### Codice Rosso: il 2019 è un anno parziale

I quattro reati del Codice Rosso esistono dall'agosto 2019 (L. 69/2019), e nel primo rilascio la colonna si chiama `2019*`. Nel file la colonna `anno_parziale` è vera per quelle righe: senza quell'avvertenza il salto da 947 casi nel 2019 a 2.873 nel 2020 si legge come crescita del fenomeno, mentre è soprattutto un anno che copre metà del periodo.

Le etichette dei quattro reati sono scritte diversamente nei due rilasci (per esteso nel primo, abbreviate con l'articolo nel secondo) e sono ricondotte con [`data/output/2026/legende/reati_alias.csv`](../../data/output/2026/legende/reati_alias.csv).
