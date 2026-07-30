# Data Profile: region_master.csv

## Overview

| Attribute | Value |
|-----------|-------|
| **Source File** | `__initial_load/country-master/region_master.csv` |
| **Rows** | 5 |
| **Columns** | 7 |
| **Primary Key** | `region_code` |
| **Source System** | MDM_CORE |
| **Table Type** | Reference / Lookup |

## Schema Definition

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | region_code | VARCHAR | NO | Primary key (business code) |
| 2 | region_name | VARCHAR | NO | Descriptive region name |
| 3 | is_active | CHAR(1) | NO | Active flag (Y/N) |
| 4 | effective_start_date | DATE | NO | SCD2 validity start |
| 5 | effective_end_date | DATE | NO | SCD2 validity end (9999-12-31 = current) |
| 6 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 7 | source_system | VARCHAR | NO | Origin system identifier |

## Data Values

| region_code | region_name |
|-------------|-------------|
| AMER | Americas |
| EMEA | Europe Middle East Africa |
| JAPAN | Japan |
| GREATER_CHINA | Greater China |
| APAC | Asia Pacific |

## Data Quality Assessment

| Check | Result | Details |
|-------|--------|---------|
| Uniqueness (PK) | PASS | 5/5 unique region_codes |
| Completeness | PASS | 0 NULLs across all columns |
| Active Records | 100% | All 5 records have is_active = 'Y' |
| Temporal Consistency | PASS | All records: start=2000-01-01, end=9999-12-31 |
| Source System | Uniform | All records from MDM_CORE |
| Historical Records | NONE | No expired/inactive records in initial load |

## Observations

- Static reference table with 5 geographic business regions.
- Uses SCD Type 2 pattern (effective_start_date / effective_end_date) though no historical versions exist in the initial load.
- Japan and Greater China are broken out as separate regions from APAC, suggesting business significance for reporting/segmentation.
- All records share the same creation timestamp, indicating a single bulk load event.

## Downstream Dependencies

- Referenced by `country_master.region_code` (1:M relationship)
