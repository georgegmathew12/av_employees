-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename emp_no/dept_no to employee_id/department_id for downstream consistency.

with source as (

    select * from {{ source('google_drive', 'dept_emp') }}

),

renamed as (

    select
        emp_no              as employee_id,
        dept_no             as department_id,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
