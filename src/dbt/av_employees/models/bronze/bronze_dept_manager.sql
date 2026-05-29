with source as (

    select * from {{ source('google_drive', 'dept_manager') }}

),

renamed as (

    select
        dept_no             as department_id,
        emp_no              as employee_id,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
