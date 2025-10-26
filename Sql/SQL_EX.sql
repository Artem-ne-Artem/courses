--1(1) Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd!!!!!
Select		model, speed, hd
From		PC
Where		Price<500
--2(1) Найдите производителей принтеров. Вывести: maker--
select		distinct maker
From		Product
Where	type='printer'
--3(1)Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
select		model, ram, screen
From		Laptop
Where		price>1000
--4(1) Найдите все записи таблицы Printer для цветных принтеров. 
select		*
From		Printer
where		color='y'
--5(1) Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
select		model, speed, hd
From		PC
Where		price<600 AND cd in ('12x','24x')
--6(1) Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
Select		Distinct maker, L.speed
From		Product as P inner join laptop as L
			ON P.model=L.model
			AND L.hd>=10
--7(1) Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
select		t1.model,t1.price
From		(select	model, price
			From	Laptop
			union
			select	model, price
			From	Printer
			union
			select	model, price
			From	PC) as t1
			inner join Product as P
			ON t1.model=p.model
			And P.maker='b'
--8(1) Найдите производителя, выпускающего ПК, но не ПК-блокноты.
		-- Мое решение верный ответ, неверное число записей (меньше на 2)
		select		*
		From (
		select		p.maker
		From		PC as ps inner join Product as p
					on ps.model=p.model
		except
		select		p.maker
		From		Laptop as l inner join Product as p
					on l.model=p.model
			)
		-- Верное решение
		SELECT maker FROM product WHERE type = 'pc'
		EXCEPT
		SELECT maker FROM product WHERE type = 'laptop'
--9(1) Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker 
		--Подзапрос
		select		distinct maker
		From		Product
		Where		model in	(
								select	model
								From	PC
								Where	model=Product.model
								And speed>=450	 
								)
		--Inner join
		select		distinct maker
		From		Product as P inner join PC as PS
					on p.model=ps.model
					and ps.speed>=450
--10(1) Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
select		model, price
From		Printer
Where		price= 
					(select MAX( price)
					From Printer
					)
--11(1) Найдите среднюю скорость ПК
select		avg(speed)
from		PC
--12(1)  Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол
select	avg(speed)
From	Laptop
where	price>1000
--13(1)  Найдите среднюю скорость ПК, выпущенных производителем A
select		avg(speed)
From		PC As ps inner join Product as P
			on ps.model=p.model
			And p.maker='A'
--14(3) Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем 
--модели являются продуктами одного типа.--Вывести: maker, type 

select		pr.maker, Count(Pr.type)
From		(select		maker, type, count(model) AS Qty_model
			From		Product
			group by	maker, type
			Having		count(model)>1
			) as Pr
Group by	pr.maker

select *
from Product
order by maker asc

SELECT maker
FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT type) = 3

--15(1) Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
select		hd--, count (hd)
From		PC
group by	hd
having		count (hd)>=2

--16(2) Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, 
--т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM. 
select		distinct a.model, b.model, a.speed, a.ram
From		PC as A cross join pc as B
Where		a.speed=b.speed and a.ram=b.ram and a.model>b.model

--17(2) (All)Найдите модели ПК-блокнотов, скорость которых меньше скорости любого из ПК.Вывести: type, model, speed 
select		distinct p.type, l.model, l.code,l.speed
From		Laptop as L cross join Product as P
Where		l.model=p.model
			AND speed< all (select	speed
							from	PC)

--18(2) Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
select		distinct p.maker,price
From		Printer as Pr cross join Product as P
Where		pr.model=p.model
			And pr.color='y'
			And Pr.price in (select min(price)
						from Printer Where color='y')

--19(1) Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
--Вывести: maker, средний размер экрана
select		distinct P.maker, avg(l.screen)
From		Product as P inner join Laptop as l
			on p.model=l.model
group by	p.maker

--20(2) Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК. 
select		distinct maker, count(model)
From		Product
where		type ='pc'
group by	maker
having		count(model)>=3

--21(1) Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
--Вывести: maker, максимальная цена.
select		distinct p.maker, max(price)
From		product as P inner join PC as PS
			ON p.model=ps.model
Group by	p.maker

--22(1) Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. 
--Вывести: speed, средняя цена.
select		distinct speed, AVG(price)
From		PC
Where		Speed>600
Group by	speed
order by	Speed desc

--23(2) Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
--Вывести: Maker
Select		distinct p.maker--, t1.model, t1.speed
From		(select	model, speed
			From	PC
			union
			select	model, speed
			From	Laptop) as t1 inner join Product as P
			ON t1.model=p.model
			AND t1.speed>=750
--24(2)  Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции. 
With CTE as (select	model, price From PC
			union
			select model, price  From Laptop
			union 
			select model, price	From Printer)
Select		model
From		CTE
Where		Price=(select max(price) from CTE)

select		t1.model
From		(select	model, price From PC
			union
			select model, price  From Laptop
			union 
			select model, price	From Printer) as t1
Where		t1.Price=
			(select max(price) from (select	model, price From PC
									union
									select model, price  From Laptop
									union 
									select model, price	From Printer) as t1) 

Select top 1 with ties model 
From		(Select model, price  from PC
			union 
			Select model, price from Laptop
			union
			Select model,price from Printer) as s
order by price desc

--25(3) Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
--имеющих наименьший объем RAM. Вывести: Maker
--Мой вариант Ваш запрос вернул правильные данные на основной базе, но не прошел тест на проверочной базе. Неверное число записей (больше на 3)
select		distinct p.maker
From		Product as p inner join	
									(select		model, max(speed) as Max_Speed
									From		(select * 
												From pc 
												Where ram in 
															(select min(ram) as Min_Ram from PC)
												)as t0
												Group by	model
									) as t1
			on p.model=t1.model
			and type in ('printer', 'pc')
--Вариант Ваш запрос вернул правильные данные на основной базе, но не прошел тест на проверочной базе. Неверное число записей (больше на 3)
select		distinct maker
From		Product 
Where		type='printer'
			AND maker in(Select maker 
						From Product
						Where model in	(Select model
										From	PC
										Where speed=
													(select		max(speed)
													From		(select speed From pc 
																	Where ram =(
																				select min(ram) from PC
																				)
																) as t0
													)
										)
						)

--26(2) Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена. 
select		AVG(t0.price)
From		(
			select		model, price
			From		PC
			UNION all
			select		model, price
			From		Laptop
			) as t0 inner join Product as P
			ON t0.model=P.model
Where		type in ('pc', 'laptop') and maker='a'

--27(2) Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD. 
select		distinct p.maker, avg(hd)
From		PC as Ps inner join Product as P
			ON Ps.model=P.model
			AND p.maker in (Select p.maker From Printer as Pr inner join Product as P On Pr.model=P.model)
Group by	p.maker

Select		Result.maker, avg(Result.hd)
From		(
			SELECT		PC.hd, Product.maker 
			FROM		PC INNER JOIN Product 
						ON PC.model = Product.model
			Where		Product.maker in	
										(
										SELECT Product.maker 
										FROM Product INNER JOIN Printer 
										ON Product.model = Printer.model 
										GROUP BY Product.maker
										)
			) as Result
Group by	Result.maker

--28(1) Используя таблицу Product, определить количество производителей, выпускающих по одной модели. 
Select		count(t1.maker)
From		(Select		distinct maker, count(model) as t0
			From		Product
			Group by	maker
			Having		count(model)=1
			) as t1

--29(3) В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], 
--написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
select		t1.*, I.inc, O.out
From		(select		point, date 
			From		Income_o
			union
			Select		point, date
			From		Outcome_o) as t1 left join Income_o as I
			ON t1.point=I.point AND t1.date=I.date
			left join Outcome_o as O
			ON t1.point=O.point AND t1.date=O.date

Select		Case When i1.point is null then o1.point else i1.point End as point_1,
			Case When i1.date is null then o1.date else i1.date End as date_2,
			inc, out
From		Income_o i1 full join Outcome_o o1
			ON i1.point = o1.point and i1.date = o1.date

--30(3) В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз 
--(первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения 
--операций будет соответствовать одна строка. 
--Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).
Select		t0.*, o.sum_out, i.sum_inc
From		(
			Select *--point, date
			From Income
			union
			Select point, date
			From Outcome
			) as t0 
					left join (Select point, date, sum(inc) as sum_inc From Income Group by point, date) as I
					ON t0.date=i.date and t0.point=I.point
					left join (Select point, date, sum(out) as sum_out From Outcome Group by point, date) as O 
					ON t0.date=O.date and t0.point=O.point

Select		point, date, sum(out) as Out_1, sum(inc) as Inc_1
From		(select		point, date, inc, NULL as out
			From		Income
			Union all
			select		point, date, NULL as inc, out
			From		Outcome) MyTable
Group by	point, date

--31(1) Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну. 
Select		Class, country
From		Classes
Where		bore>=16

--32(3) Одной из характеристик корабля является половина куба калибра его главных орудий (mw). С точностью до 2 десятичных знаков 
--определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных. 
Select		*
From		(select distinct S_1.name, S_1.class, C_1.country, C_1.bore
			From Ships as S_1 left join Classes as C_1 on s_1.class=c_1.class
			union all
			select distinct ship, C_2.class, C_2.country, C_2.bore
			from Outcomes as O left join Classes as C_2 ON O.ship=C_2.class
			left join ships as S_2 ON O.ship=s_2.name left join Classes as C ON s_2.class=C.class
			) as t_name

Select		a.*--country, cast(avg((power(bore,3)/2)) as numeric(6,2)) as weight
from		(select country, classes.class, bore, name from classes left join ships on classes.class=ships.class
			union all
			select distinct country, class, bore, ship from classes t1 left join outcomes t2 on t1.class=t2.ship
			where ship=class and ship not in (select name from ships) ) a
where		name IS NOT NULL group by country

--33(1) Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
Select		Distinct ship
From		Outcomes
Where	battle in ('North Atlantic') and result in ('sunk')

--34(2) По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
--Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей. 
Select		Distinct S.name--, s.launched, C.type, C.displacement 
From		Ships as S left join Classes as C
			ON S.class=C.class
Where		launched>=1922 and C.type='bb' and c.displacement>35000
order by	launched desc

--35(2) В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
--Вывод: номер модели, тип модели. 
Select		model, type
From		product
Where		model not like '%[^0-9]%' or model not like '%[^a-z]%'

--36(2) Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
Select		s.name--, c.class
From		(select	distinct name
			From Ships
			union
			select	distinct ship
			From Outcomes) as s 
			left join Classes as C
			ON s.name=C.class
Where		name in (select class From Classes)

--37(2) Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
Select		t0.class--, count(t0.name)
From		(select	c.class, s.name
			From	Classes as C left join Ships as S ON C.class=S.class
			union
			select	c.class, o.ship
			From	Classes as C left join Outcomes as O ON C.class=O.ship
			) as t0
Group by	t0.class
Having		count(t0.name)<2

--38(1) Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc'). 

Select		country
From		Classes
Where		type = 'bb' 
Intersect
Select		country
From		Classes
Where		type = 'bc'

--39(2) Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, 
--произошедшей позже. 
Select		Ship
From		Outcomes
Where		result = 'damaged'
Intersect
Select		Ship
From		Outcomes
Where		result not in ('damaged')

--40(1) Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. 
Select		S.class, S.name, C.country--, C.numGuns
From		Ships as S inner join Classes as C
			ON S.class=C.class
				AND c.numGuns>=10
order by	class asc

--41(2) Для ПК с максимальным кодом из таблицы PC вывести все его характеристики (кроме кода) в два столбца:
--название характеристики (имя соответствующего столбца в таблице PC);
--значение характеристики
Select	prop, val
From	(Select		code, model, 
					Cast(speed as varchar(50)) as speed, 
					Cast(ram as varchar(50)) as ram, 
					Cast(hd as varchar(50)) as hd, 
					Cast(cd as varchar(50)) as cd, 
					Cast(price as varchar(50)) as price
		from		PC
		Where		code = (Select max(code)
							From PC)
		) as t0
unpivot	(
		val for prop in (model, speed, ram, hd, cd, price)
		) as UnPvt

--42(1) Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены. 
Select		ship, battle
From		Outcomes
where		result = 'sunk'

--43(2) Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. 
Select		Name--, Year(date)
From		Battles
Where		Year(date) in	(Select		Year(date)
							From		Battles
							Except
							Select		launched
							From		Ships
							)

--44(1) Найдите названия всех кораблей в базе данных, начинающихся с буквы R. 
Select	distinct t0.class
From	(select		class
		From		Classes
		union
		select		name
		From		Ships
		union
		select		ship
		From		Outcomes) as t0
Where	t0.class LIKE 'R%'

--45(1) Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
--Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов. 
Select t0.class
from	(select		class
		From		Classes
		union
		select		Ship
		From		Outcomes
		union
		Select		name
		from		Ships) as t0
Where	t0.class like '% % %'

--46(2) Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.
Select		distinct s.name, C.displacement, C.numGuns
From		Ships as S left join Classes as C
			ON S.class=C.class
Where		name in	(Select		ship
					From		Outcomes
					Where		battle = 'Guadalcanal')

Select		O.ship, C.displacement, C.numGuns
From		Outcomes as O left join Ships as S
			ON O.ship=S.name 
			left join Classes as C
			ON S.class=C.class
Where		battle = 'Guadalcanal'

--47(3) Пронумеровать строки из таблицы Product в следующем порядке: имя производителя в порядке убывания числа производимых им моделей 
--(при одинаковом числе моделей имя производителя в алфавитном порядке по возрастанию), номер модели (по возрастанию).
--Вывод: номер в соответствии с заданным порядком, имя производителя (maker), модель (model) 
Select		count (*) over (Order by	t1.CountM desc, t1.maker asc, t1.model asc) as 'no', t1.maker, t1.model 
From		(select		Count (*) Over (partition by Maker) as CountM, maker, model
			From		Product) as t1

--48(2) Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении. 
Select		C.Class--, S.name, O.ship, O.result
From		Classes as C left join Ships as S
			ON C.class=S.class
where		C.class in (Select ship From Outcomes Where result ='sunk')
			OR
			S.name in (Select ship From Outcomes Where result ='sunk')
Group by	C.class

--49(1) Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes). 
Select		s.name
From		Ships as S inner join Classes as C
			ON S.class=C.class
Where		C.bore=16
Union
Select		o.ship
From		Outcomes as O inner join Classes as C
			ON O.ship=C.class
Where		C.bore=16

--50(1) Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships. 
Select		Distinct O.battle
From		Outcomes as O left join Ships as S
			ON O.ship=S.name
Where		S.class='Kongo'
--51(3) Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей такого же водоизмещения 
--(учесть корабли из таблицы Outcomes). НЕ РЕШИЛ
Select		t0.displacement, t0.numGuns, t0.name
From		(Select		S.name, C.numGuns, C.displacement
			From		Ships as S Left join Classes as C
						ON S.class=C.class
			union
			Select		C.class, C.numGuns, C.displacement
			From		Classes as C
			Where		Class in	(Select Ship From Outcomes
									Union
									Select class From Classes)
			) as t0
--52(2) Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
--имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн
Select		S.name
From		Ships as S
Where		S.class in
			(Select		class
			From		Classes
			Where		(country='Japan' or country is NULL)
						AND (type='bb' or type is NULL) 
						AND (numGuns>=9 or numGuns is NULL) 
						AND (displacement<=65000 or displacement is NULL) 
						AND (bore<19 or bore is NULL)
			)
