# Apple Inc. E2E Pipeline - Observations & Gap Analysis

**Document Type:** Observations, Gaps, and Recommendations  
**Dataset:** Apple Inc. Retail Data (2019-2025)  
**Prepared By:** Data Engineering Team  
**Date:** 2026-07-30  

---

## 1. STRUCTURAL OBSERVATIONS

### 1.1 Dataset Architecture

| ID | Observation | Impact |
|----|-------------|--------|
| OBS-001 | Dataset follows a 4-level product hierarchy: Category -> Family -> Model -> SKU | Enables drill-down analytics from reporting segments to individual part numbers |
| OBS-002 | Customer data is partitioned by Year then Country (245 files total) | Requires partition-aware loading strategy; cannot simple UNION |
| OBS-003 | Sales transactions split into Header + Item (2 files per year) | Standard star-schema fact table design; currently 1:1 relationship |
| OBS-004 | All reference/dimension tables use SCD2 pattern (effective_start_date / effective_end_date) | Supports historical tracking but currently all records show single version |
| OBS-005 | Source systems span 5 distinct origins: PLM_CORE, ERP_SKU, MDM, RETAIL_OPS, SAP_SD | Multi-system integration; MDM acts as customer golden record |
| OBS-006 | Store data uses synthetic/randomized addresses and coordinates | Not suitable for production geospatial analytics without correction |
| OBS-007 | Country availability file is truncated at 999 rows in source | Estimated 19,500+ rows total; full extract needed |

### 1.2 Data Relationships

| ID | Observation | Impact |
|----|-------------|--------|
| OBS-008 | Product hierarchy has clean referential integrity across all 4 levels | No orphan records; safe for JOIN operations |
| OBS-009 | Customer master covers 35 countries matching country_master exactly | Complete geographic alignment |
| OBS-010 | Sales header references customers, stores, countries, and currencies with valid FKs | Clean dimensional model ready for star-schema |
| OBS-011 | Each sales transaction has exactly 1 line item (no multi-item baskets) | Limits basket analysis and cross-sell metrics |
| OBS-012 | ONLINE transactions correctly have NULL store_id; POS transactions have valid store codes | Clean channel attribution logic |
| OBS-013 | EUR currency serves 9 countries (Eurozone consolidation is correct) | No currency misalignment |

### 1.3 Volume & Growth Patterns

| ID | Observation | Impact |
|----|-------------|--------|
| OBS-014 | Customer base grows ~6% annually (32,827 in 2019 -> 46,295 in 2025) | Healthy growth trajectory; aligns with Apple's real expansion |
| OBS-015 | Transaction volume grows ~5-6% annually (77,155 in 2019 -> 107,922 in 2025) | Consistent with customer growth |
| OBS-016 | US dominates all metrics: 39% of stores, 27% of customers, 29% of transactions | US-centric weighting aligns with Apple's revenue distribution |
| OBS-017 | COVID impact visible in 2020: only 6 new stores opened (vs. 14 in 2019) | Temporal anomaly that should be documented, not "fixed" |

---

## 2. DATA GAPS

### 2.1 Missing Data Elements

| ID | Gap | Severity | Business Impact | Recommendation |
|----|-----|----------|-----------------|----------------|
| GAP-001 | No product pricing table (USD/local) | HIGH | Cannot calculate revenue in standardized currency; price_tier exists but no actual prices | Create product_pricing dimension with historical prices per SKU per country |
| GAP-002 | No FX exchange rate table | HIGH | All transaction amounts in local currency; cannot consolidate to USD for global reporting | Add daily FX rate dimension from Treasury system |
| GAP-003 | No returns/refunds data | HIGH | Net revenue overstated; no product quality signal; no return rate KPI | Add returns_header + returns_item tables |
| GAP-004 | No Apple Services data | HIGH | ~27% of Apple's revenue (iCloud, Music, TV+, App Store) not captured | Extend model to include services subscriptions |
| GAP-005 | No AppleCare attachment data | MEDIUM | Cannot measure service plan attach rate (key Apple retail KPI) | Add service_plan_attachment bridge table |
| GAP-006 | All discontinue_date columns are NULL across product tables | MEDIUM | Cannot determine product lifecycle end; limits sunset/EOL analytics | Populate with actual discontinuation dates |
| GAP-007 | No silicon/chip attribute on Mac models | MEDIUM | Cannot track Intel -> Apple Silicon transition (major business event) | Add chip_generation column to product_model_master |
| GAP-008 | No acquisition channel for customers | MEDIUM | Cannot calculate Customer Acquisition Cost (CAC) by channel | Add acquisition_channel column (online/retail/partner/education) |
| GAP-009 | No customer device ownership / installed base | MEDIUM | Cannot determine ecosystem depth or cross-sell opportunity | Create customer_device_bridge table |
| GAP-010 | Tax jurisdiction granularity mismatch | MEDIUM | Store uses state-level codes (US_FL_STD) but tax_master only has country-level (US_STD) | Create state-level tax_jurisdiction table or extend tax_master |
| GAP-011 | No employee/headcount data for stores | LOW | Cannot normalize revenue per employee or plan staffing | Add store_staffing table |
| GAP-012 | No store renovation/remodel history | LOW | Cannot track "Next Generation" store format upgrades | Add store_event_history table |
| GAP-013 | No customer opt-in/consent flags | LOW | GDPR/CCPA compliance risk for marketing analytics | Add consent_preferences table |
| GAP-014 | No fiscal calendar dimension | LOW | Apple's FY starts Oct 1; standard calendar misaligns with earnings reporting | Create fiscal_calendar dimension |

### 2.2 Data Completeness Gaps

| ID | Gap | Affected Table | Records Impacted |
|----|-----|---------------|-----------------|
| GAP-015 | product_country_availability truncated at 999 rows | product_country_availability | ~18,500 rows missing |
| GAP-016 | No multi-item transactions | sales_item | 621,546 transactions limited to single item each |
| GAP-017 | All lifecycle_status = ACTIVE (no historical state) | product_model_master, product_family_master | 112+ models with no lifecycle progression |
| GAP-018 | Gender limited to Male/Female only | customer_master | Does not reflect modern diversity options |
| GAP-019 | No order_status field on transactions | sales_header | Cannot distinguish COMPLETED vs CANCELLED vs RETURNED |

---

## 3. DESIGN PATTERN OBSERVATIONS

### 3.1 Naming Conventions

| ID | Observation |
|----|-------------|
| OBS-018 | All tables use snake_case naming (e.g., product_sku_master, sales_header) |
| OBS-019 | Primary keys follow `{entity}_code` or `{entity}_id` or `{entity}_sk` pattern |
| OBS-020 | Business keys use human-readable formats: CUST-2019-US-000001, TXN-B8137B056287 |
| OBS-021 | Foreign keys use the same column name as the referenced PK (e.g., country_code references country_code) |
| OBS-022 | Timestamp columns consistently named `created_at` and `updated_at` |
| OBS-023 | SCD2 columns consistently named `effective_start_date` / `effective_end_date` with `is_active` flag |

### 3.2 Data Type Patterns

| ID | Observation |
|----|-------------|
| OBS-024 | UUIDs used for surrogate keys (transaction_sk, customer_id) — good for distributed systems |
| OBS-025 | Boolean fields stored as CHAR(1) 'Y'/'N' in dimensions, 'True'/'False' string in customer_master — **inconsistency** |
| OBS-026 | Dates stored as ISO 8601 format (YYYY-MM-DD) throughout |
| OBS-027 | Timestamps include microsecond precision in reference tables but second precision in transactions |
| OBS-028 | Monetary amounts appear to be DECIMAL with 2 decimal places |

### 3.3 Apple-Specific Patterns

| ID | Observation |
|----|-------------|
| OBS-029 | Product category codes map directly to Apple's 10-K reporting segments (iPhone, Mac, iPad, Wearables/Home/Accessories) |
| OBS-030 | Store format codes (FLG/MINI/MALL) align with Apple Retail's actual store classification system |
| OBS-031 | Apple part number format (M{alphanumeric}LL/A) correctly uses LL/A suffix for US market SKUs |
| OBS-032 | Country launch wave pattern (US Day 0 -> EU Week 1 -> Asia Week 2 -> EM Month 1) matches Apple's real rollout strategy |
| OBS-033 | Payment methods include Apple-specific options: Apple Pay, Apple Financing, Corporate Financing |

---

## 4. RISK OBSERVATIONS

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|-----------|--------|------------|
| RISK-001 | Customer deduplication failure during load (same customer across year partitions) | HIGH | Inflated customer counts, incorrect CLV | Use customer_id as merge key; take latest updated_at |
| RISK-002 | Currency conversion errors without FX rate table | HIGH | Incorrect global revenue totals | Implement FX rate dimension before any cross-currency aggregation |
| RISK-003 | Geolocation data unusable for spatial analytics | MEDIUM | Store locator, cannibalization analysis will fail | Validate and correct lat/lon against city/state data |
| RISK-004 | Vision Pro transactions in 2019 corrupt time-series analysis | LOW | Product launch analytics skewed | Filter or reclassify VPR records pre-2024 |
| RISK-005 | Gender-name mismatches in customer data | LOW | Demographic analytics unreliable | Accept as synthetic data limitation or implement validation |
| RISK-006 | Uniform payment method distribution (synthetic artifact) | LOW | Payment analytics won't reflect real-world patterns | Document as known limitation; don't build payment insights from this data |

---

## 5. SUMMARY METRICS

| Metric | Value |
|--------|-------|
| Total tables/entities | 10 |
| Total records (all files) | ~916,000+ |
| Total columns (unique) | ~120 |
| Countries covered | 35 |
| Time span | 2019-2025 (7 years) |
| Source systems | 5 (PLM_CORE, ERP_SKU, MDM, RETAIL_OPS, SAP_SD) |
| Critical gaps identified | 5 (HIGH severity) |
| Data anomalies found | 4 |
| Observations documented | 33 |

---

*End of Document*
