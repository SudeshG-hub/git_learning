SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create Procedure [dbo].[Rpt-040_18042022]
@TimeKey  INT
AS


--BEGIN

--Declare @Timekey as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

----DECLARE  @TimeKey AS INT=26299

declare @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)

---------------------------======================================DPD CalCULATION  Start===========================================

 Drop table if exists   #DPD 

select * into #DPD from  PRO.AccountCal_Hist where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
alter Table #DPD

add DPD_IntService int,DPD_NoCredit int,DPD_Overdrawn int,DPD_Overdue int,DPD_Renewal int,DPD_StockStmt int,DPD_MAX INT


/*---------- CALCULATED ALL DPD---------------------------------------------------------*/

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)+1  ELSE 0 END)			   
             ,A.DPD_NoCredit =  (CASE WHEN  A.LastCrDate IS NOT NULL      THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)+1       ELSE 0 END)
			 ,A.DPD_Overdrawn=  (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate)+1     ELSE 0 END)
			 ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)+1   ELSE 0 END) 
			 ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate) +1     ELSE 0 END)
			 ,A.DPD_StockStmt=  (CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate)  +1     ELSE 0 END)
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
------,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												When A.SourceAlt_Key=1 and C.Segment='TWL' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												When A.SourceAlt_Key=1 and C.Segment='AGRI' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												When A.SourceAlt_Key=2 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysGroup
------												ENd REV_ASST_MAIN_CLS

------,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												When A.SourceAlt_Key=1 and C.Segment='TWL' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												When A.SourceAlt_Key=1 and C.Segment='AGRI' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												When A.SourceAlt_Key=2 and C.Segment='SECURED' And UCIF_DPD_MAX>=I.DPD_LowerValue and UCIF_DPD_MAX<=I.DPD_HigherValue then I.SrcSysClassName
------												ENd  REV_ASST_SUB_CLS
,C.AssetClassName as FinalAssetClassName
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
------,F.CustMoveDescription as CustSMAStatus
-----------------------------------------------------
----,case When A.SourceAlt_Key=1 and C.Segment='UNSECURED' then 'MicroBanking and Personal Loans'
---- When A.SourceAlt_Key=1 and C.Segment='SECURED' then 'SECURED and FIG Loans' 
---- else  c.segment End BusinessVerticals
,'' BusinessVerticals
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

,isnull(A.OtherOverdue,0)OtherOverdue
,CONVERT(varchar(20),A.OtherOverdueSinceDt,103)otherOverDueDt

From Pro.AccountCal_Hist A
inner join  DimBranch DB                          on DB.BranchCode=A.BranchCode 
                                                  AND DB.EffectiveToTimeKey=49999

Left Join	DimProduct D                          On A.ProductAlt_Key=D.ProductAlt_Key 
                                                  And D.EffectiveToTimeKey=49999

left Join	(select Distinct SourceAlt_Key
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

LEFT Join   (select Distinct SourceAlt_Key
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

Inner Join Pro.CustomerCal_HIST F                   On F.CustomerEntityId=A.CustomerEntityId 
                                                    AND F.EffectiveFromTimeKey=@TimeKey

Inner Join SysDayMatrix G                           ON A.EffectiveFromTimekey=G.TimeKey

INNER JOIN DIMSOURCEDB H                            ON H.SourceAlt_Key=A.SourceAlt_Key   
                                                    And H.EffectiveToTimeKey=49999

INNER JOIN #DPD DPD1                                ON DPD1.AccountEntityID=A.AccountEntityID

INNER JOIN #UCIF_DPD  DPD                           ON DPD.UCIF_ID=A.UCIF_ID

LEFT JOIN  PRO.AdvAcRestructureCal R		        ON R.AccountEntityId=A.AccountEntityId

LEFT join DimParameter P                            on p.ParameterAlt_Key=r.RestructureTypeAlt_Key
                                                    ANd p.DimParameterName ='TypeOfRestructuring'

 
 
Where A.finalAssetClassAlt_key=1 --And A.DPD_Max>30 And A.DPD_Max<=60
AND A.FlgSMA='Y'
AND(    (UCIF_DPD_MAX>0  AND UCIF_DPD_MAX<=30)
     OR (UCIF_DPD_MAX>30 AND UCIF_DPD_MAX<=60)
     OR (UCIF_DPD_MAX>60 AND UCIF_DPD_MAX<=90))
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

 Select A.UCIF_ID,UCIF_DPD_MAX 
 into #AgriUcif 
 from #SMA1Data A
 Inner Join CurDat.AdvAcBasicDetail C      ON C.CustomerACID=A.CustomerAcID

 Inner Join #DPD D                         ON D.CustomerAcID=A.CustomerAcID

 Inner Join DimProduct B                   ON A.ProductAlt_Key=B.ProductAlt_Key

 Inner Join #UCIF_DPD E                    ON E.UCIF_ID=A.UCIF_ID

 Where B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@Timekey
 and C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
 ANd B.ProductCode='25007' ANd C.ReferencePeriod=90
 ANd D.DPD_MAX Between 1 and 90
 And E.UCIF_DPD_MAX Between 1 and 90




 --Select *  from #AgriUcif
 Update A Set REV_ASST_SUB_CLS= CASE WHEN UCIF_DPD_MAX >0  and UCIF_DPD_MAX<=30  THEN 'SMA0'
                                     WHEN UCIF_DPD_MAX >30 and UCIF_DPD_MAX<=60  THEN 'SMA1'
									 WHEN UCIF_DPD_MAX >60 and UCIF_DPD_MAX<=90  THEN 'SMA2'
									 END
 from #SMA1Data A
 Inner Join #AgriUcif B ON A.UCIF_ID=B.UCIF_ID


 --Inner Join CurDat.AdvAcBasicDetail C ON C.CustomerACID=A.CustomerAcID
 --Inner Join Pro.ACCOUNTCAL D ON D.CustomerAcID=A.CustomerAcID
 --Inner Join DimProduct B ON A.ProductAlt_Key=B.ProductAlt_Key
 --Where B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@Timekey
 --ANd B.ProductCode='25007' ANd C.ReferencePeriod=90
 --And D.DPD_Max Between 31 and 60

 ----------------------------------------

 --Select * from #SMA1Data

 ----------------------------------
if object_id('tempdb..#SMAReason')is not null
	drop table #SMAReason

select CustomerId,CustomerACID
,STUFF((SELECT ', ' + x.CustomerACID 
         FROM #SMA1Data x
		 WHERE x.CustomerId = #SMA1Data.CustomerId 
			AND x.SMA_Reason!='DEGRADE BY OVERDUE'
		 FOR XML PATH('')), 1, 1, '') as aaa
into #SMAReason
from #SMA1Data
where SMA_Reason='DEGRADE BY OVERDUE'
--and CustomerId=494819
group by CustomerId,CustomerACID

 ------END
-- update A set A.SMA_Reason=A.SMA_Reason+'Percolation from link Account No. ('+(select aaa from #SMAReason B 
--	where B.CustomerId=A.CustomerId and B.CustomerACID=A.CustomerACID)+')'
--FROM #SMA1Data A
--WHERE A.SMA_Reason='DEGRADE BY OVERDUE'

 /*

  IF OBJECT_ID('TempDB..#SMADATA') Is Not Null
 Drop Table #SMADATA
 SELECT ROW_NUMBER() OVER (PARTITION BY  CustomerId ORDER BY CustomerId ASC,SMA_Reason DESC)R1,* INTO #SMADATA FROM  #SMA1Data
 OPTION(RECOMPILE)
 SELECT CurrentProcessingDate,SrNo,SourceName,CustomerAcID,CustomerID,CustomerName,UCIF_ID	
       ,FacilityType,PANNO,AadharCardNO,InitialNpaDt,InitialAssetClassAlt_Key,InitalAssetClassName	
       ,FirstDtOfDisb,ProductAlt_Key,ProductName,Balance,PrincOutStd,PrincOverdue,IntOverdue	
       ,DrawingPower,CurrentLimit,ContiExcessDt,StockStDt,DebitSinceDt,LastCrDate,CurQtrCredit	
       ,CurQtrInt,InttServiced,IntNotServicedDt,OverDueSinceDt,ReviewDueDt,SecurityValue,DFVAmt	
       ,GovtGtyAmt,WriteOffAmount,UnAdjSubSidy,Asset_Norm,AddlProvision,PrincOverdueSinceDt,IntOverdueSinceDt	
       ,OtherOverdueSinceDt,UnserviedInt,AdvanceRecovery,CoverGovGur,DegReason,NetBalance,ApprRV,SecuredAmt	
       ,UnSecuredAmt,ProvDFV,Provsecured,ProvUnsecured,ProvCoverGovGur,TotalProvision,BankTotalProvision	
       ,RBITotalProvision,FinalNpaDt,DoubtfulDt,UpgDate,REV_ASST_MAIN_CLS,REV_ASST_SUB_CLS,FinalAssetClassName	
       ,DPD_IntService	,DPD_NoCredit,DPD_Overdrawn,DPD_Overdue,DPD_Renewal,DPD_StockStmt,DPD_MAX,NPA_Reason	
       ,FlgDeg	,FlgUpg	,FinalProvisionPer,FlgSMA,SMA_Dt,SMA_Class

       ,CASE   WHEN R1>1 and SMA_Reason=''
               THEN 'Percolation from other Account'
			   ELSE SMA_Reason
			   END AS SMA_Reason

       ,FlgPNPA,PNPA_DATE,PNPA_Reason	
       ,CustSMAStatus,BusinessVerticals,BranchCode,BranchStateName,Restructure_type_flag,Secured_Provision_per	
       ,UnSecured_Provision_per,TotalProvision_per,Client_Level_DPD,Interest_Receivable,Product_ID
	   FROM #SMADATA
 ORDER BY CustomerID
 ----Select CUSTOMERID,COUNT(CustomerAcID),CustomerAcID from #SMA1Data  GROUP BY CUSTOMERID,CustomerAcID HAVING COUNT( CustomerAcID)>1

 */

 SELECT * FROM #SMA1Data

 --END
GO
