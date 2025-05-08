SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[CollateralMasterDownload_Prod]
As

BEGIN

Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

	select CollateralTypeAltKey,CollateralTypeDescription,'CollateralType' as TableName
	from DimCollateralType
	where EffectiveFromTimeKey<=@TimeKey
	AND EffectiveToTimeKey >=@TimeKey
	order by CollateralTypeID

	select B.CollateralTypeAltKey,B.CollateralTypeDescription, A.CollateralSubTypeAltKey,A.CollateralSubTypeDescription,'CollateralSubType' as TableName from DimCollateralSubType A
		INNER JOIN DimCollateralType B
		ON A.CollateralTypeAltKey=B.CollateralTypeAltKey
	where A.EffectiveFromTimeKey<=@TimeKey
	AND A.EffectiveToTimeKey >=@TimeKey

		Select CollateralChargeTypeAltKey,
		CollChargeDescription,'ChargeType' as TableName from DimCollateralChargeType
		where EffectiveFromTimeKey<=@TimeKey
	     AND EffectiveToTimeKey >=@TimeKey

		  Select SecurityChargeTypeCode,
		   SecurityChargeTypeName,'ChargeNature' as TableName from DimSecurityChargeType
			where SecurityChargeTypeGroup='COLLATERAL' AND  EffectiveFromTimeKey<=@TimeKey
			AND EffectiveToTimeKey >=@TimeKey

			Select CollateralOwnerTypeAltKey,
			CollOwnerDescription,'CollateralOwnerType' as TableName from DimCollateralOwnerType
			where EffectiveFromTimeKey<=@TimeKey
			AND EffectiveToTimeKey >=@TimeKey

			Select  B.CollateralTypeDescription,A.ValueExpirationAltKey,
			A.Documents ,'ExpiryBusinessRulee' as TableName from DimValueExpiration A
			INNER JOIN DimCollateralType B ON A.SecurityTypeAlt_Key=B.CollateralTypeAltKey
			where A.EffectiveFromTimeKey<=@TimeKey
			AND A.EffectiveToTimeKey >=@TimeKey and A.ValueExpirationAltKey not in ('6','8')
			
		
			
			


	END

GO
