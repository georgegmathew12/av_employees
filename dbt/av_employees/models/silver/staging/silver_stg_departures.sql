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
    qualify row_number() over (partition by b.employee_id order by b.loaded_at desc, b._line desc) = 1

)

select * from cleaned
