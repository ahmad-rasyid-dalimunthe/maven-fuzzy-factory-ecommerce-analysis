# Project Overview

## Project Background

Maven Fuzzy Factory is an e-commerce business that records customer sessions, website interactions, product purchases, and refunds. While the company collects large volumes of transactional data, raw operational data alone provides limited business value without systematic analysis.

This project transforms raw transactional data into actionable business insights through SQL-based analytics and interactive dashboards. The objective is to support data-driven decision-making by evaluating business performance, customer purchasing behavior, and refund performance.

---

# Business Objectives

The project addresses three primary business objectives:

### 1. Evaluate Overall Business Performance

Measure the company's commercial performance by analyzing:

- Revenue
- Gross Profit
- Gross Margin
- Average Order Value (AOV)
- Product Performance
- Acquisition Performance

---

### 2. Understand Customer Purchase Behavior

Analyze customer progression throughout the purchase journey to identify conversion opportunities across:

- Acquisition Sources
- Device Types
- Products
- Funnel Stages

---

### 3. Identify Profit Recovery Opportunities

Evaluate refund performance to determine:

- Products with elevated refund rates
- Revenue lost through refunds
- Potential recoverable revenue
- Impact of refunds on profitability

---

# Project Scope

The analysis focuses on six raw transactional tables:

| Table | Description |
|--------|-------------|
| website_sessions | Customer website sessions and traffic attribution |
| website_pageviews | Customer browsing behavior |
| orders | Completed customer orders |
| order_items | Product-level order transactions |
| order_item_refunds | Product refund transactions |
| products | Product master data |

---

# Analytical Workflow

The project follows a structured analytics workflow.

```
Raw Dataset
      │
      ▼
Data Understanding
      │
      ▼
Data Cleaning
      │
      ▼
Exploratory Data Analysis
      │
      ▼
Business Data Mart Development
      │
      ▼
Interactive Dashboard
      │
      ▼
Business Recommendations
```

---

# Dashboard Structure

Three business-focused dashboards were developed.

| Dashboard | Primary Focus | Data Mart |
|-----------|---------------|-----------|
| Business Performance | Revenue, profitability, acquisition, and product performance | mart_business_performance |
| Customer Funnel | Customer purchase journey and conversion analysis | mart_customer_funnel |
| Refund Analysis | Refund performance and profitability impact | mart_refund_analysis |

---

# Technology Stack

| Category | Technology |
|----------|------------|
| SQL Engine | Google BigQuery |
| Dashboard | Google Looker Studio |
| Version Control | GitHub |
| Documentation | Markdown |


---

# Deliverables

The project produces the following deliverables:

- SQL scripts covering data understanding, cleaning, exploratory analysis, and data mart development.
- Three business-ready data marts optimized for dashboard reporting.
- Three interactive dashboards developed in Google Looker Studio.
- Supporting project documentation describing the analytical process and business findings.
- Actionable business recommendations derived from analytical insights.

---

# Expected Business Value

The project enables stakeholders to:

- Monitor business performance using standardized KPIs.
- Understand customer behavior throughout the purchasing journey.
- Evaluate acquisition channel effectiveness.
- Identify operational opportunities to reduce refunds.
- Improve profitability through data-driven decision-making.

---

# Related Documentation

- [02 Data Understanding](02_data_understanding.md)
- [03 Data Cleaning](03_data_cleaning.md)
- [04 Exploratory Data Analysis](04_exploratory_data_analysis.md)
- [05 Business Recommendations](05_business_recommendations.md)
- [06 Limitations](06_limitations.md)
- [07 Future Improvements](07_future_improvements.md)
