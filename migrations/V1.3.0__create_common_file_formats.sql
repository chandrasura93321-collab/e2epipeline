-- ============================================================================
-- Migration: V1.3.0
-- Description: Create common schema objects - CSV file format
-- Purpose: Reusable file format for all CSV data ingestion into Bronze layer
-- Environment: Replace SALES_DEV with target database (SALES_QA / SALES_PROD)
-- ============================================================================

-- Standard CSV file format used by COPY INTO and INFER_SCHEMA
CREATE FILE FORMAT IF NOT EXISTS SALES_DEV.COMMON.CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    EMPTY_FIELD_AS_NULL = TRUE
    NULL_IF = ('', 'NULL', 'null')
    TRIM_SPACE = TRUE
    COMMENT = 'Standard CSV file format for raw data ingestion';
