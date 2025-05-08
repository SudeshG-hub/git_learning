SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[IBPCFlagDropDown_Backup_11032022]

AS
	BEGIN

Declare @Timekey Int,@CustomerACID  varchar (50)
--Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')
Set @Timekey =(Select TimeKey from SysDayMatrix where Date=Cast(Getdate() as Date))
BEGIN

		Select	Distinct PoolID
					,PoolName
					,'PoolList' as TableName
		from		IBPCFinalPoolSummary A
		where A.EffectiveFromTimeKey<=@Timekey
		and	A.EffectiveToTimeKey>=@Timekey
		

END				

	END
GO
