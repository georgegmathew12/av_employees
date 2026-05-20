

with source as (

    select * from {{ source('google_drive', 'dept_emp') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        emp_no,
        dept_no

    from source

)

select * from renamed

