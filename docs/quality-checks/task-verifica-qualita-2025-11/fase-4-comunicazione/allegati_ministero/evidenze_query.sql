-- Query SQL DuckDB per validazione dati Ministero
-- File: MI-123-U-A-SD-2025-90_6.xlsx
-- Data: 2025-11-15

-- 1. Verifica struttura dati PROT_SDI (CRITICO) - FILE_6 ORIGINALE
SELECT 
    'STRUTTURA DATI PROT_SDI' as issue,
    COUNT(*) as total_records,
    COUNT(DISTINCT PROT_SDI) as unique_prot_sdi,
    COUNT(*) - COUNT(DISTINCT PROT_SDI) as record_multipli,
    ROUND((COUNT(*) - COUNT(DISTINCT PROT_SDI)) * 100.0 / COUNT(*), 1) as perc_multipli
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx');

-- 2. Analisi pattern multi-record PROT_SDI (esempio reale)
SELECT 
    'ESEMPIO CASO COMPLESSO' as issue,
    PROT_SDI as prot_sdi,
    COUNT(*) as record_totali,
    COUNT(DISTINCT COD_DENUNCIATO) as autori_distinti,
    COUNT(DISTINCT COD_VITTIMA) as vittime_distinte,
    COUNT(DISTINCT ART) as reati_distinti,
    FIRST(ART) as tipo_reato,
    FIRST(DES_REA_EVE) as descrizione_reato
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')
WHERE PROT_SDI = 'PGPQ102023002369    '
GROUP BY PROT_SDI;

-- 3. Distribuzione valori DES_OBIET (CRITICO)
SELECT 
    'DISTRIBUZIONE DES_OBIET' as issue,
    DES_OBIET as valore,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')), 1) as percentage
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')
GROUP BY DES_OBIET
ORDER BY count DESC
LIMIT 10;

-- 4. Domande critiche campo DES_OBIET (CRITICO)
SELECT 
    'DOMANDE CRITICHE DES_OBIET' as issue,
    'Cos''è questo campo?' as domanda1,
    'Vittima? Contesto? Luogo?' as dettaglio1
UNION ALL
SELECT 
    'DOMANDE CRITICHE DES_OBIET' as issue,
    'Fonte classificazione?' as domanda2,
    'ISTAT? Codice Penale? SDI interno?' as dettaglio2
UNION ALL
SELECT 
    'DOMANDE CRITICHE DES_OBIET' as issue,
    'Significato valori?' as domanda3,
    'PRIVATO CITTADINO vs NON PREVISTO/ALTRO?' as dettaglio3;

-- 5. Struttura campi FILE_6 (verifica completezza)
SELECT 
    des_obiet,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM read_csv_auto('data/processing/reati_sdi/reati_sdi.csv')), 1) as percentage
FROM read_csv_auto('data/processing/reati_sdi/reati_sdi.csv')
GROUP BY des_obiet
ORDER BY count DESC;

-- 6. Gap temporale art. 387 bis vs ISTAT (CRITICO)
SELECT 
    'GAP TEMPORALE ART. 387 BIS' as issue,
    EXTRACT(YEAR FROM CAST(DATA_INIZIO_FATTO AS DATE)) as anno_fatto,
    COUNT(*) as casi_sdi,
    -- Dati ISTAT di riferimento (da confrontare)
    0 as casi_istat_2019, -- 1.741 casi reali ISTAT
    0 as casi_istat_2020  -- Dati da reperire
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')
WHERE ART = 387
GROUP BY EXTRACT(YEAR FROM CAST(DATA_INIZIO_FATTO AS DATE))
ORDER BY anno_fatto;

-- 7. Analisi lag temporale fatti-denunce
SELECT 
    'LAG TEMPORALE FATTO-DENUNCIA' as issue,
    EXTRACT(YEAR FROM CAST(DATA_INIZIO_FATTO AS DATE)) as anno_fatto,
    COUNT(*) as casi,
    AVG(DATEDIFF(day, CAST(DATA_INIZIO_FATTO AS DATE), CAST(DATA_DENUNCIA AS DATE))) as lag_medio_giorni,
    MIN(DATEDIFF(day, CAST(DATA_INIZIO_FATTO AS DATE), CAST(DATA_DENUNCIA AS DATE))) as lag_minimo,
    MAX(DATEDIFF(day, CAST(DATA_INIZIO_FATTO AS DATE), CAST(DATA_DENUNCIA AS DATE))) as lag_massimo
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')
WHERE DATA_INIZIO_FATTO IS NOT NULL AND DATA_DENUNCIA IS NOT NULL
GROUP BY EXTRACT(YEAR FROM CAST(DATA_INIZIO_FATTO AS DATE))
ORDER BY anno_fatto;

-- 8. Completezza relazione Vittima-Autore (Eccellenza)
SELECT 
    'COMPLETEZZA RELAZIONE V-A' as issue,
    COUNT(*) as total_records,
    SUM(CASE WHEN RELAZIONE_AUTORE_VITTIMA IS NOT NULL AND RELAZIONE_AUTORE_VITTIMA != '' THEN 1 ELSE 0 END) as con_relazione,
    ROUND(SUM(CASE WHEN RELAZIONE_AUTORE_VITTIMA IS NOT NULL AND RELAZIONE_AUTORE_VITTIMA != '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as perc_completezza
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx');

-- 9. Distribuzione tipi relazione V-A
SELECT 
    RELAZIONE_AUTORE_VITTIMA as relazione_va,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')), 1) as percentage
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx')
WHERE RELAZIONE_AUTORE_VITTIMA IS NOT NULL AND RELAZIONE_AUTORE_VITTIMA != ''
GROUP BY RELAZIONE_AUTORE_VITTIMA
ORDER BY count DESC;

-- 10. Confronto scale FILE_5 vs FILE_6
SELECT 
    'CONFRONTO SCALE DATI' as issue,
    'FILE_5' as file_source,
    '928000' as record_stimati,
    'Dati aggregati comunicazioni SDI' as note
UNION ALL
SELECT 
    'CONFRONTO SCALE DATI' as issue,
    'FILE_6' as file_source,
    COUNT(*) as record_stimati,
    'Dati dettagliati reati genere' as note
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx');

-- 11. Metadati file (verifica mancanze)
SELECT 
    'METADATI FILE' as issue,
    'FILE_6 Excel originale' as file_name,
    COUNT(*) as righe,
    28 as colonne,
    'Apache POI' as autore_excel,
    'MANCANTE' as data_estrazione_sdi,
    'MANCANTE' as titolo_dataset,
    'MANCANTE' as descrizione_completa
FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx');