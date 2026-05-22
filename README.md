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
- [x] Silver layer (staging + intermediate)
- [x] Gold layer (star schema data mart)

## Known data gaps & assumptions

### Source data issues

- `dept_emp` has multiple rows per employee but **no date columns** — "current department" is unknowable from this data
- `dept_manager` has the same issue (no date columns) — "current manager" is unknowable
- `employees` has ~777 fully-null rows from blank CSV lines; `departures` has ~17,637 — filtered out in silver_stg
- `birth_date`, `hire_date`, `exit_date` are stored as VARCHAR in `MM/DD/YY` format — silver applies a dynamic century pivot (`YY > current_year → 1900s`, else 2000s); fails for employees aged 100+ but unrealistic. Pivot also assumes hires/exits are only recorded once complete (no pre-announced future dates) — enforced by `hire_date <= current_date()` / `exit_date <= current_date()` tests
- `exit_reason` is a NUMBER code with no decoder table provided
- `gender` is assumed binary (`M`/`F`)
- No `_fivetran_deleted` column — Google Drive connector dropped it in Aug 2019 (truncate-and-reload model)
- `salaries` has one row per employee, treated as current salary (no salary history)
- `titles` treated as a static lookup (no history)
- **Referential integrity is broken in raw CSVs**: ~77% of `salaries` and `dept_emp` rows reference employee_ids that don't exist in the `employees` CSV. Bronze preserves this faithfully (no data dropped in ELT). Silver staging drops orphan rows via inner join to `silver_stg_employees`, so silver FK tests pass — the loss is documented here, not in the test output. If preserving orphans for analysis becomes important, switch the silver_stg inner joins to left joins and mark the `relationships` tests `severity: warn`.

### Modeling assumptions

- `silver_int_employee` deliberately skips department field (no way to differentiate between current and historical department)
- Silver contract: cleaned + joined data only, no derived columns or business defaults — those belong in gold
- Bronze tests configured as warnings — data quality issues from upstream are expected; silver enforces strictness
- `loaded_at` (renamed from `_fivetran_synced`) is the only blocking not_null test on bronze

## Gold layer (data mart)

Star schema in `gold` schema, consumed by Tableau analysts. All models materialized as tables with enforced contracts (column types locked).

**Dims:** `dim_employee`, `dim_department`, `dim_title`, `dim_exit_reason`, `dim_date`, `dim_generation`
**Facts:** `fct_employment` (1 row/employee), `fct_employee_department` (bridge)

`fct_employment.tenure_days` is exposed as a continuous measure — analysts bucket it in Tableau (`Create Bins`) to fit each dashboard's needs. Generation boundaries are external classifications, so they live in `dim_generation` as data (one-row update to redefine, no fact rebuild).

Supported dashboard cuts include: newcomers/leavers per month or quarter, annual turnover, headcount over time, leavers by generation, leavers by tenure bucket, leavers by exit reason, and **leavers by job title** (join `fct_employment` → `dim_title` on `title_id`, filter `is_active = false`).

### Gold data gaps

| Gap | What's needed to fix | Once fixed | Workaround today |
|---|---|---|---|
| Location | source column on `employees` (or office-assignment table with dates) | add `dim_location` + `location_id` FK on `fct_employment` | "leavers by location" omitted from dashboard |
| Exit reason decoder | lookup table (code → label, category) | replace `fct_employment.exit_reason_code` with text `exit_reason` sourced from `dim_exit_reason.exit_reason_label`; populate real labels in the dim | label = `"unknown (<code>)"`, fact exposes raw code |
| Dept-at-exit | dates on `dept_emp` source | join `fct_employment.exit_date` to dated bridge, store `exit_department_id` on the fact | `fct_employee_department.is_only_department` flag; dashboard filters to single-dept employees for clean dept-of-leaver charts |

### Access (analyst role)

`dbt_project.yml` does not currently apply grants — the Snowflake `analyst_role` and downstream Tableau service account must be created first:

```sql
create role analyst_role;
grant usage on database <db> to role analyst_role;
grant usage on schema <db>.dbt_<user>_gold to role analyst_role;
grant select on all tables in schema <db>.dbt_<user>_gold to role analyst_role;
```

Once the role exists, add `+grants: { select: ["analyst_role"] }` under the `gold:` block in `dbt_project.yml` so future builds re-apply the grant automatically.

### PII

These columns are personally identifiable and tagged with `meta: { pii: true }` in the YAML schema files:

- `silver_stg_employees`, `silver_int_employee`: `first_name`, `last_name`
- `silver_stg_salaries`, `silver_int_employee`: `salary`

For multi-engineer or non-engineer access, apply Snowflake dynamic data masking policies. Example:

```sql
create masking policy mask_pii as (val string) returns string ->
    case when current_role() in ('PII_VIEWER', 'ACCOUNTADMIN') then val else '***MASKED***' end;
alter table dbt_george_silver.silver_int_employee
    modify column first_name set masking policy mask_pii;
```

### Recurring sync (one-time load currently)

This pipeline runs as a one-time load: CSVs were uploaded to Google Drive and Fivetran synced them into Snowflake once. To convert to a recurring pipeline:

1. Set the Fivetran connector's sync schedule (e.g., hourly) in the Fivetran UI
2. Add a `prod` target to `~/.dbt/profiles.yml` with a service account
3. Schedule `dbt build` to run after each Fivetran sync — options: dbt Cloud (UI-based), GitHub Actions cron, Airflow/Dagster/Prefect (full orchestrator)

### Pipeline gaps to address later

- No source freshness checks in `sources.yml` (would alert if Fivetran stops syncing — relevant only if pipeline becomes recurring)
- No `prod` target in `profiles.yml` — only `dev`
- CI: Tier 1 (GitHub Actions running `uv run dbt parse` on every PR) is the next planned addition. Tiers 2 (compile against warehouse) and 3 (build against CI schema) require Snowflake service credentials and a separate CI schema.
- Bronze column descriptions are sparse — would improve `dbt docs`
