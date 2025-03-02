{{ 
    config(
        materialized='table'
    ) 
}}

WITH trip_data AS (
    SELECT 
        dispatching_base_num,
        pickup_datetime,
        dropOff_datetime,
        pickup_locationID,
        dropoff_locationID,
        TIMESTAMP_DIFF(dropOff_datetime, pickup_datetime, SECOND) AS trip_duration,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month
    FROM 
        {{ ref('dim_fhv_trips') }}
)

SELECT 
    year,
    month,
    pickup_locationID,
    dropoff_locationID,
    APPROX_QUANTILES(trip_duration, 100)[OFFSET(90)] AS p90_trip_duration
FROM 
    trip_data
GROUP BY 
    year, month, pickup_locationID, dropoff_locationID
ORDER BY 
    year, month, pickup_locationID, dropoff_locationID