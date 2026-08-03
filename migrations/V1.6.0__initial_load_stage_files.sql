-- ============================================================================
-- Migration: V1.6.0
-- Description: Initial load - Upload CSV source files to internal stage
-- Purpose: Place all raw CSV files into STG_RAW stage for subsequent COPY INTO
-- Note: These are Snow CLI commands (not SQL). They are stored here as
--       commented reference for the database change management process.
--       Execute these commands from a local terminal with Snow CLI installed.
-- Connection: snow CLI connection "coco" (Snowflake account: RGZARGH-YZ09033)
-- Stage: @SALES_DEV.BRONZE.STG_RAW
-- Options: --parallel 10 --auto-compress --overwrite
-- ============================================================================

-- ==========================================================
-- 1. Country Master (4 files)
-- Path: initial-load/country-master/
-- ==========================================================

-- snow stage copy "project\__initial_load\country-master\country_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/country-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\country-master\currency_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/country-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\country-master\region_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/country-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\country-master\tax_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/country-master/" -c coco --parallel 10 --auto-compress --overwrite

-- ==========================================================
-- 2. Product Master (5 files)
-- Path: initial-load/product-master/
-- ==========================================================

-- snow stage copy "project\__initial_load\product-master\product_category_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/product-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\product-master\product_country_availability.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/product-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\product-master\product_family_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/product-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\product-master\product_model_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/product-master/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\product-master\product_sku_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/product-master/" -c coco --parallel 10 --auto-compress --overwrite

-- ==========================================================
-- 3. Store Master (1 file)
-- Path: initial-load/store-master/
-- ==========================================================

-- snow stage copy "project\__initial_load\store-master\store_master.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/store-master/" -c coco --parallel 10 --auto-compress --overwrite

-- ==========================================================
-- 4. Customer Master - 2019 (35 files, partitioned by country)
-- Path: initial-load/customer-master/2019/<COUNTRY_CODE>/
-- ==========================================================

-- snow stage copy "project\__initial_load\customer-master\2019\AE\customer_master_2019_AE.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/AE/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\AT\customer_master_2019_AT.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/AT/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\AU\customer_master_2019_AU.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/AU/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\BE\customer_master_2019_BE.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/BE/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\BR\customer_master_2019_BR.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/BR/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\CA\customer_master_2019_CA.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/CA/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\CH\customer_master_2019_CH.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/CH/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\CN\customer_master_2019_CN.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/CN/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\DE\customer_master_2019_DE.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/DE/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\DK\customer_master_2019_DK.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/DK/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\ES\customer_master_2019_ES.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/ES/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\FI\customer_master_2019_FI.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/FI/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\FR\customer_master_2019_FR.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/FR/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\HK\customer_master_2019_HK.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/HK/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\IE\customer_master_2019_IE.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/IE/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\IL\customer_master_2019_IL.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/IL/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\IN\customer_master_2019_IN.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/IN/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\IT\customer_master_2019_IT.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/IT/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\JP\customer_master_2019_JP.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/JP/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\KR\customer_master_2019_KR.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/KR/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\MX\customer_master_2019_MX.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/MX/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\MY\customer_master_2019_MY.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/MY/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\NL\customer_master_2019_NL.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/NL/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\NO\customer_master_2019_NO.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/NO/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\NZ\customer_master_2019_NZ.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/NZ/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\PL\customer_master_2019_PL.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/PL/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\SA\customer_master_2019_SA.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/SA/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\SE\customer_master_2019_SE.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/SE/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\SG\customer_master_2019_SG.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/SG/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\TH\customer_master_2019_TH.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/TH/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\TR\customer_master_2019_TR.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/TR/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\TW\customer_master_2019_TW.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/TW/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\UK\customer_master_2019_UK.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/UK/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\US\customer_master_2019_US.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/US/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\customer-master\2019\ZA\customer_master_2019_ZA.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/customer-master/2019/ZA/" -c coco --parallel 10 --auto-compress --overwrite

-- ==========================================================
-- 5. Sales Transactions - 2019 (2 files, partitioned by year)
-- Path: initial-load/sales-transaction/2019/
-- ==========================================================

-- snow stage copy "project\__initial_load\sales-transaction\2019\sales_header_2019.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/sales-transaction/2019/" -c coco --parallel 10 --auto-compress --overwrite
-- snow stage copy "project\__initial_load\sales-transaction\2019\sales_item_2019.csv" "@SALES_DEV.BRONZE.STG_RAW/initial-load/sales-transaction/2019/" -c coco --parallel 10 --auto-compress --overwrite

-- ==========================================================
-- Verification: List all uploaded files
-- ==========================================================
-- LIST @SALES_DEV.BRONZE.STG_RAW/initial-load/;
