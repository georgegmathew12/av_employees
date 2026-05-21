{% macro parse_date_yy(col) %}
    case
        when year(try_to_date({{ col }}, 'MM/DD/YY')) > year(current_date())
            then dateadd(year, -100, try_to_date({{ col }}, 'MM/DD/YY'))
        else try_to_date({{ col }}, 'MM/DD/YY')
    end
{% endmacro %}
