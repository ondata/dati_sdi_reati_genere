## Descrizione dei dati

Questa cartella contiene i dati rilasciati a seguito dell'accesso civico generalizzato presentato da Giulia Sudano in data 18 aprile 2025 e riscontrato il 9 maggio 2025, relativi a reati connessi alla violenza di genere. I dati sono stati forniti dal Dipartimento della Pubblica Sicurezza del Ministero dell'Interno e riguardano il periodo 2019-2024 (con i dati 2024 non ancora consolidati).

### Fonte dei dati

- SDI (Sistema di Indagine) / SSD (Sistema di Sorveglianza Dati) - per i reati e le comunicazioni con relazione vittima/autore
- DCPC (Direzione Centrale della Polizia Criminale) - per gli omicidi volontari consumati

## Differenza tra i due file principali

Il file `MI-123-U-A-SD-2025-90_5.xlsx` contiene **statistiche ufficiali sui reati** commessi (omicidi, violenze, minacce, ecc.) **registrati dalle forze dell'ordine** e disaggregati **per provincia**. Si tratta di dati strutturati e conteggiati secondo le categorie di reato previste dal codice penale.

Il file `MI-123-U-A-SD-2025-90_6.xlsx`, invece, raccoglie **comunicazioni SDI** in cui è presente una **relazione vittima-autore** e sono **disaggregate fino al livello comunale**. Questi dati rappresentano l'elenco delle comunicazioni presenti in SDI riconducibili ai casi di violenza di genere.

## File presenti

### 1. `MI-123-U-A-SD-2025-90_5.xlsx`

Contiene i dati relativi alle seguenti tipologie di reato:

- Omicidi
- Tentati omicidi
- Lesioni dolose
- Percosse
- Minacce
- Violenze sessuali
- Atti persecutori
- Maltrattamenti contro familiari e conviventi
- Costrizione o induzione al matrimonio
- Deformazione dell'aspetto mediante lesioni permanenti al viso
- Diffusione illecita di immagini o video sessualmente espliciti
- Violazione dei provvedimenti di allontanamento o divieto di avvicinamento

Ogni reato è disaggregato per:

- Provincia
- Anno (2019-2024)
- Totale casi
- Vittime di sesso femminile

Nel caso degli omicidi, è presente una tabella specifica con ulteriori disaggregazioni:

- Totali con vittime donne
- In ambito familiare/affettivo
- Compiuti da partner o ex partner

È suddiviso in 10 fogli:

1. **Omicidi DCPC**: Omicidi volontari consumati in Italia (fonte D.C.P.C. - dati operativi, non consolidati)
2. **Delitti - Commessi**: Numero reati commessi disaggregati a livello provinciale
3. **Delitti - Vittime**: Numero vittime di sesso femminile disaggregate a livello provinciale
4. **Delitti - Segnalazioni**: Segnalazioni a carico dei presunti autori noti, per sesso e fasce d'età con vittima di sesso femminile
5. **Reati spia - Commessi**: Numero reati commessi disaggregati a livello provinciale
6. **Reati spia - Vittime**: Numero vittime di sesso femminile disaggregate a livello provinciale
7. **Reati spia - Segnalazioni**: Segnalazioni a carico dei presunti autori noti, per sesso e fasce d'età con vittima di sesso femminile
8. **Codice Rosso - Commessi**: Numero reati commessi disaggregati a livello provinciale
9. **Codice Rosso - Vittime**: Numero vittime di sesso femminile disaggregate a livello provinciale
10. **Codice Rosso - Segnalazioni**: Segnalazioni a carico dei presunti autori noti, per sesso e fasce d'età con vittima di sesso femminile

*Nota: I fogli 2-10 contengono dati di fonte SDI/SSD non consolidati per il 2024 e quindi suscettibili di variazioni.*

### 2. `MI-123-U-A-SD-2025-90_6.xlsx`

Contiene le comunicazioni registrate nel sistema SDI riconducibili a episodi di violenza di genere, dove è indicata una relazione vittima-autore.

I dati sono disaggregati fino al livello comunale (luogo del fatto) e comprendono:

- Tipo di relazione tra vittima e autore
- Luogo del fatto (Comune)
- Numero di comunicazioni per anno (2019-2024)
- descrizione del reato
- data inizio e fine del fatto
- data della denuncia
- età e genere e nazionalità della vittima
- età e genere e nazionalità denunciato
- Reato Tentato o Consumato
- Stato in cui è avvenuto il reato (suppongo Null == Italia)
- Luogo in cui è avvenuto il fatto


## Limitazioni

- I dati 2024 non sono consolidati e potrebbero essere soggetti a variazioni.
- I dati a livello comunale non sono stati forniti per i reati in senso stretto (file `_5.xlsx`), ma solo per le comunicazioni con relazione vittima/autore (file `_6.xlsx`), per motivi legati alla normativa sulla privacy (Delibera Garante n. 515 del 19/12/2018).
- Non è presente una classificazione specifica dei "femminicidi", in quanto non previsti dal codice penale come fattispecie autonoma.
