SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-----------------Provision WorkSheet Report

create PROCEDURE [dbo].[Rpt-032_02-08-2022]
         @FromDate  VARCHAR(20)  
        ,@ToDate  VARCHAR(20) 
        ,@BranchCode AS VARCHAR(MAX)  
		,@CustomerID AS VARCHAR(100) 
		,@AccountID  AS VARCHAR(MAX)
		,@Cost AS FLOAT

AS

--DECLARE  @FromDate  VARCHAR(20) ='10/08/2021'  
--        ,@ToDate  VARCHAR(20) ='13/08/2021'   
--        ,@BranchCode AS VARCHAR(MAX)='<ALL>'   
--		,@CustomerID AS VARCHAR(100)='D2588312' 
--		,@AccountID  AS VARCHAR(MAX)='2224210080000005'
--		,@Cost AS FLOAT=1


-----------------------------------------------------------------------------------------------------
DECLARE	@FromDate1 DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @ToDate1 DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))

DECLARE @FromTimeKey  AS INT=(SELECT TimeKey FROM SysDayMatrix WHERE DATE=@FromDate1)
DECLARE @ToTimeKey   AS INT=(SELECT TimeKey FROM SysDayMatrix WHERE DATE=@ToDate1)

---------------------------------------------------------------------------------------------------------
DECLARE @ProcessDate DATE=(SELECT DATE From SysDayMatrix WHERE Timekey=@FromTimeKey)

DECLARE @ProcessDate1 DATE=(SELECT DATE From SysDayMatrix WHERE Timekey=@ToTimeKey)

-----------------================================================

IF(OBJECT_ID('TEMPDB..#DimAcBuSegment')IS NOT NULL)
   DROP TABLE #DimAcBuSegment

SELECT 
DENSE_RANK()OVER(PARTITION BY AcBuRevisedSegmentCode ORDER BY AcBuSegmentCode) RN,
AcBuSegmentCode,
AcBuRevisedSegmentCode,
AcBuSegmentDescription 
INTO #DimAcBuSegment
FROM DimAcBuSegment
WHERE EffectiveFromTimeKey<=@FromTimeKey AND EffectiveToTimeKey>=@FromTimeKey

OPTION(RECOMPILE)

---------------------==========================================

IF(OBJECT_ID('TEMPDB..#DimAcBuSegment1')IS NOT NULL)
   DROP TABLE #DimAcBuSegment1

SELECT 
DENSE_RANK()OVER(PARTITION BY AcBuRevisedSegmentCode ORDER BY AcBuSegmentCode) RN,
AcBuSegmentCode,
AcBuRevisedSegmentCode,
AcBuSegmentDescription 
INTO #DimAcBuSegment1
FROM DimAcBuSegment
WHERE EffectiveFromTimeKey<=@ToTimeKey AND EffectiveToTimeKey>=@ToTimeKey

OPTION(RECOMPILE)

---------------------------======================================From Date DPD CalCULATION  Start===========================================
IF OBJECT_ID('tempdb..#DPD') IS NOT NULL 
	DROP TABLE #DPD
   

SELECT * INTO #DPD 
FROM  PRO.AccountCal_Hist 
WHERE EffectiveFromTimeKey<=@FromTimeKey AND EffectiveToTimeKey>=@FromTimeKey
      AND RefCustomerID=@CustomerID

OPTION(RECOMPILE)

ALTER TABLE #DPD

ADD DPD_IntService INT,DPD_NoCredit INT,DPD_Overdrawn INT,DPD_Overdue INT,DPD_Renewal INT,DPD_StockStmt INT,DPD_MAX INT


/*---------- CALCULATED ALL DPD---------------------------------------------------------*/

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)  ELSE 0 END)			   
             ,A.DPD_NoCredit =  (CASE WHEN  A.LastCrDate IS NOT NULL      THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)       ELSE 0 END)
			 ,A.DPD_Overdrawn=  (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate)     ELSE 0 END)
			 ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)   ELSE 0 END) 
			 ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)      ELSE 0 END)
			 ,A.DPD_StockStmt=  (CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate)       ELSE 0 END)
FROM #DPD A 

OPTION(RECOMPILE)

/*--------------IF ANY DPD IS NEGATIVE THEN ZERO---------------------------------*/

 UPDATE #DPD SET DPD_IntService=0 WHERE ISNULL(DPD_IntService,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD SET DPD_NoCredit=0 WHERE ISNULL(DPD_NoCredit,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD SET DPD_Overdrawn=0 WHERE ISNULL(DPD_Overdrawn,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD SET DPD_Overdue=0 WHERE ISNULL(DPD_Overdue,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD SET DPD_Renewal=0 WHERE ISNULL(DPD_Renewal,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD SET DPD_StockStmt=0 WHERE ISNULL(DPD_StockStmt,0)<0

 OPTION(RECOMPILE)

/*------------DPD IS ZERO FOR ALL ACCOUNT DUE TO LASTCRDATE ------------------------------------*/

UPDATE A SET DPD_NoCredit=0 FROM #DPD A 

OPTION(RECOMPILE)

/* CALCULATE MAX DPD */

IF OBJECT_ID('TEMPDB..#TEMPTABLE') IS NOT NULL
   DROP TABLE #TEMPTABLE

	 SELECT A.CustomerAcID
			,CASE WHEN  ISNULL(A.DPD_IntService,0)>=ISNULL(A.RefPeriodIntService,0)		THEN A.DPD_IntService     ELSE 0   END DPD_IntService,  
			 CASE WHEN  ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.RefPeriodNoCredit,0)			THEN A.DPD_NoCredit       ELSE 0   END DPD_NoCredit,  
			 CASE WHEN  ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.RefPeriodOverDrawn	,0)	    THEN A.DPD_Overdrawn      ELSE 0   END DPD_Overdrawn,  
			 CASE WHEN  ISNULL(A.DPD_Overdue,0)>=ISNULL(A.RefPeriodOverdue	,0)		    THEN A.DPD_Overdue        ELSE 0   END DPD_Overdue , 
			 CASE WHEN  ISNULL(A.DPD_Renewal,0)>=ISNULL(A.RefPeriodReview	,0)			THEN A.DPD_Renewal        ELSE 0   END DPD_Renewal ,
			 CASE WHEN  ISNULL(A.DPD_StockStmt,0)>=ISNULL(A.RefPeriodStkStatement,0)    THEN A.DPD_StockStmt      ELSE 0   END DPD_StockStmt  
			 INTO #TEMPTABLE
			 FROM #DPD A 
			 INNER JOIN Pro.CustomerCal_hist B   ON A.RefCustomerID=B.RefCustomerID
			                                        AND B.EffectiveFromTimeKey<=@FromTimeKey AND B.EffectiveToTimeKey>=@FromTimeKey

			 WHERE ( ISNULL(DPD_IntService,0)>=ISNULL(RefPeriodIntService,0)
                   OR ISNULL(DPD_NoCredit,0)>=ISNULL(RefPeriodNoCredit,0)
				   OR ISNULL(DPD_Overdrawn,0)>=ISNULL(RefPeriodOverDrawn,0)
				   OR ISNULL(DPD_Overdue,0)>=ISNULL(RefPeriodOverdue,0)
				   OR ISNULL(DPD_Renewal,0)>=ISNULL(RefPeriodReview,0)
                   OR ISNULL(DPD_StockStmt,0)>=ISNULL(RefPeriodStkStatement,0)
			      ) AND (ISNULL(B.FlgProcessing,'N')='N' 
			      )
			    
	OPTION(RECOMPILE)

	/*--------------INTIAL MAX DPD 0 FOR RE PROCESSING DATA-------------------------*/

		UPDATE A SET A.DPD_Max=0
		 FROM #DPD A 
		
		OPTION(RECOMPILE) 


		/*----------------FIND MAX DPD---------------------------------------*/

		UPDATE   A SET A.DPD_Max= (CASE    WHEN (ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_NoCredit,0) AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdrawn,0) AND    ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdue,0) AND  ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_StockStmt,0)) THEN ISNULL(A.DPD_IntService,0)
										   WHEN (ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_IntService,0) AND ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Overdrawn,0) AND    ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_Overdue,0) AND    ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_StockStmt,0)) THEN   ISNULL(A.DPD_NoCredit ,0)
										   WHEN (ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_NoCredit,0)  AND ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_Overdue,0) AND   ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_StockStmt,0)) THEN  ISNULL(A.DPD_Overdrawn,0)
										   WHEN (ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_NoCredit,0)    AND ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_Overdrawn,0)  AND  ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_Overdue,0)  AND ISNULL(A.DPD_Renewal,0) >=ISNULL(A.DPD_StockStmt ,0)) THEN ISNULL(A.DPD_Renewal,0)
										   WHEN (ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_NoCredit,0)    AND ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_Overdrawn,0)  AND  ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_Renewal,0)  AND ISNULL(A.DPD_Overdue ,0)>=ISNULL(A.DPD_StockStmt ,0))  THEN   ISNULL(A.DPD_Overdue,0)
										   ELSE ISNULL(A.DPD_StockStmt,0) END) 
			 
		FROM  #DPD A 
		INNER JOIN PRO.CustomerCal_Hist C        ON C.RefCustomerID=A.RefCustomerID
		                                             AND C.EffectiveFromTimeKey<=@FromTimeKey AND C.EffectiveToTimeKey>=@FromTimeKey
		WHERE  (ISNULL(C.FlgProcessing,'N')='N') 
		        AND (ISNULL(A.DPD_IntService,0)>0   OR ISNULL(A.DPD_Overdrawn,0)>0   OR  ISNULL(A.DPD_Overdue,0)>0	 OR ISNULL(A.DPD_Renewal,0) >0 
				    OR ISNULL(A.DPD_StockStmt,0)>0 OR ISNULL(DPD_NoCredit,0)>0)

OPTION(RECOMPILE)
------------------------------------------------=========================END===========================
---------------------------======================================To Date DPD CalCULATION  Start===========================================

IF OBJECT_ID('tempdb..#DPD1') IS NOT NULL 
	DROP TABLE #DPD1
   

SELECT * INTO #DPD1 
FROM  PRO.AccountCal_Hist 
WHERE EffectiveFromTimeKey<=@ToTimeKey AND EffectiveToTimeKey>=@ToTimeKey
      AND RefCustomerID=@CustomerID

OPTION(RECOMPILE)

ALTER TABLE #DPD1

ADD DPD_IntService INT,DPD_NoCredit INT,DPD_Overdrawn INT,DPD_Overdue INT,DPD_Renewal INT,DPD_StockStmt INT,DPD_MAX INT


/*---------- CALCULATED ALL DPD---------------------------------------------------------*/

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate1)    ELSE 0 END)			   
             ,A.DPD_NoCredit =  (CASE WHEN  A.LastCrDate IS NOT NULL        THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate1)        ELSE 0 END)
			 ,A.DPD_Overdrawn=  (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate1)     ELSE 0 END)
			 ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL    THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate1)   ELSE 0 END) 
			 ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL       THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate1)        ELSE 0 END)
			 ,A.DPD_StockStmt=  (CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate1)         ELSE 0 END)
FROM #DPD1 A 																													  

OPTION(RECOMPILE)

/*--------------IF ANY DPD IS NEGATIVE THEN ZERO---------------------------------*/

 UPDATE #DPD SET DPD_IntService=0 WHERE ISNULL(DPD_IntService,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD1 SET DPD_NoCredit=0 WHERE ISNULL(DPD_NoCredit,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD1 SET DPD_Overdrawn=0 WHERE ISNULL(DPD_Overdrawn,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD1 SET DPD_Overdue=0 WHERE ISNULL(DPD_Overdue,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD1 SET DPD_Renewal=0 WHERE ISNULL(DPD_Renewal,0)<0

 OPTION(RECOMPILE)

 UPDATE #DPD1 SET DPD_StockStmt=0 WHERE ISNULL(DPD_StockStmt,0)<0

 OPTION(RECOMPILE)

/*------------DPD IS ZERO FOR ALL ACCOUNT DUE TO LASTCRDATE ------------------------------------*/

UPDATE A SET DPD_NoCredit=0 FROM #DPD1 A 

OPTION(RECOMPILE)

/* CALCULATE MAX DPD */

IF OBJECT_ID('TEMPDB..#TEMPTABLE1') IS NOT NULL
   DROP TABLE #TEMPTABLE1

	 SELECT A.CustomerAcID
			,CASE WHEN  ISNULL(A.DPD_IntService,0)>=ISNULL(A.RefPeriodIntService,0)		THEN A.DPD_IntService     ELSE 0   END DPD_IntService,  
			 CASE WHEN  ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.RefPeriodNoCredit,0)			THEN A.DPD_NoCredit       ELSE 0   END DPD_NoCredit,  
			 CASE WHEN  ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.RefPeriodOverDrawn	,0)	    THEN A.DPD_Overdrawn      ELSE 0   END DPD_Overdrawn,  
			 CASE WHEN  ISNULL(A.DPD_Overdue,0)>=ISNULL(A.RefPeriodOverdue	,0)		    THEN A.DPD_Overdue        ELSE 0   END DPD_Overdue , 
			 CASE WHEN  ISNULL(A.DPD_Renewal,0)>=ISNULL(A.RefPeriodReview	,0)			THEN A.DPD_Renewal        ELSE 0   END DPD_Renewal ,
			 CASE WHEN  ISNULL(A.DPD_StockStmt,0)>=ISNULL(A.RefPeriodStkStatement,0)    THEN A.DPD_StockStmt      ELSE 0   END DPD_StockStmt  
			 INTO #TEMPTABLE1
			 FROM #DPD1 A 
			 INNER JOIN Pro.CustomerCal_hist B   ON A.RefCustomerID=B.RefCustomerID
			                                        AND B.EffectiveFromTimeKey<=@ToTimeKey AND B.EffectiveToTimeKey>=@ToTimeKey

			 WHERE ( ISNULL(DPD_IntService,0)>=ISNULL(RefPeriodIntService,0)
                   OR ISNULL(DPD_NoCredit,0)>=ISNULL(RefPeriodNoCredit,0)
				   OR ISNULL(DPD_Overdrawn,0)>=ISNULL(RefPeriodOverDrawn,0)
				   OR ISNULL(DPD_Overdue,0)>=ISNULL(RefPeriodOverdue,0)
				   OR ISNULL(DPD_Renewal,0)>=ISNULL(RefPeriodReview,0)
                   OR ISNULL(DPD_StockStmt,0)>=ISNULL(RefPeriodStkStatement,0)
			      ) AND (ISNULL(B.FlgProcessing,'N')='N' 
			      )
			    
	OPTION(RECOMPILE)

	/*--------------INTIAL MAX DPD 0 FOR RE PROCESSING DATA-------------------------*/

		UPDATE A SET A.DPD_Max=0
		 FROM #DPD1 A 
		
		OPTION(RECOMPILE) 


		/*----------------FIND MAX DPD---------------------------------------*/

		UPDATE   A SET A.DPD_Max= (CASE    WHEN (ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_NoCredit,0) AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdrawn,0) AND    ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Overdue,0) AND  ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_IntService,0)>=ISNULL(A.DPD_StockStmt,0)) THEN ISNULL(A.DPD_IntService,0)
										   WHEN (ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_IntService,0) AND ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Overdrawn,0) AND    ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_Overdue,0) AND    ISNULL(A.DPD_NoCredit,0)>=  ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_NoCredit,0)>=ISNULL(A.DPD_StockStmt,0)) THEN   ISNULL(A.DPD_NoCredit ,0)
										   WHEN (ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_NoCredit,0)  AND ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_Overdue,0) AND   ISNULL(A.DPD_Overdrawn,0)>= ISNULL(A.DPD_Renewal,0) AND ISNULL(A.DPD_Overdrawn,0)>=ISNULL(A.DPD_StockStmt,0)) THEN  ISNULL(A.DPD_Overdrawn,0)
										   WHEN (ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_NoCredit,0)    AND ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Renewal,0)>=ISNULL(A.DPD_Overdrawn,0)  AND  ISNULL(A.DPD_Renewal,0)>=   ISNULL(A.DPD_Overdue,0)  AND ISNULL(A.DPD_Renewal,0) >=ISNULL(A.DPD_StockStmt ,0)) THEN ISNULL(A.DPD_Renewal,0)
										   WHEN (ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_NoCredit,0)    AND ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_IntService,0)  AND  ISNULL(A.DPD_Overdue,0)>=ISNULL(A.DPD_Overdrawn,0)  AND  ISNULL(A.DPD_Overdue,0)>=   ISNULL(A.DPD_Renewal,0)  AND ISNULL(A.DPD_Overdue ,0)>=ISNULL(A.DPD_StockStmt ,0))  THEN   ISNULL(A.DPD_Overdue,0)
										   ELSE ISNULL(A.DPD_StockStmt,0) END) 
			 
		FROM  #DPD1 A 
		INNER JOIN PRO.CustomerCal_Hist C        ON C.RefCustomerID=A.RefCustomerID
		                                            AND C.EffectiveFromTimeKey<=@ToTimeKey AND C.EffectiveToTimeKey>=@ToTimeKey

		WHERE  (ISNULL(C.FlgProcessing,'N')='N') 
		        AND (ISNULL(A.DPD_IntService,0)>0   OR ISNULL(A.DPD_Overdrawn,0)>0   OR  ISNULL(A.DPD_Overdue,0)>0	 OR ISNULL(A.DPD_Renewal,0) >0 
				    OR ISNULL(A.DPD_StockStmt,0)>0 OR ISNULL(DPD_NoCredit,0)>0)

OPTION(RECOMPILE)


---------------------------------------------------------------END----------------------------------

---------------------------------------------------------------------------------
IF OBJECT_ID('TEMPDB..#DATA') IS NOT NULL
   DROP TABLE #DATA


SELECT 
UCIF_ID,
RefCustomerID,
CustomerAcId,
CustomerName,
ISNULL(AcBuSegmentDescription,'NA')                   AS Segment,
ISNULL(GLCode,'NA')                                   AS GLCode,
ISNULL(ProductCode,'NA')                              AS ProductCode,
ISNULL(ProductName,'NA')                              AS ProductName,
NPADate,
ISNULL(Restructure,'NA')                              AS Restructure,
ISNULL(PUI,'NA')                                      AS PUI,
ISNULL(FacilityType,'NA')                             AS FacilityType,
SUM(ISNULL(DFVAmt,0))                                 AS DFVAmt,
AssetClass,                                         
'NA'                                                  AS Asset_Sub_Class,
DPD_Max,
SUM(ISNULL(Balance,0))                                AS Balance,
SUM(ISNULL(Unserviedint,0))                           AS Unserviedint,
SUM(ISNULL(CashMarginHeldwithBank,0))                 AS CashMarginHeldwithBank,
SUM(ISNULL(RealisableValueofSecurity,0))              AS RealisableValueofSecurity,
SUM(ISNULL(RetainbaleportionofECGC_CGTMSE,0))         AS RetainbaleportionofECGC_CGTMSE,
SUM(ISNULL(WriteOffAmount,0))                         AS WriteOffAmount,
SUM(ISNULL(Provsecured,0))                            AS Provsecured,
SUM(ISNULL(ProvUnsecured,0))                          AS ProvUnsecured,
SUM(ISNULL(TotalProvision,0))                         AS TotalProvision,
SUM(ISNULL(PropertionateValueOfSec,0))                AS PropertionateValueOfSec,
SUM(ISNULL(UsedValueOfSec,0))                         AS UsedValueOfSec,
SUM(ISNULL(AddlProvision,0))                          AS AddlProvision,
SUM(ISNULL(ProvDFV,0))                                AS ProvDFV,
SUM(ISNULL(RestructureProvision,0))                   AS RestructureProvision,
Flag,
SUM(ISNULL(SecuredAmt,0))                 As SecuredAmt,
SUM(ISNULL(UnSecuredAmt,0))                 As UnSecuredAmt
,sum(isnull(PrincOutStd,0))     AS PrincOutStd
,sum(isnull(NetBalance,0))     AS NetBalance

INTO #DATA
FROM(
SELECT    

          CUST.UCIF_ID 
		  ,CUST.RefCustomerID
          ,ACCOUNT.CustomerAcId
          ,CUST.CustomerName
		  ,DS.AcBuSegmentDescription
		  ,DGL.GLCode
		  ,DP.ProductCode
          ,DP.ProductName
		  ,CONVERT(VARCHAR(20),ACCOUNT.FinalNpaDt,103)                AS  NPADate
		  ,CASE WHEN ISNULL(ACCOUNT.FlgRestructure,'')='Y'
		        THEN 'Yes'
				WHEN ISNULL(ACCOUNT.FlgRestructure,'N')='N'
				THEN 'No'
				END                                                   AS Restructure
          ,CASE WHEN ISNULL(ACCOUNT.PUI,'')='Y'
		        THEN 'Yes'
				WHEN ISNULL(ACCOUNT.PUI,'N')='N'
				THEN 'No'
				END                                                   AS PUI
          ,ACCOUNT.FacilityType
		  ,CAST(ISNULL(ACCOUNT.DFVAmt,0)/@Cost  AS DECIMAL(30,2))                           AS  DFVAmt 

		  ,DA.AssetClassShortName                                     AS  AssetClass
          ,DPD_Max
		  ,CAST(ISNULL(ACCOUNT.Balance,0)/@cost   AS DECIMAL(30,2))                         AS  Balance
          ,CAST(ISNULL(ACCOUNT.unserviedint,0)/@cost   AS DECIMAL(30,2))                    AS  Unserviedint
		  ,CAST(0  AS DECIMAL(30,2))                                                        AS  CashMarginHeldwithBank
          ,CAST(0  AS DECIMAL(30,2))                                                        AS  RealisableValueofSecurity
          ,CAST(0  AS DECIMAL(30,2))                                                        AS  RetainbaleportionofECGC_CGTMSE
          ,CAST(ISNULL(ACCOUNT.WriteOffAmount,0)/@cost   AS DECIMAL(30,2))                  AS  WriteOffAmount
          ,CAST(ISNULL(ACCOUNT.Provsecured,0)/@cost     AS DECIMAL(30,2))                   AS  Provsecured
          ,CAST(ISNULL(ACCOUNT.ProvUnsecured,0)/@cost   AS DECIMAL(30,2))                   AS  ProvUnsecured
          ,CAST(ISNULL(ACCOUNT.TotalProvision,0)/@cost  AS DECIMAL(30,2))                   AS  TotalProvision
		  ,CAST(ISNULL(ACCOUNT.apprRV,0)/@cost  AS DECIMAL(30,2))                           AS  PropertionateValueOfSec
		  ,CAST(ISNULL(ACCOUNT.UsedRV,0)/@cost  AS DECIMAL(30,2))                           AS  UsedValueOfSec
		  ,CAST(ISNULL(ACCOUNT.AddlProvision,0)/@cost  AS DECIMAL(30,2))                    AS  AddlProvision
		  ,CAST(ISNULL(ACCOUNT.ProvDFV,0)/@cost  AS DECIMAL(30,2))                          AS  ProvDFV
		  ,CAST(ISNULL(ACRCH.RestructureProvision,0)/@Cost AS DECIMAL(30,2))                AS  RestructureProvision
		  ,'FD'                                                       AS  Flag
		  ,cast(Isnull(Account.SecuredAmt,0)/@cost as decimal(30,2)) as SecuredAmt
		  ,cast(Isnull(Account.UnSecuredAmt,0)/@cost as decimal(30,2)) as UnSecuredAmt
		  ,cast(Isnull(Account.PrincOutStd,0)/@cost as decimal(30,2)) as PrincOutStd
		  ,cast(Isnull(Account.NetBalance,0)/@cost as decimal(30,2)) as NetBalance
		  
FROM  Pro.CustomerCal_Hist  CUST       
												 

     
INNER JOIN Pro.AccountCal_Hist   ACCOUNT        ON ACCOUNT.RefCustomerID=CUST.RefCustomerID
                                                   AND ACCOUNT.EffectiveFromTimeKey<=@FromTimeKey
												   AND ACCOUNT.EffectiveToTimeKey>=@FromTimeKey
												   AND CUST.EffectiveFromTimeKey<=@FromTimeKey
												   AND CUST.EffectiveToTimeKey>=@FromTimeKey


INNER JOIN #DPD      DPD                        ON ACCOUNT.CustomerAcID=DPD.CustomerAcID
                                                   AND ACCOUNT.RefCustomerID=DPD.RefCustomerID
												   AND ACCOUNT.BranchCode=DPD.BranchCode
       
LEFT JOIN AdvAcBasicDetail  ACBD                ON ACCOUNT.CustomerAcID=ACBD.CustomerAcID
                                                   AND ACBD.EffectiveFromTimeKey<=@FromTimeKey
												   AND ACBD.EffectiveToTimeKey>=@FromTimeKey
												    
INNER JOIN DimBranch   DB                       ON ACCOUNT.BranchCode=DB.BranchCode
                                                   AND DB.EffectiveFromTimeKey<=@FromTimeKey
												   AND DB.EffectiveToTimeKey>=@FromTimeKey												   
												             

INNER JOIN DimProduct   DP                      ON ACCOUNT.ProductAlt_Key=DP.ProductAlt_Key
                                                   AND DP.EffectiveFromTimeKey<=@FromTimeKey
												   AND DP.EffectiveToTimeKey>=@FromTimeKey


LEFT JOIN Pro.AdvAcRestructureCal_Hist ACRCH    ON ACCOUNT.AccountEntityId=ACRCH.AccountEntityId
                                                   AND ACRCH.EffectiveFromTimeKey<=@FromTimeKey
												   AND ACRCH.EffectiveToTimeKey>=@FromTimeKey

INNER JOIN DimAssetClass   DA                   ON  ACCOUNT.FinalAssetClassAlt_Key=DA.AssetClassAlt_Key
                                                    AND DA.EffectiveFromTimeKey<=@FromTimeKey
												    AND DA.EffectiveToTimeKey>=@FromTimeKey


LEFT JOIN DimGL   DGL                           ON  ACBD.GLAlt_Key=DGL.GLAlt_Key
                                                    AND DGL.EffectiveFromTimeKey<=@FromTimeKey
												    AND DGL.EffectiveToTimeKey>=@FromTimeKey   

LEFT JOIN #DimAcBuSegment  DS                   ON  ACCOUNT.ActSegmentCode=DS.AcBuRevisedSegmentCode
                                                    AND DS.RN=1

WHERE  DB.BranchCode IN (SELECT * FROM Dbo.Split(@BranchCode,',' ))  
       AND CUST.RefCustomerID=@CustomerID
	   AND ACCOUNT.CustomerACID IN (SELECT * FROM Dbo.Split(@AccountID,',' )) 

UNION ALL

SELECT   

           CUST.UCIF_ID 
		  ,CUST.RefCustomerID
          ,ACCOUNT.CustomerAcId
          ,CUST.CustomerName
		  ,DS.AcBuSegmentDescription
		  ,DGL.GLCode
		  ,DP.ProductCode
          ,DP.ProductName
		  ,CONVERT(VARCHAR(20),ACCOUNT.FinalNpaDt,103)                AS  NPADate
		  ,CASE WHEN ISNULL(ACCOUNT.FlgRestructure,'')='Y'
		        THEN 'Yes'
				WHEN ISNULL(ACCOUNT.FlgRestructure,'N')='N'
				THEN 'No'
				END                                                   AS Restructure
          ,CASE WHEN ISNULL(ACCOUNT.PUI,'')='Y'
		        THEN 'Yes'
				WHEN ISNULL(ACCOUNT.PUI,'N')='N'
				THEN 'No'
				END                                                   AS PUI
          ,ACCOUNT.FacilityType
		  ,CAST(ISNULL(ACCOUNT.DFVAmt,0)/@Cost   AS DECIMAL(30,2))    AS  DFVAmt 

		  ,DA.AssetClassShortName                                     AS  AssetClass


          ,DPD_Max
		  ,CAST(ISNULL(ACCOUNT.Balance,0)/@cost   AS DECIMAL(30,2))                         AS  Balance
          ,CAST(ISNULL(ACCOUNT.unserviedint,0)/@cost   AS DECIMAL(30,2))                    AS  Unserviedint
		  ,CAST(0   AS DECIMAL(30,2))                                                        AS  CashMarginHeldwithBank
          ,CAST(0   AS DECIMAL(30,2))                                                       AS  RealisableValueofSecurity
          ,CAST(0   AS DECIMAL(30,2))                                                       AS  RetainbaleportionofECGC_CGTMSE
          ,CAST(ISNULL(ACCOUNT.WriteOffAmount,0)/@cost  AS DECIMAL(30,2))                   AS  WriteOffAmount
          ,CAST(ISNULL(ACCOUNT.Provsecured,0)/@cost    AS DECIMAL(30,2))                    AS  Provsecured
          ,CAST(ISNULL(ACCOUNT.ProvUnsecured,0)/@cost   AS DECIMAL(30,2))                   AS  ProvUnsecured
          ,CAST(ISNULL(ACCOUNT.TotalProvision,0)/@cost   AS DECIMAL(30,2))                  AS  TotalProvision
		  ,CAST(ISNULL(ACCOUNT.apprRV,0)/@cost  AS DECIMAL(30,2))                           AS  PropertionateValueOfSec
		  ,CAST(ISNULL(ACCOUNT.UsedRV,0)/@cost  AS DECIMAL(30,2))                           AS  UsedValueOfSec
		  ,CAST(ISNULL(ACCOUNT.AddlProvision,0)/@cost  AS DECIMAL(30,2))                    AS  AddlProvision
		  ,CAST(ISNULL(ACCOUNT.ProvDFV,0)/@cost  AS DECIMAL(30,2))                          AS  ProvDFV
		  ,CAST(ISNULL(ACRCH.RestructureProvision,0)/@Cost AS DECIMAL(30,2))                AS  RestructureProvision
		  ,'TD'                                                       AS  Flag
		  ,cast(Isnull(Account.SecuredAmt,0)/@cost as decimal(30,2)) as SecuredAmt
		  ,cast(Isnull(Account.UnSecuredAmt,0)/@cost as decimal(30,2)) as UnSecuredAmt
		  ,cast(Isnull(Account.PrincOutStd,0)/@cost as decimal(30,2)) as PrincOutStd
		  ,cast(Isnull(Account.NetBalance,0)/@cost as decimal(30,2)) as NetBalance

FROM  Pro.CustomerCal_Hist  CUST        
												 

     
INNER JOIN Pro.AccountCal_Hist   ACCOUNT        ON ACCOUNT.RefCustomerID=CUST.RefCustomerID
                                                   AND ACCOUNT.EffectiveFromTimeKey<=@ToTimeKey
												   AND ACCOUNT.EffectiveToTimeKey>=@ToTimeKey
												   AND CUST.EffectiveFromTimeKey<=@ToTimeKey
												   AND CUST.EffectiveToTimeKey>=@ToTimeKey

INNER JOIN #DPD1      DPD                       ON ACCOUNT.CustomerAcID=DPD.CustomerAcID
                                                   AND ACCOUNT.RefCustomerID=DPD.RefCustomerID
												   AND ACCOUNT.BranchCode=DPD.BranchCode

LEFT JOIN AdvAcBasicDetail  ACBD                ON ACCOUNT.CustomerAcID=ACBD.CustomerAcID
                                                   AND ACBD.EffectiveFromTimeKey<=@ToTimeKey
												   AND ACBD.EffectiveToTimeKey>=@ToTimeKey  
												   
INNER JOIN DimBranch   DB                       ON ACCOUNT.BranchCode=DB.BranchCode
                                                   AND DB.EffectiveFromTimeKey<=@ToTimeKey
												   AND DB.EffectiveToTimeKey>=@ToTimeKey												            

INNER JOIN DimProduct   DP                      ON ACCOUNT.ProductAlt_Key=DP.ProductAlt_Key
                                                   AND DP.EffectiveFromTimeKey<=@ToTimeKey
												   AND DP.EffectiveToTimeKey>=@ToTimeKey


LEFT JOIN Pro.AdvAcRestructureCal_Hist ACRCH    ON ACCOUNT.AccountEntityId=ACRCH.AccountEntityId
                                                   AND ACRCH.EffectiveFromTimeKey<=@ToTimeKey
												   AND ACRCH.EffectiveToTimeKey>=@ToTimeKey

INNER JOIN DimAssetClass   DA                   ON  ACCOUNT.FinalAssetClassAlt_Key=DA.AssetClassAlt_Key
                                                    AND DA.EffectiveFromTimeKey<=@ToTimeKey
												    AND DA.EffectiveToTimeKey>=@ToTimeKey


LEFT JOIN DimGL   DGL                           ON  ACBD.GLAlt_Key=DGL.GLAlt_Key
                                                    AND DGL.EffectiveFromTimeKey<=@ToTimeKey
												    AND DGL.EffectiveToTimeKey>=@ToTimeKey

LEFT JOIN #DimAcBuSegment1  DS                  ON  ACCOUNT.ActSegmentCode=DS.AcBuRevisedSegmentCode
                                                    AND DS.RN=1 


WHERE  DB.BranchCode IN (SELECT * FROM Dbo.Split(@BranchCode,',' )) 
       AND CUST.RefCustomerID=@CustomerID
	   AND ACCOUNT.CustomerACID IN (SELECT * FROM Dbo.Split(@AccountID,',' )) 


)DATA


GROUP BY
UCIF_ID,
RefCustomerID,
CustomerAcId,
CustomerName,
GLCode,
ProductCode,
ProductName,
NPADate,
Restructure,
PUI,
FacilityType,
AssetClass,
DPD_Max,
Flag,
AcBuSegmentDescription

OPTION(RECOMPILE)

																								
------------------------------------------------------------------------
SELECT 
DISTINCT

D.UCIF_ID,
D.RefCustomerID ,
D.CustomerAcId,
D.CustomerName,
D.Segment,
D.GLCode,
D.ProductCode,
D.ProductName,
NPADate_FD,
NPADate_TD,
D.Restructure,
D.PUI,
D.FacilityType,
D.DFVAmt,
AssetClass_FD,
AssetClass_TD,
Asset_Sub_Class_FD,
Asset_Sub_Class_TD,
ISNULL(DPD_Max_FD,0)+1          AS DPD_Max_FD,
ISNULL(DPD_Max_TD,0)+1          AS DPD_Max_TD,
Balance_FD,
Balance_TD,
Unserviedint_FD,
Unserviedint_TD,
CashMarginHeldwithBank_FD,
CashMarginHeldwithBank_TD,
RealisableValueofSecurity_FD,
RealisableValueofSecurity_TD,
RetainbaleportionofECGC_CGTMSE_FD,
RetainbaleportionofECGC_CGTMSE_TD,
WriteOffAmount_FD,
WriteOffAmount_TD,
Provsecured_FD,
Provsecured_TD,
ProvUnsecured_FD,
ProvUnsecured_TD,
TotalProvision_FD,
TotalProvision_TD,
PropertionateValueOfSec_FD,
PropertionateValueOfSec_TD,
UsedValueOfSec_FD,
UsedValueOfSec_TD,
AddlProvision_FD,
AddlProvision_TD,
ProvDFV_FD,
ProvDFV_TD,
RestructureProvision_FD,
RestructureProvision_TD,
SecuredAmt_FD,
SecuredAmt_TD,
UnSecuredAmt_FD,
UnSecuredAmt_TD
,PrincOutStd_FD
,PrincOutStd_TD
,NetBalance_FD,NetBalance_TD
, (case when AssetClass_FD='STD' THEN (Provsecured_FD*100)/case when Balance_FD     =0 then 1 else Balance_FD     end 
       when AssetClass_FD='SUB' THEN (Provsecured_FD*100)/case when NetBalance_FD	=0 then 1 else NetBalance_FD end
	   when AssetClass_FD='DB1' THEN (Provsecured_FD*100)/case when SecuredAmt_FD	=0 then 1 else SecuredAmt_FD end
	   when AssetClass_FD='DB2' THEN (Provsecured_FD*100)/case when SecuredAmt_FD	=0 then 1 else SecuredAmt_FD end	 
	   when AssetClass_FD='DB3' THEN (Provsecured_FD*100)/case when NetBalance_FD	=0 then 1 else NetBalance_FD end	 
	   when AssetClass_FD='LOS' THEN (Provsecured_FD*100)/case when NetBalance_FD	=0 then 1 else NetBalance_FD end														   
	   end) as Provision_Per_secured_FD
, isnull((case when AssetClass_TD='STD' 
THEN (Provsecured_TD*100)/case when Balance_TD     =0 then 1 else Balance_TD    end
       when AssetClass_TD='SUB' THEN (Provsecured_TD*100)/case when NetBalance_TD	=0 then 1 else  NetBalance_TD end
	   when AssetClass_TD='DB1' THEN (Provsecured_TD*100)/case when SecuredAmt_TD	=0 then 1 else  SecuredAmt_TD  end
	   when AssetClass_TD='DB2' THEN (Provsecured_TD*100)/case when SecuredAmt_TD	=0 then 1 else  SecuredAmt_TD  end
	   when AssetClass_TD='DB3' THEN (Provsecured_TD*100)/case when NetBalance_TD	=0 then 1 else  NetBalance_TD  end
	   when AssetClass_TD='LOS' THEN  (Provsecured_TD*100)/case when NetBalance_TD	=0 then 1 else  NetBalance_TD  end
	   end),0) as Provision_Per_secured_TD

, (case when AssetClass_FD='STD' THEN (Provunsecured_FD*100)/case when Balance_FD      =0 then 1 else Balance_FD      end
       when AssetClass_FD='SUB' THEN (Provunsecured_FD*100)/case when NetBalance_FD  =0 then 1 else NetBalance_FD  end
	   when AssetClass_FD='DB1' THEN (Provunsecured_FD*100)/case when UnSecuredAmt_FD =0 then 1 else UnSecuredAmt_FD end
	   when AssetClass_FD='DB2' THEN (Provunsecured_FD*100)/case when UnSecuredAmt_FD =0 then 1 else UnSecuredAmt_FD end
	   when AssetClass_FD='DB3' THEN (Provunsecured_FD*100)/case when NetBalance_FD =0 then 1 else NetBalance_FD end
	   when AssetClass_FD='LOS' THEN (Provunsecured_FD*100)/case when NetBalance_FD  =0 then 1 else NetBalance_FD  end
	   end) as Provision_Per_Unsecured_FD				 						   				  
, (case when AssetClass_TD='STD' THEN (Provunsecured_TD*100)/case when Balance_TD	   =0 then 1 else Balance_TD	  end
       when AssetClass_TD='SUB' THEN (Provunsecured_TD*100)/case when NetBalance_TD  =0 then 1 else NetBalance_TD  end
	   when AssetClass_TD='DB1' THEN (Provunsecured_TD*100)/case when UnSecuredAmt_TD =0 then 1 else UnSecuredAmt_TD end
	   when AssetClass_TD='DB2' THEN (Provunsecured_TD*100)/case when UnSecuredAmt_TD =0 then 1 else UnSecuredAmt_TD end
	   when AssetClass_TD='DB3' THEN (Provunsecured_TD*100)/case when NetBalance_TD =0 then 1 else NetBalance_TD end
	   when AssetClass_TD='LOS' THEN (Provunsecured_TD*100)/case when NetBalance_TD  =0 then 1 else NetBalance_TD  end
	   end) as Provision_Per_Unsecured_TD

FROM #DATA D

INNER JOIN(
SELECT  CustomerACID,[FD] NPADate_FD,[TD] NPADate_TD
				FROM 
				(		SELECT CustomerACID ,NPADate ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(NPADate) FOR FLAG IN ([FD],[TD])
				) P
	   ) NPA ON NPA.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] AssetClass_FD,[TD] AssetClass_TD
				FROM 
				(		SELECT CustomerACID ,AssetClass ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(AssetClass) FOR FLAG IN ([FD],[TD])
				) P
	   ) ASSET ON ASSET.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] Asset_Sub_Class_FD,[TD] Asset_Sub_Class_TD
				FROM 
				(		SELECT CustomerACID ,Asset_Sub_Class ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(Asset_Sub_Class) FOR FLAG IN ([FD],[TD])
				) P
	   ) ASSET_Sub ON ASSET_Sub.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] DPD_Max_FD,[TD] DPD_Max_TD
				FROM 
				(		SELECT CustomerACID ,DPD_Max ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(DPD_Max) FOR FLAG IN ([FD],[TD])
				) P
	   ) DPD ON DPD.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] Balance_FD,[TD] Balance_TD
				FROM 
				(		SELECT CustomerACID ,Balance ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(Balance) FOR FLAG IN ([FD],[TD])
				) P
	   ) OS ON OS.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] Unserviedint_FD,[TD] Unserviedint_TD
				FROM 
				(		SELECT CustomerACID ,Unserviedint ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(Unserviedint) FOR FLAG IN ([FD],[TD])
				) P
	   ) UNSI ON UNSI.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] CashMarginHeldwithBank_FD,[TD] CashMarginHeldwithBank_TD
				FROM 
				(		SELECT CustomerACID ,CashMarginHeldwithBank ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(CashMarginHeldwithBank) FOR FLAG IN ([FD],[TD])
				) P
	   ) CMHWB ON CMHWB.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] RealisableValueofSecurity_FD,[TD] RealisableValueofSecurity_TD
				FROM 
				(		SELECT CustomerACID ,RealisableValueofSecurity ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(RealisableValueofSecurity) FOR FLAG IN ([FD],[TD])
				) P
	   ) RVS ON RVS.CustomerACID=D.CustomerACID 

INNER JOIN(
SELECT  CustomerACID,[FD] RetainbaleportionofECGC_CGTMSE_FD,[TD] RetainbaleportionofECGC_CGTMSE_TD
				FROM 
				(		SELECT CustomerACID ,RetainbaleportionofECGC_CGTMSE ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(RetainbaleportionofECGC_CGTMSE) FOR FLAG IN ([FD],[TD])
				) P
	   ) ECGC_CGTMSE ON ECGC_CGTMSE.CustomerACID=D.CustomerACID


INNER JOIN(
SELECT  CustomerACID,[FD] WriteOffAmount_FD,[TD] WriteOffAmount_TD
				FROM 
				(		SELECT CustomerACID ,WriteOffAmount ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(WriteOffAmount) FOR FLAG IN ([FD],[TD])
				) P
	   ) WOA ON WOA.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] Provsecured_FD,[TD] Provsecured_TD
				FROM 
				(		SELECT CustomerACID ,Provsecured ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(Provsecured) FOR FLAG IN ([FD],[TD])
				) P
	   ) PS ON PS.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] ProvUnsecured_FD,[TD] ProvUnsecured_TD
				FROM 
				(		SELECT CustomerACID ,ProvUnsecured ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(ProvUnsecured) FOR FLAG IN ([FD],[TD])
				) P
	   ) PNS ON PNS.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] TotalProvision_FD,[TD] TotalProvision_TD
				FROM 
				(		SELECT CustomerACID ,TotalProvision ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(TotalProvision) FOR FLAG IN ([FD],[TD])
				) P
	   ) TP ON TP.CustomerACID=D.CustomerACID


INNER JOIN(
SELECT  CustomerACID,[FD] PropertionateValueOfSec_FD,[TD] PropertionateValueOfSec_TD
				FROM 
				(		SELECT CustomerACID ,PropertionateValueOfSec,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(PropertionateValueOfSec) FOR FLAG IN ([FD],[TD])
				) P
	   ) ARV ON ARV.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] UsedValueOfSec_FD,[TD] UsedValueOfSec_TD
				FROM 
				(		SELECT CustomerACID ,UsedValueOfSec ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(UsedValueOfSec) FOR FLAG IN ([FD],[TD])
				) P
	   ) URV ON URV.CustomerACID=D.CustomerACID


INNER JOIN(
SELECT  CustomerACID,[FD] AddlProvision_FD,[TD] AddlProvision_TD
				FROM 
				(		SELECT CustomerACID ,AddlProvision ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(AddlProvision) FOR FLAG IN ([FD],[TD])
				) P
	   ) ADP ON ADP.CustomerACID=D.CustomerACID


INNER JOIN(
SELECT  CustomerACID,[FD] ProvDFV_FD,[TD] ProvDFV_TD
				FROM 
				(		SELECT CustomerACID ,ProvDFV ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(ProvDFV) FOR FLAG IN ([FD],[TD])
				) P
	   ) DFP ON DFP.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] RestructureProvision_FD,[TD] RestructureProvision_TD
				FROM 
				(		SELECT CustomerACID ,RestructureProvision ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(RestructureProvision) FOR FLAG IN ([FD],[TD])
				) P
	   ) RestructureP ON RestructureP.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] SecuredAmt_FD,[TD] SecuredAmt_TD
				FROM 
				(		SELECT CustomerACID ,SecuredAmt ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(SecuredAmt) FOR FLAG IN ([FD],[TD])
				) P
	   ) SecuredAmt ON SecuredAmt.CustomerACID=D.CustomerACID
INNER JOIN(
SELECT  CustomerACID,[FD] UnSecuredAmt_FD,[TD] UnSecuredAmt_TD
				FROM 
				(		SELECT CustomerACID ,UnSecuredAmt ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(UnSecuredAmt) FOR FLAG IN ([FD],[TD])
				) P
	   ) UnSecuredAmt ON UnSecuredAmt.CustomerACID=D.CustomerACID
INNER JOIN(
SELECT  CustomerACID,[FD] PrincOutStd_FD,[TD] PrincOutStd_TD
				FROM 
				(		SELECT CustomerACID ,PrincOutStd ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(PrincOutStd) FOR FLAG IN ([FD],[TD])
				) P
	   ) PrincOutStd ON PrincOutStd.CustomerACID=D.CustomerACID

INNER JOIN(
SELECT  CustomerACID,[FD] NetBalance_FD,[TD] NetBalance_TD
				FROM 
				(		SELECT CustomerACID ,NetBalance ,Flag 
						FROM #DATA
				) Pvt
				PIVOT       
				(
				MAX(NetBalance) FOR FLAG IN ([FD],[TD])
				) P
	   ) NetBalance ON NetBalance.CustomerACID=D.CustomerACID
OPTION(RECOMPILE)

DROP TABLE #DPD,#DPD1,#TEMPTABLE,#TEMPTABLE1,#DATA,#DimAcBuSegment,#DimAcBuSegment1
GO
