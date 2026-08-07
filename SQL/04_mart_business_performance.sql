-- ============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 04_mart_business_performance.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- Creates the business performance mart used for the
-- Executive Performance dashboard.
--
-- Grain:
-- One row represents one purchased order item.
--
-- Main dimensions:
-- - Order Date
-- - Acquisition Source
-- - Device Type
-- - Product
--
-- Main measures:
-- - Revenue
-- - COGS
-- - Gross Profit
-- - Refund
-- - Net Revenue
-- ============================================================

CREATE OR REPLACE VIEW `maven_fuzzy_Factory.mart_business_performance` AS

-- ============================================================
-- Session Attribution
-- Standardize acquisition source using UTM parameters and
-- referrer information.
-- ============================================================

WITH session_attribution AS (

    SELECT
        website_session_id,

        device_type,

        CASE
            WHEN utm_source <> 'NULL'
                THEN utm_source

            WHEN REGEXP_CONTAINS(http_referer, r'gsearch\.com')
                THEN 'gsearch'

            WHEN REGEXP_CONTAINS(http_referer, r'bsearch\.com')
                THEN 'bsearch'

            WHEN REGEXP_CONTAINS(http_referer, r'socialbook\.com')
                THEN 'socialbook'

            ELSE 'unattributed'
        END AS acquisition_source

    FROM `maven_fuzzy_Factory.website_sessions`

),

-- ============================================================
-- Refund Summary
-- Aggregate refund amount per order item.
-- ============================================================

refund_summary AS (

    SELECT
        order_item_id,

        SUM(refund_amount_usd) AS refund_amount,

        COUNT(DISTINCT order_item_refund_id)
            AS refund_transactions

    FROM `maven_fuzzy_Factory.order_item_refunds`

    GROUP BY
        order_item_id

)

-- ============================================================
-- Business Performance Mart
-- ============================================================

SELECT

    -- ==========================
    -- Date Dimension
    -- ==========================

    DATE(o.created_at) AS order_date,

    -- ==========================
    -- Order Dimension
    -- ==========================

    o.order_id,
    o.website_session_id,

    -- ==========================
    -- Marketing Dimension
    -- ==========================

    sa.acquisition_source,
    sa.device_type,

    -- ==========================
    -- Product Dimension
    -- ==========================

    oi.order_item_id,
    oi.product_id,
    p.product_name,

    -- ==========================
    -- Financial Measures
    -- ==========================

    oi.price_usd AS revenue,

    oi.cogs_usd AS cogs,

    oi.price_usd - oi.cogs_usd
        AS gross_profit,

    -- ==========================
    -- Refund Measures
    -- ==========================

    COALESCE(
        rs.refund_amount,
        0
    ) AS refund_amount,

    COALESCE(
        rs.refund_transactions,
        0
    ) AS refund_transactions,

    -- ==========================
    -- Post Refund Measures
    -- ==========================

    oi.price_usd
        - COALESCE(rs.refund_amount, 0)
        AS net_revenue_after_refund,

    (
        oi.price_usd
        - oi.cogs_usd
        - COALESCE(rs.refund_amount, 0)
    ) AS gross_profit_after_refund

FROM `maven_fuzzy_Factory.orders` AS o

INNER JOIN `maven_fuzzy_Factory.order_items` AS oi
    ON o.order_id = oi.order_id

INNER JOIN `maven_fuzzy_Factory.products` AS p
    ON oi.product_id = p.product_id

LEFT JOIN session_attribution AS sa
    ON o.website_session_id = sa.website_session_id

LEFT JOIN refund_summary AS rs
    ON oi.order_item_id = rs.order_item_id;
