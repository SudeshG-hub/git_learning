SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ExceptionalDegrationCustomerFlagDropDown_Prod]

AS
	BEGIN

Declare @Timekey Int,@CustomerACID  varchar (50)
Set @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C')

BEGIN

		Select		[ParameterAlt_Key]
					,ParameterName
					,'DegrationFlag' as TableName
		from		DimParameter A
		where		[DimParameterName] = 'UploadFLagType'
		AND			ParameterName iN ('TWO','Fraud Committed')--,'Restructure','Benami Loans','Sub Lending','Absconding','IBPC','Securitization','PUI','SaletoARC','SMA-0','RP (Resolution Plan)')
		and			A.EffectiveFromTimeKey<=@Timekey
		and			A.EffectiveToTimeKey>=@Timekey

		Exec [SourceSystemDropDown]
END				

	END

	

GO
