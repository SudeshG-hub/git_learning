SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--=======================================================
--Created By   :-LIPSA
--Created Date :-07/05/2022
--=======================================================
CREATE PROCEDURE [dbo].[Rpt-Year]

AS

--drop table if exists #A

SELECT Distinct YEAR(DATE) YearName
--into #A
FROM   SysDayMatrix Where Date<=GetDate() AND Date>'2020-12-31'
Order by YearName DESC


--select * from #A
GO
