--------------Переменная------------
DECLARE @Var1 int
SET @Var1=5
select @Var1*2
--------------Переменная + IF + Else------------
DECLARE @Var1 int
SET @Var1=5
If @Var1>6
	Select 'A'
Else
	Select 'B'
