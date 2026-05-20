# dbt

Not yet initialized. To bootstrap:

```bash
cd dbt
dbt init av_employees   # answer prompts for Snowflake
```

Then organize models:

```
dbt/av_employees/models/
├── bronze/   # 1:1 with raw, light cleanup (rename, cast, dedupe)
├── silver/   # conformed, joined, business entities
└── gold/     # marts: aggregated, BI-ready
```

Profile credentials live in `~/.dbt/profiles.yml` (gitignored). See `profiles.yml.example`.
