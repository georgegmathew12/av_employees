-- Silver staging: filter fully-null rows.

with bronze as (

    select * from {{ ref('bronze_departments') }}

),

cleaned as (

    select
        department_id,
        department_name,
        loaded_at
    from bronze
    where department_id is not null

)

select * from cleaned
