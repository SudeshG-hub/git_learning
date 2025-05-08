SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt-029_08-08-2022]
      @TimeKey AS INT,
	  @Cost    AS FLOAT
AS

--DECLARE 
--      @TimeKey AS INT=26511,
--	  @Cost    AS FLOAT=1

DECLARE @Date AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)
DECLARE @LastQtrDateKey INT = (SELECT LastQtrDateKey FROM sysdaymatrix WHERE timekey=@TimeKey)
DECLARE @PerDayDateKey AS INT=@TimeKey-1

DECLARE @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)


---------------------------======================================DPD CalCULATION  Start===========================================

 IF OBJECT_ID('TempDB..#DPD') Is Not Null
Drop Table #DPD


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
          ,DPD_Overdue Int
          ,DPD_Renewal Int
          ,DPD_StockStmt Int
          ,DPD_PrincOverdue Int
          ,DPD_IntOverdueSince Int
          ,DPD_OtherOverdueSince Int
           ,DPD_Max Int
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


WHERE B.SchemeType='CAA'  AND ISNULL(A.Balance,0)=0 AND ISNULL(C.SignBalance,0)<0
      AND B.EffectiveFromTimeKey <= @Timekey AND B.EffectiveToTimeKey >= @Timekey 
      AND C.EffectiveFromTimeKey <= @Timekey AND C.EffectiveToTimeKey >= @Timekey
      AND A.EffectiveFromTimeKey <= @Timekey AND A.EffectiveToTimeKey >= @Timekey
      AND A.DebitSinceDt IS NULL

OPTION(RECOMPILE)

END
------------------------------

 UPDATE #DPD SET DPD_IntService=0 WHERE isnull(DPD_IntService,0)<0
 UPDATE #DPD SET DPD_NoCredit=0 WHERE isnull(DPD_NoCredit,0)<0
 UPDATE #DPD SET DPD_Overdrawn=0 WHERE isnull(DPD_Overdrawn,0)<0
 UPDATE #DPD SET DPD_Overdue=0 WHERE isnull(DPD_Overdue,0)<0
 UPDATE #DPD SET DPD_Renewal=0 WHERE isnull(DPD_Renewal,0)<0
 UPDATE #DPD SET DPD_StockStmt=0 WHERE isnull(DPD_StockStmt,0)<0
 UPDATE #DPD SET DPD_PrincOverdue=0 WHERE isnull(DPD_PrincOverdue,0)<0
 UPDATE #DPD SET DPD_IntOverdueSince=0 WHERE isnull(DPD_IntOverdueSince,0)<0
 UPDATE #DPD SET DPD_OtherOverdueSince=0 WHERE isnull(DPD_OtherOverdueSince,0)<0

UPDATE A SET A.DPD_Max=0  FROM #Dpd  A
UPDATE   A SET A.DPD_Max= (CASE    WHEN (isnull(A.DPD_IntService,0)>=isnull(A.DPD_NoCredit,0)
                                        AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdrawn,0)
                                                                                AND    isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdue,0)
                                                                                AND  isnull(A.DPD_IntService,0)>=isnull(A.DPD_Renewal,0)
                                                                                AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN isnull(A.DPD_IntService,0)
                                   WHEN (isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_IntService,0)
                                                                        AND isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Overdrawn,0)
                                                                        AND    isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_Overdue,0)
                                                                        AND    isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Renewal,0)
                                                                        AND isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN   isnull(A.DPD_NoCredit ,0)
                                                                   WHEN (isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_NoCredit,0)  
                                                                        AND isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_IntService,0)  
                                                                                AND  isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_Overdue,0)
                                                                                AND   isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_Renewal,0)
                                                                                AND isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN  isnull(A.DPD_Overdrawn,0)
                                                                   WHEN (isnull(A.DPD_Renewal,0)>=isnull(A.DPD_NoCredit,0)    
                                                                        AND isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_IntService,0)  
                                                                                AND  isnull(A.DPD_Renewal,0)>=isnull(A.DPD_Overdrawn,0)  
                                                                                AND  isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_Overdue,0)  
                                                                                AND isnull(A.DPD_Renewal,0) >=isnull(A.DPD_StockStmt ,0))
                                                                   THEN isnull(A.DPD_Renewal,0)
                                       WHEN (isnull(A.DPD_Overdue,0)>=isnull(A.DPD_NoCredit,0)    
                                                                        AND isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_IntService,0)
                                                                            AND  isnull(A.DPD_Overdue,0)>=isnull(A.DPD_Overdrawn,0)  
                                                                                AND  isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_Renewal,0)  
                                                                                AND isnull(A.DPD_Overdue ,0)>=isnull(A.DPD_StockStmt ,0))  
                                                                   THEN   isnull(A.DPD_Overdue,0)
                                                                   ELSE isnull(A.DPD_StockStmt,0)
                                                END)
                         
FROM  #DPD a

WHERE  (isnull(A.DPD_IntService,0)>0   OR isnull(A.DPD_Overdrawn,0)>0   OR  Isnull(A.DPD_Overdue,0)>0        
       OR isnull(A.DPD_Renewal,0) >0 OR isnull(A.DPD_StockStmt,0)>0 OR isnull(DPD_NoCredit,0)>0)

OPTION(RECOMPILE)
-------------------------------------
 IF OBJECT_ID('TempDB..#PREV_DAY') Is Not Null
Drop Table #PREV_DAY

SELECT 
A. CustomerEntityID,
B.AccountEntityId,
ASSET.AssetClassName,
ISNULL(NetBalance,0)                                 AS NetBalance,
ISNULL(SecuredAmt,0)                                 AS SecuredAmt,
ISNULL(UnSecuredAmt,0)                               AS UnSecuredAmt,
ISNULL(TotalProvision,0)                             AS TotalProvision,
ISNULL(Provsecured,0)                                AS Provsecured,
ISNULL(ProvUnsecured,0)                              AS ProvUnsecured,
CASE WHEN AssetClassName <>'STANDARD' THEN (ISNULL(NetBalance,0)-ISNULL(totalprovision,0)) END   AS NetNPA
,(ISNULL(NetBalance,0)-ISNULL(totalprovision,0))    AS NetNPA1

INTO #PREV_DAY
FROM PRO.CUSTOMERCAL_hist A
INNER JOIN PRO.ACCOUNTCAL_hist B	          ON A.CustomerEntityID=B.CustomerEntityID

LEFT JOIN DimAssetClass ASSET	              ON ASSET.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                                 AND ASSET.EffectiveFromTimeKey<=@PerDayDateKey
									             AND ASSET.EffectiveToTimeKey>=@PerDayDateKey

WHERE B.EffectiveFromTimeKey <= @PerDayDateKey AND B.EffectiveToTimeKey >=@PerDayDateKey
      AND A.EffectiveFromTimeKey <= @PerDayDateKey AND A.EffectiveToTimeKey >=@PerDayDateKey
OPTION(RECOMPILE)
------------------------
 IF OBJECT_ID('TempDB..#PREV_QTR') Is Not Null
Drop Table #PREV_QTR


SELECT 
A. CustomerEntityID,
B.AccountEntityId,
ASSET.AssetClassName,
ISNULL(NetBalance,0)                                 AS NetBalance,
ISNULL(SecuredAmt,0)                                 AS SecuredAmt,
ISNULL(UnSecuredAmt,0)                               AS UnSecuredAmt,
ISNULL(TotalProvision,0)                             AS TotalProvision,
ISNULL(Provsecured,0)                                AS Provsecured,
ISNULL(ProvUnsecured,0)                              AS ProvUnsecured,
CASE WHEN AssetClassName <>'STANDARD' THEN (ISNULL(NetBalance,0)-ISNULL(totalprovision,0)) END   AS NetNPA
,(ISNULL(NetBalance,0)-ISNULL(totalprovision,0))    AS NetNPA1

INTO #PREV_QTR
FROM PRO.CUSTOMERCAL_hist A
INNER JOIN PRO.ACCOUNTCAL_hist B	          ON A.CustomerEntityID=B.CustomerEntityID

LEFT JOIN DimAssetClass ASSET	              ON ASSET.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                                 AND ASSET.EffectiveFromTimeKey<=@LastQtrDateKey
									             AND ASSET.EffectiveToTimeKey>=@LastQtrDateKey

WHERE B.EffectiveFromTimeKey <= @LastQtrDateKey AND B.EffectiveToTimeKey >=@LastQtrDateKey
      AND A.EffectiveFromTimeKey <= @LastQtrDateKey AND A.EffectiveToTimeKey >=@LastQtrDateKey

OPTION(RECOMPILE)

-----------------------------------Provision

SELECT 
CONVERT(VARCHAR(20),@Date, 103)                  AS  [Process_date]
,A.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,CustomerName
,B.BranchCode
,BranchName
,B.CustomerAcID
,SourceName
,B.FacilityType
,SchemeType
,B.ProductCode
,ProductName
,ActSegmentCode
,AcBuSegmentDescription
,AcBuRevisedSegmentCode
,DPD_Max
,CASE  WHEN A.SourceAlt_Key = 6 
        THEN 'CD' 
		ELSE '' 
		END                                                          AS [Cycle Past due]
,CONVERT(VARCHAR(20),FinalNpaDt,103)                                 AS FinalNpaDt
,A2.AssetClassName                                                   AS FinalAssetName
,NPANorms	
,ISNULL(B.Balance,0)/@Cost                                           AS Balance							                             
,ISNULL(B.NetBalance,0)/@Cost                                        AS NetBalance
,ISNULL(A.CurntQtrRv,0)/@Cost                                        AS SecurityValue
,ISNULL(ApprRV,0)/@Cost                                              AS ApprRV
,ISNULL(B.SecuredAmt,0)/@Cost                                        AS SecuredAmt
,ISNULL(B.UnSecuredAmt,0)/@Cost                                      AS UnSecuredAmt
,ISNULL(B.TotalProvision,0)/@Cost                                    AS TotalProvision
,ISNULL(B.Provsecured,0)/@Cost                                       AS Provsecured
,ISNULL(B.ProvUnsecured,0)/@Cost                                     AS ProvUnsecured
,ISNULL(PrincOutStd,0)/@Cost                                         AS PrincOutStd
,ISNULL(UsedRV,0)/@Cost                                              AS SecurityRV
,CASE WHEN A2.AssetClassName  <>'STANDARD'
      THEN (ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0))/@Cost 
	  ELSE 0 
	  END           AS [Net NPA]
,(ISNULL(B.Provsecured,0)/NULLIF(B.SecuredAmt,0))*100                AS [ProvisionSecured%]
,(ISNULL(B.ProvUnsecured,0)/NULLIF(B.UnSecuredAmt,0))*100            AS [ProvisionUnSecured%]
,(ISNULL(B.TotalProvision,0)/NULLIF(B.NetBalance,0))*100             AS [ProvisionTotal%]
,ISNULL(Y.NetBalance,0)/@Cost                                        AS [Prev. Qtr. Balance Outstanding]
,ISNULL(Y.SecuredAmt,0)/@Cost	                                     AS [Prev. Qtr. Secured Outstanding]
,ISNULL(Y.UnSecuredAmt,0)/@Cost	                                     AS [Prev. Qtr. Unsecured Outstanding]
,ISNULL(Y.TotalProvision,0)/@Cost	                                 AS [Prev. Qtr.Provision Total]
,ISNULL(Y.Provsecured,0)/@Cost	                                     AS [Prev. Qtr.Provision Secured]
,ISNULL(Y.ProvUnsecured,0)/@Cost	                                 AS [Prev. Qtr. Provision Unsecured]
,ISNULL(Y.NetNPA,0)/@Cost	                                         AS [Prev. Qtr. Net NPA]
----------------------------
 
,CASE WHEN Y1.AssetClassName='STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
      THEN ISNULL(B.NetBalance,0)
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'  
      THEN (CASE WHEN (ISNULL(B.NetBalance,0) - ISNULL(Y1.netBalance,0)) < 0 
                 THEN 0 
	             ELSE ABS(ISNULL(B.NetBalance,0) - ISNULL(Y1.netBalance,0)) 
	             END)   
      WHEN Y1.AccountEntityId IS NULL AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
	  THEN ISNULL(B.NetBalance,0)
	  ELSE 0 
	  END/@Cost                                           AS NPAIncrease

,CASE WHEN ISNULL(Y1.AssetClassName,'') <>'STANDARD' AND A2.AssetClassName ='STANDARD'   
      THEN ISNULL(Y1.netBalance,0)
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
	  THEN (CASE WHEN (ISNULL(Y1.netBalance,0)-ISNULL(B.NetBalance,0))< 0 
                 THEN 0 
	             ELSE (ISNULL(Y1.netBalance,0)-ISNULL(B.NetBalance,0))
	             END)   	  
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND B.AccountEntityId IS NULL 
	  THEN ISNULL(Y1.netBalance,0)
	  ELSE 0 
	  END/@Cost                                                  AS NPADecrease


,CASE WHEN Y1.AssetClassName='STANDARD' AND A2.AssetClassName ='STANDARD'   
      THEN (CASE WHEN (ISNULL(B.TotalProvision,0) - ISNULL(Y1.TotalProvision,0)) < 0 
                 THEN 0 
	             ELSE ABS(ISNULL(B.TotalProvision,0) - ISNULL(Y1.TotalProvision,0)) 
	             END)
	   WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND A2.AssetClassName ='STANDARD'   
	   THEN ISNULL(B.TotalProvision,0) 	              
	   WHEN Y1.AccountEntityId IS NULL AND A2.AssetClassName ='STANDARD'   
	   THEN ISNULL(B.TotalProvision,0)  
	   ELSE 0 
	   END/@Cost                                                   AS STD_ProvisionIncrease

,CASE WHEN Y1.AssetClassName='STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'   
      THEN ISNULL(B.TotalProvision,0)
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'   
	  THEN (CASE WHEN (ISNULL(B.TotalProvision,0) - ISNULL(Y1.TotalProvision,0)) < 0 
                 THEN 0 
	             ELSE ABS(ISNULL(B.TotalProvision,0) - ISNULL(Y1.TotalProvision,0)) 
	             END) 	              
	  WHEN Y1.AccountEntityId IS NULL AND ISNULL(A2.AssetClassName,'') <>'STANDARD'   
	  THEN ISNULL(B.TotalProvision,0)  
	  ELSE 0 
	  END/@Cost                                                   AS NPA_ProvisionIncrease


,CASE WHEN Y1.AssetClassName ='STANDARD'  AND A2.AssetClassName ='STANDARD'  
      THEN (CASE WHEN (ISNULL(Y1.TotalProvision,0)-ISNULL(B.TotalProvision,0))< 0 
                 THEN 0 
	             ELSE (ISNULL(Y1.TotalProvision,0)-ISNULL(B.TotalProvision,0)) 
	             END)  
	  WHEN Y1.AssetClassName ='STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'  
	  THEN ISNULL(Y1.TotalProvision,0)
	  ELSE 0 
	  END/@Cost                                                    AS STD_ProvisionDecrease

,CASE WHEN ISNULL(Y1.AssetClassName,'') <>'STANDARD'  AND ISNULL(A2.AssetClassName,'') <>'STANDARD'  
      THEN (CASE WHEN (ISNULL(Y1.TotalProvision,0)-ISNULL(B.TotalProvision,0))< 0 
                 THEN 0 
	             ELSE (ISNULL(Y1.TotalProvision,0)-ISNULL(B.TotalProvision,0))
	             END)  
	  WHEN ISNULL(Y1.AssetClassName,'') <>'STANDARD' AND A2.AssetClassName='STANDARD'  
	  THEN ISNULL(Y1.TotalProvision,0)
	  ELSE 0 
	  END/@Cost                                                    AS NPA_ProvisionDecrease


,CASE WHEN Y1.AssetClassName='STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
      THEN (ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0))
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'  
      THEN (CASE WHEN ((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y1.NetNPA,0)) < 0 
                 THEN 0 
	             ELSE ABS((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y1.NetNPA,0)) 
	             END)   
      WHEN Y1.AccountEntityId IS NULL AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
	  THEN (ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0))
	  ELSE 0 
	  END/@Cost                                           AS NetNPAIncrease

,CASE WHEN ISNULL(Y1.AssetClassName,'') <>'STANDARD' AND A2.AssetClassName ='STANDARD'   
      THEN ISNULL(Y1.NetNPA,0)
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND ISNULL(A2.AssetClassName,'') <>'STANDARD'
	  THEN (CASE WHEN (ISNULL(Y1.NetNPA,0)-(ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)))< 0 
                 THEN 0 
	             ELSE (ISNULL(Y1.NetNPA,0)-(ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)))
	             END)   
	  
	  WHEN ISNULL(Y1.AssetClassName,'')<>'STANDARD' AND B.AccountEntityId IS NULL 
	  THEN ISNULL(Y1.NetNPA,0)
	  ELSE 0 
	  END/@Cost                                          AS NetNPAnDecrease


FROM PRO.CUSTOMERCAL_hist A
INNER JOIN PRO.ACCOUNTCAL_hist B    ON A.CustomerEntityID=B.CustomerEntityID
                                       AND A.EffectiveFromTimeKey<=@TimeKey
									   AND A.EffectiveToTimeKey>=@TimeKey
                                       AND B.EffectiveFromTimeKey<=@TimeKey
									   AND B.EffectiveToTimeKey>=@TimeKey

INNER JOIN #DPD DPD                 ON DPD.CustomerAcID=B.CustomerAcID

LEFT JOIN DIMSOURCEDB src	        ON B.SourceAlt_Key =src.SourceAlt_Key
                                       AND src.EffectiveFromTimeKey<=@TimeKey
									   AND src.EffectiveToTimeKey>=@TimeKey
	

LEFT JOIN DIMPRODUCT PD          	ON  PD.PRODUCTALT_KEY=B.PRODUCTALT_KEY
                                        AND PD.EffectiveFromTimeKey<=@TimeKey
									    AND PD.EffectiveToTimeKey>=@TimeKey


LEFT JOIN DimAssetClass A2	        ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                       AND A2.EffectiveFromTimeKey<=@TimeKey
									   AND A2.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAcBuSegment S          ON B.ActSegmentCode=S.AcBuSegmentCode
                                       AND S.EffectiveFromTimeKey<=@TimeKey
									   AND S.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimBranch X               ON B.BranchCode = X.BranchCode
                                       AND X.EffectiveFromTimeKey<=@TimeKey
									   AND X.EffectiveToTimeKey>=@TimeKey

LEFT JOIN #PREV_QTR   Y        	  	ON B.AccountEntityId = Y.AccountEntityId

LEFT JOIN #PREV_DAY   Y1        	ON B.AccountEntityId = Y1.AccountEntityId



ORDER BY A.RefCustomerID  
OPTION(RECOMPILE)

DROP TABLE #DPD

GO
