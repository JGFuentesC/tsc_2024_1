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
CREATE OR REPLACE TABLE
  bicis.completa AS
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
    `tsc20241.bicis.acumulado_mensual` ) A
FULL JOIN
  `tsc20241.bicis.cat_bici_mes` B
USING
  (bike_id,
    month)
ORDER BY
  month;
CREATE OR REPLACE TABLE
  bicis.tad AS
SELECT
  bike_id,
  bike_type,
  num_viajes,
  DATE_DIFF(month, MIN(month) OVER (PARTITION BY bike_id),month) AS antig,
  SUM(num_viajes) OVER (PARTITION BY bike_id ORDER BY month ROWS BETWEEN 1 PRECEDING AND 0 FOLLOWING) AS num_viajes_ult_2m,
  AVG(total_duration) OVER (PARTITION BY bike_id ORDER BY month ROWS BETWEEN 1 PRECEDING AND 0 FOLLOWING) AS prom_duracion_ult_2m,
  ROW_NUMBER() OVER (PARTITION BY bike_id ORDER BY month) AS rn,
  CASE
    WHEN LEAD(num_viajes,1) OVER (PARTITION BY bike_id ORDER BY month)= 0 THEN 1
  ELSE
  0
END
  AS label,
  month
FROM
  `tsc20241.bicis.completa`
ORDER BY
  bike_id,
  month;
CREATE OR REPLACE MODEL
  bicis.logreg OPTIONS(model_type='logistic_reg',
    input_label_cols=['label'],
    FIT_INTERCEPT = TRUE,
    CATEGORY_ENCODING_METHOD = 'ONE_HOT_ENCODING',
    ENABLE_GLOBAL_EXPLAIN = TRUE,
    DATA_SPLIT_METHOD = 'AUTO_SPLIT',
    HPARAM_TUNING_ALGORITHM = 'RANDOM_SEARCH',
    HPARAM_TUNING_OBJECTIVES = ['ROC_AUC'] ) AS
SELECT
  bike_type,
  antig,
  num_viajes_ult_2m,
  prom_duracion_ult_2m,
  label
FROM
  bicis.tad
WHERE
  rn BETWEEN 2
  AND 118
  AND num_viajes!=0;
WITH
  prediction AS (
  SELECT
    bike_id,
    bike_type,
    label,
    ROUND(predicted_label_probs[
    OFFSET
      (0)].prob,3) AS proba,
    month,
  FROM
    ML.PREDICT(MODEL `bicis.logreg`,
      (
      SELECT
        bike_id,
        bike_type,
        antig,
        num_viajes_ult_2m,
        prom_duracion_ult_2m,
        label,
        month
      FROM
        bicis.tad
      WHERE
        rn BETWEEN 2
        AND 118
        AND num_viajes != 0)) )
SELECT
  month,
  label,
  CASE
    WHEN proba<=0.02 THEN '00. [0.00,0.02]'
    WHEN proba<=0.04 THEN '01. (0.02,0.04]'
    WHEN proba<=0.06 THEN '02. (0.04,0.06]'
    WHEN proba<=0.08 THEN '03. (0.06,0.08]'
    WHEN proba<=0.10 THEN '04. (0.08,0.10]'
    WHEN proba<=0.12 THEN '05. (0.10,0.12]'
    WHEN proba<=0.14 THEN '06. (0.12,0.14]'
    WHEN proba<=0.16 THEN '07. (0.14,0.16]'
  ELSE
  '08. (0.16,1]'
END
  AS proba,
  COUNT(*) AS casos
FROM
  prediction
GROUP BY
  1,
  2,
  3