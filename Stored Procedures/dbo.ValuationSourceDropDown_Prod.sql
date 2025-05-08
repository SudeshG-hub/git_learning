SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ValuationSourceDropDown_Prod]

AS
	BEGIN

Declare @Timekey Int
Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')

BEGIN

		Select SourceAlt_Key
		,SourceName
		,'ValuationSource' TableName
		from DIMSOURCEDB
		where EffectiveFromTimeKey<=@Timekey
		AND EffectiveToTimeKey>=@Timekey


		Select A.[SecurityTypeAlt_Key] AS CollateralType_AltKey ,B.CollateralTypeDescription as CollateralType,
A.SecuritySubTypeAlt_Key as SecuritySubTypeAlt_Key, C.CollateralSubTypeDescription AS ParameterName,A.[ExpirationPeriod] As PeriodInMonth,
	'ValuationSourceData' TableName
From [DimValueExpiration] A INNER JOIN DimCollateralType B ON A.[SecurityTypeAlt_Key]= B.CollateralTypeAltKey
INNER JOIN DimCollateralSubType C ON A.SecuritySubTypeAlt_Key=C.CollateralSubTypeAltKey

END				

	END
GO
