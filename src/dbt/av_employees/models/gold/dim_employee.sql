with employees as (

    select * from {{ ref('silver_int_employee') }}

),

generations as (

    select * from {{ ref('dim_generation') }}

),

dept_counts as (

    select
        employee_id,
        count(*) as dept_count
    from {{ ref('silver_int_employee_department') }}
    group by employee_id

)

select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.gender,
    e.birth_date,
    g.generation_id,
    coalesce(c.dept_count = 1, false) as has_single_department
from employees e
left join generations g on year(e.birth_date) between g.min_year and g.max_year
left join dept_counts c on e.employee_id = c.employee_id
