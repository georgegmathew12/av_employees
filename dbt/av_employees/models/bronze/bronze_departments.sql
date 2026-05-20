-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename dept_no/dept_name to department_id/department_name for downstream consistency.

with source as (

    select * from {{ source('google_drive', 'departments') }}

),

renamed as (

    select
        dept_no             as department_id,
        dept_name           as department_name,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
