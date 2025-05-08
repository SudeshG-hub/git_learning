SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----------------------AssetClassification  ALL NPA  Report----------------------

CREATE PROC [dbo].[Rpt-039_02-08-2022]
	@TimeKey  INT
	AS 


--DECLARE  @TimeKey AS INT=26372

declare @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)


---------------------------======================================DPD CalCULATION  Start===========================================

 IF OBJECT_ID('TempDB..#DPD') Is Not Null
Drop Table #DPD


SELECT    CustomerAcID
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


------------------------------------------------=========================END===========================


Select * from (
Select 

Convert(Varchar(10),G.Date,103)CurrentProcessingDate
,ROW_NUMBER()Over(Order by A.UcifEntityId) SrNo
---------RefColumns---------
,H.SourceName
,A.CustomerAcID
,A.RefCustomerID as CustomerID
,F.CustomerName
,A.UCIF_ID
,A.FacilityType
,F.PANNO
,F.AadharCardNO
,Convert(Varchar(10),A.InitialNpaDt,103)InitialNpaDt
,A.InitialAssetClassAlt_Key
,E.AssetClassName as InitalAssetClassName

----Edit--------
,convert(varchar(10),A.FirstDtOfDisb,103)FirstDtOfDisb
,A.ProductAlt_Key
,D.ProductName
,A.Balance
,A.PrincOutStd
,A.PrincOverdue
,A.IntOverdue
,A.DrawingPower
,A.CurrentLimit
,Convert(Varchar(10),A.ContiExcessDt,103)ContiExcessDt
,Convert(Varchar(10),A.StockStDt,103)StockStDt
,Convert(Varchar(10),A.DebitSinceDt,103)DebitSinceDt
,Convert(Varchar(10),A.LastCrDate,103)LastCrDate
,A.CurQtrCredit
,A.CurQtrInt
,case when (A.CurQtrInt-A.CurQtrCredit)>0
      then (A.CurQtrInt-A.CurQtrCredit)
	  else 0 end    inttNotServiced
,A.InttServiced
,Convert(Varchar(10),A.IntNotServicedDt,103)IntNotServicedDt
,Convert(Varchar(10),A.OverDueSinceDt,103)OverDueSinceDt
,Convert(Varchar(10),A.ReviewDueDt,103)ReviewDueDt
,A.SecurityValue
,A.DFVAmt
,A.GovtGtyAmt
,A.WriteOffAmount
,A.UnAdjSubSidy
,A.Asset_Norm
,A.AddlProvision
,Convert(Varchar(10),A.PrincOverdueSinceDt,103)PrincOverdueSinceDt
,Convert(Varchar(10),A.IntOverdueSinceDt,103)IntOverdueSinceDt
,Convert(Varchar(10),A.OtherOverdueSinceDt,103)OtherOverdueSinceDt
,A.UnserviedInt
,A.AdvanceRecovery

-------OutPut-----
,A.CoverGovGur
,A.DegReason
,A.NetBalance
,A.ApprRV
,A.SecuredAmt
,A.UnSecuredAmt
,A.ProvDFV
,A.Provsecured
,A.ProvUnsecured
,A.ProvCoverGovGur
,A.TotalProvision
,A.BankTotalProvision
,A.RBITotalProvision
,Convert(Varchar(10),A.FinalNpaDt,103)FinalNpaDt
,Convert(Varchar(10),F.DbtDt,103)DoubtfulDt
,A.UpgDate
,(CASE WHEN ISNULL(A.FinalAssetClassAlt_Key,1) = 1 THEN '001' ELSE '002' END)  REV_ASST_MAIN_CLS
,C.AssetClassName             AS REV_ASST_SUB_CLS
,'NPA'                        AS FinalAssetClassName
,DPD_Max
,DPD_IntService
,DPD_NoCredit
,DPD_Overdrawn
,DPD_Overdue
,DPD_Renewal
,DPD_StockStmt
,A.NPA_Reason
,A.FlgDeg
,A.FlgUpg
,A.FinalProvisionPer
,A.FlgSMA
,A.SMA_Dt
,A.SMA_Class
,A.SMA_Reason
,A.FlgPNPA
,A.PNPA_DATE
,A.PNPA_Reason
,F.CustMoveDescription                                AS CustSMAStatus
,D.SchemeType
,CONVERT(varchar(20),A.AcOpenDt,103)        AS AccountOpenDate
,isnull(A.OtherOverdue,0)                             AS OtherOverdue
,CONVERT(varchar(20),A.OtherOverdueSinceDt,103)       AS otherOverDueDt
,CONVERT(varchar(20),A.FinalNpaDt,103)                AS NpaDt
,f.dbtdt,f.dbtdt2,f.dbtdt3,f.lossdt
FROM Pro.AccountCal_HIst A

INNER JOIN Pro.CustomerCal_Hist F                 ON F.CustomerEntityId=A.CustomerEntityId 
                                                     AND F.EffectiveFromTimeKey<=@TimeKey  
												     AND F.EffectiveToTimeKey>=@TimeKey
													 AND A.EffectiveFromTimeKey<=@TimeKey  
													 AND A.EffectiveToTimeKey>=@TimeKey
													  
INNER JOIN SysDayMatrix G                         ON A.EffectiveFromTimekey=G.TimeKey


INNER JOIN #DPD DPD                               ON DPD.AccountEntityID=A.AccountEntityID

INNER JOIN DIMSOURCEDB H                          ON H.SourceAlt_Key=A.SourceAlt_Key   
                                                     AND H.EffectiveFromTimeKey<=@TimeKey  
													 AND H.EffectiveToTimeKey>=@TimeKey

LEFT JOIN	DimProduct D                          ON A.ProductAlt_Key=D.ProductAlt_Key 
                                                     AND D.EffectiveFromTimeKey<=@TimeKey  
													 AND D.EffectiveToTimeKey>=@TimeKey

LEFT JOIN	(select Distinct SourceAlt_Key
                            ,AssetClassAlt_Key
							,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' 
							       ELSE SrcSysClassCode 
							  END)SrcSysClassName 
							,AssetClassName
							,EffectiveFromTimeKey
							,EffectiveToTimeKey
			  from DimAssetClassMapping) C         ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                      AND C.SourceAlt_Key=D.SourceAlt_Key
                                                      AND C.EffectiveFromTimeKey<=@TimeKey  
													  AND C.EffectiveToTimeKey>=@TimeKey

LEFT JOIN   (select Distinct SourceAlt_Key
                            ,AssetClassAlt_Key
							,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' 
							       ELSE SrcSysClassCode 
							  END)SrcSysClassName 
							,AssetClassName
							,EffectiveFromTimeKey
							,EffectiveToTimeKey
					from DimAssetClassMapping) E    ON E.AssetClassAlt_Key=A.InitialAssetClassAlt_Key 
                                                       AND	C.SourceAlt_Key=D.SourceAlt_Key
                                                       AND E.EffectiveFromTimeKey<=@TimeKey  
													  AND E.EffectiveToTimeKey>=@TimeKey


--LEFT JOIN AdvAcBasicDetail   ACBD                   ON A.AccountEntityID=ACBD.AccountEntityID 
--                                                       AND   ACBD.EffectiveFromTimeKey<=@TimeKey  
--													   AND   ACBD.EffectiveToTimeKey>=@TimeKey

WHERE A.finalAssetClassAlt_key>1 

 )AA where AA.REV_ASST_SUB_CLS is not null
 order by AA.SrNo
OPTION(RECOMPILE)

DROP TABLE #DPD
GO
