{% snapshot snap_bronze_salaries %}

{{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='employee_id',
      check_cols=['salary'],
      invalidate_hard_deletes=True
    )
}}

select * from {{ ref('bronze_salaries') }}

{% endsnapshot %}
