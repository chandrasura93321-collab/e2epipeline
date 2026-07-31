# Session Log - Apple Sales Analytics Data Platform

## Session: 2026-07-31 - Infrastructure DDL Setup

### Objective
Set up the foundational Snowflake infrastructure for Apple Inc's Sales Analytics platform following a medallion architecture (Bronze/Silver/Gold) with Dev/QA/Prod environments.

### Architectural References Reviewed
- `___architectural_notes/medallion-architecture-with-dev-qa-prod.png`
- `___architectural_notes/architectural-important-notes.png`
- `___architectural_notes/architectural-data-flow-rules.png`

### What Was Accomplished

#### 1. Snowflake Objects Created (Executed in Account)

| Object | Fully Qualified Name | Type | Notes |
|--------|---------------------|------|-------|
| Database | `SALES_DEV` | Transient | Dev environment for sales analytics |
| Schema | `SALES_DEV.BRONZE` | Transient | Raw data landing zone |
| Schema | `SALES_DEV.SILVER` | Transient | Cleaned & curated data |
| Schema | `SALES_DEV.GOLD` | Transient | Fact & dimension tables |
| Schema | `SALES_DEV.COMMON` | Transient | File formats, sequences, UDFs |
| File Format | `SALES_DEV.COMMON.CSV_FORMAT` | CSV | Standard CSV ingestion format |
| Stage | `SALES_DEV.BRONZE.STG_RAW` | Internal | Single stage for all raw CSV files |
| Database | `GOVERNANCE` | Permanent | Central governance (tags, policies) |
| Schema | `GOVERNANCE.POLICIES` | Standard | Masking/row access policies |
| Schema | `GOVERNANCE.TAGS` | Standard | Tag definitions |
| Tag | `GOVERNANCE.TAGS.ENVIRONMENT` | Tag | Values: DEV, QA, PROD |
| Tag | `GOVERNANCE.TAGS.COST_CENTER` | Tag | Values: SALES_DEV, SALES_QA, SALES_PROD |
| Tag | `GOVERNANCE.TAGS.DATA_DOMAIN` | Tag | Values: SALES, PRODUCT, CUSTOMER, STORE, REFERENCE |

#### 2. Tags Applied

All SALES_DEV objects tagged with `COST_CENTER = 'SALES_DEV'` and `ENVIRONMENT = 'DEV'` (database, all schemas, and stage).

#### 3. Migration Scripts Created (Schemachange Style)

```
project/migrations/
├── V1.0.0__create_governance_database_and_schemas.sql
├── V1.1.0__create_governance_tags.sql
├── V1.2.0__create_sales_database_and_schemas.sql
├── V1.3.0__create_common_file_formats.sql
├── V1.4.0__create_bronze_internal_stage.sql
└── V1.5.0__apply_governance_tags.sql
```

Scripts follow `V<major>.<minor>.<patch>__<description>.sql` naming pattern and are idempotent (CREATE IF NOT EXISTS).

#### 4. Git Activity
- Committed to `main` branch: `f2d8aba`
- Merged into `dev` branch: `37eb56f`
- Both branches pushed to `origin` (GitHub)

### Architectural Rules Followed
1. All DEV schemas/tables are TRANSIENT (no fail-safe cost)
2. File formats stored in COMMON schema
3. Tags and policies in separate GOVERNANCE database
4. All objects have meaningful comments
5. CREATE IF NOT EXISTS used throughout
6. Objects tagged for chargeback tracking
7. UPPERCASE naming convention for all objects

### Pending / Next Steps
- Load CSV files into `STG_RAW` stage via PUT command
- Use INFER_SCHEMA to create Bronze tables with metadata columns (`__file_name`, `__row_number`, `__load_timestamp`)
- COPY INTO to populate Bronze tables
- Create Dynamic Tables for Silver layer (cleaned data)
- Create Dynamic Tables for Gold layer (fact/dimension tables)
- Create aggregated fact table in Gold
- Create Semantic View in Gold layer
- Create Task for incremental delta load
- Set up SALES_QA and SALES_PROD environments (reuse migration scripts)
