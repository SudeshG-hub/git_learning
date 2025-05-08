SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[CollateralSubTypeDropDown_Prod]

  
AS
  BEGIN

  Declare @TimeKey as Int 

	Set @TimeKey = (Select Timekey from SysDataMatrix where CurrentStatus='C')

BEGIN TRY
 --BEGIN TRANSACTION
		
		Select 
		CollateralTypeAltKey
		,CollateralTypeID
		,CollateralType
		,CollateralTypeDescription
		,'CollateralType' TableName
		from DimCollateralType 
		Where EffectiveFromTimeKey<=@TimeKey
		And EffectiveToTimeKey>=@TimeKey


END TRY
   BEGIN CATCH
	--ROLLBACK TRAN

	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	SELECT ERROR_MESSAGE()
	RETURN -1


  END CATCH

 END

	
GO
