--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
SELECT		Department ,Employee , Salary
FROM		(select t1.name Employee ,t1.salary ,t2.name Department ,dense_rank() over(partition by departmentId order by salary desc) zzz
			from Employee t1 join Department t2 on t1.departmentId = t2.id
			) t1
where 		zzz <=3
order by 	salary desc
--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select		t1.member_name, t1.status, sum(t2.amount*t2.unit_price) as costs
from 		familyMembers as t1
left join	payments as t2 on t1.member_id = t2.family_member
where 		year(t2.date) = 2005
group by 	t1.member_name, t1.status
--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name from passenger group by name having count(name) > 1
--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
select count(*) as count from student where first_name = 'Anna'
--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(classroom) as count from schedule where date = '2019-09-02'
--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
--дубль
--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select floor(avg(year(current_date) - year(birthday))) as age rom familymembers
--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select		good_type_name, sum(amount*unit_price) as costs
from 		goodtypes
inner join 	goods on good_type_id=type
inner join 	payments on good_id=good
where 		year(date)=2005
group BY	good_type_name
--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
select min(timestampdiff(year,birthday,current_date)) as year from student
--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
SELECT		max(timestampdiff(year, birthday,current_date)) as max_year
FROM		student 
inner join	student_in_class on student.id = student_in_class.student
inner join	class on student_in_class.class = class.id
where 		class.name like '10%'
--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
select		t1.status, t1.member_name, sum(t2.amount * t2.unit_price) as costs
from 		familymembers as t1
inner join	payments as t2 on t1.member_id = t2.family_member
inner join	goods as t3 on t2.good = t3.good_id
inner join	goodtypes as t4 on t3.TYPE = t4.good_type_id
where		good_type_name = 'entertainment'
group by	t1.status, t1.member_name
--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
delete from company
where company.id in
(select company
from		(select		company ,case when qty = min(qty) over () then 1 else 0 end as marker
			from		(select company, count(*) as qty from trip group by company) as t1
			) as t2
where marker = 1
) as t3
--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
select		classroom 
from		schedule
group by	classroom
having 		count(classroom) =	(select count(classroom)
								from Schedule 
								group by classroom
								order by count (classroom) desc
								limit 1)
--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
select		last_name          
from        teacher as t1 
inner join	schedule as t2 on t1.id = t2.teacher
inner join	subject as t3 on t2.subject = t3.id
where 		t3.name = 'Physical Culture'
order by 	t1.last_name
--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
select 		concat(last_name, '.', left(first_name, 1), '.', left(middle_name, 1), '.') as name
from		student
order by 	last_name, first_name

