with employees as (

    select * from {{ ref('silver_stg_employees') }}

),

titles as (

    select * from {{ ref('silver_stg_titles') }}

),

salaries as (

    select * from {{ ref('silver_stg_salaries') }}

),

departures as (

    select * from {{ ref('silver_stg_departures') }}

),

joined as (

    select
        e.employee_id,
        e.first_name,
        e.last_name,
        e.gender,
        e.birth_date,
        e.hire_date,
        e.title_id,
        t.title,
        s.salary,
        d.exit_date,
        d.exit_reason
    from employees e
    left join titles     t on e.title_id    = t.title_id
    left join salaries   s on e.employee_id = s.employee_id
    left join departures d on e.employee_id = d.employee_id

)

select * from joined
