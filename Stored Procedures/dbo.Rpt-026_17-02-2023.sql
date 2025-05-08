SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Rpt-026_17-02-2023]
       @FromDate   AS VARCHAR(15)
      ,@ToDate     AS VARCHAR(15)
	  ,@Cost    AS FLOAT
AS

--DECLARE 
--       @FromDate   AS VARCHAR(15)='17/03/2022'
--      ,@ToDate     AS VARCHAR(15)='20/03/2022'
--	  ,@Cost    AS FLOAT=1


DECLARE	@From1		DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @To1		DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))

DECLARE @ProcessDate DATE=(SELECT DATE FROM Sysdaymatrix WHERE [DATE]=@From1)
DECLARE @ProcessDate1 DATE=(SELECT DATE FROM Sysdaymatrix WHERE [DATE]=@To1)

DECLARE @FromTimeKey INT=(SELECT TimeKey FROM Sysdaymatrix WHERE [DATE]=@From1)
DECLARE @ToTimeKey INT=(SELECT TimeKey FROM Sysdaymatrix WHERE [DATE]=@To1)


---------------------------======================================DPD CalCULATION  Start===========================================

IF OBJECT_ID('TempDB..#DPD') IS NOT NULL
DROP TABLE #DPD


SELECT            A.CustomerAcID
                 ,A.AccountEntityID
                 ,A.IntNotServicedDt
                 ,A.LastCrDate
                 ,A.ContiExcessDt
                 ,A.OverDueSinceDt
                 ,A.ReviewDueDt
                 ,A.StockStDt
                 ,A.DebitSinceDt
                 ,A.PrincOverdueSinceDt
                 ,A.IntOverdueSinceDt
                 ,A.OtherOverdueSinceDt
                 ,A.SourceAlt_Key
				 ,PenalInterestOverDueSinceDt
INTO #DPD
FROM pro.AccountCal_Hist A
LEFT JOIN  AdvAcOtherFinancialDetail FIN    ON A.AccountEntityId = FIN.AccountEntityId
                                               AND FIN.EffectiveFromTimeKey<=@FromTimeKey
									           AND FIN.EffectiveToTimeKey>=@FromTimeKey

WHERE A.EffectiveFromTimeKey <= @FromTimeKey and A.EffectiveToTimeKey >= @FromTimeKey

OPTION(RECOMPILE)
---------------
Alter Table #DPD
Add        DPD_IntService Int
          ,DPD_NoCredit Int
          ,DPD_Overdrawn Int
          ,DPD_Overdue Int
          ,DPD_Renewal Int
          ,DPD_StockStmt Int
          ,DPD_PrincOverdue Int
          ,DPD_IntOverdueSince Int
          ,DPD_OtherOverdueSince Int
          ,DPD_Max Int
		  ,DPD_PenalInterestOverdue INT

-------------------

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)+1  ELSE 0 END)                          
             ,A.DPD_NoCredit = CASE WHEN (DebitSinceDt IS NULL OR DATEDIFF(DAY,DebitSinceDt,@ProcessDate)>=90)
                                                                                        THEN (CASE WHEN  A.LastCrDate IS NOT NULL
                                                                                        THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)+0
                                                                                        ELSE 0  
                                                                                        END)
                                                                                        ELSE 0 
																						END

                         ,A.DPD_Overdrawn= (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate) + 1    ELSE 0 END)
                         ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
                         ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)  +1    ELSE 0 END)
                         ,A.DPD_StockStmt= (CASE WHEN  A.StockStDt IS NOT NULL THEN   DateDiff(Day,DATEADD(month,3,A.StockStDt),@ProcessDate)+1 ELSE 0 END)
                         ,A.DPD_PrincOverdue = (CASE WHEN  A.PrincOverdueSinceDt IS NOT NULL THEN DATEDIFF(DAY,A.PrincOverdueSinceDt,@ProcessDate)+1  ELSE 0 END)                          
                         ,A.DPD_IntOverdueSince =  (CASE WHEN  A.IntOverdueSinceDt IS NOT NULL      THEN DATEDIFF(DAY,A.IntOverdueSinceDt,  @ProcessDate)+1       ELSE 0 END)
                         ,A.DPD_OtherOverdueSince =   (CASE WHEN  A.OtherOverdueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OtherOverdueSinceDt,  @ProcessDate)+1  ELSE 0 END)
						 ,A.DPD_PenalInterestOverdue=(CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.PenalInterestOverDueSinceDt,  @ProcessDate)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
FROM #DPD A


OPTION(RECOMPILE)

----New Condition Added By Report Team  02/08/2022 for 1 Augesut greter or equal ---

IF @FromTimeKey>=26511
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


WHERE B.SchemeType='CAA'  AND ISNULL(A.Balance,0)=0 AND ISNULL(C.SignBalance,0)<0
      AND B.EffectiveFromTimeKey <= @FromTimeKey AND B.EffectiveToTimeKey >= @FromTimeKey 
      AND C.EffectiveFromTimeKey <= @FromTimeKey AND C.EffectiveToTimeKey >= @FromTimeKey
      AND A.EffectiveFromTimeKey <= @FromTimeKey AND A.EffectiveToTimeKey >= @FromTimeKey
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
 UPDATE #DPD SET DPD_PenalInterestOverdue=0 WHERE ISNULL(DPD_PenalInterestOverdue,0)<0

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

------------------------------------------------=========================END===========================
---------------------------======================================DPD CalCULATION  Start===========================================

IF OBJECT_ID('TempDB..#DPD1') IS NOT NULL
DROP TABLE #DPD1


SELECT            A.CustomerAcID
                 ,A.AccountEntityID
                 ,A.IntNotServicedDt
                 ,A.LastCrDate
                 ,A.ContiExcessDt
                 ,A.OverDueSinceDt
                 ,A.ReviewDueDt
                 ,A.StockStDt
                 ,A.DebitSinceDt
                 ,A.PrincOverdueSinceDt
                 ,A.IntOverdueSinceDt
                 ,A.OtherOverdueSinceDt
                 ,A.SourceAlt_Key
				 ,PenalInterestOverDueSinceDt
INTO #DPD1
FROM pro.AccountCal_Hist A
LEFT JOIN  AdvAcOtherFinancialDetail FIN    ON A.AccountEntityId = FIN.AccountEntityId
                                               AND FIN.EffectiveFromTimeKey<=@ToTimeKey
									           AND FIN.EffectiveToTimeKey>=@ToTimeKey

WHERE A.EffectiveFromTimeKey <= @ToTimeKey and A.EffectiveToTimeKey >= @ToTimeKey

OPTION(RECOMPILE)
---------------
Alter Table #DPD1
Add        DPD_IntService Int
          ,DPD_NoCredit Int
          ,DPD_Overdrawn Int
          ,DPD_Overdue Int
          ,DPD_Renewal Int
          ,DPD_StockStmt Int
          ,DPD_PrincOverdue Int
          ,DPD_IntOverdueSince Int
          ,DPD_OtherOverdueSince Int
          ,DPD_Max Int
		  ,DPD_PenalInterestOverdue INT

-------------------

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate1)+1  ELSE 0 END)                          
             ,A.DPD_NoCredit = CASE WHEN (DebitSinceDt IS NULL OR DATEDIFF(DAY,DebitSinceDt,@ProcessDate1)>=90)
                                                                                        THEN (CASE WHEN  A.LastCrDate IS NOT NULL
                                                                                        THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate1)+0
                                                                                        ELSE 0  
                                                                                        END)
                                                                                        ELSE 0 
																						END

                         ,A.DPD_Overdrawn= (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate1) + 1    ELSE 0 END)
                         ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate1)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
                         ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate1)  +1    ELSE 0 END)
                         ,A.DPD_StockStmt= (CASE WHEN  A.StockStDt IS NOT NULL THEN   DateDiff(Day,DATEADD(month,3,A.StockStDt),@ProcessDate1)+1 ELSE 0 END)
                         ,A.DPD_PrincOverdue = (CASE WHEN  A.PrincOverdueSinceDt IS NOT NULL THEN DATEDIFF(DAY,A.PrincOverdueSinceDt,@ProcessDate1)+1  ELSE 0 END)                          
                         ,A.DPD_IntOverdueSince =  (CASE WHEN  A.IntOverdueSinceDt IS NOT NULL      THEN DATEDIFF(DAY,A.IntOverdueSinceDt,  @ProcessDate1)+1       ELSE 0 END)
                         ,A.DPD_OtherOverdueSince =   (CASE WHEN  A.OtherOverdueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OtherOverdueSinceDt,  @ProcessDate1)+1  ELSE 0 END)
						 ,A.DPD_PenalInterestOverdue=(CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.PenalInterestOverDueSinceDt,  @ProcessDate1)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
FROM #DPD1 A


OPTION(RECOMPILE)

----New Condition Added By Report Team  02/08/2022 for 1 Augesut greter or equal ---

IF @ToTimeKey>=26511
BEGIN
UPDATE #DPD1 SET 
#DPD1.DPD_IntService=0,
#DPD1.DPD_NoCredit=0,
#DPD1.DPD_Overdrawn=0,
#DPD1.DPD_Overdue=0,
#DPD1.DPD_Renewal=0,
#DPD1.DPD_StockStmt=0,
#DPD1.DPD_PrincOverdue=0,
#DPD1.DPD_IntOverdueSince=0,
#DPD1.DPD_OtherOverdueSince=0
FROM  Pro.ACCOUNTCAL_hist A
INNER JOIN AdvAcBalanceDetail C      ON A.AccountEntityId=C.AccountEntityId
INNER JOIN #DPD1  DPD                 ON DPD.AccountEntityID=A.AccountEntityID
INNER JOIN DimProduct B              ON A.ProductCode=B.ProductCode 


WHERE B.SchemeType='CAA'  AND ISNULL(A.Balance,0)=0 AND ISNULL(C.SignBalance,0)<0
      AND B.EffectiveFromTimeKey <= @ToTimeKey AND B.EffectiveToTimeKey >= @ToTimeKey 
      AND C.EffectiveFromTimeKey <= @ToTimeKey AND C.EffectiveToTimeKey >= @ToTimeKey
      AND A.EffectiveFromTimeKey <= @ToTimeKey AND A.EffectiveToTimeKey >= @ToTimeKey
      AND A.DebitSinceDt IS NULL

OPTION(RECOMPILE)

END
------------------------------

 UPDATE #DPD1 SET DPD_IntService=0 WHERE ISNULL(DPD_IntService,0)<0
 UPDATE #DPD1 SET DPD_NoCredit=0 WHERE ISNULL(DPD_NoCredit,0)<0
 UPDATE #DPD1 SET DPD_Overdrawn=0 WHERE ISNULL(DPD_Overdrawn,0)<0
 UPDATE #DPD1 SET DPD_Overdue=0 WHERE ISNULL(DPD_Overdue,0)<0
 UPDATE #DPD1 SET DPD_Renewal=0 WHERE ISNULL(DPD_Renewal,0)<0
 UPDATE #DPD1 SET DPD_StockStmt=0 WHERE ISNULL(DPD_StockStmt,0)<0
 UPDATE #DPD1 SET DPD_PrincOverdue=0 WHERE ISNULL(DPD_PrincOverdue,0)<0
 UPDATE #DPD1 SET DPD_IntOverdueSince=0 WHERE ISNULL(DPD_IntOverdueSince,0)<0
 UPDATE #DPD1 SET DPD_OtherOverdueSince=0 WHERE ISNULL(DPD_OtherOverdueSince,0)<0
 UPDATE #DPD1 SET DPD_PenalInterestOverdue=0 WHERE ISNULL(DPD_PenalInterestOverdue,0)<0

UPDATE A SET A.DPD_Max=0  FROM #DPD1  A
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
                         
FROM  #DPD1 a

WHERE  (ISNULL(A.DPD_IntService,0)>0   OR ISNULL(A.DPD_Overdrawn,0)>0   OR  ISNULL(A.DPD_Overdue,0)>0        
       OR ISNULL(A.DPD_Renewal,0) >0 OR ISNULL(A.DPD_StockStmt,0)>0 OR ISNULL(DPD_NoCredit,0)>0)

------------------------------------------------=========================END===========================

---------Degrade Report-------------------

SELECT 
DISTINCT
CONVERT(VARCHAR(20),@ProcessDate, 103)                  AS  [Process_date]
,SourceName
,B.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,CustomerName
,B.Branchcode
,BranchName
,B.CustomerAcID
,CONVERT(VARCHAR(20),B.AcOpenDt,103)             AS AcOpenDt
,B.FacilityType
,SchemeType
,B.ProductCode
,ProductName
,DPD_Max
,CONVERT(VARCHAR(20),FinalNpaDt,103)           AS FinalNpaDt
,ISNULL(B.Balance,0)/@Cost                     AS Balance
,ISNULL(B.PrincOutStd,0)/@Cost                 AS PrincOutStd
,ISNULL(B.DrawingPower,0)/@Cost                AS DrawingPower
,ISNULL(B.CurrentLimit,0)/@Cost                AS CurrentLimit
,CONVERT(VARCHAR(20),B.ContiExcessDt,103)      AS ContiExcessDt
,DPD_Overdrawn
,CONVERT(VARCHAR(20),B.ReviewDueDt,103)        AS ReviewDueDt
,DPD_Renewal
,CONVERT(VARCHAR(20),B.StockStDt,103)          AS StockStDt
,DPD_StockStmt
,CONVERT(VARCHAR(20),B.DebitSinceDt,103)       AS DebitSinceDt
,CONVERT(VARCHAR(20),B.LastCrDate,103)         AS LastCrDate
,DPD_NoCredit
,ISNULL(B.CurQtrCredit,0)/@Cost                AS CurQtrCredit
,ISNULL(B.CurQtrInt,0)/@Cost                   AS CurQtrInt
,ISNULL(B.PrincOverdue,0)/@Cost                         AS PrincOverdue
,CONVERT(VARCHAR(20),B.PrincOverdueSinceDt,103)           AS PrincOverdueSinceDt
,DPD_PrincOverDue
,ISNULL(b.IntOverdue,0)/@Cost                           AS IntOverdue
,CONVERT(VARCHAR(20),B.IntOverdueSinceDt,103)           AS IntOverdueSinceDt
,DPD_IntOverdueSince
,ISNULL(FIN.PenalOverdueinterest,0)/@Cost                                  AS Penal_Interest_Overdue
,CONVERT(VARCHAR(20),FIN.PenalInterestOverDueSinceDt,103)                  AS Penal_Interest_Overdue_Date
,ISNULL(DPD_PenalInterestOverdue,0)                                        AS DPD_Penal_Interest_Overdue
,ISNULL(B.OtherOverdue,0)/@Cost                         AS OtherOverdue
,CONVERT(VARCHAR(20),B.OtherOverdueSinceDt,103)         AS OtherOverdueSinceDt
,DPD_OtherOverdueSince
,ISNULL(B.OverdueAmt,0)/@Cost                            AS OverdueAmt
,CONVERT(VARCHAR(20),B.OverDueSinceDt,103)                 AS OverDueSinceDt
,DPD_Overdue
,FlgFraud                                                                  AS RFA_Fraud_Flag
,CONVERT(VARCHAR(20),FraudDate,103)                                        AS RFA_Fraud_Date
,CASE WHEN C.AssetClassAlt_Key=1
      THEN (CASE WHEN B.SMA_Class='STD' THEN 'STANDARD'
	            WHEN B.SMA_Class='SMA_0' THEN 'SMA 0'
				WHEN B.SMA_Class='SMA_1' THEN 'SMA 1'
				WHEN B.SMA_Class='SMA_2' THEN 'SMA 2' 
				END)
	  ELSE C.SrcSysClassName 
	  END                                                                  AS SubAssetClass 
,A2.AssetClassName                                                         AS AssetClass
,CONVERT(VARCHAR(20),FinalNpaDt,103)                                       AS AssetClassDate
,SMA_Class                                                                 AS SMA_Class
,CASE WHEN SMA_Class='SMA_0'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date0 
,CASE WHEN SMA_Class='SMA_1'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date1 
,CASE WHEN SMA_Class='SMA_2'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date2
,ISNULL(B.TotalProvision,0)/@Cost                                          AS TotalProvision 
,ISNULL(NetBalance,0)/@Cost                                                AS NetBalance
,ISNULL(B.WriteOffAmount,0)/@Cost                                          AS WriteOffAmount
,ISNULL(FIN.UnAppliedIntAmount,0)/@Cost                                    AS InterestInSuspenseAmount
,0                                                                         AS TotalIncomeSuspended
,REPLACE(ISNULL(B.NPA_Reason,B.DegReason),',','')                          AS DegReason


FROM PRO.CUSTOMERCAL_Hist A
INNER JOIN pro.AccountCal_Hist B           ON A.CustomerEntityID=B.CustomerEntityID
                                              AND A.EffectiveFromTimeKey<=@FromTimeKey
									          AND A.EffectiveToTimeKey>=@FromTimeKey
                                              AND B.EffectiveFromTimeKey<=@FromTimeKey
									          AND B.EffectiveToTimeKey>=@FromTimeKey
									  

INNER JOIN #DPD PD          	           ON  PD.CustomerAcID=B.CustomerAcID

INNER JOIN SysDayMatrix SDM          	   ON  SDM.TimeKey=B.EffectiveFromTimeKey

LEFT JOIN DimAssetClass A2	               ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                              AND A2.EffectiveFromTimeKey <= @FromTimeKey 
											  AND A2.EffectiveToTimeKey >= @FromTimeKey

LEFT JOIN DimSourceDB SRC	               ON B.SourceAlt_Key =SRC.SourceAlt_Key
                                              AND SRC.EffectiveFromTimeKey <= @FromTimeKey 
											  AND SRC.EffectiveToTimeKey >= @FromTimeKey

LEFT JOIN DimProduct DP                    ON  DP.ProductCode=B.ProductCode
                                               AND DP.EffectiveFromTimeKey <= @FromTimeKey 
											   AND DP.EffectiveToTimeKey >= @FromTimeKey

LEFT JOIN		(SELECT DISTINCT SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
				 EffectiveFromTimeKey,EffectiveToTimeKey
				 FROM DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
                                              AND C.SourceAlt_Key=DP.SourceAlt_Key
                                              AND C.EffectiveFromTimeKey <= @FromTimeKey 
											  AND C.EffectiveToTimeKey >= @FromTimeKey

LEFT JOIN DimBranch X                      ON B.BranchCode = X.BranchCode
                                              AND x.EffectiveFromTimeKey <= @FromTimeKey 
									          AND X.EffectiveToTimeKey >= @FromTimeKey

LEFT JOIN AdvAcOtherFinancialDetail FIN    ON B.AccountEntityId = FIN.AccountEntityId
                                               AND FIN.EffectiveFromTimeKey<=@FromTimeKey
									           AND FIN.EffectiveToTimeKey>=@FromTimeKey


WHERE InitialAssetClassAlt_Key = 1 AND FinalAssetClassAlt_Key > 1

UNION ALL

SELECT 
DISTINCT
CONVERT(VARCHAR(20),@ProcessDate1, 103)                  AS  [Process_date]
,SourceName
,B.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,CustomerName
,B.Branchcode
,BranchName
,B.CustomerAcID
,CONVERT(VARCHAR(20),B.AcOpenDt,103)             AS AcOpenDt
,B.FacilityType
,SchemeType
,B.ProductCode
,ProductName
,DPD_Max
,CONVERT(VARCHAR(20),FinalNpaDt,103)          AS FinalNpaDt
,ISNULL(B.Balance,0)/@Cost                     AS Balance
,ISNULL(B.PrincOutStd,0)/@Cost                 AS PrincOutStd
,ISNULL(B.DrawingPower,0)/@Cost                AS DrawingPower
,ISNULL(B.CurrentLimit,0)/@Cost                AS CurrentLimit
,CONVERT(VARCHAR(20),B.ContiExcessDt,103)      AS ContiExcessDt
,DPD_Overdrawn
,CONVERT(VARCHAR(20),B.ReviewDueDt,103)        AS ReviewDueDt
,DPD_Renewal
,CONVERT(VARCHAR(20),B.StockStDt,103)          AS StockStDt
,DPD_StockStmt
,CONVERT(VARCHAR(20),B.DebitSinceDt,103)       AS DebitSinceDt
,CONVERT(VARCHAR(20),B.LastCrDate,103)         AS LastCrDate
,DPD_NoCredit
,ISNULL(B.CurQtrCredit,0)/@Cost                AS CurQtrCredit
,ISNULL(B.CurQtrInt,0)/@Cost                   AS CurQtrInt
,ISNULL(B.PrincOverdue,0)/@Cost                         AS PrincOverdue
,CONVERT(VARCHAR(20),B.PrincOverdueSinceDt,103)           AS PrincOverdueSinceDt
,DPD_PrincOverDue
,ISNULL(b.IntOverdue,0)/@Cost                           AS IntOverdue
,CONVERT(VARCHAR(20),B.IntOverdueSinceDt,103)           AS IntOverdueSinceDt
,DPD_IntOverdueSince
,ISNULL(FIN.PenalOverdueinterest,0)/@Cost                                  AS Penal_Interest_Overdue
,CONVERT(VARCHAR(20),FIN.PenalInterestOverDueSinceDt,103)                  AS Penal_Interest_Overdue_Date
,ISNULL(DPD_PenalInterestOverdue,0)                                        AS DPD_Penal_Interest_Overdue
,ISNULL(B.OtherOverdue,0)/@Cost                         AS OtherOverdue
,CONVERT(VARCHAR(20),B.OtherOverdueSinceDt,103)         AS OtherOverdueSinceDt
,DPD_OtherOverdueSince
,ISNULL(B.OverdueAmt,0)/@Cost                            AS OverdueAmt
,CONVERT(VARCHAR(20),B.OverDueSinceDt,103)                 AS OverDueSinceDt
,DPD_Overdue
,FlgFraud                                                                  AS RFA_Fraud_Flag
,CONVERT(VARCHAR(20),FraudDate,103)                                        AS RFA_Fraud_Date
,CASE WHEN C.AssetClassAlt_Key=1
      THEN (CASE WHEN B.SMA_Class='STD' THEN 'STANDARD'
	            WHEN B.SMA_Class='SMA_0' THEN 'SMA 0'
				WHEN B.SMA_Class='SMA_1' THEN 'SMA 1'
				WHEN B.SMA_Class='SMA_2' THEN 'SMA 2' 
				END)
	  ELSE C.SrcSysClassName 
	  END                                                                  AS SubAssetClass 
,A2.AssetClassName                                                         AS AssetClass
,CONVERT(VARCHAR(20),FinalNpaDt,103)                                       AS AssetClassDate
,SMA_Class                                                                 AS SMA_Class
,CASE WHEN SMA_Class='SMA_0'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date0 
,CASE WHEN SMA_Class='SMA_1'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date1 
,CASE WHEN SMA_Class='SMA_2'
      THEN CONVERT(VARCHAR(20),SDM.DATE,103)
	  END                                                                  AS SMA_Date2
,ISNULL(B.TotalProvision,0)/@Cost                                          AS TotalProvision 
,ISNULL(NetBalance,0)/@Cost                                                AS NetBalance
,ISNULL(B.WriteOffAmount,0)/@Cost                                          AS WriteOffAmount
,ISNULL(FIN.UnAppliedIntAmount,0)/@Cost                                    AS InterestInSuspenseAmount
,0                                                                         AS TotalIncomeSuspended
,REPLACE(ISNULL(B.NPA_Reason,B.DegReason),',','')                          AS DegReason


FROM PRO.CUSTOMERCAL_Hist A
INNER JOIN pro.AccountCal_Hist B           ON A.CustomerEntityID=B.CustomerEntityID
                                              AND A.EffectiveFromTimeKey<=@ToTimeKey
									          AND A.EffectiveToTimeKey>=@ToTimeKey
                                              AND B.EffectiveFromTimeKey<=@ToTimeKey
									          AND B.EffectiveToTimeKey>=@ToTimeKey

INNER JOIN SysDayMatrix SDM          	   ON  SDM.TimeKey=B.EffectiveFromTimeKey									  

INNER JOIN #DPD1 PD          	           ON  PD.CustomerAcID=B.CustomerAcID

LEFT JOIN DimAssetClass A2	               ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                              AND A2.EffectiveFromTimeKey <= @ToTimeKey 
											  AND A2.EffectiveToTimeKey >= @ToTimeKey

LEFT JOIN DimSourceDB SRC	               ON B.SourceAlt_Key =SRC.SourceAlt_Key
                                              AND SRC.EffectiveFromTimeKey <= @ToTimeKey 
											  AND SRC.EffectiveToTimeKey >= @ToTimeKey

LEFT JOIN DimProduct DP                    ON  DP.ProductCode=B.ProductCode
                                               AND DP.EffectiveFromTimeKey <= @ToTimeKey 
											   AND DP.EffectiveToTimeKey >= @ToTimeKey

LEFT JOIN		(SELECT DISTINCT SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
				 EffectiveFromTimeKey,EffectiveToTimeKey
				 FROM DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
                                              AND C.SourceAlt_Key=DP.SourceAlt_Key
                                              AND C.EffectiveFromTimeKey <= @ToTimeKey 
											  AND C.EffectiveToTimeKey >= @ToTimeKey




LEFT JOIN DimBranch X                      ON B.BranchCode = X.BranchCode
                                              AND x.EffectiveFromTimeKey <= @ToTimeKey 
									          AND X.EffectiveToTimeKey >= @ToTimeKey

LEFT JOIN AdvAcOtherFinancialDetail FIN    ON B.AccountEntityId = FIN.AccountEntityId
                                               AND FIN.EffectiveFromTimeKey<=@ToTimeKey
									           AND FIN.EffectiveToTimeKey>=@ToTimeKey


WHERE InitialAssetClassAlt_Key = 1 AND FinalAssetClassAlt_Key > 1

OPTION(RECOMPILE)

DROP TABLE #DPD,#DPD1


GO
