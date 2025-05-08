SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create PROC [dbo].[CalypsoCustomerlevelSearchdetails_08102022]
			
				@CustomerID varchar(30)=''

AS
	BEGIN

Declare @Timekey int
SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

select  T.IssuerID  as CustomerID
	   ,T.IssuerName as CustomerName
	   ,d.AssetClass
	   ,d.NPADate
	   ,d.SecurityValue
	   ,d.AdditionalProvision
	   ,C.ParameterName as FraudAccountFlag
	   ,d.FraudDate
	   ,'CalypsoCustomerLevelMOC' as TableName
 from  CalypsoCustomerLevelMOC D

INNER  JOIN InvestmentIssuerDetail  T  ON T.IssuerID=d.Customerid
AND  T.EffectiveFromTimeKey<=@Timekey
AND T.EffectiveToTimeKey >= @Timekey 

Left join (select parametername,parameteralt_key from Dimparameter where dimparametername='dimyesno'
AND EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey) C
ON D.FraudAccountFlagAlt_Key=C.ParameterAlt_Key

Where T.EffectiveFromTimeKey<=@Timekey
AND T.EffectiveToTimeKey>=@Timekey
AND T.IssuerID=@CustomerID

UNION

select a.CustomerID  as CustomerID
	   ,a.CustomerName as CustomerName
	   ,d.AssetClass
	   ,d.NPADate
	   ,d.SecurityValue
	   ,d.AdditionalProvision
	   ,C.ParameterName as FraudAccountFlag
	   ,d.FraudDate
	   ,'CalypsoCustomerLevelMOC' as TableName
 from  CalypsoCustomerLevelMOC D

inner join curdat.DerivativeDetail A
on D.Customerid=A.CustomerId
AND A.EffectiveFromTimeKey<=@Timekey
AND A.EffectiveToTimeKey>=@Timekey


Left join (select parametername,parameteralt_key from Dimparameter where dimparametername='dimyesno'
AND EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey) C
ON D.FraudAccountFlagAlt_Key=C.ParameterAlt_Key

Where A.EffectiveFromTimeKey<=@Timekey
AND A.EffectiveToTimeKey>=@Timekey
AND A.CustomerID=@CustomerID


END






GO
