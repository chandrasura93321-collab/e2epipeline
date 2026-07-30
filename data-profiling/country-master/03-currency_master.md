# Data Profile: currency_master.csv

## Overview

| Attribute | Value |
|-----------|-------|
| **Source File** | `__initial_load/country-master/currency_master.csv` |
| **Rows** | 27 |
| **Columns** | 9 |
| **Primary Key** | `currency_code` |
| **Source System** | TREASURY_SYS |
| **Table Type** | Reference / Lookup |

## Schema Definition

| # | Column | Data Type | Nullable | Description |
|---|--------|-----------|----------|-------------|
| 1 | currency_code | VARCHAR(3) | NO | Primary key (ISO 4217 code) |
| 2 | currency_name | VARCHAR | NO | Full currency name |
| 3 | currency_symbol | VARCHAR | NO | Display symbol (e.g. $, €, £) |
| 4 | minor_unit | INTEGER | NO | Decimal places (0 or 2) |
| 5 | is_active | CHAR(1) | NO | Active flag (Y/N) |
| 6 | effective_start_date | DATE | NO | SCD2 validity start |
| 7 | effective_end_date | DATE | NO | SCD2 validity end |
| 8 | created_at | TIMESTAMP | NO | Record creation timestamp |
| 9 | source_system | VARCHAR | NO | Origin system identifier |

## Data Values

| currency_code | currency_name | symbol | minor_unit |
|---------------|---------------|--------|------------|
| USD | US Dollar | $ | 2 |
| JPY | Japanese Yen | ¥ | 0 |
| GBP | British Pound | £ | 2 |
| EUR | Euro | € | 2 |
| SEK | Swedish Krona | kr | 2 |
| CHF | Swiss Franc | CHF | 2 |
| NOK | Norwegian Krone | kr | 2 |
| DKK | Danish Krone | kr | 2 |
| CAD | Canadian Dollar | $ | 2 |
| NZD | New Zealand Dollar | $ | 2 |
| AUD | Australian Dollar | $ | 2 |
| CNY | Chinese Yuan | ¥ | 2 |
| HKD | Hong Kong Dollar | $ | 2 |
| INR | Indian Rupee | ₹ | 2 |
| TWD | Taiwan Dollar | $ | 2 |
| KRW | South Korean Won | ₩ | 0 |
| MXN | Mexican Peso | $ | 2 |
| PLN | Polish Zloty | zł | 2 |
| AED | UAE Dirham | د.إ | 2 |
| SAR | Saudi Riyal | ﷼ | 2 |
| BRL | Brazilian Real | R$ | 2 |
| TRY | Turkish Lira | ₺ | 2 |
| SGD | Singapore Dollar | $ | 2 |
| MYR | Malaysian Ringgit | RM | 2 |
| ILS | Israeli Shekel | ₪ | 2 |
| ZAR | South African Rand | R | 2 |
| THB | Thai Baht | ฿ | 2 |

## Column Profiling

### minor_unit Distribution

| Value | Count | Currencies |
|-------|-------|------------|
| 2 | 25 | All except JPY and KRW |
| 0 | 2 | JPY, KRW |

### Shared Symbols

| Symbol | Currencies |
|--------|------------|
| $ | USD, CAD, NZD, AUD, HKD, TWD, MXN, SGD |
| kr | SEK, NOK, DKK |
| ¥ | JPY, CNY |

## Data Quality Assessment

| Check | Result | Details |
|-------|--------|---------|
| Uniqueness (PK) | PASS | 27/27 unique currency_codes |
| Completeness | PASS | 0 NULLs across all columns |
| ISO 4217 Conformance | PASS | All codes are valid ISO 4217 |
| Minor Unit Accuracy | PASS | JPY(0), KRW(0) correct per standard |
| Active Records | 100% | All 27 records have is_active = 'Y' |
| Temporal Consistency | PASS | All records: start=2000-01-01, end=9999-12-31 |
| Source System | Uniform | All from TREASURY_SYS |

## Observations

1. **27 currencies** support 35 countries. EUR is shared across 9 European countries (DE, FR, NL, BE, FI, IE, AT, IT, ES).

2. **Zero-decimal currencies**: JPY and KRW correctly have `minor_unit = 0`. This is critical for pricing/payment calculations — amounts in these currencies should not display decimals.

3. **Symbol disambiguation**: The `$` symbol is used by 8 different currencies. Applications must display the currency code alongside the symbol for clarity (e.g. "A$" for AUD, "C$" for CAD).

4. **CHF uses text as symbol**: Swiss Franc has no unique glyph; "CHF" is used as both the code and symbol. This is standard practice.

5. All records share the same creation timestamp, confirming a single bulk load event.

## Downstream Dependencies

- Referenced by: `country_master.currency_code` (M:1 — multiple countries can share one currency)
- Used in: pricing calculations, FX conversions, transaction reporting
