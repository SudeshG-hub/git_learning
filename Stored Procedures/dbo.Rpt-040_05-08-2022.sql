SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Procedure [dbo].[Rpt-040_05-08-2022]
@TimeKey  INT
AS


--DECLARE  @TimeKey AS INT=26512

declare @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)

---------------------------======================================DPD CalCULATION  Start===========================================

 IF OBJECT_ID('TempDB..#DPD') Is Not Null
Drop Table #DPD


SELECT            CustomerAcID
                 ,AccountEntityID
				 ,UCIF_ID
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
				 ,FinalAssetClassAlt_Key
				 ,Asset_Norm
				 ,ProductAlt_Key
INTO #DPD
FROM pro.AccountCal_Hist
WHERE EffectiveFromTimeKey <= @Timekey AND EffectiveToTimeKey >= @Timekey


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


------------------------------------------------=========================END===========================
--UCIF Level
       
 IF OBJECT_ID('TempDB..#UCIF_DPD') IS Not NUll
 Drop Table #UCIF_DPD

 Select UCIF_ID,Max(UCIF_DPD_MAX)UCIF_DPD_MAX into #UCIF_DPD from (
SELECT UCIF_ID ,MAX(DPD_Max) UCIF_DPD_MAX 

 FROM #DPD
 Where Asset_Norm<>'ALWYS_STD' 
 GROUP BY UCIF_ID
 UNION
 

select b.UCIF_ID,max(ISNULL(c.TOTAL_DPD,0)) TOTAL_DPD_Max 
---	into #UCIF_DPD_Rstr 
from      #DPD b

INNER JOIN      pro.AdvAcRestructureCal_Hist c       on  b.AccountEntityID=c.AccountEntityId
where           b.FinalAssetClassAlt_Key > 1

and C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
group by         B.UCIF_ID
)A
Group By UCIF_ID



Select *  from (
Select 
DISTINCT
Convert(Varchar(10),@ProcessDate,103)CurrentProcessingDate
--,ROW_NUMBER()Over(Order by A.UcifEntityId) SrNo
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
,Convert(Varchar(10),A.FirstDtOfDisb,103)FirstDtOfDisb
,A.ProductAlt_Key
,D.ProductName
,SchemeType
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
--,Convert(Varchar(10),A.RepossessionDate,103)RepossessionDate
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
,C.SrcSysClassName REV_ASST_SUB_CLS
,C.AssetClassName as FinalAssetClassName
,DPD1.DPD_IntService
,DPD1.DPD_NoCredit
,DPD1.DPD_Overdrawn
,DPD1.DPD_Overdue
,DPD1.DPD_Renewal
,DPD1.DPD_StockStmt
,CASE WHEN R.AccountEntityId IS NOT NULL and A.FinalAssetClassAlt_Key>1 Then R.TOTAL_DPD Else DPD.UCIF_DPD_MAX END DPD_MAX
,A.NPA_Reason
,A.FlgDeg
,A.FlgUpg
,A.FinalProvisionPer
,A.FlgSMA
,Convert(Varchar(10),A.SMA_Dt,103)SMA_Dt
------,A.SMA_Class
,CASE WHEN A.SMA_Class='SMA_0' THEN 'SMA 0'
      WHEN A.SMA_Class='SMA_1' THEN 'SMA 1'
	  WHEN A.SMA_Class='SMA_2' THEN 'SMA 2'
	  END SMA_Class

,A.SMA_Reason
,A.FlgPNPA
,A.PNPA_DATE
,A.PNPA_Reason
,CASE WHEN F.CustMoveDescription='SMA_0' THEN 'SMA 0'
      WHEN F.CustMoveDescription='SMA_1' THEN 'SMA 1'
	  WHEN F.CustMoveDescription='SMA_2' THEN 'SMA 2'
	  END CustSMAStatus
-----------------------------------------------------

,'' BusinessVerticals
,A.BranchCode
,DB.BranchStateName

,(A.ProvSecured/case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as Secured_Provision_per
,(A.ProvUnsecured/case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as UnSecured_Provision_per
,(A.TotalProvision / case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as TotalProvision_per
,DPD.UCIF_DPD_MAX   Client_Level_DPD
,(a.Balance-a.PrincOutStd) Interest_Receivable
,a.ProductCode as Product_ID


,isnull(A.OtherOverdue,0)OtherOverdue
,CONVERT(varchar(20),A.OtherOverdueSinceDt,103)otherOverDueDt

FROM Pro.AccountCal_Hist A
INNER JOIN Pro.CustomerCal_HIST F                 On F.CustomerEntityId=A.CustomerEntityId 
                                                  AND F.EffectiveFromTimeKey <= @Timekey AND F.EffectiveToTimeKey >= @Timekey
												  AND A.EffectiveFromTimeKey <= @Timekey AND A.EffectiveToTimeKey >= @Timekey

INNER JOIN  DimBranch DB                          on DB.BranchCode=A.BranchCode 
                                                  AND DB.EffectiveToTimeKey=49999

LEFT JOIN	DimProduct D                          On A.ProductAlt_Key=D.ProductAlt_Key 
                                                  And D.EffectiveToTimeKey=49999

LEFT JOIN	(select Distinct SourceAlt_Key
                            ,AssetClassAlt_Key
							,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' 
							       ELSE SrcSysClassCode 
							  END)SrcSysClassName 
							,AssetClassName
							,EffectiveFromTimeKey
							,EffectiveToTimeKey
			  from DimAssetClassMapping) C         ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                   And C.SourceAlt_Key=D.SourceAlt_Key
                                                   And C.EffectiveToTimeKey=49999

LEFT JOIN   (select Distinct SourceAlt_Key
                            ,AssetClassAlt_Key
							,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' 
							       ELSE SrcSysClassCode 
							  END)SrcSysClassName 
							,AssetClassName
							,EffectiveFromTimeKey
							,EffectiveToTimeKey
					from DimAssetClassMapping) E    ON E.AssetClassAlt_Key=A.InitialAssetClassAlt_Key 
                                                    And	C.SourceAlt_Key=D.SourceAlt_Key
                                                    And	C.EffectiveToTimeKey=49999

INNER JOIN SysDayMatrix G                           ON A.EffectiveFromTimekey=G.TimeKey

INNER JOIN DIMSOURCEDB H                            ON H.SourceAlt_Key=A.SourceAlt_Key   
                                                    AND H.EffectiveToTimeKey=49999

INNER JOIN #DPD DPD1                                ON DPD1.AccountEntityID=A.AccountEntityID

INNER JOIN #UCIF_DPD  DPD                           ON DPD.UCIF_ID=A.UCIF_ID

LEFT JOIN  PRO.AdvAcRestructureCal_Hist R		    ON R.AccountEntityId=A.AccountEntityId
                                                    AND R.EffectiveFromTimeKey <= @Timekey AND R.EffectiveToTimeKey >= @Timekey

LEFT JOIN DimParameter P                            ON p.ParameterAlt_Key=r.RestructureTypeAlt_Key
                                                    AND p.DimParameterName ='TypeOfRestructuring'
													AND P.EffectiveToTimeKey=49999

 
 
Where A.finalAssetClassAlt_key=1 
AND A.FlgSMA='Y'


 )AA where AA.REV_ASST_SUB_CLS is not null 
 order by AA.CustomerID




 DROP TABLE #DPD,#UCIF_DPD

GO
