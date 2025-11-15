-- Query di validazione osservazioni Rossella
-- FILE_6: MI-123-U-A-SD-2025-90_6.xlsx
-- Data validazione: 2025-11-15

-- ==============================================================================
-- SETUP: Carica file Excel in DuckDB
-- ==============================================================================

INSTALL spatial;
LOAD spatial;

CREATE OR REPLACE TABLE file6 AS
SELECT * FROM st_read('data/rawdata/MI-123-U-A-SD-2025-90_6.xlsx');

-- ==============================================================================
-- QUERY 1: Distribuzione per anno denuncia (Osservazione Rossella)
-- ==============================================================================
-- Rossella dice: 2019: 5, 2020: 5, 2021: 3, 2022: 13, 2023: 530, 2024: 4.277

SELECT
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi_totali
FROM file6
WHERE DATA_DENUNCIA IS NOT NULL
GROUP BY anno_denuncia
ORDER BY anno_denuncia;

-- ==============================================================================
-- QUERY 2: Periodo agosto 2019 - agosto 2020 per art. 558 bis
-- ==============================================================================
-- Rossella dice: 0 casi nel periodo (solo 8 casi in 2024)
-- ISTAT report: 11 casi nel periodo agosto 2019 - agosto 2020

SELECT
    COUNT(*) AS casi_558bis_periodo_istat,
    MIN(DATA_DENUNCIA) AS prima_denuncia,
    MAX(DATA_DENUNCIA) AS ultima_denuncia
FROM file6
WHERE ART = 558
  AND DES_REA_EVE LIKE '%BIS%'
  AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31';

-- Distribuzione completa art. 558 bis per anno denuncia
SELECT
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi_558bis
FROM file6
WHERE ART = 558
  AND DES_REA_EVE LIKE '%BIS%'
GROUP BY anno_denuncia
ORDER BY anno_denuncia;

-- ==============================================================================
-- QUERY 3: Periodo agosto 2019 - agosto 2020 per art. 583 quinquies
-- ==============================================================================
-- Rossella dice: 1 caso (in 2024)
-- ISTAT report: 56 casi nel periodo agosto 2019 - agosto 2020

SELECT
    COUNT(*) AS casi_583quinquies_periodo_istat,
    MIN(DATA_DENUNCIA) AS prima_denuncia,
    MAX(DATA_DENUNCIA) AS ultima_denuncia
FROM file6
WHERE ART = 583
  AND DES_REA_EVE LIKE '%QUINQUIES%'
  AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31';

-- Distribuzione completa art. 583 quinquies per anno denuncia
SELECT
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi_583quinquies
FROM file6
WHERE ART = 583
  AND DES_REA_EVE LIKE '%QUINQUIES%'
GROUP BY anno_denuncia
ORDER BY anno_denuncia;

-- ==============================================================================
-- QUERY 4: Periodo agosto 2019 - agosto 2020 per art. 387 bis
-- ==============================================================================
-- Rossella dice: 0 casi nel periodo (69 casi totali in 2023-2024)
-- ISTAT report: 1.741 casi nel periodo agosto 2019 - agosto 2020

SELECT
    COUNT(*) AS casi_387bis_periodo_istat,
    MIN(DATA_DENUNCIA) AS prima_denuncia,
    MAX(DATA_DENUNCIA) AS ultima_denuncia
FROM file6
WHERE ART = 387
  AND DES_REA_EVE LIKE '%BIS%'
  AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31';

-- Distribuzione completa art. 387 bis per anno denuncia
SELECT
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi_387bis
FROM file6
WHERE ART = 387
  AND DES_REA_EVE LIKE '%BIS%'
GROUP BY anno_denuncia
ORDER BY anno_denuncia;

-- ==============================================================================
-- QUERY 5: Filtro alternativo - DATA_INIZIO_FATTO vs DATA_DENUNCIA
-- ==============================================================================
-- Rossella: "Applicando filtro data inizio/fine atto, numeri cambiano leggermente"

-- Distribuzione per anno INIZIO FATTO
SELECT
    YEAR(CAST(DATA_INIZIO_FATTO AS DATE)) AS anno_fatto,
    COUNT(*) AS casi_totali
FROM file6
WHERE DATA_INIZIO_FATTO IS NOT NULL
GROUP BY anno_fatto
ORDER BY anno_fatto;

-- Confronto diretto: anno denuncia vs anno fatto
SELECT
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    YEAR(CAST(DATA_INIZIO_FATTO AS DATE)) AS anno_fatto,
    COUNT(*) AS casi
FROM file6
WHERE DATA_DENUNCIA IS NOT NULL
  AND DATA_INIZIO_FATTO IS NOT NULL
GROUP BY anno_denuncia, anno_fatto
ORDER BY anno_denuncia, anno_fatto;

-- ==============================================================================
-- QUERY 6: LAG TEMPORALE - Fatto 2019-2020 denunciato in anni successivi
-- ==============================================================================

SELECT
    YEAR(CAST(DATA_INIZIO_FATTO AS DATE)) AS anno_fatto,
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi,
    ROUND(AVG(DATEDIFF('day',
        CAST(DATA_INIZIO_FATTO AS DATE),
        CAST(DATA_DENUNCIA AS DATE)
    ))) AS lag_medio_giorni
FROM file6
WHERE DATA_INIZIO_FATTO IS NOT NULL
  AND DATA_DENUNCIA IS NOT NULL
  AND YEAR(CAST(DATA_INIZIO_FATTO AS DATE)) IN (2019, 2020)
GROUP BY anno_fatto, anno_denuncia
ORDER BY anno_fatto, anno_denuncia;

-- ==============================================================================
-- QUERY 7: Art. 387 bis - Analisi approfondita lag temporale
-- ==============================================================================

SELECT
    YEAR(CAST(DATA_INIZIO_FATTO AS DATE)) AS anno_fatto,
    YEAR(CAST(DATA_DENUNCIA AS DATE)) AS anno_denuncia,
    COUNT(*) AS casi,
    ROUND(AVG(DATEDIFF('day',
        CAST(DATA_INIZIO_FATTO AS DATE),
        CAST(DATA_DENUNCIA AS DATE)
    ))) AS lag_medio_giorni,
    MIN(DATEDIFF('day',
        CAST(DATA_INIZIO_FATTO AS DATE),
        CAST(DATA_DENUNCIA AS DATE)
    )) AS lag_min_giorni,
    MAX(DATEDIFF('day',
        CAST(DATA_INIZIO_FATTO AS DATE),
        CAST(DATA_DENUNCIA AS DATE)
    )) AS lag_max_giorni
FROM file6
WHERE ART = 387
  AND DES_REA_EVE LIKE '%BIS%'
  AND DATA_INIZIO_FATTO IS NOT NULL
  AND DATA_DENUNCIA IS NOT NULL
GROUP BY anno_fatto, anno_denuncia
ORDER BY anno_fatto, anno_denuncia;

-- ==============================================================================
-- QUERY 8: Tabella comparativa ISTAT vs FILE_6
-- ==============================================================================

WITH istat_data AS (
    SELECT 558 AS articolo, 'bis' AS variante, 11 AS casi_istat UNION ALL
    SELECT 583, 'quinquies', 56 UNION ALL
    SELECT 387, 'bis', 1741
),
file6_data AS (
    SELECT
        558 AS articolo,
        'bis' AS variante,
        COUNT(*) AS casi_file6_periodo
    FROM file6
    WHERE ART = 558
      AND DES_REA_EVE LIKE '%BIS%'
      AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31'
    UNION ALL
    SELECT
        583,
        'quinquies',
        COUNT(*)
    FROM file6
    WHERE ART = 583
      AND DES_REA_EVE LIKE '%QUINQUIES%'
      AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31'
    UNION ALL
    SELECT
        387,
        'bis',
        COUNT(*)
    FROM file6
    WHERE ART = 387
      AND DES_REA_EVE LIKE '%BIS%'
      AND CAST(DATA_DENUNCIA AS DATE) BETWEEN '2019-08-01' AND '2020-08-31'
)
SELECT
    i.articolo,
    i.variante,
    i.casi_istat AS istat_agosto2019_agosto2020,
    f.casi_file6_periodo AS file6_agosto2019_agosto2020,
    i.casi_istat - f.casi_file6_periodo AS gap,
    ROUND(100.0 * f.casi_file6_periodo / i.casi_istat, 2) AS percentuale_copertura
FROM istat_data i
LEFT JOIN file6_data f ON i.articolo = f.articolo AND i.variante = f.variante
ORDER BY i.articolo;
