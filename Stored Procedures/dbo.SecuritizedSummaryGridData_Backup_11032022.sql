SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SecuritizedSummaryGridData_Backup_11032022]
	 @UserLoginId VARCHAR(100)=null
	,@Menuid INT=null
	,@UploadId int=null
	
AS
--DECLARE @Timekey INT=49999
--	,@UserLoginId VARCHAR(100)='FNASUPERADMIN'
--	,@Menuid INT=161
BEGIN
		SET NOCOUNT ON;

    Declare @Timekey int
 Select @Timekey=Max(Timekey) from dbo.SysDayMatrix  
  where  Date=cast(getdate() as Date)
    PRINT @Timekey  

	Select 'SecuritizedData' as TableName, ROW_NUMBER() over(Order by PoolID) as SrNo
			,UploadID
			,SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,NoOfAccount
			,POS
			,SecuritisationExposureAmt
			,Convert(Varchar(20),SecuritisationReckoningDate,103)SecuritisationReckoningDate
			,Convert(Varchar(20),SecuritisationMarkingDate,103)SecuritisationMarkingDate
			--,SecuritisationPortfolio
			,Convert(Varchar(20),MaturityDate,103)MaturityDate 
			,TotalPosBalance
			,TotalInttReceivable
			
			from SecuritizedSummary_stg
	Where UploadID=@UploadId

	exec GetSecuritizedType

END

GO
