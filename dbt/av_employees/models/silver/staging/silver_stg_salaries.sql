-- Silver staging: filter fully-null rows, drop orphans (employee_ids not in silver_stg_employees).

with bronze as (

    select * from {{ ref('bronze_salaries') }}

),

cleaned as (

    select
        b.employee_id,
        b.salary,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_employees') }} e
        on b.employee_id = e.employee_id
    where b.employee_id is not null

)

select * from cleaned
