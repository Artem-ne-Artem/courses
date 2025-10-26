--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing
-----------------------------------------------------------------------------------------------------------------------------------
--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop).
--�������: model, maker, type

select model, maker ,"type" from product
-----------------------------------------------------------------------------------------------------------------------------------
--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� �������
--PC - "1", � ��������� - "0"

select *, case when price > (select avg(price) from pc) then 1 else 0 end as flag from printer
-----------------------------------------------------------------------------------------------------------------------------------
--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

--��� 1
select		t1.name
from 		(select name from Ships union select ship from Outcomes) as t1
left join 	ships as t2 on t1.name = t2.name
where		t2.class is null

--��� 2
with query as (select name from Ships union select ship from Outcomes)
select name from query where name not in (select distinct name from ships)
-----------------------------------------------------------------------------------------------------------------------------------
--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.

with t0 as
(select distinct launched from Ships)
select * from Battles where extract (year from date) <> all (select launched from t0)
-----------------------------------------------------------------------------------------------------------------------------------
--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select		t1.battle
from		Outcomes as t1 
inner join	(select name from Ships where class = 'Kongo') as t2 on t1.ship = t2.name
-----------------------------------------------------------------------------------------------------------------------------------
--task1  (lesson4)
--������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������,
--���� ��������� ������ > 300. �� view ��� �������: model, price, flag

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
--������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������,
--���� ��������� ������ c������ . �� view ��� �������: model, price, flag

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
--������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'.
--������� model

with query as (
select * from printer as t1
left join product as t2 on t1.model  = t2.model
)
select model from query where maker = 'A' and price > (select avg(price) from query where maker in ('D', 'C'))
-----------------------------------------------------------------------------------------------------------------------------------
--task4 (lesson4)
--������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'.
--������� model

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
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

select avg(price) from 
(select model ,price from pc where model in (select model from product where maker = 'A')
	union
select model ,price from laptop where model in (select model from product where maker = 'A')
	union
select model ,price from printer where model in (select model from product where maker = 'A')
) as t1
-----------------------------------------------------------------------------------------------------------------------------------
--task6 (lesson4)
--������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������.
--�� view: maker, count
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
--�� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
--select * from count_products_by_makers

-----------------------------------------------------------------------------------------------------------------------------------
--task8 (lesson4)
--������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

create table printer_updated as (
select t1.* from printer as t1 left join product as t2 on t1.model = t2.model where maker not in ('D')
)
--select * from printer_updated
-----------------------------------------------------------------------------------------------------------------------------------
--task9 (lesson4)
--������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� �������������
--(�������� printer_updated_with_makers)

create view printer_updated_with_makers as (
select t1.* ,t2.maker from printer_updated as t1 left join product as t2 on t1.model = t2.model
)
--select * from printer_updated_with_makers
-----------------------------------------------------------------------------------------------------------------------------------
--task10 (lesson4)
--�������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes).
--�� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

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
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task12 (lesson4)
--�������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ���
--����� 9 - �� 1, ����� 0

create table classes_with_flag as (
select * from classes
)
select *, case when bore >=9 then 1 else 0 end as flag from classes_with_flag
-----------------------------------------------------------------------------------------------------------------------------------
--task13 (lesson4)
--�������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task14 (lesson4)
--�������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

select		count(*)
from 		(select name from Ships union all select ship from Outcomes)  as t1
where 		name like 'O%' or name like 'M%'
-----------------------------------------------------------------------------------------------------------------------------------
--task15 (lesson4)
--�������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select		count(*)
from 		(select name from Ships union all select ship from Outcomes) as t1 where name like '% %'
-----------------------------------------------------------------------------------------------------------------------------------
--task16 (lesson4)
--�������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

select launched, count(*) from ships group by launched order by launched
-----------------------------------------------------------------------------------------------------------------------------------

--task10 (lesson4)
--������������ �����: �� ���� products_price_categories_with_makers �� ������� �� ������� �������������
--������ (X: category_price, Y: count)

-----------------------------------------------------------------------------------------------------------------------------------
--task11 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� A & D ������ (X: category_price, Y: count)