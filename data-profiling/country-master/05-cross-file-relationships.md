# Country Master - Cross-File Relationship and Summary

## Entity Relationship Diagram

```
+------------------+
|  region_master   |
|  (5 rows)        |
|  PK: region_code |
+--------+---------+
         | 1:M
         v
+----------------------------------------------------------+
|                    country_master                          |
|                    (35 rows)                               |
|  PK: country_code                                         |
|  FK: region_code -> region_master                         |
|  FK: currency_code -> currency_master                     |
|  FK: tax_code -> tax_master                               |
+------------+-----------------------------+----------------+
             | M:1                         | 1:1
             v                             v
+--------------------+         +--------------------+
|  currency_master   |         |    tax_master      |
|  (27 rows)         |         |    (35 rows)       |
|  PK: currency_code |         |  PK: tax_code      |
+--------------------+         +--------------------+
```

## Referential Integrity Summary

| Relationship | Parent Table | Child Table | Cardinality | Orphan Records | Status |
|-------------|--------------|-------------|-------------|----------------|--------|
| region to country | region_master | country_master | 1:M | 0 | PASS |
| currency to country | currency_master | country_master | 1:M | 0 | PASS |
| tax to country | tax_master | country_master | 1:1 | 0 | PASS |

## Cross-File Consistency

| Check | Result | Details |
|-------|--------|---------|
| All country.region_code values exist in region_master | PASS | 5/5 regions referenced |
| All country.currency_code values exist in currency_master | PASS | 27/27 currencies referenced |
| All country.tax_code values exist in tax_master | PASS | 35/35 tax codes referenced |
| Unused region records | NONE | All 5 regions have at least 1 country |
| Unused currency records | NONE | All 27 currencies are referenced by at least 1 country |
| Unused tax records | NONE | All 35 tax codes are referenced exactly once |

## Source System Mapping

| Source System | Tables | Description |
|---------------|--------|-------------|
| MDM_CORE | region_master, country_master | Master Data Management system |
| TREASURY_SYS | currency_master | Treasury/Finance system |
| TAX_ENGINE | tax_master | Tax calculation engine |

## Common Design Patterns

All four tables share these design conventions:

1. **SCD Type 2**: effective_start_date + effective_end_date columns for temporal versioning
2. **Audit columns**: is_active, created_at, source_system on every table
3. **Open end date**: 9999-12-31 indicates currently active records
4. **No historical records**: Initial load contains only current-state data (no expired rows)
5. **Business keys as PK**: Natural keys used (not surrogate integers)

## File Inventory

| # | File | Rows | Columns | PK | Source |
|---|------|------|---------|----|--------|
| 1 | region_master.csv | 5 | 7 | region_code | MDM_CORE |
| 2 | country_master.csv | 35 | 20 | country_code | MDM_CORE |
| 3 | currency_master.csv | 27 | 9 | currency_code | TREASURY_SYS |
| 4 | tax_master.csv | 35 | 9 | tax_code | TAX_ENGINE |

## Key Business Insights

- **35 markets** across **5 regions** with **27 currencies** and **35 tax configurations**
- EUR is the most shared currency (9 countries)
- Tier1 markets (14) represent high-revenue countries; Tier2 (21) are secondary markets
- 14 countries are GDPR-applicable (all European)
- All 35 markets support e-commerce; only 23 have physical retail stores
- Tax rates range from 0% (Hong Kong) to 25.5% (Finland)
- US is the only market with tax-exclusive pricing (added at checkout)
