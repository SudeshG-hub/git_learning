SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--=======================================================
--Created By   :-LIPSA
--Created Date :-07/05/2022
--=======================================================
CREATE PROCEDURE [dbo].[Rpt-Month]

@Year Varchar(20)
AS

--drop table if exists #A

--DECLARE
--@Year Varchar(20)='2022'

SELECT Distinct DATENAME(MM,DATE) MonthName,DATEPART(MM,DATE) orderby
--into #A
FROM   SysDayMatrix 
WHERE TimeKey<=(SELECT TimeKey FROM   SysDataMatrix Where CurrentStatus='C')
----Date<=GetDate()
      AND Year(Date)=@Year
ORDER BY orderby DESC


--Select * from #A ORDER BY orderby DESC
GO
