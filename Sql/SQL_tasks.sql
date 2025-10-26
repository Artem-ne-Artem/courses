--есть таблица с датами и курсом валюты. показать курс на каджую дату, если курс = 0 показать последний в хронологическом порядке != 0
with query AS (
select			*
				,ROW_NUMBER() OVER (Order by Date) as 'RowNumber'
				,ROW_NUMBER() OVER (Partition by Date order by Сurrencies) as 'number'
from			tbl
)

select			cast(Z1.Date as date) as 'Date' /*,Z1.Сurrencies as 'Сurrencies' ,t0.Max as 't0.Max'*/ ,Z3.Сurrencies as 'Cur'
From			query as Z1
Cross Apply		(select		MAX(Z2.RowNumber) as 'Max'
				from		tbl as Z2
				where		Z2.RowNumber <= Z1.RowNumber And Z2.Сurrencies>0) as t0
				Inner join tbl as Z3 ON t0.Max = Z3.RowNumber
where			Z1.number=1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--построить постраничную разбивку всех продуктов (не более двух продуктов на одной странице): все данные из laptop, номер страницы, список всех страниц
/*
sample:
1 1
2 1
1 2
2 2
1 3
2 3
*/

select		*
			,(row_number() over(Order by Code DESC)) % ((count(*) over()) / (count(*) over()/2)) + 1 'place'
			,(row_number() over(Order by Code)) % (count(*) over()/2) + 1 as 'page'
from		laptop
order by 	page ,place

-- variable
declare @var1 int
set @var1 = (select count(*)/2 from laptop)

select		* ,row_number() over(partition by page order by page) as 'place'
from		(select * ,nTile(@var1) OVER (Order by Code DESC) as 'page' from laptop) as t1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--изменить меру у типа "груша" на "т", если цвет "желтый" и мера не "г".
select		t0.id, t0.цвет, t0.тип_id, t0.тип,
			case When [цвет] = 'желтый' and [мера] not in ('г') and t0.тип = 'груша' then 'т' else 'кг' end  'мера_1'
from		(select		a.id, a.цвет, a.тип_id, a.мера, b.тип 
			From		tbl_2 as a
			left join	tbl_3 as b 
			on a.тип_id = b.тип_id
			) t0

--удалить желтые яблоки из таблицы 1
Delete
From		tbl_2
Where		[цвет] = ('желтый') and [тип_id]  in (Select тип_id From tbl_3 Where [тип] = 'яблоко')

--показать на основе таблицы 1 сколько всего весит каждый тип продукта в киллограммах
select		t0.тип, sum(t0.[мера кг]) 
from		(select *, case when [мера]='г' then [«начение]/1000 else [«начение] end as 'мера кг' from tbl_4)t0
group by	t0.тип
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--показать сред стоимость покупки клиентов из центрального региона ("Central"), совершившим первую покупку в январе 2018 года. Результаты предоставить в разбивке по городам
select		t1.CityID_2, AVG(t1.[Purchase price]) as 'AVG Check'
from		(select		O.*, R.Region, IsNull(C.CityID,1) as CityID_2, IsNull(R.Region,'Central') as Region_2
						,ROW_NUMBER () OVER (Partition by O.CustomerID Order by O.OrderDate Asc) as 'RowNumber'
						,(select sum(Quantity * Price) from tbl_Order_List$ as OL where OL.OrderID = O.OrderID) as 'Purchase price'
			from		tbl_Orders$ as O
			left join	tbl_Customers$ as C
						on O.CustomerID = C.CustomerID
			left join	tbl_City_Region$ as R
						on C.CityID = R.CityID
			where		month(O.OrderDate) = 01
						and YEAR(O.OrderDate) = 2018
						and O.DeliveryDays is not Null
						and day(O.OrderDate) + O.DeliveryDays <32
						--and O.CustomerID=3585
			) as t1
where		t1.Region_2='Central'
			and t1.RowNumber=1
group by	t1.CityID_2
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
if object_id ('tempdb..#tbl_t') is not null drop table #tbl_t
CREATE TABLE #tbl_t (snap_date datetime, channel_name nvarchar(25), point_id nvarchar(25), login_z nvarchar(25), serial nvarchar(25), price int)
GO
INSERT INTO #tbl_t (snap_date, channel_name, point_id, login_z, serial, price)
VALUES
('20180101', 'retail', 'A456', 'A1_IVANOV', '074648576857', 15490),
('20180102', 'retail', 'A456', 'A1_IVANOV', '054654645646', 21990),
('20180102', 'retail', 'A456', 'A1_IVANOV', '054654645647', 5000),
('20180103', 'wholesale', 'C987', 'B2_MATVEEV', '056734574745', 2090),
('20180104', 'wholesale', 'Z974', 'C2_PETROV', '056734574777', 3000),
('20180105', 'retail', 'Z974', 'C2_PETROV', '056734574778', 5000),
('20180106', 'retail', 'Z975', 'C2_PETROV', '056734574779', 4660)

if object_id ('tempdb..#tbl_w') is not null drop table #tbl_w
CREATE TABLE #tbl_w (serial nvarchar(25), cost int)
GO
INSERT INTO #tbl_w (serial, cost)
VALUES
('074648576857', 12300),
('054654645646', 19000),
('054654645647', 4000),
('056734574745', 1500),
('056734574777', 2000),
('056734574778', 3000),
('056734574779', 3600)
;

--Таблица #tbl_t содержит подневный факт продаж товара. Каждой продаваемой единице товара принадлежит уникальный серийный номер. 
--Таблица #tbl_w содержит данные по себестоимости товара. Каждой закупаемой единице товара принадлежит уникальный серийный номер. 

--1. Напишите SQL-запрос возвращающий Количество проданного товара и Общую сумму выручки в разрезе Точки продаж за 31 декабря 2018 года. Отсортируйте результат в порядке убывания выручки.
select		point_id
			,count(*) as 'Qty'
			,sum(price) as 'Summ'
from		#tbl_t
where		snap_date = '2018.12.31'
group by	point_id
order by	Summ desc

--2. Напишите SQL-запрос возвращающий список состоящий из Количества продаж и Сотрудников , которые 
--совершили более 2х продаж за период с 1 по31 декабря 2018 года и имеют в наименовании логина приставку "A1_".
	
select		login_z
			,count(*) 'Qty'
from		#tbl_t
where		snap_date between '2018.01.01' and '2018.01.03'
			and login_z like 'A1_%'
group by	login_z
having		count(*) >2

--3. Напишите SQL-запрос возвращающий расчет Мотивации в разрезе каждого Сотрудника в калах продаж ограниченных Розницей и Оптом, где под Мотивационной ставкой подразумевается % от продажи каждой единицы товара: 10% за сумму продажи до 15тыс. и 20% за сумму от 15тыс.
select		distinct login_z
			,sum(case when price <=15000 then price * 0.1 when price >15000 then price * 0.2 end) OVER (partition by login_z) as 'Motivation'
from		#tbl_t
where		channel_name in ('retail', 'wholesale')

--4. Напишите SQL-запрос возвращающий расчет Маржи в разрезе каждой Точки продаж за период 2018 года. Отобразите 10 лучших точек продаж по марже.
select		top(10) *
from		(select		t1.point_id
						,sum(t1.price - w1. cost) as 'GM'
			from		#tbl_t as t1
			left join	#tbl_w as w1
						on t1.serial = w1.serial
			where		year(snap_date) = '2018'
			group by	t1.point_id
			) as MyTable
order by	GM desc
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Вывести сотрудников, у которых средняя премия в 1 квартале 2016г более 2000р
select		e.empname , avg(premium)
from		emp_prem as EP
join		employee as e
			on EP.id_emp=e.Id_emp
			and year(month)=2016
			and MONTH(month) in ('1', '2', '3')
group by	e.empname
having		avg(premium)>2000

--Тем сотрудникам, у которых в данном месяце максимальна, удвоить ее, если премия максимальна у нескольких сотрудников, удвоение не производить
select		*, case when t1.Count_1=1 then t0.premium*2 else t0.premium end as Total_Prem
from		emp_prem as t0
left join	(select month, count(id_emp) as Count_1 from emp_prem group by month) as t1
			on t0.month=t1.month
order by	t0.month asc
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Напишите запрос, который выберет каждую 14-ую запись, упорядоченную по id (результат 1)
select		id
from		(select *, row_number() over(order by id) % 14 as 'Number' from t_Id) as t1
where		t1.Number = 0

select		t1.* 
from		(select *, row_number () over(order by id) as 'row' from t_Id) as t1
where		t1.row % 14 = 0

select		top(1) with ties *
from		t_Id
order by	row_number() over(order by id) % 14
--Напишите запрос, который разобьет упорядоченную по id выборку на 10 одинаковых групп, таких, чтобы каждое из значений id в группе с меньшим номером было строго меньше любого id из группы с большим номером (результат 2)
select		*
			,nTile(10) OVER (Order by id asc) as'nTile'
from		t_Id
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--1 Общую (накопленную) сумму просроченного долга непогашенную (не выплаченную) на момент выгрузки
--2 Дату начала текущей просрочки. Под датой начала просрочки, в данной задаче понимается первая дата непрерывного периода, в котором общая сумма просроченного непогашенного долга > 0.
--3 Кол-во дней текущей просрочки.
Select		t2.Agreement
			,t2.RunningTotal
			,t2.Date
			,DATEDIFF (DAY, t2.Date, GETDATE()) as 'Qty_day_debt'
From		(select		t1.*
						,SUM (t1.Sum) over (Partition by t1.Agreement Order by t1.date asc) as 'RunningTotal'
						,ROW_NUMBER () over (Partition by t1.Agreement order by t1.date desc) as 'Rank'
			from		t_Debt as t1) as t2
Where		t2.Rank = 1
			and t2.RunningTotal <>0
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Посчитать кол-во чеков,  в которых куплено больше 2-х пар любой обуви и есть любой товар из категории туризм
select		count(distinct id_chek)
from		(select		t1.*, t2.category, t2.product
						,sum(t1.qty) over(partition by t2.category, t1.id_chek order by t1.id_chek) as 'zz'
			from		sales as t1
			join		(select * from sales where category in ('обувь', 'туризм')) as t2
						on t1.art = t2.art
			) as t1
where		category = 'обувь' and zz > 2

