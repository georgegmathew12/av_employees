with src as (

    select * from {{ ref('silver_int_employee') }}

),

calc as (

    select
        employee_id,
        title_id,
        hire_date,
        exit_date,
        exit_reason                                                          as exit_reason_code,
        salary,
        datediff(day, hire_date, coalesce(exit_date, current_date()))        as tenure_days,
        exit_date is null                                                    as is_active
    from src

)

select
    employee_id,
    title_id,
    hire_date,
    exit_date,
    exit_reason_code,
    salary,
    tenure_days,
    {{ tenure_bucket('tenure_days') }}                                       as tenure_bucket,
    is_active
from calc
