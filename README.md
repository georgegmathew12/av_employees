# av_employees

End-to-end ELT pipeline for AV employee data.

## Architecture

```
Source System  →  Fivetran  →  Snowflake (raw)  →  dbt  →  Snowflake (bronze/silver/gold)  →  Consumers
```

- **Extract + Load:** Fivetran replicates source data into Snowflake.
- **Transform:** dbt models the raw data into bronze (1:1 cleaned), silver (conformed entities), and gold (business marts).

## Repo layout

```
av_employees/
├── fivetran/           # Connector config-as-code, source docs
├── dbt/
│   └── av_employees/   # dbt project (models, tests, macros)
├── docs/               # Diagrams, decisions, notes
├── pyproject.toml      # Python deps (uv-managed)
└── uv.lock             # Pinned dependency tree
```

## Setup

Requires [uv](https://docs.astral.sh/uv/).

1. Clone the repo and `cd` in.
2. Install Python deps: `uv sync`
3. Copy creds template: `cp dbt/profiles.yml.example ~/.dbt/profiles.yml`, then fill in Snowflake account/user/password/role/database/warehouse.
4. Verify connection: `cd dbt/av_employees && uv run dbt debug` → should print "All checks passed!"

## Running dbt

From `dbt/av_employees/`:

```bash
uv run dbt build      # run models + tests
uv run dbt run        # models only
uv run dbt test       # tests only
uv run dbt docs serve # auto-doc site
```

## Status

- [x] Fivetran → Snowflake raw load
- [x] uv environment + dbt-snowflake installed
- [x] dbt project initialized + connected to Snowflake
- [ ] Sources defined (Fivetran raw tables)
- [ ] Bronze layer
- [ ] Silver layer
- [ ] Gold layer
