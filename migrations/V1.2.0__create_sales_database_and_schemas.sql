-- ============================================================================
-- Migration: V1.2.0
-- Description: Create Sales database and medallion architecture schemas
-- Purpose: Set up the transient database with Bronze, Silver, Gold, Common layers
-- Environment: Parameterized - replace {{DATABASE_NAME}} for target environment
--   DEV  -> SALES_DEV
--   QA   -> SALES_QA
--   PROD -> SALES_PROD
-- Note: DEV and QA use TRANSIENT (no fail-safe cost); PROD uses permanent
-- ============================================================================

-- Sales analytics database (transient for DEV/QA, permanent for PROD)
CREATE TRANSIENT DATABASE IF NOT EXISTS SALES_DEV
    COMMENT = 'Apple Inc Sales Analytics - Development Environment';

-- Bronze layer: raw data landing zone for ingested source files
CREATE TRANSIENT SCHEMA IF NOT EXISTS SALES_DEV.BRONZE
    COMMENT = 'Raw data landing zone for ingested source files';

-- Silver layer: cleaned, validated, and curated data
CREATE TRANSIENT SCHEMA IF NOT EXISTS SALES_DEV.SILVER
    COMMENT = 'Cleaned and curated data layer';

-- Gold layer: modelled data with fact and dimension tables
CREATE TRANSIENT SCHEMA IF NOT EXISTS SALES_DEV.GOLD
    COMMENT = 'Modelled data with fact and dimension tables';

-- Common layer: shared utilities like file formats, sequences, UDFs, procedures
CREATE TRANSIENT SCHEMA IF NOT EXISTS SALES_DEV.COMMON
    COMMENT = 'Shared utilities - file formats, sequences, UDFs, stored procedures';
