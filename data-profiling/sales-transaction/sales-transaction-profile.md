# Apple Inc. Sales Transaction - Complete Data Profile Analysis

## Overview

| Attribute | Value |
|-----------|-------|
| **Source Folder** | `__initial_load/sales-transaction/` |
| **Partitioning** | Year (e.g., `2019/sales_header_2019.csv`) |
| **Years** | 2019 - 2025 (7 years) |
| **File Structure** | 2 files per year: `sales_header` + `sales_item` |
| **Total Files** | 14 (7 years x 2 files) |
| **Total Transactions** | 621,546 |
| **Total Line Items** | 621,546 (1:1 relationship) |
| **Source System** | SAP_SD (Sales & Distribution) |
| **Table Type** | Fact tables (transactional grain) |

---

## 1. SALES_HEADER (Transaction-Level Facts)

### Schema

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | transaction_sk | UUID | NO | PK / Surrogate key |
| 2 | transaction_id | VARCHAR | NO | Business key (TXN-{HEX12} format) |
| 3 | transaction_timestamp | TIMESTAMP | NO | Transaction date/time |
| 4 | customer_id | UUID | NO | FK -> customer_master.customer_id |
| 5 | store_id | VARCHAR | YES | FK -> store_master.store_code (NULL for ONLINE) |
| 6 | channel_id | VARCHAR | NO | Sales channel (POS / ONLINE) |
| 7 | country_code | VARCHAR(2) | NO | FK -> country_master.country_code |
| 8 | payment_method | VARCHAR | NO | Payment type |
| 9 | currency | VARCHAR(3) | NO | FK -> currency_master.currency_code |
| 10 | gross_amount | DECIMAL | NO | Pre-discount amount |
| 11 | total_discount | DECIMAL | NO | Discount applied (0.0 if none) |
| 12 | total_tax | DECIMAL | NO | Tax amount |
| 13 | net_total | DECIMAL | NO | Final amount (gross - discount + tax) |
| 14 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 15 | source_system | VARCHAR | NO | SAP_SD |

---

## 2. SALES_ITEM (Line-Item Level Facts)

### Schema

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | transaction_line_id | VARCHAR | NO | PK (LINE-{HEX12} format) |
| 2 | transaction_sk | UUID | NO | FK -> sales_header.transaction_sk |
| 3 | line_number | INTEGER | NO | Always 1 (single-item transactions) |
| 4 | sku_code | VARCHAR | NO | FK -> product_sku_master.sku_code |
| 5 | category_code | VARCHAR(3) | NO | FK -> product_category_master.category_code |
| 6 | quantity | INTEGER | NO | Units purchased (1 or 2) |
| 7 | unit_price | DECIMAL | NO | Price per unit (local currency) |
| 8 | discount_amount | DECIMAL | NO | Line-level discount |
| 9 | tax_amount | DECIMAL | NO | Line-level tax |
| 10 | line_total | DECIMAL | NO | Final line amount (qty * price - discount + tax) |
| 11 | created_at | TIMESTAMP | NO | Record creation timestamp |

---

## Transaction Volume by Year

| Year | Transactions | YoY Growth | Avg Daily Transactions |
|------|-------------|------------|------------------------|
| 2019 | 77,155 | - | 211 |
| 2020 | 81,146 | +5.2% | 222 |
| 2021 | 85,845 | +5.8% | 235 |
| 2022 | 91,079 | +6.1% | 249 |
| 2023 | 96,743 | +6.2% | 265 |
| 2024 | 102,656 | +6.1% | 281 |
| 2025 | 107,922 | +5.1% | 296 |

**Total: 621,546 transactions** with consistent ~5-6% annual growth.

### Apple Context

- Growth rate aligns with Apple's global revenue trajectory (~6% CAGR 2019-2024)
- The scale suggests this represents a subset/sample (Apple processes ~1B+ transactions annually in reality)
- 2020 growth despite COVID reflects Apple's digital channel strength

---

## Header-Item Relationship

| Check | Result | Implication |
|-------|--------|-------------|
| Header rows = Item rows | YES (every year) | **1:1 relationship** — single-item transactions only |
| line_number values | Always 1 | No multi-line orders in dataset |
| transaction_sk linkage | Item.transaction_sk -> Header.transaction_sk | Clean FK join |

### Business Implication

- Each transaction represents a **single product purchase**
- In reality, Apple retail transactions frequently include accessories (case + AirPods with iPhone)
- This simplifies analytics but means basket analysis / cross-sell metrics aren't available from this data alone
- Future enhancement: Add multi-item transactions to enable market basket analysis

---

## Channel Analysis

| Channel | Transactions | % | Store ID Pattern |
|---------|-------------|---|------------------|
| POS | 61,804 (2019) | 80.1% | Has store_id (e.g., SE_0001) |
| ONLINE | 15,351 (2019) | 19.9% | store_id is NULL/empty |

### Apple Context

- **80/20 POS/Online split** was realistic for Apple in 2019 (pre-COVID)
- Post-COVID (2020+), Apple's online share increased significantly (~30-35% by 2022)
- Apple.com is the company's single largest "store" by revenue
- POS = Apple Retail Stores + Authorized Resellers
- The dataset likely maintains the same ratio across years (check if online % grows)

---

## Country Distribution (2019)

| Country | Transactions | % | Alignment with Revenue |
|---------|-------------|---|------------------------|
| US | 22,146 | 28.7% | Apple's ~43% US revenue share (under-represented) |
| CN | 7,329 | 9.5% | ~19% real revenue (under-represented) |
| JP | 6,843 | 8.9% | ~8% (well-represented) |
| UK | 5,862 | 7.6% | ~6% (slightly over) |
| DE | 4,362 | 5.7% | ~5% (aligned) |
| FR | 3,709 | 4.8% | ~4% (aligned) |
| CA | 3,041 | 3.9% | ~3% (aligned) |
| IT | 2,242 | 2.9% | ~2% (aligned) |
| AU | 2,013 | 2.6% | ~2% (aligned) |
| Others (26) | 19,608 | 25.4% | Distributed across remaining markets |

**35 countries** represented — matches the country_master and customer_master footprint.

---

## Currency Analysis

| Currency | Transactions | Countries Using |
|----------|-------------|-----------------|
| USD | 22,146 | US |
| EUR | 14,572 | DE, FR, IT, ES, NL, BE, AT, IE, FI |
| CNY | 7,329 | CN |
| JPY | 6,843 | JP |
| GBP | 5,862 | UK |
| CAD | 3,041 | CA |
| AUD | 2,013 | AU |
| KRW | 1,718 | KR |
| INR | 1,488 | IN |
| TWD | 1,457 | TW |
| Others (17) | 11,686 | Remaining markets |

### Apple Context

- **EUR consolidation** — 9 Eurozone countries transact in EUR; this is correct
- **27 distinct currencies** — matches Apple's real-world multi-currency operations
- All amounts are in **local currency** — critical for FX conversion in reporting
- Missing: No FX rate columns; downstream pipeline needs to join with exchange rate data for USD-normalized reporting

---

## Payment Method Analysis

| Payment Method | Transactions | % | Apple Context |
|----------------|-------------|---|---------------|
| Cash | 8,712 | 11.3% | Still accepted at Apple Stores (declining) |
| Bank EMI | 8,704 | 11.3% | Installment plans (popular in India, Brazil) |
| Mastercard | 8,620 | 11.2% | Standard card payment |
| Apple Financing | 8,601 | 11.1% | Apple Card Monthly Installments / iPhone Upgrade Program |
| Corporate Financing | 8,572 | 11.1% | Apple Business financing / leasing |
| Apple Pay | 8,565 | 11.1% | Apple's digital wallet |
| Visa | 8,523 | 11.0% | Standard card payment |
| American Express | 8,510 | 11.0% | Premium card (aligns with Apple's affluent demographic) |
| Discover | 8,348 | 10.8% | US-focused card network |

### Distribution Insight

- **Nearly uniform distribution** (~11% each) — likely synthetic/randomized
- In reality, Apple Pay would be much higher (~30-40% at Apple Stores)
- Cash would be much lower (~2-3%)
- Regional variations expected: WeChat/Alipay dominant in China, UPI in India

### Apple-Specific Payment Methods

- **Apple Financing**: Maps to Apple Card Monthly Installments (0% APR for 24 months on iPhone)
- **Corporate Financing**: Apple Financial Services for enterprise hardware leasing
- **Bank EMI**: Interest-bearing installments through partner banks (Bajaj Finserv in India, etc.)

---

## Product Category Sales Distribution (2019)

| Category | Items Sold | % | Avg Unit Price Range | Apple Context |
|----------|-----------|---|---------------------|---------------|
| AirPods (AIR) | 23,334 | 30.2% | $140-250 | Volume leader; impulse/accessory purchase |
| iPhone (IPH) | 12,492 | 16.2% | $1,000-1,550 | Revenue leader; highest ASP |
| Apple TV (TV) | 10,612 | 13.8% | $150-180 | High volume; low ASP |
| HomePod (HMP) | 10,288 | 13.3% | $300-450 | Moderate volume |
| iPad (IPD) | 8,762 | 11.4% | $530-740 | Mid-range |
| Accessories (ACC) | 6,316 | 8.2% | $89-190 | Low ASP; attachment sales |
| Mac (MAC) | 3,617 | 4.7% | $1,500-3,100 | Low volume; highest ASP |
| Apple Watch (WCH) | 1,691 | 2.2% | Variable | Moderate ASP |
| Displays (DSP) | 37 | 0.05% | $1,500-5,000 | Ultra-niche; Pro segment only |
| Vision Pro (VPR) | 6 | 0.01% | $3,500+ | Just launched 2024 (6 sales in 2019 is a data anomaly) |

### Apple Revenue vs. Volume Insight

While **AirPods lead by unit volume** (30%), **iPhone leads by revenue** (estimated ~45% of total dollar value from 16% of transactions) due to its 5-10x higher ASP. This volume vs. revenue split is a classic Apple pattern:
- AirPods: High volume, low ASP = traffic driver
- iPhone: Moderate volume, high ASP = revenue engine
- Mac: Low volume, highest ASP = margin contributor

### Data Anomaly: Vision Pro in 2019

- Vision Pro launched February 2024, but 6 units appear in 2019 data
- This is a data generation artifact — flag for data quality

---

## Pricing Analysis (Local Currency)

### By Category (approximate ranges from 2019 sample)

| Category | Min Unit Price | Max Unit Price | Avg Unit Price |
|----------|---------------|----------------|----------------|
| ACC | ~$45 | ~$190 | ~$120 |
| AIR | ~$140 | ~$550 | ~$220 |
| TV | ~$130 | ~$200 | ~$160 |
| HMP | ~$100 | ~$450 | ~$350 |
| WCH | ~$250 | ~$800 | ~$450 |
| IPD | ~$330 | ~$1,200 | ~$680 |
| IPH | ~$700 | ~$1,600 | ~$1,200 |
| MAC | ~$1,000 | ~$6,000 | ~$2,500 |
| DSP | ~$1,600 | ~$5,000 | ~$3,000 |
| VPR | ~$3,500 | ~$4,000 | ~$3,500 |

### Discount Analysis

- **Most transactions have $0 discount** — aligns with Apple's minimal-discounting strategy
- Discounts present are small (5-10% range) — likely education pricing or trade-in credits
- Apple rarely offers percentage-off sales; discounts come via:
  - Trade-in value credits
  - Education pricing (fixed tier)
  - Employee purchase program
  - Back-to-school gift card promotions

### Tax Rate Analysis

- Tax consistently ~25% of gross amount — matches standard VAT/sales tax
- Formula: `net_total = gross_amount - total_discount + total_tax`
- Verified: Calculation is consistent across sampled records

---

## Quantity Distribution

| Quantity | Prevalence | Context |
|----------|-----------|---------|
| 1 | ~75% | Most Apple purchases are single-unit |
| 2 | ~25% | Bulk buy (e.g., 2 AirPods, family purchase) |

- Maximum quantity observed: 2
- No high-volume bulk purchases (those would go through Apple Business channel)
- Realistic for retail/consumer purchases

---

## Temporal Patterns (2019 Sample)

### Monthly Distribution

Based on transaction timestamps spanning Jan-Dec 2019:
- Transactions distributed across all 12 months
- Expected seasonality peaks: September (iPhone launch), November-December (holiday shopping)
- Q4 (Oct-Dec) likely has highest concentration — aligns with Apple's fiscal Q1 being their strongest quarter

---

## Foreign Key Relationships

| FK Column | References | Integrity |
|-----------|-----------|-----------|
| Header.customer_id | customer_master.customer_id | VERIFY — UUIDs should match |
| Header.store_id | store_master.store_code | PASS — NULL for ONLINE, valid codes for POS |
| Header.country_code | country_master.country_code | PASS — 35 countries match |
| Header.currency | currency_master.currency_code | PASS — 27 currencies match |
| Item.transaction_sk | sales_header.transaction_sk | PASS — 1:1 join confirmed |
| Item.sku_code | product_sku_master.sku_code | VERIFY — part numbers should match |
| Item.category_code | product_category_master.category_code | PASS — 10 categories match |

---

## Data Quality Summary

| Check | Status | Details |
|-------|--------|---------|
| PK uniqueness (transaction_sk) | PASS | UUID ensures uniqueness |
| Header-Item row count match | PASS | Identical counts every year |
| Store_id NULL for ONLINE | PASS | 100% correlation: ONLINE = empty store_id |
| Payment method cardinality | INFO | 9 distinct values; evenly distributed (likely synthetic) |
| Vision Pro in 2019 | FAIL | 6 VPR transactions in 2019; product didn't exist until 2024 |
| Currency-country alignment | PASS | Each country maps to correct local currency |
| Amount calculation | PASS | net_total = gross_amount - discount + tax (verified) |
| Negative amounts | PASS | No negative values found (no returns/refunds in dataset) |
| Multi-item transactions | INFO | None exist; all line_number = 1 (limits basket analysis) |

---

## Cross-File Relationship Map

```
+-------------------+          +-------------------+
|  customer_master  |          |   store_master    |
|  (274K records)   |          |   (127 stores)    |
+--------+----------+          +---------+---------+
         |                               |
         | customer_id                   | store_id
         v                               v
+--------------------------------------------------------+
|                   sales_header                          |
|                   (621,546 transactions)                |
|  PK: transaction_sk                                    |
|  FK: customer_id, store_id, country_code, currency     |
+--------------------------+-----------------------------+
                           |
                           | transaction_sk (1:1)
                           v
+---------------------------------------------------------+
|                    sales_item                            |
|                    (621,546 line items)                  |
|  PK: transaction_line_id                                |
|  FK: transaction_sk, sku_code, category_code            |
+-----------+---------------------+-----------------------+
            |                     |
            v                     v
+-------------------+    +---------------------------+
| product_sku_master|    | product_category_master   |
| (651 SKUs)        |    | (10 categories)           |
+-------------------+    +---------------------------+
```

---

## Strategic Data Modeling Recommendations

1. **Add returns/refunds table** — no negative transactions exist; returns are critical for net revenue reporting and product quality analytics
2. **Add multi-item transactions** — current 1:1 limits basket analysis, cross-sell/upsell measurement, and average items-per-transaction KPIs
3. **Add FX rate dimension** — all amounts in local currency; need daily exchange rates for consolidated USD reporting
4. **Add order_status** — no status column (COMPLETED, CANCELLED, RETURNED); important for fulfillment analytics
5. **Add shipping/fulfillment** — ONLINE orders need delivery tracking; POS orders may include in-store pickup vs. ship-to-home
6. **Add AppleCare attachment** — service plan attachment rates are a critical Apple KPI; currently not captured
7. **Add trade-in value** — Apple Trade In is a major discount mechanism; should be separated from generic discounts
8. **Implement slowly changing currency rates** — transaction amounts are point-in-time; need historical FX for accurate period-over-period comparison
9. **Fix VPR anomaly** — remove or reclassify the 6 Vision Pro transactions from 2019
10. **Add fiscal period mapping** — Apple's fiscal year starts October 1; need a fiscal calendar dimension for proper financial reporting alignment
