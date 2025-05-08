SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create   PROCEDURE [dbo].[Rpt-027_old]
	  @DateFrom	AS VARCHAR(15),
      @DateTo		AS VARCHAR(15),
	  @Cost    AS FLOAT
AS

--DECLARE 
	  
--@DateFrom	AS VARCHAR(15)='09/09/2021',
--@DateTo		AS VARCHAR(15)='19/09/2021',
--@Cost    AS FLOAT=1

DECLARE	@From1		DATE=(SELECT Rdate FROM dbo.DateConvert(@DateFrom))
DECLARE @to1		DATE=(SELECT Rdate FROM dbo.DateConvert(@DateTo))


----------------------------Upgrade Report-------------------------------

SELECT 
CONVERT(VARCHAR(20),Convert(date,Process_date,105), 103)           AS  [Process_date]
,B.UCIC                                       AS UCIC
,B.CustomerID                                 AS CustomerID
,CustomerName
,B.BranchCode
,BranchName
,CustomerAcID                                 AS CustomerAcID
,B.SourceName
,B.FacilityType
,B.SchemeType
,B.ProductCode
,B.ProductName
,ActSegmentCode
,CASE WHEN B.SourceName='Ganaseva' THEN 'FI'
		  WHEN B.SourceName='VisionPlus' THEN 'Credit Card'
		else AcBuSegmentDescription end AcBuSegmentDescription
,CASE WHEN B.SourceName='Ganaseva' THEN 'FI'
		  WHEN B.SourceName='VisionPlus' THEN 'Credit Card'
		else B.AcBuRevisedSegmentCode end AcBuRevisedSegmentCode
,''                                          AS  DPD_Max
,CONVERT(VARCHAR(20),FinalNpaDt,103)         AS FinalNpaDt
,CONVERT(VARCHAR(20),Convert(date,Process_date,105),103)         AS UpgDate
,ISNULL(Balance,0)/@Cost                     AS Balance
,ISNULL(NetBalance,0)/@Cost                  AS NetBalance
,ISNULL(DrawingPower,0)/@Cost                AS DrawingPower
,ISNULL(CurrentLimit,0)/@Cost                AS CurrentLimit
,(CASE WHEN B.SourceName = 'Finacle' AND B.SchemeType = 'ODA' 
				THEN	(CASE WHEN (ISNULL(Balance,0) -(CASE WHEN ISNULL(DrawingPower,0)<ISNULL(CurrentLimit,0) THEN  ISNULL(DrawingPower,0) ELSE ISNULL(CurrentLimit,0)  END ))<=0
								THEN 0
							 ELSE  (CASE WHEN ISNULL(DrawingPower,0)<ISNULL(CurrentLimit,0) THEN  ISNULL(DrawingPower,0) ELSE ISNULL(CurrentLimit,0)  END ) 
						END) 
				ELSE 0 END)/@COST  OverDrawn_Amt                                                                      
,''                                          AS DPD_Overdrawn
,CONVERT(VARCHAR(20),ContiExcessDt,103)      AS ContiExcessDt
,CONVERT(VARCHAR(20),ReviewDueDt,103)        AS ReviewDueDt
,''                                          AS DPD_Renewal
,CONVERT(VARCHAR(20),StockStDt,103)          AS StockStDt
,''                                          AS DPD_StockStmt
,CONVERT(VARCHAR(20),DebitSinceDt,103)       AS DebitSinceDt
,CONVERT(VARCHAR(20),LastCrDate,103)         AS LastCrDate
,''                                          AS DPD_NoCredit
,ISNULL(CurQtrCredit,0)/@Cost                AS CurQtrCredit
,ISNULL(CurQtrInt,0)/@Cost                   AS CurQtrInt
,CASE WHEN ISNULL(Agrischeme,'N') != 'Y' THEN (CASE WHEN (ISNULL(CurQtrInt,0) -ISNULL(CurQtrCredit,0)) < 0 
       THEN 0 
	   ELSE (ISNULL(CurQtrInt,0) -ISNULL(CurQtrCredit,0)) 
	   END)/@Cost        
	   ELSE 0 
	   END                                            AS [InterestNotServiced]
,''                                                   AS DPD_IntService
,0                                                    AS [CC/OD Interest Service]
,ISNULL(OverdueAmt,0)/@Cost                           AS OverdueAmt
,CONVERT(VARCHAR(20),OverDueSinceDt,103)              AS OverDueSinceDt
,''                                                   AS DPD_Overdue
,ISNULL(PrincOverdue,0)/@Cost                         AS PrincOverdue
,CONVERT(VARCHAR(20),PrincOverdueSinceDt,103)         AS PrincOverdueSinceDt
,''                                                   AS DPD_PrincOverdue
,ISNULL(IntOverdue,0)/@Cost                           AS IntOverdue
,CONVERT(VARCHAR(20),IntOverdueSinceDt,103)           AS IntOverdueSinceDt
,''                                                   AS DPD_IntOverdueSince
,ISNULL(OtherOverdue,0)/@Cost                         AS OtherOverdue
,CONVERT(VARCHAR(20),OtherOverdueSinceDt,103)         AS OtherOverdueSinceDt
,''                                                   AS  DPD_OtherOverdueSince
,0                                                    AS [Bill/PC Overdue Amount]
,''                                                   AS [Overdue Bill/PC ID]
,''                                                   AS [Bill/PC Overdue Date]
,''                                                   AS [DPD Bill/PC]
,A2.AssetClassName                                    AS FinalAssetName
--,A.DegReason
,RefPeriodOverdue as NPANorms
FROM ACL_UPG_DATA B
LEFT JOIN DIMSOURCEDB src	               ON B.SourceName =src.SourceName
                                              AND src.EffectiveToTimeKey=49999
											  	
LEFT JOIN DIMPRODUCT PD                    ON  PD.ProductCode=B.ProductCode
                                               AND PD.EffectiveToTimeKey=49999


LEFT JOIN DimAssetClass A2	               ON  A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                               AND A2.EffectiveToTimeKey=49999

LEFT JOIN DimAcBuSegment S                 ON B.ActSegmentCode=S.AcBuSegmentCode
                                              AND S.EffectiveToTimeKey=49999

LEFT JOIN DimBranch X                      ON B.BranchCode = X.BranchCode
                                              AND X.EffectiveToTimeKey=49999

WHERE B.FlgUpg='U' and Convert(date,Process_date,105) between @From1  AND  @to1




OPTION(RECOMPILE)

GO
