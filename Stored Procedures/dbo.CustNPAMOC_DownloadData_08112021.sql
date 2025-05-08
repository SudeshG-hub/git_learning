SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[CustNPAMOC_DownloadData_08112021]
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

		
  SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 

  SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 

		  		  PRINT @Timekey  

		--DECLARE @PageFrom INT, @PageTo INT   
  
		--SET @PageFrom = (@perPage*@Page)-(@perPage) +1  
		--SET @PageTo = @perPage*@Page  

IF (@UploadType='Customer MOC Upload')

BEGIN
		
		--SELECT * FROM(
		SELECT Distinct CustomerID,'Details' as TableName,
		UploadID,
		CustomerID,
		B.CustomerName,
		AssetClass,
		NPADate,
		SecurityValue,
		AdditionalProvision,
		A.MOCType,
		A.MOCReason,
		MOCDate,
		MOCBy,
		MOCSource
		


		FROM CustomerLevelMOC_Mod A
		INNER JOIN PRO.CustomerCal_Hist B ON A.CustomerID=B.RefCustomerID
		WHERE UploadId=@ExcelUploadId
		AND A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey


		

	

END



END











GO
