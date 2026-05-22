select
    title_id,
    title
from {{ ref('silver_int_title') }}
