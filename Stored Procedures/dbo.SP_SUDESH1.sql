SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_SUDESH1]
as


Create table #Employee(
  EmpID INT IDENTITY(1,1) NOT NULL ,
  Ename VARCHAR (30),
  Age INT)

  INSERT INTO #Employee values ('ANeesh',23) , ('priteshh',25)
  select * from #Employee
GO
