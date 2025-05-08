SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt-028_06042022]
      @TimeKey AS INT,
	  @Cost    AS FLOAT
AS

--DECLARE 
--      @TimeKey AS INT=26299,
--	  @Cost    AS FLOAT=1

DECLARE @Date AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)
-------------------------------------Asset Classification

SELECT 
CONVERT(VARCHAR(20),@Date, 103)                  AS  [Process_date] 
,A.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,CustomerName
,B.BranchCode
,BranchName
,CustomerAcID
,SourceName
,B.FacilityType
,SchemeType
,B.ProductCode
,ProductName
,ActSegmentCode
,AcBuSegmentDescription
,AcBuRevisedSegmentCode
,DPD_Max
,CONVERT(VARCHAR(20),FinalNpaDt,103)         AS FinalNpaDt
,ISNULL(B.Balance,0)/@Cost                     AS Balance
,ISNULL(NetBalance,0)/@Cost                  AS NetBalance
,ISNULL(DrawingPower,0)/@Cost                AS DrawingPower
,ISNULL(CurrentLimit,0)/@Cost                AS CurrentLimit
,(CASE WHEN (ISNULL(B.Balance,0) -(ISNULL(DrawingPower,0)+ISNULL(CurrentLimit,0))) < 0 
       THEN 0 
	   ELSE (ISNULL(B.Balance,0) -(ISNULL(DrawingPower,0)+ISNULL(CurrentLimit,0))) 
	   END)/@Cost                                                                        AS OverDrawn_Amt
,DPD_Overdrawn
,CONVERT(VARCHAR(20),ContiExcessDt,103)      AS ContiExcessDt
,CONVERT(VARCHAR(20),ReviewDueDt,103)        AS ReviewDueDt
,DPD_Renewal
,CONVERT(VARCHAR(20),StockStDt,103)          AS StockStDt
,DPD_StockStmt
,CONVERT(VARCHAR(20),DebitSinceDt,103)       AS DebitSinceDt
,CONVERT(VARCHAR(20),LastCrDate,103)         AS LastCrDate
,DPD_NoCredit
,ISNULL(CurQtrCredit,0)/@Cost                AS CurQtrCredit
,ISNULL(CurQtrInt,0)/@Cost                   AS CurQtrInt
,(CASE WHEN (ISNULL(CurQtrInt,0) -ISNULL(CurQtrCredit,0)) < 0 
       THEN 0 
	   ELSE (ISNULL(CurQtrInt,0) -ISNULL(CurQtrCredit,0)) 
	   END)/@Cost                                     AS [InterestNotServiced]
,DPD_IntService
,0                                                    AS [CC/OD Interest Service]
,ISNULL(OverdueAmt,0)/@Cost                           AS OverdueAmt
,CONVERT(VARCHAR(20),B.OverDueSinceDt,103)              AS OverDueSinceDt
,DPD_Overdue
,ISNULL(PrincOverdue,0)/@Cost                         AS PrincOverdue
,CONVERT(VARCHAR(20),PrincOverdueSinceDt,103)         AS PrincOverdueSinceDt
,DPD_PrincOverdue
,ISNULL(IntOverdue,0)/@Cost                           AS IntOverdue
,CONVERT(VARCHAR(20),IntOverdueSinceDt,103)           AS IntOverdueSinceDt
,DPD_IntOverdueSince
,ISNULL(OtherOverdue,0)/@Cost                         AS OtherOverdue
,CONVERT(VARCHAR(20),OtherOverdueSinceDt,103)         AS OtherOverdueSinceDt
,DPD_OtherOverdueSince
,0                                                    AS [Bill/PC Overdue Amount]
,''                                                   AS [Overdue Bill/PC ID]
,''                                                   AS [Bill/PC Overdue Date]
,''                                                   AS [DPD Bill/PC]
,A2.AssetClassName                                    AS FinalAssetName
,REPLACE(isnull(B.NPA_Reason,b.DegReason),',','') as DegReason
,NPANorms
--------
,E.SrcSysClassName   SubAssetClass
,'' SubAssetDate

,(ISNULL(BAL.SignBalance,0)*-1)CREDITBAL
FROM PRO.CUSTOMERCAL A
INNER JOIN PRO.ACCOUNTCAL B       	ON A.CustomerEntityID=B.CustomerEntityID
                                       AND A.EffectiveFromTimeKey<=@TimeKey
									   AND A.EffectiveToTimeKey>=@TimeKey
                                       AND B.EffectiveFromTimeKey<=@TimeKey
									   AND B.EffectiveToTimeKey>=@TimeKey

Left JOIN AdvAcBalanceDetail BAL       	ON BAL.AccountEntityId=B.AccountEntityId
                                       AND BAL.EffectiveFromTimeKey<=@TimeKey
									   AND BAL.EffectiveToTimeKey>=@TimeKey

Left Join		DimProduct D        On B.ProductAlt_Key=D.ProductAlt_Key 
                                    And D.EffectiveToTimeKey=49999
left Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
				 EffectiveFromTimeKey,EffectiveToTimeKey
				 from DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
                                              And	C.SourceAlt_Key=D.SourceAlt_Key
                                              And	C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) E ON		E.AssetClassAlt_Key=B.InitialAssetClassAlt_Key 
                                                 And	C.SourceAlt_Key=D.SourceAlt_Key
                                                 And	C.EffectiveToTimeKey=49999

LEFT JOIN DIMSOURCEDB src	        ON B.SourceAlt_Key =src.SourceAlt_Key
                                       AND src.EffectiveFromTimeKey<=@TimeKey
									   AND src.EffectiveToTimeKey>=@TimeKey
	

----LEFT JOIN DIMPRODUCT PD          	ON  PD.PRODUCTALT_KEY=B.PRODUCTALT_KEY
----                                        AND PD.EffectiveFromTimeKey<=@TimeKey
----									    AND PD.EffectiveToTimeKey>=@TimeKey


LEFT JOIN DimAssetClass A2	        ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                       AND A2.EffectiveFromTimeKey<=@TimeKey
									   AND A2.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAcBuSegment S          ON B.ActSegmentCode=S.AcBuSegmentCode
                                       AND S.EffectiveFromTimeKey<=@TimeKey
									   AND S.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimBranch X               ON B.BranchCode = X.BranchCode
                                       AND X.EffectiveFromTimeKey<=@TimeKey
									   AND X.EffectiveToTimeKey>=@TimeKey

WHERE RefPeriodOverdue NOT IN (181,366)

OPTION(RECOMPILE)
GO
