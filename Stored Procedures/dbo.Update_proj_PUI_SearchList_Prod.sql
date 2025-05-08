SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Exec Update_proj_PUI_SearchList @OperationFlag=1
CREATE PROC [dbo].[Update_proj_PUI_SearchList_Prod]
--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 20,
													@MenuID	INT=24705
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')


Declare @Authlevel InT
 
select @Authlevel=AuthLevel from SysCRisMacMenu  
 where MenuId=@MenuID
  --select * from 	SysCRisMacMenu where menucaption like '%PUI%'					

BEGIN TRY

/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in (16,17,20))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		 A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC
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
                 INTO #temp
                 FROM 
                 (
                     SELECT 
							        A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,case when A.ChangeinProjectScope=1 THEN 'Y' ELSE 'N' END AS ChangeinProjectScopeDESC
                                    ,convert(varchar(10),A.FreshOriginalDCCO ,103) FreshOriginalDCCO
                                   ,convert(varchar(10),A.RevisedDCCO ,103) RevisedDCCO 
                                   ,A.CourtCaseArbitration
								   ,case when A.CourtCaseArbitration=1 THEN 'Y' ELSE 'N' END AS CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,case when A.ChangeinOwnerShip=1 THEN 'Y' ELSE 'N' END AS ChangeinOwnerShipDESC
                                   ,convert(varchar(10),A.CIOReferenceDate ,103) CIOReferenceDate
                                   ,convert(varchar(10),A.CIODCCO ,103) CIODCCO 
								   ,case when A.CostOverRun=1 THEN 'Y' ELSE 'N' END AS CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,case when A.TakeOutFinance=1 THEN 'Y' ELSE 'N' END AS TakeOutFinanceDESC
								   ,case when A.AssetClassSellerBookAlt_key=1 then 'STD'
								         ELSE 'NPA' END AS AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,convert(varchar(10),A.NPADateSellerBook ,103) NPADateSellerBook 
                                   ,A.Restructuring
								    ,case when A.Restructuring=1 THEN 'Y' ELSE 'N' END AS RestructuringDESC
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus
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
                     FROM AdvAcPUIDetailSub A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
                     UNION
                     SELECT   A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,case when A.ChangeinProjectScope=1 THEN 'Y' ELSE 'N' END AS ChangeinProjectScopeDESC
                                   --,A.FreshOriginalDCCO
								    ,convert(varchar(10),A.FreshOriginalDCCO ,103) FreshOriginalDCCO
                                   ,convert(varchar(10),A.RevisedDCCO ,103) RevisedDCCO 
                                   ,A.CourtCaseArbitration
								   ,case when A.CourtCaseArbitration=1 THEN 'Y' ELSE 'N' END AS CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,case when A.ChangeinOwnerShip=1 THEN 'Y' ELSE 'N' END AS ChangeinOwnerShipDESC
                                   ,convert(varchar(10),A.CIOReferenceDate ,103) CIOReferenceDate
                                   ,convert(varchar(10),A.CIODCCO ,103) CIODCCO 
								   ,case when A.CostOverRun=1 THEN 'Y' ELSE 'N' END AS CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,case when A.TakeOutFinance=1 THEN 'Y' ELSE 'N' END AS TakeOutFinanceDESC
								   ,case when A.AssetClassSellerBookAlt_key=1 then 'STD'
								         ELSE 'NPA' END AS AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,convert(varchar(10),A.NPADateSellerBook ,103) NPADateSellerBook 
                                   ,A.Restructuring
								    ,case when A.Restructuring=1 THEN 'Y' ELSE 'N' END AS RestructuringDESC,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate
                     FROM AdvAcPUIDetailSub_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM AdvAcPUIDetailSub_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY  A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate;

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AssetClassSellerBookAlt_key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'UpdatePUI' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
             
             END;
             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in(16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT   A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 INTO #temp16
                 FROM 
                 (
                     SELECT   A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,case when A.ChangeinProjectScope=1 THEN 'Y' ELSE 'N' END AS ChangeinProjectScopeDESC
                                     ,convert(varchar(10),A.FreshOriginalDCCO ,103) FreshOriginalDCCO
                                   ,convert(varchar(10),A.RevisedDCCO ,103) RevisedDCCO 
                                   ,A.CourtCaseArbitration
								   ,case when A.CourtCaseArbitration=1 THEN 'Y' ELSE 'N' END AS CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,case when A.ChangeinOwnerShip=1 THEN 'Y' ELSE 'N' END AS ChangeinOwnerShipDESC
                                   ,convert(varchar(10),A.CIOReferenceDate ,103) CIOReferenceDate
                                   ,convert(varchar(10),A.CIODCCO ,103) CIODCCO 
								   ,case when A.CostOverRun=1 THEN 'Y' ELSE 'N' END AS CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,case when A.TakeOutFinance=1 THEN 'Y' ELSE 'N' END AS TakeOutFinanceDESC
								   ,case when A.AssetClassSellerBookAlt_key=1 then 'STD'
								         ELSE 'NPA' END AS AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,convert(varchar(10),A.NPADateSellerBook ,103) NPADateSellerBook 
                                   ,A.Restructuring
								    ,case when A.Restructuring=1 THEN 'Y' ELSE 'N' END AS RestructuringDESC,
							isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate
                     FROM AdvAcPUIDetailSub_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM AdvAcPUIDetailSub_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
							    GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY   A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AssetClassSellerBookAlt_key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'UpdatePUI' TableName, 
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
                 SELECT    A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 INTO #temp20
                 FROM 
                 (
                     SELECT  A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,case when A.ChangeinProjectScope=1 THEN 'Y' ELSE 'N' END AS ChangeinProjectScopeDESC
                                   --,A.FreshOriginalDCCO
                                     ,convert(varchar(10),A.FreshOriginalDCCO ,103) FreshOriginalDCCO
                                   ,convert(varchar(10),A.RevisedDCCO ,103) RevisedDCCO 
                                   ,A.CourtCaseArbitration
								   ,case when A.CourtCaseArbitration=1 THEN 'Y' ELSE 'N' END AS CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,case when A.ChangeinOwnerShip=1 THEN 'Y' ELSE 'N' END AS ChangeinOwnerShipDESC
                                   ,convert(varchar(10),A.CIOReferenceDate ,103) CIOReferenceDate
                                   ,convert(varchar(10),A.CIODCCO ,103) CIODCCO 
								   ,case when A.CostOverRun=1 THEN 'Y' ELSE 'N' END AS CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,case when A.TakeOutFinance=1 THEN 'Y' ELSE 'N' END AS TakeOutFinanceDESC
								   ,case when A.AssetClassSellerBookAlt_key=1 then 'STD'
								         ELSE 'NPA' END AS AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,convert(varchar(10),A.NPADateSellerBook ,103) NPADateSellerBook 
                                   ,A.Restructuring
								    ,case when A.Restructuring=1 THEN 'Y' ELSE 'N' END AS RestructuringDESC,
							A.AuthorisationStatus AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate
							,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy
							,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate
							,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy
							,ISNULL(A.DateApproved,A.DateModified) as ModAppDate
                     FROM AdvAcPUIDetailSub_Mod A
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(AuthorisationStatus, 'A') IN('1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM AdvAcPUIDetailSub_Mod
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
                      
                 
                 GROUP BY    A.CustomerID
								   ,A.AccountID
                                   ,A.ChangeinProjectScope
								   ,A.ChangeinProjectScopeDESC
                                   ,A.FreshOriginalDCCO
                                   ,A.RevisedDCCO
                                   ,A.CourtCaseArbitration
								   ,A.CourtCaseArbitrationDESC
                                   ,A.ChangeinOwnerShip
								   ,A.ChangeinOwnerShipDESC
                                   ,A.CIOReferenceDate
                                   ,A.CIODCCO
								   ,A.CostOverRunDESC
                                   ,A.CostOverRun
                                   ,A.RevisedProjectCost
                                   ,A.RevisedDebt
                                   ,A.RevisedDebt_EquityRatio
                                   ,A.TakeOutFinance
								   ,A.TakeOutFinanceDESC
								    ,A.AssetClassSellerBook
                                   ,A.AssetClassSellerBookAlt_key
                                   ,A.NPADateSellerBook
                                   ,A.Restructuring
								   ,A.RestructuringDESC,
							A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate,
							A.CrAppBy,
							A.CrAppDate,
							A.ModAppBy,
							A.ModAppDate
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY AssetClassSellerBookAlt_key) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'UpdatePUI' TableName, 
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
