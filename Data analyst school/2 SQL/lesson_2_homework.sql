/*
Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля, построенного по данному
проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД. Корабль, давший название классу, 
называется головным.
Classes - содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну,
в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах).
Ships - записаны название корабля, имя его класса и год спуска на воду.
Battles - включены название и дата битвы, в которой участвовали корабли.
Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged или невредим - OK). 
Замечания:
1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships.
2) Потопленный корабль в последующих битвах участия не принимает.
*/
-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
select * from ships where launched > 1920 order by launched 

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
select * from ships where launched > 1920 and launched <= 1942 order by launched

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
select class, count(*) as qty from ships group by class order by class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select class, country from classes where bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select ship from outcomes where battle = 'North Atlantic' and result = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
select		t1.ship --,t1.* ,t2.*
from		Outcomes as t1
left join	Battles as t2 on t1.battle = t2.name
where 		result = 'sunk'
			and t2.date = (select max(date) from Battles as t1 inner join Outcomes as t2 on t1.name = t2.battle where result = 'sunk')
--Комментарий. Т.к. в послед. дату битвы (где был потоплен хоть один корабль), было потоплено 2 корабля, и мы не знаем кого потопили раньше, значит выводим обоих.
			
-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
select		t1.ship ,t3.class
from		Outcomes as t1
left join	Battles as t2 on t1.battle = t2.name
left join	Ships as t3 on t1.ship = t3."name" 
where 		result = 'sunk'
			and t2.date = (select max(date) from Battles as t1 inner join Outcomes as t2 on t1.name = t2.battle where result = 'sunk')
--Комментарий. По данным кораблям нет класса, см. Замечания п.1
			
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
select		t1.ship ,t2.class
from		Outcomes as t1
left join	Ships as t2 on t1.ship = t2.name
left join	classes as t3 on t2."class" = t3."class" 
where 		t1.result = 'sunk' and t3.bore >= 16
--Комментарий. Возвращает пустую таблицу. Т.к. данные о классе/калибре есть только по одному потопленному кораблю (и у него калибр < 16)

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select class from classes where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select		t1.class ,t2."name"
from		classes as t1
left join	ships as t2
			on t1."class" = t2."class" 
where		t1.country = 'USA'
order by	t1.class ,t2."name"



