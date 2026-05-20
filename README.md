# av_employees

End-to-end ELT pipeline for AV employee data.

## Architecture

```
Source System  →  Fivetran  →  Snowflake (raw)  →  dbt  →  Snowflake (bronze/silver/gold)  →  Consumers
```

- **Extract + Load:** Fivetran replicates source data into Snowflake.
- **Transform:** dbt models the raw data into bronze (raw cleaned), silver (conformed), and gold (business-ready) layers.

## Repo layout

```
av_employees/
├── fivetran/   # Connector config-as-code, source documentation
├── dbt/        # dbt project (models, tests, macros)
└── docs/       # Diagrams, decisions, notes
```

## Setup

1. Clone: `git clone https://github.com/georgegmathew12/av_employees.git`
2. Copy `dbt/profiles.yml.example` → `~/.dbt/profiles.yml` and fill in Snowflake creds.
3. From `dbt/`: `dbt deps && dbt debug` to confirm connectivity.

## Status

- [x] Fivetran → Snowflake raw load
- [ ] dbt project initialized
- [ ] Bronze layer
- [ ] Silver layer
- [ ] Gold layer
