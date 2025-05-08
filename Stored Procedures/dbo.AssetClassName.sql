SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[AssetClassName]

AS
BEGIN

Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

	select AssetClassName
	from DimAssetClass
	where EffectiveFromTimeKey<=@TimeKey
	AND EffectiveToTimeKey >=@TimeKey

	END
GO
