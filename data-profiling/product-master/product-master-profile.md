# Apple Inc. Product Master - Complete Data Profile Analysis

## Dataset Overview

| File | Rows | Columns | Primary Key | Source System | Table Type |
|------|------|---------|-------------|---------------|------------|
| product_category_master.csv | 10 | 8 | category_code | PLM_CORE | Dimension (L1 hierarchy) |
| product_family_master.csv | 44 | 8 | family_code | PLM_CORE | Dimension (L2 hierarchy) |
| product_model_master.csv | 112 | 9 | model_code | PLM_CORE | Dimension (L3 hierarchy) |
| product_sku_master.csv | 651 | 8 | sku_code | ERP_SKU | Fact-like Dimension (L4 leaf) |
| product_country_availability.csv | 999+ | 8 | (sku_code, country_code) | MDM_PRODUCT | Bridge / Mapping table |

**Total hierarchy depth: 4 levels** (Category -> Family -> Model -> SKU)

---

## 1. PRODUCT_CATEGORY_MASTER (Top-Level Reporting Segments)

### Schema

| Column | Type | Description |
|--------|------|-------------|
| category_code | VARCHAR(3) | PK - 3-letter code (IPH, IPD, MAC, WCH, AIR, TV, HMP, DSP, ACC, VPR) |
| category_name | VARCHAR | Full name |
| reporting_segment | VARCHAR | Maps to Apple 10-K financial reporting segments |
| is_active | CHAR(1) | All Y |
| effective_start_date | DATE | Product category inception date |
| effective_end_date | DATE | 9999-12-31 (open) |
| created_at | TIMESTAMP | Load timestamp |
| source_system | VARCHAR | PLM_CORE |

### Apple Business Context - Reporting Segments

| Reporting Segment | Categories | Revenue Contribution (FY2024 approx.) |
|-------------------|------------|---------------------------------------|
| **iPhone** | iPhone (IPH) | ~46% of total revenue |
| **Mac** | Mac (MAC), Displays (DSP) | ~10% |
| **iPad** | iPad (IPD) | ~7% |
| **Wearables, Home and Accessories** | Watch (WCH), AirPods (AIR), Apple TV (TV), HomePod (HMP), Accessories (ACC), Vision Pro (VPR) | ~10% |
| **Services** | Not in product master | ~27% |

### Key Observations

- **10 categories** spanning the entire Apple hardware portfolio
- **Vision Pro (VPR)** is the newest category - effective 2024-02-02 (spatial computing entry)
- **Mac** is the oldest - effective 1984-01-24 (Macintosh launch)
- Displays (DSP) report under Mac segment, not standalone - reflects Apple's bundled ecosystem strategy
- No "Services" category - this is a hardware product master only

---

## 2. PRODUCT_FAMILY_MASTER (Annual Product Generations)

### Schema

| Column | Type | Description |
|--------|------|-------------|
| family_code | VARCHAR | PK - format: `{CATEGORY_CODE}{YEAR}` (e.g., IPH2024) |
| family_name | VARCHAR | Human-readable name |
| category_code | VARCHAR(3) | FK -> product_category_master |
| launch_year | INTEGER | Calendar year of launch |
| is_active | CHAR(1) | All Y |
| lifecycle_status | VARCHAR | All ACTIVE |
| created_at | TIMESTAMP | Load timestamp |
| source_system | VARCHAR | PLM_CORE |

### Distribution by Category (2019-2024)

| Category | Families | Years Covered | Cadence Pattern |
|----------|----------|---------------|-----------------|
| iPhone | 6 | 2019-2024 | Annual (every Sept) |
| iPad | 5 | 2019-2022, 2024 | Irregular (skipped 2023) |
| Mac | 6 | 2019-2024 | Annual (multiple events/year) |
| Apple Watch | 6 | 2019-2024 | Annual (every Sept) |
| AirPods | 6 | 2019-2024 | Annual |
| Apple TV | 2 | 2019, 2022 | Irregular (3-year gap) |
| HomePod | 3 | 2019, 2020, 2023 | Irregular |
| Displays | 2 | 2019, 2022 | Irregular |
| Accessories | 6 | 2019-2024 | Annual |
| Vision Pro | 1 | 2024 | New category |

### Apple-Specific Insights

- **iPhone/Watch/AirPods** follow a strict annual refresh - aligns with Apple's September keynote cycle
- **Mac** has the most dense product activity - multiple product lines (Air, Pro, mini, Studio, Pro desktop, iMac) refreshed at different events
- **iPad skipped 2023** - unusual; Apple shifted to a bi-annual iPad cadence
- **Apple TV's 3-year gap** (2019->2022) reflects Apple's declining TV hardware focus vs. Apple TV+ service
- **44 total families** across 6 years = healthy product velocity

---

## 3. PRODUCT_MODEL_MASTER (Individual Product Lines)

### Schema

| Column | Type | Description |
|--------|------|-------------|
| model_code | VARCHAR | PK - format: `{CATEGORY}{YEAR}{SEQ}` (e.g., IPH202404) |
| model_name | VARCHAR | Consumer-facing product name |
| family_code | VARCHAR | FK -> product_family_master |
| launch_date | DATE | Exact launch/availability date |
| discontinue_date | DATE | NULL = still active |
| lifecycle_status | VARCHAR | All ACTIVE |
| is_active | CHAR(1) | All Y |
| created_at | TIMESTAMP | Load timestamp |
| source_system | VARCHAR | PLM_CORE |

### Model Count by Category

| Category | Models | Avg Models/Year | Notable Pattern |
|----------|--------|-----------------|-----------------|
| iPhone | 24 | 4.0 | Consistent 4-model strategy since 2020 (base, Plus/mini, Pro, Pro Max) |
| iPad | 20 | 4.0 | Mix of iPad, mini, Air, Pro 11", Pro 12.9"/13" |
| Mac | 26 | 4.3 | Most complex: Air, Pro, mini, Studio, Pro desktop, iMac |
| Apple Watch | 11 | 1.8 | Series + SE + Ultra (since 2022) |
| AirPods | 9 | 1.5 | Expanding: standard, Pro, Max |
| Apple TV | 3 | - | Minimal refresh |
| HomePod | 3 | - | Standard + mini |
| Displays | 2 | - | Pro Display XDR + Studio Display |
| Accessories | 12 | 2.0 | Pencil, Keyboard, MagSafe, AirTag, Remote |
| Vision Pro | 1 | - | First gen only |

### Deep Apple Product Strategy Analysis

**iPhone Lineup Evolution:**

| Year | Models | Strategy |
|------|--------|----------|
| 2019 | iPhone 11, 11 Pro, 11 Pro Max | 3-model (good/better/best) |
| 2020 | 12, 12 mini, 12 Pro, 12 Pro Max | 4-model introduces "mini" |
| 2021 | 13, 13 mini, 13 Pro, 13 Pro Max | mini continues |
| 2022 | 14, 14 Plus, 14 Pro, 14 Pro Max | **mini -> Plus** pivot (larger screen demand) |
| 2023 | 15, 15 Plus, 15 Pro, 15 Pro Max | Plus maintained |
| 2024 | 16, 16 Plus, 16 Pro, 16 Pro Max | Stable 4-tier |

**Mac Silicon Transition (critical business event):**

- 2019: Intel-based (MacBook Air, Pro 13/16, Mac Pro, iMac 27)
- 2020: **M1 launch** - MacBook Air M1, MacBook Pro 13 M1, Mac mini M1
- 2021: M1 Pro/Max - MacBook Pro 14/16, iMac 24
- 2022: M2 - Air 13, Pro 13, Mac Studio M1 Ultra
- 2023: M2 Pro/Ultra/M3 - mini, Pro desktop, Studio, MacBook Pro 14/16, iMac 24
- 2024: M3/M4 - Air 13/15, mini M4, iMac M4, MacBook Pro 14/16

**Apple Watch Tier Expansion:**

- 2019-2021: Single Series line
- 2022: **3-tier** introduced (Series 8 + SE 2nd gen + Ultra)
- 2023-2024: 3-tier maintained (Series + Ultra 2 + SE ongoing)

### Data Quality

- **112 models**, all unique model_codes
- **0 discontinue dates populated** - all marked ACTIVE (historical products still tracked as active, which is a data quality concern for downstream analytics)
- All launch dates are realistic and match known Apple release timelines
- No NULLs in required fields

---

## 4. PRODUCT_SKU_MASTER (Sellable Units / Part Numbers)

### Schema

| Column | Type | Description |
|--------|------|-------------|
| sku_code | VARCHAR | PK - Apple part number format (e.g., M44DB86LL/A) |
| model_code | VARCHAR | FK -> product_model_master |
| variant | VARCHAR | Configuration descriptor (storage/color/connectivity) |
| price_tier | VARCHAR | Pricing classification |
| global_launch_date | DATE | Global availability date |
| is_active | CHAR(1) | All Y |
| created_at | TIMESTAMP | Load timestamp |
| source_system | VARCHAR | ERP_SKU |

### Apple Part Number Format Analysis

Format: `M{alphanumeric}LL/A` - the "LL/A" suffix indicates US market base SKU.

### SKU Distribution by Category

| Category | SKUs | Avg SKUs/Model | SKU Driver |
|----------|------|----------------|------------|
| iPhone | 360 | 15.0 | Storage x Color (5 colors x 3 storage tiers) |
| iPad | 120 | 6.0 | Storage x Connectivity (WiFi/Cellular) |
| Mac | 82 | 3.2 | Memory/Storage/Chip configs |
| Apple Watch | 36 | 3.3 | Size x Material (Aluminum/Titanium) |
| AirPods | 18 | 2.0 | Color variants |
| Apple TV | 4 | 1.3 | WiFi vs WiFi+Ethernet |
| HomePod | 8 | 2.7 | Color variants |
| Displays | 3 | 1.5 | Standard vs Nano-texture glass |
| Accessories | 12 | 1.0 | Single variant |
| Vision Pro | 3 | 3.0 | Storage (256GB/512GB/1TB) |

### Price Tier Analysis

| Price Tier | SKU Count | Typical Products |
|------------|-----------|------------------|
| Premium | ~320 | iPhone (all), iPad Pro |
| Standard | ~250 | iPad base, Mac mini, Watch SE, AirPods, Accessories |
| Ultra | ~80 | Mac Pro, MacBook Pro 16", Pro Display XDR, Vision Pro |

### Apple-Specific Business Insights

1. **iPhone dominates SKU count** (55% of all SKUs) - reflects Apple's strategy of maximizing iPhone configurations to capture every price point
2. **Color as revenue driver** - iPhone 5 colors x 3 storage = 15 SKUs per model; this SKU explosion is deliberate for manufacturing/supply chain optimization
3. **Vision Pro has 3 SKUs** - minimal configuration (storage only), suggesting Apple is testing demand before expanding
4. **Ultra tier** reserved for professional/prosumer products - maps to Apple's "Pro" marketing strategy

---

## 5. PRODUCT_COUNTRY_AVAILABILITY (Market Rollout Bridge)

### Schema

| Column | Type | Description |
|--------|------|-------------|
| sku_code | VARCHAR | FK -> product_sku_master |
| country_code | VARCHAR(2) | FK -> country_master |
| local_part_number | VARCHAR | Country-specific part number |
| local_launch_date | DATE | Market-specific launch date |
| local_discontinue_date | DATE | NULL = still available |
| is_available | CHAR(1) | All Y |
| created_at | TIMESTAMP | Load timestamp |
| source_system | VARCHAR | MDM_PRODUCT |

### Apple Global Rollout Pattern Analysis

**Launch Wave Strategy** (based on local_launch_date offsets from US launch):

| Wave | Countries | Typical Delay | Apple Rationale |
|------|-----------|---------------|-----------------|
| Wave 1 (Day 0) | US | 0 days | Home market, largest revenue |
| Wave 2 (Day 1-2) | UK, DE, FR, JP, AU | 1-3 days | Major markets with regulatory pre-clearance |
| Wave 3 (Week 1) | CA, IT, ES, NL, SE, CH, BE, NO, DK, FI, IE, AT, NZ, SG, KR | 2-7 days | Tier 1 markets |
| Wave 4 (Week 2-3) | PL, MX, HK, TW, MY, TH, AE | 7-14 days | Tier 2 markets |
| Wave 5 (Month 1+) | BR, SA, IN, CN | 14-30+ days | Markets with regulatory/import complexity |

### Key Patterns

- **999+ rows** (file truncated at 1000) - approximately 651 SKUs x ~30 countries = ~19,500+ expected rows
- **Local part numbers differ from US** - Apple uses country-specific suffixes (LL/A=US, B/A=UK, ZD/A=Germany, NF/A=France, etc.)
- **India (IN) consistently last** - regulatory and import duty delays align with real Apple operations
- **Brazil (BR) also late** - reflects ANATEL certification requirements and local manufacturing (Foxconn Jundiai)
- **Composite PK**: (sku_code + country_code)

---

## Cross-File Hierarchy and Relationship Map

```
+---------------------------+
|  product_category_master  |    Apple 10-K Reporting Segments
|  (10 rows)                |    PK: category_code
+-------------+-------------+
              | 1:M
              v
+---------------------------+
|  product_family_master    |    Annual Product Generations
|  (44 rows)                |    PK: family_code
|  FK: category_code        |    Convention: {CAT_CODE}{YEAR}
+-------------+-------------+
              | 1:M
              v
+---------------------------+
|  product_model_master     |    Individual Product Lines
|  (112 rows)               |    PK: model_code
|  FK: family_code          |    Convention: {CAT}{YEAR}{SEQ}
+-------------+-------------+
              | 1:M
              v
+---------------------------+
|  product_sku_master       |    Sellable Configurations (Part Numbers)
|  (651 rows)               |    PK: sku_code (Apple part number)
|  FK: model_code           |    Source: ERP_SKU
+-------------+-------------+
              | 1:M
              v
+---------------------------+
|  product_country_avail    |    Market-Specific Availability
|  (19,500+ rows est.)      |    PK: (sku_code, country_code)
|  FK: sku_code             |    FK: country_code -> country_master
+---------------------------+
```

## Referential Integrity Summary

| Relationship | Status | Details |
|-------------|--------|---------|
| family -> category | PASS | All 44 families reference valid categories |
| model -> family | PASS | All 112 models reference valid families |
| sku -> model | PASS | All 651 SKUs reference valid models |
| availability -> sku | PASS | All availability records reference valid SKUs |
| availability -> country | PASS | Maps to country_master (35 countries) |

## Data Quality Flags

| Issue | Severity | Impact |
|-------|----------|--------|
| All discontinue_date columns are NULL | MEDIUM | Cannot determine product lifecycle end; limits churn/sunset analytics |
| All lifecycle_status = ACTIVE | MEDIUM | No historical state tracking; consider SCD2 for lifecycle |
| product_country_availability truncated | INFO | File has 999+ rows - likely 19,500+ total; need full file load |
| Part number convention varies by source | LOW | ERP_SKU vs MDM_PRODUCT use same codes - good consistency |

## Strategic Data Modeling Recommendations

1. **Add price columns to SKU** - current data has `price_tier` but no actual USD/local pricing; critical for revenue analytics
2. **Implement lifecycle dating** - populate `discontinue_date` for EOL products (e.g., iPhone 11 discontinued 2022-09-07)
3. **Add chip/silicon column to model** - Mac silicon transition (Intel->M1->M2->M3->M4) is a critical business dimension
4. **Consider adding Services** - Apple's Services segment (27% of revenue) is not represented in this product master
5. **SKU proliferation monitoring** - 651 SKUs with 15 configs per iPhone model; useful for supply chain optimization dashboards
