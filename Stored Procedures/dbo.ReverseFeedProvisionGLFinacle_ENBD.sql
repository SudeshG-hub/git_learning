SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[ReverseFeedProvisionGLFinacle_ENBD]

AS 

Declare @TIMEKEY as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

Declare @PrevTimekey as Int =(Select Timekey-1 from Automate_Advances where ext_flg='Y')
Declare @Date as Date =(Select Date from Automate_Advances where ext_flg='Y')

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReverseFeedProvisionGL_ENBD','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID

--TRUNCATE TABLE  [dbo].[ReversefeedProvisionGL]

--INSERT into [dbo].[ReversefeedProvisionGL]
Select 
@Date [Date of Data]
,DB.SourceName [Source System]
,B.BranchCode [SOL ID]
,E.CurrencyCode [Currency Code]
,D.ProductCode [SCHM_CODE]
,ISNULL(AU.Prov_Dr_GL,'') [Dr. Prov GL Code]
,ISNULL(AU.Prov_Cr_GL,'') [Cr. Prov GL Code]
,sum(ISNULL(B.TotalProvision,0))[Total Provision as on month end]
,sum(ISNULL(C.TotalProvision,0)) [Total Provision of previous month] 
,(CASE WHEN sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) END)[Incremental Provision]
,(CASE WHEN sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) END) [Decremental Provision]
,F.OfficeGL_AccountNumber  [Provision Credit Office Account]
,H.OfficeGL_AccountNumber  [Provision Debit Office Account]
 from	 Pro.ACCOUNTCAL B		
 LEFT JOIN	Pro.AccountCal_Hist C	ON B.CustomerAcID = C.CustomerAcID 
 and		C.EffectiveFromTimeKey <= @PrevTimekey 
 and  C.EffectiveToTimeKey >= @PrevTimekey
 LEFT JOIN	DimProduct D			ON B.ProductAlt_Key = D.ProductAlt_Key	
 left join DimCurrency E			ON B.CurrencyAlt_Key = E.CurrencyAlt_Key
 left join		(select distinct ProductCode,InterestSuspenseNormal,InterestReceivableNormal,InterestIncomeNormal,SuspendedInterestNormal,InterestSuspensePenal,InterestReceivablePenal,InterestIncomePenal,SuspendedInterestPenal,Prov_CR_GL,Prov_DR_GL,EffectiveFromTimeKey,EffectiveToTimeKey from DimGLProduct_AU) au	on b.ProductCode = au.ProductCode and au.EffectiveToTimeKey = 49999	
 left join	DimSourceDB DB ON B.SourceAlt_Key = DB.SourceAlt_Key and DB.EffectiveTotimekey = 49999
 LEFT JOIN DimSubGLBACIDMapping F ON AU.PROV_CR_GL = F.OfficeGL_BACID and F.CurrencyCode = E.CurrencyCode and F.EffectiveFromTimeKey <= @TIMEKEY and F.EffectiveToTimeKey >= @Timekey
 LEFT JOIN DimSubGLBACIDMapping H ON au.PROV_DR_GL = H.OfficeGL_BACID and H.CurrencyCode = E.CurrencyCode and F.EffectiveFromTimeKey <= @TIMEKEY and F.EffectiveToTimeKey >= @Timekey 
 where B.SourceAlt_Key=1
 and B.EffectiveFromTimeKey<=@TIMEKEY 
 and B.EffectiveToTimeKey >=@TIMEKEY
--AND				(	(B.InitialAssetClassAlt_Key = 1 and B.FinalAssetClassAlt_Key > 1) 
--					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key = 1) 
--					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key > 1 and (B.InitialAssetClassAlt_Key != B.FinalAssetClassAlt_Key OR B.InitialNpaDt != B.FinalNpaDt))
--				)
 group by 
 b.Branchcode,
 Currency2digitcode
,DB.SourceName
,B.BranchCode
,D.ProductCode
,E.CurrencyCode
,AU.Prov_Dr_GL
,AU.Prov_Cr_GL
,F.OfficeGL_AccountNumber
,H.OfficeGL_AccountNumber
having ((CASE WHEN sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) END) > 0 OR
(CASE WHEN sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) END) > 0 )

-------------------------
 
 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedProvisionGL_ENBD'

GO
