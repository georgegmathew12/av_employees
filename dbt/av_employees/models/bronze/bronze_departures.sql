-- Bronze: drop _line, rename _fivetran_synced to loaded_at,
-- rename emp_no to employee_id. exit_date left as VARCHAR — source uses
-- M/D/YY format and century interpretation belongs in silver.

with source as (

    select * from {{ source('google_drive', 'departures') }}

),

renamed as (

    select
        emp_no              as employee_id,
        exit_date,
        exit_reason,
        _fivetran_synced    as loaded_at

    from source

)

select * from renamed
