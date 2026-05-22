# dbt

dbt project lives in `av_employees/`. Adapter: `dbt-snowflake`.

## First-time setup

1. `uv sync` from the repo root (installs `dbt-snowflake`).
2. `cp profiles.yml.example ~/.dbt/profiles.yml` and fill in Snowflake creds. See the table in `profiles.yml.example` for where to find each field.
3. `cd av_employees && uv run dbt debug` → confirms connection.

## Model layers

```
av_employees/models/
├── bronze/   # 1:1 with raw; rename/cast only — no filtering, no dedup
├── silver/   # cleaned + conformed entities; staging dedupes + filters, intermediate joins
└── gold/     # star schema, BI-ready
```

## Common commands

Run all from `av_employees/`:

```bash
uv run dbt build              # run + test everything
uv run dbt run -s bronze      # only bronze models
uv run dbt test               # run tests
uv run dbt docs generate      # build docs
```

## Profiles

- Real creds: `~/.dbt/profiles.yml` (gitignored, never committed)
- Template: `profiles.yml.example` (committed, no real values)
