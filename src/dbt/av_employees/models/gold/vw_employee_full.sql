{{ config(materialized='view', contract={'enforced': false}) }}

with depts as (

    select
        b.employee_id,
        listagg(d.department_name, ', ') within group (order by d.department_name) as departments,
        count(*) as department_count
    from {{ ref('fct_employee_department') }} b
    join {{ ref('dim_department') }} d on b.department_id = d.department_id
    group by b.employee_id

)

select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.gender,
    e.birth_date,
    g.generation_name,
    t.title,
    f.hire_date,
    f.exit_date,
    f.salary,
    f.tenure_days,
    f.is_active,
    er.exit_reason_label,
    coalesce(d.departments, '') as departments,
    coalesce(d.department_count, 0) as department_count,
    e.has_single_department
from {{ ref('dim_employee') }} e
join {{ ref('fct_employment') }} f        on e.employee_id   = f.employee_id
join {{ ref('dim_generation') }} g        on e.generation_id = g.generation_id
join {{ ref('dim_title') }} t             on f.title_id      = t.title_id
left join {{ ref('dim_exit_reason') }} er on f.exit_reason_id = er.exit_reason_id
left join depts d                         on e.employee_id   = d.employee_id
