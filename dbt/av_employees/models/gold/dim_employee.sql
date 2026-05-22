with employees as (

    select * from {{ ref('silver_int_employee') }}

),

generations as (

    select * from {{ ref('dim_generation') }}

)

select
    e.employee_id,
    e.first_name,
    e.last_name,
    e.gender,
    e.birth_date,
    g.generation_id
from employees e
left join generations g
    on year(e.birth_date) between g.min_year and g.max_year
