-- ============================================================================
-- Migration: V1.1.0
-- Description: Create governance tags for chargeback and classification
-- Purpose: Define reusable tags for environment, cost center, and data domain
-- Environment: Shared across all environments (DEV, QA, PROD)
-- ============================================================================

-- Tag to identify environment context (DEV, QA, PROD)
CREATE TAG IF NOT EXISTS GOVERNANCE.TAGS.ENVIRONMENT
    ALLOWED_VALUES 'DEV', 'QA', 'PROD'
    COMMENT = 'Tag to identify environment context of objects';

-- Tag for chargeback cost tracking across environments
CREATE TAG IF NOT EXISTS GOVERNANCE.TAGS.COST_CENTER
    ALLOWED_VALUES 'SALES_DEV', 'SALES_QA', 'SALES_PROD'
    COMMENT = 'Tag for chargeback cost tracking across environments';

-- Tag for data domain classification of objects
CREATE TAG IF NOT EXISTS GOVERNANCE.TAGS.DATA_DOMAIN
    ALLOWED_VALUES 'SALES', 'PRODUCT', 'CUSTOMER', 'STORE', 'REFERENCE'
    COMMENT = 'Tag for data domain classification of objects';
