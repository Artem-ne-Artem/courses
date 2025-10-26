--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
select	            case when t2.Grade < 8 then 'NULL' else t1.Name END ,t2.Grade ,t1.Marks 
from        Students as t1
cross join  Grades as t2
where       t1.Marks >= t2.Min_mark and t1.Marks <= t2.Max_mark 
order by    t2.Grade desc, t1.Name asc;
-----------------------------------------------------------------------------------------------------------------------------------
--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
select      doctor, professor, singer, actor
from        (select	row_number() over (partition by occupation order by Name) marker ,name ,occupation 
            from        occupations
            ) as tab 
pivot       (max(name) for occupation in (doctor ,professor, singer, actor)) as pivott
order by    marker
-----------------------------------------------------------------------------------------------------------------------------------
--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem
select distinct city from station where city not like '[aeuio]%'
-----------------------------------------------------------------------------------------------------------------------------------
--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct city from station where city like '%[^aeuio]'
-----------------------------------------------------------------------------------------------------------------------------------
--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct city from station where city like '%[^aeuio]' or city like '[^aeuio]%'
-----------------------------------------------------------------------------------------------------------------------------------
--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct city from station where city like '%[^aeuio]' and city like '[^aeuio]%'
-----------------------------------------------------------------------------------------------------------------------------------
--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name from Employee where salary > 2000 and months < 10 order by employee_id
-----------------------------------------------------------------------------------------------------------------------------------
--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
-- дублирует 1-ю задачу
