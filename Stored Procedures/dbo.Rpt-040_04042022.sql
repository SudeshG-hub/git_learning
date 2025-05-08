SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt-040_04042022]
@TimeKey  INT
AS

/*
Report Name : SMA1_REPORT
Date : 11-11-2021 
*/
BEGIN

--Declare @Timekey as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

----DECLARE  @TimeKey AS INT=26115

declare @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)

---------------------------======================================DPD CalCULATION  Start===========================================

 Drop table if exists   #DPD 

select * into #DPD from  PRO.AccountCal_Hist where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
alter Table #DPD
add DPD_IntService int,DPD_NoCredit int,DPD_Overdrawn int,DPD_Overdue int,DPD_Renewal int,DPD_StockStmt int,DPD_MAX INT


/*---------- CALCULATED ALL DPD---------------------------------------------------------*/

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)  ELSE 0 END)			   
             ,A.DPD_NoCredit =  (CASE WHEN  A.LastCrDate IS NOT NULL      THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)       ELSE 0 END)
			 ,A.DPD_Overdrawn=  (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate)     ELSE 0 END)
			 ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)   ELSE 0 END) 
			 ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)      ELSE 0 END)
			 ,A.DPD_StockStmt=  (CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate)       ELSE 0 END)
FROM #DPD A 



/*--------------IF ANY DPD IS NEGATIVE THEN ZERO---------------------------------*/

 UPDATE #DPD SET DPD_IntService=0 WHERE isnull(DPD_IntService,0)<0
 UPDATE #DPD SET DPD_NoCredit=0 WHERE isnull(DPD_NoCredit,0)<0
 UPDATE #DPD SET DPD_Overdrawn=0 WHERE isnull(DPD_Overdrawn,0)<0
 UPDATE #DPD SET DPD_Overdue=0 WHERE isnull(DPD_Overdue,0)<0
 UPDATE #DPD SET DPD_Renewal=0 WHERE isnull(DPD_Renewal,0)<0
 UPDATE #DPD SET DPD_StockStmt=0 WHERE isnull(DPD_StockStmt,0)<0

/*------------DPD IS ZERO FOR ALL ACCOUNT DUE TO LASTCRDATE ------------------------------------*/

UPDATE A SET DPD_NoCredit=0 FROM #DPD A 



/* CALCULATE MAX DPD */

	 IF OBJECT_ID('TEMPDB..#TEMPTABLE') IS NOT NULL
	    DROP TABLE #TEMPTABLE

	 SELECT A.CustomerAcID
			,CASE WHEN  isnull(A.DPD_IntService,0)>=isnull(A.RefPeriodIntService,0)		THEN A.DPD_IntService  ELSE 0   END DPD_IntService,  
			 CASE WHEN  isnull(A.DPD_NoCredit,0)>=isnull(A.RefPeriodNoCredit,0)			THEN A.DPD_NoCredit    ELSE 0   END DPD_NoCredit,  
			 CASE WHEN  isnull(A.DPD_Overdrawn,0)>=isnull(A.RefPeriodOverDrawn	,0)	    THEN A.DPD_Overdrawn   ELSE 0   END DPD_Overdrawn,  
			 CASE WHEN  isnull(A.DPD_Overdue,0)>=isnull(A.RefPeriodOverdue	,0)		    THEN A.DPD_Overdue     ELSE 0   END DPD_Overdue , 
			 CASE WHEN  isnull(A.DPD_Renewal,0)>=isnull(A.RefPeriodReview	,0)			THEN A.DPD_Renewal     ELSE 0   END  DPD_Renewal ,
			 CASE WHEN  isnull(A.DPD_StockStmt,0)>=isnull(A.RefPeriodStkStatement,0)       THEN A.DPD_StockStmt   ELSE 0   END DPD_StockStmt  
			 INTO #TEMPTABLE
			 --FROM PRO.ACCOUNTCAL A inner join pro.CustomerCal B on a.RefCustomerID=b.RefCustomerID
			 FROM #DPD A inner join pro.CustomerCal_hist B on A.SourceSystemCustomerID=B.SourceSystemCustomerID
			     and B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey
			 WHERE ( 
			          isnull(DPD_IntService,0)>=isnull(RefPeriodIntService,0)
                   OR isnull(DPD_NoCredit,0)>=isnull(RefPeriodNoCredit,0)
				   OR isnull(DPD_Overdrawn,0)>=isnull(RefPeriodOverDrawn,0)
				   OR isnull(DPD_Overdue,0)>=isnull(RefPeriodOverdue,0)
				   OR isnull(DPD_Renewal,0)>=isnull(RefPeriodReview,0)
                   OR isnull(DPD_StockStmt,0)>=isnull(RefPeriodStkStatement,0)
			      ) AND (isnull(B.FlgProcessing,'N')='N' 
	
			      )
			    
				--and A.RefCustomerID<>'0'

	/*--------------INTIAL MAX DPD 0 FOR RE PROCESSING DATA-------------------------*/

		UPDATE A SET A.DPD_Max=0
		 FROM #DPD A 
		 --inner join PRO.CUSTOMERCAL B on A.RefCustomerID=B.RefCustomerID
		 --WHERE  isnull(B.FlgProcessing,'N')='N'  


		/*----------------FIND MAX DPD---------------------------------------*/

		UPDATE   A SET A.DPD_Max= (CASE    WHEN (isnull(A.DPD_IntService,0)>=isnull(A.DPD_NoCredit,0) AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdrawn,0) AND    isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdue,0) AND  isnull(A.DPD_IntService,0)>=isnull(A.DPD_Renewal,0) AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_StockStmt,0)) THEN isnull(A.DPD_IntService,0)
										   WHEN (isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_IntService,0) AND isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Overdrawn,0) AND    isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_Overdue,0) AND    isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Renewal,0) AND isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_StockStmt,0)) THEN   isnull(A.DPD_NoCredit ,0)
										   WHEN (isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_NoCredit,0)  AND isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_IntService,0)  AND  isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_Overdue,0) AND   isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_Renewal,0) AND isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_StockStmt,0)) THEN  isnull(A.DPD_Overdrawn,0)
										   WHEN (isnull(A.DPD_Renewal,0)>=isnull(A.DPD_NoCredit,0)    AND isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_IntService,0)  AND  isnull(A.DPD_Renewal,0)>=isnull(A.DPD_Overdrawn,0)  AND  isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_Overdue,0)  AND isnull(A.DPD_Renewal,0) >=isnull(A.DPD_StockStmt ,0)) THEN isnull(A.DPD_Renewal,0)
										   WHEN (isnull(A.DPD_Overdue,0)>=isnull(A.DPD_NoCredit,0)    AND isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_IntService,0)  AND  isnull(A.DPD_Overdue,0)>=isnull(A.DPD_Overdrawn,0)  AND  isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_Renewal,0)  AND isnull(A.DPD_Overdue ,0)>=isnull(A.DPD_StockStmt ,0))  THEN   isnull(A.DPD_Overdue,0)
										   ELSE isnull(A.DPD_StockStmt,0) END) 
			 
		FROM  #DPD a 
		--INNER JOIN PRO.CUSTOMERCAL C ON C.RefCustomerID=a.RefCustomerID
		INNER JOIN PRO.CustomerCal_Hist C ON C.SourceSystemCustomerID=a.SourceSystemCustomerID
		and C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
		WHERE  (isnull(C.FlgProcessing,'N')='N') 
		AND 
		(isnull(A.DPD_IntService,0)>0   OR isnull(A.DPD_Overdrawn,0)>0   OR  Isnull(A.DPD_Overdue,0)>0	 OR isnull(A.DPD_Renewal,0) >0 OR
		isnull(A.DPD_StockStmt,0)>0 OR isnull(DPD_NoCredit,0)>0)


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

inner join      pro.AdvAcRestructureCal c
on              b.AccountEntityID=c.AccountEntityId
where           b.FinalAssetClassAlt_Key > 1
and C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
group by         B.UCIF_ID
)A
Group By UCIF_ID


IF OBJECT_ID('TempDB..#SMA1Data') Is Not Null
Drop Table #SMA1Data


Select * into #SMA1Data from (
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
,D.AssetClassName as InitalAssetClassName

----Edit--------
,A.FirstDtOfDisb
,A.ProductAlt_Key
,C.ProductName
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
--,A.RePossession
--,A.RCPending
--,A.PaymentPending
--,A.WheelCase
--,A.RFA
--,A.IsNonCooperative
--,A.Sarfaesi
--,A.WeakAccount
--,A.SubLendingFlag
--,A.AbscondingFlag
--,A.BenamiLoansFlag
--,A.MarkSubLendingDate
--,A.MarkAbscondingDate
--,A.MarkBenamiDate


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
,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												When A.SourceAlt_Key=1 and C.Segment='TWL' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												When A.SourceAlt_Key=1 and C.Segment='AGRI' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												When A.SourceAlt_Key=2 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
												ENd REV_ASST_MAIN_CLS

,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												When A.SourceAlt_Key=1 and C.Segment='TWL' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												When A.SourceAlt_Key=1 and C.Segment='AGRI' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												When A.SourceAlt_Key=2 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
												ENd  REV_ASST_SUB_CLS
,E.AssetClassName as FinalAssetClassName
,DPD1.DPD_IntService
,DPD1.DPD_NoCredit
,DPD1.DPD_Overdrawn
,DPD1.DPD_Overdue
,DPD1.DPD_Renewal
,DPD1.DPD_StockStmt
--,CASE WHEN ISNULL(A.DPD_Max,0)>ISNULL(R.TOTAL_DPD,0) THEN ISNULL(A.DPD_Max,0) ELSE ISNULL(R.TOTAL_DPD,0) END DPD_Max
,CASE WHEN R.AccountEntityId IS NOT NULL and A.FinalAssetClassAlt_Key>1 Then R.TOTAL_DPD Else DPD.UCIF_DPD_MAX END DPD_MAX
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
,F.CustMoveDescription as CustSMAStatus
-----------------------------------------------------
,case When A.SourceAlt_Key=1 and C.Segment='UNSECURED' then 'MicroBanking and Personal Loans'
 When A.SourceAlt_Key=1 and C.Segment='SECURED' then 'SECURED and FIG Loans' 
 else  c.segment End BusinessVerticals
--,CASE WHEN ISNULL(A.DPD,0)>ISNULL(R.TOTAL_DPD,0) THEN ISNULL(A.DPD,0) ELSE ISNULL(R.TOTAL_DPD,0) END DPD
,A.BranchCode
,DB.BranchStateName
--,case when R.AccountEntityId is not null then 'R' else NULL end Restructure_type_flag
,(case When R.RF2_CODE IS NOT NULL THEN RF2_CODE
when RestructureTypeAlt_Key in (4,5) AND R.RF2_CODE IS NULL then 'MSME'
when RestructureTypeAlt_Key in (6,7,8,9) then P.ParameterName
when RestructureTypeAlt_Key in (3) AND R.RF2_CODE IS NULL AND R.COVID_OTR_Catg = 1  then 'RCPL'
when RestructureTypeAlt_Key in (3) AND R.RF2_CODE IS NULL AND R.COVID_OTR_Catg = 2  then 'RCOC'
else null

END)Restructure_type_flag
--,A.TwoFlag
--, R.SLBC_Restructuring
--,CASE WHEN SD.[SLBC Flag] IS NOT NULL THEN SD.[SLBC Flag] ELSE NULL END SLBC_Restructuring
,(A.ProvSecured/case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as Secured_Provision_per
,(A.ProvUnsecured/case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as UnSecured_Provision_per
,(A.TotalProvision / case when a.NetBalance=0 then 1 else a.NetBalance end) * 100 as TotalProvision_per
,DPD.UCIF_DPD_MAX   Client_Level_DPD
,(a.Balance-a.PrincOutStd) Interest_Receivable
,a.ProductCode as Product_ID
--,SD.[Provision Rate] SLBC_Provision_Rate
--,(sd.[Provision Rate]*a.NetBalance)/100 SLBC_Provision_Amount

From Pro.AccountCal_Hist A
inner join  DimBranch DB on DB.BranchCode=A.BranchCode AND DB.EffectiveToTimeKey=49999
Inner Join DimProduct C ON C.ProductAlt_Key=A.ProductAlt_Key 
                              And C.EffectiveToTimeKey=49999
							  AND A.EffectiveFromTimeKey=@TimeKey
Inner Join DimAssetClass D On D.AssetClassAlt_Key=A.InitialAssetClassAlt_Key 
                              And D.EffectiveToTimeKey=49999
INNER JOIN DimAssetClass E On E.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                              And E.EffectiveToTimeKey=49999
Inner Join Pro.CustomerCal_HIST F On F.CustomerEntityId=A.CustomerEntityId AND F.EffectiveFromTimeKey=@TimeKey
Inner Join SysDayMatrix G ON A.EffectiveFromTimekey=G.TimeKey
INNER JOIN DIMSOURCEDB H ON H.SourceAlt_Key=A.SourceAlt_Key   And H.EffectiveToTimeKey=49999
Inner Join DimAssetClassMapping I ON  I.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                  And I.Segment=C.Segment 
								  And I.SourceAlt_Key=C.SourceAlt_Key
                                  And I.EffectiveToTimeKey=49999
INNER JOIN #DPD DPD1 ON DPD1.AccountEntityID=A.AccountEntityID
INNER JOIN #UCIF_DPD  DPD ON DPD.UCIF_ID=A.UCIF_ID
 LEFT JOIN  PRO.AdvAcRestructureCal R
		ON R.AccountEntityId=A.AccountEntityId
LEFT join DimParameter P on p.ParameterAlt_Key=r.RestructureTypeAlt_Key ANd p.DimParameterName ='TypeOfRestructuring'

 ----LEFT JOIN  SLBC_DATA_UJJIVAN SD
 ----ON         A.CustomerAcID=SD.AccountID+'-'+CAST(SD.LoanSeries AS VARCHAR(2))
 
Where A.finalAssetClassAlt_key=1 --And A.DPD_Max>30 And A.DPD_Max<=60
AND UCIF_DPD_MAX>30 AND UCIF_DPD_MAX<=60
---------------------Added on 31-08-2021
ANd Not Exists (Select 1 from #DPD PA 
Inner Join DimProduct DP ON PA.ProductAlt_Key =DP.ProductAlt_Key And DP.EffectiveToTimeKey=49999
Where DP.ProductCode in ('23001','23002') and PA.Asset_Norm='ALWYS_STD'
And PA.CustomerAcID=A.CustomerAcID
)


--AND A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey
--Inner Join DimProduct D On B.ProductAlt_Key=D.ProductAlt_Key And D.EffectiveToTimeKey=49999
--Inner Join DimAssetClassMapping I ON I.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
--                            And I.Segment=C.Segment And I.SourceAlt_Key=C.SourceAlt_Key
--And I.EffectiveToTimeKey=49999
 )AA where AA.REV_ASST_SUB_CLS is not null 
 order by AA.SrNo


 
 -----------Added on 27092021

 
 IF OBJECT_ID('TempDB..#AgriUcif') Is Not Null
 Drop Table #AgriUcif

 Select A.UCIF_ID into #AgriUcif from #SMA1Data A
 Inner Join CurDat.AdvAcBasicDetail C ON C.CustomerACID=A.CustomerAcID
 Inner Join #DPD D ON D.CustomerAcID=A.CustomerAcID
 Inner Join DimProduct B ON A.ProductAlt_Key=B.ProductAlt_Key
 Inner Join #UCIF_DPD E ON E.UCIF_ID=A.UCIF_ID
 Where B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@Timekey
 and C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
 ANd B.ProductCode='25007' ANd C.ReferencePeriod=90
 ANd D.DPD_MAX Between 31 and 60
 And E.UCIF_DPD_MAX Between 31 and 60




 --Select *
 Update A Set REV_ASST_SUB_CLS='SMA1'
 from #SMA1Data A
 Inner Join #AgriUcif B ON A.UCIF_ID=B.UCIF_ID


 --Inner Join CurDat.AdvAcBasicDetail C ON C.CustomerACID=A.CustomerAcID
 --Inner Join Pro.ACCOUNTCAL D ON D.CustomerAcID=A.CustomerAcID
 --Inner Join DimProduct B ON A.ProductAlt_Key=B.ProductAlt_Key
 --Where B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@Timekey
 --ANd B.ProductCode='25007' ANd C.ReferencePeriod=90
 --And D.DPD_Max Between 31 and 60

 ----------------------------------------

 Select * from #SMA1Data

 ----------------------------------


 END
GO
