# Data Profile: tax_master.csv

## Overview

| Attribute | Value |
|-----------|-------|
| **Source File** | `__initial_load/country-master/tax_master.csv` |
| **Rows** | 35 |
| **Columns** | 9 |
| **Primary Key** | `tax_code` |
| **Source System** | TAX_ENGINE |
| **Table Type** | Reference / Lookup |

## Schema Definition

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | tax_code | VARCHAR | NO | Primary key (country-prefixed code) |
| 2 | tax_type | VARCHAR | NO | Tax classification (VAT, GST, etc.) |
| 3 | tax_rate | DECIMAL(4,3) | NO | Rate as decimal fraction (e.g. 0.2 = 20%) |
| 4 | tax_inclusive_flag | CHAR(1) | NO | Y = tax included in listed price, N = added at checkout |
| 5 | effective_start_date | DATE | NO | SCD2 validity start |
| 6 | effective_end_date | DATE | NO | SCD2 validity end |
| 7 | is_active | CHAR(1) | NO | Active flag (Y/N) |
| 8 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 9 | source_system | VARCHAR | NO | Origin system identifier |

## Column Profiling

### tax_type Distribution

| Tax Type | Count | Countries |
|----------|-------|-----------|
| VAT | 25 | UK, DE, FR, NL, SE, CH, BE, NO, DK, FI, IE, AT, IT, ES, CN, TW, KR, PL, AE, SA, TR, IL, ZA, TH, HK |
| GST | 5 | CA, NZ, AU, IN, SG |
| SALES_TAX | 1 | US |
| IVA | 1 | MX |
| ICMS | 1 | BR |
| SST | 1 | MY |
| NONE | 1 | HK |

### tax_rate Statistics

| Metric | Value |
|--------|-------|
| Minimum | 0.000 (HK_NO_TAX) |
| Maximum | 0.255 (FI_VAT_STD = 25.5%) |
| Mean | ~0.153 |
| Median | 0.170 |

### tax_rate Breakdown

| Rate | Tax Code | Country |
|------|----------|---------|
| 0.000 | HK_NO_TAX | Hong Kong |
| 0.050 | CA_GST_STD | Canada |
| 0.050 | TW_VAT_STD | Taiwan |
| 0.050 | AE_VAT_STD | UAE |
| 0.070 | US_SALES_TAX | United States |
| 0.070 | TH_VAT_STD | Thailand |
| 0.081 | CH_VAT_STD | Switzerland |
| 0.090 | SG_GST_STD | Singapore |
| 0.100 | JP_VAT_STD | Japan |
| 0.100 | AU_GST_STD | Australia |
| 0.100 | KR_VAT_STD | South Korea |
| 0.100 | MY_SST_STD | Malaysia |
| 0.130 | CN_VAT_STD | China |
| 0.150 | NZ_GST_STD | New Zealand |
| 0.150 | SA_VAT_STD | Saudi Arabia |
| 0.150 | ZA_VAT_STD | South Africa |
| 0.160 | MX_IVA_STD | Mexico |
| 0.170 | BR_ICMS_STD | Brazil |
| 0.170 | IL_VAT_STD | Israel |
| 0.180 | IN_GST_STD | India |
| 0.190 | DE_VAT_STD | Germany |
| 0.200 | UK_VAT_STD | United Kingdom |
| 0.200 | FR_VAT_STD | France |
| 0.200 | AT_VAT_STD | Austria |
| 0.200 | TR_VAT_STD | Turkey |
| 0.210 | NL_VAT_STD | Netherlands |
| 0.210 | BE_VAT_STD | Belgium |
| 0.210 | ES_VAT_STD | Spain |
| 0.220 | IT_VAT_STD | Italy |
| 0.230 | IE_VAT_STD | Ireland |
| 0.230 | PL_VAT_STD | Poland |
| 0.250 | SE_VAT_STD | Sweden |
| 0.250 | NO_VAT_STD | Norway |
| 0.250 | DK_VAT_STD | Denmark |
| 0.255 | FI_VAT_STD | Finland |

### tax_inclusive_flag Distribution

| Value | Count | Meaning |
|-------|-------|---------|
| Y | 33 | Price displayed to customer includes tax |
| N | 2 | Tax added at checkout (US_SALES_TAX, HK_NO_TAX) |

## Data Quality Assessment

| Check | Result | Details |
|-------|--------|---------|
| Uniqueness (PK) | PASS | 35/35 unique tax_codes |
| Completeness | PASS | 0 NULLs across all columns |
| Rate Range Validity | PASS | All rates between 0.0 and 1.0 |
| Active Records | 100% | All 35 records have is_active = 'Y' |
| Temporal Consistency | PASS | All records: start=2020-01-01, end=9999-12-31 |
| Source System | Uniform | All from TAX_ENGINE |
| Naming Convention | PASS | All codes follow pattern: {COUNTRY}_{TYPE}_{QUALIFIER} |

## Observations

1. **1:1 relationship with country_master**: Each country has exactly one tax code, and each tax code belongs to one country. The tax_code naming convention embeds the country prefix.

2. **Inclusive vs. exclusive pricing**: Only US (sales tax added at checkout) and HK (no tax) use exclusive pricing. All other 33 markets use tax-inclusive pricing. This is critical for storefront display logic.

3. **HK_NO_TAX**: Hong Kong has zero tax. The `tax_type = NONE` and `tax_inclusive_flag = N` are logically consistent.

4. **Tax rates reflect real-world 2024 rates**: FI at 25.5% (raised from 24% in 2024), CH at 8.1% (raised in 2024), etc.

5. **Effective date differs from other master files**: Tax records start at 2020-01-01 (vs 2000-01-01 for regions/currencies), suggesting these rates were last refreshed or versioned in 2020.

## Downstream Dependencies

- Referenced by: `country_master.tax_code` (1:1 relationship)
- Used in: order total calculations, invoice generation, tax reporting
