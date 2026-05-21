-- Generic test: model must have at least one row. Catches accidentally-empty
-- silver/gold tables that pass other per-row tests vacuously.

{% test at_least_one_row(model) %}

    select 1
    where (select count(*) from {{ model }}) = 0

{% endtest %}
