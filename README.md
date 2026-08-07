# Maven Fuzzy Factory E-commerce Performance Analysis

## Project Overview

This project analyzes the performance of Maven Fuzzy Factory, an e-commerce business selling stuffed animal products. The objective is to evaluate customer acquisition, conversion funnel performance, product profitability, and refund behavior using SQL, Google BigQuery, and Looker Studio.

The project follows a complete analytics workflow, starting from raw transactional data exploration, data cleaning, exploratory data analysis (EDA), development of analytical data marts, and interactive dashboard visualization for business decision-making.

---

## Business Problem

The business aims to understand:

- Which marketing channels generate the highest business value.
- Where customers drop off during the purchasing journey.
- Which products contribute the most to revenue and profit.
- Which products experience excessive refund rates.
- How refund performance impacts profitability.

---

## Project Objectives

- Assess overall business performance.
- Analyze customer acquisition channels.
- Evaluate customer conversion funnel.
- Measure product-level sales performance.
- Identify refund-related revenue leakage.
- Provide actionable business recommendations.

---

## Dataset

**Source**

Maven Analytics – Maven Fuzzy Factory Dataset

**Raw Tables**

| Table | Description |
|--------|-------------|
| website_sessions | Website visitor sessions |
| website_pageviews | Customer page navigation |
| orders | Completed customer orders |
| order_items | Individual products purchased |
| order_item_refunds | Product refunds |
| products | Product master table |

Additional documentation is available in the **dataset** folder.

---

## Project Architecture

![Project Architecture](../Images/project_architecture_and_data_pipeline.png)
---

## Entity Relationship Diagram (ERD)

<img src="images/erd.png" width="100%">

---

## Technology Stack

| Category | Tools |
|----------|------|
| SQL | Google BigQuery |
| Data Cleaning | SQL |
| Data Modeling | SQL View (Data Mart) |
| Dashboard | Google Looker Studio |
| Documentation | GitHub Markdown |

---

## Project Workflow

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
Business Data Mart
      │
      ▼
Interactive Dashboard
      │
      ▼
Business Insights & Recommendations
```

---

## Data Mart

Three analytical data marts were developed to support dashboard reporting.

| Data Mart | Purpose |
|-----------|---------|
| mart_business_performance | Business KPI and profitability analysis |
| mart_customer_funnel | Customer acquisition and conversion funnel |
| mart_refund_analysis | Product refund performance analysis |

---

## Dashboard

The dashboard consists of three analytical pages.

### 1. Business Performance

<img src="images/dashboard_page1_business_performance.png" width="100%">

---

### 2. Customer Acquisition & Product Funnel

<img src="images/dashboard_page2_customer_funnel.png" width="100%">

---

### 3. Refund Analysis

<img src="images/dashboard_page3_refund_analysis.png" width="100%">

---

## Interactive Dashboard

View the interactive dashboard here:

**Google Looker Studio**

*(Insert your dashboard URL here.)*

---

## Key Insights

### Business Performance

- Gsearch generated the largest revenue contribution.
- Desktop users consistently outperformed mobile users.
- Revenue and gross profit showed a positive long-term trend.

### Customer Funnel

- Significant customer drop-off occurred between Product Detail and Cart.
- Mobile visitors exhibited lower conversion performance.
- The Original Mr. Fuzzy generated the highest purchase volume.

### Refund Analysis

- Refund performance varied considerably across products.
- Products with higher refund rates reduced overall profitability.
- Reducing refund rates to the store average could recover additional revenue.

---

## Business Recommendations

- Optimize product detail pages to improve Add-to-Cart conversion.
- Improve mobile checkout experience.
- Allocate more marketing budget toward high-performing acquisition channels.
- Investigate root causes of high-refund products.
- Prioritize products with strong profitability and lower refund risk.

---

## Repository Structure

```
Maven-Fuzzy-Factory-Analysis
│
├── dataset/
├── dashboard/
├── images/
├── sql/
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## SQL Workflow

```
01_data_understanding.sql

        ↓

02_data_cleaning.sql

        ↓

03_exploratory_data_analysis.sql

        ↓

04_mart_business_performance.sql

        ↓

05_mart_customer_funnel.sql

        ↓

06_mart_refund_analysis.sql
```

---

## Skills Demonstrated

- SQL (Google BigQuery)
- Data Cleaning
- Exploratory Data Analysis
- Data Modeling
- Data Mart Development
- Marketing Analytics
- Customer Funnel Analysis
- Product Performance Analysis
- Refund Analysis
- Business Intelligence
- Dashboard Development
- Data Visualization

---

## Author

**Ahmad Rasyid Dalimunthe**

Aspiring Data Analyst

LinkedIn: *(add your profile)*

GitHub: *(add your profile)*
