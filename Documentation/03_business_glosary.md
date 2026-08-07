# Business Glossary

## Overview

This document defines the business metrics, dimensions, and key performance indicators (KPIs) used throughout the Maven Fuzzy Factory E-commerce Analysis project.

The glossary ensures consistent interpretation of metrics across SQL analysis, data marts, dashboards, and business recommendations.

---

# Financial Metrics

## Revenue

**Definition**

Total sales generated from purchased products before refunds.

**Formula**

Revenue = SUM(price_usd)

**Used In**

- Business Performance Dashboard
- Product Performance
- Acquisition Performance

---

## Cost of Goods Sold (COGS)

**Definition**

The direct cost incurred to produce products sold.

**Formula**

COGS = SUM(cogs_usd)

---

## Gross Profit

**Definition**

Profit generated before accounting for refunds.

**Formula**

Gross Profit = Revenue − COGS

---

## Gross Margin

**Definition**

Percentage of revenue retained after deducting product costs.

**Formula**

Gross Margin = Gross Profit / Revenue

---

## Net Revenue After Refund

**Definition**

Revenue remaining after refund transactions.

**Formula**

Net Revenue = Revenue − Refund Amount

---

## Gross Profit After Refund

**Definition**

Gross profit after considering refund losses.

**Formula**

Gross Profit After Refund = Gross Profit − Refund Amount

---

## Average Order Value (AOV)

**Definition**

Average revenue generated per completed order.

**Formula**

Average Order Value = Revenue / Number of Orders

---

# Refund Metrics

## Refund Amount

**Definition**

Total monetary value refunded to customers.

**Formula**

Refund Amount = SUM(refund_amount_usd)

---

## Refund Transaction

**Definition**

Number of refund records processed.

---

## Refund Rate

**Definition**

Percentage of revenue returned to customers through refunds.

**Formula**

Refund Rate = Refund Amount / Revenue

---

## Store Refund Rate

**Definition**

Overall refund rate across the entire business.

Used as a benchmark to compare product-level refund performance.

---

## Product Refund Rate

**Definition**

Refund rate calculated for an individual product.

---

## Potential Recoverable Revenue

**Definition**

Estimated revenue that could be retained if a product's refund rate were reduced to the overall store refund rate.

**Purpose**

Identifies products with the greatest opportunity for profitability improvement.

---

# Customer Funnel Metrics

## Product Detail Session

**Definition**

A session in which a customer viewed at least one product detail page.

---

## Cart Session

**Definition**

A session that reached the shopping cart page.

---

## Shipping Session

**Definition**

A session that reached the shipping page.

---

## Billing Session

**Definition**

A session that reached the billing page.

---

## Purchase Session

**Definition**

A session that successfully completed an order.

---

## Product Purchased

**Definition**

Indicates whether the viewed product was ultimately purchased as the primary product within the same session.

Values:

- 1 = Purchased
- 0 = Not Purchased

---

# Acquisition Metrics

## Acquisition Source

**Definition**

The marketing source responsible for acquiring a website session.

Possible values include:

- gsearch
- bsearch
- socialbook
- unattributed

The source is derived from UTM parameters and HTTP referrer information.

---

## Device Type

**Definition**

Device used during the customer session.

Possible values:

- Desktop
- Mobile

---

# Business Dimensions

## Session

A single visit to the website.

Identified by:

website_session_id

---

## Order

A completed customer purchase.

Identified by:

order_id

---

## Order Item

A product included within an order.

Identified by:

order_item_id

---

## Product

A unique product sold by Maven Fuzzy Factory.

Identified by:

product_id

---

# Dashboard KPIs

The Business Performance Dashboard includes:

- Revenue
- Gross Profit
- Gross Margin
- Orders
- Average Order Value

---

The Customer Funnel Dashboard includes:

- Product Detail Sessions
- Cart Sessions
- Shipping Sessions
- Billing Sessions
- Purchase Sessions
- Product Purchased

---

The Refund Dashboard includes:

- Refund Amount
- Refund Rate
- Net Revenue
- Gross Profit After Refund
- Potential Recoverable Revenue

---

# Notes

All business metrics are calculated from the cleaned analytical data marts rather than directly from the raw transactional tables.

This approach ensures consistency across SQL analysis, dashboards, and business recommendations.
