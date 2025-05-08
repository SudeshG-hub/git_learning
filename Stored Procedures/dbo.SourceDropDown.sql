SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROC [dbo].[SourceDropDown]

AS
	BEGIN

Declare @Timekey Int
Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')

BEGIN

		Select SourceAlt_Key
		,SourceName
		,'SourceSysList' TableName
		from DIMSOURCEDB
		where EffectiveFromTimeKey<=@Timekey
		AND EffectiveToTimeKey>=@Timekey
END				

	END
GO
