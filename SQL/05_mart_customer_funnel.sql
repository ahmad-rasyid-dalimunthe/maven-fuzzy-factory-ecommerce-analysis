-- ============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 05_mart_customer_funnel.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- Creates the customer funnel mart used for the
-- Acquisition & Product Funnel dashboard.
--
-- Grain:
-- One row represents one product detail view within
-- a website session.
--
-- Main dimensions:
-- - Session Date
-- - Acquisition Source
-- - Device Type
-- - Product
--
-- Main measures:
-- - Product Detail
-- - Cart
-- - Shipping
-- - Billing
-- - Purchase
-- - Product Purchased
-- ============================================================

CREATE OR REPLACE VIEW `maven_fuzzy_Factory.mart_customer_funnel` AS

-- ============================================================
-- Session Attribution
-- Standardize traffic acquisition source.
-- ============================================================

WITH session_attribution AS (

    SELECT
        ws.website_session_id,

        DATE(ws.created_at) AS session_date,

        ws.device_type,

        CASE
            WHEN ws.utm_source <> 'NULL'
                THEN ws.utm_source

            WHEN REGEXP_CONTAINS(ws.http_referer, r'gsearch\.com')
                THEN 'gsearch'

            WHEN REGEXP_CONTAINS(ws.http_referer, r'bsearch\.com')
                THEN 'bsearch'

            WHEN REGEXP_CONTAINS(ws.http_referer, r'socialbook\.com')
                THEN 'socialbook'

            ELSE 'unattributed'
        END AS acquisition_source

    FROM `maven_fuzzy_Factory.website_sessions` AS ws

),

-- ============================================================
-- Product Detail Views
-- Identify which product page was viewed.
-- ============================================================

product_views AS (

    SELECT DISTINCT

        wp.website_session_id,

        CASE wp.pageview_url
            WHEN '/the-original-mr-fuzzy'
                THEN 1
            WHEN '/the-forever-love-bear'
                THEN 2
            WHEN '/the-birthday-sugar-panda'
                THEN 3
            WHEN '/the-hudson-river-mini-bear'
                THEN 4
        END AS product_id,

        CASE wp.pageview_url
            WHEN '/the-original-mr-fuzzy'
                THEN 'The Original Mr. Fuzzy'
            WHEN '/the-forever-love-bear'
                THEN 'The Forever Love Bear'
            WHEN '/the-birthday-sugar-panda'
                THEN 'The Birthday Sugar Panda'
            WHEN '/the-hudson-river-mini-bear'
                THEN 'The Hudson River Mini Bear'
        END AS product_name

    FROM `maven_fuzzy_Factory.website_pageviews` AS wp

    WHERE wp.pageview_url IN (

        '/the-original-mr-fuzzy',
        '/the-forever-love-bear',
        '/the-birthday-sugar-panda',
        '/the-hudson-river-mini-bear'

    )

),

-- ============================================================
-- Session Funnel
-- Determine whether each session reached each stage
-- of the purchase journey.
-- ============================================================

session_funnel AS (

    SELECT

        website_session_id,

        MAX(
            CASE
                WHEN pageview_url IN (

                    '/the-original-mr-fuzzy',
                    '/the-forever-love-bear',
                    '/the-birthday-sugar-panda',
                    '/the-hudson-river-mini-bear'

                )
                THEN 1
                ELSE 0
            END
        ) AS product_detail,

        MAX(
            CASE
                WHEN pageview_url = '/cart'
                THEN 1
                ELSE 0
            END
        ) AS cart,

        MAX(
            CASE
                WHEN pageview_url = '/shipping'
                THEN 1
                ELSE 0
            END
        ) AS shipping,

        MAX(
            CASE
                WHEN pageview_url IN ('/billing', '/billing-2')
                THEN 1
                ELSE 0
            END
        ) AS billing,

        MAX(
            CASE
                WHEN pageview_url = '/thank-you-for-your-order'
                THEN 1
                ELSE 0
            END
        ) AS purchase

    FROM `maven_fuzzy_Factory.website_pageviews`

    GROUP BY
        website_session_id

),

-- ============================================================
-- Purchased Product
-- Retrieve the primary product purchased within
-- each session.
-- ============================================================

purchased_products AS (

    SELECT

        o.website_session_id,

        o.order_id,

        oi.product_id,

        p.product_name,

        1 AS product_purchased

    FROM `maven_fuzzy_Factory.orders` AS o

    INNER JOIN `maven_fuzzy_Factory.order_items` AS oi
        ON o.order_id = oi.order_id
       AND oi.is_primary_item = 1

    INNER JOIN `maven_fuzzy_Factory.products` AS p
        ON oi.product_id = p.product_id

)

-- ============================================================
-- Customer Funnel Mart
-- ============================================================

SELECT

    -- ==========================
    -- Session Dimension
    -- ==========================

    sa.session_date,

    sa.website_session_id,

    sa.acquisition_source,

    sa.device_type,

    -- ==========================
    -- Product Dimension
    -- ==========================

    pv.product_id,

    pv.product_name,

    -- ==========================
    -- Funnel Measures
    -- ==========================

    sf.product_detail,

    sf.cart,

    sf.shipping,

    sf.billing,

    sf.purchase,

    -- ==========================
    -- Purchase Measures
    -- ==========================

    IF(
        pv.product_id = pp.product_id,
        1,
        0
    ) AS product_purchased,

    pp.order_id

FROM session_attribution AS sa

LEFT JOIN session_funnel AS sf
    ON sa.website_session_id = sf.website_session_id

LEFT JOIN product_views AS pv
    ON sa.website_session_id = pv.website_session_id

LEFT JOIN purchased_products AS pp
    ON sa.website_session_id = pp.website_session_id;
