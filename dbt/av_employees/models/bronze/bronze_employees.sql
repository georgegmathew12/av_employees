-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename emp_no/sex/emp_title_id for downstream consistency.
-- Date columns left as VARCHAR — source uses M/D/YY format and the
-- century-pivot rule (e.g. birth dates → 1900s) is business logic
-- that belongs in silver.

with source as (

    select * from {{ source('google_drive', 'employees') }}

),

renamed as (

    select
        emp_no                  as employee_id,
        emp_title_id            as title_id,
        birth_date,
        first_name,
        last_name,
        sex                     as gender,
        hire_date,
        _fivetran_synced        as loaded_at

    from source

)

select * from renamed
