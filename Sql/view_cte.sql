----------------CTE (common table expression) --------------------------------
With	t0 as (Select P.ProductName, SUM(P.UnitPrice) as 'sum' From Products as P Group by P.ProductName), 
		t1 as (Select O.CustomerID, COUNT(O.OrderID) as 'count' From Orders as O Group by O.CustomerID)
Select * From t0
--------------------------------------------------------------------------------------------------------------
WITH MyReport
	AS		(Select		T.title, IsNull(SUM(S.qty),0) as Total
			From		titles as T Left Join sales as S
						ON T.title_id=S.title_id
			Group by	T.title)

Select		*
From		MyReport
----------------save query View-------------------------------
Create View Mysales
 AS
	select		title, IsNull(SUM(qty),0) as TOtal
	From		titles as T left join sales as S
				on t.title_id=s.title_id
	Where		title like'%a%'
	Group by	title
	Having		SUM(qty)>=30

Select *
from Mysales--Where title like'%a%' AND TOtal>=30
----------------alter query in base View-------------------------------
Alter View Mysales
 AS
	select		title, IsNull(SUM(qty),0) as TOtal
	From		titles as T left join sales as S
				on t.title_id=s.title_id
	Where		title like'%a%'
	Group by	title
	Having		SUM(qty)>=30

----------------Сохранение запроса в базе STORED Procedure (процедура)------
Alter PROCEDURE ListSales_2		@Str varchar(10),               --параметр текста
								@MinQty int = NUL				--параметр суммы
AS			(Select		T.title, IsNull(SUM(S.qty),0) as Total
			From		titles as T Left Join sales as S
						ON T.title_id=S.title_id
			Where		T.title LIKE '%'+@Str+'%'
			Group by	T.title
			Having		Sum(S.qty)>=@MinQty OR @MinQty IS NULL)

--EXECUTE ListSales_2 'a', 0									--вызов процедуры
----------------Сохранение запроса в базе функция (FUNCTION)----------------
Alter FUNCTION ListSales_3		(@Str varchar(10),              --параметр текста
								@MinQty int = NUL				--параметр суммы
								)
	Returns Table												-- что возвращает функция		

AS			
	Return
			(Select		T.title, IsNull(SUM(S.qty),0) as Total
			From		titles as T Left Join sales as S
						ON T.title_id=S.title_id
			Where		T.title LIKE '%'+@Str+'%'
			Group by	T.title
			Having		Sum(S.qty)>=@MinQty OR @MinQty IS NULL)

--Select * From ListSales_3 ('a',0) Where Total<50				--вызов функции
