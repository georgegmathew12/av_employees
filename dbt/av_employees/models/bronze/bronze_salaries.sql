

with source as (

    select * from {{ source('google_drive', 'salaries') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        emp_no,
        salary

    from source

)

select * from renamed

