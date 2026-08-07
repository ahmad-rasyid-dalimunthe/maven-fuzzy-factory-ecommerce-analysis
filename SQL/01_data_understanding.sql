-- =============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 01_data_understanding.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- This script performs an initial assessment of the raw dataset
-- to understand its structure, data volume, temporal coverage,
-- key integrity, table relationships, categorical variables,
-- and overall data quality before any transformation or analysis.
-- =============================================================

-- =============================================================
-- 1. DATASET OVERVIEW
-- =============================================================
-- Count the number of records in each raw table to understand
-- dataset size and relative scale.

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
ORDER BY row_count DESC;


-- =============================================================
-- 2. DATE COVERAGE
-- =============================================================
-- Identify the available time period covered by each
-- transactional table.

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


-- =============================================================
-- 3. PRIMARY KEY VALIDATION
-- =============================================================
-- Verify that every table contains unique primary keys
-- and identify duplicate records if they exist.

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


-- =============================================================
-- 4. REFERENTIAL INTEGRITY VALIDATION
-- =============================================================
-- Verify that foreign key relationships are preserved
-- across all transactional tables.


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

-- 5.2 UTM Sources and Campaigns

SELECT
    utm_source,
    utm_campaign,
    COUNT(*) AS sessions
FROM `maven_fuzzy_Factory.website_sessions`
GROUP BY
    utm_source,
    utm_campaign
ORDER BY sessions DESC;

-- 5.3 Pagevew URLs

SELECT
    pageview_url,
    COUNT(*) AS total_pageviews
FROM `maven_fuzzy_Factory.website_pageviews`
GROUP BY pageview_url
ORDER BY total_pageviews DESC;


-- =============================================================
-- 6. MISSING VALUE ASSESSMENT
-- =============================================================
-- Review SQL NULL values and literal 'NULL' strings in
-- critical fields across all raw tables.
--
-- Note:
-- The dataset stores missing marketing attribution values
-- as the literal string 'NULL' instead of SQL NULL.
-- =============================================================

SELECT
    'website_sessions' AS table_name,

    COUNT(*) AS total_rows,

    -- Primary Key
    COUNTIF(website_session_id IS NULL) AS sql_null_session_id,

    -- Timestamp
    COUNTIF(created_at IS NULL) AS sql_null_created_at,

    -- Marketing Attribution
    COUNTIF(utm_source IS NULL) AS sql_null_utm_source,
    COUNTIF(utm_source = 'NULL') AS text_null_utm_source,

    COUNTIF(utm_campaign IS NULL) AS sql_null_utm_campaign,
    COUNTIF(utm_campaign = 'NULL') AS text_null_utm_campaign,

    COUNTIF(utm_content IS NULL) AS sql_null_utm_content,
    COUNTIF(utm_content = 'NULL') AS text_null_utm_content,

    COUNTIF(http_referer IS NULL) AS sql_null_http_referer,
    COUNTIF(http_referer = 'NULL') AS text_null_http_referer

FROM `maven_fuzzy_Factory.website_sessions`

UNION ALL

SELECT
    'website_pageviews',

    COUNT(*),

    COUNTIF(website_pageview_id IS NULL),

    COUNTIF(created_at IS NULL),

    NULL,
    NULL,

    NULL,
    NULL,

    NULL,
    NULL,

    COUNTIF(pageview_url IS NULL),
    COUNTIF(pageview_url = 'NULL')

FROM `maven_fuzzy_Factory.website_pageviews`

UNION ALL

SELECT
    'orders',

    COUNT(*),

    COUNTIF(order_id IS NULL),

    COUNTIF(created_at IS NULL),

    COUNTIF(website_session_id IS NULL),
    0,

    COUNTIF(primary_product_id IS NULL),
    0,

    NULL,
    NULL,

    NULL,
    NULL

FROM `maven_fuzzy_Factory.orders`

UNION ALL

SELECT
    'order_items',

    COUNT(*),

    COUNTIF(order_item_id IS NULL),

    COUNTIF(created_at IS NULL),

    COUNTIF(order_id IS NULL),
    0,

    COUNTIF(product_id IS NULL),
    0,

    NULL,
    NULL,

    NULL,
    NULL

FROM `maven_fuzzy_Factory.order_items`

UNION ALL

SELECT
    'order_item_refunds',

    COUNT(*),

    COUNTIF(order_item_refund_id IS NULL),

    COUNTIF(created_at IS NULL),

    COUNTIF(order_item_id IS NULL),
    0,

    COUNTIF(order_id IS NULL),
    0,

    NULL,
    NULL,

    NULL,
    NULL

FROM `maven_fuzzy_Factory.order_item_refunds`

UNION ALL

SELECT
    'products',

    COUNT(*),

    COUNTIF(product_id IS NULL),

    COUNTIF(created_at IS NULL),

    COUNTIF(product_name IS NULL),
    COUNTIF(product_name = 'NULL'),

    NULL,
    NULL,

    NULL,
    NULL,

    NULL,
    NULL

FROM `maven_fuzzy_Factory.products`

ORDER BY table_name;



-- =============================================================
-- DATA UNDERSTANDING SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • All primary keys are unique, indicating no duplicate
--   records across the raw tables.
--
-- • No orphan records were identified, confirming that all
--   foreign key relationships are intact.
--
-- • Critical identifier fields contain no SQL NULL values.
--
-- • Marketing attribution fields use the literal string
--   'NULL' instead of SQL NULL values, requiring
--   standardization during the data cleaning stage.
--
-- • The dataset captures the complete customer journey,
--   including website sessions, pageviews, orders,
--   order items, refunds, and product information.
--
-- These observations confirm that the dataset is suitable
-- for downstream cleaning, exploratory analysis,
-- feature engineering, and dashboard development.
--
-- =============================================================
