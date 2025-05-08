SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AccountFlaggingDownloadData]
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

		Select @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
			Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
			 where A.CurrentStatus='C')
		  		  PRINT @Timekey  

		--DECLARE @PageFrom INT, @PageTo INT   
  
		--SET @PageFrom = (@perPage*@Page)-(@perPage) +1  
		--SET @PageTo = @perPage*@Page  

IF (@UploadType='Account Flagging Upload')

BEGIN
		PRINT 'REV'
		--SELECT * FROM(
		SELECT 'Details' as TableName 
		,UploadID
		,ACID
		,Amount
		,Date
		,Action
		------,ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS ROW_NUM
		FROM AccountFlaggingDetails_Mod
		WHERE UploadId=@ExcelUploadId
		AND EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey

		----SELECT 'Summary' as TableName, Row_Number() over(order by PoolID) as SrNo
		----,UploadID
		----,SummaryID
		----,PoolID
		----,PoolName
		----,PoolType
		----,BalanceOutstanding
		----,IBPCExposureAmt
		----,IBPCReckoningDate
		----,IBPCMarkingDate
		----,MaturityDate
		----------,ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS ROW_NUM
		----FROM IBPCPoolSummary_Mod
		----WHERE UploadId=@ExcelUploadId
		----AND EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey

		--)A
		--WHERE ROW_NUM BETWEEN  @PageFrom AND @PageTo
		--ORDER BY ROW_NUM  

END



END
GO
