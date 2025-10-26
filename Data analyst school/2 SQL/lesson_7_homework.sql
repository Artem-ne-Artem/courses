--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7).
-- В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/
select email from person group by email having count(*) > 1
---------------------------------------------------------------------------------------------------------------------------
--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
select t1.name Employee from Employee t1, Employee t2 where t1.managerId = t2.id and t1.salary > t2.salary
---------------------------------------------------------------------------------------------------------------------------
--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select  score, dense_rank () over (order by score desc) rank from  Scores
---------------------------------------------------------------------------------------------------------------------------
--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select t1.firstname ,t1.lastName ,t2.city ,t2.state from Person t1 left join Address t2 on t1.personId = t2.personId