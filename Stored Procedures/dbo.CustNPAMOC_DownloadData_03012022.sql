SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[CustNPAMOC_DownloadData_03012022]
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
		SET NOCOUNT ON;

		
  --SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 

  --SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 

  
  
SET @Timekey =(Select Timekey from SysDataMatrix Where MOC_Initialised='Y' AND ISNULL(MOC_Frozen,'N')='N') 

		  		  PRINT @Timekey  

		--DECLARE @PageFrom INT, @PageTo INT   
  
		--SET @PageFrom = (@perPage*@Page)-(@perPage) +1  
		--SET @PageTo = @perPage*@Page  

IF (@UploadType='Customer MOC Upload')

BEGIN
		
		--SELECT * FROM(
		SELECT Distinct A.CustomerID,'Details' as TableName,
		UploadID,
		
		B.CustomerName,
		A.AssetClass,
		NPADate,
		SecurityValue,
		AdditionalProvision,
		A.MOCType,
		A.MOCReason,
		A.MOCDate,
		MOCBy,
		MOCSource
		


		FROM CustomerLevelMOC_Mod A
			INNER JOIN CustomerBasicDetail B ON A.CustomerID=B.CustomerID
		WHERE UploadId=@ExcelUploadId
		AND A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey


		

	

END



END

GO
