SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ExceptionalDegrationCustomerDropDown]

AS
	BEGIN

Declare @Timekey Int
Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')

BEGIN

		Select	[CustomerACID]
					,[CustomerId]
				    ,[CustomerName]
		from		[CurDat].[AdvAcBasicDetail] A
		Inner Join	[CurDat].[CustomerBasicDetail] B On A.[CustomerEntityId]=B.[CustomerEntityId]	
		where		A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey
		and			B.EffectiveFromTimeKey<=@Timekey
		and			B.EffectiveToTimeKey>=@Timekey
END				

	END
GO
