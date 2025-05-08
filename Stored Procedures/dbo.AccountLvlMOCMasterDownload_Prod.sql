SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CollateralMasterDownload
CREATE PROC [dbo].[AccountLvlMOCMasterDownload_Prod]
As

BEGIN

Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

	

select 
			 MOCTypeName as MOCSource
			 ,'MOCSource' as TableName
			 from dimmoctype
			 where EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey

		
select 
			 SourceName as SourceSystem
			 ,'SourceSystem' as TableName
			 from DIMSOURCEDB
			 where EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey



	


		
			
		
			
			


	END










GO
