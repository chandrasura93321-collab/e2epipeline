-- ============================================================================
-- Migration: V1.4.0
-- Description: Create internal stage in Bronze schema for raw file landing
-- Purpose: Single internal stage for all CSV source files (PUT target)
-- Environment: Replace SALES_DEV with target database (SALES_QA / SALES_PROD)
-- ============================================================================

-- Internal stage for all raw CSV source files
-- Files are uploaded here via PUT command before COPY INTO loads them to tables
CREATE STAGE IF NOT EXISTS SALES_DEV.BRONZE.STG_RAW
    FILE_FORMAT = SALES_DEV.COMMON.CSV_FORMAT
    COMMENT = 'Internal stage for all raw CSV source files';
