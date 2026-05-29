select
    employee_id,
    title_id,
    hire_date,
    exit_date,
    exit_reason                                                          as exit_reason_id,
    salary,
    datediff(day, hire_date, coalesce(exit_date, current_date()))        as tenure_days,
    exit_date is null                                                    as is_active
from {{ ref('silver_int_employee') }}
