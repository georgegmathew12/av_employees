{% macro generation_bucket(birth_date_col) %}
    case
        when year({{ birth_date_col }}) between 1928 and 1945 then 'Silent Generation'
        when year({{ birth_date_col }}) between 1946 and 1964 then 'Baby Boomer'
        when year({{ birth_date_col }}) between 1965 and 1980 then 'Generation X'
        when year({{ birth_date_col }}) between 1981 and 1996 then 'Millennial'
        when year({{ birth_date_col }}) between 1997 and 2012 then 'Generation Z'
        when year({{ birth_date_col }}) >= 2013              then 'Generation Alpha'
    end
{% endmacro %}
