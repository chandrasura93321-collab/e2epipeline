# Apple Inc. E2E Pipeline - SQL Data Validation Queries

**Document Type:** SQL Validation Queries for Post-Load Data Quality Checks  
**Dataset:** Apple Inc. Retail Data (2019-2025)  
**Prepared By:** Data Engineering Team  
**Date:** 2026-07-30  
**Assumption:** CSV files loaded into Snowflake tables with the same name as the CSV file (without extension)  

---

## Table Name Mapping

| CSV File | Target Table Name |
|----------|-------------------|
| region_master.csv | REGION_MASTER |
| country_master.csv | COUNTRY_MASTER |
| currency_master.csv | CURRENCY_MASTER |
| tax_master.csv | TAX_MASTER |
| product_category_master.csv | PRODUCT_CATEGORY_MASTER |
| product_family_master.csv | PRODUCT_FAMILY_MASTER |
| product_model_master.csv | PRODUCT_MODEL_MASTER |
| product_sku_master.csv | PRODUCT_SKU_MASTER |
| product_country_availability.csv | PRODUCT_COUNTRY_AVAILABILITY |
| store_master.csv | STORE_MASTER |
| customer_master_YYYY_CC.csv | CUSTOMER_MASTER (consolidated) |
| sales_header_YYYY.csv | SALES_HEADER (consolidated) |
| sales_item_YYYY.csv | SALES_ITEM (consolidated) |

---

## 1. PRIMARY KEY / UNIQUENESS CHECKS

```sql
-- PK-001: Region master uniqueness
SELECT 'PK-001' AS check_id, 'region_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT region_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT region_code) AS duplicates
FROM region_master;

-- PK-002: Country master uniqueness
SELECT 'PK-002' AS check_id, 'country_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT country_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT country_code) AS duplicates
FROM country_master;

-- PK-003: Currency master uniqueness
SELECT 'PK-003' AS check_id, 'currency_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT currency_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT currency_code) AS duplicates
FROM currency_master;

-- PK-004: Tax master uniqueness
SELECT 'PK-004' AS check_id, 'tax_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT tax_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT tax_code) AS duplicates
FROM tax_master;

-- PK-005: Product category master uniqueness
SELECT 'PK-005' AS check_id, 'product_category_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT category_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT category_code) AS duplicates
FROM product_category_master;

-- PK-006: Product family master uniqueness
SELECT 'PK-006' AS check_id, 'product_family_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT family_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT family_code) AS duplicates
FROM product_family_master;

-- PK-007: Product model master uniqueness
SELECT 'PK-007' AS check_id, 'product_model_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT model_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT model_code) AS duplicates
FROM product_model_master;

-- PK-008: Product SKU master uniqueness
SELECT 'PK-008' AS check_id, 'product_sku_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT sku_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT sku_code) AS duplicates
FROM product_sku_master;

-- PK-009: Product country availability composite key uniqueness
SELECT 'PK-009' AS check_id, 'product_country_availability' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT CONCAT(sku_code, '|', country_code)) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT CONCAT(sku_code, '|', country_code)) AS duplicates
FROM product_country_availability;

-- PK-010: Store master uniqueness
SELECT 'PK-010' AS check_id, 'store_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT store_code) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT store_code) AS duplicates
FROM store_master;

-- PK-011: Customer master uniqueness (after consolidation)
SELECT 'PK-011' AS check_id, 'customer_master' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT customer_id) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT customer_id) AS duplicates
FROM customer_master;

-- PK-012: Sales header uniqueness
SELECT 'PK-012' AS check_id, 'sales_header' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT transaction_sk) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT transaction_sk) AS duplicates
FROM sales_header;

-- PK-013: Sales item uniqueness
SELECT 'PK-013' AS check_id, 'sales_item' AS table_name,
       COUNT(*) AS total_rows,
       COUNT(DISTINCT transaction_line_id) AS distinct_keys,
       COUNT(*) - COUNT(DISTINCT transaction_line_id) AS duplicates
FROM sales_item;
```

---

## 2. REFERENTIAL INTEGRITY CHECKS

```sql
-- RI-001: Product family -> category
SELECT 'RI-001' AS check_id,
       'product_family_master.category_code -> product_category_master' AS relationship,
       COUNT(*) AS orphan_count
FROM product_family_master f
LEFT JOIN product_category_master c ON f.category_code = c.category_code
WHERE c.category_code IS NULL;

-- RI-002: Product model -> family
SELECT 'RI-002' AS check_id,
       'product_model_master.family_code -> product_family_master' AS relationship,
       COUNT(*) AS orphan_count
FROM product_model_master m
LEFT JOIN product_family_master f ON m.family_code = f.family_code
WHERE f.family_code IS NULL;

-- RI-003: Product SKU -> model
SELECT 'RI-003' AS check_id,
       'product_sku_master.model_code -> product_model_master' AS relationship,
       COUNT(*) AS orphan_count
FROM product_sku_master s
LEFT JOIN product_model_master m ON s.model_code = m.model_code
WHERE m.model_code IS NULL;

-- RI-004: Product country availability -> SKU
SELECT 'RI-004' AS check_id,
       'product_country_availability.sku_code -> product_sku_master' AS relationship,
       COUNT(*) AS orphan_count
FROM product_country_availability a
LEFT JOIN product_sku_master s ON a.sku_code = s.sku_code
WHERE s.sku_code IS NULL;

-- RI-005: Product country availability -> country
SELECT 'RI-005' AS check_id,
       'product_country_availability.country_code -> country_master' AS relationship,
       COUNT(*) AS orphan_count
FROM product_country_availability a
LEFT JOIN country_master c ON a.country_code = c.country_code
WHERE c.country_code IS NULL;

-- RI-006: Country -> region
SELECT 'RI-006' AS check_id,
       'country_master.region_code -> region_master' AS relationship,
       COUNT(*) AS orphan_count
FROM country_master c
LEFT JOIN region_master r ON c.region_code = r.region_code
WHERE r.region_code IS NULL;

-- RI-007: Country -> currency
SELECT 'RI-007' AS check_id,
       'country_master.currency_code -> currency_master' AS relationship,
       COUNT(*) AS orphan_count
FROM country_master c
LEFT JOIN currency_master cu ON c.currency_code = cu.currency_code
WHERE cu.currency_code IS NULL;

-- RI-008: Country -> tax
SELECT 'RI-008' AS check_id,
       'country_master.tax_code -> tax_master' AS relationship,
       COUNT(*) AS orphan_count
FROM country_master c
LEFT JOIN tax_master t ON c.tax_code = t.tax_code
WHERE t.tax_code IS NULL;

-- RI-009: Store -> country
SELECT 'RI-009' AS check_id,
       'store_master.country_code -> country_master' AS relationship,
       COUNT(*) AS orphan_count
FROM store_master s
LEFT JOIN country_master c ON s.country_code = c.country_code
WHERE c.country_code IS NULL;

-- RI-010: Store -> region
SELECT 'RI-010' AS check_id,
       'store_master.region_code -> region_master' AS relationship,
       COUNT(*) AS orphan_count
FROM store_master s
LEFT JOIN region_master r ON s.region_code = r.region_code
WHERE r.region_code IS NULL;

-- RI-011: Sales header -> customer
SELECT 'RI-011' AS check_id,
       'sales_header.customer_id -> customer_master' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_header sh
LEFT JOIN customer_master cm ON sh.customer_id = cm.customer_id
WHERE cm.customer_id IS NULL;

-- RI-012: Sales header -> store (POS only)
SELECT 'RI-012' AS check_id,
       'sales_header.store_id -> store_master (POS only)' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_header sh
LEFT JOIN store_master sm ON sh.store_id = sm.store_code
WHERE sh.channel_id = 'POS'
  AND sm.store_code IS NULL;

-- RI-013: Sales header -> country
SELECT 'RI-013' AS check_id,
       'sales_header.country_code -> country_master' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_header sh
LEFT JOIN country_master c ON sh.country_code = c.country_code
WHERE c.country_code IS NULL;

-- RI-014: Sales header -> currency
SELECT 'RI-014' AS check_id,
       'sales_header.currency -> currency_master' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_header sh
LEFT JOIN currency_master cu ON sh.currency = cu.currency_code
WHERE cu.currency_code IS NULL;

-- RI-015: Sales item -> sales header
SELECT 'RI-015' AS check_id,
       'sales_item.transaction_sk -> sales_header' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_item si
LEFT JOIN sales_header sh ON si.transaction_sk = sh.transaction_sk
WHERE sh.transaction_sk IS NULL;

-- RI-016: Sales item -> product SKU
SELECT 'RI-016' AS check_id,
       'sales_item.sku_code -> product_sku_master' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_item si
LEFT JOIN product_sku_master ps ON si.sku_code = ps.sku_code
WHERE ps.sku_code IS NULL;

-- RI-017: Sales item -> product category
SELECT 'RI-017' AS check_id,
       'sales_item.category_code -> product_category_master' AS relationship,
       COUNT(*) AS orphan_count
FROM sales_item si
LEFT JOIN product_category_master pc ON si.category_code = pc.category_code
WHERE pc.category_code IS NULL;
```

---

## 3. NULL / COMPLETENESS CHECKS

```sql
-- NL-001 to NL-007: Comprehensive NULL check across all tables
SELECT 'NULL_CHECK' AS check_type,
       table_name,
       column_name,
       total_rows,
       null_count,
       ROUND(null_count * 100.0 / total_rows, 2) AS null_pct
FROM (
    -- Region master
    SELECT 'region_master' AS table_name, 'region_code' AS column_name,
           COUNT(*) AS total_rows, SUM(CASE WHEN region_code IS NULL THEN 1 ELSE 0 END) AS null_count
    FROM region_master
    UNION ALL
    SELECT 'country_master', 'country_code', COUNT(*), SUM(CASE WHEN country_code IS NULL THEN 1 ELSE 0 END) FROM country_master
    UNION ALL
    SELECT 'store_master', 'store_close_date', COUNT(*), SUM(CASE WHEN store_close_date IS NULL THEN 1 ELSE 0 END) FROM store_master
    UNION ALL
    SELECT 'store_master', 'state_code', COUNT(*), SUM(CASE WHEN state_code IS NULL OR state_code = '' THEN 1 ELSE 0 END) FROM store_master
    UNION ALL
    SELECT 'product_model_master', 'discontinue_date', COUNT(*), SUM(CASE WHEN discontinue_date IS NULL THEN 1 ELSE 0 END) FROM product_model_master
    UNION ALL
    SELECT 'sales_header', 'store_id', COUNT(*), SUM(CASE WHEN store_id IS NULL OR store_id = '' THEN 1 ELSE 0 END) FROM sales_header
    UNION ALL
    SELECT 'customer_master', 'state_province', COUNT(*), SUM(CASE WHEN state_province IS NULL OR state_province = '' THEN 1 ELSE 0 END) FROM customer_master
);
```

---

## 4. VALUE DOMAIN CHECKS

```sql
-- VD-001: Region code valid values
SELECT 'VD-001' AS check_id, region_code AS invalid_value, COUNT(*) AS count
FROM region_master
WHERE region_code NOT IN ('AMER', 'EMEA', 'JAPAN', 'GREATER_CHINA', 'APAC')
GROUP BY region_code;

-- VD-002: Store format valid values
SELECT 'VD-002' AS check_id, format_code AS invalid_value, COUNT(*) AS count
FROM store_master
WHERE format_code NOT IN ('FLG', 'MINI', 'MALL')
GROUP BY format_code;

-- VD-003: Customer segment valid values
SELECT 'VD-003' AS check_id, customer_segment AS invalid_value, COUNT(*) AS count
FROM customer_master
WHERE customer_segment NOT IN ('Consumer', 'Business', 'Education')
GROUP BY customer_segment;

-- VD-004: Loyalty tier valid values
SELECT 'VD-004' AS check_id, loyalty_tier AS invalid_value, COUNT(*) AS count
FROM customer_master
WHERE loyalty_tier NOT IN ('None', 'Silver', 'Gold', 'Platinum')
GROUP BY loyalty_tier;

-- VD-005: Customer type valid values
SELECT 'VD-005' AS check_id, customer_type AS invalid_value, COUNT(*) AS count
FROM customer_master
WHERE customer_type NOT IN ('NEW', 'RETURNING')
GROUP BY customer_type;

-- VD-006: Sales channel valid values
SELECT 'VD-006' AS check_id, channel_id AS invalid_value, COUNT(*) AS count
FROM sales_header
WHERE channel_id NOT IN ('POS', 'ONLINE')
GROUP BY channel_id;

-- VD-007: Payment method valid values
SELECT 'VD-007' AS check_id, payment_method AS invalid_value, COUNT(*) AS count
FROM sales_header
WHERE payment_method NOT IN ('Cash', 'Visa', 'Mastercard', 'American Express', 'Discover',
                              'Apple Pay', 'Apple Financing', 'Bank EMI', 'Corporate Financing')
GROUP BY payment_method;

-- VD-008: Product category valid values
SELECT 'VD-008' AS check_id, category_code AS invalid_value, COUNT(*) AS count
FROM product_category_master
WHERE category_code NOT IN ('IPH', 'IPD', 'MAC', 'WCH', 'AIR', 'TV', 'HMP', 'DSP', 'ACC', 'VPR')
GROUP BY category_code;

-- VD-009: is_active valid values (dimension tables)
SELECT 'VD-009' AS check_id, 'store_master' AS table_name, is_active AS invalid_value, COUNT(*) AS count
FROM store_master
WHERE is_active NOT IN ('Y', 'N')
GROUP BY is_active;
```

---

## 5. NUMERICAL RANGE CHECKS

```sql
-- NR-001: Store floor area range
SELECT 'NR-001' AS check_id, 'store_master.floor_area_sqft' AS column_checked,
       MIN(floor_area_sqft) AS min_val, MAX(floor_area_sqft) AS max_val, AVG(floor_area_sqft) AS avg_val,
       SUM(CASE WHEN floor_area_sqft < 3000 OR floor_area_sqft > 30000 THEN 1 ELSE 0 END) AS out_of_range
FROM store_master;

-- NR-002: Store annual rent range
SELECT 'NR-002' AS check_id, 'store_master.annual_rent_usd' AS column_checked,
       MIN(annual_rent_usd) AS min_val, MAX(annual_rent_usd) AS max_val, AVG(annual_rent_usd) AS avg_val,
       SUM(CASE WHEN annual_rent_usd < 100000 OR annual_rent_usd > 25000000 THEN 1 ELSE 0 END) AS out_of_range
FROM store_master;

-- NR-003/004: Store coordinates range
SELECT 'NR-003/004' AS check_id, 'store_master coordinates' AS column_checked,
       SUM(CASE WHEN latitude < -60 OR latitude > 70 THEN 1 ELSE 0 END) AS lat_out_of_range,
       SUM(CASE WHEN longitude < -180 OR longitude > 180 THEN 1 ELSE 0 END) AS lon_out_of_range
FROM store_master;

-- NR-005: Sales item quantity range
SELECT 'NR-005' AS check_id, 'sales_item.quantity' AS column_checked,
       MIN(quantity) AS min_val, MAX(quantity) AS max_val,
       SUM(CASE WHEN quantity < 1 OR quantity > 10 THEN 1 ELSE 0 END) AS out_of_range
FROM sales_item;

-- NR-006: Sales item unit price range
SELECT 'NR-006' AS check_id, 'sales_item.unit_price' AS column_checked,
       MIN(unit_price) AS min_val, MAX(unit_price) AS max_val,
       SUM(CASE WHEN unit_price <= 0 OR unit_price > 10000 THEN 1 ELSE 0 END) AS out_of_range
FROM sales_item;

-- NR-007: Discount cannot exceed unit price
SELECT 'NR-007' AS check_id, 'sales_item.discount_amount' AS column_checked,
       COUNT(*) AS violations
FROM sales_item
WHERE discount_amount < 0 OR discount_amount > (unit_price * quantity * 0.5);

-- NR-008: Tax amount reasonable range (0 to 35% of gross)
SELECT 'NR-008' AS check_id, 'sales_item.tax_amount' AS column_checked,
       COUNT(*) AS violations
FROM sales_item
WHERE tax_amount < 0 OR tax_amount > (unit_price * quantity * 0.35);

-- NR-009: No negative amounts in sales header
SELECT 'NR-009' AS check_id, 'sales_header negative amounts' AS column_checked,
       SUM(CASE WHEN gross_amount < 0 THEN 1 ELSE 0 END) AS negative_gross,
       SUM(CASE WHEN total_discount < 0 THEN 1 ELSE 0 END) AS negative_discount,
       SUM(CASE WHEN total_tax < 0 THEN 1 ELSE 0 END) AS negative_tax,
       SUM(CASE WHEN net_total < 0 THEN 1 ELSE 0 END) AS negative_net
FROM sales_header;

-- NR-010: Tax rate within expected bounds
SELECT 'NR-010' AS check_id, 'tax_master.tax_rate' AS column_checked,
       MIN(tax_rate) AS min_rate, MAX(tax_rate) AS max_rate,
       SUM(CASE WHEN tax_rate < 0 OR tax_rate > 0.35 THEN 1 ELSE 0 END) AS out_of_range
FROM tax_master;

-- NR-011: Customer DOB reasonable range
SELECT 'NR-011' AS check_id, 'customer_master.date_of_birth' AS column_checked,
       MIN(date_of_birth) AS earliest_dob, MAX(date_of_birth) AS latest_dob,
       SUM(CASE WHEN date_of_birth < '1940-01-01' OR date_of_birth > '2008-12-31' THEN 1 ELSE 0 END) AS out_of_range
FROM customer_master;
```

---

## 6. CROSS-TABLE CONSISTENCY CHECKS

```sql
-- CC-001: Currency-country alignment in sales
SELECT 'CC-001' AS check_id,
       'Sales currency matches country currency' AS description,
       COUNT(*) AS mismatches
FROM sales_header sh
JOIN country_master cm ON sh.country_code = cm.country_code
WHERE sh.currency != cm.currency_code;

-- CC-002: POS transactions must have store_id; ONLINE must not
SELECT 'CC-002' AS check_id,
       'Channel-store_id consistency' AS description,
       SUM(CASE WHEN channel_id = 'POS' AND (store_id IS NULL OR store_id = '') THEN 1 ELSE 0 END) AS pos_without_store,
       SUM(CASE WHEN channel_id = 'ONLINE' AND store_id IS NOT NULL AND store_id != '' THEN 1 ELSE 0 END) AS online_with_store
FROM sales_header;

-- CC-003: Store country matches transaction country for POS
SELECT 'CC-003' AS check_id,
       'Store country = transaction country for POS' AS description,
       COUNT(*) AS mismatches
FROM sales_header sh
JOIN store_master sm ON sh.store_id = sm.store_code
WHERE sh.channel_id = 'POS'
  AND sh.country_code != sm.country_code;

-- CC-004: Sales item category matches SKU's category via hierarchy
SELECT 'CC-004' AS check_id,
       'Item category matches SKU hierarchy category' AS description,
       COUNT(*) AS mismatches
FROM sales_item si
JOIN product_sku_master ps ON si.sku_code = ps.sku_code
JOIN product_model_master pm ON ps.model_code = pm.model_code
JOIN product_family_master pf ON pm.family_code = pf.family_code
WHERE si.category_code != pf.category_code;

-- CC-005: Header and item row count match
SELECT 'CC-005' AS check_id,
       'Header-item count match' AS description,
       (SELECT COUNT(*) FROM sales_header) AS header_count,
       (SELECT COUNT(*) FROM sales_item) AS item_count,
       (SELECT COUNT(*) FROM sales_header) - (SELECT COUNT(*) FROM sales_item) AS difference;

-- CC-006: Customer registration before first transaction
SELECT 'CC-006' AS check_id,
       'Customer registered before first purchase' AS description,
       COUNT(*) AS violations
FROM (
    SELECT cm.customer_id, cm.registration_date, MIN(sh.transaction_timestamp) AS first_txn
    FROM customer_master cm
    JOIN sales_header sh ON cm.customer_id = sh.customer_id
    GROUP BY cm.customer_id, cm.registration_date
    HAVING cm.registration_date > MIN(sh.transaction_timestamp)::DATE
);
```

---

## 7. TEMPORAL / BUSINESS RULE CHECKS

```sql
-- TR-001: SCD2 date validity (end_date >= start_date)
SELECT 'TR-001' AS check_id, table_name, COUNT(*) AS violations
FROM (
    SELECT 'region_master' AS table_name FROM region_master WHERE effective_end_date < effective_start_date
    UNION ALL
    SELECT 'country_master' FROM country_master WHERE effective_end_date < effective_start_date
    UNION ALL
    SELECT 'currency_master' FROM currency_master WHERE effective_end_date < effective_start_date
    UNION ALL
    SELECT 'tax_master' FROM tax_master WHERE effective_end_date < effective_start_date
    UNION ALL
    SELECT 'product_category_master' FROM product_category_master WHERE effective_end_date < effective_start_date
    UNION ALL
    SELECT 'store_master' FROM store_master WHERE effective_end_date < effective_start_date
)
GROUP BY table_name;

-- TR-002: Customer registration_date within acquisition_year
SELECT 'TR-002' AS check_id,
       'registration_date matches acquisition_year' AS description,
       COUNT(*) AS violations
FROM customer_master
WHERE EXTRACT(YEAR FROM registration_date) != acquisition_year;

-- TR-003: No sales before store opening
SELECT 'TR-003' AS check_id,
       'No POS sales before store opens' AS description,
       COUNT(*) AS violations
FROM sales_header sh
JOIN store_master sm ON sh.store_id = sm.store_code
WHERE sh.channel_id = 'POS'
  AND sh.transaction_timestamp::DATE < sm.store_open_date;

-- TR-004: No Vision Pro sales before launch (2024-02-02)
SELECT 'TR-004' AS check_id,
       'No VPR transactions before 2024-02-02' AS description,
       COUNT(*) AS violations
FROM sales_item si
JOIN sales_header sh ON si.transaction_sk = sh.transaction_sk
WHERE si.category_code = 'VPR'
  AND sh.transaction_timestamp < '2024-02-02';

-- TR-005: Sales amount formula validation
-- net_total = gross_amount - total_discount + total_tax
SELECT 'TR-005' AS check_id,
       'Amount formula: net_total = gross - discount + tax' AS description,
       COUNT(*) AS violations
FROM sales_header
WHERE ABS(net_total - (gross_amount - total_discount + total_tax)) > 0.01;

-- TR-006: Line total formula validation
-- line_total = (quantity * unit_price) - discount_amount + tax_amount
SELECT 'TR-006' AS check_id,
       'Line formula: line_total = qty*price - discount + tax' AS description,
       COUNT(*) AS violations
FROM sales_item
WHERE ABS(line_total - ((quantity * unit_price) - discount_amount + tax_amount)) > 0.01;

-- TR-007: Header total = sum of line items for that transaction
SELECT 'TR-007' AS check_id,
       'Header net_total = sum of item line_totals' AS description,
       COUNT(*) AS violations
FROM sales_header sh
JOIN (
    SELECT transaction_sk, SUM(line_total) AS item_total
    FROM sales_item
    GROUP BY transaction_sk
) si ON sh.transaction_sk = si.transaction_sk
WHERE ABS(sh.net_total - si.item_total) > 0.01;

-- TR-008: Product SKU launch date before any sale of that SKU
SELECT 'TR-008' AS check_id,
       'SKU not sold before its launch date' AS description,
       COUNT(*) AS violations
FROM sales_item si
JOIN sales_header sh ON si.transaction_sk = sh.transaction_sk
JOIN product_sku_master ps ON si.sku_code = ps.sku_code
WHERE sh.transaction_timestamp::DATE < ps.global_launch_date;
```

---

## 8. STATISTICAL DISTRIBUTION CHECKS

```sql
-- SD-001: Country distribution in sales (US should be 27-30%)
SELECT 'SD-001' AS check_id,
       country_code,
       COUNT(*) AS txn_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM sales_header
GROUP BY country_code
ORDER BY txn_count DESC;

-- SD-002: Channel split (POS should be 75-85%)
SELECT 'SD-002' AS check_id,
       channel_id,
       COUNT(*) AS txn_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM sales_header
GROUP BY channel_id;

-- SD-003: Product category distribution in sales items
SELECT 'SD-003' AS check_id,
       category_code,
       COUNT(*) AS item_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM sales_item
GROUP BY category_code
ORDER BY item_count DESC;

-- SD-004: Customer segment distribution
SELECT 'SD-004' AS check_id,
       customer_segment,
       COUNT(*) AS cust_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM customer_master
GROUP BY customer_segment;

-- SD-005: Loyalty tier distribution
SELECT 'SD-005' AS check_id,
       loyalty_tier,
       COUNT(*) AS cust_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM customer_master
GROUP BY loyalty_tier;

-- SD-006: Store format distribution
SELECT 'SD-006' AS check_id,
       format_code,
       COUNT(*) AS store_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM store_master
GROUP BY format_code;

-- SD-007: Payment method distribution
SELECT 'SD-007' AS check_id,
       payment_method,
       COUNT(*) AS txn_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct
FROM sales_header
GROUP BY payment_method
ORDER BY txn_count DESC;

-- SD-008: Year-over-year transaction growth
SELECT 'SD-008' AS check_id,
       EXTRACT(YEAR FROM transaction_timestamp) AS txn_year,
       COUNT(*) AS txn_count,
       LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM transaction_timestamp)) AS prev_year_count,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM transaction_timestamp))) * 100.0
             / NULLIF(LAG(COUNT(*)) OVER (ORDER BY EXTRACT(YEAR FROM transaction_timestamp)), 0), 2) AS yoy_growth_pct
FROM sales_header
GROUP BY EXTRACT(YEAR FROM transaction_timestamp)
ORDER BY txn_year;

-- SD-009: Year-over-year customer growth
SELECT 'SD-009' AS check_id,
       acquisition_year,
       COUNT(*) AS new_customers,
       LAG(COUNT(*)) OVER (ORDER BY acquisition_year) AS prev_year,
       ROUND((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY acquisition_year)) * 100.0
             / NULLIF(LAG(COUNT(*)) OVER (ORDER BY acquisition_year), 0), 2) AS yoy_growth_pct
FROM customer_master
WHERE customer_type = 'NEW'
GROUP BY acquisition_year
ORDER BY acquisition_year;
```

---

## 9. ROW COUNT VALIDATION (Post-Load Expected Counts)

```sql
-- Expected row counts for validation after loading
SELECT 'ROW_COUNT' AS check_type, table_name, actual_count, expected_count,
       CASE WHEN actual_count = expected_count THEN 'PASS' ELSE 'FAIL' END AS status
FROM (
    SELECT 'region_master' AS table_name, (SELECT COUNT(*) FROM region_master) AS actual_count, 5 AS expected_count
    UNION ALL SELECT 'country_master', (SELECT COUNT(*) FROM country_master), 35
    UNION ALL SELECT 'currency_master', (SELECT COUNT(*) FROM currency_master), 27
    UNION ALL SELECT 'tax_master', (SELECT COUNT(*) FROM tax_master), 35
    UNION ALL SELECT 'product_category_master', (SELECT COUNT(*) FROM product_category_master), 10
    UNION ALL SELECT 'product_family_master', (SELECT COUNT(*) FROM product_family_master), 44
    UNION ALL SELECT 'product_model_master', (SELECT COUNT(*) FROM product_model_master), 112
    UNION ALL SELECT 'product_sku_master', (SELECT COUNT(*) FROM product_sku_master), 651
    UNION ALL SELECT 'store_master', (SELECT COUNT(*) FROM store_master), 127
    UNION ALL SELECT 'sales_header', (SELECT COUNT(*) FROM sales_header), 621546
    UNION ALL SELECT 'sales_item', (SELECT COUNT(*) FROM sales_item), 621546
);
```

---

## 10. COMPREHENSIVE DATA QUALITY SUMMARY QUERY

```sql
-- Single query to run all critical checks and produce a pass/fail dashboard
WITH checks AS (
    SELECT 'PK: region_master' AS check_name,
           CASE WHEN COUNT(*) = COUNT(DISTINCT region_code) THEN 'PASS' ELSE 'FAIL' END AS status
    FROM region_master
    UNION ALL
    SELECT 'PK: country_master',
           CASE WHEN COUNT(*) = COUNT(DISTINCT country_code) THEN 'PASS' ELSE 'FAIL' END
    FROM country_master
    UNION ALL
    SELECT 'PK: sales_header',
           CASE WHEN COUNT(*) = COUNT(DISTINCT transaction_sk) THEN 'PASS' ELSE 'FAIL' END
    FROM sales_header
    UNION ALL
    SELECT 'RI: family->category',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
    FROM product_family_master f LEFT JOIN product_category_master c ON f.category_code = c.category_code WHERE c.category_code IS NULL
    UNION ALL
    SELECT 'RI: header->customer',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
    FROM sales_header sh LEFT JOIN customer_master cm ON sh.customer_id = cm.customer_id WHERE cm.customer_id IS NULL
    UNION ALL
    SELECT 'TR: amount formula',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
    FROM sales_header WHERE ABS(net_total - (gross_amount - total_discount + total_tax)) > 0.01
    UNION ALL
    SELECT 'TR: VPR before launch',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'KNOWN FAIL' END
    FROM sales_item si JOIN sales_header sh ON si.transaction_sk = sh.transaction_sk
    WHERE si.category_code = 'VPR' AND sh.transaction_timestamp < '2024-02-02'
    UNION ALL
    SELECT 'CC: channel-store consistency',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
    FROM sales_header WHERE (channel_id = 'POS' AND (store_id IS NULL OR store_id = ''))
                         OR (channel_id = 'ONLINE' AND store_id IS NOT NULL AND store_id != '')
)
SELECT check_name, status
FROM checks
ORDER BY status DESC, check_name;
```

---

*End of Document*
