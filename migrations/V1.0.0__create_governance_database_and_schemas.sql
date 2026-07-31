-- ============================================================================
-- Migration: V1.0.0
-- Description: Create Governance database and schemas
-- Purpose: Central repository for tags, policies, masking and security objects
-- Environment: Shared across all environments (DEV, QA, PROD)
-- ============================================================================

-- Governance database (permanent, not transient - shared across environments)
CREATE DATABASE IF NOT EXISTS GOVERNANCE
    COMMENT = 'Central governance database for tags, policies, masking and security objects';

-- Schema for masking policies, row access policies, and global policies
CREATE SCHEMA IF NOT EXISTS GOVERNANCE.POLICIES
    COMMENT = 'Schema for masking policies, row access policies and global policies';

-- Schema for all tag definitions (chargeback, classification, environment)
CREATE SCHEMA IF NOT EXISTS GOVERNANCE.TAGS
    COMMENT = 'Schema for all tag definitions used for chargeback and classification';
