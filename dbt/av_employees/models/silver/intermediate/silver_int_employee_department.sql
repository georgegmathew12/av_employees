with dept_emp as (

    select * from {{ ref('silver_stg_dept_emp') }}

),

departments as (

    select * from {{ ref('silver_stg_departments') }}

),

joined as (

    select
        de.employee_id,
        de.department_id,
        d.department_name
    from dept_emp de
    left join departments d on de.department_id = d.department_id

)

select * from joined
