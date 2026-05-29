{% test at_least_one_row(model) %}

    select 1
    where (select count(*) from {{ model }}) = 0

{% endtest %}
