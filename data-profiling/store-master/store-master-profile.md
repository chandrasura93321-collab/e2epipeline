# Apple Inc. Store Master - Complete Data Profile Analysis

## Overview

| Attribute | Value |
|-----------|-------|
| **Source File** | `__initial_load/store-master/store_master.csv` |
| **Rows** | 127 |
| **Columns** | 22 |
| **Primary Key** | `store_code` |
| **Source System** | RETAIL_OPS |
| **Table Type** | Dimension / Master Data |

---

## Schema Definition

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | store_code | VARCHAR | NO | PK - Format: `{COUNTRY_CODE}_{SEQ}` (e.g., US_0001) |
| 2 | store_name | VARCHAR | NO | Consumer-facing store name (e.g., "Apple Bradleyton") |
| 3 | country_code | VARCHAR(2) | NO | FK -> country_master |
| 4 | region_code | VARCHAR | NO | FK -> region_master |
| 5 | tax_jurisdiction_code | VARCHAR | NO | FK -> tax_master (state/province level) |
| 6 | format_code | VARCHAR | NO | Store format classification (FLG, MINI, MALL) |
| 7 | city | VARCHAR | NO | City name (localized) |
| 8 | state_code | VARCHAR | YES | State/Province code (NULL for countries without states) |
| 9 | postal_code | VARCHAR | NO | Local postal/zip code |
| 10 | address_line1 | VARCHAR | NO | Street address |
| 11 | latitude | DECIMAL | NO | GPS latitude |
| 12 | longitude | DECIMAL | NO | GPS longitude |
| 13 | store_open_date | DATE | NO | Store opening date |
| 14 | store_close_date | DATE | YES | Store closure date (NULL = currently open) |
| 15 | lifecycle_status | VARCHAR | NO | All ACTIVE |
| 16 | floor_area_sqft | INTEGER | NO | Retail floor area in square feet |
| 17 | annual_rent_usd | INTEGER | NO | Annual lease cost in USD |
| 18 | is_active | CHAR(1) | NO | All Y |
| 19 | effective_start_date | DATE | NO | SCD2 start date |
| 20 | effective_end_date | DATE | 9999-12-31 | SCD2 end date |
| 21 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 22 | source_system | VARCHAR | NO | RETAIL_OPS |

---

## Store Distribution by Country

| Country | Code | Region | Stores | % of Total | Real-World Apple Store Count (approx.) |
|---------|------|--------|--------|------------|----------------------------------------|
| United States | US | AMER | 50 | 39.4% | ~270 (scaled down) |
| China | CN | GREATER_CHINA | 10 | 7.9% | ~56 |
| United Kingdom | UK | EMEA | 8 | 6.3% | ~40 |
| Canada | CA | AMER | 6 | 4.7% | ~29 |
| Australia | AU | APAC | 6 | 4.7% | ~22 |
| France | FR | EMEA | 5 | 3.9% | ~20 |
| Germany | DE | EMEA | 4 | 3.1% | ~16 |
| Japan | JP | JAPAN | 4 | 3.1% | ~10 |
| South Korea | KR | APAC | 3 | 2.4% | ~7 |
| Italy | IT | EMEA | 3 | 2.4% | ~17 |
| Spain | ES | EMEA | 2 | 1.6% | ~11 |
| Taiwan | TW | GREATER_CHINA | 2 | 1.6% | ~2 |
| Hong Kong | HK | GREATER_CHINA | 2 | 1.6% | ~6 |
| Netherlands | NL | EMEA | 2 | 1.6% | ~3 |
| Sweden | SE | EMEA | 2 | 1.6% | ~3 |
| Switzerland | CH | EMEA | 2 | 1.6% | ~4 |
| Singapore | SG | APAC | 2 | 1.6% | ~3 |
| UAE | AE | APAC | 2 | 1.6% | ~4 |
| Austria | AT | EMEA | 1 | 0.8% | ~1 |
| Ireland | IE | EMEA | 1 | 0.8% | ~1 |
| Mexico | MX | AMER | 1 | 0.8% | ~2 |
| India | IN | APAC | 1 | 0.8% | ~2 |
| Brazil | BR | AMER | 1 | 0.8% | ~2 |
| Turkey | TR | EMEA | 1 | 0.8% | ~5 |

**Total: 24 countries, 127 stores**

---

## Store Distribution by Region

| Region | Stores | % | Interpretation |
|--------|--------|---|----------------|
| AMER | 58 | 45.7% | US-heavy; Americas dominance in Apple retail |
| EMEA | 31 | 24.4% | Europe-wide presence |
| GREATER_CHINA | 14 | 11.0% | China + Taiwan + Hong Kong |
| APAC | 14 | 11.0% | AU, SG, AE, IN, KR |
| JAPAN | 4 | 3.1% | Japan has its own Apple reporting segment |

---

## Store Format Analysis

### Format Code Definitions

| Format | Description | Count | % | Avg Floor Area (sqft) | Avg Annual Rent (USD) |
|--------|-------------|-------|---|----------------------|----------------------|
| FLG | Flagship | 47 | 37.0% | ~14,500 | ~$10.8M |
| MINI | Mini / Standard | 46 | 36.2% | ~15,200 | ~$10.5M |
| MALL | Mall-Based | 34 | 26.8% | ~14,100 | ~$9.9M |

### Apple Retail Context

- **Flagship (FLG)**: Apple's signature standalone stores - glass facades, high ceilings, premium locations (e.g., Apple Fifth Avenue NYC, Apple Regent Street London). Highest brand visibility.
- **MINI**: Smaller standalone or street-facing stores in secondary markets. Standard Apple retail experience at reduced scale.
- **MALL**: Shopping center locations. Lower capital investment, leveraging existing foot traffic. Apple has historically been migrating away from mall locations toward standalone flagship.

### Format Distribution by Country

| Country | FLG | MINI | MALL | Strategy Insight |
|---------|-----|------|------|------------------|
| US (50) | 20 | 14 | 16 | Balanced mix; shows US market maturity |
| CN (10) | 1 | 7 | 2 | Mini-dominant; rapid expansion in secondary Chinese cities |
| UK (8) | 1 | 5 | 2 | Mini-heavy; high street retail culture |
| CA (6) | 1 | 3 | 2 | Balanced |
| AU (6) | 1 | 3 | 2 | Mixed |
| FR (5) | 2 | 2 | 1 | Flagship-leaning; Paris flagship presence |
| DE (4) | 1 | 2 | 1 | Mixed |
| JP (4) | 2 | 2 | 0 | No mall stores; Japan favors standalone retail |

---

## Floor Area Analysis

| Metric | Value |
|--------|-------|
| **Minimum** | 5,205 sqft (AE_0002 Reidborough, UAE) |
| **Maximum** | 24,570 sqft (US_0019 Martinezburgh, FL) |
| **Average** | ~14,700 sqft |
| **Median** | ~14,500 sqft |

### Size Distribution

| Size Bracket | Count | % | Typical Format |
|-------------|-------|---|----------------|
| < 8,000 sqft | 18 | 14.2% | Smaller MINI/MALL stores in secondary markets |
| 8,000 - 15,000 sqft | 51 | 40.2% | Standard stores |
| 15,000 - 20,000 sqft | 37 | 29.1% | Large flagship/premium locations |
| > 20,000 sqft | 21 | 16.5% | Major flagships and regional anchor stores |

### Apple Context

- Apple's real-world stores average ~7,000-15,000 sqft for standard stores
- Flagship stores (Apple Fifth Avenue, Apple Park Visitor Center) can exceed 20,000 sqft
- The dataset ranges from 5,205 to 24,570 sqft — realistic for Apple's retail mix

---

## Annual Rent Analysis

| Metric | Value |
|--------|-------|
| **Minimum** | $660,419 (IE_0001 Karen Ville, Ireland) |
| **Maximum** | $19,405,046 (CN_0001, China) |
| **Average** | ~$10.2M |
| **Total Portfolio** | ~$1.3B annual rent |

### Rent by Region

| Region | Avg Annual Rent | Interpretation |
|--------|-----------------|----------------|
| GREATER_CHINA | ~$11.0M | Premium real estate in Chinese tier-1/2 cities |
| AMER | ~$10.6M | High US commercial real estate costs |
| EMEA | ~$9.8M | Moderate; mix of expensive (UK/CH) and affordable (IE/ES) |
| JAPAN | ~$9.5M | Tokyo-centric premium rents |
| APAC | ~$9.1M | Varied; Singapore/Australia expensive, India cheaper |

### Apple Context

- Apple typically occupies premium retail locations (high foot traffic, luxury adjacency)
- Real-world Apple Store rents range from $1M-$30M+ annually depending on market
- Fifth Avenue, NYC: ~$30M/year; Regent Street, London: ~$15M/year
- This dataset's range ($660K - $19.4M) is realistic for a global portfolio

---

## Store Opening Timeline

### Openings by Year

| Year | Stores Opened | Cumulative | Strategy Phase |
|------|---------------|------------|----------------|
| 2016 | 10 | 10 | Established market saturation |
| 2017 | 9 | 19 | Steady growth |
| 2018 | 10 | 29 | Continued expansion |
| 2019 | 14 | 43 | Peak expansion pre-COVID |
| 2020 | 6 | 49 | **COVID slowdown** |
| 2021 | 14 | 63 | Post-COVID recovery surge |
| 2022 | 16 | 79 | Aggressive expansion |
| 2023 | 9 | 88 | Normalization |
| 2024 | 10 | 98 | Steady state |
| 2025 | 14 | 112 | International push |
| 2026 | 15 | 127 | Continued growth (partial year) |

### Apple Retail Strategy Insights

1. **2020 COVID impact visible** — only 6 openings (Apple paused retail expansion during lockdowns)
2. **2021-2022 recovery** — 30 stores in 2 years; Apple accelerated post-pandemic
3. **India (2024)** — Apple opened its first India stores in 2023 (Mumbai, Delhi); this dataset shows 1 India store opened 2024
4. **No store closures** — all `store_close_date` values are NULL; all 127 stores currently active

---

## Tax Jurisdiction Analysis

### US Tax Jurisdictions (50 stores across 30 states)

| Pattern | Example | Count |
|---------|---------|-------|
| US_{STATE}_STD | US_FL_STD | 50 |

Top US states by store count:
- FL: 5 stores
- ND: 3 stores
- IN, NV, OH, MI, SC, WY: 2-3 stores each

### International Tax Codes

| Pattern | Markets | Notes |
|---------|---------|-------|
| {COUNTRY}_STD | UK, FR, IT, ES, KR, HK, TW, NL, SE, CH, SG, AE, AT, IE, MX, TR | Single national tax rate |
| {COUNTRY}_{STATE}_STD | US, CN, AU, CA, DE, JP, IN, BR | State/province-level taxation |

### Apple Context

- US sales tax varies by state (0% in OR, NH to 7.25%+ in CA, TN)
- This granularity is critical for Apple's point-of-sale tax calculation
- Apple's real-world systems must handle thousands of tax jurisdictions globally

---

## Geolocation Data Quality

### Coordinate Validation

| Check | Result | Details |
|-------|--------|---------|
| All latitudes in valid range (-90 to 90) | PASS | Min: -32.68 (AU), Max: 60.99 (SE) |
| All longitudes in valid range (-180 to 180) | PASS | Min: -126.18 (CA), Max: 143.79 (JP) |
| Country-coordinate alignment | **PARTIAL FAIL** | Some US stores have coordinates outside continental US bounds |

### Potential Coordinate Issues (US)

Several US stores show coordinates that don't align with their stated city/state:
- US_0001 (VA): lat 42.84 — this is MI/WI latitude, not Virginia
- US_0005 (ND): lon -123.74 — this is Pacific Ocean/Oregon longitude, not North Dakota
- US_0019 (FL): lat 28.13, lon -91.84 — Gulf of Mexico, not Florida mainland

**Assessment**: This is synthetic/randomized data — city names and coordinates are generated independently. This is fine for a demo dataset but would be a critical data quality issue in production (impacts store locator, geofencing, delivery routing).

---

## Foreign Key Relationships

| FK Column | References | Integrity | Notes |
|-----------|-----------|-----------|-------|
| country_code | country_master.country_code | PASS | All 24 countries exist in country_master (35 countries) |
| region_code | region_master.region_code | PASS | All 5 regions represented |
| tax_jurisdiction_code | tax_master.tax_code | PARTIAL | Store tax codes are state-level (US_FL_STD), tax_master has country-level (US_STD) — **granularity mismatch** |

### Tax Jurisdiction Gap

The `tax_master` file has 35 country-level tax codes (US_STD, UK_STD, etc.), but `store_master` uses state-level codes (US_FL_STD, US_CA_STD, CN_42_STD, etc.). This means:
- Either a supplementary state-level tax table exists that isn't in this dataset
- Or the FK relationship is intentionally denormalized for the store's local jurisdiction

---

## Data Quality Summary

| Check | Status | Details |
|-------|--------|---------|
| Primary key uniqueness | PASS | All 127 store_codes are unique |
| Completeness | PASS | No NULLs in required fields; state_code appropriately NULL for countries without states (UK, FR, IT, etc.) |
| store_close_date all NULL | INFO | No closed stores — all 127 currently active |
| Coordinate accuracy | WARN | Synthetic data — lat/lon don't match stated locations |
| Tax jurisdiction FK | WARN | State-level codes in store vs country-level in tax_master |
| Future open dates | INFO | 15 stores have open dates in 2025-2026 (planned openings) |
| Format code consistency | PASS | Only 3 valid values (FLG, MINI, MALL) — no typos |
| Naming convention | PASS | All store names follow "Apple {CityName}" pattern |

---

## Strategic Data Modeling Recommendations

1. **Add store performance metrics** — revenue, transactions, conversion rate, NPS; essential for retail analytics
2. **Create state-level tax junction table** — bridge the granularity gap between store_master (state-level) and tax_master (country-level)
3. **Add store tier/class** — Apple internally classifies stores (A/B/C tier) based on revenue potential; useful for resource allocation
4. **Implement SCD2 properly** — track store renovations, format changes (MALL -> FLG conversions happen frequently in Apple retail)
5. **Fix geolocation data** — critical for store locator, geo-analytics, cannibalization analysis
6. **Add headcount/staffing** — Genius Bar capacity, staff count; drives scheduling and CX analytics
7. **Track renovation dates** — Apple redesigns stores every 5-7 years ("Next Generation" store format); impacts capex planning
