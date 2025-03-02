{% macro safe_cast(column_name, target_type) %}
    SAFE_CAST({{ column_name }} AS {{ target_type }})
{% endmacro %}

{{
    config(
        materialized='view'
    )
}}

with tripdata as (
    select *,
        row_number() over(partition by dispatching_base_num, pickup_datetime) as rn
    from {{ source('staging', 'ext_fhv_taxi') }}
    where dispatching_base_num is not null
)

select
    -- Identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    dispatching_base_num,
    
    -- Timestamps
    pickup_datetime,
    dropOff_datetime,
    
    -- Location Info
    {{ safe_cast("PUlocationID", "INTEGER") }} as pickup_locationid,
    {{ safe_cast("DOlocationID", "INTEGER") }} as dropoff_locationid,
    
    -- Trip Info
    SR_Flag,
    Affiliated_base_number

from tripdata
where rn = 1

{% if var('is_test_run', default=false) %}
  limit 100
{% endif %}
