# SQL Scripts

This folder contains all SQL scripts used throughout the Maven Fuzzy Factory E-commerce Analysis project.

The scripts follow a structured analytics workflow, beginning with raw data exploration and ending with business-ready data marts used for dashboard development.

---

# SQL Workflow

```
Raw Dataset
     │
     ▼
01_data_understanding.sql
     │
     ▼
02_data_cleaning.sql
     │
     ▼
03_exploratory_data_analysis.sql
     │
     ▼
04_mart_business_performance.sql
     │
     ▼
05_mart_customer_funnel.sql
     │
     ▼
06_mart_refund_analysis.sql
     │
     ▼
Google Looker Studio Dashboard
```

---

# SQL Files

## 01_data_understanding.sql(../SQL/01_data_understanding.sql)

### Purpose

Explore the raw dataset to understand its structure and evaluate overall data quality before performing any transformation.

### Analysis Includes

- Dataset overview
- Date coverage
- Primary key validation
- Referential integrity validation
- Categorical value inspection
- Missing value assessment

### Output

Data quality assessment of all six raw tables.

---

## 02_data_cleaning.sql

### Purpose

Standardize raw data and prepare consistent fields for downstream analysis.

### Cleaning Process

- Standardize traffic attribution values
- Create acquisition source classification
- Create attribution type classification
- Standardize text-based NULL values
- Validate cleaned outputs

### Output

Clean and standardized business dimensions ready for analysis.

---

## 03_exploratory_data_analysis.sql

### Purpose

Perform exploratory analysis to understand customer behavior, sales performance, marketing effectiveness, and refund patterns.

### Analysis Includes

### Business Performance

- Revenue trend
- Product performance
- Acquisition performance
- Device performance

### Customer Funnel

- Overall funnel
- Funnel by acquisition source
- Funnel by device
- Funnel by product

### Refund Analysis

- Product refund rate
- Refund amount
- Recoverable revenue
- Profitability after refund

### Output

Business insights used to define dashboard requirements and business recommendations.

---

## 04_mart_business_performance.sql

### Purpose

Build the Business Performance data mart used by Dashboard Page 1.

### Metrics

- Revenue
- Gross Profit
- Gross Margin
- Net Revenue
- Refund Amount
- Average Order Value

### Dimensions

- Date
- Product
- Acquisition Source
- Device Type

---

## 05_mart_customer_funnel.sql

### Purpose

Build the Customer Funnel data mart used by Dashboard Page 2.

### Funnel Stages

- Product Detail
- Cart
- Shipping
- Billing
- Purchase

### Dimensions

- Acquisition Source
- Device Type
- Product

---

## 06_mart_refund_analysis.sql

### Purpose

Build the Refund Analysis data mart used by Dashboard Page 3.

### Metrics

- Revenue
- Refund Amount
- Refund Rate
- Gross Profit
- Net Revenue
- Recoverable Revenue

### Dimensions

- Product
- Acquisition Source
- Device Type
- Order Date

---

# SQL Standards

This project follows several SQL development principles:

- Modular SQL scripts
- Common Table Expressions (CTEs) for readability
- Consistent naming conventions
- Business-oriented calculations
- Reusable analytical logic
- BigQuery Standard SQL syntax

---

# Data Source

Dataset:

**Maven Fuzzy Factory**

Tables used:

- website_sessions
- website_pageviews
- orders
- order_items
- order_item_refunds
- products

---

# Dashboard Dependency

The final Google Looker Studio dashboard consumes only the following production-ready data marts:

| Dashboard Page | Data Mart |
|----------------|-----------|
| Business Performance | mart_business_performance |
| Customer Funnel | mart_customer_funnel |
| Refund Analysis | mart_refund_analysis |

All exploratory SQL scripts are retained for documentation and reproducibility but are not directly connected to the dashboard.
