--task11 (lesson5)
--Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg_price)
--done
---------------------------------------------------------------------------------------------------------------------------
--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
---------------------------------------------------------------------------------------------------------------------------
--task1 (lesson5)
--Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов 
--(не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц
/*
sample:
1 1
2 1
1 2
2 2
1 3
2 3
*/
create view pages_all_products as (
select		(row_number() over(Order by Code DESC)) % ((count(*) over()) / (count(*) over()/2)) + 1 "place"
			,(row_number() over(Order by Code DESC)) % (count(*) over()/2) + 1 as "page"
from		laptop
order by 	page ,place
)
select * from pages_all_products

/*
declare @var1 int
set @var1 = (select count(*)/2 from laptop)

select		* ,row_number() over(partition by page order by page) as 'place'
from		(select * ,nTile(@var1) OVER (Order by Code DESC) as 'page' from laptop) as t1
*/
---------------------------------------------------------------------------------------------------------------------------
--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров
--по типу устройства. Вывод: производитель, тип, процент (%)
CREATE or REPLACE VIEW distribution_by_type_2 as (
with query as(
select 'pc' as "type", count(*) as "qty" from pc
	union all
select 'laptop' as "type", count(*) as "qty" from laptop
	union all
select 'printer' as "type", count(*) as "qty" from printer
)
select		type ,round(100.0 * sum(qty) over (partition by type) / sum(qty) over (), 2) as "percent"
from		query
)
--select * from distribution_by_type_2
---------------------------------------------------------------------------------------------------------------------------
--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущего view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
--done
---------------------------------------------------------------------------------------------------------------------------
--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
create table ships_two_words as (
select * from ships where name like '% %'
)
--select * from ships_two_words
---------------------------------------------------------------------------------------------------------------------------
--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"
select		ship
from		Outcomes
where 		ship not in (select name from ships)
			and ship like 'S%'
---------------------------------------------------------------------------------------------------------------------------
--task6 (lesson5)
--Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
with query as(select t1.*, t2.maker from printer as t1 left join product as t2 on t1.model = t2.model)
select		model
from		(select		model ,maker ,price ,row_number() over(order by price desc) as "top_price"
			from		query
			where		price > (select avg(price) from query where maker = 'D')
			) as t1
where		t1.top_price <=3	
