-- Silver staging: filter fully-null rows, parse exit_date with century pivot,
-- drop orphans (employee_ids not in silver_stg_employees).

with bronze as (

    select * from {{ ref('bronze_departures') }}

),

cleaned as (

    select
        b.employee_id,
        {{ parse_date_yy('b.exit_date') }} as exit_date,
        b.exit_reason,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_employees') }} e
        on b.employee_id = e.employee_id
    where b.employee_id is not null

)

select * from cleaned
