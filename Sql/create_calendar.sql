if		object_id ('tempdb..#tab_1') is not null drop table #tab_1
select	*, 0 as 'holidays', datepart(dw, report_date) as 'week_day'
--into	#tab_1
from	calendar2021

update	#tab_1
set		holidays = 1
where	report_date in ('2021-01-01' ,'2021-01-02' ,'2021-01-03', '2021-01-04', '2021-01-05', '2021-01-06', '2021-01-07', '2021-01-08'
,'2021-01-09', '2021-01-10'
,'2021-02-22' ,'2021-02-23' ,'2021-03-08' ,'2021-05-03' ,'2021-05-10' ,'2021-06-14' ,'2021-11-04' ,'2021-11-05' ,'2021-12-31')

select * from #tab_1 where holidays = 1