-- Silver staging: filter fully-null rows, parse VARCHAR dates with century pivot.

with bronze as (

    select * from {{ ref('bronze_employees') }}

),

cleaned as (

    select
        employee_id,
        title_id,
        {{ parse_date_yy('birth_date') }} as birth_date,
        first_name,
        last_name,
        gender,
        {{ parse_date_yy('hire_date') }} as hire_date,
        loaded_at
    from bronze
    where employee_id is not null

)

select * from cleaned
