with bronze as (

    select * from {{ ref('bronze_dept_emp') }}

),

cleaned as (

    select distinct
        b.employee_id,
        b.department_id,
        b.loaded_at
    from bronze b
    inner join {{ ref('silver_stg_employees') }}    e on b.employee_id   = e.employee_id
    inner join {{ ref('silver_stg_departments') }}  d on b.department_id = d.department_id

)

select * from cleaned
