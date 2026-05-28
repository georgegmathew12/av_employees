# av_employees

ELT pipeline for AV employee data.

[**Presentation deck**](https://georgegmathew12.github.io/av_employees/) — slides walking through the pipeline (Fivetran → Snowflake → dbt) for HR + analyst audiences. Source: [`slides.md`](slides.md). Rebuilt automatically on every push to `main`.

## Architecture

```
CSVs (Google Drive) → Fivetran → Snowflake (raw) → dbt (bronze → silver → gold) → Tableau / SQL consumers
```

- Fivetran loads CSVs into Snowflake (one-time, truncate-and-reload).
- dbt transforms raw → bronze (typed) → silver (cleaned + conformed) → gold (star schema + a flat view for non-Tableau consumers).

## Repo layout

```
av_employees/
├── fivetran/           # Connector config, source docs
├── dbt/av_employees/   # dbt project (models, snapshots, macros, tests)
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
uv run dbt deps              # install packages
uv run dbt parse             # syntax check, no warehouse calls
uv run dbt build             # run models + tests
uv run dbt build -s gold     # build only the gold layer
uv run dbt snapshot          # capture history of undated source tables
uv run dbt test              # tests only
uv run dbt docs generate     # build the lineage site
```

## Status

- [x] Fivetran → Snowflake raw load
- [x] Bronze, silver, gold layers
- [x] Tests, contracts, snapshots, CI

## Pipeline walkthrough

### Gold — data mart

Star schema in the `gold` schema. Tables with enforced contracts.

**Dims:** `dim_employee`, `dim_department`, `dim_title`, `dim_exit_reason`, `dim_date`, `dim_generation`
**Facts:** `fct_employment` (1 row per employee), `fct_employee_department` (bridge — multiple departments per employee, source has no dates)
**Views:** `vw_employee_full` (denormalized one-row-per-employee for non-Tableau consumers — see Consumers section)

Gold reads only from silver intermediate models.

### Silver — conformed entities

Two sublayers in the `silver` schema.

**Staging** (views): `silver_stg_employees`, `silver_stg_departures`, `silver_stg_departments`, `silver_stg_titles`, `silver_stg_salaries`, `silver_stg_dept_emp`, `silver_stg_dept_manager`

Purpose: per-source cleanup. Filters null rows, parses VARCHAR dates, dedupes (by `loaded_at` then `_line`), drops FK orphans.

**Intermediate** (tables): `silver_int_employee`, `silver_int_employee_department`, `silver_int_department`, `silver_int_title`

Purpose: joined business entities + thin passthroughs for lookup dims. Gold contract layer.

### Bronze — typed raw

Tables in the `bronze` schema, one per source: `bronze_employees`, `bronze_departures`, `bronze_departments`, `bronze_titles`, `bronze_salaries`, `bronze_dept_emp`, `bronze_dept_manager`

Purpose: 1:1 with source. Renames columns to project naming (`emp_no` → `employee_id`, `_fivetran_synced` → `loaded_at`). Keeps `_line` as a deterministic dedupe tiebreaker. No filtering, no business logic.

### Snapshots

`snap_bronze_dept_emp`, `snap_bronze_salaries`, `snap_bronze_titles` capture row-level history for tables that have no date columns at source. Run `dbt snapshot` before each `dbt build` once the pipeline becomes recurring.

## Data gaps

All gaps come from source data. ELT cannot fix what's missing upstream.

| Gap | Effect | How we handle it now | Fix when source improves |
|---|---|---|---|
| `dept_emp` / `dept_manager` have no dates | Cannot determine dept-at-exit or current manager | Bridge fact + `dim_employee.has_single_department` flag | Add dates to source; derive dept-at-exit by joining `fct_employment.exit_date` to a dated bridge |
| `exit_reason` is a code with no decoder | Shows raw codes only | `dim_exit_reason.exit_reason_label` = `"unknown (<code>)"` | Populate real labels in `dim_exit_reason` |
| No location column anywhere | Cannot slice by location | Omit from dashboard | Add `dim_location` + `location_id` FK on `fct_employment` |
| Dates stored as `MM/DD/YY` VARCHAR | Two-digit year is ambiguous | Project sets Snowflake `TWO_DIGIT_CENTURY_START = (current_year - 99)` via `pre_hook` on every model/test/snapshot session — newest 2-digit year parses as current year, oldest supported birth shifts back one year each Jan 1 | Source supplies ISO dates → drop the macro + pre_hook |
| `salaries` has 1 row per employee, no date | Could be from any snapshot | Treated as current — assumption based on 1-row-per-employee shape | Use most recent dated salary on `fct_employment`; optionally add history fact |
| `titles` resolves to 1 title per employee, no date | Same as salary | Treated as current — same assumption | Same pattern as salary |
| ~77% of `salaries` and `dept_emp` rows reference `employee_ids` not in `employees` | FK broken | Silver inner-joins to drop orphans | Source fixes referential integrity → switch to left joins |
| Null rows in `employees` (~777) and `departures` (~17,637) | Blank CSV lines | Filtered in silver | Source removes blank lines |
| `gender` values | Assumed `M`/`F` | `accepted_values` test enforces | Expand allowed values if source changes |
| No `_fivetran_deleted` column | Cannot detect source deletes | Truncate-and-reload; fine for one-time load | Filter `_fivetran_deleted` in bronze; enable incremental builds |

## Consumers

- **Tableau analysts** — connect to the star schema (`fct_employment`, `fct_employee_department`, and the dims) and define relationships in the data source.
- **Non-Tableau users** (Snowsight, Excel/ODBC, ad-hoc SQL) — query `vw_employee_full`. One row per employee with attributes pre-joined; departments collapsed into a comma-separated string. For exact department filtering, use the star schema instead.

## Improvements

### Modeling

- **Historical employment.** Today `fct_employment` is 1 row per employee. If source adds salary or title history (multi-row with dates), the `unique` test on `employee_id` fails and we add a parallel `fct_employment_role` fact at role-period granularity. Existing fact stays as the current snapshot.
- **Salary history fact.** Driven by source adding dated salary records. Enables salary growth, compensation trends.
- **Title history fact.** Same idea for promotion paths and tenure-in-role analysis.

### Dashboard charts to consider adding

- Salary growth over time (needs salary history)
- Promotion paths + relation to exits (needs title history)
- Average time in role before promotion (needs title history)
- Manager span of control (needs `dept_manager` dates)
- Hiring velocity by department (needs `dept_emp` dates)
- Cohort retention by hire year (currently available — analyst calc in Tableau)

### Operational

- **Recurring sync.** Currently one-time. To enable: schedule the Fivetran connector, add a `prod` target to `profiles.yml` with a service account, schedule `dbt build` + `dbt snapshot`.
- **Source freshness.** Not configured. Add once recurring.
- **CI tiers.** Tier 1 (parse on PR) is implemented. Tier 2 (compile against warehouse) and Tier 3 (build against a dedicated CI schema) need Snowflake service credentials.
- **Tableau grants.** `dbt_project.yml` does not apply grants. To enable, create an `analyst_role` in Snowflake and add `+grants: { select: ["analyst_role"] }` under `gold:` in `dbt_project.yml`.
