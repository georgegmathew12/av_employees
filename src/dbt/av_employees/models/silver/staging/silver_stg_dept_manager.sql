with bronze as (

    select * from {{ ref('bronze_dept_manager') }}

),

cleaned as (

    select
        b.department_id,
        b.employee_id,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_employees') }}    e on b.employee_id   = e.employee_id
    inner join {{ ref('silver_stg_departments') }}  d on b.department_id = d.department_id
    qualify row_number() over (partition by b.department_id, b.employee_id order by b.loaded_at desc, b._line desc) = 1

)

select * from cleaned
