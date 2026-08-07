# Assumptions & Limitations

## Overview

This document describes the analytical assumptions and dataset limitations identified during the Maven Fuzzy Factory E-commerce Analysis project.

Clearly documenting assumptions improves transparency, reproducibility, and appropriate interpretation of business insights.

---

# Analytical Assumptions

## 1. One Website Session Represents One Customer Visit

Each `website_session_id` is treated as a single customer visit.

Multiple sessions from the same user are analyzed independently because customer identity is not consistently available across all analyses.

---

## 2. Order Completion Represents Successful Conversion

An order is considered completed when a record exists in the `orders` table.

The presence of an order indicates a successful purchase regardless of later refund activity.

---

## 3. Gross Profit Calculation

Gross profit is calculated using product revenue and product cost only.

Formula:

Gross Profit = Revenue − COGS

Operating expenses such as marketing, logistics, payroll, or overhead are outside the scope of this dataset.

---

## 4. Refund Impact

Refunds reduce revenue and gross profit.

Refund amounts are assumed to represent the total financial impact of each refunded order item.

---

## 5. Traffic Attribution

Traffic source is determined using the following priority:

1. UTM Source
2. HTTP Referrer
3. Unattributed

Sessions without both UTM parameters and referrer information are classified as **unattributed**.

---

## 6. Customer Funnel

Customer funnel progression is reconstructed from website pageviews.

A customer is considered to have reached a funnel stage when the corresponding page is visited.

---

# Dataset Limitations

## 1. Product-Level Funnel Limitation

The dataset records pageviews at the session level but does not retain product identity after customers leave the product detail page.

Consequently:

- Product detail pages identify the viewed product.
- Cart, shipping, billing, and purchase pages do not indicate which specific product continued through the funnel.

Because of this limitation, the project cannot determine with certainty whether the same viewed product reached checkout.

Instead, the analysis measures:

- Sessions that viewed each product.
- Sessions that progressed through subsequent funnel stages.
- Whether the primary purchased product matches the viewed product.

This limitation should be considered when interpreting product funnel conversion rates.

---

## 2. Refund Timing

Refund records are available but do not include business reasons for refunds.

The analysis measures refund amount rather than refund causes.

---

## 3. Customer Behavior

Customer demographics are unavailable.

The dataset contains no information regarding:

- Gender
- Age
- Geographic location
- Customer segment

Behavioral analysis is therefore limited to sessions, devices, and acquisition channels.

---

## 4. Marketing Cost

Marketing spend is unavailable.

As a result, the project evaluates:

- Revenue
- Gross Profit
- Gross Margin

but cannot calculate:

- ROAS
- ROI
- Customer Acquisition Cost (CAC)

---

## 5. Inventory Information

Inventory availability is not included.

The analysis cannot determine whether low sales are caused by:

- customer demand
- stock shortages
- inventory planning

---

## 6. Customer Lifetime Value

Customer lifetime metrics cannot be calculated because long-term customer history is unavailable.

Metrics such as:

- Lifetime Value (LTV)
- Repeat Purchase Rate
- Customer Retention

are outside the scope of this project.

---

# Data Quality Notes

The raw dataset contains several fields using the string value `'NULL'` instead of SQL NULL.

During data cleaning these values are standardized before analysis.

Primary keys are unique across all tables.

No orphan records were detected in foreign key relationships.

---

# Interpretation Guidance

Business recommendations in this project are based on the available transactional dataset.

They should be interpreted as data-driven opportunities rather than definitive operational conclusions.

Additional datasets—including advertising spend, inventory, customer demographics, and operational costs—would enable more comprehensive business analysis.
