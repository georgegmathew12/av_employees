-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename emp_no to employee_id for downstream consistency.

with source as (

    select * from {{ source('google_drive', 'salaries') }}

),

renamed as (

    select
        emp_no              as employee_id,
        salary,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
