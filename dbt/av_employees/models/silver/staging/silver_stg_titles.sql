-- Silver staging: filter fully-null rows.

with bronze as (

    select * from {{ ref('bronze_titles') }}

),

cleaned as (

    select
        title_id,
        title,
        loaded_at
    from bronze
    where title_id is not null

)

select * from cleaned
