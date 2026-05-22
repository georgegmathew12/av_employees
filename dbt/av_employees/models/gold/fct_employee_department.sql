select
    employee_id,
    department_id
from {{ ref('silver_int_employee_department') }}
