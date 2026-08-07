# Data Understanding

## Objective

The objective of the data understanding phase is to evaluate the quality, completeness, and integrity of the raw dataset before performing any data transformation or business analysis.

This phase ensures that the dataset is suitable for analytical processing and identifies potential data quality issues that may affect downstream reporting.

---

# Dataset Overview

The project uses six relational tables representing customer sessions, website interactions, transactions, products, and refunds.

| Table | Description |
|--------|-------------|
| website_sessions | Customer website sessions and traffic attribution |
| website_pageviews | Customer browsing activities |
| orders | Customer purchase transactions |
| order_items | Product-level transaction details |
| order_item_refunds | Refund transactions |
| products | Product master information |

The relationships between these tables were validated during the data understanding phase to ensure referential integrity.

---

# Data Quality Assessment

The following validation checks were performed.

## 1. Dataset Overview

Purpose:

- Verify the availability of all required tables.
- Measure dataset size.
- Understand data volume before analysis.

Validation:

- Row count for each table.

Result:

- All six tables were successfully loaded.
- Dataset sizes are consistent with an operational e-commerce database.

---

## 2. Date Coverage

Purpose:

Understand the available observation period for analytical reporting.

Validation:

- Minimum transaction date.
- Maximum transaction date.

Result:

- The dataset covers approximately three years of business activity, providing sufficient historical information for trend analysis.

---

## 3. Primary Key Validation

Purpose:

Verify that every primary key uniquely identifies a single record.

Validated Keys:

- website_session_id
- website_pageview_id
- order_id
- order_item_id
- order_item_refund_id
- product_id

Result:

- No duplicate primary keys were detected.
- Entity integrity is fully maintained across all tables.

---

## 4. Referential Integrity Validation

Purpose:

Ensure that relationships between tables are complete and no orphan records exist.

Relationships validated:

- Orders → Website Sessions
- Order Items → Orders
- Refunds → Order Items
- Website Pageviews → Website Sessions

Result:

- No orphan records were identified.
- All foreign key relationships are valid.

---

## 5. Categorical Data Inspection

Purpose:

Review business dimensions available for segmentation and dashboard reporting.

Fields inspected:

- Device Type
- Traffic Source
- Campaign
- Website URLs

Result:

- Categorical fields are internally consistent.
- The available categories support customer acquisition, funnel, and product analyses.

---

## 6. Missing Value Assessment

Purpose:

Evaluate missing values stored as:

- SQL NULL
- String "NULL"

Result:

- Critical identifier fields contain no SQL NULL values.
- Several traffic attribution fields store missing information as the string "NULL" rather than SQL NULL.
- This representation requires standardization during the data cleaning stage.

---

# Key Findings

The data understanding phase produced several important findings:

- Primary keys are unique across all tables.
- No referential integrity issues were detected.
- Critical business entities contain no missing identifiers.
- Missing traffic attribution values are represented as the string "NULL".
- The dataset provides sufficient historical coverage for trend analysis.

---

# Impact on Subsequent Analysis

The findings from this phase directly informed the data cleaning strategy.

Specifically:

- Traffic attribution fields were standardized.
- Acquisition source classification was created.
- Attribution categories were derived for downstream analysis.
- Business dimensions were validated before constructing analytical data marts.

---

# Related Resources

- [SQL Script – Data Understanding](../SQL/01_data_understanding.sql)
- [03 Data Cleaning](03_data_cleaning.md)
