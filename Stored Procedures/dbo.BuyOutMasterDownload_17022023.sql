SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--CollateralMasterDownload
create PROC [dbo].[BuyOutMasterDownload_17022023]
As

BEGIN

Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

	select SchemeCode,SchemeCodeDescription,'SchemeCode' as TableName
	from DimBuyoutSchemeCode


	where EffectiveFromTimeKey<=@TimeKey
	AND EffectiveToTimeKey >=@TimeKey
	order by SchemeCodeAltKey

	--select  ParameterAlt_Key
	--	,ParameterName
	--	,'SeniorityOfChargeMaster' as TableName 
	--	from DimParameter A where DimParameterName='DimSeniorityOfCharge'
	--	AND A.EffectiveFromTimeKey<=@TimeKey
	--AND A.EffectiveToTimeKey >=@TimeKey

		

		
			
		
			
			


	END



GO
