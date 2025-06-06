SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[SaletoArcACFlaggingSearchList_04052022]
--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 1
													,@MenuID  INT
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
	--SET @Timekey=(SELECT MAX(TIMEKEY) FROM SysDayMatrix where Cast(date as Date)=cast(getdate() as date))

	Declare @Authlevel InT
 
select @Authlevel=AuthLevel from SysCRisMacMenu  
 where MenuId=@MenuID	

  print @menuID
					
					

BEGIN TRY




/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in ( 16,17,20))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey 
                            ,A.CreatedBy 
                            ,A.DateCreated 
                            ,A.ApprovedBy 
                            ,A.DateApproved
                            ,A.ModifiedBy
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.ChangeFields
                 INTO #temp
                 FROM 
                 (
                     SELECT 
							A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,ds.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,isnull(A.AuthorisationStatus,'A') as AuthorisationStatus 
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey 
                            ,A.CreatedBy
                            ,A.DateCreated 
                            ,A.ApprovedBy 
                            ,A.DateApproved
                            ,A.ModifiedBy 
                            ,A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate
							,'' AS ChangeFields
                     FROM	SaletoARCACFlaggingDetail A Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=A.SourceAlt_Key
					 WHERE  A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus,'A') ='A'
                     UNION
                     SELECT A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,ds.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,isnull(A.AuthorisationStatus,'A') as AuthorisationStatus 
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated 
                            ,A.ApprovedBy 
                            ,A.DateApproved
                            ,A.ModifiedBy
                            ,A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							,'' AS ChangeFields
                     FROM	SaletoARCACFlaggingDetail_Mod A Inner join DIMSOURCEDB ds on ds.SourceAlt_Key=A.SourceAlt_Key
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM SaletoARCACFlaggingDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')
                         GROUP BY AccountID
                     )
                 ) A 
                      
                 
                 GROUP BY A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated 
                            ,A.ApprovedBy
                            ,A.DateApproved
                            ,A.ModifiedBy
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.ChangeFields
							

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AccountFlagAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'SaletoARCACFlaggingDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				 order by len(AuthorisationStatus) desc,DateCreated desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END;
             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in (16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus 
                            ,A.EffectiveFromTimeKey 
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy
                            ,A.DateApproved 
                            ,A.ModifiedBy
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate,
							A. ChangeFields
                 INTO #temp16
                 FROM 
                 (
                     SELECT A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,isnull(A.AuthorisationStatus,'A') AuthorisationStatus 
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy
                            ,A.DateApproved
                            ,A.ModifiedBy
                            ,A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							,'' AS ChangeFields
                     FROM SaletoARCACFlaggingDetail_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM SaletoARCACFlaggingDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus,'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY AccountID
                     )
                 ) A 
                      
                 
                 GROUP BY A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy 
                            ,A.DateApproved 
                            ,A.ModifiedBy 
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate,
							A. ChangeFields
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AccountFlagAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'SaletoARCACFlaggingDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp16 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				 order by len(AuthorisationStatus) desc,DateCreated desc

                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

    IF (@OperationFlag =20)
             BEGIN
			 IF OBJECT_ID('TempDB..#temp20') IS NOT NULL
                 DROP TABLE #temp20;
                 SELECT A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy 
                            ,A.DateApproved 
                            ,A.ModifiedBy 
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.ChangeFields
                 INTO #temp20
                 FROM 
                 (
                     SELECT A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							--,isnull(A.AuthorisationStatus,'A') 
							,A.AuthorisationStatus 
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy
                            ,A.DateApproved
                            ,A.ModifiedBy
                            ,A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							,'' AS ChangeFields
                     FROM SaletoARCACFlaggingDetail_Mod A

					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(AuthorisationStatus, 'A') IN('1A')
                           AND A.Entity_Key IN
                     (
                         SELECT MAX(Entity_Key)
                         FROM SaletoARCACFlaggingDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                              -- AND AuthorisationStatus IN('1A')
							  	AND (case when @AuthLevel =2  AND ISNULL(AuthorisationStatus, 'A') IN('1A')
										THEN 1 
							           when @AuthLevel =1 AND ISNULL(AuthorisationStatus,'A') IN ('NP','MP','DP')
										THEN 1
										ELSE 0									
										END
									)=1
                         GROUP BY AccountId
                     )
                 ) A 
                      
                 
                 GROUP BY A.AccountFlagAlt_Key
							,A.SourceAlt_Key
							,A.SourceName
							,A.AccountID
							,A.CustomerID
							,A.CustomerName
							,A.FlagAlt_Key
							,A.AccountBalance
							,A.POS
							,A.InterestReceivable
							,A.ExposureAmount
							,A.AuthorisationStatus
                            ,A.EffectiveFromTimeKey
                            ,A.EffectiveToTimeKey
                            ,A.CreatedBy
                            ,A.DateCreated
                            ,A.ApprovedBy 
                            ,A.DateApproved 
                            ,A.ModifiedBy 
                            ,A.DateModified
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.ChangeFields
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AccountFlagAlt_Key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'SaletoARCACFlaggingDetail' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp20 A
                      ) AS DataPointOwner
                 ) AS DataPointOwner
				 order by len(AuthorisationStatus) desc,DateCreated desc
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

	select *,'SaletoARCAssetMarking' AS tableName from MetaScreenFieldDetail where ScreenName='SaletoARCAssetMarking' 
  
  
    END;
GO
