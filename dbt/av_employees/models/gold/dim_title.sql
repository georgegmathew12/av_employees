select
    title_id,
    title
from {{ ref('silver_stg_titles') }}
