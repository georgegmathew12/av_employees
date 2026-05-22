{% macro parse_date_yy(col) %}
    case
        when year(try_to_date({{ col }}, 'MM/DD/YY')) >= 2025
            then dateadd(year, -100, try_to_date({{ col }}, 'MM/DD/YY'))
        else try_to_date({{ col }}, 'MM/DD/YY')
    end
{% endmacro %}
