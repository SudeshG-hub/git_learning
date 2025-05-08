SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create PROC [dbo].[Rpt-025_05-08-2022]
	@TimeKey  INT
	AS 


--DECLARE  @TimeKey AS INT=25992

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

------------------------------------------------------

IF(OBJECT_ID('TEMPDB..#DimAcBuSegment')IS NOT NULL)
   DROP TABLE #DimAcBuSegment

SELECT 
DENSE_RANK()OVER(PARTITION BY AcBuRevisedSegmentCode ORDER BY AcBuSegmentCode) RN,
AcBuSegmentCode,
AcBuRevisedSegmentCode,
AcBuSegmentDescription 
INTO #DimAcBuSegment
FROM DimAcBuSegment
WHERE EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)

---------------------PreMOC_DATA----------------------


SELECT 

DISTINCT 

	'Post Moc' Moc_Status 
	,CONVERT(VARCHAR(20),G.DATE,103)                                  AS CurrentProcessingDate
	,ROW_NUMBER()OVER(ORDER BY A.UcifEntityId)                        AS SrNo
	---------RefColumns---------
	,H.SourceName
	,A.CustomerAcID
	,A.RefCustomerID                                                  AS CustomerID
	,F.CustomerName
	,A.UCIF_ID
	,A.FacilityType
    ,ISNULL(F.PANNo,'')                                               AS PANNo
	,F.AadharCardNo
	,CONVERT(VARCHAR(20),A.InitialNpaDt,103)                          AS InitialNpaDt
	,A.InitialAssetClassAlt_Key
	,D.AssetClassName                                                 AS InitalAssetClassName
	
	----Edit--------
	,CONVERT(VARCHAR(20),A.FirstDtOfDisb,103)                         AS FirstDtOfDisb
	,A.ProductAlt_Key
	,C.ProductName
	,ISNULL(A.Balance,0)                                              AS Balance
	,ISNULL(A.PrincOutStd,0)                                          AS PrincOutStd
	,ISNULL(A.PrincOverdue,0)                                         AS PrincOverdue
	,ISNULL(A.IntOverdue,0)                                           AS IntOverdue
	,ISNULL(A.DrawingPower,0)                                         AS DrawingPower
	,ISNULL(A.CurrentLimit,0)                                         AS CurrentLimit
	,CONVERT(VARCHAR(20),A.ContiExcessDt,103)                         AS ContiExcessDt
	,CONVERT(VARCHAR(20),A.StockStDt,103)                             AS StockStDt
	,CONVERT(VARCHAR(20),A.DebitSinceDt,103)                          AS DebitSinceDt
	,CONVERT(VARCHAR(20),A.LastCrDate,103)                            AS LastCrDate
	,ISNULL(A.CurQtrCredit,0)                                         AS CurQtrCredit
	,ISNULL(A.CurQtrInt,0)                                            AS CurQtrInt
	,A.InttServiced
	,CONVERT(VARCHAR(20),A.IntNotServicedDt,103)                      AS IntNotServicedDt
	,CONVERT(VARCHAR(20),A.OverDueSinceDt,103)                        AS OverDueSinceDt
	,CONVERT(VARCHAR(20),A.ReviewDueDt,103)                           AS ReviewDueDt
	,ISNULL(F.CurntQtrRv,0)                                           AS SecurityValue
	,ISNULL(A.DFVAmt,0)                                               AS DFVAmt
	,ISNULL(A.GovtGtyAmt,0)                                           AS GovtGtyAmt
	,ISNULL(A.WriteOffAmount,0)                                       AS WriteOffAmount
	,ISNULL(A.UnAdjSubSidy,0)                                         AS UnAdjSubSidy
	,A.Asset_Norm												      
	,ISNULL(A.AddlProvision,0)                                        AS AddlProvision
	,CONVERT(VARCHAR(20),A.PrincOverDueSinceDt,103)                   AS PrincOverDueSinceDt
	,CONVERT(VARCHAR(20),A.IntOverDueSinceDt,103)                     AS IntOverDueSinceDt
	,CONVERT(VARCHAR(20),A.OtherOverDueSinceDt,103)                   AS OtherOverDueSinceDt
	,ISNULL(A.UnserviedInt,0)                                         AS UnserviedInt
	,ISNULL(A.AdvanceRecovery,0)                                      AS AdvanceRecovery
	,A.RePossession
	,CONVERT(VARCHAR(20),A.RepossessionDate,103)                      AS RepossessionDate
	,A.RCPending
	,A.PaymentPending
	,A.WheelCase
	,A.RFA
	,A.IsNonCooperative
	,A.Sarfaesi
	,CONVERT(VARCHAR(20),A.SarfaesiDate,103)                          AS SarfaesiDate
	,A.WeakAccount                                                    AS InherentWeakness
	,CONVERT(VARCHAR(20),A.WeakAccountDate,103)                       AS InherentWeaknessDate
	,A.FlgFITL
	,A.FlgRestructure
	,CONVERT(VARCHAR(20),A.RestructureDate,103)                       AS RestructureDate
	,A.FlgUnusualBounce
	,CONVERT(VARCHAR(20),A.UnusualBounceDate,103)                     AS UnusualBounceDate
	,A.FlgUnClearedEffect
	,CONVERT(VARCHAR(20),A.UnClearedEffectDate,103)                   AS UnClearedEffectDate                     
-------OutPut-----
    ,ISNULL(A.CoverGovGur,0)                                          AS CoverGovGur
    ,A.DegReason												      
    ,ISNULL(A.NetBalance,0)                                           AS NetBalance
    ,ISNULL(A.ApprRV,0)                                               AS ApprRV
    ,ISNULL(A.SecuredAmt,0)                                           AS SecuredAmt
    ,ISNULL(A.UnSecuredAmt,0)                                         AS UnSecuredAmt
    ,ISNULL(A.ProvDFV,0)                                              AS ProvDFV
    ,ISNULL(A.Provsecured,0)                                          AS Provsecured
    ,ISNULL(A.ProvUnsecured,0)                                        AS ProvUnsecured
    ,ISNULL(A.ProvCoverGovGur,0)                                      AS ProvCoverGovGur
    ,ISNULL(A.TotalProvision,0)                                       AS TotalProvision
    ,ISNULL(A.BankTotalProvision,0)                                   AS BankTotalProvision
    ,ISNULL(A.RBITotalProvision,0)                                    AS RBITotalProvision
    ,CONVERT(VARCHAR(20),A.FinalNpaDt,103)                            AS FinalNpaDt
    ,CONVERT(VARCHAR(20),F.DbtDt,103)                                 AS DoubtfulDt
    ,CONVERT(VARCHAR(20),A.UpgDate,103)                               AS UpgDate
    ,A.FinalAssetClassAlt_Key
    ,E.AssetClassName                                                 AS FinalAssetClassName
    ,A.NPA_Reason
    ,A.FlgDeg
    ,A.FlgUpg
    ,A.FinalProvisiONPer
    ,A.FlgSMA
    ,CONVERT(VARCHAR(20),A.SMA_Dt,103)                                AS SMA_Dt
    ,A.SMA_Class
    ,A.SMA_Reason
    ,A.FlgPNPA
    ,CONVERT(VARCHAR(20),A.PNPA_DATE,103)                             AS PNPA_DATE
    ,A.PNPA_Reason
    ,F.CustMoveDescription                                            AS CustSMAStatus
	,CONVERT(VARCHAR(20),A.MOC_Dt,103)                                AS MOC_Dt
	,A.FlgFraud
	,CONVERT(VARCHAR(20),A.FraudDate,103)                             AS FraudDate
	,ISNULL(ALM.CreatedBy,CLM.CreatedBy)                              AS MakerID
	,ISNULL(ALM.DateCreated,CLM.DateCreated)    AS MakerDate
	,ISNULL(ALM.ApprovedByFirstLevel,CLM.ApprovedByFirstLevel)        AS CheckerID
	,ISNULL(ALM.DateApprovedFirstLevel,CLM.DateApprovedFirstLevel)    AS CheckerDate
	,ISNULL(ALM.ApprovedBy,CLM.ApprovedBy)                            AS ReviewerID 
	,ISNULL(ALM.DateApproved,CLM.DateApproved)                        AS ReviewerDate
	,ISNULL(A.MOCReason,F.MOCReason)                                  AS MOCReason
	,DABS.AcBuRevisedSegmentCode                                      AS AcBuSegmentCode
	,DABS.AcBuSegmentDescription

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

LEFT JOIN #DimAcBuSegment   DABS              ON A.ActSegmentCode=DABS.AcBuRevisedSegmentCode
                                                 AND DABS.RN=1

WHERE (A.FlgMoc='Y'  oR F.FlgMoc='Y')

UNION ALL

SELECT 

DISTINCT

    'Pre Moc' Moc_Status 
    ,CONVERT(VARCHAR(20),G.DATE,103)                                  AS CurrentProcessingDate
    ,ROW_NUMBER()OVER(ORDER BY A.UcifEntityId)                        AS SrNo
    ---------RefColumns---------
    ,H.SourceName
    ,A.CustomerAcID
    ,A.RefCustomerID                                                  AS CustomerID
    ,F.CustomerName
    ,A.UCIF_ID
    ,A.FacilityType
    ,ISNULL(F.PANNo,'')                                               AS PANNo
    ,F.AadharCardNo
    ,CONVERT(VARCHAR(20),A.InitialNpaDt,103)                          AS InitialNpaDt
    ,A.InitialAssetClassAlt_Key
	,D.AssetClassName                                                 AS InitalAssetClassName
	
	----Edit--------
	,CONVERT(VARCHAR(20),A.FirstDtOfDisb,103)                         AS FirstDtOfDisb
	,A.ProductAlt_Key
	,C.ProductName
	,ISNULL(A.Balance,0)                                              AS Balance
	,ISNULL(A.PrincOutStd,0)                                          AS PrincOutStd
	,ISNULL(A.PrincOverdue,0)                                         AS PrincOverdue
	,ISNULL(A.IntOverdue,0)                                           AS IntOverdue
	,ISNULL(A.DrawingPower,0)                                         AS DrawingPower
	,ISNULL(A.CurrentLimit,0)                                         AS CurrentLimit
	,CONVERT(VARCHAR(20),A.ContiExcessDt,103)                         AS ContiExcessDt
	,CONVERT(VARCHAR(20),A.StockStDt,103)                             AS StockStDt
	,CONVERT(VARCHAR(20),A.DebitSinceDt,103)                          AS DebitSinceDt
	,CONVERT(VARCHAR(20),A.LastCrDate,103)                            AS LastCrDate
	,ISNULL(A.CurQtrCredit,0)                                         AS CurQtrCredit
	,ISNULL(A.CurQtrInt,0)                                            AS CurQtrInt
	,A.InttServiced
	,CONVERT(VARCHAR(20),A.IntNotServicedDt,103)                      AS IntNotServicedDt
	,CONVERT(VARCHAR(20),A.OverDueSinceDt,103)                        AS OverDueSinceDt
	,CONVERT(VARCHAR(20),A.ReviewDueDt,103)                           AS ReviewDueDt
	,ISNULL(F.CurntQtrRv,0)                                           AS SecurityValue
	,ISNULL(A.DFVAmt,0)                                               AS DFVAmt
	,ISNULL(A.GovtGtyAmt,0)                                           AS GovtGtyAmt
	,ISNULL(A.WriteOffAmount,0)                                       AS WriteOffAmount
	,ISNULL(A.UnAdjSubSidy,0)                                         AS UnAdjSubSidy
	,A.Asset_Norm
	,ISNULL(A.AddlProvision,0)                                        AS AddlProvision
	,CONVERT(VARCHAR(20),A.PrincOverDueSinceDt,103)                   AS PrincOverDueSinceDt
	,CONVERT(VARCHAR(20),A.IntOverDueSinceDt,103)                     AS IntOverDueSinceDt
	,CONVERT(VARCHAR(20),A.OtherOverDueSinceDt,103)                   AS OtherOverDueSinceDt
	,ISNULL(A.UnserviedInt,0)                                         AS UnserviedInt
	,ISNULL(A.AdvanceRecovery,0)                                      AS AdvanceRecovery
	,A.RePossession
	,CONVERT(VARCHAR(20),A.RepossessionDate,103)                      AS RepossessionDate
	,A.RCPending
	,A.PaymentPending
	,A.WheelCase
	,A.RFA
	,A.IsNonCooperative
	,A.Sarfaesi
	,CONVERT(VARCHAR(20),A.SarfaesiDate,103)                          AS SarfaesiDate
	,A.WeakAccount                                                    AS InherentWeakness
	,CONVERT(VARCHAR(20),A.WeakAccountDate,103)                       AS InherentWeaknessDate
	,A.FlgFITL
	,A.FlgRestructure
	,CONVERT(VARCHAR(20),A.RestructureDate,103)                       AS RestructureDate
	,A.FlgUnusualBounce
	,CONVERT(VARCHAR(20),A.UnusualBounceDate,103)                     AS UnusualBounceDate
	,A.FlgUnClearedEffect
	,CONVERT(VARCHAR(20),A.UnClearedEffectDate,103)                   AS UnClearedEffectDate  
-------OutPut-----
    ,ISNULL(A.CoverGovGur,0)                                          AS CoverGovGur
    ,A.DegReason												      
    ,ISNULL(A.NetBalance,0)                                           AS NetBalance
    ,ISNULL(A.ApprRV,0)                                               AS ApprRV
    ,ISNULL(A.SecuredAmt,0)                                           AS SecuredAmt
    ,ISNULL(A.UnSecuredAmt,0)                                         AS UnSecuredAmt
    ,ISNULL(A.ProvDFV,0)                                              AS ProvDFV
    ,ISNULL(A.Provsecured,0)                                          AS Provsecured
    ,ISNULL(A.ProvUnsecured,0)                                        AS ProvUnsecured
    ,ISNULL(A.ProvCoverGovGur,0)                                      AS ProvCoverGovGur
    ,ISNULL(A.TotalProvision,0)                                       AS TotalProvision
    ,ISNULL(A.BankTotalProvision,0)                                   AS BankTotalProvision
    ,ISNULL(A.RBITotalProvision,0)                                    AS RBITotalProvision
    ,CONVERT(VARCHAR(20),A.FinalNpaDt,103)                            AS FinalNpaDt
    ,CONVERT(VARCHAR(20),F.DbtDt,103)                                 AS DoubtfulDt
    ,CONVERT(VARCHAR(20),A.UpgDate,103)                               AS UpgDate
    ,A.FinalAssetClassAlt_Key
    ,E.AssetClassName                                                 AS FinalAssetClassName
    ,A.NPA_Reason
    ,A.FlgDeg
    ,A.FlgUpg
    ,A.FinalProvisiONPer
    ,A.FlgSMA
    ,CONVERT(VARCHAR(20),A.SMA_Dt,103)                                AS SMA_Dt
    ,A.SMA_Class
    ,A.SMA_Reason
    ,A.FlgPNPA
    ,CONVERT(VARCHAR(20),A.PNPA_DATE,103)                             AS PNPA_DATE
    ,A.PNPA_Reason
    ,F.CustMoveDescription                                            AS CustSMAStatus
	,CONVERT(VARCHAR(20),A.MOC_Dt,103)                                AS MOC_Dt
	,A.FlgFraud
	,CONVERT(VARCHAR(20),A.FraudDate,103)                             AS FraudDate
	,ISNULL(ALM.CreatedBy,CLM.CreatedBy)                              AS MakerID
	,ISNULL(ALM.DateCreated,CLM.DateCreated)     AS MakerDate
	,ISNULL(ALM.ApprovedByFirstLevel,CLM.ApprovedByFirstLevel)        AS CheckerID
	,ISNULL(ALM.DateApprovedFirstLevel,CLM.DateApprovedFirstLevel)    AS CheckerDate
	,ISNULL(ALM.ApprovedBy,CLM.ApprovedBy)                            AS ReviewerID 
	,ISNULL(ALM.DateApproved,CLM.DateApproved)                        AS ReviewerDate
	,ISNULL(A.MOCReason,F.MOCReason)                                  AS MOCReason
	,DABS.AcBuRevisedSegmentCode                                      AS AcBuSegmentCode
	,DABS.AcBuSegmentDescription
	

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

LEFT JOIN #DimAcBuSegment   DABS                        ON A.ActSegmentCode=DABS.AcBuRevisedSegmentCode
                                                           AND DABS.RN=1

WHERE A.CustomerAcID IN(SELECT CustomerAcID FROM #AccountCal_Hist A
                                 left join #CustomerCal_HIST C On C.CustomerEntityId=A.CustomerEntityId
                                WHERE (A.FlgMoc='Y' OR C.FlgMoc='Y') ) 

ORDER BY CustomerAcID,CustomerID,Moc_Status DESC


OPTION(RECOMPILE)

DROP TABLE #AccountCal_Hist,#CustomerCal_Hist,#AccountLevelMOC_Mod,#CustomerLevelMOC_Mod,#AccountCal,#CustomerCal,#DimAcBuSegment

GO
