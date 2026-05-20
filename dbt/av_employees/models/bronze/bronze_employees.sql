-- Bronze: cast VARCHAR birth_date and hire_date to DATE, drop _line,
-- rename _fivetran_synced to loaded_at, rename emp_no/sex/emp_title_id for downstream consistency.

with source as (

    select * from {{ source('google_drive', 'employees') }}

),

renamed as (

    select
        emp_no                  as employee_id,
        emp_title_id            as title_id,
        birth_date::date        as birth_date,
        first_name,
        last_name,
        sex                     as gender,
        hire_date::date         as hire_date,
        _fivetran_synced        as loaded_at

    from source

)

select * from renamed
