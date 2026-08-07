-- =============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 03_data_cleaning.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- This script documents the data cleaning and validation
-- process performed prior to feature engineering and
-- dashboard development.
--
-- The primary objective is to standardize marketing
-- attribution fields and validate key URLs used for
-- funnel analysis.
-- =============================================================

-- =============================================================
-- 1. INSPECT RAW MARKETING ATTRIBUTION
-- =============================================================
-- Review combinations of UTM parameters and referrer values
-- before standardization.

SELECT
    utm_source,
    utm_campaign,
    utm_content,
    http_referer,
    COUNT(*) AS sessions

FROM `maven_fuzzy_Factory.website_sessions`

GROUP BY
    utm_source,
    utm_campaign,
    utm_content,
    http_referer

ORDER BY sessions DESC;


-- =============================================================
-- 2. STANDARDIZE ACQUISITION SOURCE
-- =============================================================
-- Replace inconsistent traffic attribution by combining
-- UTM parameters and HTTP referrer into a standardized
-- acquisition source.

SELECT

    website_session_id,

    device_type,

    CASE

        WHEN utm_source != 'NULL'
            THEN utm_source

        WHEN utm_source = 'NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'gsearch\.com'
                )
            THEN 'gsearch'

        WHEN utm_source = 'NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'bsearch\.com'
                )
            THEN 'bsearch'

        WHEN utm_source = 'NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'socialbook\.com'
                )
            THEN 'socialbook'

        ELSE 'unattributed'

    END AS acquisition_source

FROM `maven_fuzzy_Factory.website_sessions`;


-- =============================================================
-- 3. VALIDATE STANDARDIZED ACQUISITION SOURCE
-- =============================================================
-- Verify that all sessions are classified into a
-- standardized acquisition source.

WITH cleaned_sessions AS (

SELECT

    website_session_id,

    CASE

        WHEN utm_source != 'NULL'
            THEN utm_source

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(http_referer,r'gsearch\.com')
            THEN 'gsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(http_referer,r'bsearch\.com')
            THEN 'bsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(http_referer,r'socialbook\.com')
            THEN 'socialbook'

        ELSE 'unattributed'

    END AS acquisition_source

FROM `maven_fuzzy_Factory.website_sessions`

)

SELECT

    acquisition_source,

    COUNT(*) AS sessions

FROM cleaned_sessions

GROUP BY acquisition_source

ORDER BY sessions DESC;


-- =============================================================
-- 4. VALIDATE PRODUCT DETAIL URLS
-- =============================================================
-- Verify product detail pages used in funnel analysis.

SELECT

    pageview_url,

    COUNT(*) AS pageviews,

    COUNT(DISTINCT website_session_id)
        AS unique_sessions

FROM `maven_fuzzy_Factory.website_pageviews`

WHERE pageview_url IN (

'/the-original-mr-fuzzy',

'/the-forever-love-bear',

'/the-birthday-sugar-panda',

'/the-hudson-river-mini-bear'

)

GROUP BY pageview_url

ORDER BY pageviews DESC;


-- =============================================================
-- 5. VALIDATE CHECKOUT URLS
-- =============================================================
-- Verify billing pages used in checkout funnel.

SELECT

    pageview_url,

    COUNT(*) AS pageviews,

    COUNT(DISTINCT website_session_id)
        AS unique_sessions

FROM `maven_fuzzy_Factory.website_pageviews`

WHERE pageview_url IN (

'/billing',

'/billing-2'

)

GROUP BY pageview_url

ORDER BY pageviews DESC;


-- =============================================================
-- DATA CLEANING SUMMARY
-- =============================================================
--
-- Cleaning Actions Performed
--
-- • Standardized acquisition sources using UTM parameters
--   and HTTP referrer.
--
-- • Consolidated traffic attribution into four categories:
--
--      - gsearch
--      - bsearch
--      - socialbook
--      - unattributed
--
-- • Validated all product detail URLs used in funnel
--   analysis.
--
-- • Validated all billing URLs used in checkout analysis.
--
-- These standardized fields are used throughout the
-- analytical data marts and Tableau dashboard.
--
-- =============================================================
