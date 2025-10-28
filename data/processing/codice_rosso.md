# Sintesi Analisi Dati: Codice Rosso (2019-2024)

Questa analisi si concentra sui reati rientranti nel "Codice Rosso", ovvero:
-   `COSTRIZIONE O INDUZIONE AL MATRIMONIO`
-   `DEFORMAZIONE DELL'ASPETTO DELLA PERSONA MEDIANTE LESIONI PERMANENTI AL VISO`
-   `DIFFUSIONE ILLECITA DI IMMAGINI O VIDEO SESSUALMENTE ESPLICITI`
-   `VIOLAZIONE DEI PROVVEDIMENTI DI ALLONTANAMENTO DALLA CASA FAMILIARE E DEL DIVIETO DI AVVICINAMENTO AI LUOGHI FREQUENTATI DALLA PERSONA OFFESA`

Per la comprensione del fenomeno, sono stati utilizzati e confrontati tre tipi di dati:
-   **Reati Commessi**: Il numero totale di reati "Codice Rosso" registrati come avvenuti dalle forze dell'ordine (indipendentemente dalla fonte di conoscenza, sia essa una denuncia o un'iniziativa autonoma).
-   **Segnalazioni (a carico di presunti autori noti)**: Il numero di casi in cui è stato identificato un presunto responsabile del reato, e il caso è stato formalizzato contro di lui.
-   **Vittime Femminili**: Il numero di vittime di sesso femminile per i reati "Codice Rosso".

## 1. Panoramica Generale e Tendenze

-   **Tipi di Reato**: L'analisi ha confermato la presenza dei quattro reati specifici del "Codice Rosso".
-   **Trend in Aumento Marcato**: L'introduzione della legge "Codice Rosso" (agosto 2019) ha coinciso con un **aumento costante e significativo** dei reati commessi, delle segnalazioni e delle vittime dal 2019 al 2024.
    -   Reati commessi: da 947 (2019) a 4.982 (2024).
    -   Segnalazioni: da 423 (2019) a 2.234 (2024).
    -   Vittime femminili: da 570 (2019) a 2.707 (2024).
    Questo suggerisce una maggiore emersione e registrazione di questi fenomeni a seguito della normativa.

## 2. Profilo degli Autori (Segnalazioni)

-   **Prevalenza Maschile Schiacciante**: Le segnalazioni a carico di presunti autori noti mostrano una netta prevalenza maschile (circa 94% sul totale delle segnalazioni). Questo rafforza la connotazione di genere di questi crimini.
-   **Fasce d'Età degli Autori**: Gli autori sono prevalentemente adulti, con le fasce d'Età 35-44, 45-54 e 25-34 che registrano il maggior numero di segnalazioni.

## 3. Profilo delle Vittime (Vittime Femminili)

-   **Vittime di Tutte le Età**: I reati "Codice Rosso" colpiscono vittime di tutte le fasce d'età. Le fasce più colpite sono 35-44, 25-34 e 45-54 anni. È presente un numero significativo di vittime anche tra i minori (0-17 anni) e gli anziani (65 e oltre).
-   **Alta Incidenza Femminile**: La percentuale complessiva di vittime femminili sul totale dei reati "Codice Rosso" commessi è del **57.50%**.
    -   In particolare, la `COSTRIZIONE O INDUZIONE AL MATRIMONIO` mostra una percentuale del 100% di vittime femminili (sebbene con numeri assoluti bassi).
    -   La `DIFFUSIONE ILLECITA DI IMMAGINI O VIDEO SESSUALMENTE ESPLICITI` si attesta al 60.95% di vittime femminili.
    -   La `VIOLAZIONE DEI PROVVEDIMENTI DI ALLONTANAMENTO DALLA CASA FAMILIARE E DEL DIVIETO DI AVVICINAMENTO AI LUOGHI FREQUENTATI DALLA PERSONA OFFESA` ha il 55.52% di vittime femminili.

## 4. Concentrazione Geografica

-   **Aree Metropolitane Epicentri**: Le grandi aree metropolitane come Roma, Napoli, Milano e Torino registrano il maggior numero di reati "Codice Rosso" commessi e, di conseguenza, il maggior numero di vittime femminili. Questo suggerisce che i contesti urbani densamente popolati sono i principali epicentri di questi fenomeni.

## 5. Analisi delle Discrepanze e Flussi di Dati (Dati 2024)

Il confronto tra i diversi flussi di dati per il 2024 rivela dinamiche importanti:

-   **Reati Commessi (4.982) vs. Segnalazioni (a carico di presunti autori noti) (2.234)**:
    -   Solo circa il **44.84%** dei reati "Codice Rosso" commessi ha portato all'identificazione e alla segnalazione di un presunto autore. La differenza (2.748 reati) indica un **"gap di identificazione dell'autore"**. Questo può essere dovuto a reati in cui il responsabile non è stato individuato (pur essendo il reato noto alle forze dell'ordine), a casi di sotto-denuncia che impediscono l'identificazione, o a complessità investigative che non hanno ancora portato a una formalizzazione contro un presunto autore.

-   **Reati Commessi (4.982) vs. Vittime Femminili (2.707)**:
    -   Circa il **54.34%** dei reati "Codice Rosso" commessi ha una vittima di sesso femminile. La differenza (2.275 reati) può essere spiegata dalla presenza di vittime maschili o da reati che, pur essendo "commessi", non rientrano nella categoria delle "vittime femminili" (es. reati tentati senza vittima diretta, o casi in cui la vittima non è stata identificata o non ha sporto denuncia).

-   **Segnalazioni (a carico di presunti autori noti) (2.234) vs. Vittime Femminili (2.707)**:
    -   Il numero di vittime femminili è leggermente **superiore** al numero di segnalazioni a carico di presunti autori noti (473 vittime in più). Questo può essere spiegato dal fatto che una singola segnalazione può riguardare più vittime (es. maltrattamenti familiari) o che le vittime possono essere identificate anche se il presunto autore non è stato ancora segnalato formalmente (es. denuncia contro ignoti, o casi in cui la vittima è stata assistita ma l'indagine sull'autore è ancora in corso).

Queste discrepanze evidenziano una complessa dinamica di emersione e registrazione dei reati "Codice Rosso", suggerendo una sotto-identificazione degli autori e una complessità nella registrazione dei flussi di dati.

## 6. Criticità dei Dati

-   **Problema di Encoding**: È stato riscontrato un problema di encoding nella colonna `provinciauts_corretto` (es. "VALLE D'AOSTA/VALLÃ‰E D'AOSTE"), che richiederà un intervento di pulizia per garantire l'accuratezza delle analisi geografiche future.
-   **Dati 2024 Provvisori**: I dati relativi al 2024 sono da considerarsi provvisori e non consolidati, e potrebbero subire variazioni.

## 7. Implicazioni e Prossimi Passi

L'analisi conferma che i reati "Codice Rosso" sono un indicatore cruciale della violenza di genere, con una prevalenza significativa di vittime femminili e un trend in aumento. Le discrepanze tra i flussi di dati sottolineano la necessità di un approccio olistico per comprendere e contrastare il fenomeno.

-   **Approfondimento sulle Dinamiche di Emersione**: È fondamentale continuare a studiare le ragioni delle discrepanze per comprendere meglio le barriere alla denuncia e all'identificazione degli autori.
-   **Analisi Pro Capite**: Per una comparazione più accurata tra le province, si suggerisce di calcolare i tassi pro capite, normalizzando i dati per la popolazione residente.
-   **Correzione Encoding**: È fondamentale implementare un processo ETL per correggere il problema di encoding riscontrato nei nomi delle province.
-   **Visualizzazioni**: Sviluppare visualizzazioni interattive per esplorare le tendenze temporali, le distribuzioni geografiche e i profili demografici, facilitando la comprensione e la comunicazione degli insight.
-   **Interventi Multilivello**: Per migliorare l'emersione e il contrasto dei reati "Codice Rosso", sono necessari interventi su più fronti: sensibilizzazione, formazione delle forze dell'ordine, supporto alle vittime e analisi più granulare dei dati.