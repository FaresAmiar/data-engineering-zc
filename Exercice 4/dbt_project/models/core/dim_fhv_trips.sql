{{ 
    config(
        materialized='table'
    ) 
}}

WITH fhv_data AS (
    SELECT 
        *,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month
    FROM 
        {{ ref('stg_fhv_taxi') }}  -- Reference to the staging model
)

SELECT 
    fhv_data.*,
    zones.borough AS pickup_borough,
    zones.zone AS pickup_zone
FROM 
    fhv_data
LEFT JOIN 
    {{ ref('dim_zones') }} AS zones
ON 
    fhv_data.pickup_locationID = zones.locationid