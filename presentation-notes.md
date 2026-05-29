# Presentation notes

Talking points per slide. Keep it conversational. The deck carries the detail; you carry the story.

---

## 1. Title — AV Employees ELT Pipeline
- One line: "This is the data work behind the HR attrition dashboard."
- Name the three tools up front: Fivetran, Snowflake, dbt.
- Two audiences in the room: keep it plain for HR, the analysts will get the depth in the middle.

## 2. Agenda
- Quick read of the path: the problem, the raw data, how we move and clean it, then what HR gets out of it.
- Don't linger. 10 seconds.

## 3. Problem — One in five have left
- Lead with the number: 1 in 5 employees on record have left. 14,032 departures across 69,321 people.
- HR can feel the churn but can't see it: which teams, which roles.
- The data exists. It's just stuck in raw files no one can query.
- (If asked: these are figures from the dataset we loaded, for demonstration.)

## 4. Raw data — what we had / lacked
- We had seven CSV files and the links between people, teams, and roles.
- What was missing is the point: dates stored as text, IDs that point to no one, no labels, no location.
- Land the scale of the mess: ~777 blank employee rows, ~17,600 blank departures, ~77% of salary rows for people not in the data.
- This is why you can't just open the CSVs in Excel and trust the answer.

## 5. Architecture — the pipeline
- Walk the arrows left to right once.
- Each tool has one job: Fivetran moves it, Snowflake stores it, dbt cleans it.
- The point to make: every step is checked before the next one trusts it.

## 6. Loading — Fivetran
- Fivetran reads the Drive folder and loads each file into Snowflake. No code to maintain.
- Be honest: this was a one-time load. Scheduling it is a small config change (it's in next steps).
- Why managed: reliable out of the box, frees us to work on the data.

## 7. Storage — Snowflake
- Everything lives in Snowflake, every stage of cleanup.
- Why that matters: any number on the dashboard traces back to the source.
- Forward-looking: payroll, HRIS, surveys can plug in later without redoing this.

## 8. Transformation — dbt (bronze / silver / gold)
- The three-step story: make it readable, make it correct, make it usable.
- Bronze = raw but renamed. Silver = cleaned and joined. Gold = what the dashboard reads.
- It's all plain SQL, version controlled and tested. Anyone can read it, changes are safe.

## 9. Key decisions
- Pick two to talk through, don't read the table.
- Dropping unmatched IDs: keeps counts honest, and we know exactly how many (~77% of salary rows).
- Star schema + flat view: analysts want one shape, everyone else wants the other.

## 10. Limitations — what's missing
- Frame it as honest, not defensive: every gap is in the source data, not our work.
- The big ones: no dates on department changes, exit reasons are codes, no location.
- Each one opens up the moment the source improves. No rebuild needed.

## 11. Quality checks
- This is the trust slide. Slow down.
- Tests catch bad data at every layer. Contracts stop the build if the source shifts shape.
- Automated checks run on every change. Lineage ties each field back to its file.

## 12. Governance — access and security
- It's names, pay, and departures, so access matters.
- Be precise on current state: the pipeline separates raw / in-progress / finished layers, ready for grants.
- Next step is granting analysts the finished tables only and masking pay. Don't claim it's fully locked down today.

## 13. For analysts — how they use it
- Two ways in: the star schema for Tableau, the flat view for everyone else.
- The pie is a real result: most people leave between 5 and 15 years in. Few leave early.
- Point: this took one query, or a few clicks in Tableau.

## 14. Result — where people leave from
- Real numbers: Development and Production lose the most people.
- The value line: HR can pull this in seconds, then drill into role, tenure, or generation.

## 15. Impact — what changed
- Before: numbers across seven files, manual cuts, totals that didn't match.
- After: one source, queried directly, real questions answered.
- Let the contrast do the work. Don't oversell it.

## 16. Summary and next steps
- One sentence on what's done: clean, tested dataset, controlled access, traceable numbers.
- Next, in order: fix the source data first, then schedule it, add salary/promotion history, then masking and an analyst role.
- Source fixes are the biggest unlock, and they're not our work, they're the data owner's.

## 17. Questions
- Hand off cleanly. Point to the GitHub repo and the live Tableau dashboard.

---

## Tough questions to be ready for

- **"Is this live / how fresh is the data?"** — One-time load today. Scheduling is a small config change and it's the first next step.
- **"Is any of this automated?"** — Every change runs automated checks (parse/compile). Full build-and-test in CI needs warehouse credentials and is planned.
- **"Who can see salaries?"** — Layers are separated and ready for role grants. Granting analysts finished tables only, plus masking pay, is the next step.
- **"What does it cost to run?"** — Tiny at this volume. Comfortably inside free tiers; a few dollars a month at most if scheduled daily.
- **"Why did we drop 77% of salary rows?"** — Those rows reference employee IDs that aren't in the employee file. Keeping them would inflate or break the joins. We track exactly how many we set aside.
- **"Are these real company numbers?"** — They're from the dataset we loaded, used to demonstrate the pipeline.
- **"Why both a star schema and a flat view?"** — Tableau wants the star schema for slicing. Excel and ad-hoc SQL users want one wide table. Same source, two shapes.
