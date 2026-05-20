

with source as (

    select * from {{ source('google_drive', 'departments') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        dept_no,
        dept_name

    from source

)

select * from renamed

