SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GLProductNameDroDown_Prod]



AS

	BEGIN

Declare @Timekey as Int

Set @Timekey= (select Timekey from SysDataMatrix where currentstatus='C')

	 BEGIN
		
		select 
		ProductName
		,ProductCode
		,'ProductNameList' AS TableName
		from DimProduct 
		where EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey
		
		
		END

END
GO
