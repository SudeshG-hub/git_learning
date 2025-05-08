SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec FacilityDetailSelect @CustomerEntityID=601,@AccountEntityID=101,@FacilityType=N'TL',@TimeKey=25999,@BranchCode=N'101',@OperationFlag=2,@AccountFlag=N'F'
--go


--sp_helptext FacilityDetailSelect

--------------------------------------------------------------------------------------------------------


--Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 -- =============================================
create PROCEDURE [dbo].[FacilityDetailSelect_15112022]
	 @CustomerEntityID INT=0
	,@AccountEntityID INT=0
	,@FacilityType varchar(10)=''
	,@TimeKey	INT=0
	,@BranchCode VARCHAR(10)=''
	,@OperationFlag TINYINT=0
	,@AccountFlag varchar(2)=''
 
 
-- Declare
--     @CustomerEntityID INT=1001556
--	,@AccountEntityID INT=679
--	,@FacilityType varchar(10)='AB'
--	,@TimeKey	INT=24570
--	,@BranchCode VARCHAR(10)='0110'
--	,@OperationFlag TINYINT=2
--	,@AccountFlag varchar(2)='F'

AS 

BEGIN

	SET NOCOUNT ON;

			
	IF (@OperationFlag=2)		
			BEGIN
										Select 
										A.CustomerAcId
										,Convert(Varchar(20),A.AccountOpenDate,103) AcOpenDt
										,I.SchemeType SchemeType
										,I.ProductName SchemeProductCode
										,A.SegmentCode ACSegmentCode
										,A.FacilityType
										,C.InttRate Rateofinterest
										,A.FlgSecured SecuredStatus
										--,A.AssetClass AssetClassNorm
										,A.ReferencePeriod AssetClassNorm
										,isnull(J.AssetClassName,'STANDARD') AS AssetClassCode
										,Convert(Varchar(20),C.NpaDt,103) NPADate
										,K.SubSectorName Sector
										,L.ActivityName PurposeofAdvance
										,A.CurrentLimit
										,Convert(varchar(20),A.CurrentLimitDt,103) CurrentLimitDate
										,Convert(varchar(20),A.DtofFirstDisb,103) FirstDateofDisbursement
										,B.Balance BalanceosINR
										,B.PrincipalBalance POS
										,B.InterestReceivable  InterestReceivable
										,B.UnAppliedIntAmount InterestAccrued
										,C.DrawingPower
										,G.AdhocAmt
										,Convert(Varchar(20),G.AdhocDt,103) AdhocDate
										,COnvert(varchar(20),G.AdhocExpiryDate,103) AdhocExpiryDate
										,convert(varchar(20),AC.IntNotServicedDt,103) IntNotServicedDate
										,Convert(Varchar(20),AC.DebitSinceDt,103) DebitSinceDate
										,Convert(Varchar(20),B.LastCrDt,103) LastCreditDate
										,Convert(Varchar(20),G.ContExcsSinceDt,103) ContiExcessDate
										,AC.CurQtrCredit CurQtrCredit
										,AC.CurQtrInt CurQtrInt
										,Convert(Varchar(20),AC.StockStDt,103) StockStatementDt
										--,NULL StockStatemenFrequency
										,Convert(varchar(20),C.Ac_ReviewDt,103) ReviewRenewalDueDate
										,B.OverduePrincipal PrincipalOverdueAmt
										,Convert(varchar(20),B.OverduePrincipalDt,103) PrincipalOverDueSinceDt
										,B.Overdueinterest InterestOverdueAmt
										,convert(varchar(20),B.OverdueIntDt,103) InterestOverDueSinceDt
										,F.CorporateUCIC_ID CorporateUCICID
										,F.CorporateCustomerID CorporateCustomerID
										,F.Liability
										,F.MinimumAmountDue
										,F.CD CycleDue
										,F.Bucket
										,F.DPD
										--,NULL AccountCategory
										--,NULL STDProvisionCategory
										--,Convert(varchar(20),E.WriteOffDt,103) DateofTWO
										,Convert(varchar(20),EFST_T.StatusDate,103) DateofTWO
										--,E.WriteOffAmt WriteOffAmt_HO
										,EFST_T.Amount WriteOffAmt_HO
										--,N.SplFlag FraudCommitted 
										,case when EFST.StatusType is null then 'No' else 'Yes' end FraudCommitted
										--,D.FMRDate FraudDate
										,Convert(varchar(20),EFST.StatusDate,103) FraudDate
										--,O.SplFlag IBPCExposure
										--,P.SplFlag SecurtisedExposure
										--,Q.SplFlag AbInitio
										--,R.SplFlag PUIMarked
										 ,case when pui.AccountEntityId is null then 'No' else 'Yes' end PUIMarked
										--,NULL RFAMarked
										--,S.SplFlag NonCooperative
										--,T.SplFlag Repossesion
										--,U.SplFlag Sarfaesi
										--,V.SplFlag Inherentweakness
										--,W.SplFlag RCPendingFlag
										--,M.ExitCDRFlg RestructureFlag
										,case when M.AccountEntityId is null then 'No' else 'Yes' end RestructureFlag
										--, Case When AD.StatusType ='TWO' Then AD.StatusDate Else '' END  [TWO Date]
										,Convert(varchar(20),EFST_T.StatusDate,103)  [TWO Date]
									    --, Case When AD.StatusType ='TWO' Then ISNULL(AD.Amount,0)  Else 0.00 END  [TWO Amount]
										,EFST_T.Amount as [TWO Amount]
                                       -- , AD.StatusDate AS [Fraud Date] --Sachin
									    --,EFST.StatusDate AS [Fraud Date] --PRASHANT
										--,IB.ExposureAmount AS [IBPC Exposure Amount] --Sachin
										--,SF.ExposureAmount AS [Securtised Exposure Amount] --Sachin
										--,N.SplFlag AS [Fraud Committed] --Sachin
										--,case when EFST.StatusType is null then 'No' else 'Yes' end [Fraud Committed] --PRASHANT
										--,Q.SplFlag AS [Ab-Initio] --Sachin
										--,R.SplFlag AS [PUI Marked] --Sachin
										--,case when pui.AccountEntityId is null then 'No' else 'Yes' end [PUI Marked]
										--,RF.SplFlag AS [RFA Marked] --Sachin
										,Case when RFA.RefCustomerACID is not null Then 'Yes' Else 'No'  END RFAFlag
										,RFA.RFA_DateReportingByBank as RFADAte
										,B.UnAppliedIntAmount as UnAppliedIntAmount
										,Case When ACH.FinalAssetClassAlt_Key=1 Then ACH.SMA_Class Else J.AssetClassShortNameEnum  ENd as AssetSubClass
										,ACH.TotalProvision as ProvisionAmount
										,AC.DPD_Max as DPDMax

										From CurDat.AdvAcBasicDetail A
										LEFT JOIN CurDat.AdvAcBalanceDetail B ON A.AccountEntityId=B.AccountEntityId
										AND B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN CurDat.AdvAcFinancialDetail C ON C.AccountEntityId=A.AccountEntityId
										AND C.EffectiveFromTimeKey<=@TimeKey And C.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN CurDat.AdvCustOtherDetail D ON D.CustomerEntityId=A.CustomerEntityId
										AND D.EffectiveFromTimeKey<=@TimeKey And D.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN CurDat.AdvAcWODetail E ON E.AccountEntityId=A.AccountEntityId
										AND E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN CurDat.AdvFacCreditCardDetail F ON F.AccountEntityId=A.AccountEntityId
										AND F.EffectiveFromTimeKey<=@TimeKey And F.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN Curdat.ADVFACCCDETAIL G ON G.AccountEntityId=A.AccountEntityId
										AND G.EffectiveFromTimeKey<=@TimeKey And G.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN Curdat.AdvFacDLDetail H ON H.AccountEntityId=A.AccountEntityId
										AND H.EffectiveFromTimeKey<=@TimeKey And H.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN DimProduct I ON I.ProductAlt_Key=A.ProductAlt_Key
										AND I.EffectiveFromTimeKey<=@TimeKey And I.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN DimAssetClass J ON J.AssetClassAlt_Key=B.AssetClassAlt_Key
										AND J.EffectiveFromTimeKey<=@TimeKey And j.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN DimSubSector k ON k.SubSectorAlt_Key=A.SubSectorAlt_Key
										AND K.EffectiveFromTimeKey<=@TimeKey And K.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN DimActivity l ON l.ActivityAlt_Key=A.ActivityAlt_Key
										AND l.EffectiveFromTimeKey<=@TimeKey And l.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN Curdat.AdvAcRestructureDetail M ON M.AccountEntityId=A.AccountEntityId
										AND M.EffectiveFromTimeKey<=@TimeKey And M.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN ExceptionFinalStatusType AD ON A.CustomerACID=AD.ACID  --Sachin
										AND AD.EffectiveFromTimeKey<=@TimeKey And AD.EffectiveToTimeKey>=@TimeKey
										--LEFT JOIN IBPCFinalPoolDetail IB ON A.CustomerACID=IB.AccountID  --Sachin
										--AND IB.EffectiveFromTimeKey<=@TimeKey And IB.EffectiveToTimeKey>=@TimeKey
										--LEFT JOIN SecuritizedFinalACDetail SF ON A.CustomerACID=SF.AccountID  --Sachin
										--AND SF.EffectiveFromTimeKey<=@TimeKey And SF.EffectiveToTimeKey>=@TimeKey
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'Fraud' SplFlag from CurDat.AdvAcOtherDetail 

										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%Fraud%') N ON N.AccountEntityId=A.AccountEntityId
										--AND N.EffectiveFromTimeKey<=@TimeKey And N.EffectiveToTimeKey>=@TimeKey AND N.SplFlag like '%Fraud%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'IBPC' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%IBPC%') O ON O.AccountEntityId=A.AccountEntityId
										----AND O.EffectiveFromTimeKey<=@TimeKey And O.EffectiveToTimeKey>=@TimeKey AND O.SplFlag like '%IBPC%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'Securitised' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%Securitised%') P ON P.AccountEntityId=A.AccountEntityId
										----AND P.EffectiveFromTimeKey<=@TimeKey And P.EffectiveToTimeKey>=@TimeKey AND P.SplFlag like '%Securitised%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'Ab-Initio' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%Ab-Initio%') Q ON Q.AccountEntityId=A.AccountEntityId
										----AND Q.EffectiveFromTimeKey<=@TimeKey And Q.EffectiveToTimeKey>=@TimeKey AND Q.SplFlag like '%Ab-Initio%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'PUI' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%PUI%') R ON R.AccountEntityId=A.AccountEntityId
										--AND R.EffectiveFromTimeKey<=@TimeKey And R.EffectiveToTimeKey>=@TimeKey AND R.SplFlag like '%PUI%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'NonCooperative' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%NonCooperative%') S ON S.AccountEntityId=A.AccountEntityId
										----AND S.EffectiveFromTimeKey<=@TimeKey And S.EffectiveToTimeKey>=@TimeKey AND S.SplFlag like '%NonCooperative%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'Repossed' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%Repossed%') T ON T.AccountEntityId=A.AccountEntityId
										----AND T.EffectiveFromTimeKey<=@TimeKey And T.EffectiveToTimeKey>=@TimeKey AND T.SplFlag like '%Repossed%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'Sarfaesi' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%Sarfaesi%') U ON U.AccountEntityId=A.AccountEntityId
										----AND U.EffectiveFromTimeKey<=@TimeKey And U.EffectiveToTimeKey>=@TimeKey AND U.SplFlag like '%Sarfaesi%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'WeakAccount' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%WeakAccount%') V ON V.AccountEntityId=A.AccountEntityId
										----AND V.EffectiveFromTimeKey<=@TimeKey And V.EffectiveToTimeKey>=@TimeKey AND V.SplFlag like '%WeakAccount%' 
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'RC-Pending' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%RC-Pending%') W ON W.AccountEntityId=A.AccountEntityId
										--LEFT JOIN (Select AccountEntityId,RefSystemAcId,'RFA' SplFlag from CurDat.AdvAcOtherDetail 
										--where EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@TimeKey
										--	And SplFlag like '%RFA%') RF ON RF.AccountEntityId=A.AccountEntityId
										--AND W.EffectiveFromTimeKey<=@TimeKey And W.EffectiveToTimeKey>=@TimeKey AND W.SplFlag like '%RC-Pending%' 
										left join AdvAcPUIDetailMain pui on pui.AccountEntityId=a.AccountEntityId
										and pui.EffectiveFromTimeKey<=@TimeKey and pui.EffectiveToTimeKey>=@TimeKey
										LEFT JOIN PRO.ACCOUNTCAL AC ON AC.AccountEntityId=A.AccountEntityId
										AND AC.EffectiveFromTimeKey<=@TimeKey And AC.EffectiveToTimeKey>=@TimeKey
										 left join  (select  CustomerID,ACID,StatusType,StatusDate from  ExceptionFinalStatusType
														where StatusType='Fraud Committed'
														And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) EFST
														 on   a.CustomerACID=EFST.ACID
										 left join (select  CustomerID,ACID,StatusType,StatusDate,Amount from  ExceptionFinalStatusType
													where StatusType='TWO'
												    And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) EFST_T
													on   a.CustomerACID=EFST_T.ACID
										left join (select  * from  Fraud_Details
													where RFA_DateReportingByBank is not null
												    And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) RFA
													on   a.CustomerACID=RFA.RefCustomerACID
										LEFT JOIN PRO.AccountCal_Hist ACH ON ACH.AccountEntityId=A.AccountEntityId
										AND ACH.EffectiveFromTimeKey<=@TimeKey And ACH.EffectiveToTimeKey>=@TimeKey

										Where A.EffectiveFromTimeKey<=@TimeKey And A.EffectiveToTimeKey>=@TimeKey
										AND A.AccountEntityId=@AccountEntityId
										AND A.FacilityType=@FacilityType
										AND A.CustomerEntityId=@CustomerEntityId
										AND A.BranchCode=@BranchCode

								END
				
END
GO
