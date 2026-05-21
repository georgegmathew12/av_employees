-- Parse a VARCHAR column in MM/DD/YY format with a dynamic century pivot:
-- if the parsed year is > current year, treat as 1900s (subtract 100).
-- Uses try_to_date so malformed strings return NULL instead of erroring.

{% macro parse_date_yy(col) %}
    case
        when year(try_to_date({{ col }}, 'MM/DD/YY')) > year(current_date())
            then dateadd(year, -100, try_to_date({{ col }}, 'MM/DD/YY'))
        else try_to_date({{ col }}, 'MM/DD/YY')
    end
{% endmacro %}
