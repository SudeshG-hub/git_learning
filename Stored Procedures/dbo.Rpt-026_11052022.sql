SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


creATE  PROCEDURE [dbo].[Rpt-026_11052022]
      @DateFrom	AS VARCHAR(15),
      @DateTo		AS VARCHAR(15),
	  @Cost    AS FLOAT
AS

--DECLARE 
--    @DateFrom	AS VARCHAR(15)='01/10/2021',
--    @DateTo		AS VARCHAR(15)='15/03/2022',
--	  @Cost    AS FLOAT=1

DECLARE	@From1		DATE=(SELECT Rdate FROM dbo.DateConvert(@DateFrom))
DECLARE @to1		DATE=(SELECT Rdate FROM dbo.DateConvert(@DateTo))


---------------------DEGRADATION  Report----------------------
---------------------------======================================DPD CalCULATION  Start===========================================


select distinct CustomerAcID,IntNotServicedDt,DegDate
into #IntNoserviedDt
from Pro.ACCOUNTCAL_hist  A
INNER JOIN Pro.CustomerCal_Hist B 
ON A.CustomerEntityID = B.CustomerEntityID
AND A.EffectiveFromTimeKey = B.EffectiveFromTimeKey
and cast(DegDate as date) is not NULL
and IntNotServicedDt is not NULL

OPTION(RECOMPILE)

---------Degrade Report-------------------
SELECT DISTINCT
--CONVERT(VARCHAR(20),@to1, 103)                  AS  [Process_date] 
CONVERT(VARCHAR(20),Convert(date,Process_date,105), 103)                  AS  [Process_date]
,UCIC                                        AS UCIC
,CustomerID                                 AS CustomerID
,CustomerName
,B.Branchcode
,BranchName
,B.CustomerAcID
,SourceName
,FacilityType
,SchemeType
,ProductCode
,ProductName
,ActSegmentCode
,CASE WHEN SourceName='Ganaseva' THEN 'FI'
		  WHEN SourceName='VisionPlus' THEN 'Credit Card'
		else AcBuSegmentDescription end AcBuSegmentDescription
,CASE WHEN SourceName='Ganaseva' THEN 'FI'
		  WHEN SourceName='VisionPlus' THEN 'Credit Card'
		else B.AcBuRevisedSegmentCode end AcBuRevisedSegmentCode
,DPD_Max
,CONVERT(VARCHAR(20),FinalNpaDt,103)         AS FinalNpaDt
,ISNULL(b.Balance,0)/@Cost                     AS Balance
,ISNULL(b.NetBalance,0)/@Cost                  AS NetBalance
,ISNULL(b.DrawingPower,0)/@Cost                AS DrawingPower
,ISNULL(b.CurrentLimit,0)/@Cost                AS CurrentLimit
,(CASE WHEN B.SourceName = 'Finacle' AND SchemeType = 'ODA' 
				THEN	(CASE WHEN (ISNULL(b.Balance,0) -(CASE WHEN ISNULL(b.DrawingPower,0)<ISNULL(b.CurrentLimit,0) THEN  ISNULL(b.DrawingPower,0) ELSE ISNULL(b.CurrentLimit,0)  END ))<=0
								THEN 0
							 ELSE  (CASE WHEN ISNULL(b.DrawingPower,0)<ISNULL(b.CurrentLimit,0) THEN  ISNULL(b.DrawingPower,0) ELSE ISNULL(b.CurrentLimit,0)  END ) 
						END) 
				ELSE 0 END)/@COST  OverDrawn_Amt 
, DPD_Overdrawn
,CONVERT(VARCHAR(20),ContiExcessDt,103)      AS ContiExcessDt
,CONVERT(VARCHAR(20),ReviewDueDt,103)        AS ReviewDueDt
, DPD_Renewal
,CONVERT(VARCHAR(20),StockStDt,103)          AS StockStDt
,DPD_StockStmt
,CONVERT(VARCHAR(20),DebitSinceDt,103)       AS DebitSinceDt
,CONVERT(VARCHAR(20),LastCrDate,103)         AS LastCrDate
,DPD_NoCredit
,ISNULL(b.CurQtrCredit,0)/@Cost                AS CurQtrCredit
,ISNULL(b.CurQtrInt,0)/@Cost                   AS CurQtrInt
,(CASE WHEN (ISNULL(b.CurQtrInt,0) -ISNULL(b.CurQtrCredit,0)) < 0 
       THEN 0 
	   ELSE (ISNULL(b.CurQtrInt,0) -ISNULL(b.CurQtrCredit,0)) 
	   END)/@Cost                                     AS [InterestNotServiced]
, DPD_IntService
, Dt.IntNotServicedDt                                                  AS [CC/OD Interest Service]
,(ISNULL(b.OverdueAmt,0)/@Cost)                          AS OverdueAmt
,CONVERT(VARCHAR(20),OverDueSinceDt,103)              AS OverDueSinceDt
,DPD_Overdue
,ISNULL(b.PrincOverdue,0)/@Cost                         AS PrincOverdue
,CONVERT(VARCHAR(20),PrincOverdueSinceDt,103)         AS PrincOverdueSinceDt
,DPD_PrincOverDue
,ISNULL(b.IntOverdue,0)/@Cost                           AS IntOverdue
,CONVERT(VARCHAR(20),IntOverdueSinceDt,103)           AS IntOverdueSinceDt
, DPD_IntOverdueSince
,ISNULL(b.OtherOverdue,0)/@Cost                         AS OtherOverdue
,CONVERT(VARCHAR(20),OtherOverdueSinceDt,103)         AS OtherOverdueSinceDt
,DPD_OtherOverdueSince
,(CASE WHEN SchemeType = 'FBA' then b.OverdueAmt else 0 END)   AS [Bill/PC Overdue Amount]
,''                                                   AS [Overdue Bill/PC ID]
,(CASE WHEN SchemeType = 'FBA' then CONVERT(varchar,OverDueSinceDt) else '' END)                                                   AS [Bill/PC Overdue Date]
,(CASE WHEN SchemeType = 'FBA' then DPD_Overdue else 0 END)                                                   AS [DPD Bill/PC]
,A2.AssetClassName                                    AS FinalAssetName
,REPLACE(isnull(B.NPA_Reason,b.DegReason),',','') as DegReason
,RefPeriodOverdue as NPANorms
--,B.DPD_Max
,B.NPA_Reason
,NULL AS  MocReason
,E.SrcSysClassName   SubAssetClass
FROM ACL_NPA_DATA B
LEFT JOIN DimAssetClass A2	        ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                       AND A2.EffectiveToTimeKey=49999



left Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
				 EffectiveFromTimeKey,EffectiveToTimeKey
				 from DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
                                              --And	C.SourceAlt_Key=D.SourceAlt_Key
                                              And	C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) E ON		E.AssetClassAlt_Key=B.InitialAssetClassAlt_Key 
                                                 ----And	C.SourceAlt_Key=D.SourceAlt_Key
                                                 And	C.EffectiveToTimeKey=49999

LEFT JOIN DimAcBuSegment S          ON B.ActSegmentCode=S.AcBuSegmentCode
                                       AND S.EffectiveToTimeKey=49999

LEFT JOIN DimBranch X               ON B.BranchCode = X.BranchCode
                                       AND X.EffectiveToTimeKey=49999

LEFT JOIN #IntNoserviedDt DT        ON B.CustomerAcid = Dt.CustomerAcID

WHERE InitialAssetClassAlt_Key = 1 and FinalAssetClassAlt_Key > 1
AND Convert(date,Process_date,105) between @From1  AND  @to1

OPTION(RECOMPILE)

DROP TABLE #IntNoserviedDt
GO
