{% macro parse_date_yy(col) %}
    try_to_date({{ col }}, 'MM/DD/YY')
{% endmacro %}
