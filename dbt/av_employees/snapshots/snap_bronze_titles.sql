{% snapshot snap_bronze_titles %}

{{
    config(
      target_schema='snapshots',
      strategy='check',
      unique_key='title_id',
      check_cols=['title'],
      invalidate_hard_deletes=True
    )
}}

select * from {{ ref('bronze_titles') }}

{% endsnapshot %}
