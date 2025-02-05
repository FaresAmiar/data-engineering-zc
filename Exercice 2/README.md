# README - SQL Queries for Taxi Data

## SQL Queries

### 3. Total Rows for Yellow Taxi Data in 2020
```sql
SELECT COUNT(unique_row_id)
FROM yellow_tripdata yt  
WHERE yt.tpep_pickup_datetime >= DATE '2020-01-01' 
  AND yt.tpep_dropoff_datetime < DATE '2021-01-01';
```

### 4. Total Rows for Green Taxi Data in 2020
```sql
SELECT COUNT(unique_row_id)
FROM green_tripdata gt  
WHERE gt.lpep_pickup_datetime >= DATE '2020-01-01' 
  AND gt.lpep_dropoff_datetime < DATE '2021-01-01';
```

### 5. Total Rows for Yellow Taxi Data in March 2021
```sql
SELECT COUNT(unique_row_id)
FROM yellow_tripdata yt  
WHERE yt.tpep_pickup_datetime >= DATE '2021-03-01' 
  AND yt.tpep_dropoff_datetime < DATE '2021-04-01';
```

