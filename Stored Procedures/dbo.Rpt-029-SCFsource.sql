SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt-029-SCFsource]
      @TimeKey AS INT,
	  @Cost    AS FLOAT,
	  @SelectReport AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26629,
--	  @Cost    AS FLOAT=1,
--	  @SelectReport AS INT=2

DECLARE @Date AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)
DECLARE @LastQtrDateKey INT = (SELECT LastQtrDateKey FROM sysdaymatrix WHERE timekey=@TimeKey)
DECLARE @PerDayDateKey AS INT=@TimeKey-1

DECLARE @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)
---------------------------======================================DPD CalCULATION  Start===========================================

IF OBJECT_ID('TempDB..#DPD') Is Not Null
DROP TABLE #DPD


SELECT            CustomerAcID
                 ,AccountEntityID
                  ,IntNotServicedDt
                 ,LastCrDate
                 ,ContiExcessDt
                 ,OverDueSinceDt
                 ,ReviewDueDt
                 ,StockStDt
                 ,DebitSinceDt
                 ,PrincOverdueSinceDt
                 ,IntOverdueSinceDt
                 ,OtherOverdueSinceDt
                 ,SourceAlt_Key
INTO #DPD
FROM pro.AccountCal_Hist
WHERE EffectiveFromTimeKey <= @Timekey and EffectiveToTimeKey >= @Timekey

OPTION(RECOMPILE)
---------------
Alter Table #DPD
Add   DPD_IntService Int
      ,DPD_NoCredit Int
          ,DPD_Overdrawn Int
          ,DPD_Overdue Int---
          ,DPD_Renewal Int
          ,DPD_StockStmt Int
          ,DPD_PrincOverdue Int--
          ,DPD_IntOverdueSince Int--
          ,DPD_OtherOverdueSince Int
           ,DPD_Max Int--
-------------------

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)+1  ELSE 0 END)                          
             ,A.DPD_NoCredit = CASE WHEN (DebitSinceDt IS NULL OR DATEDIFF(DAY,DebitSinceDt,@ProcessDate)>=90)
                                                                                        THEN (CASE WHEN  A.LastCrDate IS NOT NULL
                                                                                        THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)+0
                                                                                        ELSE 0  
                                                                                       
                                                                                        END)
                                                                        ELSE 0 END

                         ,A.DPD_Overdrawn= (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate) + 1    ELSE 0 END)
                         ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
                         ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)  +1    ELSE 0 END)
                     ,A.DPD_StockStmt= (CASE WHEN  A.StockStDt IS NOT NULL THEN   DateDiff(Day,DATEADD(month,3,A.StockStDt),@ProcessDate)+1 ELSE 0 END)
                         ,A.DPD_PrincOverdue = (CASE WHEN  A.PrincOverdueSinceDt IS NOT NULL THEN DATEDIFF(DAY,A.PrincOverdueSinceDt,@ProcessDate)+1  ELSE 0 END)                          
             ,A.DPD_IntOverdueSince =  (CASE WHEN  A.IntOverdueSinceDt IS NOT NULL      THEN DATEDIFF(DAY,A.IntOverdueSinceDt,  @ProcessDate)+1       ELSE 0 END)
                         ,A.DPD_OtherOverdueSince =   (CASE WHEN  A.OtherOverdueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OtherOverdueSinceDt,  @ProcessDate)+1  ELSE 0 END)
FROM #DPD A


OPTION(RECOMPILE)

----New Condition Added By Report Team  02/08/2022 for 1 Augesut greter or equal ---

IF @TimeKey>=26511
BEGIN
UPDATE #DPD SET 
#DPD.DPD_IntService=0,
#DPD.DPD_NoCredit=0,
#DPD.DPD_Overdrawn=0,
#DPD.DPD_Overdue=0,
#DPD.DPD_Renewal=0,
#DPD.DPD_StockStmt=0,
#DPD.DPD_PrincOverdue=0,
#DPD.DPD_IntOverdueSince=0,
#DPD.DPD_OtherOverdueSince=0
FROM  Pro.ACCOUNTCAL_hist A
INNER JOIN AdvAcBalanceDetail C      ON A.AccountEntityId=C.AccountEntityId
INNER JOIN #DPD  DPD                 ON DPD.AccountEntityID=A.AccountEntityID
INNER JOIN DimProduct B              ON A.ProductCode=B.ProductCode 


WHERE ISNULL(A.Balance,0)=0 AND ISNULL(C.SignBalance,0)>=0
      AND B.EffectiveFromTimeKey <= @Timekey AND B.EffectiveToTimeKey >= @Timekey 
      AND C.EffectiveFromTimeKey <= @Timekey AND C.EffectiveToTimeKey >= @Timekey
      AND A.EffectiveFromTimeKey <= @Timekey AND A.EffectiveToTimeKey >= @Timekey
      AND A.DebitSinceDt IS NULL

OPTION(RECOMPILE)

END
------------------------------

 UPDATE #DPD SET DPD_IntService=0 WHERE ISNULL(DPD_IntService,0)<0
 UPDATE #DPD SET DPD_NoCredit=0 WHERE ISNULL(DPD_NoCredit,0)<0
 UPDATE #DPD SET DPD_Overdrawn=0 WHERE ISNULL(DPD_Overdrawn,0)<0
 UPDATE #DPD SET DPD_Overdue=0 WHERE ISNULL(DPD_Overdue,0)<0
 UPDATE #DPD SET DPD_Renewal=0 WHERE ISNULL(DPD_Renewal,0)<0
 UPDATE #DPD SET DPD_StockStmt=0 WHERE ISNULL(DPD_StockStmt,0)<0
 UPDATE #DPD SET DPD_PrincOverdue=0 WHERE ISNULL(DPD_PrincOverdue,0)<0
 UPDATE #DPD SET DPD_IntOverdueSince=0 WHERE ISNULL(DPD_IntOverdueSince,0)<0
 UPDATE #DPD SET DPD_OtherOverdueSince=0 WHERE ISNULL(DPD_OtherOverdueSince,0)<0

UPDATE A SET A.DPD_Max=0  FROM #Dpd  A
UPDATE   A SET A.DPD_Max= (CASE    WHEN (ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_NoCredit,0)
                                        AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdrawn,0)
                                                                                AND    ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdue,0)
                                                                                AND  ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Renewal,0)
                                                                                AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_StockStmt,0))
                                                                   THEN ISNULL(A.DPD_IntService,0)
                                   WHEN (ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_IntService,0)
                                                                        AND ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Overdrawn,0)
                                                                        AND    ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_Overdue,0)
                                                                        AND    ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Renewal,0)
                                                                        AND ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_StockStmt,0))
                                                                   THEN   ISNULL(A.DPD_NoCredit ,0)
                                                                   WHEN (ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_NoCredit,0)  
                                                                        AND ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_IntService,0)  
                                                                                AND  ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_Overdue,0)
                                                                                AND   ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_Renewal,0)
                                                                                AND ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_StockStmt,0))
                                                                   THEN  ISNULL(A.DPD_Overdrawn,0)
                                                                   WHEN (ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_NoCredit,0)    
                                                                        AND ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_IntService,0)  
                                                                                AND  ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_Overdrawn,0)  
                                                                                AND  ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_Overdue,0)  
                                                                                AND ISNULL(A.DPD_Renewal,0) >=ISNULL(A.DPD_StockStmt ,0))
                                                                   THEN ISNULL(A.DPD_Renewal,0)
                                       WHEN (ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_NoCredit,0)    
                                                                        AND ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_IntService,0)
                                                                            AND  ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_Overdrawn,0)  
                                                                                AND  ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_Renewal,0)  
                                                                                AND ISNULL(A.DPD_Overdue ,0)>=ISNULL(A.DPD_StockStmt ,0))  
                                                                   THEN   ISNULL(A.DPD_Overdue,0)
                                                                   ELSE ISNULL(A.DPD_StockStmt,0)
                                                END)
                         
FROM  #DPD a

WHERE  (ISNULL(A.DPD_IntService,0)>0   OR ISNULL(A.DPD_Overdrawn,0)>0   OR  ISNULL(A.DPD_Overdue,0)>0        
       OR ISNULL(A.DPD_Renewal,0) >0 OR ISNULL(A.DPD_StockStmt,0)>0 OR ISNULL(DPD_NoCredit,0)>0)

OPTION(RECOMPILE)


--------------------------------------

Drop table if exists #main


SELECT * into #main from ( select 
CONVERT(VARCHAR(20),@Date, 103)                  AS [Report Date]
,src.SourceName                                  AS [Source System]           
,B.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,A.CustomerName
,X.BranchCode
,X.BranchName
,B.CustomerAcID                                 AS  [Account No]

,'' AS [Account Open Date]
,B.FacilityType
,SchemeType
,B.ProductCode                                 As [Scheme Code]
,PD.ProductName                                AS [Scheme Description]
,ABD.CurrentLimit                              As [Limit Sanction Amount in INR] 
,'' AS [BillNo]
,'' AS [BillDt]
,'' AS [BillAmt]
,'' AS [BillPurDt]
,'' AS [Bill liability amount]
,'' AS [BillDueDt]
,'' AS [BillExtendedDueDt]
,'' AS [Limit expiry Dt]
,ISNULL(B.BalanceInCrncy,0)/@Cost                     AS BalanceInINR
,ISNULL(IntOverdue,0)                          AS Overdue_Interest
,'' As UnAppliedIntt
,CONVERT(VARCHAR(20),B.IntOverdueSinceDt,103)  AS Overdue_Interest_Date
,'' As [BillProductCode]
,DPD_Max
,ISNULL(B.Balance ,0)/@Cost                           AS [Balance Outstanding]                                      
,ISNULL(B.PrincOutStd,0)/@Cost                                  AS [Principal O/S (POS)]
,'' AS [Drawing Power]
,'' AS [Sanction Limit]
,B.PrincOverdue
,CONVERT(VARCHAR(20),B.PrincOverdueSinceDt,103)  AS [Principal Overdue Date]
,DPD_PrincOverdue
,B.IntOverdue 
,CONVERT(VARCHAR(20),B.IntOverdueSinceDt,103)  AS [Interest Overdue Date]
,DPD_IntOverdueSince
,'' AS [Penal Interest Overdue]
,'' AS [Penal Interest Overdue Date]
,'' AS [DPD Penal Interest Overdue]
,CONVERT(VARCHAR(20),B.OverDueSinceDt,103)  AS [Overdue Date]
,ISNULL(OverdueAmt,0)/@Cost  AS [OverdueAmt]
,DPD_Overdue
,'' AS [RFA/ Fraud Date]
,'' AS [Sub Assset Class]
,'' AS NPA_Date
,'' AS NPA_reason
,b.UnSecuredAmt 
, ROUND(ISNULL(CASE WHEN ROUND((ISNULL(ProvUnsecured,0)/NULLIF(UnSecuredAmt,0))*100,1) < 0.5 AND ROUND((ISNULL(ProvUnsecured,0)/NULLIF(UnSecuredAmt,0))*100,1) > 0  
THEN 0.4  ELSE ROUND((ISNULL(ProvUnsecured,0)/NULLIF(UnSecuredAmt,0))*100,2)  END,0),2) As [Provision UnSecured %]
,'' AS  [Additional Provision]
,'' AS  [Final Provision %]
,'' AS [Write Off Amount]
,ISNULL(B.NetBalance,0)/@Cost     As [Net Balance]
, case WHEN FinalAssetclassAlt_key = 1 THEN 0 ELSE ISNULL(UnAppliedIntAmount,0) End AS [Interest In Suspense Amount]
,'' [Total income suspended]
,'' AS [Flg Deg]
,'' AS [Flg Upg]
,Case WHEN ISNULL(RFA,'N')='Y'   THEN 'Yes'  ELSE 'No'End as [RFA Flag]
,Case WHEN ISNULL(FlgFraud,'N')='Y'   THEN 'Yes'  ELSE 'No' End as [Fraud Flag]
,A.CustomerName as [Borrower Name]



FROM AdvAcBasicDetail ABD inner join 

PRO.ACCOUNTCAL_hist B                           ON ABD.AccountEntityId=B.AccountEntityID
                                                         AND ABD.EffectiveFromTimeKey<=@TimeKey 
														 AND ABD.EffectiveToTimeKey>=@TimeKey				                  
                                                         AND B.EffectiveFromTimeKey<=@TimeKey
									                     AND B.EffectiveToTimeKey>=@TimeKey

INNER JOIN	   PRO.CUSTOMERCAL_hist A			ON A.CustomerEntityID=B.CustomerEntityID
                                                         AND A.EffectiveFromTimeKey<=@TimeKey
									                     AND A.EffectiveToTimeKey>=@TimeKey				                  

INNER JOIN #DPD DPD                             ON DPD.CustomerAcID=B.CustomerAcID
									                  
--LEFT JOIN #SecurityValueDetails SVD                   ON SVD.AccountEntityId=B.AccountEntityID
									                  
--LEFT JOIN #PREV_QTR   Y        	  	                  ON B.AccountEntityId = Y.AccountEntityId
									                  
--LEFT JOIN #PREV_DAY   Y1        	                  ON B.AccountEntityId = Y1.AccountEntityId

LEFT JOIN AdvAcOtherFinancialDetail FIN               ON B.AccountEntityId = FIN.AccountEntityId
                                                          AND FIN.EffectiveFromTimeKey<=@TimeKey
									                      AND FIN.EffectiveToTimeKey>=@TimeKey

--LEFT JOIN #MOC_Provision MOCP                         ON B.AccountEntityId = MOCP.AccountEntityId

LEFT JOIN SaletoARCFinalACFlagging SARC               ON SARC.AccountId=B.CustomerAcID
                                                         AND SARC.EffectiveFromTimeKey<=@TimeKey
									                     AND SARC.EffectiveToTimeKey>=@TimeKey

LEFT JOIN RP_Portfolio_Details  RPD                   ON RPD.CustomerId=B.RefCustomerID
                                                         AND RPD.EffectiveFromTimeKey<=@TimeKey
									                     AND RPD.EffectiveToTimeKey>=@TimeKey 
									   
LEFT JOIN DIMSOURCEDB src	                          ON B.SourceAlt_Key =src.SourceAlt_Key
                                                         AND src.EffectiveFromTimeKey<=@TimeKey
									                     AND src.EffectiveToTimeKey>=@TimeKey
									                  
									                  
LEFT JOIN DIMPRODUCT PD          	                  ON PD.PRODUCTALT_KEY=B.PRODUCTALT_KEY
                                                          AND PD.EffectiveFromTimeKey<=@TimeKey
									                      AND PD.EffectiveToTimeKey>=@TimeKey
									                  
									                  
LEFT JOIN DimAssetClass A2	                          ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                                         AND A2.EffectiveFromTimeKey<=@TimeKey
									                     AND A2.EffectiveToTimeKey>=@TimeKey
									                  
LEFT JOIN DimAcBuSegment S                            ON B.ActSegmentCode=S.AcBuSegmentCode
                                                         AND S.EffectiveFromTimeKey<=@TimeKey
									                     AND S.EffectiveToTimeKey>=@TimeKey
									                  
LEFT JOIN DimBranch X                                 ON B.BranchCode = X.BranchCode
                                                         AND X.EffectiveFromTimeKey<=@TimeKey
									                     AND X.EffectiveToTimeKey>=@TimeKey
									   where A.SourceAlt_Key=3
)A

Select * from #main

--OPTION(RECOMPILE)

--DROP TABLE #DPD,#SecurityValueDetails,#PREV_QTR,#PREV_DAY,#MOC_Provision

GO
