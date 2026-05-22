with bridge as (

    select * from {{ ref('silver_int_employee_department') }}

),

dept_counts as (

    select
        employee_id,
        count(*) as dept_count
    from bridge
    group by employee_id

)

select
    b.employee_id,
    b.department_id,
    c.dept_count = 1 as is_only_department
from bridge b
join dept_counts c on b.employee_id = c.employee_id
