SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[ReverseFeedProvisionGLFinacle_ENBD_bkup]

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
dateofdata [Date of Data]
,SourceSystemName[Source System]
,A.BranchCode [SOL ID]
,E.CurrencyCode [Currency Code]
,D.ProductCode [SCHM_CODE]
,ISNULL(AU.Prov_Dr_GL,'') [Dr. Prov GL Code]
,ISNULL(AU.Prov_Cr_GL,'') [Cr. Prov GL Code]
,sum(ISNULL(B.TotalProvision,0))[Total Provision as on month end]
,sum(ISNULL(C.TotalProvision,0)) [Total Provision of previous month] 
,(CASE WHEN sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) END)[Incremental Provision]
,(CASE WHEN sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) END) [Decremental Provision]
,ISNULL((cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.Prov_Cr_GL as varchar(max))),'')  [Provision Credit Office Account]
,ISNULL((cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.Prov_Dr_GL as varchar(max))),'')  [Provision Debit Office Account]
 from		ReverseFeedData A
 LEFT JOIN Pro.ACCOUNTCAL B		ON A.AccountID = B.CustomerAcID 
 LEFT JOIN	Pro.AccountCal_Hist C	ON A.AccountID = C.CustomerAcID 
 and		C.EffectiveFromTimeKey <= @PrevTimekey 
 and  C.EffectiveToTimeKey >= @PrevTimekey
 LEFT JOIN	DimProduct D			ON B.ProductAlt_Key = D.ProductAlt_Key	
 left join DimCurrency E			ON B.CurrencyAlt_Key = E.CurrencyAlt_Key
 left join		dimglproduct_au au	on b.ProductCode = au.ProductCode and au.EffectiveToTimeKey = 49999	
 where A.SourceAlt_Key=1
 and A.EffectiveFromTimeKey<=@TIMEKEY 
 and A.EffectiveToTimeKey >=@TIMEKEY
 AND B.FInalassetclassAlt_Key > 1
 
 group by 
 b.Branchcode,
 Currency2digitcode,
 DateofData
,SourceSystemName
,A.BranchCode
,D.ProductCode
,E.CurrencyCode
,AU.Prov_Dr_GL
,AU.Prov_Cr_GL

having ((CASE WHEN sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(B.TotalProvision,0))-sum(ISNULL(C.TotalProvision,0)) END) > 0 OR
(CASE WHEN sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) < 0 THEN 0 ELSE sum(ISNULL(C.TotalProvision,0))-sum(ISNULL(B.TotalProvision,0)) END) > 0 )

-------------------------
 
 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedProvisionGL_ENBD'
GO
