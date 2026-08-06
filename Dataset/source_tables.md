# Source Tables

This project uses six relational tables from the Maven Fuzzy Factory e-commerce database. Each table serves a specific purpose in the analytical workflow.

---

## 1. website_sessions

**Grain**

One row represents one website session.

**Primary Key**

`website_session_id`

**Purpose**

Stores visitor acquisition information, including marketing source, campaign, device type, and referring website.

| Column | Description |
|--------|-------------|
| website_session_id | Unique session identifier |
| created_at | Session start timestamp |
| user_id | Unique customer identifier |
| is_repeat_session | Indicates whether the visitor is returning |
| utm_source | Marketing source |
| utm_campaign | Marketing campaign |
| utm_content | Marketing content |
| device_type | Desktop or Mobile |
| http_referer | External referral website |

---

## 2. website_pageviews

**Grain**

One row represents one pageview event.

**Primary Key**

`website_pageview_id`

**Purpose**

Captures customer browsing behavior throughout the website and serves as the foundation for funnel analysis.

| Column | Description |
|--------|-------------|
| website_pageview_id | Unique pageview identifier |
| created_at | Pageview timestamp |
| website_session_id | Session identifier |
| pageview_url | Visited page URL |

---

## 3. orders

**Grain**

One row represents one completed order.

**Primary Key**

`order_id`

**Purpose**

Stores order-level information, including purchased items, revenue, and production cost.

| Column | Description |
|--------|-------------|
| order_id | Unique order identifier |
| created_at | Order timestamp |
| website_session_id | Related website session |
| user_id | Customer identifier |
| primary_product_id | Main purchased product |
| items_purchased | Number of purchased items |
| price_usd | Total order revenue |
| cogs_usd | Cost of goods sold |

---

## 4. order_items

**Grain**

One row represents one purchased product.

**Primary Key**

`order_item_id`

**Purpose**

Provides product-level sales information for profitability analysis.

| Column | Description |
|--------|-------------|
| order_item_id | Unique purchased item identifier |
| created_at | Purchase timestamp |
| order_id | Related order |
| product_id | Purchased product |
| is_primary_item | Indicates the primary purchased product |
| price_usd | Product revenue |
| cogs_usd | Product cost |

---

## 5. order_item_refunds

**Grain**

One row represents one refunded order item.

**Primary Key**

`order_item_refund_id`

**Purpose**

Tracks refunded products and refund amounts for refund analysis.

| Column | Description |
|--------|-------------|
| order_item_refund_id | Unique refund identifier |
| created_at | Refund timestamp |
| order_item_id | Refunded order item |
| order_id | Related order |
| refund_amount_usd | Refund amount |

---

## 6. products

**Grain**

One row represents one product.

**Primary Key**

`product_id`

**Purpose**

Stores product master information used throughout the analysis.

| Column | Description |
|--------|-------------|
| product_id | Product identifier |
| created_at | Product launch date |
| product_name | Product name |

---

## Analytical Workflow

The analytical workflow follows the sequence below:

```
website_sessions
        │
        ▼
website_pageviews
        │
        ▼
orders
        │
        ▼
order_items
        │
        ▼
order_item_refunds

products
        │
        ▼
Data Marts
        │
        ▼
Looker Studio Dashboard
```
