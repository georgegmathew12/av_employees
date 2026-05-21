-- Silver staging: filter fully-null rows, dedupe composite key,
-- drop orphans (employee_ids not in silver_stg_employees).

with bronze as (

    select * from {{ ref('bronze_dept_emp') }}

),

cleaned as (

    select distinct
        b.employee_id,
        b.department_id,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_employees') }} e
        on b.employee_id = e.employee_id
    where b.employee_id is not null
      and b.department_id is not null

)

select * from cleaned
