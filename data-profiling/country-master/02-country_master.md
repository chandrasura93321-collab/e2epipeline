# Data Profile: country_master.csv

## Overview

| Attribute | Value |
|-----------|-------|
| **Source File** | `__initial_load/country-master/country_master.csv` |
| **Rows** | 35 |
| **Columns** | 20 |
| **Primary Key** | `country_code` |
| **Source System** | MDM_CORE |
| **Table Type** | Dimension / Master Data |

## Schema Definition

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | country_code | VARCHAR(2) | NO | Primary key (ISO 3166-1 alpha-2) |
| 2 | country_name | VARCHAR | NO | Full country name |
| 3 | iso_alpha3 | VARCHAR(3) | NO | ISO 3166-1 alpha-3 code |
| 4 | region_code | VARCHAR | NO | FK to region_master |
| 5 | apple_fiscal_segment | VARCHAR | NO | Business fiscal segment |
| 6 | currency_code | VARCHAR(3) | NO | FK to currency_master |
| 7 | tax_code | VARCHAR | NO | FK to tax_master |
| 8 | primary_language | VARCHAR | NO | Primary spoken language |
| 9 | timezone | VARCHAR | NO | IANA timezone identifier |
| 10 | ecommerce_supported | CHAR(1) | NO | E-commerce availability (Y/N) |
| 11 | retail_store_supported | CHAR(1) | NO | Physical retail presence (Y/N) |
| 12 | market_tier | VARCHAR | NO | Market classification (Tier1/Tier2) |
| 13 | population_millions | INTEGER | NO | Population in millions |
| 14 | gdp_usd_billions | INTEGER | NO | GDP in USD billions |
| 15 | gdpr_applicable | CHAR(1) | NO | GDPR compliance required (Y/N) |
| 16 | is_active | CHAR(1) | NO | Active flag (Y/N) |
| 17 | effective_start_date | DATE | NO | SCD2 validity start (market entry date) |
| 18 | effective_end_date | DATE | NO | SCD2 validity end |
| 19 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 20 | source_system | VARCHAR | NO | Origin system identifier |

## Column Profiling

### region_code Distribution

| region_code | Count | Countries |
|-------------|-------|-----------|
| EMEA | 15 | UK, DE, FR, NL, SE, CH, BE, NO, DK, FI, IE, AT, IT, PL, TR, IL, ZA |
| APAC | 8 | AU, NZ, IN, KR, AE, SA, SG, MY, TH |
| AMER | 5 | US, CA, MX, BR |
| GREATER_CHINA | 4 | CN, HK, TW |
| JAPAN | 1 | JP |

### market_tier Distribution

| Tier | Count | Countries |
|------|-------|-----------|
| Tier1 | 14 | US, JP, UK, DE, FR, IT, CA, AU, ES, CN, IN, KR, BR (by GDP/population) |
| Tier2 | 21 | Remaining markets |

### ecommerce_supported / retail_store_supported

| ecommerce | retail | Count |
|-----------|--------|-------|
| Y | Y | 23 |
| Y | N | 12 |
| N | * | 0 |

### apple_fiscal_segment Distribution

| Segment | Count |
|---------|-------|
| Europe | 15 |
| Rest of Asia Pacific | 8 |
| Americas | 5 |
| Greater China | 4 |
| Japan | 1 |

### gdpr_applicable

| Value | Count | Countries |
|-------|-------|-----------|
| Y | 14 | UK, DE, FR, NL, SE, CH, BE, NO, DK, FI, IE, AT, IT, PL |
| N | 21 | All non-European countries |

### effective_start_date Range (Market Entry Dates)

| Metric | Value |
|--------|-------|
| Earliest | 1997-11-10 (US) |
| Latest | 2014-05-06 (TH) |
| Median | ~2008 |

## Data Quality Assessment

| Check | Result | Details |
|-------|--------|---------|
| Uniqueness (PK) | PASS | 35/35 unique country_codes |
| Completeness | PASS | 0 NULLs across all 20 columns |
| Referential Integrity (region_code) | PASS | All values exist in region_master |
| Referential Integrity (currency_code) | PASS | All values exist in currency_master |
| Referential Integrity (tax_code) | PASS | All values exist in tax_master |
| ISO Code Consistency | PASS | All alpha-2 and alpha-3 codes are valid |
| Active Records | 100% | All 35 records have is_active = 'Y' |
| Temporal Consistency | PASS | All end dates = 9999-12-31 |

## Observations and Potential Issues

1. **AE (UAE) and SA (Saudi Arabia)** are assigned to region `APAC` rather than `EMEA`. This appears to be a deliberate business segmentation choice (fiscal segment = "Rest of Asia Pacific") rather than a geographic error.

2. **IL (Israel)** is in region `EMEA` (segment "Europe") but timezone is `Asia/Jerusalem`. This is a common business classification choice.

3. **Currency sharing**: 9 countries share EUR. The relationship to currency_master is M:1.

4. **Tax code relationship**: 1:1 with tax_master (each country has exactly one tax code, each tax code belongs to one country).

5. **Population/GDP values** are static snapshots and may need periodic refresh.

## Downstream Dependencies

- Referenced by: customer_master, sales transactions (via country_code)
- References: region_master, currency_master, tax_master
