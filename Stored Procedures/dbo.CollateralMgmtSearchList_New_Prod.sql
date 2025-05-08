SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CollateralMgmtSearchList_New_Prod]
--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													@OperationFlag  INT         = 1
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
                 SELECT		A.TaggingLevel,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,A.DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,A.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,A.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,A.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,A. CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,A.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,A.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,A.ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
							,A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate
                 INTO #temp
                 FROM 
                 (
                     SELECT B.ParameterName as TaggingLevel,
							A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,C.ParameterName as DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,E.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,F.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,G.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,H.ParameterName as CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,I.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,J.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,D.ParameterName as ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
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
                     FROM CollateralMgmt A
					 Inner Join (Select ParameterAlt_Key,ParameterName,'TaggingLevel' as Tablename 
						  from DimParameter where DimParameterName='DimRatingType'
						  and ParameterName not in ('Guarantor')
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)B
						  ON A.TaggingAlt_Key=B.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'DistributionModel' as Tablename 
						  from DimParameter where DimParameterName='Collateral'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)C
						  ON A.DistributionAlt_Key=C.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'ShareAvailabletoBank' as Tablename 
						  from DimParameter where DimParameterName='CollateralBank'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)D
						  ON A.ShareAvailabletoBankAlt_Key=D.ParameterAlt_Key
						  inner join DimCollateralType E
						  ON A.CollateralTypeAlt_Key=E.CollateralTypeAltKey
						  AND E.EffectiveFromTimeKey<=@Timekey And E.EffectiveToTimeKey>=@TimeKey
						  inner join DimCollateralSubType F
						  ON A.CollateralSubTypeAlt_Key=F.CollateralSubTypeAltKey 
						  And F.EffectiveFromTimeKey<=@Timekey And F.EffectiveToTimeKey>=@TimeKey
						  Inner join DimCollateralOwnerType G
						  ON A.CollateralOwnerTypeAlt_Key=G.CollateralOwnerTypeAltKey
						  And G.EffectiveFromTimeKey<=@Timekey And G.EffectiveToTimeKey>=@TimeKey
						  Inner Join (Select ParameterAlt_Key,ParameterName,'CollateralOwnershipType' as Tablename 
						  from DimParameter where DimParameterName='CollateralOwnershipType'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON A.CollateralOwnerShipTypeAlt_Key=H.ParameterAlt_Key
						  Inner join DimCollateralChargeType I
						  ON A.ChargeTypeAlt_Key=I.CollateralChargeTypeAltKey
						  And I.EffectiveFromTimeKey<=@Timekey And I.EffectiveToTimeKey>=@TimeKey
						  Inner Join DimSecurityChargeType J
						  On A.ChargeNatureAlt_Key=J.SecurityChargeTypeAlt_Key
						  And J.EffectiveFromTimeKey<=@Timekey And J.EffectiveToTimeKey>=@TimeKey
						  AND SecurityChargeTypeGroup='COLLATERAL'
						 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
                     UNION
                     SELECT 	B.ParameterName as TaggingLevel
							,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,C.ParameterName as DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,E.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,F.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,G.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,H.ParameterName as CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,I.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,J.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,D.ParameterName as ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
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
                     FROM CollateralMgmt_Mod A
					 Inner Join (Select ParameterAlt_Key,ParameterName,'TaggingLevel' as Tablename 
						  from DimParameter where DimParameterName='DimRatingType'
						  and ParameterName not in ('Guarantor')
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)B
						  ON A.TaggingAlt_Key=B.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'DistributionModel' as Tablename 
						  from DimParameter where DimParameterName='Collateral'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)C
						  ON A.DistributionAlt_Key=C.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'ShareAvailabletoBank' as Tablename 
						  from DimParameter where DimParameterName='CollateralBank'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)D
						  ON A.ShareAvailabletoBankAlt_Key=D.ParameterAlt_Key
						  inner join DimCollateralType E
						  ON A.CollateralTypeAlt_Key=E.CollateralTypeAltKey
						  AND E.EffectiveFromTimeKey<=@Timekey And E.EffectiveToTimeKey>=@TimeKey
						  inner join DimCollateralSubType F
						  ON A.CollateralSubTypeAlt_Key=F.CollateralSubTypeAltKey 
						  And F.EffectiveFromTimeKey<=@Timekey And F.EffectiveToTimeKey>=@TimeKey
						  Inner join DimCollateralOwnerType G
						  ON A.CollateralOwnerTypeAlt_Key=G.CollateralOwnerTypeAltKey
						  And G.EffectiveFromTimeKey<=@Timekey And G.EffectiveToTimeKey>=@TimeKey
						  Inner Join (Select ParameterAlt_Key,ParameterName,'CollateralOwnershipType' as Tablename 
						  from DimParameter where DimParameterName='CollateralOwnershipType'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON A.CollateralOwnerShipTypeAlt_Key=H.ParameterAlt_Key
						  Inner join DimCollateralChargeType I
						  ON A.ChargeTypeAlt_Key=I.CollateralChargeTypeAltKey
						  And I.EffectiveFromTimeKey<=@Timekey And I.EffectiveToTimeKey>=@TimeKey
						  Inner Join DimSecurityChargeType J
						  On A.ChargeNatureAlt_Key=J.SecurityChargeTypeAlt_Key
						  And J.EffectiveFromTimeKey<=@Timekey And J.EffectiveToTimeKey>=@TimeKey
						  AND SecurityChargeTypeGroup='COLLATERAL'
						 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM CollateralMgmt_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY CollateralID
                     )
                 ) A 
                      
                 
                 GROUP BY	 A.TaggingLevel
							,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,A.DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,A.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,A.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,A.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,A. CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,A.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,A.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,A.ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
							,A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate;

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY CollateralID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Collateral' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
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
                 SELECT		A.TaggingLevel
							,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,A.DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,A.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,A.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,A.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,A. CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,A.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,A.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,A.ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
							,A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate
                 INTO #temp16
                 FROM 
                 (
                     SELECT B.ParameterName as TaggingLevel
							,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,C.ParameterName as DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,E.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,F.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,G.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,H.ParameterName as CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,I.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,J.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,D.ParameterName as ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
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
                     FROM CollateralMgmt_Mod A
					 Inner Join (Select ParameterAlt_Key,ParameterName,'TaggingLevel' as Tablename 
						  from DimParameter where DimParameterName='DimRatingType'
						  and ParameterName not in ('Guarantor')
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)B
						  ON A.TaggingAlt_Key=B.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'DistributionModel' as Tablename 
						  from DimParameter where DimParameterName='Collateral'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)C
						  ON A.DistributionAlt_Key=C.ParameterAlt_Key
						  Inner Join (Select ParameterAlt_Key,ParameterName,'ShareAvailabletoBank' as Tablename 
						  from DimParameter where DimParameterName='CollateralBank'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)D
						  ON A.ShareAvailabletoBankAlt_Key=D.ParameterAlt_Key
						  inner join DimCollateralType E
						  ON A.CollateralTypeAlt_Key=E.CollateralTypeAltKey
						  AND E.EffectiveFromTimeKey<=@Timekey And E.EffectiveToTimeKey>=@TimeKey
						  inner join DimCollateralSubType F
						  ON A.CollateralSubTypeAlt_Key=F.CollateralSubTypeAltKey 
						  And F.EffectiveFromTimeKey<=@Timekey And F.EffectiveToTimeKey>=@TimeKey
						  Inner join DimCollateralOwnerType G
						  ON A.CollateralOwnerTypeAlt_Key=G.CollateralOwnerTypeAltKey
						  And G.EffectiveFromTimeKey<=@Timekey And G.EffectiveToTimeKey>=@TimeKey
						  Inner Join (Select ParameterAlt_Key,ParameterName,'CollateralOwnershipType' as Tablename 
						  from DimParameter where DimParameterName='CollateralOwnershipType'
						  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)H
						  ON A.CollateralOwnerShipTypeAlt_Key=H.ParameterAlt_Key
						  Inner join DimCollateralChargeType I
						  ON A.ChargeTypeAlt_Key=I.CollateralChargeTypeAltKey
						  And I.EffectiveFromTimeKey<=@Timekey And I.EffectiveToTimeKey>=@TimeKey
						  Inner Join DimSecurityChargeType J
						  On A.ChargeNatureAlt_Key=J.SecurityChargeTypeAlt_Key
						  And J.EffectiveFromTimeKey<=@Timekey And J.EffectiveToTimeKey>=@TimeKey
						  AND SecurityChargeTypeGroup='COLLATERAL'
						 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM CollateralMgmt_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY CollateralID
                     )
                 ) A 
                      
                 
                 GROUP BY	A.TaggingLevel
							,A.CollateralAlt_Key
							,A.AccountID
							,A.UCICID
							,A.CustomerID
							,A.CustomerName
							,A.TaggingAlt_Key
							,A.DistributionAlt_Key
							,A.DistributionModel
							,A.CollateralID
							,A.CollateralCode
							,A.CollateralTypeAlt_Key
							,A.CollateralTypeDescription
							,A.CollateralSubTypeAlt_Key
							,A.CollateralSubTypeDescription
							,A.CollateralOwnerTypeAlt_Key
							,A.CollOwnerDescription
							,A.CollateralOwnerShipTypeAlt_Key
							,A. CollateralOwnershipType
							,A.ChargeTypeAlt_Key
							,A.CollChargeDescription
							,A.ChargeNatureAlt_Key
							,A.SecurityChargeTypeName
							,A.ShareAvailabletoBankAlt_Key
							,A.ShareAvailabletoBank
							,A.CollateralShareamount
							,A.TotalCollateralvalueatcustomerlevel
							,A.AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified,
							A.CrModBy,
							A.CrModDate
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY CollateralID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Collateral' TableName, 
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
