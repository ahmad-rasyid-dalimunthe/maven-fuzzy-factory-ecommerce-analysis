-- =====================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 01_data_understanding.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- Initial exploration of the raw dataset to understand
-- table structures, data volume, date coverage,
-- primary key integrity, referential integrity,
-- categorical values, and missing values.
-- =====================================================

-- =====================================================
-- 1. DATASET OVERVIEW
-- =====================================================
-- Count the total number of records in each raw table.

SELECT
    'website_sessions' AS table_name,
    COUNT(*) AS row_count
FROM `maven_fuzzy_Factory.website_sessions`

UNION ALL

SELECT
    'website_pageviews',
    COUNT(*)
FROM `maven_fuzzy_Factory.website_pageviews`

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM `maven_fuzzy_Factory.orders`

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM `maven_fuzzy_Factory.order_items`

UNION ALL

SELECT
    'order_item_refunds',
    COUNT(*)
FROM `maven_fuzzy_Factory.order_item_refunds`

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM `maven_fuzzy_Factory.products`


-- =====================================================
-- 2. DATE COVERAGE
-- =====================================================
-- Identify the available time period across transactional tables.

SELECT
    'website_sessions' AS table_name,
    MIN(created_at) AS min_date,
    MAX(created_at) AS max_date
FROM `maven_fuzzy_Factory.website_sessions`

UNION ALL

SELECT
    'website_pageviews',
    MIN(created_at),
    MAX(created_at)
FROM `maven_fuzzy_Factory.website_pageviews`

UNION ALL

SELECT
    'orders',
    MIN(created_at),
    MAX(created_at)
FROM `maven_fuzzy_Factory.orders`

UNION ALL

SELECT
    'order_item_refunds',
    MIN(created_at),
    MAX(created_at)
FROM `maven_fuzzy_Factory.order_item_refunds`

ORDER BY min_date;

ORDER BY row_count DESC;


-- =====================================================
-- 3. PRIMARY KEY VALIDATION
-- =====================================================
-- Verify that each primary key contains unique values.

SELECT
    'website_sessions' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT website_session_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT website_session_id) AS duplicate_rows
FROM `maven_fuzzy_Factory.website_sessions`

UNION ALL

SELECT
    'website_pageviews',
    COUNT(*),
    COUNT(DISTINCT website_pageview_id),
    COUNT(*) - COUNT(DISTINCT website_pageview_id)
FROM `maven_fuzzy_Factory.website_pageviews`

UNION ALL

SELECT
    'orders',
    COUNT(*),
    COUNT(DISTINCT order_id),
    COUNT(*) - COUNT(DISTINCT order_id)
FROM `maven_fuzzy_Factory.orders`

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    COUNT(DISTINCT order_item_id),
    COUNT(*) - COUNT(DISTINCT order_item_id)
FROM `maven_fuzzy_Factory.order_items`

UNION ALL

SELECT
    'order_item_refunds',
    COUNT(*),
    COUNT(DISTINCT order_item_refund_id),
    COUNT(*) - COUNT(DISTINCT order_item_refund_id)
FROM `maven_fuzzy_Factory.order_item_refunds`

UNION ALL

SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(DISTINCT product_id)
FROM `maven_fuzzy_Factory.products`;


-- =====================================================
-- 4. REFERENTIAL INTEGRITY VALIDATION
-- =====================================================
-- Verify that all foreign key relationships are valid
-- and no orphan records exist.

-- 4.1 Orders → Website Sessions

SELECT
    'Orders → Website Sessions' AS relationship,
    COUNT(*) AS orphan_records
FROM `maven_fuzzy_Factory.orders` o
LEFT JOIN `maven_fuzzy_Factory.website_sessions` s
    ON o.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;

-- 4.2 Order Items → Orders

SELECT
    'Order Items → Orders' AS relationship,
    COUNT(*) AS orphan_records
FROM `maven_fuzzy_Factory.order_items` oi
LEFT JOIN `maven_fuzzy_Factory.orders` o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 4.3 Refunds → Order Items

SELECT
    'Refunds → Order Items' AS relationship,
    COUNT(*) AS orphan_records
FROM `maven_fuzzy_Factory.order_item_refunds` r
LEFT JOIN `maven_fuzzy_Factory.order_items` oi
    ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;

-- 4.4 Website Pageviews → Website Sessions

SELECT
    'Website Pageviews → Website Sessions' AS relationship,
    COUNT(*) AS orphan_records
FROM `maven_fuzzy_Factory.website_pageviews` p
LEFT JOIN `maven_fuzzy_Factory.website_sessions` s
    ON p.website_session_id = s.website_session_id
WHERE s.website_session_id IS NULL;


-- =====================================================
-- 5. CATEGORICAL DATA INSPECTION
-- =====================================================
-- Review categorical fields to understand available
-- dimensions for analysis.

-- 5.1 Device Types

SELECT
    device_type,
    COUNT(*) AS sessions
FROM `maven_fuzzy_Factory.website_sessions`
GROUP BY device_type
ORDER BY sessions DESC;

-- 5.2 Traffic Sources and Campaigns

SELECT
    utm_source,
    utm_campaign,
    COUNT(*) AS sessions
FROM `maven_fuzzy_Factory.website_sessions`
GROUP BY
    utm_source,
    utm_campaign
ORDER BY sessions DESC;

-- 5.3 Website URLs

SELECT
    pageview_url,
    COUNT(*) AS total_pageviews
FROM `maven_fuzzy_Factory.website_pageviews`
GROUP BY pageview_url
ORDER BY total_pageviews DESC;


-- =====================================================
-- 6. MISSING VALUE ASSESSMENT
-- =====================================================
-- Assess SQL NULL values and string 'NULL' values
-- across all raw tables.

WITH missing_values AS (

SELECT
    'website_sessions' AS table_name,
    COUNT(*) AS total_rows,
    COUNTIF(website_session_id IS NULL) AS sql_null_primary_key,
    COUNTIF(website_session_id = 'NULL') AS text_null_primary_key,
    COUNTIF(created_at IS NULL) AS sql_null_created_at

FROM `maven_fuzzy_Factory.website_sessions`

UNION ALL

SELECT
    'website_pageviews',
    COUNT(*),
    COUNTIF(website_pageview_id IS NULL),
    COUNTIF(CAST(website_pageview_id AS STRING) = 'NULL'),
    COUNTIF(created_at IS NULL)

FROM `maven_fuzzy_Factory.website_pageviews`

UNION ALL

SELECT
    'orders',
    COUNT(*),
    COUNTIF(order_id IS NULL),
    COUNTIF(CAST(order_id AS STRING) = 'NULL'),
    COUNTIF(created_at IS NULL)

FROM `maven_fuzzy_Factory.orders`

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    COUNTIF(order_item_id IS NULL),
    COUNTIF(CAST(order_item_id AS STRING) = 'NULL'),
    COUNTIF(created_at IS NULL)

FROM `maven_fuzzy_Factory.order_items`

UNION ALL

SELECT
    'order_item_refunds',
    COUNT(*),
    COUNTIF(order_item_refund_id IS NULL),
    COUNTIF(CAST(order_item_refund_id AS STRING) = 'NULL'),
    COUNTIF(created_at IS NULL)

FROM `maven_fuzzy_Factory.order_item_refunds`

UNION ALL

SELECT
    'products',
    COUNT(*),
    COUNTIF(product_id IS NULL),
    COUNTIF(CAST(product_id AS STRING) = 'NULL'),
    COUNTIF(created_at IS NULL)

FROM `maven_fuzzy_Factory.products`

)

SELECT *
FROM missing_values;



-- =====================================================
-- DATA UNDERSTANDING SUMMARY
-- =====================================================
-- Key observations:
-- • All primary keys are unique.
-- • No orphan records were found across table relationships.
-- • No SQL NULL values were detected in critical identifier fields.
-- • Several traffic attribution fields contain the string 'NULL'
--   rather than SQL NULL, requiring standardization during data cleaning.
-- • Dataset spans approximately three years of e-commerce activity.
