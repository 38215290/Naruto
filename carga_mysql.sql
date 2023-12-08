CREATE DATABASE naruto;
USE naruto;
CREATE TABLE series(
ID int,
num_ep INT,
title VARCHAR(150),
ttype VARCHAR (100),
years_launch VARCHAR(50),
rating VARCHAR(50),
votes VARCHAR(50),
saga VARCHAR(150),
airdate VARCHAR(150),
years VARCHAR (150),
months VARCHAR (150),
days VARCHAR(100)
);

# ante una advertencia de error 
SET GLOBAL local_infile = true;
SHOW VARIABLES LIKE "secure_file_priv";

#CARGA DE DATOS
LOAD DATA LOCAL INFILE 'C:/Program Files/MySQL/MySQL Server 8.0/Uploads/naruto_sh.csv'
INTO TABLE series
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
ignore 1 lines;

# visualizamos la tabla series
SELECT * FROM naruto.series;
SHOW TABLES FROM naruto;

# inciamos un contador 
# tabla dimension TYPE
SET @contador=0;
CREATE TABLE tab_type as
 select distinct(select @contador:= @contador+1) as id_type,
ttype as ttypes ,
AVG(rating) as promedio_rating ,
count(title) as cantidad_ep 
from series group by ttype;


# tabla dimension RATING
set @contador=0;
CREATE TABLE tab_rate as 
select distinct(select @contador:= @contador+1) as id_rate,
rating as ratings ,
count(num_ep) as cantidad_episodios 
from series
group by ratings 
order by rating desc;

# tabla dimension YEARS
set @contador=0;
CREATE TABLE tab_years as select distinct(select @contador:= @contador+1) as id_years,
years as yyears, 
SUM(votes) as votos_por_año , 
count(title) as num_ep 
from series group by years;

# tabla dimension SEASON
create table tab_saga as select distinct(select @contador:= @contador+1) AS id_season, 
saga as season , 
AVG(rating) as promedio_rating 
from series group by saga ;

#tabla principal (de hechos)
drop table tab_principal;
create table tab_principal select A.ID as id_principal ,
A.num_ep as num_eps,A.title as title,
A.ttype as typee,
A.years_launch as years,
A.rating as ratingg,
A.votes as vote,
A.saga as season 
,A.months as months,
C.id_rate as id_rate,
D.id_season as id_season,
E.id_type as id_type,
F.id_years as id_years
from series A
inner join tab_rate C on(A.rating = C.ratings)
inner join tab_saga D on(A.saga = D.season)
inner join tab_type E on (A.ttype = E.ttypes)
inner join tab_years F on (A.years = F.yyears)
order by id_principal asc;
