SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[Rpt-025_29-10-2022]
	@TimeKey  INT,
	@SelectReport AS INT
	AS 


--DECLARE  @TimeKey AS INT=26357,
--         @SelectReport AS INT=1

IF(OBJECT_ID('TEMPDB..#AccountCal_Hist')IS NOT NULL)
   DROP TABLE #AccountCal_Hist

SELECT * 
INTO #AccountCal_Hist
FROM Pro.AccountCal_Hist
WHERE EffectiveFromTimeKey=@TimeKey AND EffectiveToTimeKey=@TimeKey

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_CustomerACID ON #AccountCal_Hist(CustomerACID)
INCLUDE	(CustomerEntityID,FinalAssetClassAlt_Key,InitialAssetClassAlt_Key,ProductAlt_Key,SourceAlt_Key,EffectiveFromTimekey,EffectiveToTimekey,ActSegmentCode)

-------------------------------------------------
IF(OBJECT_ID('TEMPDB..#CustomerCal_HIST')IS NOT NULL)
   DROP TABLE #CustomerCal_HIST

SELECT * 
INTO #CustomerCal_HIST
FROM Pro.CustomerCal_HIST
WHERE EffectiveFromTimeKey=@TimeKey AND EffectiveToTimeKey=@TimeKey

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_CustomerEntityID ON #CustomerCal_HIST(CustomerEntityID)
INCLUDE	(RefCustomerID,EffectiveFromTimekey,EffectiveToTimekey)

---------------------------------------------------

IF(OBJECT_ID('TEMPDB..#AccountLevelMOC_Mod')IS NOT NULL)
   DROP TABLE #AccountLevelMOC_Mod

SELECT *
INTO #AccountLevelMOC_Mod
FROM AccountLevelMOC_Mod
WHERE EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey
	  AND ChangeField IS NOT NULL

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_AccountID ON #AccountLevelMOC_Mod(AccountID)
INCLUDE	(ChangeField,EffectiveFromTimekey,EffectiveToTimekey)

---------------------------------------------------
IF(OBJECT_ID('TEMPDB..#CustomerLevelMOC_Mod')IS NOT NULL)
   DROP TABLE #CustomerLevelMOC_Mod

SELECT *
INTO #CustomerLevelMOC_Mod
FROM CustomerLevelMOC_Mod
WHERE EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey
	  AND ChangeField IS NOT NULL

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_CustomerEntityID2 ON #CustomerLevelMOC_Mod(CustomerEntityID)
INCLUDE	(ChangeField,EffectiveFromTimekey,EffectiveToTimekey)

-------------------------------------------

IF(OBJECT_ID('TEMPDB..#AccountCal')IS NOT NULL)
   DROP TABLE #AccountCal

SELECT *
INTO #AccountCal
FROM PREMOC.AccountCal
WHERE EffectiveFromTimeKey=@TimeKey AND EffectiveToTimeKey=@TimeKey

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_CustomerACID1 ON #AccountCal(CustomerACID)
INCLUDE	(CustomerEntityID,FinalAssetClassAlt_Key,InitialAssetClassAlt_Key,ProductAlt_Key,SourceAlt_Key,EffectiveFromTimekey,EffectiveToTimekey,ActSegmentCode)

--------------------------------------------
IF(OBJECT_ID('TEMPDB..#CustomerCal')IS NOT NULL)
   DROP TABLE #CustomerCal

SELECT * 
INTO #CustomerCal
FROM PreMoc.CustomerCal
WHERE EffectiveFromTimeKey=@TimeKey AND EffectiveToTimeKey=@TimeKey

OPTION(RECOMPILE)

CREATE NONCLUSTERED INDEX INX_CustomerEntityID1 ON #CustomerCal(CustomerEntityID)
INCLUDE	(RefCustomerID,EffectiveFromTimekey,EffectiveToTimekey)



---------------------PreMOC_DATA----------------------


SELECT 

DISTINCT 

	'Post Moc' Moc_Status 
	,CONVERT(VARCHAR(20),G.DATE,103)                                  AS CurrentProcessingDate
	---------RefColumns---------
	,H.SourceName
	,A.UCIF_ID
	,A.RefCustomerID                                                  AS CustomerID
	,F.CustomerName
	,A.CustomerAcID
	,A.FacilityType
	,CONVERT(VARCHAR(20),A.InitialNpaDt,103)                          AS InitialNpaDt
    ,CONVERT(VARCHAR(20),A.FinalNpaDt,103)                            AS FinalNpaDt
	,D.AssetClassName                                                 AS InitalAssetClassName	
	,E.AssetClassName                                                 AS FinalAssetClassName 
	----Edit--------
	,ISNULL(A.PrincOutStd,0)                                          AS PrincOutStd
	,ISNULL(F.CurntQtrRv,0)                                           AS SecurityValue											      
	,ISNULL(A.AddlProvision,0)                                        AS AddlProvision
    ,ISNULL(A.UnserviedInt,0)                                         AS UnserviedInt
	,A.RFA	
	,A.FlgFraud
	,CONVERT(VARCHAR(20),A.FraudDate,103)                             AS FraudDate												      
    ,ISNULL(A.NetBalance,0)                                           AS NetBalance
    ,ISNULL(A.Provsecured,0)                                          AS Provsecured
    ,ISNULL(A.ProvUnsecured,0)                                        AS ProvUnsecured
    ,ISNULL(A.TotalProvision,0)                                       AS TotalProvision
    ,ISNULL(A.BankTotalProvision,0)                                   AS BankTotalProvision
    ,ISNULL(A.RBITotalProvision,0)                                    AS RBITotalProvision
	,CONVERT(VARCHAR(20),A.MOC_Dt,103)                                AS MOC_Dt
	,ISNULL(ALM.CreatedBy,CLM.CreatedBy)                              AS MakerID
	,ISNULL(ALM.DateCreated,CLM.DateCreated)    AS MakerDate
	,ISNULL(ALM.ApprovedByFirstLevel,CLM.ApprovedByFirstLevel)        AS CheckerID
	,ISNULL(ALM.DateApprovedFirstLevel,CLM.DateApprovedFirstLevel)    AS CheckerDate
	,ISNULL(ALM.ApprovedBy,CLM.ApprovedBy)                            AS ReviewerID 
	,ISNULL(ALM.DateApproved,CLM.DateApproved)                        AS ReviewerDate
	,ISNULL(A.MOCReason,F.MOCReason)                                  AS MOCReason

FROM  #AccountCal_Hist A
INNER JOIN DimProduct C                       ON C.ProductAlt_Key=A.ProductAlt_Key 
                                                 AND C.EffectiveFromTimeKey<=@TimeKey
												 AND C.EffectiveToTimeKey>=@TimeKey

LEFT JOIN #AccountLevelMOC_Mod ALM            ON ALM.AccountId=A.CustomerAcID

LEFT JOIN #CustomerCal_HIST F                 ON F.CustomerEntityId=A.CustomerEntityId

LEFT JOIN #CustomerLevelMOC_Mod CLM           ON F.CustomerEntityId=CLM.CustomerEntityId

INNER JOIN DimAssetClass D                    ON D.AssetClassAlt_Key=A.InitialAssetClassAlt_Key 
                                                 AND D.EffectiveFromTimeKey<=@TimeKey
												 AND D.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass E                    ON E.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                 AND E.EffectiveFromTimeKey<=@TimeKey
												 AND E.EffectiveToTimeKey>=@TimeKey

INNER JOIN SysDayMatrix G                     ON A.EffectiveFromTimekey=G.TimeKey

INNER JOIN DimSourceDB H                      ON H.SourceAlt_Key=A.SourceAlt_Key
                                                 AND H.EffectiveFromTimeKey<=@TimeKey
												 AND H.EffectiveToTimeKey>=@TimeKey


WHERE (A.FlgMoc='Y'  OR F.FlgMoc='Y') AND @SelectReport=1

UNION ALL

SELECT 

DISTINCT

    'Pre Moc' Moc_Status 
    ,CONVERT(VARCHAR(20),G.DATE,103)                                  AS CurrentProcessingDate
    ---------RefColumns---------
	,H.SourceName
	,A.UCIF_ID
	,A.RefCustomerID                                                  AS CustomerID
	,F.CustomerName
	,A.CustomerAcID
	,A.FacilityType
	,CONVERT(VARCHAR(20),A.InitialNpaDt,103)                          AS InitialNpaDt
    ,CONVERT(VARCHAR(20),A.FinalNpaDt,103)                            AS FinalNpaDt
	,D.AssetClassName                                                 AS InitalAssetClassName	
	,E.AssetClassName                                                 AS FinalAssetClassName 
	----Edit--------
	,ISNULL(A.PrincOutStd,0)                                          AS PrincOutStd
	,ISNULL(F.CurntQtrRv,0)                                           AS SecurityValue											      
	,ISNULL(A.AddlProvision,0)                                        AS AddlProvision
    ,ISNULL(A.UnserviedInt,0)                                         AS UnserviedInt
	,A.RFA	
	,A.FlgFraud
	,CONVERT(VARCHAR(20),A.FraudDate,103)                             AS FraudDate												      
    ,ISNULL(A.NetBalance,0)                                           AS NetBalance
    ,ISNULL(A.Provsecured,0)                                          AS Provsecured
    ,ISNULL(A.ProvUnsecured,0)                                        AS ProvUnsecured
    ,ISNULL(A.TotalProvision,0)                                       AS TotalProvision
    ,ISNULL(A.BankTotalProvision,0)                                   AS BankTotalProvision
    ,ISNULL(A.RBITotalProvision,0)                                    AS RBITotalProvision
	,CONVERT(VARCHAR(20),A.MOC_Dt,103)                                AS MOC_Dt
	,ISNULL(ALM.CreatedBy,CLM.CreatedBy)                              AS MakerID
	,ISNULL(ALM.DateCreated,CLM.DateCreated)    AS MakerDate
	,ISNULL(ALM.ApprovedByFirstLevel,CLM.ApprovedByFirstLevel)        AS CheckerID
	,ISNULL(ALM.DateApprovedFirstLevel,CLM.DateApprovedFirstLevel)    AS CheckerDate
	,ISNULL(ALM.ApprovedBy,CLM.ApprovedBy)                            AS ReviewerID 
	,ISNULL(ALM.DateApproved,CLM.DateApproved)                        AS ReviewerDate
	,ISNULL(A.MOCReason,F.MOCReason)                                  AS MOCReason	

FROM #AccountCal A
INNER JOIN DimProduct C                                 ON C.ProductAlt_Key=A.ProductAlt_Key 
                                                           AND C.EffectiveFromTimeKey<=@TimeKey
												           AND C.EffectiveToTimeKey>=@TimeKey

LEFT JOIN #AccountLevelMOC_Mod ALM                      ON ALM.AccountId=A.CustomerAcID

LEFT JOIN #CustomerCal F                                ON F.CustomerEntityId=A.CustomerEntityId

LEFT JOIN #CustomerLevelMOC_Mod CLM                     ON F.CustomerEntityId=CLM.CustomerEntityId

INNER JOIN DimAssetClass D                              ON D.AssetClassAlt_Key=A.InitialAssetClassAlt_Key 
                                                           AND D.EffectiveFromTimeKey<=@TimeKey
												           AND D.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass E                              ON E.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                           AND E.EffectiveFromTimeKey<=@TimeKey
												           AND E.EffectiveToTimeKey>=@TimeKey


INNER JOIN SysDayMatrix G                               ON A.EffectiveFromTimekey=G.TimeKey

INNER JOIN DimSourceDB H                                ON H.SourceAlt_Key=A.SourceAlt_Key
                                                           AND H.EffectiveFromTimeKey<=@TimeKey
												           AND H.EffectiveToTimeKey>=@TimeKey

WHERE A.CustomerAcID IN(SELECT CustomerAcID FROM #AccountCal_Hist A
                                 left join #CustomerCal_HIST C On C.CustomerEntityId=A.CustomerEntityId
                                WHERE (A.FlgMoc='Y' OR C.FlgMoc='Y') ) AND @SelectReport=1

ORDER BY CustomerAcID,CustomerID,Moc_Status DESC


OPTION(RECOMPILE)

DROP TABLE #AccountCal_Hist,#CustomerCal_Hist,#AccountLevelMOC_Mod,#CustomerLevelMOC_Mod,#AccountCal,#CustomerCal

GO
