{{ 
    config(
        materialized='table'
    ) 
}}

WITH filtered_trips AS (
    SELECT 
        service_type,
        fare_amount,
        trip_distance,
        payment_type_description,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month
    FROM 
        {{ ref('fact_trips') }}
    WHERE 
        fare_amount > 0 
        AND trip_distance > 0 
        AND payment_type_description IN ('Cash', 'Credit Card')
)

SELECT 
    service_type,
    year,
    month,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(90)] AS fare_p90,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(95)] AS fare_p95,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(97)] AS fare_p97
FROM 
    filtered_trips
GROUP BY 
    service_type, year, month
ORDER BY 
    service_type, year, month