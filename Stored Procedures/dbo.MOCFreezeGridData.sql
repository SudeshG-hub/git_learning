SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [dbo].[MOCFreezeGridData]

--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 2
													,@MenuID  INT  =14569
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')

Declare @Authlevel InT
 
select @Authlevel=AuthLevel from SysCRisMacMenu  
 where MenuId=@MenuID	
 --select * from 	SysCRisMacMenu where menucaption like '%Product%'				

BEGIN TRY

/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in (16,17,20))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		
							A.Freeze_MOC_Date, 
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
                            A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date
                 INTO #temp
                 FROM 
                 (
                     SELECT 
							
							Convert(Varchar(20),A.Freeze_MOC_Date,103) as Freeze_MOC_Date,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy  as FreezeBy, 
                            Convert(Varchar(20),A.DateCreated,103) as Date_of_freeze, 
                            A.ApprovedBy as ApprovedBySecondLevel, 
                            Convert(Varchar(20),A.DateApproved,103) as DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified
							,B.ApprovedByFirstLevel
							,Convert(Varchar(20),B.DateApprovedFirstLevel,103) DateApprovedFirstLevel
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(B.ApprovedByFirstLevel,B.CreatedBy) as CrAppBy
							,ISNULL(B.DateApprovedFirstLevel,B.DateCreated) as CrAppDate
							,ISNULL(B.ApprovedByFirstLevel,B.ModifiedBy) as ModAppBy
							,ISNULL(B.DateApprovedFirstLevel,B.DateModified) as ModAppDate
							, Convert(Varchar(20),A.MOC_Initialized_Date,103) MOC_Initialized_Date
                     FROM MOCFreezeDetails A
					 LEFT JOIN MOCFreezeDetails_Mod B ON A.Freeze_MOC_Date=B.Freeze_MOC_Date And B.EffectiveFromTimeKey <= @TimeKey AND B.EffectiveToTimeKey >= @TimeKey
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
                     UNION
                     SELECT Convert(Varchar(20),A.Freeze_MOC_Date,103) as Freeze_MOC_Date,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy  as FreezeBy, 
                            Convert(Varchar(20),A.DateCreated,103) as Date_of_freeze, 
                            A.ApprovedBy as ApprovedBySecondLevel, 
                            Convert(Varchar(20),A.DateApproved,103) as DateApprovedSecondLevel,
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified
							,A.ApprovedByFirstLevel
							,Convert(Varchar(20),A.DateApprovedFirstLevel,103) DateApprovedFirstLevel
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							, Convert(Varchar(20),A.MOC_Initialized_Date,103) MOC_Initialized_Date
                     FROM MOCFreezeDetails_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM MOCFreezeDetails_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY A.Freeze_MOC_Date, 
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
                            A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date;

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY Date_of_freeze) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'MOCFreezeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner ORDER BY Freeze_MOC_Date DESC
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END;
             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in(16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT 
							A.Freeze_MOC_Date,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
							A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date
                 INTO #temp16
                 FROM 
                 (
                     SELECT Convert(Varchar(20),A.Freeze_MOC_Date,103) as Freeze_MOC_Date,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy  as FreezeBy, 
                            Convert(Varchar(20),A.DateCreated,103) as Date_of_freeze, 
                            A.ApprovedBy as ApprovedBySecondLevel, 
                            Convert(Varchar(20),A.DateApproved,103) as DateApprovedSecondLevel,  
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified
							,A.ApprovedByFirstLevel
							,Convert(Varchar(20),A.DateApprovedFirstLevel,103) DateApprovedFirstLevel
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							, Convert(Varchar(20),A.MOC_Initialized_Date,103) MOC_Initialized_Date
                     FROM MOCFreezeDetails_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM MOCFreezeDetails_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
							    GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY	A.Freeze_MOC_Date,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
                            A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date


                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY Date_of_freeze) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'MOCFreezeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp16 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

   Else

   IF (@OperationFlag =20)
             BEGIN
			 IF OBJECT_ID('TempDB..#temp20') IS NOT NULL
                 DROP TABLE #temp20;
                 SELECT		A.Freeze_MOC_Date,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
                            A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date
                 INTO #temp20
                 FROM 
                 (
                     SELECT Convert(Varchar(20),A.Freeze_MOC_Date,103) as Freeze_MOC_Date,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy  as FreezeBy, 
                            Convert(Varchar(20),A.DateCreated,103) as Date_of_freeze, 
                            A.ApprovedBy as ApprovedBySecondLevel, 
                            Convert(Varchar(20),A.DateApproved,103) as DateApprovedSecondLevel,  
                            A.ModifiedBy, 
                            Convert(Varchar(20),A.DateModified,103) DateModified
							,A.ApprovedByFirstLevel
							,Convert(Varchar(20),A.DateApprovedFirstLevel,103) DateApprovedFirstLevel
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedByFirstLevel,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedByFirstLevel,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApprovedFirstLevel,A.DateModified) as ModAppDate
							, Convert(Varchar(20),A.MOC_Initialized_Date,103) MOC_Initialized_Date
                     FROM MOCFreezeDetails_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM MOCFreezeDetails_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               --AND AuthorisationStatus IN('1A')
							   AND (case when @AuthLevel =2  AND ISNULL(AuthorisationStatus, 'A') IN('1A')
										THEN 1 
							           when @AuthLevel =1 AND ISNULL(AuthorisationStatus,'A') IN ('NP','MP','DP')
										THEN 1
										ELSE 0									
										END
									)=1
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY 
							A.Freeze_MOC_Date,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.FreezeBy, 
  							A.Date_of_freeze,
                            A.ApprovedBySecondLevel, 
                            A.DateApprovedSecondLevel, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.ApprovedByFirstLevel,
							A.DateApprovedFirstLevel,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
							,A.MOC_Initialized_Date

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY Date_of_freeze) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'MOCFreezeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp20 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
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
