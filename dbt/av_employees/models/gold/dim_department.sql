select
    department_id,
    department_name
from {{ ref('silver_int_department') }}
