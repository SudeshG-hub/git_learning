SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[restructureAssets_DownloadData]
	@Timekey INT
	,@UserLoginId VARCHAR(100)
	,@ExcelUploadId INT
	,@UploadType VARCHAR(50)
	--,@Page SMALLINT =1     
 --   ,@perPage INT = 30000   
AS

----DECLARE @Timekey INT=49999
----	,@UserLoginId VARCHAR(100)='FNASUPERADMIN'
----	,@ExcelUploadId INT=4
----	,@UploadType VARCHAR(50)='Interest reversal'

BEGIN

SET DATEFORMAT DMY
		SET NOCOUNT ON;

		Select @Timekey=Max(Timekey) from dbo.SysDayMatrix  
		  where  Date=cast(getdate() as Date)
		  		  PRINT @Timekey  

		--DECLARE @PageFrom INT, @PageTo INT   
  
		--SET @PageFrom = (@perPage*@Page)-(@perPage) +1  
		--SET @PageTo = @perPage*@Page 
		

IF (@UploadType='Restructure Assets Upload')

BEGIN
		
		--SELECT * FROM(
		SELECT 'Details' as TableName,
		UploadID,
		AccountID,
		RestructureFacility,
		--RevisedBusinessSeg,
		--DisbursementDate,
		--ReferenceDate,
		--InvocationDate,
		--CONVERT(VARCHAR(10),InvocationDate,103) As InvocationDate,
		EquityConversion,
        StatusOfSpecificPeriod,
		--DateofConversionintoEquity,
		--PrinRpymntStartDate,
		--InttRpymntStartDate,
		CONVERT(VARCHAR(10),DateofConversionintoEquity,103) As DateofConversionintoEquity,
		CONVERT(VARCHAR(10),PrinRpymntStartDate,103) As PrinRpymntStartDate,
		CONVERT(VARCHAR(10),InttRpymntStartDate,103) As InttRpymntStartDate,

		--AssetClassatRstrctr,
		--IfNPANPADate,
		--NPAQuarter,
		TypeofRestructuring,
		--CovidMoratoriamMSME,
		--CovidOTRCategory,
		BankingRelationship,
		CONVERT(VARCHAR(10),DateofRestructuring,103) As DateofRestructuring,
		--DateofRestructuring,
		RestructuringApprovingAuth,
		CONVERT(VARCHAR(10),DateofIstDefaultonCRILIC,103) As DateofIstDefaultonCRILIC,
		--DateofIstDefaultonCRILIC,
		ReportingBank,
		--CONVERT(VARCHAR(10),DateofSigningICA,103) As DateofSigningICA,
		----DateofSigningICA,
		OSasondateofRstrctr,
		POSasondateofRstrctr,
		A.InvestmentGrade
		--CreditProvisionRs,
		--DFVProvisionRs,
		--MTMProvisionRs
		--Totalprov as TotalProvisionRs,
		--DateofConversionintoEquity as EquityConversion,
		--SpecifiedPeriodStatus
		FROM RestructureAsset_Upload_Mod A
		 --INNER JOIN  [DBO].[AdvAcBalanceDetail] E ON E.AccountEntityId= A.AccountEntityId
		 --AND E.EffectiveFromTimeKey<=@TimeKey and E.EffectiveToTimeKey>=@TimeKey
		 --LEFT JOIN [PRO].[AdvAcRestructureCal] O ON O.AccountEntityId=A.AccountEntityId
			--		 AND O.EffectiveFromTimeKey<=@TimeKey and O.EffectiveToTimeKey>=@TimeKey
		WHERE UploadId=@ExcelUploadId
		AND A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey

		

	

END

END



GO
