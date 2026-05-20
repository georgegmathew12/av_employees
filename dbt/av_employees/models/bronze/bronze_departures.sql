

with source as (

    select * from {{ source('google_drive', 'departures') }}

),

renamed as (

    select
        _line,
        _fivetran_synced,
        emp_no,
        exit_date,
        exit_reason

    from source

)

select * from renamed

