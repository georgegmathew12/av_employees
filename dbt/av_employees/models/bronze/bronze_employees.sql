

with source as (

    select * from {{ source('google_drive', 'employees') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        emp_no,
        emp_title_id,
        birth_date,
        first_name,
        last_name,
        sex,
        hire_date

    from source

)

select * from renamed

