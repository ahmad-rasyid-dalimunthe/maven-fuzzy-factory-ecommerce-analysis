# Data Dictionary

## Overview

This document describes the raw tables used throughout the Maven Fuzzy Factory E-commerce Analysis project.

The dataset consists of six relational tables representing customer sessions, website behavior, orders, products, and refunds.

---

# Entity Relationship Overview

| Table | Description | Primary Key |
|--------|-------------|-------------|
| website_sessions | Stores customer visit information and acquisition attributes. | website_session_id |
| website_pageviews | Stores every page viewed during a customer session. | website_pageview_id |
| orders | Stores completed customer orders. | order_id |
| order_items | Stores product-level details for each order. | order_item_id |
| order_item_refunds | Stores refund transactions for order items. | order_item_refund_id |
| products | Product master table. | product_id |

---

# 1. website_sessions

## Description

Contains one record for every website visit.

This table is the starting point for customer acquisition and traffic analysis.

### Primary Key

| Column | Type |
|---------|------|
| website_session_id | INTEGER |

### Important Columns

| Column | Description |
|---------|-------------|
| website_session_id | Unique identifier for each website session |
| created_at | Session timestamp |
| user_id | Customer identifier |
| utm_source | Marketing traffic source |
| utm_campaign | Marketing campaign |
| utm_content | Marketing advertisement content |
| device_type | Desktop or Mobile |
| http_referer | Referring website |

### Used For

- Traffic analysis
- Acquisition analysis
- Device analysis
- Customer funnel
- Marketing attribution

---

# 2. website_pageviews

## Description

Stores every page viewed during each customer session.

Each session can have multiple pageviews.

### Primary Key

| Column | Type |
|---------|------|
| website_pageview_id | INTEGER |

### Foreign Key

| Column | References |
|---------|------------|
| website_session_id | website_sessions |

### Important Columns

| Column | Description |
|---------|-------------|
| website_pageview_id | Unique pageview identifier |
| website_session_id | Website session identifier |
| created_at | Pageview timestamp |
| pageview_url | URL visited by customer |

### Used For

- Customer journey
- Funnel analysis
- Product page analysis
- Navigation behavior

---

# 3. orders

## Description

Contains completed customer orders.

Each order belongs to one website session.

### Primary Key

| Column | Type |
|---------|------|
| order_id | INTEGER |

### Foreign Key

| Column | References |
|---------|------------|
| website_session_id | website_sessions |

### Important Columns

| Column | Description |
|---------|-------------|
| order_id | Unique order identifier |
| created_at | Order timestamp |
| website_session_id | Purchasing session |
| user_id | Customer identifier |
| primary_product_id | Main purchased product |
| items_purchased | Number of items |
| price_usd | Order revenue |
| cogs_usd | Order cost |

### Used For

- Revenue analysis
- Order analysis
- Customer conversion

---

# 4. order_items

## Description

Stores product-level information for each order.

One order may contain multiple order items.

### Primary Key

| Column | Type |
|---------|------|
| order_item_id | INTEGER |

### Foreign Keys

| Column | References |
|---------|------------|
| order_id | orders |
| product_id | products |

### Important Columns

| Column | Description |
|---------|-------------|
| order_item_id | Unique order item identifier |
| order_id | Parent order |
| product_id | Purchased product |
| created_at | Purchase timestamp |
| is_primary_item | Indicates primary purchased product |
| price_usd | Product selling price |
| cogs_usd | Product cost |

### Used For

- Product profitability
- Revenue analysis
- Gross margin
- Refund analysis

---

# 5. order_item_refunds

## Description

Contains refund transactions associated with purchased products.

Not every order item has a refund.

### Primary Key

| Column | Type |
|---------|------|
| order_item_refund_id | INTEGER |

### Foreign Key

| Column | References |
|---------|------------|
| order_item_id | order_items |

### Important Columns

| Column | Description |
|---------|-------------|
| order_item_refund_id | Refund identifier |
| order_item_id | Refunded product |
| order_id | Parent order |
| refund_amount_usd | Refund amount |
| created_at | Refund date |

### Used For

- Refund analysis
- Product quality evaluation
- Net revenue calculation

---

# 6. products

## Description

Master table containing product information.

### Primary Key

| Column | Type |
|---------|------|
| product_id | INTEGER |

### Important Columns

| Column | Description |
|---------|-------------|
| product_id | Product identifier |
| created_at | Product launch date |
| product_name | Product name |

### Used For

- Product reporting
- Product profitability
- Product refund analysis

---

# Data Relationships

| Parent Table | Child Table | Relationship |
|--------------|-------------|--------------|
| website_sessions | website_pageviews | One-to-Many |
| website_sessions | orders | One-to-Many |
| orders | order_items | One-to-Many |
| order_items | order_item_refunds | One-to-Many |
| products | order_items | One-to-Many |

---

# Analytical Data Marts

The raw tables are transformed into three business-oriented analytical views for reporting purposes.

| Data Mart | Purpose |
|-----------|---------|
| mart_business_performance | Financial and profitability reporting |
| mart_customer_funnel | Customer journey and conversion analysis |
| mart_refund_analysis | Refund performance and recoverable revenue analysis |
