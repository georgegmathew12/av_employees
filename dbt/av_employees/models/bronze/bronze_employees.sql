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
        _line,
        _fivetran_synced        as loaded_at

    from source

)

select * from renamed
