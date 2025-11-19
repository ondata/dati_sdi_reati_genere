# Analisi Geografiche Proposte - Dataset SDI Reati Genere

**Data:** 18 novembre 2025  
**Database:** `data/processed/reati_sdi_relazionale.duckdb`  
**Copertura geografica:** 20 regioni, 106 province, ~600 comuni  
**Eventi totali:** 2.644  
**Vittime totali:** 2.821 (72.6% italiane, 27.4% straniere)

## Prerequisiti

### Dati Disponibili

✅ **Codici ISTAT completi:**
- Regioni: 2.540/2.644 eventi (96.1%)
- Province: 2.533/2.644 eventi (95.8%)
- Comuni: 2.492/2.644 eventi (94.3%)

✅ **Codici ISO alpha-3:**
- Stati eventi: 2.644/2.644 (100%)
- Nazioni nascita vittime: 2.821/2.821 (100%)
- Nazioni nascita denunciati: 2.432/2.856 (85.2%)

⚠️ **Dati geografici esterni da acquisire:**
- Shapefile regioni Italia (fonte: ISTAT)
- Shapefile province Italia (fonte: ISTAT)
- Shapefile comuni Italia (fonte: ISTAT - opzionale, file pesante)

### Distribuzione Dati

**Top 10 Regioni per numero eventi:**

| Regione | Codice | Eventi | % |
|---------|--------|--------|---|
| LOMBARDIA | 03 | 367 | 13.9% |
| LAZIO | 12 | 287 | 10.9% |
| SICILIA | 19 | 264 | 10.0% |
| EMILIA ROMAGNA | 08 | 207 | 7.8% |
| VENETO | 05 | 185 | 7.0% |
| PIEMONTE | 01 | 174 | 6.6% |
| TOSCANA | 09 | 173 | 6.5% |
| CAMPANIA | 15 | 168 | 6.4% |
| UMBRIA | 10 | 148 | 5.6% |
| PUGLIA | 16 | 128 | 4.8% |

**Top 10 Province per numero eventi:**

| Provincia | Codice | Eventi |
|-----------|--------|--------|
| ROMA | 258 | 212 |
| PERUGIA | 054 | 137 |
| NAPOLI | 263 | 102 |
| MILANO | 215 | 100 |
| TORINO | 201 | 80 |
| BOLOGNA | 237 | 65 |
| BERGAMO | 016 | 57 |
| BRESCIA | 017 | 55 |
| CATANIA | 287 | 54 |
| MESSINA | 283 | 53 |

**Top 15 Nazioni nascita vittime:**

| Nazione | ISO | Vittime | Regioni coinvolte |
|---------|-----|---------|-------------------|
| ITALIA | ITA | 2.048 | 20 |
| ROMANIA | ROU | 140 | 18 |
| MAROCCO | MAR | 77 | 15 |
| ALBANIA | ALB | 53 | 12 |
| UCRAINA | UKR | 43 | 13 |
| NIGERIA | NGA | 40 | 12 |
| MOLDAVIA | MDA | 33 | 8 |
| TUNISIA | TUN | 31 | 9 |
| PERU' | PER | 30 | 9 |
| BRASILE | BRA | 23 | 9 |
| BANGLADESH | BGD | 16 | 9 |
| ECUADOR | ECU | 15 | 4 |
| SRI LANKA (CEYLON) | LKA | 14 | 7 |
| FRANCIA | FRA | 12 | 9 |
| GERMANIA | DEU | 12 | 8 |

---

## 1. Mappa Coropletica Regionale - Densità Eventi

### Obiettivo
Visualizzare la **distribuzione nazionale** degli eventi di violenza di genere per regione.

### Tipo Visualizzazione
Mappa coropletica Italia con scala di colori proporzionale al numero di eventi.

### Query SQL

```sql
SELECT 
  REGIONE,
  CODICE_REGIONE,
  COUNT(*) as n_eventi,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentuale
FROM eventi
WHERE REGIONE IS NOT NULL
GROUP BY REGIONE, CODICE_REGIONE
ORDER BY n_eventi DESC;
```

### Insights Attesi
- Identificazione **regioni critiche** (Lombardia, Lazio, Sicilia)
- Confronto Nord vs Centro vs Sud
- Possibile correlazione con densità popolazione

### Strumenti Suggeriti
- **Python:** GeoPandas + Matplotlib
- **R:** ggplot2 + sf
- **QGIS:** Mappa statica professionale

### Output
- Formato: PNG/SVG ad alta risoluzione
- Legenda: Scala colori + valori assoluti
- Titolo: "Distribuzione Eventi Violenza di Genere per Regione (2019-2024)"

---

## 2. Mappa Provinciale - Hotspot Violenza di Genere

### Obiettivo
Identificare **province critiche** con maggiore concentrazione di eventi.

### Tipo Visualizzazione
Mappa province con:
- Cerchi proporzionali (dimensione = numero eventi), oppure
- Scala colori coropletica provinciale

### Query SQL

```sql
SELECT 
  PROVINCIA,
  CODICE_PROVINCIA,
  REGIONE,
  COUNT(*) as n_eventi,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as percentuale
FROM eventi
WHERE PROVINCIA IS NOT NULL
GROUP BY PROVINCIA, CODICE_PROVINCIA, REGIONE
ORDER BY n_eventi DESC;
```

### Insights Attesi
- Hotspot urbani: Roma (212), Napoli (102), Milano (100)
- Province piccole ma critiche (es. Perugia 137 eventi)
- Disparità intra-regionali (es. Lombardia: Milano vs altre province)

### Varianti
1. **Mappa base:** Tutte le 106 province
2. **Mappa focus:** Solo province con >20 eventi
3. **Mappa confronto:** Nord vs Centro vs Sud (pannelli separati)

### Output
- Formato: PNG/PDF interattivo (con tooltip)
- Annotazioni: Top 5 province evidenziate
- Fonte dati: "Ministero Interno - SDI 2019-2024"

---

## 3. Distribuzione Geografica Vittime Straniere

### Obiettivo
Analizzare **dove si concentrano le vittime straniere** per nazione di origine.

### Tipo Visualizzazione
**Small multiples:** Serie di mini-mappe (una per nazione), oppure
**Mappa unica:** Con layer selezionabili per nazione

### Query SQL Base

```sql
SELECT 
  e.REGIONE,
  e.CODICE_REGIONE,
  v.NAZIONE_NASCITA_VITTIMA,
  v.NAZIONE_NASCITA_VITTIMA_ISO,
  COUNT(*) as n_vittime
FROM vittime v
JOIN eventi e ON v.PROT_SDI = e.PROT_SDI
WHERE v.NAZIONE_NASCITA_VITTIMA != 'ITALIA'
  AND e.REGIONE IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY n_vittime DESC;
```

### Query per Top 5 Nazioni

```sql
WITH top_nazioni AS (
  SELECT NAZIONE_NASCITA_VITTIMA
  FROM vittime
  WHERE NAZIONE_NASCITA_VITTIMA != 'ITALIA'
  GROUP BY NAZIONE_NASCITA_VITTIMA
  ORDER BY COUNT(*) DESC
  LIMIT 5
)
SELECT 
  e.REGIONE,
  e.CODICE_REGIONE,
  v.NAZIONE_NASCITA_VITTIMA,
  v.NAZIONE_NASCITA_VITTIMA_ISO,
  COUNT(*) as n_vittime
FROM vittime v
JOIN eventi e ON v.PROT_SDI = e.PROT_SDI
WHERE v.NAZIONE_NASCITA_VITTIMA IN (SELECT * FROM top_nazioni)
  AND e.REGIONE IS NOT NULL
GROUP BY 1, 2, 3, 4
ORDER BY v.NAZIONE_NASCITA_VITTIMA, n_vittime DESC;
```

### Insights Attesi
- **Romania:** Distribuzione in 18/20 regioni (più diffusa)
- **Ecuador:** Concentrata in 4 regioni (più localizzata)
- Correlazione con comunità immigrate residenti
- Identificazione **regioni critiche per comunità specifiche**

### Output Proposti
1. **Griglia 2x3:** Mappe piccole per top 5 nazioni + totale straniere
2. **Dashboard interattivo:** Selezione nazione → aggiorna mappa
3. **Report PDF:** Una pagina per nazione con mappa + statistiche

---

## 4. Confronto Italia vs Stranieri per Regione

### Obiettivo
Calcolare **incidenza percentuale vittime straniere** per regione.

### Tipo Visualizzazione
- Mappa coropletica: Colore = % vittime straniere
- Grafico a barre affiancate: Regione | Italiane | Straniere

### Query SQL

```sql
SELECT 
  e.REGIONE,
  e.CODICE_REGIONE,
  COUNT(CASE WHEN v.NAZIONE_NASCITA_VITTIMA = 'ITALIA' THEN 1 END) as vittime_italiane,
  COUNT(CASE WHEN v.NAZIONE_NASCITA_VITTIMA != 'ITALIA' THEN 1 END) as vittime_straniere,
  COUNT(*) as totale_vittime,
  ROUND(COUNT(CASE WHEN v.NAZIONE_NASCITA_VITTIMA != 'ITALIA' THEN 1 END) * 100.0 / COUNT(*), 2) as pct_straniere
FROM vittime v
JOIN eventi e ON v.PROT_SDI = e.PROT_SDI
WHERE e.REGIONE IS NOT NULL
GROUP BY e.REGIONE, e.CODICE_REGIONE
ORDER BY pct_straniere DESC;
```

### Insights Attesi
- Regioni con **alta % straniere**: possibili zone ad alta immigrazione
- Regioni con **bassa % straniere**: pattern diversi di vittimizzazione
- Confronto con dati ISTAT residenti stranieri per regione

### Output
- **Mappa:** Gradiente colore rosso (alta % straniere) → blu (bassa %)
- **Tabella comparativa:** Regione | % straniere | Rank
- **Correlazione:** Scatterplot % straniere vs % residenti stranieri ISTAT

---

## 5. Mappa Bipartita: Nazione Origine → Regione Evento

### Obiettivo
Visualizzare **flussi geografici** da nazione di origine a regione italiana dell'evento.

### Tipo Visualizzazione
- **Sankey Diagram:** Nazioni (sinistra) → Regioni (destra)
- **Chord Diagram:** Cerchio con collegamenti nazione-regione

### Query SQL

```sql
SELECT 
  v.NAZIONE_NASCITA_VITTIMA as nazione_origine,
  v.NAZIONE_NASCITA_VITTIMA_ISO as iso_origine,
  e.REGIONE as regione_evento,
  e.CODICE_REGIONE as cod_regione,
  COUNT(*) as n_vittime
FROM vittime v
JOIN eventi e ON v.PROT_SDI = e.PROT_SDI
WHERE v.NAZIONE_NASCITA_VITTIMA != 'ITALIA'
  AND e.REGIONE IS NOT NULL
GROUP BY 1, 2, 3, 4
HAVING COUNT(*) >= 3  -- Solo flussi significativi (≥3 vittime)
ORDER BY n_vittime DESC;
```

### Insights Attesi
- **Romania → Lombardia:** Flusso maggiore (vittime rumene in Lombardia)
- **Nigeria → Lazio/Campania:** Possibile pattern migratorio
- **Concentrazione vs dispersione:** Alcune nazioni concentrate, altre diffuse

### Output
- **Sankey interattivo (HTML):** Hover per dettagli numerici
- **Chord diagram statico (SVG):** Per pubblicazioni
- **Matrice origine-destinazione (CSV):** Per analisi ulteriori

---

## 6. Evoluzione Temporale Geografica

### Obiettivo
Mostrare **trend temporali regionali** degli eventi (2019-2024).

### Tipo Visualizzazione
- **Mappa animata:** Fotogrammi annuali con sfumatura colore
- **Small multiples:** 6 mappe (una per anno)
- **Serie temporali sovrapposte:** Linee per top 5 regioni

### Query SQL

```sql
SELECT 
  EXTRACT(YEAR FROM DATA_DENUNCIA) as anno,
  e.REGIONE,
  e.CODICE_REGIONE,
  COUNT(*) as n_eventi
FROM eventi e
WHERE DATA_DENUNCIA IS NOT NULL 
  AND REGIONE IS NOT NULL
  AND EXTRACT(YEAR FROM DATA_DENUNCIA) BETWEEN 2019 AND 2024
GROUP BY anno, e.REGIONE, e.CODICE_REGIONE
ORDER BY anno, n_eventi DESC;
```

### Query Variazione Anno su Anno

```sql
WITH eventi_annuali AS (
  SELECT 
    EXTRACT(YEAR FROM DATA_DENUNCIA) as anno,
    REGIONE,
    CODICE_REGIONE,
    COUNT(*) as n_eventi
  FROM eventi
  WHERE DATA_DENUNCIA IS NOT NULL AND REGIONE IS NOT NULL
  GROUP BY 1, 2, 3
)
SELECT 
  a.anno,
  a.REGIONE,
  a.CODICE_REGIONE,
  a.n_eventi as eventi_correnti,
  LAG(a.n_eventi) OVER (PARTITION BY a.REGIONE ORDER BY a.anno) as eventi_precedenti,
  a.n_eventi - LAG(a.n_eventi) OVER (PARTITION BY a.REGIONE ORDER BY a.anno) as variazione_assoluta,
  ROUND((a.n_eventi - LAG(a.n_eventi) OVER (PARTITION BY a.REGIONE ORDER BY a.anno)) * 100.0 / 
        NULLIF(LAG(a.n_eventi) OVER (PARTITION BY a.REGIONE ORDER BY a.anno), 0), 2) as variazione_pct
FROM eventi_annuali a
ORDER BY a.anno, variazione_pct DESC;
```

### Insights Attesi
- Regioni con **trend crescente** (allerta)
- Regioni con **trend decrescente** (possibili best practices)
- Impatto **COVID-19** (2020-2021)
- Effetto **Codice Rosso** (legge 2019)

### Output
1. **GIF animato:** Mappa che evolve 2019→2024
2. **Dashboard interattivo:** Slider temporale
3. **Report PDF:** 6 mappe affiancate + grafici trend

---

## 7. Analisi Comunale (Opzionale - Alta Granularità)

### Obiettivo
Identificare **comuni critici** con cluster di eventi.

### Tipo Visualizzazione
- Mappa puntuale (dot map) su base comunale
- Heatmap densità eventi

### Query SQL

```sql
SELECT 
  COMUNE,
  CODICE_COMUNE,
  PROVINCIA,
  REGIONE,
  COUNT(*) as n_eventi
FROM eventi
WHERE COMUNE IS NOT NULL 
  AND CODICE_COMUNE IS NOT NULL
GROUP BY 1, 2, 3, 4
HAVING COUNT(*) >= 5  -- Solo comuni con almeno 5 eventi
ORDER BY n_eventi DESC;
```

### Limiti
- 152 eventi (5.7%) senza comune specificato
- Shapefile comuni Italia molto pesante (~8000 geometrie)
- Possibili problemi privacy (piccoli comuni identificabili)

### Raccomandazione
⚠️ **Valutare attentamente privacy** prima di pubblicare analisi comunali nominative.  
Preferire **aggregazione a livello provinciale** per dati pubblici.

---

## Priorità di Implementazione

### 🥇 Priorità Alta (Fare Subito)

1. **Mappa Coropletica Regionale** - Vista d'insieme nazionale essenziale
2. **Mappa Provinciale Hotspot** - Granularità operativa per policy maker
3. **Distribuzione Vittime Straniere** - Analisi vulnerabilità comunità

### 🥈 Priorità Media (Seconda Fase)

4. **Confronto Italia vs Stranieri** - Analisi comparativa
5. **Mappa Bipartita Nazione→Regione** - Pattern migratori

### 🥉 Priorità Bassa (Opzionale)

6. **Evoluzione Temporale** - Richiede dati completi tutti gli anni
7. **Analisi Comunale** - Solo se privacy garantita

---

## Strumenti Tecnici Consigliati

### Python Stack
```bash
# Installazione librerie
pip install geopandas matplotlib plotly folium duckdb contextily
```

**Librerie:**
- `geopandas`: Manipolazione dati geografici
- `matplotlib`: Mappe statiche
- `plotly`: Mappe interattive
- `folium`: Mappe web leaflet
- `contextily`: Basemap OSM
- `duckdb`: Query database

### R Stack
```r
# Installazione pacchetti
install.packages(c("sf", "ggplot2", "tmap", "mapview", "DBI", "duckdb"))
```

**Pacchetti:**
- `sf`: Simple Features per dati geografici
- `ggplot2` + `geom_sf()`: Mappe eleganti
- `tmap`: Mappe tematiche
- `mapview`: Mappe interattive
- `duckdb`: Connessione database

### QGIS (GUI)
- **Pro:** Interfaccia grafica, mappe professionali
- **Contro:** Meno automazione, richiede competenze GIS
- **Uso:** Mappe finali per report/pubblicazioni

### Observable / D3.js (Web)
- **Pro:** Interattività massima, pubblicazione web
- **Contro:** Curva apprendimento alta
- **Uso:** Dashboard pubblici online

---

## Dati Geografici Esterni Necessari

### Shapefile ISTAT (da scaricare)

**Fonte:** https://www.istat.it/it/archivio/222527

**File necessari:**

1. **Limiti amministrativi regioni**
   - File: `Limiti01012024.zip` o più recente
   - Formato: SHP + DBF + SHX + PRJ
   - Chiave join: `COD_REG` (codice regione)

2. **Limiti amministrativi province**
   - File: Stesso ZIP regioni
   - Chiave join: `COD_PROV` (codice provincia)

3. **Limiti amministrativi comuni** (opzionale)
   - File: Stesso ZIP
   - Chiave join: `PRO_COM` (codice comune)
   - ⚠️ File molto pesante (~100 MB)

### Join con Dataset SDI

```python
import geopandas as gpd
import duckdb

# Carica shapefile ISTAT
gdf_regioni = gpd.read_file("Limiti01012024/Reg01012024.shp")

# Query dati SDI
con = duckdb.connect("data/processed/reati_sdi_relazionale.duckdb")
df_eventi = con.execute("""
    SELECT CODICE_REGIONE, REGIONE, COUNT(*) as n_eventi
    FROM eventi
    WHERE REGIONE IS NOT NULL
    GROUP BY CODICE_REGIONE, REGIONE
""").df()

# Join geografico
gdf_regioni['COD_REG'] = gdf_regioni['COD_REG'].astype(str).str.zfill(2)
gdf_merged = gdf_regioni.merge(
    df_eventi, 
    left_on='COD_REG', 
    right_on='CODICE_REGIONE',
    how='left'
)

# Mappa
gdf_merged.plot(column='n_eventi', cmap='YlOrRd', legend=True, figsize=(12,10))
```

---

## Checklist Pre-Analisi

Prima di iniziare le analisi geografiche, verificare:

- [ ] Database DuckDB aggiornato con codici ISTAT
- [ ] Database DuckDB aggiornato con codici ISO
- [ ] Shapefile ISTAT scaricati e decompressi
- [ ] Librerie Python/R installate e testate
- [ ] Query SQL validate su subset dati
- [ ] Palette colori accessibili (daltonici) scelte
- [ ] Valutazione privacy per dati comunali
- [ ] Piano pubblicazione output (formato, destinatari)

---

## Note Finali

**Limitazioni:**
- 152 eventi (5.7%) senza localizzazione comunale
- Dati 2024 non consolidati (possibile sottostima)
- Necessaria cautela interpretazione causale (correlazione ≠ causalità)

**Raccomandazioni:**
- Integrare con dati ISTAT popolazione per tassi pro-capite
- Considerare variabili socio-economiche (tasso povertà, istruzione)
- Confrontare con dati anni precedenti (se disponibili)

**Contatti per chiarimenti:**
- Script elaborazione: `scripts/pulisci_dataset.sh`
- Documentazione problemi: `docs/problemi_nomi_geografici.md`
- Database: `data/processed/reati_sdi_relazionale.duckdb`

---

**Documento redatto da:** Pipeline analisi dati  
**Ultima revisione:** 18 novembre 2025  
**Versione:** 1.0
