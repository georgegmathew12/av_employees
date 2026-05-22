# av_employees

ELT pipeline for AV employee data.

## Architecture

```
CSVs (Google Drive) → Fivetran → Snowflake (raw) → dbt (bronze → silver → gold) → Tableau
```

- Fivetran loads CSVs into Snowflake (one-time, truncate-and-reload).
- dbt transforms raw → bronze (cleaned) → silver (conformed) → gold (star schema).

## Repo layout

```
av_employees/
├── fivetran/           # Connector config, source docs
├── dbt/av_employees/   # dbt project
├── docs/               # Diagrams, decisions
├── pyproject.toml
└── uv.lock
```

## Setup

Requires [uv](https://docs.astral.sh/uv/).

1. `uv sync`
2. `cp dbt/profiles.yml.example ~/.dbt/profiles.yml` — fill in Snowflake creds
3. `cd dbt/av_employees && uv run dbt debug`

## Run

From `dbt/av_employees/`:

```bash
uv run dbt deps              # install dbt packages (dbt_utils, codegen)
uv run dbt parse             # syntax check, no warehouse calls
uv run dbt build             # run models + tests
uv run dbt build -s gold     # build only the gold layer
uv run dbt build -s gold+    # gold and everything downstream
uv run dbt test              # run tests only
uv run dbt docs generate     # generate catalog + lineage
```

## Status

- [x] Fivetran → Snowflake raw load
- [x] Bronze, silver, gold layers
- [x] Tests, contracts, docs

## Pipeline walkthrough

### Gold — data mart for Tableau

Star schema in the `gold` schema. Tables with enforced contracts.

**Dims:** `dim_employee`, `dim_department`, `dim_title`, `dim_exit_reason`, `dim_date`, `dim_generation`
**Facts:** `fct_employment` (1 row per employee), `fct_employee_department` (bridge — multiple departments per employee. gap addressed in further documentation)

### Silver — conformed entities

Two sublayers in the `silver` schema.

**Staging** (views): `silver_stg_employees`, `silver_stg_departures`, `silver_stg_departments`, `silver_stg_titles`, `silver_stg_salaries`, `silver_stg_dept_emp`, `silver_stg_dept_manager`

Purpose: per-source cleanup. Filters null rows, parses VARCHAR dates, dedupes, drops orphans.

**Intermediate** (tables): `silver_int_employee`, `silver_int_employee_department`

Purpose: business entities. Employees joined to title, salary, and exit info. Bridge for the many-to-many employee-department relationship.

### Bronze — typed raw

Tables in the `bronze` schema, one per source: `bronze_employees`, `bronze_departures`, `bronze_departments`, `bronze_titles`, `bronze_salaries`, `bronze_dept_emp`, `bronze_dept_manager`

Purpose: 1:1 with source. Renames raw columns to project naming (`emp_no` → `employee_id`, `_fivetran_synced` → `loaded_at`). No filtering, no business logic. Silver is insulated from source-side renames or shape changes here.

## Data gaps

All gaps come from source data. ELT cannot fix what's missing upstream.

| Gap | Effect | How we handle it now | Fix when source improves |
|---|---|---|---|
| `dept_emp` / `dept_manager` have no dates | Cannot determine dept-at-exit or current manager | Bridge fact + `is_only_department` flag | Add dates to source; analysts derive dept-at-exit by joining `fct_employment.exit_date` to dated bridge |
| `exit_reason` is a code with no decoder | Shows raw codes only | `dim_exit_reason.exit_reason_label` = `"unknown (<code>)"` | Populate real labels in `dim_exit_reason` |
| No location column anywhere | Cannot slice by location | Omit from dashboard | Add `dim_location` + `location_id` FK on `fct_employment` |
| Dates stored as `MM/DD/YY` VARCHAR | Century is ambiguous | Current solution: pivot: `YY > current_year → 1900s`;| Source supplies ISO dates → drop pivot macro |
| `salaries` has 1 row per employee, no date | Could be from any snapshot | Assumption: treat as current. Based on 1-row per employee | Use most recent dated salary on `fct_employment`; optionally add history fact |
| `titles` resolves to 1 title per employee, no date | Same as salary | Treated as current. Same assumption | Same pattern as salary |
| ~77% of `salaries` and `dept_emp` rows orphan `employee_id` | FK broken | Silver inner-joins to drop orphans | Source fixes referential integrity → switch to left joins |
| Null rows in `employees` (~777) and `departures` (~17,637) | Garbage | Filtered in silver | Source removes blank lines |
| `gender` values | Assumed `M`/`F` | `accepted_values` test enforces | Expand allowed values if source changes |
| No `_fivetran_deleted` column | Cannot detect source deletes | Truncate-and-reload; fine for one-time load | Filter `_fivetran_deleted` in bronze; enable incremental builds |

## Improvements

### Modeling

- **Historical employment.** Today `fct_employment` is 1 row per employee. If source adds salary or title history (multi-row with dates), the `unique` test on `employee_id` fails and we add a parallel `fct_employment_role` fact at role-period granularity. Existing fact stays as the current snapshot. No breaking change.
- **Salary history fact.** Driven by source adding dated salary records. Enables salary growth, compensation trends.
- **Title history fact.** Same idea for promotion paths and tenure-in-role analysis.

### Dashboard charts to consider adding

- Salary growth over time (needs salary history)
- Promotion paths (needs title history) + relation to exits
- Average time in role before promotion (needs title history) + relation to exits
- Manager span of control (needs `dept_manager` dates)
- Hiring velocity by department (needs `dept_emp` dates)
- Cohort retention by hire year (currently available, analyst calculation in Tableau)

### Operational

- **Recurring sync.** Currently one-time. Enable: schedule the Fivetran connector, add a `prod` target to `profiles.yml` with a service account, schedule `dbt build` (dbt Cloud / GitHub Actions cron / Airflow).
- **Source freshness.** Not configured. Add once recurring.
- **CI.** GitHub Actions running `uv run dbt parse` on every PR is next. Compile and build-against-CI-schema tiers need Snowflake service credentials and a dedicated CI schema.
- **`prod` target.** Missing from `profiles.yml` — only `dev` exists.
- **Bronze descriptions.** Sparse — would improve the `dbt docs` site.

### Access and PII

- **Tableau grants.** `dbt_project.yml` does not yet apply grants. To enable:

  ```sql
  create role analyst_role;
  grant usage on database <db> to role analyst_role;
  grant usage on schema <db>.dbt_<user>_gold to role analyst_role;
  grant select on all tables in schema <db>.dbt_<user>_gold to role analyst_role;
  ```

  Then add `+grants: { select: ["analyst_role"] }` under `gold:` in `dbt_project.yml`.

- **PII masking.** `first_name`, `last_name`, `salary` are tagged `meta: { pii: true }` across silver and gold. Apply Snowflake masking for non-engineer access:

  ```sql
  create masking policy mask_pii as (val string) returns string ->
      case when current_role() in ('PII_VIEWER', 'ACCOUNTADMIN') then val else '***MASKED***' end;
  alter table dbt_george_gold.dim_employee
      modify column first_name set masking policy mask_pii;
  ```
