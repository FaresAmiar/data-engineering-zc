SELECT 
    *,
    EXTRACT(YEAR FROM pickup_datetime) AS year,
    EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
    CONCAT(EXTRACT(YEAR FROM pickup_datetime), '/Q', EXTRACT(QUARTER FROM pickup_datetime)) AS year_quarter,
    EXTRACT(MONTH FROM pickup_datetime) AS month
FROM 
    fact_trips.taxi_trips