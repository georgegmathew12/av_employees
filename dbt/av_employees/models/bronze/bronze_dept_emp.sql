with source as (

    select * from {{ source('google_drive', 'dept_emp') }}

),

renamed as (

    select
        emp_no              as employee_id,
        dept_no             as department_id,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
