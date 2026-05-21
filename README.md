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
- [x] Sources defined (Fivetran raw tables)
- [x] Bronze layer
- [ ] Silver layer (staging + intermediate, designed not built)
- [ ] Gold layer

## Known data gaps & assumptions

### Source data issues

- `dept_emp` has multiple rows per employee but **no date columns** — "current department" is unknowable from this data
- `dept_manager` has the same issue (no date columns) — "current manager" is unknowable
- `employees` has ~777 fully-null rows from blank CSV lines; `departures` has ~17,637 — filtered out in silver_stg
- `birth_date`, `hire_date`, `exit_date` are stored as VARCHAR in `MM/DD/YY` format — silver applies a dynamic century pivot (`YY > current_year → 1900s`, else 2000s); fails for employees aged 100+ but unrealistic
- `exit_reason` is a NUMBER code with no decoder table provided
- `gender` is assumed binary (`M`/`F`)
- No `_fivetran_deleted` column — Google Drive connector dropped it in Aug 2019 (truncate-and-reload model)
- `salaries` has one row per employee, treated as current salary (no salary history)
- `titles` treated as a static lookup (no history)

### Modeling assumptions

- `silver_int_employee` deliberately skips department field (no way to differentiate between current and historical department)
- Bronze tests configured as warnings — data quality issues from upstream are expected; silver enforces strictness
- `loaded_at` (renamed from `_fivetran_synced`) is the only blocking not_null test on bronze

### Pipeline gaps to address later

- No source freshness checks in `sources.yml` (would alert if Fivetran stops syncing)
- No `prod` target in `profiles.yml` — only `dev`
- No scheduled runs / CI (dbt Cloud, GitHub Actions, or orchestrator)
- `models/example/` filler from `dbt init` is still present, unused
- Bronze column descriptions are sparse — would improve `dbt docs`
- Row-count parity test between bronze and silver_stg not yet implemented
