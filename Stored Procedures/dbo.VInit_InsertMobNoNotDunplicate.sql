SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[VInit_InsertMobNoNotDunplicate] (@mobnumber varchar(10) ='9284594670')
AS
BEGIN
DECLARE @isvalid bit = 0 
	IF(@mobnumber IS NOT NULL AND LEN(@mobnumber) = 10 AND SUBSTRING(@mobnumber,0,1) <> 0 )
BEGIN

--INSERT STATEMENT HERE
SET @isvalid=1
 insert into #A Values (@mobnumber)
END
SELECT @isvalid
END
 
--exec VInit_InsertMobNoNotDunplicate '9284594677'
GO
