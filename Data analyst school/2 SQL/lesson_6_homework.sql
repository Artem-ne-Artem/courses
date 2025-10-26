--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
---------------------------------------------------------------------------------------------------------------------------
--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и
--сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта
--в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
select		*
			,dense_rank() over (partition by model order by price asc) as "price_index"
			,case when price > (select max(price) from printer) then 1 else 0 end flag
from		(select	code, product.model, price, maker, product.type from pc join product on pc.model = product.model
				union all 
			select code, product.model, price, maker, product.type from printer join product on printer.model = product.model
				union all 
			select code, product.model, price, maker, product.type from laptop join product on laptop.model = product.model
			) a
order by	model, price

CREATE INDEX price_index_indx ON all_products_with_index_task5 (price_index)

/*
 * create table all_products_with_index_task5_2 as
select		*
			,dense_rank() over (partition by model order by price asc) as "price_index"
			,case when price > (select max(price) from printer) then 1 else 0 end flag
from		(select	code, product.model, price, maker, product.type from pc join product on pc.model = product.model
				union all 
			select code, product.model, price, maker, product.type from printer join product on printer.model = product.model
				union all 
			select code, product.model, price, maker, product.type from laptop join product on laptop.model = product.model
			) a
order by	model, price
*/


--explain select * from all_products_with_index_task5
--explain select * from all_products_with_index_task5_2
---------------------------------------------------------------------------------------------------------------------------
--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000.
--Проведите EXPLAIN операции и сравните базовые операции.

drop table synthetic_table
create table synthetic_table (col_1 int, col_2 int, col_3 int);
insert into synthetic_table
select		round(random()*(1000001 - 0) + 0) as col_1 
			,round(random()*(1000001 - 0) + 0) as col_2
			,round(random()*(1000001 - 0) + 0) as col_3
from 		generate_series(1, 10000);

explain analyze
select * from synthetic_table

explain analyze
select * from (select * ,row_number(*) over(order by col_1) as total from synthetic_table) a
where total = 1
---------------------------------------------------------------------------------------------------------------------------
--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash)







