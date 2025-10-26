--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях.
--Вывести: класс и число потопленных кораблей.
select		t2.class ,count(*) as qty
from		outcomes as t1
left join	ships as t2 on t1.ship = t2.name
where		t1.result = 'sunk'
group by	t2.class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
--Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса.
--Вывести: класс, год.
select "class" ,launched from ships
where "class" = name
order by "class" ,launched

--Комментарий. Для кораблей класса "Bismarck" нет данныйх в таблице "Ships", но мы знаем что корабль с одноименныи названием
--был потоплен в 1941-05-25, теоретически можно использовать эту дату за не имением других, но такой подход нужно обсуждать с заказчиками.

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных,
--вывести имя класса и число потопленных кораблей.
with query as (
select		t1.name ,t2.class ,t3.result ,case when t3.result = 'sunk' then 1 else 0 end as flag
from		(select name from Ships union all select ship from Outcomes) t1
left join	Ships as t2 on t1.name = t2.name
left join	Outcomes as t3 on t1.name = t3.ship
)
select		t1.class ,sum(t1.flag) as flag
from		query as t1
left join	(select class ,count(*) as qty from query group by class) as t2 on t1.class = t2.class
where		t1.result = 'sunk'
group by	t1.class

--Комментарий. Для 5 потопленных кораблей нет класса

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения
--(учесть корабли из таблицы Outcomes).
with query as (
select		t1.name ,t2.class ,t3.numGuns ,t3.displacement
from		(select name from Ships union select ship from Outcomes) t1
left join	Ships as t2 on t1.name = t2.name
left join	Classes as t3 on t2.class = t3.class
where		t2.class is not null
	UNION
select		t1.ship ,t2.class ,t2.numGuns ,t2.displacement
from		(select ship from Outcomes where ship = 'Bismarck') t1
left join	Classes as t2 on t1.ship = t2.class
)
select		t1.name --,t1.class ,t1.numGuns ,t1.displacement 
from		query as t1
inner join	(select displacement ,max(numGuns) as max_numGuns from query group by displacement) as t2
			on t1.numGuns = t2.max_numGuns
			and t1.displacement = t2.displacement
order by	t1.displacement

--Комментарий. В таблице “Classes” есть класс “Bismarck”, но в таблице “Ships” такого корабля нет.
--Зато в таблице “Outcomes” есть одноименный корабль. Итого руками добавляем данные по кораблю “Bismarck”.
			
--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым
--процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with query as (
select		model
from		pc
where		ram in (select min(ram) from pc)
			and speed in (select max(speed) from pc where ram in (select min(ram) from pc))
)
select		distinct maker
from		product
where		maker in (select distinct maker from product where type = 'Printer')
			and model in (select model from query)			
			
			
			
			
			
