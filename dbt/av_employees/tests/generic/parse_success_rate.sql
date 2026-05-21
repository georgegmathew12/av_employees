-- Generic test: for rows that exist in both the parsed and source models
-- (joined on key_column), the parse should not produce a NULL when the source
-- was non-null. Catches silent parse failures from format changes.

{% test parse_success_rate(model, parsed_column, source_model, source_column, key_column) %}

    select 1
    from {{ model }} m
    join {{ source_model }} s on m.{{ key_column }} = s.{{ key_column }}
    where s.{{ source_column }} is not null
      and m.{{ parsed_column }} is null

{% endtest %}
