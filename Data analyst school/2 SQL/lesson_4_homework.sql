--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
-----------------------------------------------------------------------------------------------------------------------------------
--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop).
--Вывести: model, maker, type

select model, maker ,"type" from product
-----------------------------------------------------------------------------------------------------------------------------------
--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней
--PC - "1", у остальных - "0"

select *, case when price > (select avg(price) from pc) then 1 else 0 end as flag from printer
-----------------------------------------------------------------------------------------------------------------------------------
--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

--Вар 1
select		t1.name
from 		(select name from Ships union select ship from Outcomes) as t1
left join 	ships as t2 on t1.name = t2.name
where		t2.class is null

--Вар 2
with query as (select name from Ships union select ship from Outcomes)
select name from query where name not in (select distinct name from ships)
-----------------------------------------------------------------------------------------------------------------------------------
--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with t0 as
(select distinct launched from Ships)
select * from Battles where extract (year from date) <> all (select launched from t0)
-----------------------------------------------------------------------------------------------------------------------------------
--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select		t1.battle
from		Outcomes as t1 
inner join	(select name from Ships where class = 'Kongo') as t2 on t1.ship = t2.name
-----------------------------------------------------------------------------------------------------------------------------------
--task1  (lesson4)
--Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом,
--если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
(
select model ,price ,case when price > 300 then 1 else 0 end as flag
from
	(
	select model, price from pc
		union
	select model, price from laptop
		union
	select model, price from printer
	) as t1
)
-----------------------------------------------------------------------------------------------------------------------------------
--task2  (lesson4)
--Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом,
--если стоимость больше cредней . Во view три колонки: model, price, flag

with query as (
select model, price from pc
	union
select model, price from laptop
	union
select model, price from printer
)
select model ,price ,case when price > (select avg(price) from query) then 1 else 0 end as flag from query
-----------------------------------------------------------------------------------------------------------------------------------
--task3  (lesson4)
--Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'.
--Вывести model

with query as (
select * from printer as t1
left join product as t2 on t1.model  = t2.model
)
select model from query where maker = 'A' and price > (select avg(price) from query where maker in ('D', 'C'))
-----------------------------------------------------------------------------------------------------------------------------------
--task4 (lesson4)
--Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'.
--Вывести model

with query as (
select model ,price from pc where model in (select model from product where maker = 'A')
	union
select model ,price from laptop where model in (select model from product where maker = 'A')
	union
select model ,price from printer where model in (select model from product where maker = 'A')
)
select model from query where price > (select avg(price) from printer where model in (select model from product where maker in ('D', 'C')))
-----------------------------------------------------------------------------------------------------------------------------------
--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

select avg(price) from 
(select model ,price from pc where model in (select model from product where maker = 'A')
	union
select model ,price from laptop where model in (select model from product where maker = 'A')
	union
select model ,price from printer where model in (select model from product where maker = 'A')
) as t1
-----------------------------------------------------------------------------------------------------------------------------------
--task6 (lesson4)
--Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю.
--Во view: maker, count
create view count_products_by_makers as (
select maker ,count(*) as qty
from
(select t1.model ,t2.maker from pc as t1 left join product as t2 on t1.model = t2.model
	union all
select t1.model ,t2.maker from printer as t1 left join product as t2 on t1.model = t2.model
	union all
select t1.model ,t2.maker from laptop as t1 left join product as t2 on t1.model = t2.model
) as t1
group by maker
order by maker
)
-----------------------------------------------------------------------------------------------------------------------------------
--task7 (lesson4)
--По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
--select * from count_products_by_makers

-----------------------------------------------------------------------------------------------------------------------------------
--task8 (lesson4)
--Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as (
select t1.* from printer as t1 left join product as t2 on t1.model = t2.model where maker not in ('D')
)
--select * from printer_updated
-----------------------------------------------------------------------------------------------------------------------------------
--task9 (lesson4)
--Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя
--(название printer_updated_with_makers)

create view printer_updated_with_makers as (
select t1.* ,t2.maker from printer_updated as t1 left join product as t2 on t1.model = t2.model
)
--select * from printer_updated_with_makers
-----------------------------------------------------------------------------------------------------------------------------------
--task10 (lesson4)
--Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes).
--Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as (
select		class ,count(*) as qty
from		(select		t1.ship ,case when t2."class" is not null then t2."class" else '0' end as class
			from 		outcomes as t1
			left join	ships as t2 on t1.ship = t2."name" where result = 'sunk'
			) as t1
group by	class
)
select * from sunk_ships_by_classes
-----------------------------------------------------------------------------------------------------------------------------------
--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task12 (lesson4)
--Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или
--равно 9 - то 1, иначе 0

create table classes_with_flag as (
select * from classes
)
select *, case when bore >=9 then 1 else 0 end as flag from classes_with_flag
-----------------------------------------------------------------------------------------------------------------------------------
--task13 (lesson4)
--Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task14 (lesson4)
--Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select		count(*)
from 		(select name from Ships union all select ship from Outcomes)  as t1
where 		name like 'O%' or name like 'M%'
-----------------------------------------------------------------------------------------------------------------------------------
--task15 (lesson4)
--Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select		count(*)
from 		(select name from Ships union all select ship from Outcomes) as t1 where name like '% %'
-----------------------------------------------------------------------------------------------------------------------------------
--task16 (lesson4)
--Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

select launched, count(*) from ships group by launched order by launched
-----------------------------------------------------------------------------------------------------------------------------------

--task10 (lesson4)
--Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю
--график (X: category_price, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)