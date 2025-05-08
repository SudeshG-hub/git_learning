SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sp_TrainingSQL]
AS

select '3' + '1'


--select * from  #A

--drop table #A

--select 1  as A into ##A
--UNION ALL select 1 UNION ALL select 1 UNION ALL select 1 UNION ALL select 1
--select 1,1,1 as B into #B
--select * from ##A
--select * from #B

--select 1  as B into #B
--UNION ALL select 1 UNION ALL select 1 

--select count(1) from #A A INNER JOIN #B B On A.A = B.B
--select count(1) from #A A LEFT JOIN #B B On A.A = B.B
--select count(1) from #A A RIGHT JOIN #B B On A.A = B.B
--select count(1) from #A A CROSS JOIN #B B On A.A = B.B
--select count(1) from #A A OUTER JOIN #B B On A.A = B.B

--select DATEADD(dd,15,'02-01-2025')
GO
