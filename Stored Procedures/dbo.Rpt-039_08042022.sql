SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--------------------AssetClassification  ALL NPA  Report----------------------

CREATE PROC [dbo].[Rpt-039_08042022]
	@TimeKey  INT
	AS 


--DECLARE  @TimeKey AS INT=26372
--select * from SysDayMatrix where TimeKey=25992
declare @ProcessDate date
set @ProcessDate=(select Date from Sysdaymatrix where Timekey=@TimeKey)
--select @ProcessDate

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
			 ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)+1      ELSE 0 END)
			 ,A.DPD_StockStmt=  (CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate)+1       ELSE 0 END)
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
		WHERE  (isnull(C.FlgProcessing,'N')='N') 
		AND 
		(isnull(A.DPD_IntService,0)>0   OR isnull(A.DPD_Overdrawn,0)>0   OR  Isnull(A.DPD_Overdue,0)>0	 OR isnull(A.DPD_Renewal,0) >0 OR
		isnull(A.DPD_StockStmt,0)>0 OR isnull(DPD_NoCredit,0)>0)


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
----,A.BenamiLoansFlag
----,convert(varchar(10),A.MarkBenamiDate,103) MarkBenamiDate
----,A.SubLendingFlag
----,convert(varchar(10),A.MarkSubLendingDate,103) MarkSubLendingDate
----,A.AbscondingFlag
----,convert(varchar(10),A.MarkAbscondingDate,103) MarkAbscondingDate

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
----,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And DPD.DPD_Max>=I.DPD_LowerValue and DPD.DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												When A.SourceAlt_Key=1 and C.Segment='TWL' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												When A.SourceAlt_Key=1 and C.Segment='AGRI' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												When A.SourceAlt_Key=2 and C.Segment='SECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysGroup
----												ENd REV_ASST_MAIN_CLS

----,Case When A.SourceAlt_Key=1 and C.Segment='SECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												When A.SourceAlt_Key=1 and C.Segment='UNSECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												When A.SourceAlt_Key=1 and C.Segment='TWL' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												When A.SourceAlt_Key=1 and C.Segment='AGRI' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												When A.SourceAlt_Key=2 and C.Segment='UNSECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												When A.SourceAlt_Key=2 and C.Segment='SECURED' And DPD_Max>=I.DPD_LowerValue and DPD_Max<=I.DPD_HigherValue then I.SrcSysClassName
----												ENd  REV_ASST_SUB_CLS
,E.AssetClassName as FinalAssetClassName
--,A.DPD_NoCredit
--,A.DPD_Overdrawn
--,A.DPD_Overdue
--,A.DPD_Renewal
--,A.DPD_StockStmt
,DPD_Max
,CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)+1  ELSE 0 END   as DPD_IntService
,CASE WHEN  A.LastCrDate IS NOT NULL      THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)+1       ELSE 0 END    as DPD_NoCredit
,CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate)+1     ELSE 0 END as DPD_Overdrawn
,CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)+1   ELSE 0 END  as DPD_Overdue
,CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)+1      ELSE 0 END	   as DPD_Renewal
,CASE WHEN  A.StockStDt IS NOT NULL         THEN   DATEDIFF(DAY,A.StockStDt,@ProcessDate) +1      ELSE 0 END   as DPD_StockStmt
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
,D.SchemeType
,CONVERT(varchar(20),ACBD.AccountOpenDate,103)AccountOpenDate
,isnull(A.OtherOverdue,0)OtherOverdue
,CONVERT(varchar(20),A.OtherOverdueSinceDt,103)otherOverDueDt

--declare @timekey int=25992
--select * 
From Pro.AccountCal_HIst A

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
Inner Join Pro.CustomerCal_Hist F On F.CustomerEntityId=A.CustomerEntityId AND F.EffectiveFromTimeKey=@TimeKey
Inner Join SysDayMatrix G ON A.EffectiveFromTimekey=G.TimeKey
INNER JOIN DIMSOURCEDB H ON H.SourceAlt_Key=A.SourceAlt_Key   And H.EffectiveToTimeKey=49999
------Inner Join DimAssetClassMapping I ON  I.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
------                                  And I.Segment=C.Segment 
------								  And I.SourceAlt_Key=C.SourceAlt_Key
------                                  And I.EffectiveToTimeKey=49999

inner JOIN #DPD DPD             ON DPD.AccountEntityID=A.AccountEntityID
LEFT JOIN AdvAcBasicDetail   ACBD   ON A.AccountEntityID=ACBD.AccountEntityID AND   ACBD.EffectiveFromTimeKey<=@TimeKey  AND   ACBD.EffectiveToTimeKey>=@TimeKey
----WHERE      A.FLGDEG='Y'
----Where A.flgupg='U'
Where A.finalAssetClassAlt_key>1  ----and F.RefCustomerID='9987800'
----select * from Pro.CustomerCal
----Inner Join DimProduct D On B.ProductAlt_Key=D.ProductAlt_Key And D.EffectiveToTimeKey=49999
----Inner Join DimAssetClassMapping I ON I.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
----                            And I.Segment=C.Segment And I.SourceAlt_Key=C.SourceAlt_Key
----And I.EffectiveToTimeKey=49999
 )AA where AA.REV_ASST_SUB_CLS is not null
 order by AA.SrNo
OPTION(RECOMPILE)


----select * from  pro.AccountCal_Hist where customeracid='129005000001001'
GO
