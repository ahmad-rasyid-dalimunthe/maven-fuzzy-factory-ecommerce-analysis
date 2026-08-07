# Data Cleaning

## Objective

The objective of the data cleaning phase is to standardize raw data, improve analytical consistency, and prepare reliable business dimensions for downstream reporting.

Although the Maven Fuzzy Factory dataset contains no major structural issues such as duplicate primary keys or broken relationships, several fields required standardization before meaningful business analysis could be performed.

---

# Cleaning Strategy

The cleaning process focused on improving analytical consistency rather than modifying transactional records.

The following principles were applied throughout the project:

- Preserve original business transactions.
- Avoid altering transactional values.
- Standardize inconsistent categorical values.
- Create reusable business classifications.
- Improve reporting consistency across dashboards.

---

# Cleaning Process

## 1. Traffic Attribution Standardization

### Problem

Traffic attribution fields use the literal string **"NULL"** instead of SQL NULL values.

Example:

| utm_source | http_referer |
|------------|--------------|
| NULL | NULL |
| NULL | https://gsearch.com |
| gsearch | NULL |

Without standardization, traffic source analysis becomes inconsistent.

### Solution

Traffic sources were standardized using both UTM parameters and HTTP referrers.

Priority order:

1. UTM Source
2. HTTP Referrer
3. Unattributed

Resulting acquisition sources:

- gsearch
- bsearch
- socialbook
- unattributed

---

## 2. Acquisition Source Classification

To improve marketing analysis, each session was assigned a standardized acquisition source.

Classification logic:

| Condition | Acquisition Source |
|-----------|--------------------|
| UTM available | UTM Source |
| Missing UTM + Search Referrer | Search Engine |
| Missing UTM + No Referrer | Unattributed |

This standardized dimension is used consistently across all analytical data marts.

---

## 3. Attribution Type Classification

An additional business dimension was created to distinguish traffic quality.

Three attribution categories were defined:

| Attribution Type | Description |
|------------------|-------------|
| UTM | Explicit marketing attribution |
| Referrer Only | Organic or referral traffic |
| Unattributed | No identifiable traffic source |

This classification supports acquisition performance analysis and marketing reporting.

---

## 4. Missing Value Standardization

Two types of missing values were identified:

- SQL NULL
- String "NULL"

Rather than modifying the raw tables, the analytical logic standardizes these values during query execution.

This approach preserves the integrity of the source dataset while ensuring consistent reporting.

---

## 5. Validation

Following the cleaning process, validation checks confirmed:

- No duplicate primary keys.
- No orphan records.
- Consistent acquisition source classification.
- Standardized traffic attribution.
- Stable business dimensions for downstream analysis.

---

# Cleaning Output

The cleaning process produces standardized analytical dimensions used throughout the project.

Key business dimensions include:

| Dimension | Purpose |
|-----------|---------|
| acquisition_source | Marketing performance analysis |
| attribution_type | Traffic quality classification |
| device_type | Device segmentation |
| session_date | Time-based reporting |
| product_name | Product analysis |

---

# Impact on Analysis

The cleaning phase improves analytical reliability by:

- Eliminating inconsistent traffic attribution.
- Standardizing marketing dimensions.
- Enabling consistent customer segmentation.
- Supporting reproducible KPI calculations.
- Providing clean inputs for analytical data marts.

---

# Summary

The data cleaning phase required relatively few structural corrections because the source dataset was already well maintained.

Most transformations focused on business standardization rather than data repair, ensuring that downstream analyses accurately reflect customer acquisition, purchasing behavior, and product performance.

---

# Related Resources

- [SQL Script – Data Cleaning](../sql/02_data_cleaning.sql)
- [02 Data Understanding](02_data_understanding.md)
- [04 Exploratory Data Analysis](04_exploratory_data_analysis.md)
