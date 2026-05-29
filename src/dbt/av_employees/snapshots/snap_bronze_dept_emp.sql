{% snapshot snap_bronze_dept_emp %}

{{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key="employee_id || '_' || department_id",
      check_cols=['loaded_at'],
      invalidate_hard_deletes=True
    )
}}

select * from {{ ref('bronze_dept_emp') }}

{% endsnapshot %}
