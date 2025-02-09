CREATE OR REPLACE EXTERNAL TABLE `ivory-analyst-447323-n5.saiyajin.external_yellow_taxi`
OPTIONS (
  format = 'PARQUET',
  uris = [
    'gs://goku-ssjgod1/yellow_tripdata_2024-01.parquet',
    'gs://goku-ssjgod1/yellow_tripdata_2024-02.parquet',
    'gs://goku-ssjgod1/yellow_tripdata_2024-03.parquet',
    'gs://goku-ssjgod1/yellow_tripdata_2024-04.parquet',
    'gs://goku-ssjgod1/yellow_tripdata_2024-05.parquet',
    'gs://goku-ssjgod1/yellow_tripdata_2024-06.parquet'
  ]
);

CREATE OR REPLACE TABLE `ivory-analyst-447323-n5.saiyajin.mv_yellow_taxi`
AS
SELECT * FROM `ivory-analyst-447323-n5.saiyajin.external_yellow_taxi`;

1/
SELECT COUNT(*) AS total_records
FROM `ivory-analyst-447323-n5.saiyajin.external_yellow_taxi`;

2/
SELECT COUNT(DISTINCT PULocationID) AS distinct_pulocation_external
FROM `ivory-analyst-447323-n5.saiyajin.external_yellow_taxi`;

SELECT COUNT(DISTINCT PULocationID) AS distinct_pulocation_regular
FROM `ivory-analyst-447323-n5.saiyajin.yellow_taxi`;

4/
SELECT COUNT(*) AS zero_fare_count
FROM `ivory-analyst-447323-n5.saiyajin.external_yellow_taxi`
WHERE fare_amount = 0;

5/ partition by tpep_dropoff_time to select relevant partitions only
cluster by vendor to prepare coming ordering
CREATE OR REPLACE TABLE `ivory-analyst-447323-n5.saiyajin.optimized_yellow_taxi`
PARTITION BY DATE(tpep_dropoff_datetime)  
CLUSTER BY VendorID
AS
SELECT *
FROM `ivory-analyst-447323-n5.saiyajin.yellow_taxi`;

6/
SELECT DISTINCT VendorID
FROM `ivory-analyst-447323-n5.saiyajin.yellow_taxi`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT VendorID
FROM `ivory-analyst-447323-n5.saiyajin.optimized_yellow_taxi`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
