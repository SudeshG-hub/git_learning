SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

 CREATE Proc [dbo].[CollateralValueAutoPopulate_Prod]
@collateralID  bigint   --=4
,@valueDate nvarchar(10)
,@Periodinmonths varchar(10)=''
		--='2021-03-01'

AS

Declare @valueDate1 nvarchar(10)
Declare @valueDate2 Date
--Print @valueDate

SET @valueDate1=SUBSTRING(@valueDate,7,4)+'-'+SUBSTRING(@valueDate,4,2)+'-'+SUBSTRING(@valueDate,1,2)

SET @valueDate2=Convert(Date,@valueDate1)
--Print '@valueDate1'
--Print @valueDate1
--Print '@valueDate2'
--Print @valueDate2
BEGIN

			
			Declare @timekey int=(Select TimeKey from SysDataMatrix where CurrentStatus='C')


			IF Exists (Select 1 from CollateralValueDetails where EffectiveFromTimeKey<=@timekey And EffectiveToTimeKey>=@timekey
						And CollateralID=@collateralID And ValuationDate=@valueDate2)

						BEGIN 

						Select 1 ,'ValueAutoPoPulate' TableName

						END

		ELSE

		BEGIN
			
			Declare @CollateralType as int,@CollateralSubType as int
			
			 SET @CollateralType=( Select CollateralTypeAlt_Key from CollateralMgmt 
									where EffectiveFromTimeKey<=@timekey and EffectiveToTimeKey>=@timekey 
									and CollateralID=@collateralID)
			
			SET @CollateralSubType=( Select CollateralSubTypeAlt_Key from CollateralMgmt 
									where EffectiveFromTimeKey<=@timekey and EffectiveToTimeKey>=@timekey 
									and CollateralID=@collateralID)
			
			
					--Select (Documents+' '+Validritycriteria)ExpiryBusinessRule,ExpirationPeriod,@Periodinmonths Periodinmonths
					--DATEADD(M,ExpirationPeriod,@valueDate2)ValueExpirationDate 
					--,'AutoPopulateDetails' TableName
					--From DimValueExpiration Where EffectiveFromTimeKey<=@timekey and EffectiveToTimeKey>=@timekey
					--And SecurityTypeAlt_Key = @CollateralType
					--And SecuritySubTypeAlt_Key = @CollateralSubType

					select DATEADD(M,Convert(int,@Periodinmonths),@valueDate2)ValueExpirationDate,'AutoPopulateDetails' TableName

					
			
		END

END


GO
