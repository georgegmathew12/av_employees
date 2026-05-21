{% test parse_success_rate(model, parsed_column, source_model, source_column, key_column) %}

    select 1
    from {{ model }} m
    join {{ source_model }} s on m.{{ key_column }} = s.{{ key_column }}
    where s.{{ source_column }} is not null
      and m.{{ parsed_column }} is null

{% endtest %}
