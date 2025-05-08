SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ReverseFeedProvisionAccountFinacle_ENBD]


AS

Begin




Declare @TIMEKEY as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

Declare @PrevTimekey as Int =(Select Timekey-1 from Automate_Advances where ext_flg='Y')
Declare @Date as Date =(Select Date from Automate_Advances where ext_flg='Y')
Declare @LastMonthDate as Date =(select EOMONTH(@Date,1))
Declare @LastMonthTimekey int = (select Timekey from Automate_Advances where Date = @LastMonthDate)

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReverseFeedProvisionAccountFinacle','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID


Select 
 @Date [Date of Data]
,DB.SourceName [Source System]
,B.RefCustomerID [Customer ID]
,B.CustomerACID [CustomerAcID]
,GL.GLCode  [Account_GL_Code]
,CY.CurrencyCode [Currency Code]
,DP.ProductCode [Scheme Code]
,B.BranchCode [SOL ID]
,ISNULL(B.TotalProvision,0) [Total Provision as on date] 
,ISNULL(D.TotalProvision,0) [Total Provision as of Last Month]
,ISNULL(C.TotalProvision,0) [Total Provision of previous day]
,(CASE WHEN ISNULL(B.TotalProvision,0)-ISNULL(C.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(B.TotalProvision,0)-ISNULL(C.TotalProvision,0) END) [Daily Incremental Provision]
,(CASE WHEN ISNULL(C.TotalProvision,0)-ISNULL(B.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(C.TotalProvision,0)-ISNULL(B.TotalProvision,0) END) [Daily Decremental Provision]
,(CASE WHEN ISNULL(B.TotalProvision,0)-ISNULL(D.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(B.TotalProvision,0)-ISNULL(D.TotalProvision,0) END) [Monthly  Incremental Provision]
,(CASE WHEN ISNULL(D.TotalProvision,0)-ISNULL(B.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(D.TotalProvision,0)-ISNULL(B.TotalProvision,0) END) [Monthly  Decremental Provision]
,F.OfficeGL_AccountNumber  [Provision Debit Account]
,H.OfficeGL_AccountNumber  [Provision Credit Account]
,Prov_Dr_GL [Provision Account Debit GL]
,Prov_Cr_GL [Provision Account Credit GL]
,'' [FREE_TEXT_1]
,'' [FREE_TEXT_2]
,'' [FREE_TEXT_3]
 from		Pro.ACCOUNTCAL B 
 LEFT join	AdvAcBasicDetail BD ON B.CustomerACID = BD.CustomerACID 
 and		BD.EffectiveFromTimeKey <= @Timekey and BD.EffectiveToTimekey >= @Timekey
 LEFT JOIN	DimGL GL ON BD.GLAlt_Key = GL.GLAlt_Key and GL.EffectiveToTimeKey = 49999
 LEFT JOIN	Pro.AccountCal_Hist C ON B.CustomerAcID = C.CustomerAcID 
 and		C.EffectiveFromTimeKey <= @PrevTimekey and  C.EffectiveToTimeKey >= @PrevTimekey
  LEFT JOIN	Pro.AccountCal_Hist D ON B.CustomerAcID = D.CustomerAcID 
 and		D.EffectiveFromTimeKey <= @LastMonthTimekey and  D.EffectiveToTimeKey >= @LastMonthTimekey
 left join	DimCurrency CY ON B.CurrencyAlt_Key = CY.CurrencyAlt_Key and CY.EffectiveToTimekey = 49999
Left Join	DimProduct DP On B.ProductAlt_Key=DP.ProductAlt_Key And DP.EffectiveToTimeKey=49999
 Left Join	(select distinct ProductCode,InterestSuspenseNormal,InterestReceivableNormal,InterestIncomeNormal,SuspendedInterestNormal,InterestSuspensePenal,
							 InterestReceivablePenal,InterestIncomePenal,SuspendedInterestPenal,Prov_CR_GL,Prov_DR_GL,EffectiveFromTimeKey,EffectiveToTimeKey 
							 from DimGLProduct_AU) DAC ON DP.ProductCode=DAC.ProductCode  And DAC.EffectiveToTimeKey=49999
 LEFT JOIN DimSubGLBACIDMapping F ON DAC.PROV_CR_GL = F.OfficeGL_BACID and F.CurrencyCode = CY.CurrencyCode and F.EffectiveFromTimeKey <= @TIMEKEY and F.EffectiveToTimeKey >= @Timekey
 LEFT JOIN DimSubGLBACIDMapping H ON DAC.PROV_DR_GL = H.OfficeGL_BACID and H.CurrencyCode = CY.CurrencyCode and F.EffectiveFromTimeKey <= @TIMEKEY and F.EffectiveToTimeKey >= @Timekey 
 LEFT JOIN	DimSourceDB DB ON B.SourceAlt_Key = DB.SourceAlt_Key and DB.EffectiveToTimeKey = 49999
 where		B.SourceAlt_Key=1
 and		B.EffectiveFromTimeKey<=@TIMEKEY 
 and		B.EffectiveToTimeKey >=@TIMEKEY
--AND				(	(B.InitialAssetClassAlt_Key = 1 and B.FinalAssetClassAlt_Key > 1) 
--					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key = 1) 
--					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key > 1 and (B.InitialAssetClassAlt_Key != B.FinalAssetClassAlt_Key OR B.InitialNpaDt != B.FinalNpaDt))
--				)
 AND		(
				(CASE WHEN ISNULL(B.TotalProvision,0)-ISNULL(C.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(B.TotalProvision,0)-ISNULL(C.TotalProvision,0) END) > 0
				OR (CASE WHEN ISNULL(C.TotalProvision,0)-ISNULL(B.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(C.TotalProvision,0)-ISNULL(B.TotalProvision,0) END) > 0
				OR (CASE WHEN ISNULL(B.TotalProvision,0)-ISNULL(D.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(B.TotalProvision,0)-ISNULL(D.TotalProvision,0) END) > 0
				OR (CASE WHEN ISNULL(D.TotalProvision,0)-ISNULL(B.TotalProvision,0) < 0 THEN 0 ELSE ISNULL(D.TotalProvision,0)-ISNULL(B.TotalProvision,0) END) > 0
			)
-------------------------
 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedProvisionAccountFinacle'
 
 
 End


 
GO
