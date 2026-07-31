-- ============================================================================
-- Migration: V1.5.0
-- Description: Apply governance tags to Sales database objects
-- Purpose: Enable chargeback tracking and environment identification
-- Environment: Update tag values per environment:
--   DEV  -> COST_CENTER='SALES_DEV', ENVIRONMENT='DEV'
--   QA   -> COST_CENTER='SALES_QA',  ENVIRONMENT='QA'
--   PROD -> COST_CENTER='SALES_PROD', ENVIRONMENT='PROD'
-- ============================================================================

-- Tag the database for cost tracking and environment identification
ALTER DATABASE SALES_DEV SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';

-- Tag Bronze schema
ALTER SCHEMA SALES_DEV.BRONZE SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';

-- Tag Silver schema
ALTER SCHEMA SALES_DEV.SILVER SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';

-- Tag Gold schema
ALTER SCHEMA SALES_DEV.GOLD SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';

-- Tag Common schema
ALTER SCHEMA SALES_DEV.COMMON SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';

-- Tag internal stage for chargeback
ALTER STAGE SALES_DEV.BRONZE.STG_RAW SET TAG
    GOVERNANCE.TAGS.COST_CENTER = 'SALES_DEV',
    GOVERNANCE.TAGS.ENVIRONMENT = 'DEV';
