---
marp: true
paginate: true
size: 16:9
title: AV Employees ELT Pipeline
description: ELT pipeline for AV employee data — Fivetran, Snowflake, dbt
style: |
  :root {
    --accent: #4F46E5;
    --accent-2: #06B6D4;
    --warm: #B45309;
    --ink: #0F172A;
    --muted: #64748B;
    --soft: #94A3B8;
    --surface: #FFFFFF;
    --surface-2: #F8FAFC;
    --border: #E2E8F0;
    --bronze: #92400E;
    --silver: #475569;
    --gold: #B45309;
  }
  section {
    background: var(--surface);
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Helvetica Neue", Arial, sans-serif;
    color: var(--ink);
    padding: 60px 80px 56px;
    font-size: 20px;
    line-height: 1.5;
    position: relative;
  }
  section::before {
    content: "";
    position: absolute;
    top: 0; left: 0; right: 0;
    height: 6px;
    background: linear-gradient(90deg, var(--accent), var(--accent-2));
  }
  section.cover::before { display: none; }
  section h1 {
    font-size: 46px;
    font-weight: 800;
    letter-spacing: -0.02em;
    margin: 0 0 8px;
    line-height: 1.1;
  }
  section h2 {
    font-size: 40px;
    font-weight: 800;
    letter-spacing: -0.02em;
    color: var(--ink);
    margin: 4px 0 28px;
    line-height: 1.1;
  }
  section h3 {
    color: var(--accent);
    font-size: 13px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    margin: 0 0 4px;
    font-weight: 700;
  }
  section h4 { margin: 0; }
  section p { margin: 0 0 14px; color: var(--ink); }
  section a { color: var(--accent); text-decoration: none; }
  section strong { color: var(--ink); font-weight: 700; }
  section ul { margin: 0; padding-left: 22px; line-height: 1.65; }
  section ul li { margin-bottom: 6px; }
  section li::marker { color: var(--accent); }
  section ol { padding-left: 22px; line-height: 1.65; }
  section table {
    font-size: 16px;
    border-collapse: collapse;
    width: 100%;
    border: 1px solid var(--border);
    border-radius: 10px;
    overflow: hidden;
  }
  section th {
    background: var(--ink);
    color: white;
    text-align: left;
    padding: 12px 14px;
    font-weight: 600;
    font-size: 13px;
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }
  section td {
    padding: 12px 14px;
    border-bottom: 1px solid var(--border);
    vertical-align: top;
    color: var(--ink);
  }
  section tr:last-child td { border-bottom: none; }
  section tr:nth-child(even) td { background: var(--surface-2); }
  section::after {
    color: var(--soft);
    font-weight: 600;
    font-size: 12px;
    right: 60px;
    bottom: 22px;
  }
  /* Cover */
  section.cover {
    background: radial-gradient(ellipse at 70% 30%, #1E1B4B 0%, #0F172A 60%);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 80px 90px;
  }
  section.cover h1 {
    color: white;
    font-size: 72px;
    font-weight: 800;
    letter-spacing: -0.03em;
    line-height: 1.05;
    margin: 0;
  }
  section.cover .kicker {
    font-size: 12px;
    letter-spacing: 0.3em;
    color: var(--accent-2);
    font-weight: 700;
    margin-bottom: 32px;
  }
  section.cover .sub {
    font-size: 22px;
    margin-top: 28px;
    color: #CBD5E1;
    max-width: 900px;
    line-height: 1.4;
  }
  section.cover .meta {
    position: absolute;
    bottom: 60px;
    left: 90px;
    font-size: 14px;
    color: #94A3B8;
    letter-spacing: 0.05em;
  }
  section.cover .accent-bar {
    width: 80px;
    height: 4px;
    background: var(--accent-2);
    margin: 24px 0;
  }
  /* Pipeline */
  .pipeline {
    display: flex;
    align-items: stretch;
    justify-content: space-between;
    gap: 6px;
    margin: 36px 0 8px;
  }
  .pipeline .stage { text-align: center; flex: 1; display: flex; flex-direction: column; }
  .pipeline .pill {
    background: var(--surface-2);
    border: 1.5px solid var(--border);
    color: var(--ink);
    padding: 16px 8px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 14px;
    min-height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .pipeline .pill.accent { background: var(--accent); color: white; border-color: var(--accent); }
  .pipeline .pill.ink { background: var(--ink); color: white; border-color: var(--ink); }
  .pipeline .pill.gold { background: var(--warm); color: white; border-color: var(--warm); }
  .pipeline .sub { font-size: 11px; color: var(--muted); margin-top: 8px; font-weight: 500; }
  .pipeline .arrow {
    color: var(--soft);
    font-size: 22px;
    align-self: center;
    font-weight: 400;
  }
  /* Medallion cards */
  .medallion { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 18px; margin-top: 8px; }
  .medallion .card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
  }
  .medallion .card h4 {
    margin: 0;
    padding: 14px 18px;
    color: white;
    font-size: 16px;
    letter-spacing: 0.1em;
    font-weight: 700;
  }
  .medallion .card .body { padding: 16px 20px 18px; font-size: 14px; }
  .medallion .card .body p { margin: 0 0 10px; font-weight: 600; color: var(--ink); font-size: 14px; }
  .medallion .card .body ul { margin: 0; padding-left: 18px; line-height: 1.5; font-size: 13px; color: var(--muted); }
  .medallion .card .body ul li { margin-bottom: 4px; }
  .bronze h4 { background: var(--bronze); }
  .silver h4 { background: var(--silver); }
  .gold h4 { background: var(--gold); }
  /* Two column */
  .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; }
  .two-col h4 {
    font-size: 12px;
    color: var(--accent);
    letter-spacing: 0.15em;
    text-transform: uppercase;
    margin: 0 0 12px;
    font-weight: 700;
  }
  /* Agenda */
  .agenda { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 48px; counter-reset: agenda; }
  .agenda .item {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 10px 0;
    border-bottom: 1px solid var(--border);
    counter-increment: agenda;
  }
  .agenda .item::before {
    content: counter(agenda, decimal-leading-zero);
    color: var(--accent);
    font-weight: 700;
    font-size: 13px;
    letter-spacing: 0.05em;
    font-variant-numeric: tabular-nums;
  }
  .agenda .label { font-size: 18px; color: var(--ink); font-weight: 500; }
---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">DATA ENGINEERING REVIEW</div>

# AV Employees<br/>ELT Pipeline

<div class="accent-bar"></div>

<div class="sub">The ingestion, storage, and transformation layer that feeds the HR analytics dashboard.</div>

<div class="meta">George Mathew  ·  May 29, 2026</div>

---

### AGENDA
## Today

<div class="agenda">
  <div class="item"><span class="label">Background</span></div>
  <div class="item"><span class="label">Architecture</span></div>
  <div class="item"><span class="label">Ingestion — Fivetran</span></div>
  <div class="item"><span class="label">Storage — Snowflake</span></div>
  <div class="item"><span class="label">Transformation — dbt</span></div>
  <div class="item"><span class="label">Quality &amp; limitations</span></div>
  <div class="item"><span class="label">Design decisions</span></div>
  <div class="item"><span class="label">Roadmap &amp; discussion</span></div>
</div>

---

### BACKGROUND
## Why this exists

- HR leadership saw a Tableau dashboard demo for employment trends and attrition.
- Source data is seven CSV files (employees, departments, titles, salaries, departures).
- This pipeline turns those CSVs into a governed dataset Tableau and analysts can rely on.

---

### ARCHITECTURE
## End-to-end

<div class="pipeline">
  <div class="stage"><div class="pill">CSVs</div><div class="sub">Google Drive</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill accent">Fivetran</div><div class="sub">Ingestion</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake</div><div class="sub">Raw</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill accent">dbt</div><div class="sub">Transform</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake</div><div class="sub">Gold</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill gold">Tableau</div><div class="sub">Dashboard</div></div>
</div>

Each tool has one job. The boundaries between them are governed by tests and contracts.

---

### INGESTION
## Fivetran

- Reads the Google Drive folder, unzips, lands each CSV into its own Snowflake table.
- Attaches a `_fivetran_synced` timestamp to every row.
- Zero custom loader code to maintain.

Managed service cost is justified at this volume. Revisit at scale.

---

### STORAGE
## Snowflake

| Schema | Role |
|---|---|
| `raw` | Fivetran landing tables — untouched |
| `bronze` | Typed, renamed mirror of raw |
| `silver` | Cleaned, deduplicated, joined |
| `gold` | Production facts, dimensions, and views |

Storage and compute scale independently — materializing every layer is inexpensive. Access is role-controlled.

---

### TRANSFORMATION
## dbt — bronze, silver, gold

<div class="medallion">
  <div class="card bronze">
    <h4>BRONZE</h4>
    <div class="body">
      <p>One-to-one with source</p>
      <ul>
        <li>Renames + type casts</li>
        <li>No filtering, no logic</li>
      </ul>
    </div>
  </div>
  <div class="card silver">
    <h4>SILVER</h4>
    <div class="body">
      <p>Conformed entities</p>
      <ul>
        <li>Drop nulls, dedupe</li>
        <li>Parse dates, remove orphans</li>
        <li>Join business entities</li>
      </ul>
    </div>
  </div>
  <div class="card gold">
    <h4>GOLD</h4>
    <div class="body">
      <p>Production data mart</p>
      <ul>
        <li>Star schema with contracts</li>
        <li>Flat view for SQL/Excel</li>
      </ul>
    </div>
  </div>
</div>

Every model is version-controlled SQL with built-in tests and column-level lineage.

---

### CONSUMPTION
## What analysts query

<div class="two-col">
<div>

<h4>Star schema</h4>

- `fct_employment` — 1 row per employee
- `fct_employee_department` — bridge for multi-dept
- `dim_employee`, `dim_department`, `dim_title`
- `dim_exit_reason`, `dim_date`, `dim_generation`

</div>
<div>

<h4>Flat view</h4>

`vw_employee_full` — one row per employee, all attributes pre-joined. For Snowsight, Excel, ad-hoc SQL.

</div>
</div>

---

### QUALITY
## Controls

- **Tests** at every layer — `unique`, `not_null`, `accepted_values`, `relationships`
- **Contracts** on gold — schema changes fail the build, not the dashboard
- **Snapshots** capture history for source tables with no date columns
- **CI** parses every PR before review
- **Lineage docs** — every gold column traceable to a CSV row

---

### LIMITATIONS
## Source data gaps

| Gap | Effect | Unlock |
|---|---|---|
| No dates on dept assignments | Cannot determine dept at exit | Source adds dates |
| `exit_reason` is a raw code | Dashboard shows codes only | Source supplies decoder |
| No location column | No geographic slicing | Source adds location |
| Salary / title — one row, no date | Treated as current value | Source adds history |
| ~77% of salary rows have unknown employee IDs | Affected rows excluded | Source fixes referential integrity |
| Dates stored as 2-digit-year text | Year boundary requires handling | Source supplies ISO dates |

All gaps are upstream. The pipeline absorbs source improvements without re-architecture.

---

### DECISIONS
## Choices and rationale

| Decision | Rationale |
|---|---|
| Truncate-and-reload | One-time load. Incremental added when recurring. |
| Inner-join to drop FK orphans | Preserves joined-fact integrity. Exclusion is quantified. |
| Bridge fact for departments | Multi-dept assignments with no dates. |
| Star schema **and** flat view | Tableau needs star; non-Tableau needs one-row-per-employee. |
| Snapshots on undated tables | Forward-looking history from day one. |

---

### ROADMAP
## Next

1. Schedule recurring sync (Fivetran + `dbt build`)
2. Source freshness checks + alerting
3. Salary and title history facts once source provides dates
4. Location dimension if source adds it
5. `analyst_role` provisioning in Snowflake
6. Expand CI to warehouse-backed tiers

---

### DISCUSSION
## Anticipated questions

<div class="two-col">
<div>

<h4>Business</h4>

- Data freshness once recurring?
- Operating cost at steady state?
- Access controls?
- Compliance / employee deletions?
- Adding a new source system?

</div>
<div>

<h4>Technical</h4>

- Grain of each fact?
- SCD strategy?
- Why drop orphans vs. retain with NULL?
- CI tiers + test coverage?
- 2-digit-year resolution?

</div>
</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">Q&amp;A</div>

# Thank you

<div class="accent-bar"></div>

<div class="sub">

Source: github.com/georgegmathew12/av_employees
Live dashboard: Tableau on Snowflake gold

</div>

<div class="meta">George Mathew  ·  May 29, 2026</div>
