SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CollateralNameDropDown_Prod]

AS

BEGIN

Declare @Timekey Int
Set @Timekey=(Select TimeKey from SysDataMatrix where CurrentStatus='C')


		BEGIN
		
				select SecurityName
				,SecurityAlt_Key
				,'ColDescription' TableName
				from DIMSECURITY
				where EffectiveFromTimeKey<=@Timekey
				AND EffectiveToTimeKey>=@Timekey
		END

END

GO
