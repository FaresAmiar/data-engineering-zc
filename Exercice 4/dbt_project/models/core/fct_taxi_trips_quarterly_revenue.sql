WITH quarterly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM trips_unioned.pickup_datetime) AS year,
        EXTRACT(QUARTER FROM trips_unioned.pickup_datetime) AS quarter,
        SUM(CASE WHEN trips_unioned.service_type = 'Green' THEN trips_unioned.total_amount ELSE 0 END) AS green_revenue,
        SUM(CASE WHEN trips_unioned.service_type = 'Yellow' THEN trips_unioned.total_amount ELSE 0 END) AS yellow_revenue
    FROM 
        (SELECT * FROM {{ ref('fact_trips') }}) AS trips_unioned
    GROUP BY 
        year, quarter
),

yoy_growth AS (
    SELECT 
        year,
        quarter,
        green_revenue,
        yellow_revenue,
        LAG(green_revenue) OVER (PARTITION BY quarter ORDER BY year) AS previous_green_revenue,
        LAG(yellow_revenue) OVER (PARTITION BY quarter ORDER BY year) AS previous_yellow_revenue
    FROM 
        quarterly_revenue
)

SELECT 
    year,
    quarter,
    green_revenue,
    yellow_revenue,
    CASE 
        WHEN previous_green_revenue IS NULL OR previous_green_revenue = 0 THEN NULL
        ELSE (green_revenue - previous_green_revenue) / previous_green_revenue * 100
    END AS green_yoy_growth,
    CASE 
        WHEN previous_yellow_revenue IS NULL OR previous_yellow_revenue = 0 THEN NULL
        ELSE (yellow_revenue - previous_yellow_revenue) / previous_yellow_revenue * 100
    END AS yellow_yoy_growth
FROM 
    yoy_growth
ORDER BY 
    year, quarter