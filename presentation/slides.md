---
marp: true
paginate: true
size: 16:9
title: AV Employees ELT Pipeline
description: ELT pipeline for AV employee data. Fivetran, Snowflake, dbt.
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
    --gold: #E0A82E;
    --good: #047857;
    --bad: #B91C1C;
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
  section ol li { margin-bottom: 6px; }
  section table {
    display: table;
    font-size: 16px;
    border-collapse: collapse;
    width: 100%;
    table-layout: fixed;
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
  section pre {
    background: #0F172A;
    color: #E2E8F0;
    border-radius: 12px;
    padding: 20px 24px;
    font-size: 15px;
    line-height: 1.55;
    margin: 0;
    overflow: hidden;
  }
  section code { font-family: "SF Mono", "Menlo", "Consolas", monospace; }
  section :not(pre) > code {
    background: var(--surface-2);
    border: 1px solid var(--border);
    border-radius: 5px;
    padding: 1px 6px;
    font-size: 0.88em;
    color: var(--ink);
  }
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
  .gold h4 { background: var(--gold); color: #3F2D00; }
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
  /* Stat cards */
  .stats { display: flex; gap: 20px; margin: 8px 0 28px; }
  .stat {
    flex: 1;
    background: var(--surface-2);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 24px 26px;
  }
  .stat .num {
    font-size: 46px;
    font-weight: 800;
    letter-spacing: -0.03em;
    color: var(--accent);
    line-height: 1;
  }
  .stat .num.warm { color: var(--warm); }
  .stat .lbl { font-size: 15px; color: var(--muted); margin-top: 10px; line-height: 1.35; }
  /* Callout */
  .callout {
    background: #EEF2FF;
    border-left: 4px solid var(--accent);
    border-radius: 8px;
    padding: 16px 22px;
    font-size: 18px;
    margin-top: 8px;
  }
  .callout strong { color: var(--accent); }
  /* Before / after recap */
  .recap { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 4px; }
  .recap .col { border-radius: 12px; padding: 20px 24px; }
  .recap .before { background: var(--surface-2); border: 1px solid var(--border); }
  .recap .after { background: #ECFDF5; border: 1px solid #A7F3D0; }
  .recap h4 { font-size: 12px; letter-spacing: 0.12em; text-transform: uppercase; margin: 0 0 12px; }
  .recap .before h4 { color: var(--muted); }
  .recap .after h4 { color: var(--good); }
  .recap ul { padding-left: 20px; font-size: 16px; line-height: 1.5; }
  /* Bar chart */
  .bars { margin-top: 18px; }
  .bar-row { display: flex; align-items: center; gap: 14px; margin-bottom: 11px; }
  .bar-row .name { width: 180px; flex-shrink: 0; text-align: right; font-size: 16px; color: var(--ink); }
  .bar-row .track { width: 820px; flex: none; }
  .bar-row .fill {
    height: 26px;
    border-radius: 6px;
    background: linear-gradient(90deg, var(--accent), var(--accent-2));
  }
  .fill.b1 { width: 820px; }
  .fill.b2 { width: 692px; }
  .fill.b3 { width: 489px; }
  .fill.b4 { width: 234px; }
  .fill.b5 { width: 195px; }
  .fill.b6 { width: 190px; }
  .bar-row .val { width: 60px; flex-shrink: 0; font-size: 15px; font-weight: 700; color: var(--muted); font-variant-numeric: tabular-nums; }
  /* Pie chart */
  .pie-wrap { display: flex; align-items: center; gap: 32px; margin-top: 18px; }
  .pie {
    position: relative;
    width: 200px; height: 200px; border-radius: 50%; flex-shrink: 0;
    background: conic-gradient(
      #06B6D4 0 25.55deg,
      #4F46E5 25.55deg 171.54deg,
      #E0A82E 171.54deg 317.76deg,
      #475569 317.76deg 360deg
    );
  }
  .pie .pl { position: absolute; transform: translate(-50%, -50%); font-size: 14px; font-weight: 700; }
  .pl1 { left: 113px; top: 41px; color: #0F172A; }
  .pl2 { left: 159px; top: 109px; color: #FFFFFF; }
  .pl3 { left: 46px;  top: 126px; color: #3F2D00; }
  .pl4 { left: 78px;  top: 44px;  color: #FFFFFF; }
  .legend { flex: 1; }
  .legend-row { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; font-size: 16px; color: var(--ink); }
  .legend-row .sw { width: 14px; height: 14px; border-radius: 3px; flex-shrink: 0; }
  .legend-row .lp { margin-left: auto; font-weight: 700; color: var(--muted); font-variant-numeric: tabular-nums; }
  .sw1 { background: #06B6D4; }
  .sw2 { background: #4F46E5; }
  .sw3 { background: #E0A82E; }
  .sw4 { background: #475569; }
---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">DATA ENGINEERING REVIEW</div>

# AV Employees<br/>ELT Pipeline

<div class="accent-bar"></div>

<div class="meta">George Mathew  ·  May 29, 2026</div>

---

## Agenda

<div class="agenda">
  <div class="item"><span class="label">Problem</span></div>
  <div class="item"><span class="label">Raw data</span></div>
  <div class="item"><span class="label">Loading</span></div>
  <div class="item"><span class="label">Transforming</span></div>
  <div class="item"><span class="label">Decisions</span></div>
  <div class="item"><span class="label">Limitations</span></div>
  <div class="item"><span class="label">Quality &amp; access</span></div>
  <div class="item"><span class="label">Impact &amp; next</span></div>
</div>

---

### PROBLEM
## One in five employees have left

<div class="stats">
  <div class="stat"><div class="num warm">20%</div><div class="lbl">of employees have left</div></div>
  <div class="stat"><div class="num">14,032</div><div class="lbl">departures recorded</div></div>
  <div class="stat"><div class="num">69,321</div><div class="lbl">employees in the data</div></div>
</div>

HR needs to know who is leaving, and from which teams and roles. That data already exists, but it is stuck in raw files that no one can query yet.

<div class="callout"><strong>The goal:</strong> one clean dataset HR can actually use.</div>

---

### RAW DATA
## The raw data

<div class="two-col">
<div>

<h4>What we had</h4>

- Seven CSV files: employees, departments, titles, salaries, departures
- The links between people, teams, and roles
- Enough to see who worked where and who left

</div>
<div>

<h4>What we lacked</h4>

- Reliable dates. They came as text with two digit years, so some are ambiguous.
- Reliable IDs. Many rows pointed to no one.
- Exit reason labels, or any location data.

</div>
</div>

<div class="callout">Before cleanup the files held <strong>~777</strong> blank employee rows, <strong>~17,600</strong> blank departure rows, and <strong>~77%</strong> of salary rows for employees who aren't in the data.</div>

---

### ARCHITECTURE
## The pipeline

<div class="pipeline">
  <div class="stage"><div class="pill">CSVs</div><div class="sub">Google Drive</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill accent">Fivetran</div><div class="sub">Load</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake</div><div class="sub">Raw</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill accent">dbt</div><div class="sub">Transform</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill ink">Snowflake</div><div class="sub">Gold</div></div>
  <div class="arrow">→</div>
  <div class="stage"><div class="pill gold">Tableau</div><div class="sub">Dashboard</div></div>
</div>

Each tool does one job: **Fivetran** loads the data, **Snowflake** stores it, and **dbt** cleans it. We check the data at every step.

---

### LOADING
## Fivetran loads the files

- Fivetran reads the Google Drive folder and loads each CSV into its own Snowflake table.
- There is no custom code to write or maintain. The connector handles it.
- This was a one time load. Putting it on a schedule is a small config change.

<div class="callout">A managed connector is reliable out of the box, needs no maintenance, and frees us to spend our time on the data itself.</div>

---

### STORAGE
## Snowflake stores it all

The data lands in Snowflake and stays there through every stage of cleanup. We keep each stage, so any number on the dashboard can be traced back to the source.

- **Pay for what you use.** Storage and compute scale on their own.
- **Plain SQL.** Analysts already know how to query it.
- **Room to grow.** Payroll, HRIS, or survey data can be added later without redoing this work.

---

### TRANSFORMATION
## dbt cleans and shapes it

<div class="medallion">
  <div class="card bronze">
    <h4>BRONZE</h4>
    <div class="body">
      <p>Make it readable</p>
      <ul>
        <li>Clear column names</li>
        <li>Correct data types</li>
        <li>Nothing dropped yet</li>
      </ul>
    </div>
  </div>
  <div class="card silver">
    <h4>SILVER</h4>
    <div class="body">
      <p>Make it correct</p>
      <ul>
        <li>Remove blanks and duplicates</li>
        <li>Parse dates, drop bad IDs</li>
        <li>Join the pieces together</li>
      </ul>
    </div>
  </div>
  <div class="card gold">
    <h4>GOLD</h4>
    <div class="body">
      <p>Make it usable</p>
      <ul>
        <li>Tables ready for analysis</li>
        <li>Plus a flat view for SQL</li>
      </ul>
    </div>
  </div>
</div>

Each step is plain SQL, version controlled and tested. Anyone can read the logic, and changes are safe to make.

---

### DECISIONS
## Key decisions

| Decision | Why it matters |
|---|---|
| Drop rows with unmatched IDs | We only report on employees who exist in the data. About 77% of salary rows pointed to no one, so we left them out. |
| A separate table for departments | The cleanest way to handle people who sit on more than one team. |
| A star schema **and** a flat view | The star schema gives analysts clean, related tables to query. The flat view gives non-technical users one simple sheet of employment and departures. |
| Start recording history now | The source has no dates, so a change would overwrite the old value. Snapshots capture each run and keep a history from now on. |

---

### LIMITATIONS
## What's missing

| Gap | What it means today | What unlocks it |
|---|---|---|
| Department changes have no dates | We cannot tell which team someone was on when they left | Source adds dates |
| Exit reasons are codes, not labels | The dashboard shows a code, not the reason | A lookup for the codes |
| No location anywhere | We cannot break numbers down by office or region | Source adds location |
| Salary and title are point in time | Shown as current only. No raises or promotions over time | Source adds history |

Every gap is in the **source data**, not the pipeline. When the source improves, we can add these without a rebuild.

---

### QUALITY
## Quality checks

- **Tests** catch missing values, duplicates, and bad codes at every layer.
- **Contracts** stop the build if the source changes shape, before bad data reaches the dashboard.
- **Automated checks** validate and compile the project on every change.
- **Lineage** ties every dashboard field back to its source file.

---

### GOVERNANCE
## Access and security

The data holds names, pay, and departures, so access matters.

- **Layered by design.** The pipeline separates raw, in progress, and finished tables, ready for role based grants.
- **Reviewed changes.** Every change is version controlled and approved before it takes effect.

<div class="callout">Next: grant analysts access to the finished tables only, and mask sensitive fields like pay.</div>

---

### FOR ANALYSTS
## How analysts use it

<div class="two-col">
<div>

<h4>Star schema</h4>

Tables built for Tableau. Break the numbers down by team, role, generation, or exit reason.

<h4 style="margin-top:24px">Flat view</h4>

`vw_employee_full`. One row per employee, everything joined. Open it in Excel or any SQL tool. No joins needed.

</div>
<div>

<h4>Example: leavers by tenure</h4>

<div class="pie-wrap">
  <div class="pie">
    <span class="pl pl1">7%</span>
    <span class="pl pl2">41%</span>
    <span class="pl pl3">41%</span>
    <span class="pl pl4">12%</span>
  </div>
  <div class="legend">
    <div class="legend-row"><span class="sw sw1"></span>Under 5 yrs</div>
    <div class="legend-row"><span class="sw sw2"></span>5 to 10 yrs</div>
    <div class="legend-row"><span class="sw sw3"></span>10 to 15 yrs</div>
    <div class="legend-row"><span class="sw sw4"></span>15+ yrs</div>
  </div>
</div>

Most people stay 5 to 15 years before leaving. Few leave in their first five.

</div>
</div>

---

### RESULT
## Where people leave from

<div class="bars">
  <div class="bar-row"><div class="name">Development</div><div class="track"><div class="fill b1"></div></div><div class="val">1,541</div></div>
  <div class="bar-row"><div class="name">Production</div><div class="track"><div class="fill b2"></div></div><div class="val">1,300</div></div>
  <div class="bar-row"><div class="name">Sales</div><div class="track"><div class="fill b3"></div></div><div class="val">918</div></div>
  <div class="bar-row"><div class="name">Customer Service</div><div class="track"><div class="fill b4"></div></div><div class="val">440</div></div>
  <div class="bar-row"><div class="name">Research</div><div class="track"><div class="fill b5"></div></div><div class="val">367</div></div>
  <div class="bar-row"><div class="name">Marketing</div><div class="track"><div class="fill b6"></div></div><div class="val">357</div></div>
</div>

Development and Production lose the most people. HR can now pull this in seconds, then drill into role, tenure, or generation.

---

### IMPACT
## What changed

<div class="recap">
  <div class="col before">
    <h4>Before</h4>
    <ul>
      <li>Numbers spread across seven files</li>
      <li>Spreadsheets built by hand, one at a time</li>
      <li>Totals that did not match</li>
    </ul>
  </div>
  <div class="col after">
    <h4>After</h4>
    <ul>
      <li>One source, queried directly</li>
      <li>Which teams lose the most people</li>
      <li>How long people stay, by role and generation</li>
    </ul>
  </div>
</div>

---

### SUMMARY
## Summary and next steps

**Done.** A clean, tested dataset behind the dashboard, with controlled access and traceable numbers.

**Next, in order:**

1. Fix the source data first: real dates, valid IDs, exit reason labels, and location
2. Run the pipeline on a schedule so the dashboard updates on its own
3. Add salary and promotion history once the source has it
4. Mask sensitive fields and add a dedicated analyst role

---

<!-- _class: cover -->
<!-- _paginate: false -->

<div class="kicker">DISCUSSION</div>

# Questions

<div class="accent-bar"></div>

<div class="sub">

Source: github.com/georgegmathew12/av_employees
Live dashboard: Tableau, connected to Snowflake gold

</div>

<div class="meta">George Mathew  ·  May 29, 2026</div>
