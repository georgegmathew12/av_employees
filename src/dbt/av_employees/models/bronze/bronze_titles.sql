with source as (

    select * from {{ source('google_drive', 'titles') }}

),

renamed as (

    select
        title_id,
        title,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
