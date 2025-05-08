SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[CollateralValueEnquireSearchList_Prod]
--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 1  --,
													--,@CustomerID	Varchar(100)	= NULL
													,@TaggingId		Varchar(100)	=	NULL
													--,@UCICID		Varchar(12)	=	NULL
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
					

BEGIN TRY

/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in ( 16,17))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		 A.CollateralID
							,A.CollateralValueatSanctioninRs
							,A.CollateralValueasonNPAdateinRs
							,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,A.SourceName
							,A.ValuationDate
							,A.CurrentValue
							--,A.ExpiryBusinessRule
							--,A.Periodinmonth
							,A.ValuationExpiryDate
							,A.DisplayCollateralFor
							,A.TaggingAlt_Key
							,A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy,	
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
						   ,A.TaggingId
							
                 INTO #temp
                 FROM 
                 (
                     SELECT	A.CollateralID
							,B.CollateralValueatSanctioninRs
							,B.CollateralValueasonNPAdateinRs
							,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,B.SourceName
							,A.ValuationDate
							,A.CurrentValue
							----,B.ExpiryBusinessRule
							--,B.Periodinmonth
							,A.ValuationExpiryDate
							,C.ParameterName AS DisplayCollateralFor
							,B.TaggingAlt_Key
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,(CASE WHEN B.TaggingAlt_Key=1 THEN B.RefCustomerId
							      WHEN B.TaggingAlt_Key=2 THEN  B.RefSystemAcId
								  WHEN B.TaggingAlt_Key=4 THEN B.UCICID
								  END ) TaggingId
						   
                     FROM Curdat.AdvSecurityValueDetail A
					 Inner Join Curdat.AdvSecurityDetail B on  A.CollateralID = B.CollateralID
					 Inner Join DimParameter C on  B.TaggingAlt_Key = C.ParameterAlt_Key AND C.DimParameterName='DimRatingType'
					 WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   AND A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						   
                     UNION ALL
                     SELECT	A.CollateralID
							,B.CollateralValueatSanctioninRs
							,B.CollateralValueasonNPAdateinRs
							,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,B.SourceName	
							,A.ValuationDate
							,A.CurrentValue
							--,B.ExpiryBusinessRule
							--,B.Periodinmonth
							,A.ValuationExpiryDate
							,C.ParameterName AS DisplayCollateralFor
							,B.TaggingAlt_Key
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,(CASE WHEN B.TaggingAlt_Key=1 THEN B.RefCustomerId
							      WHEN B.TaggingAlt_Key=2 THEN  B.RefSystemAcId
								  WHEN B.TaggingAlt_Key=4 THEN B.UCICID
								  END ) TaggingId
						  
                     FROM Dbo.AdvSecurityValueDetail_Mod A
					 Inner Join Curdat.AdvSecurityDetail B on  A.CollateralID = B.CollateralID
					 Inner Join DimParameter C on  B.TaggingAlt_Key = C.ParameterAlt_Key AND C.DimParameterName='DimRatingType'
					WHERE	   B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   AND A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
						  
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Dbo.AdvSecurityValueDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY CollateralID
                     )
                 ) A 
                      
                 
       --          GROUP BY	A.CollateralID
							--,A.CollateralValueatSanctioninRs
							--,A.CollateralValueasonNPAdateinRs
							--,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,A.SourceName
							--,A.ValuationDate
							--,A.CurrentValue
							--,A.ExpiryBusinessRule
							--,A.Periodinmonth
							--,A.ValuationExpiryDate
							--,A.AuthorisationStatus, 
       --                     A.EffectiveFromTimeKey, 
       --                     A.EffectiveToTimeKey, 
       --                     A.CreatedBy, 
       --                     A.DateCreated, 
       --                     A.ApprovedBy, 
       --                     A.DateApproved, 
       --                     A.ModifiedBy, 
       --                     A.DateModified;

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY CollateralID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'CollateralValueEnqury' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A Where   A.TaggingId = @TaggingId
						   --OR A.AccountID = @AccountID		
						   --OR A.UCICID =	@AccountID	)
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END;
             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in (16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT  A.CollateralID
							,A.CollateralValueatSanctioninRs
							,A.CollateralValueasonNPAdateinRs
							,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,B.SourceName
							,A.ValuationDate
							,A.CurrentValue
							--,A.ExpiryBusinessRule
							--,A.Periodinmonth
							,A.ValuationExpiryDate
							,A.DisplayCollateralFor
							,A.TaggingAlt_Key
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,A.TaggingId
						    
							
                 INTO #temp16
                 FROM 
                 (
                     SELECT A.CollateralID
							,B.CollateralValueatSanctioninRs
							,B.CollateralValueasonNPAdateinRs
							,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,B.SourceName
							,A.ValuationDate
							,A.CurrentValue
							--,B.ExpiryBusinessRule
							--,B.Periodinmonth
							,A.ValuationExpiryDate
							,C.ParameterName AS DisplayCollateralFor
							,B.TaggingAlt_Key
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,(CASE WHEN B.TaggingAlt_Key=1 THEN B.RefCustomerId
							      WHEN B.TaggingAlt_Key=2 THEN  B.RefSystemAcId
								  WHEN B.TaggingAlt_Key=4 THEN B.UCICID
								  END ) TaggingId
                     FROM Dbo.AdvSecurityValueDetail_Mod A
					 Inner Join Curdat.AdvSecurityDetail B on  A.CollateralID = B.CollateralID
					 Inner Join DimParameter C on  B.TaggingAlt_Key = C.ParameterAlt_Key AND C.DimParameterName='DimRatingType'
					 WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   AND A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                          -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Dbo.AdvSecurityValueDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY CollateralID
                     )
                 ) A 
                      
                 
       --          GROUP BY A.CollateralID
							--,A.CollateralValueatSanctioninRs
							--,A.CollateralValueasonNPAdateinRs
							--,A.CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,A.SourceName
							--,A.ValuationDate
							--,A.CurrentValue
							--,A.ExpiryBusinessRule
							--,A.Periodinmonth
							--,A.ValuationExpiryDate
							--,A.AuthorisationStatus, 
       --                     A.EffectiveFromTimeKey, 
       --                     A.EffectiveToTimeKey, 
       --                     A.CreatedBy, 
       --                     A.DateCreated, 
       --                     A.ApprovedBy, 
       --                     A.DateApproved, 
       --                     A.ModifiedBy, 
       --                     A.DateModified
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY CollateralID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'CollateralValue' TableName, 
                            *
         FROM
                     (
                         SELECT *
                         FROM #temp16 A where   A.TaggingId = @TaggingId
						   --OR A.AccountID = @AccountID		
						   --OR A.UCICID =	@AccountID	)
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

   END TRY
	BEGIN CATCH
	
	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	SELECT ERROR_MESSAGE()
	--RETURN -1
   
	END CATCH


  
  
    END;


GO
