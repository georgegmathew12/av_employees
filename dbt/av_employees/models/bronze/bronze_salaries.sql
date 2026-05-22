with source as (

    select * from {{ source('google_drive', 'salaries') }}

),

renamed as (

    select
        emp_no              as employee_id,
        salary,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
