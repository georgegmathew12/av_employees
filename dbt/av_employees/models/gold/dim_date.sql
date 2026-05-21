with spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1985-01-01' as date)",
        end_date="dateadd(year, 1, current_date())"
    ) }}

)

select
    cast(date_day as date)                                       as date_id,
    year(date_day)                                               as year,
    quarter(date_day)                                            as quarter,
    month(date_day)                                              as month,
    monthname(date_day)                                          as month_name,
    year(date_day) || '-Q' || quarter(date_day)                  as year_quarter,
    to_varchar(date_day, 'YYYY-MM')                              as year_month
from spine
