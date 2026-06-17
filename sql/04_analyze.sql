-- ============================================================================
-- 04_analyze.sql  —  Fase 4 Analyze (Google DA Capstone)
-- Dataset: data/clean/hotel_bookings_clean.csv  ·  Foco: City Hotel (Lisboa)
-- Motor: DuckDB
--
-- Adaptacion a SQL puro de las queries del notebook 03_analyze.ipynb
-- (auditadas 2x: pandas vs DuckDB). Ejecutadas y verificadas el 2026-06-16:
-- todas reproducen las cifras del informe.
--
-- Ejecucion (CLI DuckDB, desde la carpeta sql/):
--   duckdb < 04_analyze.sql
-- Las rutas son relativas a sql/  ->  ../data/clean/...
--
-- BASE DE REFERENCIA: City Hotel, 53.050 reservas, cancelacion 30,07%
-- ============================================================================


-- ----------------------------------------------------------------------------
-- Q0 · SETUP — vistas de trabajo
--   bookings = todo el CSV  ·  city = solo City Hotel
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW bookings AS
    SELECT * FROM '../data/clean/hotel_bookings_clean.csv';

CREATE OR REPLACE VIEW city AS
    SELECT * FROM bookings WHERE hotel = 'City Hotel';

-- Verificacion: total bookings vs total city
SELECT
    (SELECT COUNT(*) FROM bookings) AS total_bookings,
    (SELECT COUNT(*) FROM city)     AS total_city;


-- ----------------------------------------------------------------------------
-- Q1 · DESCRIPTIVAS — media, mediana, min, max, desv. estandar
--   Variables clave: lead_time, adr, total_of_special_requests (vista city)
-- ----------------------------------------------------------------------------
SELECT 'lead_time' AS variable,
       ROUND(AVG(lead_time), 2)    AS media,
       ROUND(MEDIAN(lead_time), 2) AS mediana,
       MIN(lead_time)              AS minimo,
       MAX(lead_time)              AS maximo,
       ROUND(STDDEV(lead_time), 2) AS desv_std
FROM city
UNION ALL
SELECT 'adr',
       ROUND(AVG(adr), 2), ROUND(MEDIAN(adr), 2),
       MIN(adr), MAX(adr), ROUND(STDDEV(adr), 2)
FROM city
UNION ALL
SELECT 'special_requests',
       ROUND(AVG(total_of_special_requests), 2),
       ROUND(MEDIAN(total_of_special_requests), 2),
       MIN(total_of_special_requests),
       MAX(total_of_special_requests),
       ROUND(STDDEV(total_of_special_requests), 2)
FROM city;

-- Tasa de cancelacion global de la vista city (= 30,07 %)
SELECT ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct
FROM city;


-- ----------------------------------------------------------------------------
-- Q2 · P1 — cancelacion por MES, desglosada por anio
--   Hallazgo: estacionalidad debil; solo abril estable sobre base
--   (2016 = 31,1 % , 2017 = 37,5 %). March 2016 = 27,3 , October 2016 = 31,8.
-- ----------------------------------------------------------------------------
SELECT
    arrival_date_month,
    ROUND(AVG(CASE WHEN arrival_date_year = 2015 THEN is_canceled END) * 100, 1) AS pct_2015,
    ROUND(AVG(CASE WHEN arrival_date_year = 2016 THEN is_canceled END) * 100, 1) AS pct_2016,
    ROUND(AVG(CASE WHEN arrival_date_year = 2017 THEN is_canceled END) * 100, 1) AS pct_2017,
    ROUND(AVG(is_canceled) * 100, 1) AS pct_total,
    SUM(is_canceled)                 AS canceladas_total,
    COUNT(*)                         AS reservas_total
FROM city
GROUP BY arrival_date_month
ORDER BY CASE arrival_date_month
    WHEN 'January' THEN 1  WHEN 'February' THEN 2  WHEN 'March' THEN 3
    WHEN 'April' THEN 4    WHEN 'May' THEN 5       WHEN 'June' THEN 6
    WHEN 'July' THEN 7     WHEN 'August' THEN 8    WHEN 'September' THEN 9
    WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12
END;


-- ----------------------------------------------------------------------------
-- Q3 · P2 — cancel rate por TRAMO de lead_time
--   Hallazgo: monotonico 10,51 % (0-7) -> 44,87 % (180+). Umbral de corte: 90+.
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN lead_time <= 7   THEN '0-7'
        WHEN lead_time <= 30  THEN '8-30'
        WHEN lead_time <= 90  THEN '31-90'
        WHEN lead_time <= 180 THEN '91-180'
        ELSE '180+'
    END AS tramo_lead_time,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY tramo_lead_time
ORDER BY MIN(lead_time);


-- ----------------------------------------------------------------------------
-- Q4 · P3a — cancel rate por market_segment
--   Hallazgo: Online TA = 36,10 %. (Se mantiene el COUNT visible: los grupos
--   pequeños no son comparables con los grandes.)
-- ----------------------------------------------------------------------------
SELECT
    market_segment,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
WHERE market_segment IS NOT NULL
GROUP BY market_segment
ORDER BY cancel_rate_pct DESC;


-- ----------------------------------------------------------------------------
-- Q5 · P3b — cancel rate por distribution_channel
-- ----------------------------------------------------------------------------
SELECT
    distribution_channel,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
WHERE distribution_channel IS NOT NULL
GROUP BY distribution_channel
ORDER BY cancel_rate_pct DESC;


-- ----------------------------------------------------------------------------
-- Q6 · P3c — PESO de cada segmento sobre el total de cancelaciones
--   Hallazgo: Online TA = 79 % de TODAS las cancelaciones (65 % del volumen).
-- ----------------------------------------------------------------------------
SELECT
    market_segment,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled) * 100.0 / (SELECT SUM(is_canceled) FROM city), 2)
        AS pct_del_total_cancelaciones
FROM city
WHERE market_segment IS NOT NULL
GROUP BY market_segment
ORDER BY canceladas DESC;


-- ----------------------------------------------------------------------------
-- Q7 · P3d — Online TA vs TODO EL RESTO
--   Hallazgo: 36,10 % vs 18,62 % = 1,9x.
-- ----------------------------------------------------------------------------
SELECT
    CASE WHEN market_segment = 'Online TA' THEN 'Online TA' ELSE 'Resto' END AS grupo,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
WHERE market_segment IS NOT NULL
GROUP BY grupo;


-- ----------------------------------------------------------------------------
-- Q8 · P4a — cancel rate por deposit_type
--   Hallazgo: Non Refund = 97,16 % (n=844, 1,6 % de reservas) = SELECCION,
--   no causalidad (se confirma en Q9 y Q9b).
-- ----------------------------------------------------------------------------
SELECT
    deposit_type,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY deposit_type
ORDER BY cancel_rate_pct DESC;


-- ----------------------------------------------------------------------------
-- Q8b · P4a (cruce) — deposit_type x market_segment: ¿quien usa cada deposito?
--   Soporta la lectura de seleccion: las Non Refund son 91 % Groups + Offline TA/TO.
-- ----------------------------------------------------------------------------
SELECT
    deposit_type,
    market_segment,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
WHERE market_segment IS NOT NULL
GROUP BY deposit_type, market_segment
ORDER BY deposit_type, reservas DESC;


-- ----------------------------------------------------------------------------
-- Q9 · P4b — antelacion por deposit_type
--   Hallazgo: Non Refund mediana 198,5 d vs ~49 d el resto -> no es el deposito,
--   es que son reservas de mucho lead time.
-- ----------------------------------------------------------------------------
SELECT
    deposit_type,
    ROUND(AVG(lead_time), 1)    AS lead_time_medio,
    ROUND(MEDIAN(lead_time), 1) AS lead_time_mediana,
    COUNT(*)                    AS reservas
FROM city
GROUP BY deposit_type
ORDER BY lead_time_medio DESC;


-- ----------------------------------------------------------------------------
-- Q10 · P5a — cancel rate por CUARTIL de ADR (NTILE 4)
--   Hallazgo: debil, 23,33 % -> 34,76 % del cuartil 1 al 4.
--   (Nota: empates en NTILE -> reproducibilidad ±0,1pp.)
-- ----------------------------------------------------------------------------
WITH q AS (
    SELECT is_canceled, adr,
           NTILE(4) OVER (ORDER BY adr) AS adr_quartile
    FROM city
)
SELECT
    adr_quartile,
    MIN(adr)                         AS adr_min,
    MAX(adr)                         AS adr_max,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM q
GROUP BY adr_quartile
ORDER BY adr_quartile;


-- ----------------------------------------------------------------------------
-- Q11 · P5b — cancel rate por nº de special_requests
-- ----------------------------------------------------------------------------
SELECT
    total_of_special_requests AS special_requests,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;


-- ----------------------------------------------------------------------------
-- Q12 · P5c — 0 peticiones vs 1+ (tasa, peso en volumen, peso en cancelaciones)
--   Hallazgo: 0 = 38,36 % vs 1+ = 21,99 % (1,74x); 0 = 49 % del volumen y
--   63 % de las cancelaciones.
-- ----------------------------------------------------------------------------
SELECT
    CASE WHEN total_of_special_requests = 0 THEN '0' ELSE '1+' END AS peticiones,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM city), 2)                 AS pct_del_volumen,
    ROUND(SUM(is_canceled) * 100.0 / (SELECT SUM(is_canceled) FROM city), 2) AS pct_de_cancelaciones
FROM city
GROUP BY peticiones
ORDER BY peticiones;


-- ----------------------------------------------------------------------------
-- Q13 · P6a — cancel rate por is_repeated_guest
--   Hallazgo: repeat guest = 11,35 % (y son solo ~3 % del volumen).
-- ----------------------------------------------------------------------------
SELECT
    is_repeated_guest,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY is_repeated_guest
ORDER BY is_repeated_guest;


-- ----------------------------------------------------------------------------
-- Q13b · P6a — cancel rate por previous_cancellations (0, 1, 2+)
--   Hallazgo: 1 previa = 80,35 % ; anomalia: 2+ previas = 15,24 % (n=210, baja).
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN previous_cancellations = 0 THEN '0'
        WHEN previous_cancellations = 1 THEN '1'
        ELSE '2+'
    END AS cancelaciones_previas,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY cancelaciones_previas
ORDER BY cancelaciones_previas;


-- ----------------------------------------------------------------------------
-- Q14 · P6b — cruce previous_cancellations x deposit_type
--   ¿El grupo "1 previa" es otra cara del Non Refund o es independiente?
--   Hallazgo: 1 previa con No Deposit = 75,68 % (n=777) -> INDEPENDIENTE de P4.
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN previous_cancellations = 0 THEN '0'
        WHEN previous_cancellations = 1 THEN '1'
        ELSE '2+'
    END AS cancelaciones_previas,
    deposit_type,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
GROUP BY cancelaciones_previas, deposit_type
ORDER BY cancelaciones_previas, reservas DESC;


-- ----------------------------------------------------------------------------
-- Q15 · CRUCE DE MAXIMO RIESGO — Online TA x lead_time > 90  (TITULAR Fase 5)
--   Hallazgo: 44,70 % de cancelacion (3,1x el suelo 14,37 %), 23 % del volumen
--   y 34 % de TODAS las cancelaciones. Las senales se POTENCIAN, no se suman.
-- ----------------------------------------------------------------------------
SELECT
    CASE WHEN market_segment = 'Online TA' THEN 'Online TA' ELSE 'Resto' END
        || ' · ' ||
    CASE WHEN lead_time > 90 THEN 'lead >90' ELSE 'lead 0-90' END AS grupo,
    ROUND(AVG(is_canceled) * 100, 2) AS cancel_rate_pct,
    SUM(is_canceled)                 AS canceladas,
    COUNT(*)                         AS reservas
FROM city
WHERE market_segment IS NOT NULL
GROUP BY grupo
ORDER BY cancel_r