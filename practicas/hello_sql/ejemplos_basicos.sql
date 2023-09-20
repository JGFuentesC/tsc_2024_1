## Cambiar base de datos objetivo
use pokemon;

## Seleccionar todas las columnas
select * from pokemon.stats;
## Seleccionar columnas específicas
select name,attack,defense from stats;
## Filtros 
select * from stats where attack>150;
select * from stats where attack<50;
select * from stats where attack>90 and height>10 ;
select name from stats where height between 10 and 50 and attack>70 ;
select * from stats where name Like '%a'; 
## Concatenar 
select concat(attack,'-',defense) as ataque_defensa,name from stats;
## Ordenar 
select * from stats where defense>90 
order by name ;
## Límite de resultados
select * from stats order by attack  limit 10;


## Funciones de agregación COUNT, SUM, AVG, MIN, MAX y GROUP BY
select count(id) pokemones_w from stats where name like 'w%';
select AVG(hp),avg(attack),avg(defense) from stats;

SELECT 
    CASE
        WHEN hp > 70 THEN 'fuertes'
        ELSE 'debiles'
    END AS tipo_pokemon,
    AVG(hp) AS hp_medio,
    AVG(attack) AS ataque_medio,
    AVG(defense) AS defensa_media,
    COUNT(*) AS num_pokemones
FROM
    stats
GROUP BY 1
;
select sum(attack) as total_ataque from 
(select * from stats order by attack desc  limit 10) as A;

## Agregar Columna en una vista
CREATE VIEW columna_extra AS 
select *,CASE
        WHEN hp > 70 THEN 'fuertes'
        ELSE 'debiles'
    END AS tipo_pokemon from stats;

## Crear tabla nueva
create table top10 as 
with A as (
select * from stats order by attack desc  limit 10)
select * from A;

## Modificar datos (ZONA DE PELIGRO!!!)
UPDATE stats
SET name = 'sonansu' where name like 'wob%';

select * from stats where name ='sonansu';
## Combinar (CTE = common table expressions)
with random1 as 
(select name,attack from stats order by rand() limit 2),
random2 as 
(select name,attack from stats order by rand() limit 2)
select * from random1,random2 # Cross-Join
