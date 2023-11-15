CREATE OR REPLACE TABLE
  bicis.viajes AS
SELECT
  trip_id,
  subscriber_type,
  bike_id,
  bike_type,
  start_time,
  duration_minutes
FROM
  `bigquery-public-data.austin_bikeshare.bikeshare_trips`;
SELECT
  MIN(start_time),
  MAX(start_time)
FROM
  `tsc20241.bicis.viajes`;
SELECT
  DATE_TRUNC(start_time,month) AS mes,
  COUNT(*)
FROM
  `tsc20241.bicis.viajes`
GROUP BY
  1
ORDER BY
  1;
SELECT
  bike_id,
  DATE_TRUNC(start_time,month) AS mes,
  COUNT(*) AS viajes
FROM
  `tsc20241.bicis.viajes`
GROUP BY
  1,
  2
ORDER BY
  1,
  2;
  #antigüedad
  #número de viajes totales en los últimos 2 meses
  #Duración promedio de sus viajes de los últimos 2 meses
  #bike_type
CREATE OR REPLACE TABLE
  bicis.cat_meses AS
WITH
  date_range AS (
  SELECT
    GENERATE_DATE_ARRAY('2013-12-01', '2023-10-31', INTERVAL 1 MONTH) AS months )
SELECT
  month
FROM
  date_range,
  UNNEST(date_range.months) AS month;
CREATE OR REPLACE TABLE
  bicis.acumulado_mensual AS
SELECT
  bike_id,
  bike_type,
  CAST(DATE_TRUNC(start_time,month) AS date) month,
  SUM(duration_minutes) AS total_duration,
  COUNT(*) AS num_viajes
FROM
  `tsc20241.bicis.viajes`
GROUP BY
  1,
  2,
  3;
SELECT
  *
FROM
  `tsc20241.bicis.acumulado_mensual`
WHERE
  bike_id='30'
ORDER BY
  month;
CREATE OR REPLACE TABLE
  bicis.cat_bici_mes AS
SELECT
  DISTINCT *
FROM
  `tsc20241.bicis.cat_meses`
CROSS JOIN (
  SELECT
    DISTINCT bike_id,
    bike_type
  FROM
    `tsc20241.bicis.acumulado_mensual`);
SELECT
  COALESCE(A.bike_id,B.bike_id) AS bike_id,
  COALESCE(A.month,B.month) AS month,
  COALESCE(A.bike_type,B.bike_type) AS bike_type,
  COALESCE(A.total_duration,0) AS total_duration,
  COALESCE(A.num_viajes,0) AS num_viajes
FROM (
  SELECT
    *
  FROM
    `tsc20241.bicis.acumulado_mensual`
  WHERE
    bike_id='30') A
FULL JOIN
  `tsc20241.bicis.cat_bici_mes` B
USING
  (bike_id,
    month)
WHERE
  bike_id='30'
ORDER BY
  month;