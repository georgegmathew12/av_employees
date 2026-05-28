---
marp: true
theme: default
paginate: true
size: 16:9
title: AV Employees ELT Pipeline
description: ELT pipeline for AV employee data — Fivetran, Snowflake, dbt
style: |
  :root {
    --accent: #2d6cdf;
    --accent-light: #e6effd;
    --ink: #1f2a37;
    --muted: #6b7280;
    --bronze: #b07a3e;
    --silver: #9ca3af;
    --gold: #d4a82e;
  }
  section {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    color: var(--ink);
    padding: 56px 72px;
  }
  section h1 { color: var(--ink); font-size: 44px; }
  section h2 { color: var(--ink); font-size: 36px; border-bottom: 2px solid #e5e7eb; padding-bottom: 12px; }
  section h3 { color: var(--accent); font-size: 20px; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 4px; }
  section a { color: var(--accent); }
  section table { font-size: 18px; border-collapse: collapse; width: 100%; }
  section th { background: var(--accent); color: white; text-align: left; padding: 10px; }
  section td { padding: 10px; border-bottom: 1px solid #e5e7eb; vertical-align: top; }
  section tr:nth-child(even) td { background: #f7f8fa; }
  section strong { color: var(--ink); }
  section ul { line-height: 1.55; }
  section li::marker { color: var(--accent); }
  .hr-note {
    margin-top: auto;
    background: var(--accent-light);
    color: var(--accent);
    padding: 12px 18px;
    border-radius: 6px;
    font-weight: 600;
    font-size: 16px;
  }
  .hr-note::before { content: "Why this matters for HR — "; font-weight: 700; }
  section.cover {
    background: var(--accent);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  section.cover h1 { color: white; font-size: 60px; margin: 0; }
  section.cover .kicker { font-size: 14px; letter-spacing: 2px; opacity: 0.85; margin-bottom: 24px; }
  section.cover .sub { font-size: 26px; margin-top: 24px; opacity: 0.95; }
  section.cover .tools { font-size: 18px; margin-top: 48px; opacity: 0.85; font-weight: 600; }
  .pipeline {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    margin: 32px 0;
  }
  .pipeline .stage {
    text-align: center;
    flex: 1;
  }
  .pipeline .pill {
    background: var(--accent);
    color: white;
    padding: 12px 8px;
    border-radius: 10px;
    font-weight: 700;
    font-size: 15px;
  }
  .pipeline .pill.muted { background: var(--muted); }
  .pipeline .pill.ink { background: var(--ink); }
  .pipeline .pill.gold { background: var(--gold); }
  .pipeline .sub { font-size: 11px; color: var(--muted); margin-top: 6px; }
  .pipeline .arrow { color: var(--muted); font-size: 24px; font-weight: 700; }
  .medallion { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-top: 24px; }
  .medallion .card { border: 2px solid; border-radius: 10px; overflow: hidden; }
  .medallion .card h4 { margin: 0; padding: 12px; color: white; text-align: center; font-size: 22px; }
  .medallion .card .body { padding: 14px 18px; font-size: 15px; }
  .medallion .card .body p { margin: 0 0 10px; font-weight: 700; }
  .medallion .card .body ul { margin: 0; padding-left: 20px; }
  .bronze { border-color: var(--bronze); }
  .bronze h4 { background: var(--bronze); }
  .silver { border-color: var(--silver); }
  .silver h4 { background: var(--silver); }
  .gold { border-color: var(--gold); }
  .gold h4 { background: var(--gold); }
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; }
---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">AV EMPLOYEES · ELT PIPELINE</div>

# From 7 raw CSVs to trusted HR analytics

<div class="sub">A governed, tested data pipeline that Tableau and analysts can rely on.</div>

<div class="tools">Built with Fivetran · Snowflake · dbt</div>

<!--
Open with: this deck shows how raw HR CSVs became a governed analytics dataset.
Two audiences — frame results for HR, depth for analysts.
Target: ~25 min + Q&A.
-->

---

### THE BUSINESS QUESTION
## What HR wanted to answer

<div class="two-col">

- **Headcount** — how many, sliced how?
- **Attrition** — who left, when, and why?
- **Tenure** — how long do people stay?
- **Departmental composition** — who works where?
- **Exit reasons** — what patterns show up?

**Example dashboard tiles**

- Headcount by department
- Monthly attrition rate
- Tenure distribution at exit
- Top exit reasons
- Employee count by generation

</div>

<!--
Anchor the room in HR outcomes before any tool name appears.
-->

---

### THE TRANSFORMATION
## Before vs. after

| | Before | After |
|---|---|---|
| **Source of truth** | 7 CSVs scattered in Google Drive | One governed star schema in Snowflake |
| **Refresh** | Manual file drops | Fivetran-managed ingestion |
| **Trust** | "Which file is current?" | Tests + contracts on every model |
| **Access** | Whoever holds the file | Tableau + SQL views, role-grantable |
| **Audit trail** | None | Full lineage from CSV → dashboard column |

<div class="hr-note">Every number on a dashboard traces back to the raw CSV row.</div>

<!--
Most important slide for HR — read each row out loud.
Pause on Trust — this is the punchline.
-->

---

### ARCHITECTURE
## The pipeline in one picture

<div class="pipeline">
  <div class="stage"><div class="pill muted">CSVs</div><div class="sub">Google Drive</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill">Fivetran</div><div class="sub">Managed ingest</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake raw</div><div class="sub">Landing schema</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill">dbt</div><div class="sub">bronze → silver → gold</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake gold</div><div class="sub">Star schema + view</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill gold">Tableau / SQL</div><div class="sub">Consumers</div></div>
</div>

**Each tool has one job. The seams between them are testable contracts.**

- **Fivetran** — moves bytes. Not a transformer.
- **Snowflake** — stores everything; compute scales separately from storage.
- **dbt** — every transformation lives in version-controlled, tested SQL.

<!--
Reuse this mental model on later slides. Each tool has one job.
-->

---

### DECISIONS
## Why these three tools

| Tool | Why chosen | Trade-off |
|---|---|---|
| **Fivetran** | Managed CSV → Snowflake ingestion. Zero loader code to maintain. | Per-row cost. Justified for a recurring source. |
| **Snowflake** | Storage and compute scale separately. SQL-native — analysts self-serve. | Cloud cost vs. on-prem. Wins on time-to-value. |
| **dbt** | Version-controlled SQL transforms, built-in tests, contracts, lineage. | Replaces "someone's spreadsheet." Learning curve. |

<div class="hr-note">Off-the-shelf tools mean we spend time on the data, not on plumbing.</div>

<!--
If asked about cost — small footprint here. Fivetran rows are bounded; Snowflake bills only when dbt runs.
-->

---

### HOW DBT IS ORGANIZED
## Bronze → Silver → Gold

<div class="medallion">
  <div class="card bronze">
    <h4>BRONZE</h4>
    <div class="body">
      <p>Typed raw — 1:1 with source</p>
      <ul>
        <li>Renames columns to project standard</li>
        <li>Keeps loaded_at + _line tiebreaker</li>
        <li>No filtering, no business logic</li>
        <li>One model per source table</li>
      </ul>
    </div>
  </div>
  <div class="card silver">
    <h4>SILVER</h4>
    <div class="body">
      <p>Cleaned + conformed</p>
      <ul>
        <li>Drops null rows, parses VARCHAR dates</li>
        <li>Dedupes by loaded_at then _line</li>
        <li>Removes FK orphans</li>
        <li>Joins related entities</li>
      </ul>
    </div>
  </div>
  <div class="card gold">
    <h4>GOLD</h4>
    <div class="body">
      <p>Star schema + flat view</p>
      <ul>
        <li>Dim + fact tables with contracts</li>
        <li>fct_employment, fct_employee_department</li>
        <li>vw_employee_full for Excel / Snowsight</li>
        <li>What Tableau and analysts query</li>
      </ul>
    </div>
  </div>
</div>

<div class="hr-note">Three audited checkpoints. If a number looks wrong, we can trace it back.</div>

<!--
Metaphor: bronze = raw ingredients, silver = prepped, gold = plated.
-->

---

### DATA MART
## The gold layer — what HR actually uses

<div class="two-col">

**Star schema**

- `fct_employment` — 1 row per employee
- `fct_employee_department` — bridge (multi-dept)
- `dim_employee` — name, gender, hire date, generation
- `dim_department`, `dim_title`
- `dim_exit_reason` — code + label
- `dim_date`, `dim_generation`

**Flat view for non-Tableau users**

`vw_employee_full` — one row per employee, all attributes pre-joined. Departments collapsed to a comma-separated string.

Open it in Excel, Snowsight, or any SQL client — no joins required.

</div>

<div class="hr-note">Analysts get the star schema. Everyone else gets one big table.</div>

<!--
The slide HR will remember. Show a screenshot of vw_employee_full if you can.
-->

---

### QUALITY & TRUST
## How we know the data is right

- **Tests** on every layer — `unique`, `not_null`, `accepted_values`, `relationships`
- **Contracts** on gold — a schema change breaks the build, not the dashboard
- **Snapshots** — capture row-level history for tables with no source dates
- **CI** — every code change is parsed before it can merge
- **Lineage docs** — click any gold column and see exactly where it came from

<div class="hr-note">If the data breaks, the pipeline fails loudly — it does not silently publish bad numbers.</div>

<!--
The trust slide. Slow down. Each bullet = one anxiety HR has.
-->

---

### OUTCOMES
## What was gained

- Single source of truth for headcount and attrition
- Reproducible — anyone can rebuild from raw in minutes
- Self-serve for analysts (star schema) **and** non-technical users (flat view)
- Full lineage — click a column, see where it came from
- Governed access — Snowflake roles control who sees what
- Tested — broken data is caught before it reaches a dashboard

<!--
Frame as time-savings and trust, not technology.
-->

---

### DATA GAPS — ALL UPSTREAM
## What was lost — honest limitations

| Gap | Effect on HR | What unlocks it |
|---|---|---|
| No dates on dept assignments | Can't say which dept at exit; can't measure manager span | Source adds dates to `dept_emp` / `dept_manager` |
| `exit_reason` is a code only | Showing raw codes, not labels | Source supplies a decoder table |
| No location column anywhere | Can't slice by location | Source adds location data |
| Salary & title — 1 row each, no dates | Treated as "current" — no comp or promotion trends | Source adds dated history records |
| ~77% of salary / dept rows have unknown IDs | Those rows are dropped from analysis | Source fixes referential integrity |
| Dates stored as 2-digit-year text | Ambiguity around year boundaries | Source supplies ISO dates |

<div class="hr-note">Every gap is upstream — fixing the source unlocks new analysis without rebuilding the pipeline.</div>

<!--
Be unapologetic about limitations — honesty earns trust.
-->

---

### DESIGN CHOICES
## Key decisions and their impact

| Decision | Why | Impact |
|---|---|---|
| **Truncate-and-reload** (not incremental) | One-time load; simpler operationally | Fast to ship. Revisit when recurring. |
| **Drop FK orphans** via inner join in silver | Cleaner gold numbers; avoid null-stuffed joins | ~77% of salary rows excluded. Documented gap. |
| **Bridge fact** for departments | Source has multi-dept employees with no dates | Correct multi-dept counts; flag for single-dept. |
| **Flat view AND star schema** | Different consumers — Tableau vs. Excel | Unblocks non-technical users at low cost. |
| **Snapshots** on undated tables | Capture history from this day forward | Future-proofs analysis before source adds dates. |

<!--
Analysts will probe here. Be ready to defend the inner-join call.
-->

---

### WHAT'S NEXT
## Roadmap — ordered by HR ROI

- **Schedule recurring sync** — Fivetran + dbt on a daily cadence
- **Salary history fact** — enables comp trends, raises, growth analysis
- **Title history fact** — promotion paths, time-in-role
- **Dated department assignments** — manager span, hiring velocity, dept-at-exit
- **Location dimension** — if source ever supplies it
- **Source freshness alerts** — catch upstream failures fast
- **Tableau role grants** in Snowflake — `analyst_role` provisioning

<div class="hr-note">The biggest wins come from source-data improvements — the pipeline is ready.</div>

<!--
Order by HR value, not engineering effort.
-->

---

### FUTURE DASHBOARDS
## Charts we could add once source improves

<div class="two-col">

- Salary growth over time
- Promotion paths + relation to exits
- Average time in role before promotion
- Manager span of control

- Hiring velocity by department
- Cohort retention by hire year
- Compensation vs. tenure curves
- Department-at-exit trends

</div>

<div class="hr-note">These are the questions HR will ask next quarter — the pipeline is ready.</div>

<!--
Frames the next HR conversation. Each bullet has a clear source-data unlock.
-->

---

### Q&A PREP
## Anticipated questions

<div class="two-col">

**From HR leadership**

- Can I trust these numbers?
- How fresh is the data?
- What if an upstream column changes?
- Who can see this data?
- What does this cost to run?
- What about GDPR / employee deletes?
- How do we add a new system (payroll, HRIS)?

**From analysts**

- What is the grain of each fact?
- How are SCDs handled?
- Why inner-join orphans vs. left-join + null?
- Test coverage — what CI tiers?
- How are 2-digit years disambiguated?
- Why a flat view *and* a star schema?
- Snapshot strategy for undated tables?

</div>

<!--
Backup slide. Don't read it — rehearse answers in advance.
-->

---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">CLOSING</div>

# What can HR answer now that it couldn't before?

<div class="sub">

Every headcount, attrition, and tenure number is now reproducible, tested, and traceable to a row of raw data.

The pipeline absorbs source-data improvements without rebuilding — every gap we identified today becomes a new chart tomorrow.

</div>

<div class="tools">Thank you — questions?</div>

<!--
End on the dashboard demo if time allows. Hand out the gaps + roadmap 1-pager.
-->
