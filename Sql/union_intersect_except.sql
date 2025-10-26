--UNION
SELECT  Country, City
FROM    Customers
  UNION ALL
SELECT  Country, City
FROM    Employees
ORDER BY Country, City

SELECT  Country, City
FROM    Customers
  UNION  -- без совпадающих строк
SELECT  Country, City
FROM    Employees
ORDER BY Country, City
-----------------------------------------------------------------------------------------------------------------------
--INTERSECT (пересечение)
--города которые есть и в одной и вдругой таблице
select city
from Employees
	intersect
select city
from Customers
-----------------------------------------------------------------------------------------------------------------------
--EXCEPT / EXCEPT ALL (исключение)
--города которые есть в тал "Employees" но нет в талб "Customers"
select city
from Employees
except
select city
from Customers
