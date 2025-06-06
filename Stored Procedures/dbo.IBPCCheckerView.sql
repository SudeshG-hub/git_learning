SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[IBPCCheckerView]

@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='FnaAdmin',  
@Timekey INT=49999,
@UploadID as Int
WITH RECOMPILE  
AS 


BEGIN

BEGIN TRY  

     
	 SET DATEFORMAT DMY

 
 Select   @Timekey=Max(Timekey) from sysDayMatrix where Cast(date as Date)=cast(getdate() as Date)

  PRINT @Timekey  

  IF (@MenuID='1458')

  BEGIN
		Select Row_Number() over(order by PoolID) as SrNo ,
		 UploadID
		,PoolID
		,PoolName
		,PoolType
		,NoofAccounts
		,BalanceOutstanding
		,IBPCExposureAmt
		,Convert(varchar(20),IBPCReckoningDate,103) IBPCReckoningDate
		,Convert(varchar(20),IBPCMarkingDate,103) IBPCMarkingDate
		,Convert(varchar(20),MaturityDate,103) MaturityDate
			,TotalPosBalance
			,TotalInttReceivable
		 from (
		
		Select 
		 UploadID
		,PoolID
		,PoolName
		,PoolType
		--,Count(1) NoofAccounts
		--,SUM(BalanceOutstanding)BalanceOutstanding
		--,SUM(IBPCExposureAmt)IBPCExposureAmt
		--,MAx(IBPCReckoningDate)IBPCReckoningDate
		--,MAx(IBPCMarkingDate)IBPCMarkingDate
		--,Max(MaturityDate)MaturityDate
		--,SUM(TotalPosBalance)TotalPosBalance
		--,SUM(TotalInttReceivable)TotalInttReceivable
		,NoOfAccount as NoofAccounts
		,BalanceOutstanding
		,IBPCExposureAmt
		,IBPCReckoningDate
		,IBPCMarkingDate
		,MaturityDate
		,TotalPosBalance
		,TotalInttReceivable
		From
		IBPCPoolSummary_Mod Where --Isnull(AuthorisationStatus,'A') in ('NP','MP') And
		 EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
		And UploadID=@UploadID
		)A

	END
End Try
BEGIN CATCH
	

	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()


END CATCH

END
  
GO
