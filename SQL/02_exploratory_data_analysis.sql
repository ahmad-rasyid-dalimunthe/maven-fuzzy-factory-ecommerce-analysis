-- =============================================================
-- Project      : Maven Fuzzy Factory E-commerce Analysis
-- File         : 02_exploratory_data_analysis.sql
-- Author       : Ahmad Rasyid Dalimunthe
-- SQL Engine   : Google BigQuery
--
-- Description:
-- Exploratory Data Analysis (EDA) performed on the raw
-- e-commerce dataset to identify customer acquisition,
-- website behavior, funnel performance, product
-- performance, and business opportunities prior to
-- building analytical data marts.
-- =============================================================



-- =============================================================
-- 1. CUSTOMER ACQUISITION OVERVIEW
-- =============================================================
-- Objective:
-- Understand how customers arrive at the website by
-- examining raw marketing attribution fields before
-- standardization.
-- =============================================================



-- -------------------------------------------------------------
-- 1.1 Raw Marketing Attribution Inspection
-- -------------------------------------------------------------
-- Review all combinations of UTM parameters and HTTP
-- referrers to understand traffic attribution quality.

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



-- -------------------------------------------------------------
-- 1.2 Attribution Classification
-- -------------------------------------------------------------
-- Categorize sessions according to the availability of
-- UTM parameters and HTTP referrer.

SELECT

    CASE

        WHEN utm_source = 'NULL'
             AND http_referer = 'NULL'
            THEN 'No UTM + No Referrer'

        WHEN utm_source = 'NULL'
             AND http_referer != 'NULL'
            THEN 'No UTM + Has Referrer'

        WHEN utm_source != 'NULL'
             AND http_referer = 'NULL'
            THEN 'Has UTM + No Referrer'

        ELSE 'Has UTM + Has Referrer'

    END AS attribution_status,

    COUNT(*) AS sessions

FROM `maven_fuzzy_Factory.website_sessions`

GROUP BY attribution_status

ORDER BY sessions DESC;



-- -------------------------------------------------------------
-- 1.3 Device Distribution by Attribution Type
-- -------------------------------------------------------------
-- Determine whether unattributed traffic differs by device.

SELECT

    CASE

        WHEN utm_source != 'NULL'
            THEN 'UTM'

        WHEN utm_source = 'NULL'
             AND http_referer != 'NULL'
            THEN 'Referrer Only'

        ELSE 'Unattributed'

    END AS attribution_type,

    device_type,

    COUNT(*) AS sessions

FROM `maven_fuzzy_Factory.website_sessions`

GROUP BY

    attribution_type,
    device_type

ORDER BY

    attribution_type,
    sessions DESC;



-- -------------------------------------------------------------
-- 1.4 Conversion Rate by Attribution Type
-- -------------------------------------------------------------
-- Compare conversion performance before traffic source
-- standardization.

WITH session_type AS (

    SELECT

        website_session_id,

        CASE

            WHEN utm_source != 'NULL'
                THEN 'UTM'

            WHEN utm_source = 'NULL'
                 AND http_referer != 'NULL'
                THEN 'Referrer Only'

            ELSE 'Unattributed'

        END AS attribution_type

    FROM `maven_fuzzy_Factory.website_sessions`

),

converted_sessions AS (

    SELECT DISTINCT

        website_session_id

    FROM `maven_fuzzy_Factory.orders`

)

SELECT

    st.attribution_type,

    COUNT(*) AS sessions,

    COUNT(cs.website_session_id) AS converted_sessions,

    SAFE_DIVIDE(

        COUNT(cs.website_session_id),
        COUNT(*)

    ) AS conversion_rate

FROM session_type st

LEFT JOIN converted_sessions cs

    ON st.website_session_id = cs.website_session_id

GROUP BY

    st.attribution_type

ORDER BY conversion_rate DESC;



-- -------------------------------------------------------------
-- 1.5 Standardized Acquisition Source
-- -------------------------------------------------------------
-- Standardize traffic sources using UTM parameters and
-- HTTP referrer.

WITH session_source AS (

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

FROM `maven_fuzzy_Factory.website_sessions`

),

converted_sessions AS (

SELECT DISTINCT

    website_session_id

FROM `maven_fuzzy_Factory.orders`

)

SELECT

    ss.acquisition_source,

    ss.device_type,

    COUNT(*) AS sessions,

    COUNT(cs.website_session_id) AS orders,

    SAFE_DIVIDE(

        COUNT(cs.website_session_id),
        COUNT(*)

    ) AS conversion_rate

FROM session_source ss

LEFT JOIN converted_sessions cs

ON ss.website_session_id = cs.website_session_id

GROUP BY

    ss.acquisition_source,
    ss.device_type

ORDER BY

    sessions DESC;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • Marketing attribution contains both UTM-tagged and
--   unattributed traffic.
--
-- • Sessions without UTM parameters can still be partially
--   recovered using HTTP referrer information.
--
-- • Standardizing acquisition sources reduces fragmented
--   traffic categories and provides a cleaner dimension
--   for downstream marketing analysis.
--
-- • The standardized acquisition source created here is
--   later used throughout the analytical data marts and
--   Tableau dashboards.
--
-- =============================================================

-- =============================================================
-- 2. WEBSITE NAVIGATION ANALYSIS
-- =============================================================
-- Objective:
-- Analyze user navigation behavior across website pages
-- to identify the most visited pages and understand how
-- customers progress toward product pages.
-- =============================================================



-- -------------------------------------------------------------
-- 2.1 Website Page Popularity
-- -------------------------------------------------------------
-- Count total pageviews and unique sessions for every page.

SELECT

    pageview_url,

    COUNT(*) AS total_pageviews,

    COUNT(DISTINCT website_session_id)
        AS unique_sessions

FROM `maven_fuzzy_Factory.website_pageviews`

GROUP BY pageview_url

ORDER BY unique_sessions DESC;



-- -------------------------------------------------------------
-- 2.2 Product Detail Page Performance
-- -------------------------------------------------------------
-- Compare traffic across individual product pages.

SELECT

    pageview_url,

    COUNT(*) AS product_pageviews,

    COUNT(DISTINCT website_session_id)
        AS unique_product_sessions

FROM `maven_fuzzy_Factory.website_pageviews`

WHERE pageview_url IN (

    '/the-original-mr-fuzzy',
    '/the-forever-love-bear',
    '/the-birthday-sugar-panda',
    '/the-hudson-river-mini-bear'

)

GROUP BY pageview_url

ORDER BY product_pageviews DESC;



-- -------------------------------------------------------------
-- 2.3 Checkout Page Usage
-- -------------------------------------------------------------
-- Measure traffic through each checkout stage.

SELECT

    pageview_url,

    COUNT(*) AS pageviews,

    COUNT(DISTINCT website_session_id)
        AS unique_sessions

FROM `maven_fuzzy_Factory.website_pageviews`

WHERE pageview_url IN (

    '/cart',
    '/shipping',
    '/billing',
    '/billing-2',
    '/thank-you-for-your-order'

)

GROUP BY pageview_url

ORDER BY unique_sessions DESC;



-- -------------------------------------------------------------
-- 2.4 Product Journey Coverage
-- -------------------------------------------------------------
-- Estimate how many sessions reached each stage of the
-- product journey using page sequence timestamps.

WITH page_sequence AS (

SELECT

    website_session_id,

    MIN(
        CASE
            WHEN pageview_url='/products'
            THEN created_at
        END
    ) AS products_time,

    MIN(
        CASE
            WHEN pageview_url IN (

                '/the-original-mr-fuzzy',
                '/the-forever-love-bear',
                '/the-birthday-sugar-panda',
                '/the-hudson-river-mini-bear'

            )

            THEN created_at
        END
    ) AS product_detail_time,

    MIN(
        CASE
            WHEN pageview_url='/cart'
            THEN created_at
        END
    ) AS cart_time,

    MIN(
        CASE
            WHEN pageview_url='/shipping'
            THEN created_at
        END
    ) AS shipping_time,

    MIN(
        CASE
            WHEN pageview_url IN ('/billing','/billing-2')
            THEN created_at
        END
    ) AS billing_time,

    MIN(
        CASE
            WHEN pageview_url='/thank-you-for-your-order'
            THEN created_at
        END
    ) AS purchase_time

FROM `maven_fuzzy_Factory.website_pageviews`

GROUP BY website_session_id

)

SELECT

    COUNT(*) AS total_sessions,

    COUNTIF(products_time IS NOT NULL)
        AS viewed_product_listing,

    COUNTIF(
        products_time IS NOT NULL
        AND product_detail_time > products_time
    ) AS viewed_product_detail,

    COUNTIF(
        products_time IS NOT NULL
        AND product_detail_time > products_time
        AND cart_time > product_detail_time
    ) AS reached_cart,

    COUNTIF(
        products_time IS NOT NULL
        AND product_detail_time > products_time
        AND cart_time > product_detail_time
        AND shipping_time > cart_time
    ) AS reached_shipping,

    COUNTIF(
        products_time IS NOT NULL
        AND product_detail_time > products_time
        AND cart_time > product_detail_time
        AND shipping_time > cart_time
        AND billing_time > shipping_time
    ) AS reached_billing,

    COUNTIF(
        products_time IS NOT NULL
        AND product_detail_time > products_time
        AND cart_time > product_detail_time
        AND shipping_time > cart_time
        AND billing_time > shipping_time
        AND purchase_time > billing_time
    ) AS completed_purchase

FROM page_sequence;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • Website traffic is concentrated on a small number of
--   landing and product-related pages.
--
-- • Product detail pages receive substantially fewer
--   visits than the product listing page, indicating the
--   first major navigation drop.
--
-- • Checkout traffic decreases progressively from Cart
--   to Purchase, suggesting friction throughout the
--   purchasing process.
--
-- • These observations provide the foundation for the
--   detailed funnel analysis presented in the next
--   section.
--
-- =============================================================


-- =============================================================
-- 3. CUSTOMER JOURNEY ANALYSIS
-- =============================================================
-- Objective:
-- Analyze customer progression through the website
-- purchase funnel and identify where users drop off
-- before completing a purchase.
-- =============================================================



-- -------------------------------------------------------------
-- 3.1 Overall Session Funnel
-- -------------------------------------------------------------
-- Measure how many sessions reach each stage of the
-- purchase journey.

WITH session_funnel AS (

SELECT

    website_session_id,

    MAX(CASE WHEN pageview_url='/products' THEN 1 ELSE 0 END)
        AS viewed_products,

    MAX(CASE
        WHEN pageview_url IN (

            '/the-original-mr-fuzzy',
            '/the-forever-love-bear',
            '/the-birthday-sugar-panda',
            '/the-hudson-river-mini-bear'

        )
        THEN 1 ELSE 0 END)
        AS viewed_product_detail,

    MAX(CASE WHEN pageview_url='/cart' THEN 1 ELSE 0 END)
        AS reached_cart,

    MAX(CASE WHEN pageview_url='/shipping' THEN 1 ELSE 0 END)
        AS reached_shipping,

    MAX(CASE
        WHEN pageview_url IN ('/billing','/billing-2')
        THEN 1 ELSE 0 END)
        AS reached_billing,

    MAX(CASE
        WHEN pageview_url='/thank-you-for-your-order'
        THEN 1 ELSE 0 END)
        AS completed_purchase

FROM `maven_fuzzy_Factory.website_pageviews`

GROUP BY website_session_id

)

SELECT

    COUNT(*) AS total_sessions,

    SUM(viewed_products) AS product_listing_sessions,

    SUM(viewed_product_detail) AS product_detail_sessions,

    SUM(reached_cart) AS cart_sessions,

    SUM(reached_shipping) AS shipping_sessions,

    SUM(reached_billing) AS billing_sessions,

    SUM(completed_purchase) AS purchase_sessions

FROM session_funnel;



-- -------------------------------------------------------------
-- 3.2 Sequential Funnel Validation
-- -------------------------------------------------------------
-- Validate that customers progress through the funnel
-- in the correct chronological order.

WITH page_sequence AS (

SELECT

    website_session_id,

    MIN(CASE WHEN pageview_url='/products' THEN created_at END)
        AS product_listing_time,

    MIN(CASE
        WHEN pageview_url IN (

            '/the-original-mr-fuzzy',
            '/the-forever-love-bear',
            '/the-birthday-sugar-panda',
            '/the-hudson-river-mini-bear'

        )
        THEN created_at
    END) AS product_detail_time,

    MIN(CASE WHEN pageview_url='/cart'
        THEN created_at END)
        AS cart_time,

    MIN(CASE WHEN pageview_url='/shipping'
        THEN created_at END)
        AS shipping_time,

    MIN(CASE
        WHEN pageview_url IN ('/billing','/billing-2')
        THEN created_at
    END) AS billing_time,

    MIN(CASE
        WHEN pageview_url='/thank-you-for-your-order'
        THEN created_at
    END) AS purchase_time

FROM `maven_fuzzy_Factory.website_pageviews`

GROUP BY website_session_id

)

SELECT

    COUNT(*) AS total_sessions,

    COUNTIF(product_listing_time IS NOT NULL)
        AS viewed_listing,

    COUNTIF(
        product_detail_time > product_listing_time
    ) AS viewed_product,

    COUNTIF(
        cart_time > product_detail_time
    ) AS reached_cart,

    COUNTIF(
        shipping_time > cart_time
    ) AS reached_shipping,

    COUNTIF(
        billing_time > shipping_time
    ) AS reached_billing,

    COUNTIF(
        purchase_time > billing_time
    ) AS completed_purchase

FROM page_sequence;



-- -------------------------------------------------------------
-- 3.3 Funnel Performance by Acquisition Source
-- -------------------------------------------------------------
-- Compare purchase funnel progression across traffic
-- acquisition channels.

WITH pageviews AS (

SELECT

    wp.website_session_id,

    wp.created_at,

    wp.pageview_url,

    CASE

        WHEN ws.utm_source!='NULL'
            THEN ws.utm_source

        WHEN REGEXP_CONTAINS(
                ws.http_referer,
                r'gsearch\.com')
            THEN 'gsearch'

        WHEN REGEXP_CONTAINS(
                ws.http_referer,
                r'bsearch\.com')
            THEN 'bsearch'

        WHEN REGEXP_CONTAINS(
                ws.http_referer,
                r'socialbook\.com')
            THEN 'socialbook'

        ELSE 'unattributed'

    END AS acquisition_source

FROM `maven_fuzzy_Factory.website_pageviews` wp

JOIN `maven_fuzzy_Factory.website_sessions` ws

ON wp.website_session_id=ws.website_session_id

),

session_funnel AS (

SELECT

    website_session_id,

    acquisition_source,

    MIN(CASE
        WHEN pageview_url IN (

            '/the-original-mr-fuzzy',
            '/the-forever-love-bear',
            '/the-birthday-sugar-panda',
            '/the-hudson-river-mini-bear'

        )

        THEN created_at

    END) product_detail_time,

    MIN(CASE
        WHEN pageview_url='/cart'
        THEN created_at
    END) cart_time,

    MIN(CASE
        WHEN pageview_url='/shipping'
        THEN created_at
    END) shipping_time,

    MIN(CASE
        WHEN pageview_url IN ('/billing','/billing-2')
        THEN created_at
    END) billing_time,

    MIN(CASE
        WHEN pageview_url='/thank-you-for-your-order'
        THEN created_at
    END) purchase_time

FROM pageviews

GROUP BY

website_session_id,

acquisition_source

)

SELECT

    acquisition_source,

    COUNTIF(product_detail_time IS NOT NULL)
        AS product_detail_sessions,

    COUNTIF(cart_time>product_detail_time)
        AS cart_sessions,

    COUNTIF(shipping_time>cart_time)
        AS shipping_sessions,

    COUNTIF(billing_time>shipping_time)
        AS billing_sessions,

    COUNTIF(purchase_time>billing_time)
        AS purchase_sessions

FROM session_funnel

GROUP BY acquisition_source

ORDER BY product_detail_sessions DESC;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • Customer progression follows a clear multi-stage
--   purchase journey from Product Detail to Purchase.
--
-- • Every stage introduces additional customer drop-off,
--   highlighting opportunities for conversion
--   optimization.
--
-- • Funnel performance differs across acquisition
--   channels, indicating that traffic quality is not
--   uniform.
--
-- • These findings motivated the creation of
--   mart_funnel and mart_dashboard_page2 for dashboard
--   reporting.
--
-- =============================================================


-- =============================================================
-- 4. DEVICE PERFORMANCE ANALYSIS
-- =============================================================
-- Objective:
-- Evaluate funnel performance across desktop and mobile
-- devices to identify usability gaps and estimate the
-- potential business impact of improving mobile
-- conversion performance.
-- =============================================================



-- -------------------------------------------------------------
-- 4.1 Purchase Funnel by Device Type
-- -------------------------------------------------------------
-- Compare customer progression through the purchase
-- funnel for desktop and mobile users.

WITH pageviews AS (

SELECT

    wp.website_session_id,
    wp.created_at,
    wp.pageview_url,
    ws.device_type

FROM `maven_fuzzy_Factory.website_pageviews` wp

JOIN `maven_fuzzy_Factory.website_sessions` ws

ON wp.website_session_id = ws.website_session_id

),

session_funnel AS (

SELECT

    website_session_id,

    device_type,

    MIN(CASE
        WHEN pageview_url IN (

            '/the-original-mr-fuzzy',
            '/the-forever-love-bear',
            '/the-birthday-sugar-panda',
            '/the-hudson-river-mini-bear'

        )
        THEN created_at
    END) AS product_detail_time,

    MIN(CASE
        WHEN pageview_url='/cart'
        THEN created_at
    END) AS cart_time,

    MIN(CASE
        WHEN pageview_url='/shipping'
        THEN created_at
    END) AS shipping_time,

    MIN(CASE
        WHEN pageview_url IN ('/billing','/billing-2')
        THEN created_at
    END) AS billing_time,

    MIN(CASE
        WHEN pageview_url='/thank-you-for-your-order'
        THEN created_at
    END) AS purchase_time

FROM pageviews

GROUP BY

    website_session_id,
    device_type

)

SELECT

    device_type,

    COUNTIF(product_detail_time IS NOT NULL)
        AS product_detail_sessions,

    COUNTIF(cart_time > product_detail_time)
        AS cart_sessions,

    COUNTIF(shipping_time > cart_time)
        AS shipping_sessions,

    COUNTIF(billing_time > shipping_time)
        AS billing_sessions,

    COUNTIF(purchase_time > billing_time)
        AS purchase_sessions,

    SAFE_DIVIDE(

        COUNTIF(cart_time > product_detail_time),
        COUNTIF(product_detail_time IS NOT NULL)

    ) AS product_to_cart_rate,

    SAFE_DIVIDE(

        COUNTIF(shipping_time > cart_time),
        COUNTIF(cart_time > product_detail_time)

    ) AS cart_to_shipping_rate,

    SAFE_DIVIDE(

        COUNTIF(billing_time > shipping_time),
        COUNTIF(shipping_time > cart_time)

    ) AS shipping_to_billing_rate,

    SAFE_DIVIDE(

        COUNTIF(purchase_time > billing_time),
        COUNTIF(billing_time > shipping_time)

    ) AS billing_to_purchase_rate

FROM session_funnel

GROUP BY device_type

ORDER BY device_type;



-- -------------------------------------------------------------
-- 4.2 Mobile Conversion Opportunity
-- -------------------------------------------------------------
-- Estimate additional purchases if mobile users achieve
-- the same Billing-to-Purchase conversion rate as
-- desktop users.

WITH funnel AS (

SELECT

    device_type,

    COUNTIF(product_detail_time IS NOT NULL)
        AS product_detail_sessions,

    COUNTIF(cart_time > product_detail_time)
        AS cart_sessions,

    COUNTIF(shipping_time > cart_time)
        AS shipping_sessions,

    COUNTIF(billing_time > shipping_time)
        AS billing_sessions,

    COUNTIF(purchase_time > billing_time)
        AS purchase_sessions

FROM (

    SELECT

        wp.website_session_id,
        ws.device_type,

        MIN(CASE
            WHEN pageview_url IN (

                '/the-original-mr-fuzzy',
                '/the-forever-love-bear',
                '/the-birthday-sugar-panda',
                '/the-hudson-river-mini-bear'

            )
            THEN wp.created_at
        END) AS product_detail_time,

        MIN(CASE
            WHEN pageview_url='/cart'
            THEN wp.created_at
        END) AS cart_time,

        MIN(CASE
            WHEN pageview_url='/shipping'
            THEN wp.created_at
        END) AS shipping_time,

        MIN(CASE
            WHEN pageview_url IN ('/billing','/billing-2')
            THEN wp.created_at
        END) AS billing_time,

        MIN(CASE
            WHEN pageview_url='/thank-you-for-your-order'
            THEN wp.created_at
        END) AS purchase_time

    FROM `maven_fuzzy_Factory.website_pageviews` wp

    JOIN `maven_fuzzy_Factory.website_sessions` ws

        ON wp.website_session_id = ws.website_session_id

    GROUP BY

        wp.website_session_id,
        ws.device_type

)

GROUP BY device_type

),

conversion_rate AS (

SELECT

    *,

    SAFE_DIVIDE(

        purchase_sessions,
        billing_sessions

    ) AS billing_to_purchase_rate

FROM funnel

),

desktop_rate AS (

SELECT

    billing_to_purchase_rate

FROM conversion_rate

WHERE device_type='desktop'

)

SELECT

    c.device_type,

    c.billing_sessions,

    c.purchase_sessions,

    ROUND(
        c.billing_to_purchase_rate,
        4
    ) AS billing_to_purchase_rate,

    CASE

        WHEN c.device_type='mobile'

        THEN ROUND(

            c.billing_sessions
            *
            d.billing_to_purchase_rate

        )

    END AS expected_mobile_purchases,

    CASE

        WHEN c.device_type='mobile'

        THEN ROUND(

            c.billing_sessions
            *
            d.billing_to_purchase_rate

        ) - c.purchase_sessions

    END AS potential_additional_purchases

FROM conversion_rate c

CROSS JOIN desktop_rate d

ORDER BY device_type;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • Desktop users outperform mobile users throughout
--   the checkout process.
--
-- • The largest performance gap occurs during the
--   Billing → Purchase stage.
--
-- • Matching desktop conversion performance on mobile
--   would generate additional completed purchases
--   without increasing acquisition costs.
--
-- • These findings support prioritizing mobile checkout
--   optimization before investing in additional traffic.
--
-- =============================================================


-- =============================================================
-- 5. MARKETING CHANNEL PERFORMANCE
-- =============================================================
-- Objective:
-- Evaluate the revenue contribution and profitability of
-- each acquisition channel to identify the most valuable
-- traffic sources.
-- =============================================================



-- -------------------------------------------------------------
-- 5.1 Revenue Performance by Acquisition Source
-- -------------------------------------------------------------
-- Compare revenue, profit, gross margin, and average
-- order value across acquisition channels.

WITH session_attribution AS (

SELECT

    website_session_id,

    CASE

        WHEN utm_source='gsearch'
            THEN 'gsearch'

        WHEN utm_source='bsearch'
            THEN 'bsearch'

        WHEN utm_source='socialbook'
            THEN 'socialbook'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'gsearch\.com')
            THEN 'gsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'bsearch\.com')
            THEN 'bsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'socialbook\.com')
            THEN 'socialbook'

        ELSE 'unattributed'

    END AS acquisition_source

FROM `maven_fuzzy_Factory.website_sessions`

),

order_profit AS (

SELECT

    o.order_id,

    o.website_session_id,

    SUM(oi.price_usd) AS revenue,

    SUM(oi.cogs_usd) AS cogs,

    SUM(oi.price_usd)-SUM(oi.cogs_usd)
        AS gross_profit

FROM `maven_fuzzy_Factory.orders` o

JOIN `maven_fuzzy_Factory.order_items` oi

ON o.order_id=oi.order_id

GROUP BY

    o.order_id,
    o.website_session_id

)

SELECT

    sa.acquisition_source,

    COUNT(DISTINCT op.order_id)
        AS orders,

    SUM(op.revenue)
        AS revenue,

    SUM(op.cogs)
        AS cogs,

    SUM(op.gross_profit)
        AS gross_profit,

    SAFE_DIVIDE(

        SUM(op.gross_profit),
        SUM(op.revenue)

    ) AS gross_margin,

    SAFE_DIVIDE(

        SUM(op.revenue),
        COUNT(DISTINCT op.order_id)

    ) AS average_order_value

FROM session_attribution sa

JOIN order_profit op

ON sa.website_session_id=op.website_session_id

GROUP BY acquisition_source

ORDER BY revenue DESC;



-- -------------------------------------------------------------
-- 5.2 Revenue Performance by Acquisition Source and Device
-- -------------------------------------------------------------
-- Evaluate channel performance segmented by device type.

WITH session_attribution AS (

SELECT

    website_session_id,

    device_type,

    CASE

        WHEN utm_source='gsearch'
            THEN 'gsearch'

        WHEN utm_source='bsearch'
            THEN 'bsearch'

        WHEN utm_source='socialbook'
            THEN 'socialbook'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'gsearch\.com')
            THEN 'gsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'bsearch\.com')
            THEN 'bsearch'

        WHEN utm_source='NULL'
             AND REGEXP_CONTAINS(
                    http_referer,
                    r'socialbook\.com')
            THEN 'socialbook'

        ELSE 'unattributed'

    END AS acquisition_source

FROM `maven_fuzzy_Factory.website_sessions`

),

order_profit AS (

SELECT

    o.order_id,

    o.website_session_id,

    SUM(oi.price_usd) AS revenue,

    SUM(oi.cogs_usd) AS cogs,

    SUM(oi.price_usd)-SUM(oi.cogs_usd)
        AS gross_profit

FROM `maven_fuzzy_Factory.orders` o

JOIN `maven_fuzzy_Factory.order_items` oi

ON o.order_id=oi.order_id

GROUP BY

    o.order_id,
    o.website_session_id

)

SELECT

    sa.acquisition_source,

    sa.device_type,

    COUNT(DISTINCT op.order_id)
        AS orders,

    SUM(op.revenue)
        AS revenue,

    SUM(op.gross_profit)
        AS gross_profit,

    SAFE_DIVIDE(

        SUM(op.gross_profit),
        SUM(op.revenue)

    ) AS gross_margin,

    SAFE_DIVIDE(

        SUM(op.revenue),
        COUNT(DISTINCT op.order_id)

    ) AS average_order_value

FROM session_attribution sa

JOIN order_profit op

ON sa.website_session_id=op.website_session_id

GROUP BY

    sa.acquisition_source,
    sa.device_type

ORDER BY

    revenue DESC;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • gsearch contributes the highest revenue and gross
--   profit, making it the primary acquisition channel.
--
-- • Revenue contribution differs substantially across
--   marketing channels.
--
-- • Device segmentation reveals differences in channel
--   effectiveness, supporting more targeted marketing
--   budget allocation.
--
-- • These results are later incorporated into the
--   marketing performance dashboard.
--
-- =============================================================


-- =============================================================
-- 6. PRODUCT & FINANCIAL PERFORMANCE
-- =============================================================
-- Objective:
-- Evaluate product sales performance, profitability,
-- and financial contribution to identify the strongest
-- revenue-generating products.
-- =============================================================



-- -------------------------------------------------------------
-- 6.1 Overall Business Performance
-- -------------------------------------------------------------
-- Summarize overall business performance across all
-- completed orders.

SELECT

    COUNT(DISTINCT order_id) AS total_orders,

    SUM(price_usd) AS total_revenue,

    SUM(cogs_usd) AS total_cogs,

    SUM(price_usd) - SUM(cogs_usd)
        AS gross_profit,

    SAFE_DIVIDE(

        SUM(price_usd)-SUM(cogs_usd),
        SUM(price_usd)

    ) AS gross_margin,

    SAFE_DIVIDE(

        SUM(price_usd),
        COUNT(DISTINCT order_id)

    ) AS average_order_value

FROM `maven_fuzzy_Factory.order_items`;



-- -------------------------------------------------------------
-- 6.2 Product Sales Performance
-- -------------------------------------------------------------
-- Compare sales performance across individual products.

SELECT

    p.product_id,

    p.product_name,

    COUNT(DISTINCT oi.order_id)
        AS total_orders,

    SUM(oi.price_usd)
        AS revenue,

    SUM(oi.cogs_usd)
        AS cogs,

    SUM(oi.price_usd)-SUM(oi.cogs_usd)
        AS gross_profit,

    SAFE_DIVIDE(

        SUM(oi.price_usd)-SUM(oi.cogs_usd),
        SUM(oi.price_usd)

    ) AS gross_margin,

    SAFE_DIVIDE(

        SUM(oi.price_usd),
        COUNT(DISTINCT oi.order_id)

    ) AS average_order_value

FROM `maven_fuzzy_Factory.order_items` oi

JOIN `maven_fuzzy_Factory.products` p

ON oi.product_id=p.product_id

GROUP BY

    p.product_id,
    p.product_name

ORDER BY revenue DESC;



-- -------------------------------------------------------------
-- 6.3 Product Profitability Ranking
-- -------------------------------------------------------------
-- Rank products by gross profit contribution.

SELECT

    p.product_name,

    SUM(oi.price_usd)
        AS revenue,

    SUM(oi.cogs_usd)
        AS cogs,

    SUM(oi.price_usd)-SUM(oi.cogs_usd)
        AS gross_profit,

    SAFE_DIVIDE(

        SUM(oi.price_usd)-SUM(oi.cogs_usd),
        SUM(oi.price_usd)

    ) AS gross_margin

FROM `maven_fuzzy_Factory.order_items` oi

JOIN `maven_fuzzy_Factory.products` p

ON oi.product_id=p.product_id

GROUP BY

    p.product_name

ORDER BY gross_profit DESC;



-- =============================================================
-- SECTION SUMMARY
-- =============================================================
--
-- Key Findings
--
-- • Revenue is concentrated in a small number of
--   products.
--
-- • Product profitability varies despite similar
--   gross margins.
--
-- • Gross profit contribution provides a more reliable
--   indicator than revenue alone when prioritizing
--   products.
--
-- • These findings identify the products that generate
--   the greatest financial value for the business.
--
-- =============================================================


-- =============================================================
-- 7. BUSINESS OPPORTUNITY ANALYSIS
-- =============================================================
-- Objective:
-- Identify financial opportunities by analyzing product
-- refunds and estimating recoverable revenue if refund
-- performance reaches the overall store benchmark.
-- =============================================================



-- -------------------------------------------------------------
-- 7.1 Product Refund Performance
-- -------------------------------------------------------------
-- Evaluate refund amount and refund rate by product.

WITH product_sales AS (

SELECT

    oi.product_id,

    p.product_name,

    SUM(oi.price_usd)
        AS revenue

FROM `maven_fuzzy_Factory.order_items` oi

JOIN `maven_fuzzy_Factory.products` p

ON oi.product_id=p.product_id

GROUP BY

    oi.product_id,
    p.product_name

),

product_refunds AS (

SELECT

    oi.product_id,

    SUM(r.refund_amount_usd)
        AS refund_amount

FROM `maven_fuzzy_Factory.order_item_refunds` r

JOIN `maven_fuzzy_Factory.order_items` oi

ON r.order_item_id=oi.order_item_id

GROUP BY

    oi.product_id

)

SELECT

    ps.product_name,

    ps.revenue,

    COALESCE(pr.refund_amount,0)
        AS refund_amount,

    SAFE_DIVIDE(

        COALESCE(pr.refund_amount,0),
        ps.revenue

    ) AS refund_rate

FROM product_sales ps

LEFT JOIN product_refunds pr

ON ps.product_id=pr.product_id

ORDER BY refund_rate DESC;



-- -------------------------------------------------------------
-- 7.2 Recoverable Revenue Opportunity
-- -------------------------------------------------------------
-- Estimate revenue that could be recovered if each
-- product achieved the overall store refund rate.

WITH product_refunds AS (

SELECT

    oi.product_id,

    SUM(r.refund_amount_usd)
        AS refund_amount

FROM `maven_fuzzy_Factory.order_item_refunds` r

JOIN `maven_fuzzy_Factory.order_items` oi

ON r.order_item_id=oi.order_item_id

GROUP BY oi.product_id

),

product_sales AS (

SELECT

    oi.product_id,

    p.product_name,

    SUM(oi.price_usd)
        AS revenue

FROM `maven_fuzzy_Factory.order_items` oi

JOIN `maven_fuzzy_Factory.products` p

ON oi.product_id=p.product_id

GROUP BY

    oi.product_id,
    p.product_name

),

metrics AS (

SELECT

    ps.product_id,

    ps.product_name,

    ps.revenue,

    COALESCE(pr.refund_amount,0)
        AS refund_amount,

    SAFE_DIVIDE(

        COALESCE(pr.refund_amount,0),
        ps.revenue

    ) AS refund_rate

FROM product_sales ps

LEFT JOIN product_refunds pr

ON ps.product_id=pr.product_id

),

benchmark AS (

SELECT

    SAFE_DIVIDE(

        SUM(refund_amount),
        SUM(revenue)

    ) AS benchmark_refund_rate

FROM metrics

)

SELECT

    m.product_name,

    m.revenue,

    m.refund_amount,

    ROUND(m.refund_rate,4)
        AS refund_rate,

    ROUND(b.benchmark_refund_rate,4)
        AS benchmark_rate,

    GREATEST(

        m.refund_amount
        -
        (m.revenue*b.benchmark_refund_rate),

        0

    ) AS recoverable_revenue

FROM metrics m

CROSS JOIN benchmark b

ORDER BY recoverable_revenue DESC;



-- =============================================================
-- EDA SUMMARY
-- =============================================================
--
-- Overall Findings
--
-- • Customer acquisition is dominated by search traffic.
--
-- • The largest funnel loss occurs immediately after the
--   product detail page.
--
-- • Mobile users underperform desktop users during
--   checkout.
--
-- • Product sales are highly concentrated.
--
-- • A small number of products account for the majority
--   of gross profit.
--
-- • Refund performance varies considerably across
--   products, creating measurable revenue recovery
--   opportunities.
--
-- • These findings directly informed the design of
--   mart_dashboard_page1,
--   mart_dashboard_page2,
--   mart_dashboard_page3,
--   and the Tableau dashboards.
--
-- =============================================================
