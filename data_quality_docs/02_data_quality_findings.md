# Apple Inc. E2E Pipeline - Data Quality Analytical Findings

**Document Type:** Data Quality Assessment & Check Specifications  
**Dataset:** Apple Inc. Retail Data (2019-2025)  
**Prepared By:** Data Engineering Team  
**Date:** 2026-07-30  
**Purpose:** Use these findings as the basis for automated data quality checks post-load  

---

## 1. REFERENTIAL INTEGRITY CHECKS

### 1.1 Product Hierarchy Chain

| Check ID | Source Table | Source Column | Target Table | Target Column | Expected Result |
|----------|-------------|---------------|--------------|---------------|-----------------|
| RI-001 | product_family_master | category_code | product_category_master | category_code | 0 orphans |
| RI-002 | product_model_master | family_code | product_family_master | family_code | 0 orphans |
| RI-003 | product_sku_master | model_code | product_model_master | model_code | 0 orphans |
| RI-004 | product_country_availability | sku_code | product_sku_master | sku_code | 0 orphans |
| RI-005 | product_country_availability | country_code | country_master | country_code | 0 orphans |

### 1.2 Country/Region Chain

| Check ID | Source Table | Source Column | Target Table | Target Column | Expected Result |
|----------|-------------|---------------|--------------|---------------|-----------------|
| RI-006 | country_master | region_code | region_master | region_code | 0 orphans |
| RI-007 | country_master | currency_code | currency_master | currency_code | 0 orphans |
| RI-008 | country_master | tax_code | tax_master | tax_code | 0 orphans |

### 1.3 Store Relationships

| Check ID | Source Table | Source Column | Target Table | Target Column | Expected Result |
|----------|-------------|---------------|--------------|---------------|-----------------|
| RI-009 | store_master | country_code | country_master | country_code | 0 orphans |
| RI-010 | store_master | region_code | region_master | region_code | 0 orphans |

### 1.4 Sales Transaction Relationships

| Check ID | Source Table | Source Column | Target Table | Target Column | Expected Result |
|----------|-------------|---------------|--------------|---------------|-----------------|
| RI-011 | sales_header | customer_id | customer_master | customer_id | 0 orphans |
| RI-012 | sales_header | store_id | store_master | store_code | 0 orphans (NULL allowed for ONLINE) |
| RI-013 | sales_header | country_code | country_master | country_code | 0 orphans |
| RI-014 | sales_header | currency | currency_master | currency_code | 0 orphans |
| RI-015 | sales_item | transaction_sk | sales_header | transaction_sk | 0 orphans |
| RI-016 | sales_item | sku_code | product_sku_master | sku_code | 0 orphans |
| RI-017 | sales_item | category_code | product_category_master | category_code | 0 orphans |

---

## 2. PRIMARY KEY / UNIQUENESS CHECKS

| Check ID | Table | Column(s) | Expected | Known Count |
|----------|-------|-----------|----------|-------------|
| PK-001 | region_master | region_code | Unique | 5 |
| PK-002 | country_master | country_code | Unique | 35 |
| PK-003 | currency_master | currency_code | Unique | 27 |
| PK-004 | tax_master | tax_code | Unique | 35 |
| PK-005 | product_category_master | category_code | Unique | 10 |
| PK-006 | product_family_master | family_code | Unique | 44 |
| PK-007 | product_model_master | model_code | Unique | 112 |
| PK-008 | product_sku_master | sku_code | Unique | 651 |
| PK-009 | product_country_availability | (sku_code, country_code) | Unique composite | ~19,500+ |
| PK-010 | store_master | store_code | Unique | 127 |
| PK-011 | customer_master | customer_id | Unique (after dedup) | ~274,111 |
| PK-012 | sales_header | transaction_sk | Unique | 621,546 |
| PK-013 | sales_item | transaction_line_id | Unique | 621,546 |

---

## 3. NULL / COMPLETENESS CHECKS

| Check ID | Table | Column | NULL Allowed? | Expected NULL % | Finding |
|----------|-------|--------|---------------|-----------------|---------|
| NL-001 | store_master | store_close_date | YES | 100% | All stores open (no closures) |
| NL-002 | store_master | state_code | YES | ~30% | NULL for countries without states (UK, FR, IT, etc.) |
| NL-003 | product_model_master | discontinue_date | YES | 100% | All NULL — no product lifecycle end dates |
| NL-004 | product_country_availability | local_discontinue_date | YES | 100% | All NULL |
| NL-005 | sales_header | store_id | YES | ~20% | NULL for ONLINE channel only |
| NL-006 | customer_master | state_province | YES | ~30% | NULL for countries without state/province |
| NL-007 | All dimension tables | All columns except noted above | NO | 0% | No unexpected NULLs |

---

## 4. VALUE DOMAIN CHECKS

### 4.1 Enumerated Values

| Check ID | Table | Column | Valid Values | Invalid Count Expected |
|----------|-------|--------|-------------|----------------------|
| VD-001 | region_master | region_code | AMER, EMEA, JAPAN, GREATER_CHINA, APAC | 0 |
| VD-002 | store_master | format_code | FLG, MINI, MALL | 0 |
| VD-003 | store_master | lifecycle_status | ACTIVE | 0 (currently) |
| VD-004 | customer_master | customer_segment | Consumer, Business, Education | 0 |
| VD-005 | customer_master | loyalty_tier | None, Silver, Gold, Platinum | 0 |
| VD-006 | customer_master | customer_type | NEW, RETURNING | 0 |
| VD-007 | customer_master | gender | Male, Female | 0 |
| VD-008 | sales_header | channel_id | POS, ONLINE | 0 |
| VD-009 | sales_header | payment_method | Cash, Visa, Mastercard, American Express, Discover, Apple Pay, Apple Financing, Bank EMI, Corporate Financing | 0 |
| VD-010 | product_category_master | category_code | IPH, IPD, MAC, WCH, AIR, TV, HMP, DSP, ACC, VPR | 0 |
| VD-011 | All SCD2 tables | is_active | Y, N (dimensions) or True, False (customer) | 0 |
| VD-012 | product_family_master | lifecycle_status | ACTIVE | 0 (currently) |
| VD-013 | sales_header | source_system | SAP_SD | 0 |

### 4.2 Format Validations

| Check ID | Table | Column | Expected Format | Regex Pattern |
|----------|-------|--------|-----------------|---------------|
| FV-001 | customer_master | customer_id | UUID v4 | `^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$` |
| FV-002 | customer_master | customer_number | CUST-YYYY-CC-NNNNNN | `^CUST-\d{4}-[A-Z]{2}-\d{6}$` |
| FV-003 | product_sku_master | sku_code | Apple part number | `^M[A-Z0-9]+LL/A$` |
| FV-004 | store_master | store_code | CC_NNNN | `^[A-Z]{2}_\d{4}$` |
| FV-005 | sales_header | transaction_id | TXN-HEX12 | `^TXN-[A-F0-9]{12}$` |
| FV-006 | sales_item | transaction_line_id | LINE-HEX12 | `^LINE-[A-F0-9]{12,14}$` |
| FV-007 | country_master | country_code | ISO 3166-1 alpha-2 | `^[A-Z]{2}$` |
| FV-008 | country_master | iso_alpha3 | ISO 3166-1 alpha-3 | `^[A-Z]{3}$` |
| FV-009 | currency_master | currency_code | ISO 4217 | `^[A-Z]{3}$` |

---

## 5. NUMERICAL RANGE CHECKS

| Check ID | Table | Column | Min Expected | Max Expected | Finding |
|----------|-------|--------|-------------|-------------|---------|
| NR-001 | store_master | floor_area_sqft | 3,000 | 30,000 | Actual: 5,205 - 24,570 |
| NR-002 | store_master | annual_rent_usd | 100,000 | 25,000,000 | Actual: 660,419 - 19,405,046 |
| NR-003 | store_master | latitude | -60 | 70 | Actual: -32.68 to 60.99 |
| NR-004 | store_master | longitude | -180 | 180 | Actual: -126.18 to 143.79 |
| NR-005 | sales_item | quantity | 1 | 10 | Actual: 1 - 2 |
| NR-006 | sales_item | unit_price | 0.01 | 10,000 | Actual: ~45 - 6,000 |
| NR-007 | sales_item | discount_amount | 0 | unit_price * 0.5 | Most are 0; max ~10% of price |
| NR-008 | sales_item | tax_amount | 0 | unit_price * 0.35 | ~25% of gross consistently |
| NR-009 | sales_header | gross_amount | 0.01 | 10,000 | Matches item unit_price * qty |
| NR-010 | sales_header | net_total | gross - discount | gross + tax | Formula verified |
| NR-011 | customer_master | date_of_birth | 1940-01-01 | 2008-12-31 | Min age ~13 (Apple ID requirement) |
| NR-012 | tax_master | tax_rate | 0.00 | 0.35 | Range: 0.00 (AE) to 0.25 (SE, NO, DK) |

---

## 6. CROSS-TABLE CONSISTENCY CHECKS

| Check ID | Description | Tables Involved | Expected Result |
|----------|-------------|-----------------|-----------------|
| CC-001 | Every country in sales_header exists in country_master | sales_header, country_master | 0 unmatched |
| CC-002 | Every currency in sales_header matches the country's currency in country_master | sales_header, country_master | 0 mismatches |
| CC-003 | POS transactions have valid store_id; ONLINE have NULL | sales_header | 100% correlation |
| CC-004 | Store's country_code matches the transaction's country_code for POS sales | sales_header, store_master | 0 mismatches |
| CC-005 | Customer's country_code matches the transaction's country_code | sales_header, customer_master | Mostly match (allow cross-border purchases) |
| CC-006 | Product category_code in sales_item matches the category derived via SKU -> Model -> Family -> Category chain | sales_item, product hierarchy | 0 mismatches |
| CC-007 | Transaction year matches the file partition year | sales_header per year file | 0 mismatches |
| CC-008 | Customer's registration_date <= first transaction date for that customer | customer_master, sales_header | 0 violations |
| CC-009 | Sales item's SKU launch_date <= transaction_timestamp | sales_item, product_sku_master | 0 violations (except VPR anomaly) |
| CC-010 | Store's store_open_date <= transaction_timestamp for POS sales | sales_header, store_master | 0 violations |

---

## 7. TEMPORAL / BUSINESS RULE CHECKS

| Check ID | Rule | Tables | Expected Result |
|----------|------|--------|-----------------|
| TR-001 | effective_end_date >= effective_start_date (all SCD2 tables) | All dimensions | 0 violations |
| TR-002 | registration_date falls within acquisition_year | customer_master | 0 violations |
| TR-003 | store_open_date <= effective_start_date or same | store_master | Logical consistency |
| TR-004 | Product launch_date is before or equal to country availability local_launch_date | product_model, product_country_availability | US launches first |
| TR-005 | No Vision Pro (VPR) transactions before 2024-02-02 | sales_item | **KNOWN FAIL: 6 records in 2019** |
| TR-006 | Transaction amounts: net_total = gross_amount - total_discount + total_tax | sales_header | 0 violations (tolerance: $0.01) |
| TR-007 | Line total: line_total = (quantity * unit_price) - discount_amount + tax_amount | sales_item | 0 violations (tolerance: $0.01) |
| TR-008 | Header totals = sum of item totals for that transaction | sales_header, sales_item | 0 violations (1:1 so trivially true) |

---

## 8. STATISTICAL DISTRIBUTION CHECKS

### 8.1 Expected Distributions

| Check ID | Table | Column | Expected Pattern | Alert Threshold |
|----------|-------|--------|-----------------|-----------------|
| SD-001 | sales_header | country_code (US) | 27-30% of transactions | Alert if < 20% or > 40% |
| SD-002 | sales_header | channel_id (POS) | 75-85% of transactions | Alert if < 60% or > 95% |
| SD-003 | sales_item | category_code (AIR) | 25-35% of items | Alert if < 15% or > 45% |
| SD-004 | sales_item | category_code (IPH) | 14-20% of items | Alert if < 8% or > 30% |
| SD-005 | customer_master | customer_segment (Consumer) | 70-80% | Alert if < 60% or > 90% |
| SD-006 | customer_master | loyalty_tier (None) | 45-55% | Alert if < 30% or > 70% |
| SD-007 | customer_master | is_active (True) | 80-90% | Alert if < 70% or > 95% |
| SD-008 | store_master | format_code distribution | Each format 25-40% | Alert if any < 15% or > 50% |
| SD-009 | sales_header | payment_method | Each method 8-14% | Alert if any < 5% or > 20% |

### 8.2 Year-over-Year Consistency

| Check ID | Metric | Expected YoY Change | Alert Threshold |
|----------|--------|---------------------|-----------------|
| YOY-001 | Total transactions | +4% to +8% | Alert if < 0% or > 15% |
| YOY-002 | Total customers | +4% to +8% | Alert if < 0% or > 15% |
| YOY-003 | Avg transaction amount | +/- 10% | Alert if > 20% swing |
| YOY-004 | Category mix (top 3) | Stable +/- 5% | Alert if category share shifts > 10% |

---

## 9. DATA ANOMALIES (CONFIRMED)

| Anomaly ID | Table | Description | Records Affected | Severity | Action |
|------------|-------|-------------|-----------------|----------|--------|
| ANM-001 | sales_item | Vision Pro (VPR) transactions in 2019 | 6 records | MEDIUM | Flag/quarantine; VPR launched 2024-02-02 |
| ANM-002 | customer_master | Gender-name mismatches (e.g., "Larry" marked Female) | ~5-10% estimated | LOW | Accept as synthetic data artifact |
| ANM-003 | store_master | GPS coordinates don't match stated city/state | ~30% of US stores | LOW | Geolocation data is synthetic; do not use for spatial analytics |
| ANM-004 | sales_header | Payment method distribution is uniform (~11% each) | All records | INFO | Synthetic distribution; real-world would show Apple Pay at 30-40% |

---

## 10. DATA QUALITY SCORECARD

| Dimension | Score | Weight | Weighted Score |
|-----------|-------|--------|----------------|
| Completeness | 92% | 25% | 23.0 |
| Uniqueness | 100% | 20% | 20.0 |
| Referential Integrity | 98% | 20% | 19.6 |
| Validity (format/domain) | 95% | 15% | 14.3 |
| Consistency (cross-table) | 96% | 10% | 9.6 |
| Timeliness | 100% | 10% | 10.0 |
| **OVERALL SCORE** | | | **96.5 / 100** |

### Score Justification

- **Completeness (92%)**: Deducted for all-NULL discontinue_dates, missing FX rates, truncated availability file
- **Referential Integrity (98%)**: Deducted for tax_jurisdiction granularity mismatch (store vs tax_master)
- **Validity (95%)**: Deducted for VPR anomaly in 2019, gender-name mismatches
- **Consistency (96%)**: Deducted for is_active format inconsistency (Y/N vs True/False)

---

*End of Document*
