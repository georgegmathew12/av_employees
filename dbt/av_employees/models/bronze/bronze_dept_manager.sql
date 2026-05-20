

with source as (

    select * from {{ source('google_drive', 'dept_manager') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        dept_no,
        emp_no

    from source

)

select * from renamed

