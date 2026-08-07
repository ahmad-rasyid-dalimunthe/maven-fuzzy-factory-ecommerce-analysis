# Project Limitations

## Purpose

This document outlines the limitations encountered during the Maven Fuzzy Factory E-commerce Analysis project.

Understanding these limitations is important to ensure that analytical results are interpreted correctly and that future improvements are clearly identified.

---

# Dataset Limitations

## 1. Product-Level Funnel Tracking

### Limitation

The dataset does not record product identifiers during the checkout process.

Specifically, the following stages only contain **website_session_id**:

- Cart
- Shipping
- Billing

Product information becomes available again only after an order is successfully created.

### Impact

The analysis can determine that:

- A customer viewed a product.
- The session progressed through the checkout funnel.
- A product was eventually purchased.

However, it **cannot confirm** that the product viewed is the same product that reached the cart, shipping, or billing stages.

Therefore, the funnel is analyzed at the **session level** rather than the **product level**.

---

## 2. Marketing Cost Information

### Limitation

The dataset does not include marketing expenditure.

Unavailable metrics include:

- Advertising spend
- Campaign cost
- Cost per Click (CPC)
- Customer Acquisition Cost (CAC)
- Return on Advertising Spend (ROAS)

### Impact

Marketing performance is evaluated using:

- Sessions
- Orders
- Revenue
- Gross Profit

instead of investment-based efficiency metrics.

---

## 3. Customer-Level Analysis

### Limitation

Although user identifiers are available, the dataset does not contain sufficient customer attributes for advanced customer analytics.

Unavailable information includes:

- Customer demographics
- Geographic location
- Customer lifetime
- Loyalty status

### Impact

The project focuses on transactional behavior rather than customer segmentation.

---

## 4. Inventory and Operations

### Limitation

The dataset contains product costs but does not include operational information such as:

- Inventory levels
- Warehouse availability
- Shipping costs
- Supplier information

### Impact

Operational efficiency and inventory optimization cannot be evaluated.

---

# Analytical Assumptions

Several assumptions were made to standardize business reporting.

## Traffic Attribution

Traffic attribution follows the following priority:

1. UTM Source
2. HTTP Referrer
3. Unattributed

This rule provides a consistent acquisition source classification across all analyses.

---

## Refund Allocation

Refund values are associated directly with the corresponding order item.

The analysis assumes that each recorded refund accurately represents the financial impact of the refunded product.

---

## Gross Profit Calculation

Gross profit is calculated as:

```
Revenue − COGS
```

Refund amounts are subsequently deducted to calculate:

- Net Revenue After Refund
- Gross Profit After Refund

---

# Interpretation Considerations

Results presented throughout the project should be interpreted with the following considerations:

- Funnel analysis represents customer sessions rather than confirmed product journeys.
- Acquisition performance excludes advertising costs.
- Refund analysis reflects recorded refund transactions only.
- Business recommendations are derived from the available dataset and may evolve if additional operational or marketing data becomes available.

---

# Future Data Requirements

Future versions of the project would benefit from additional datasets, including:

- Product identifiers at every checkout stage
- Marketing spend
- Customer demographic information
- Inventory history
- Delivery performance
- Customer support interactions

These additional data sources would enable more advanced business analyses and more comprehensive performance measurement.

---

# Related Resources

- [04 Exploratory Data Analysis](04_exploratory_data_analysis.md)
- [07 Future Improvements](07_future_improvements.md)
- [Customer Funnel Data Mart](../sql/05_mart_customer_funnel.sql)
