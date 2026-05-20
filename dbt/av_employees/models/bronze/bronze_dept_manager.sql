-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename dept_no/emp_no to department_id/employee_id for downstream consistency.

with source as (

    select * from {{ source('google_drive', 'dept_manager') }}

),

renamed as (

    select
        dept_no             as department_id,
        emp_no              as employee_id,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
