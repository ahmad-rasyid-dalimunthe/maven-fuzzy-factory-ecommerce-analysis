-- ============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 06_mart_refund_analysis.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- Creates the refund analysis mart used for the
-- Refund Performance dashboard.
--
-- Grain:
-- One row represents one purchased order item.
--
-- Main dimensions:
-- - Order Date
-- - Product
-- - Acquisition Source
-- - Device Type
--
-- Main measures:
-- - Revenue
-- - Gross Profit
-- - Refund Amount
-- - Refund Rate
-- - Recoverable Revenue
-- ============================================================

CREATE OR REPLACE VIEW `maven_fuzzy_Factory.mart_refund_analysis` AS

-- ============================================================
-- Session Attribution
-- Standardize acquisition source using UTM parameters
-- and referrer information.
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
-- Aggregate refund amount for each order item.
-- ============================================================

refund_summary AS (

    SELECT

        order_item_id,

        SUM(refund_amount_usd) AS refund_amount

    FROM `maven_fuzzy_Factory.order_item_refunds`

    GROUP BY
        order_item_id

),

-- ============================================================
-- Base Refund Dataset
-- One row per purchased order item.
-- ============================================================

base_data AS (

    SELECT

        -- ==========================
        -- Order Dimension
        -- ==========================

        oi.order_item_id,

        oi.order_id,

        DATE(oi.created_at) AS order_date,

        oi.created_at AS order_item_created_at,

        o.created_at AS order_created_at,

        o.website_session_id,

        -- ==========================
        -- Product Dimension
        -- ==========================

        oi.product_id,

        p.product_name,

        -- ==========================
        -- Marketing Dimension
        -- ==========================

        sa.acquisition_source,

        sa.device_type,

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

        CASE
            WHEN rs.refund_amount IS NOT NULL
                THEN 1
            ELSE 0
        END AS refund_flag,

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

    FROM `maven_fuzzy_Factory.order_items` AS oi

    LEFT JOIN `maven_fuzzy_Factory.products` AS p
        ON oi.product_id = p.product_id

    LEFT JOIN `maven_fuzzy_Factory.orders` AS o
        ON oi.order_id = o.order_id

    LEFT JOIN session_attribution AS sa
        ON o.website_session_id = sa.website_session_id

    LEFT JOIN refund_summary AS rs
        ON oi.order_item_id = rs.order_item_id

),

-- ============================================================
-- Store Benchmark
-- Overall refund rate across the business.
-- ============================================================

store_metrics AS (

    SELECT

        SAFE_DIVIDE(

            SUM(refund_amount),

            SUM(revenue)

        ) AS store_refund_rate

    FROM base_data

),

-- ============================================================
-- Product Benchmark
-- Refund rate by product.
-- ============================================================

product_metrics AS (

    SELECT

        product_id,

        SAFE_DIVIDE(

            SUM(refund_amount),

            SUM(revenue)

        ) AS product_refund_rate

    FROM base_data

    GROUP BY
        product_id

)

-- ============================================================
-- Refund Analysis Mart
-- ============================================================

SELECT

    -- Base Dataset

    b.*,

    -- Benchmarks

    pm.product_refund_rate,

    sm.store_refund_rate,

    -- Business Opportunity

    CASE

        WHEN pm.product_refund_rate > sm.store_refund_rate

        THEN

            b.revenue

            * (

                pm.product_refund_rate

                - sm.store_refund_rate

            )

        ELSE 0

    END AS potential_recoverable_revenue

FROM base_data AS b

LEFT JOIN product_metrics AS pm
    ON b.product_id = pm.product_id

CROSS JOIN store_metrics AS sm;
