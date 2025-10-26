--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������.
--�������: ����� � ����� ����������� ��������.
select		t2.class ,count(*) as qty
from		outcomes as t1
left join	ships as t2 on t1.ship = t2.name
where		t1.result = 'sunk'
group by	t2.class

--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������.
--���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������.
--�������: �����, ���.
select "class" ,launched from ships
where "class" = name
order by "class" ,launched

--�����������. ��� �������� ������ "Bismarck" ��� ������� � ������� "Ships", �� �� ����� ��� ������� � ����������� ���������
--��� �������� � 1941-05-25, ������������ ����� ������������ ��� ���� �� �� ������� ������, �� ����� ������ ����� ��������� � �����������.

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������,
--������� ��� ������ � ����� ����������� ��������.
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

--�����������. ��� 5 ����������� �������� ��� ������

--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� �������� ������ �� �������������
--(������ ������� �� ������� Outcomes).
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

--�����������. � ������� �Classes� ���� ����� �Bismarck�, �� � ������� �Ships� ������ ������� ���.
--���� � ������� �Outcomes� ���� ����������� �������. ����� ������ ��������� ������ �� ������� �Bismarck�.
			
--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� �������
--����������� ����� ���� ��, ������� ���������� ����� RAM. �������: Maker
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
			
			
			
			
			
