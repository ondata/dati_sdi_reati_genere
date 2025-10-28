# Sintesi Analisi Dati: Reati Spia (2019-2024)

Questa analisi si concentra sui "reati spia", ovvero `ATTI PERSECUTORI` e `MALTRATTAMENTI CONTRO FAMILIARI E CONVIVENTI`. Per la comprensione del fenomeno, sono stati utilizzati e confrontati tre tipi di dati:

-   **Reati Commessi**: Il numero totale di reati spia registrati come avvenuti.
-   **Segnalazioni (a carico di presunti autori noti)**: Il numero di casi in cui è stato identificato un presunto responsabile del reato.
-   **Vittime Femminili**: Il numero di vittime di sesso femminile per i reati spia.

## 1. Panoramica Generale e Tendenze

-   **Tipi di Reato**: L'analisi si è focalizzata esclusivamente su `ATTI PERSECUTORI` e `MALTRATTAMENTI CONTRO FAMILIARI E CONVIVENTI`, confermando la loro centralità come "reati spia" nel contesto della violenza di genere.
-   **Trend in Aumento**: Contrariamente ad altri delitti che hanno mostrato un calo nel 2020 (probabilmente legato alla pandemia), i reati spia hanno registrato un **aumento costante e preoccupante** dal 2019 al 2024, sia in termini di reati commessi che di vittime.
    -   Reati commessi: da 36.915 (2019) a 49.688 (2024).
    -   Vittime femminili: da 29.504 (2019) a 35.770 (2024).

## 2. Profilo degli Autori (Segnalazioni)

-   **Prevalenza Maschile Schiacciante**: Le segnalazioni a carico di presunti autori noti mostrano una netta prevalenza maschile. Nel 2024, su un totale di 34.119 segnalazioni, la stragrande maggioranza riguarda autori di sesso maschile (circa 91% sul totale delle segnalazioni per sesso disponibile nel dataset `reati_spia_segnalazioni.csv`). Questo evidenzia la natura di genere di questi reati.
-   **Fasce d'Età degli Autori**: Gli autori sono prevalentemente adulti, con le fasce d'età 35-44, 45-54 e 25-34 che registrano il maggior numero di segnalazioni.

## 3. Profilo delle Vittime (Vittime Femminili)

-   **Vittime di Tutte le Età**: I reati spia colpiscono vittime di tutte le fasce d'età. Le fasce più colpite sono 35-44, 45-54 e 25-34 anni. Tuttavia, è significativo notare la presenza di vittime anche tra i minori (0-17 anni) e gli anziani (65 e oltre), sottolineando la trasversalità del fenomeno.
-   **Alta Incidenza Femminile**: La percentuale complessiva di vittime femminili sul totale dei reati spia commessi è del **75.82%**. Questo dato è estremamente elevato e conferma che questi reati sono prevalentemente diretti contro le donne.
    -   In particolare, i `MALTRATTAMENTI CONTRO FAMILIARI E CONVIVENTI` mostrano una percentuale di vittime femminili dell'80.51%, mentre gli `ATTI PERSECUTORI` si attestano al 69.68%.

## 4. Concentrazione Geografica

-   **Aree Metropolitane Epicentri**: Le grandi aree metropolitane come Roma, Napoli, Milano e Torino registrano il maggior numero di reati spia commessi e, di conseguenza, il maggior numero di vittime femminili. Questo suggerisce che i contesti urbani densamente popolati sono i principali epicentri di questi fenomeni.

## 5. Analisi delle Discrepanze e Flussi di Dati (Dati 2024)

Il confronto tra i diversi flussi di dati per il 2024 rivela dinamiche importanti:

-   **Reati Commessi (49.688) vs. Segnalazioni (34.119)**:
    -   Solo circa il **68.67%** dei reati spia commessi ha portato all'identificazione e alla segnalazione di un presunto autore. La differenza (15.569 reati) indica un "gap di identificazione/segnalazione dell'autore". Questo può essere dovuto a reati in cui il responsabile non è stato individuato, a casi di sotto-denuncia, o a complessità investigative.

-   **Reati Commessi (49.688) vs. Vittime Femminili (35.819)**:
    -   Circa il **72.09%** dei reati spia commessi ha una vittima di sesso femminile. La differenza (13.869 reati) può essere spiegata dalla presenza di vittime maschili o da reati che, pur essendo "commessi", non rientrano nella categoria delle "vittime femminili" (es. reati tentati senza vittima diretta, o casi in cui la vittima non è stata identificata o non ha sporto denuncia).

-   **Segnalazioni (34.119) vs. Vittime Femminili (35.819)**:
    -   Il numero di vittime femminili è leggermente **superiore** al numero di segnalazioni a carico di presunti autori noti. Questa discrepanza (1.700 vittime in più) può essere spiegata dal fatto che una singola segnalazione può riguardare più vittime (es. maltrattamenti familiari) o che le vittime possono essere identificate anche se il presunto autore non è stato ancora segnalato formalmente.

Queste discrepanze evidenziano una complessa dinamica di emersione e registrazione dei reati spia, suggerendo una sotto-identificazione degli autori e una complessità nella registrazione dei flussi di dati.

## 6. Criticità dei Dati

-   **Problema di Encoding**: È stato riscontrato un problema di encoding nella colonna `provinciauts_corretto` (es. "VALLE D'AOSTA/VALLÃ‰E D'AOSTE"), che richiederà un intervento di pulizia per garantire l'accuratezza delle analisi geografiche future.
-   **Dati 2024 Provvisori**: I dati relativi al 2024 sono da considerarsi provvisori e non consolidati, e potrebbero subire variazioni.

## 7. Implicazioni e Prossimi Passi

L'analisi conferma che i "reati spia" sono un indicatore cruciale della violenza di genere, con una prevalenza schiacciante di vittime femminili e un trend in aumento. Le discrepanze tra i flussi di dati sottolineano la necessità di un approccio olistico per comprendere e contrastare il fenomeno.

-   **Approfondimento sulle Dinamiche di Emersione**: È fondamentale continuare a studiare le ragioni delle discrepanze per comprendere meglio le barriere alla denuncia e all'identificazione degli autori.
-   **Analisi Pro Capite**: Per una comparazione più accurata tra le province, si suggerisce di calcolare i tassi pro capite, normalizzando i dati per la popolazione residente.
-   **Correzione Encoding**: È fondamentale implementare un processo ETL per correggere il problema di encoding riscontrato nei nomi delle province.
-   **Visualizzazioni**: Sviluppare visualizzazioni interattive per esplorare le tendenze temporali, le distribuzioni geografiche e i profili demografici, facilitando la comprensione e la comunicazione degli insight.
-   **Interventi Multilivello**: Per migliorare l'emersione e il contrasto dei reati spia, sono necessari interventi su più fronti: sensibilizzazione, formazione delle forze dell'ordine, supporto alle vittime e analisi più granulare dei dati.
