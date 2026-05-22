with source as (

    select * from {{ source('google_drive', 'departments') }}

),

renamed as (

    select
        dept_no             as department_id,
        dept_name           as department_name,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
