with bronze as (

    select * from {{ ref('bronze_employees') }}

),

cleaned as (

    select
        b.employee_id,
        b.title_id,
        {{ parse_date_yy('b.birth_date') }} as birth_date,
        b.first_name,
        b.last_name,
        b.gender,
        {{ parse_date_yy('b.hire_date') }}  as hire_date,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_titles') }} t on b.title_id = t.title_id
    where b.employee_id is not null

)

select * from cleaned
