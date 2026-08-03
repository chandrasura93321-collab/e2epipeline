# e2epipeline

End-to-end sales data pipeline on Snowflake (Bronze / Silver / Gold architecture).

## Database Change Management (Migrations)

Migration scripts are stored in `project/migrations/` and follow versioned naming:

| Version | Description |
|---------|-------------|
| V1.0.0 | Create governance database and schemas |
| V1.1.0 | Create governance tags |
| V1.2.0 | Create sales database and schemas (BRONZE, SILVER, GOLD, COMMON) |
| V1.3.0 | Create common file formats (CSV_FORMAT with COMPRESSION=AUTO) |
| V1.4.0 | Create bronze internal stage (STG_RAW) |
| V1.5.0 | Apply governance tags to sales database objects |
| V1.6.0 | Initial load - Upload CSV source files to stage (Snow CLI commands) |

## Initial Data Load

Source files are located in `project/__initial_load/` and uploaded to `@SALES_DEV.BRONZE.STG_RAW/initial-load/` using Snow CLI.

### Stage Layout

```
@SALES_DEV.BRONZE.STG_RAW/initial-load/
├── country-master/          (4 files: country, currency, region, tax)
├── product-master/          (5 files: category, availability, family, model, sku)
├── store-master/            (1 file: store_master)
├── customer-master/2019/<CC>/  (35 files, partitioned by country code)
└── sales-transaction/2019/  (2 files: sales_header, sales_item)
```

### Upload Command Pattern

```
snow stage copy "<local_path>" "@SALES_DEV.BRONZE.STG_RAW/<stage_path>/" -c coco --parallel 10 --auto-compress --overwrite
```

- `--parallel 10` : 10 threads for upload performance
- `--auto-compress` : GZIP compression during upload (.csv -> .csv.gz)
- `--overwrite` : Replace existing files if re-running
- File format `CSV_FORMAT` has `COMPRESSION=AUTO`, so no format changes needed for .gz files

### Snow CLI Connection

- Connection name: `coco`
- Account: RGZARGH-YZ09033
- User: SURA
- Role: ACCOUNTADMIN
