-- Bronze: drop _line, rename _fivetran_synced to loaded_at. Column names already consistent.

with source as (

    select * from {{ source('google_drive', 'titles') }}

),

renamed as (

    select
        title_id,
        title,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
