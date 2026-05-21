select distinct
    exit_reason                                       as exit_reason_code,
    'unknown (' || exit_reason::varchar || ')'        as exit_reason_label
from {{ ref('silver_int_employee') }}
where exit_reason is not null
