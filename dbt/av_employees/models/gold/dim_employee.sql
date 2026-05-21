select
    employee_id,
    first_name,
    last_name,
    gender,
    birth_date,
    {{ generation_bucket('birth_date') }} as generation_bucket
from {{ ref('silver_int_employee') }}
