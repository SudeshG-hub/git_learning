SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROC [dbo].[BuyoutCheckerView_01112022]

@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='FnaAdmin',  
@Timekey INT=49999,
@UploadID as Int
WITH RECOMPILE  
AS 


BEGIN

BEGIN TRY  

     
	 SET DATEFORMAT DMY

 
 set  @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
 where A.CurrentStatus='C')

  PRINT @Timekey  

  IF (@MenuID='1466')

  BEGIN
		Select Row_Number() over(order by AUNo) as SrNo ,* from (
		
		Select 
		AUNo
		,PoolName
		,Category
		,SUM(TotalNoofBuyoutParty)TotalNoofBuyoutParty
		,SUM(TotalPrincipalOutstandinginRs)TotalPrincipalOutstandinginRs
		,SUM(TotalInterestReceivableinRs)TotalInterestReceivableinRs
		,SUM(BuyoutOSBalanceinRs)BuyoutOSBalanceinRs
		,SUm(TotalChargesinRs)TotalChargesinRs
		,SUM(TotalAccuredInterestinRs)TotalAccuredInterestinRs
		,Count(1) NoofAccounts
		,Action
		From
		BuyoutSummary_Mod Where --Isnull(AuthorisationStatus,'A') in ('NP','MP') And
		 EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
		And UploadID=@UploadID
		Group By 
		AUNo,PoolName,Category,Action
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
