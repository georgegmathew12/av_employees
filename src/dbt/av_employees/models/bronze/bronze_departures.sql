with source as (

    select * from {{ source('google_drive', 'departures') }}

),

renamed as (

    select
        emp_no              as employee_id,
        exit_date,
        exit_reason,
        _line,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
