

with source as (

    select * from {{ source('google_drive', 'titles') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        title_id,
        title

    from source

)

select * from renamed

