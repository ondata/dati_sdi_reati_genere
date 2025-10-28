# Sintesi Analisi Dati: Delitti, Segnalazioni e Vittime (2019-2024)

Questo documento riassume le principali osservazioni emerse dall'analisi esplorativa di tre dataset relativi ai delitti in Italia tra il 2019 e il 2024:

* `delitti_commessi.csv`: Dati generali sui delitti commessi.
* `delitti_segnalazioni.csv`: Segnalazioni a carico dei presunti autori noti in Italia disaggregati a livello provinciale, per sesso e fascie d'età con vittima di sesso femminile (Dati di fonte SDI/SSD non consolidati per il 2024 e quindi suscettibili di variazioni)
* `delitti_vittime.csv`: Numero vittime di reato in Italia, di sesso femminile disaggregate a livello provinciale (Dati di fonte SDI/SSD non consolidati per il 2024 e quindi suscettibili di variazioni)

---

## 1. Delitti Commessi (Panoramica Generale)

* **Dimensioni**: Circa 3.200 righe, 13 colonne.
* **Tipi di Delitto**: 5 categorie principali (`TENTATI OMICIDI`, `LESIONI DOLOSE`, `PERCOSSE`, `MINACCE`, `VIOLENZE SESSUALI`). Ogni categoria presenta 642 occorrenze, risultato della moltiplicazione del numero di anni (6) per il numero di province (107), indicando una riga per ogni combinazione anno-provincia per ciascun delitto.
* **Andamento Temporale**: Si osserva un calo generale nel 2020 (probabilmente legato alla pandemia di COVID-19 e alle restrizioni), seguito da una ripresa e un aumento costante fino al 2024, che registra il picco di delitti nel periodo analizzato.
* **Concentrazione Geografica**: Le province con il maggior numero di delitti commessi sono le grandi aree metropolitane (Roma, Milano, Napoli, Torino, ecc.), con Salerno che si distingue tra le prime posizioni.

## 2. Delitti Segnalati (Autori)

* **Dimensioni**: Circa 29.500 righe, 15 colonne.
* **Contesto**: Segnalazioni a carico dei presunti autori noti in Italia disaggregati a livello provinciale, per sesso e fascie d'età con vittima di sesso femminile.
* **Tipi di Delitto**: 6 categorie, inclusa la nuova categoria "OMICIDI VOLONTARI CONSUMATI".
* **Profilo degli Autori (di reati con vittime femminili)**:
  * **Sesso**: Netta prevalenza maschile in tutte le categorie di delitto e in tutti gli anni (circa 74% maschile vs 26% femminile sul totale delle segnalazioni). Questo indica che, anche quando la vittima è femminile, la maggior parte degli autori noti sono uomini.
  * **Fascia d'Età**: Le fasce 35-44, 45-54 e 25-34 sono le più rappresentate tra gli autori di reati con vittime femminili.
* **Andamento Temporale e Geografico**: Le tendenze temporali e la concentrazione geografica degli autori di reati con vittime femminili sono coerenti con il dataset dei delitti commessi, con la prevalenza maschile e delle fasce d'età centrali che si mantiene nel tempo e nelle diverse province.

## 3. Delitti Vittime

* **Dimensioni**: Circa 23.100 righe, 14 colonne.
* **Contesto**: Numero vittime di reato in Italia, di sesso femminile disaggregate a livello provinciale.
* **Tipi di Delitto**: 5 categorie, le stesse del dataset `delitti_commessi.csv`. La categoria "OMICIDI VOLONTARI CONSUMATI" non è presente come voce separata, a differenza del dataset degli autori.
* **Profilo delle Vittime (femminili)**:
  * **Fascia d'Età**: Le fasce 35-44, 45-54 e 25-34 sono quelle con il maggior numero di vittime femminili, un pattern simile a quello degli autori.
* **Andamento Temporale e Geografico**: Le tendenze temporali e la concentrazione geografica delle vittime femminili sono in linea con quelle osservate per i delitti commessi e gli autori.

## 4. Rapporto Delitti Commessi vs. Vittime Femminili

* **Contesto**: Questo dataset (`data/processing/rapporto_commessi_vittime_femminili/delitti.csv`) aggrega i dati sui delitti commessi con il numero di vittime di sesso femminile, fornendo una visione diretta dell'incidenza di genere nei reati. Copre il periodo 2019-2024.
* **Tipi di Delitto**: Include 5 categorie di delitto, escludendo gli "Omicidi Volontari Consumati" presenti nel dataset delle segnalazioni.
* **Percentuale di Vittime Femminili per Tipo di Delitto**:
  * Le **Violenze Sessuali** mostrano la percentuale media più alta di vittime femminili (circa 80.43%), coerentemente con la natura del reato.
  * Seguono le **Percosse** (circa 44.50%), le **Minacce** (circa 38.16%) e le **Lesioni Dolose** (circa 32.62%).
  * I **Tentati Omicidi** presentano la percentuale più bassa (circa 31.41%) tra i delitti analizzati in questo contesto.
* **Province con la più alta percentuale media di Vittime Femminili (Top 10)**:
  * Alcune province mostrano una maggiore incidenza relativa di reati con vittime femminili rispetto al totale dei delitti commessi. Tra queste, le prime 10 sono: Massa Carrara (codice 045, circa 56.31%), Belluno (025, circa 55.31%), Livorno (047, circa 54.78%), Ferrara (038, circa 54.03%), Asti (005, circa 52.68%), Gorizia (031, circa 52.28%), Siena (052, circa 51.90%), Fermo (109, circa 51.48%), Pisa (055, circa 51.10%), Como (029, circa 50.84%).
* **Tendenze Temporali delle Percentuali**: Le percentuali di vittime femminili per tipo di delitto mostrano variazioni annuali, ma mantengono un ordine di grandezza simile, suggerendo una relativa stabilità nella proporzione di vittime femminili rispetto al totale dei delitti commessi per ciascuna categoria.

La percentuale media complessiva di vittime femminili sul totale dei delitti commessi per tutte le province è di circa **46.42%**. Le province con percentuali superiori a questa media mostrano una maggiore incidenza relativa di reati con vittime femminili. Al contrario, province con percentuali inferiori (come Milano e Roma, che figurano tra le 10 con la percentuale più bassa) non indicano necessariamente un minor numero assoluto di vittime femminili, ma piuttosto che la proporzione di vittime femminili rispetto al volume totale dei delitti commessi in quelle aree è minore, spesso a causa di un elevato numero complessivo di reati.

---

## Osservazioni Trasversali e Punti Chiave per lo Storytelling

1. **Impatto della Pandemia**: Tutti e tre i dataset mostrano un calo dei delitti/segnalazioni/vittime nel 2020-2021, seguito da una ripresa. Questo è un punto narrativo forte per esplorare le correlazioni tra eventi sociali e dinamiche criminali.
2. **Concentrazione Urbana**: I fenomeni criminali (delitti, autori, vittime) sono fortemente concentrati nelle grandi aree metropolitane. Questo suggerisce la necessità di analisi mirate sulle specificità di queste aree.
3. **Discrepanza "Omicidi Volontari Consumati"**: La presenza di questa categoria nel dataset degli autori ma non in quello delle vittime è una discrepanza da chiarire. Potrebbe essere un problema di aggregazione o di inclusione dei dati.
4. **Focus sui Reati con Vittime Femminili**: I dataset `delitti_segnalazioni.csv` e `delitti_vittime.csv` offrono una prospettiva specifica sui reati che coinvolgono vittime di sesso femminile, permettendo un'analisi mirata su questo fenomeno.
5. **Rapporto Delitti Commessi vs. Vittime Femminili**: L'analisi del rapporto tra il totale dei delitti commessi e il numero di vittime femminili per tipo di delitto e provincia è cruciale per identificare le aree e i tipi di reato con una maggiore incidenza di vittime di sesso femminile.
6. **Problema di Encoding**: La colonna `provinciauts_corretto` presenta problemi di encoding (es. "VALLE D'AOSTA/VALLÃ‰E D'AOSTE"), che dovrebbero essere risolti per garantire l'accuratezza delle analisi geografiche.

## Analisi Dettagliata Autori e Vittime (con focus femminile)

### Profili degli Autori (di reati con vittime femminili)

*   **10. MINACCE**: Autori prevalentemente maschili nelle fasce 35-44 e 45-54 anni.
*   **12. VIOLENZE SESSUALI**: Autori prevalentemente maschili nelle fasce 25-34 e 35-44 anni.
*   **3. OMICIDI VOLONTARI CONSUMATI**: Autori prevalentemente maschili nelle fasce 35-44, 65 e oltre, e 45-54 anni.
*   **5. TENTATI OMICIDI**: Autori prevalentemente maschili nelle fasce 25-34, 35-44 e 45-54 anni.
*   **8. LESIONI DOLOSE**: Autori prevalentemente maschili nelle fasce 35-44, 25-34 e 45-54 anni.
*   **9. PERCOSSE**: Autori prevalentemente maschili nelle fasce 35-44, 45-54 e 25-34 anni.

In generale, la prevalenza maschile tra gli autori è netta in tutti i tipi di delitto, anche quando la vittima è femminile. Le autrici femminili sono presenti in numero inferiore, principalmente nelle fasce d'età 35-44 e 45-54 per Minacce, Lesioni Dolose e Percosse.

### Profili delle Vittime (femminili)

*   **10. MINACCE**: Vittime femminili prevalentemente nelle fasce 45-54, 35-44 e 25-34 anni.
*   **12. VIOLENZE SESSUALI**: Vittime femminili più concentrate nelle fasce d'età più giovani: 18-24, 25-34 e 14-17 anni, con un numero significativo anche nella fascia 0-13 anni.
*   **5. TENTATI OMICIDI**: Vittime femminili distribuite principalmente nelle fasce 35-44, 45-54 e 25-34 anni.
*   **8. LESIONI DOLOSE**: Vittime femminili prevalentemente nelle fasce 35-44, 45-54 e 25-34 anni.
*   **9. PERCOSSE**: Vittime femminili prevalentemente nelle fasce 35-44, 45-54 e 25-34 anni.

### Confronto Autori vs. Vittime (con focus femminile)

*   **Violenza di Genere (Violenza Sessuale)**: Questo è il delitto in cui la vittimizzazione femminile è più esclusiva. Gli autori sono generalmente più anziani delle vittime, evidenziando una dinamica di potere legata all'età. Le vittime sono spesso minorenni o giovani adulte.
*   **Conflitti Interpersonali (Minacce, Percosse, Lesioni Dolose)**: Questi delitti mostrano una forte sovrapposizione nelle fasce d'età tra autori e vittime, suggerendo che spesso avvengono in contesti di relazioni o interazioni tra persone di età simile. La prevalenza maschile tra gli autori, anche con vittime femminili, è un dato costante.
*   **Omicidi e Tentati Omicidi**: Questi reati, pur avendo un numero inferiore di vittime femminili, mostrano una distribuzione d'età delle vittime simile a quella degli autori, suggerendo che anche in questi casi le dinamiche possono essere legate a relazioni tra adulti.

## Prossimi Passi / Suggerimenti per l'Analisi e la Visualizzazione

* **Normalizzazione dei Dati**: Calcolare i tassi di delitto/segnalazione/vittimizzazione pro capite, utilizzando dati demografici disaggregati per sesso ed età, per un confronto più equo tra province e fasce demografiche.
* **Analisi Incrociate Approfondite**: Esplorare le relazioni tra tipo di delitto, fascia d'età (autori e vittime femminili), sesso (autori) e il rapporto tra delitti commessi e vittime femminili per identificare pattern specifici (es. quali fasce d'età di vittime femminili sono più colpite da violenze sessuali?).
* **Risoluzione Problema Encoding**: Implementare un passaggio ETL per correggere l'encoding della colonna `provinciauts_corretto`.
* **Visualizzazioni Interattive**:
    Sviluppare dashboard interattive che permettano di esplorare le tendenze temporali, le distribuzioni geografiche e i profili demografici, facilitando la scoperta di insight per lo storytelling.
