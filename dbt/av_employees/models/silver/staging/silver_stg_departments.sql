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
    qualify row_number() over (partition by department_id order by loaded_at desc) = 1

)

select * from cleaned
