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
    qualify row_number() over (partition by title_id order by loaded_at desc, _line desc) = 1

)

select * from cleaned
