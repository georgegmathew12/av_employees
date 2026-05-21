{% macro tenure_bucket(tenure_days_col) %}
    case
        when {{ tenure_days_col }} < 365         then '<1'
        when {{ tenure_days_col }} < 365 * 2     then '1-2'
        when {{ tenure_days_col }} < 365 * 3     then '2-3'
        when {{ tenure_days_col }} < 365 * 5     then '3-5'
        else                                          '>5'
    end
{% endmacro %}
