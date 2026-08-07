# Exploratory Data Analysis

## Objective

The objective of the Exploratory Data Analysis (EDA) phase is to transform cleaned transactional data into meaningful business insights that support dashboard development and decision-making.

The analyses conducted during this phase identify trends, customer behavior, operational performance, and profitability drivers that directly informed the design of the three analytical data marts.

---

# Analytical Framework

The exploratory analysis is organized into three business domains.

```
Business Performance
        │
        ▼
Customer Funnel
        │
        ▼
Refund Analysis
```

Each domain corresponds to one production-ready dashboard.

---

# 1. Business Performance Analysis

## Objective

Evaluate the company's commercial performance from revenue, profitability, customer acquisition, and product perspectives.

### Analyses Performed

- Revenue trend over time
- Overall business KPIs
- Revenue by product
- Gross profit by product
- Revenue by acquisition source
- Revenue by device type
- Average Order Value (AOV)
- Gross Margin

### Key Findings

- Revenue shows sustained growth throughout the observation period.
- **The Original Mr. Fuzzy** is the primary revenue contributor, accounting for approximately **62.5% of total revenue**.
- **gsearch** generates the highest revenue among acquisition sources.
- Desktop users contribute substantially more revenue than mobile users.
- Revenue concentration on a single product introduces product dependency risk.

### Business Impact

These findings support strategic decisions related to:

- Product portfolio management
- Marketing budget allocation
- Customer acquisition strategy
- Revenue diversification

---

# 2. Customer Funnel Analysis

## Objective

Understand customer progression throughout the purchase journey and identify conversion opportunities.

### Funnel Stages

- Product Detail
- Cart
- Shipping
- Billing
- Purchase

### Analyses Performed

- Overall customer funnel
- Funnel by acquisition source
- Funnel by device type
- Funnel by product
- Product purchase conversion

### Key Findings

- Customer conversion decreases progressively across each funnel stage.
- Mobile users exhibit significantly lower purchase conversion than desktop users.
- Conversion performance varies across acquisition source and device combinations.
- **socialbook (mobile)** records the lowest purchase conversion, approximately **0.83%**.

### Business Impact

The analysis identifies opportunities to improve:

- Mobile user experience
- Checkout usability
- Marketing campaign effectiveness
- Acquisition channel optimization

---

# 3. Refund Analysis

## Objective

Evaluate refund behavior and quantify its impact on profitability.

### Analyses Performed

- Refund amount by product
- Refund rate by product
- Net revenue after refunds
- Gross profit after refunds
- Potential recoverable revenue

### Key Findings

- **The Birthday Sugar Panda** exhibits the highest refund rate.
- Refunds reduce both revenue and gross profit.
- Products with higher refund rates generate greater recoverable revenue potential.
- Reducing refunds offers a direct opportunity to improve profitability without increasing customer acquisition.

### Business Impact

The analysis supports decisions related to:

- Product quality improvement
- Customer expectation management
- Fulfillment optimization
- Profitability enhancement

---

# Transition to Business Data Marts

The findings from the exploratory analysis were translated into three production-ready analytical data marts.

| Data Mart | Purpose |
|-----------|---------|
| mart_business_performance | Business performance reporting |
| mart_customer_funnel | Customer journey analysis |
| mart_refund_analysis | Refund and profitability analysis |

These data marts were designed to simplify dashboard development by providing standardized business metrics and dimensions.

---

# Summary

The exploratory analysis successfully transformed cleaned transactional data into actionable business insights.

Rather than serving as a final reporting layer, the EDA phase functioned as the analytical foundation for the project's data marts, interactive dashboards, and business recommendations.

---

# Related Resources

- [SQL Script – Exploratory Data Analysis](../SQL/03_exploratory_data_analysis.sql)
- [Business Performance Data Mart](../SQL/04_mart_business_performance.sql)
- [Customer Funnel Data Mart](../SQL/05_mart_customer_funnel.sql)
- [Refund Analysis Data Mart](../SQL/06_mart_refund_analysis.sql)
- [Dashboard Documentation](../dashboard/README.md)
