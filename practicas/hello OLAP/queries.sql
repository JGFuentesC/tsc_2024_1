CREATE OR REPLACE TABLE
  taxis.intermedia AS
SELECT
  ROW_NUMBER() OVER (ORDER BY taxi_id) id_viaje,
  taxi_id,
  CAST(trip_start_timestamp AS date) fecha,
  EXTRACT(hour
  FROM
    trip_start_timestamp ) hora,
  trip_seconds,
  trip_miles,
  trip_total,
  tips,
  payment_type,
  company,
  concat(cast(pickup_latitude as string),',',cast(pickup_longitude as string)) pu ,
  concat(cast(dropoff_latitude as string),',',cast(dropoff_longitude as string)) do
FROM
  `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE
  trip_start_timestamp>='2023-06-01'
  AND trip_start_timestamp<'2023-09-01';
CREATE OR REPLACE TABLE
  taxis.viajes
PARTITION BY
  fecha AS
SELECT
  *
FROM
  taxis.intermedia;
DROP TABLE taxis.intermedia ;

  CREATE OR REPLACE TABLE
  cubo.taxis AS
SELECT
  hora AS d_hora,
  CASE
    WHEN payment_type IN ('Credit Card', 'Cash', 'Mobile') THEN payment_type
  ELSE
  'Otros'
END
  AS d_medio_de_pago,
  CASE
    WHEN company IN ('Taxi Affiliation Services', 'Flash Cab', 'Sun Taxi', 'City Service', 'Taxicab Insurance Agency Llc', 'Chicago Independents', '5 Star Taxi') THEN company
  ELSE
  'Otras'
END
  AS d_compania,
  fecha AS d_fecha,
  COUNT(*) AS h_num_viajes,
  SUM(tips) AS h_propinas,
  SUM(trip_total) AS h_total_cobro,
  SUM(trip_miles)*1.60934 AS h_km_recorridos,
  SUM(trip_seconds)/60 AS h_min_duracion
FROM
  taxis.viajes
GROUP BY
  1,
  2,
  3,
  4;

  CREATE OR REPLACE TABLE
  cubo.mapa AS
SELECT
  fecha AS d_fecha,
  pu AS g_pu,
  `do` AS g_do,
  COUNT(*) AS h_num_viajes,
FROM
  taxis.viajes
where pu!=',' and `do`!=','
GROUP BY
  1,
  2,
  3;