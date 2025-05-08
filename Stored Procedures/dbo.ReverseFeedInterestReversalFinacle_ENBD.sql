SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Proc [dbo].[ReverseFeedInterestReversalFinacle_ENBD]

as 
Begin



Declare @TimeKey AS INT =(Select TimeKey from Automate_Advances where EXT_FLG='Y')

Declare @Date AS Date =(Select Date from Automate_Advances where EXT_FLG='Y')

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReverseFeedInterestReversal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID


select 
@Date [Date of Data]
,DB.SourceName as [Source System]
,B.RefCustomerID [Customer ID]
,CustomerACID [Account ID]
,D.ProductCode [Scheme Code]
,CurrencyCode [Currency Code]
,b.BranchCode [SOL-ID]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestSuspenseNormal ='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestSuspenseNormal as varchar(max))) end [Dr - GL - Interest Suspense Normal]
 --(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestSuspenseNormal as varchar(max))) [Dr - GL - Interest Suspense Normal]
,ISNULL(Y.UnAppliedIntAmount,0) [Interest Suspense Normal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestReceivableNormal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestReceivableNormal as varchar(max)))end [CR- GL  - Interest Receivable Normal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestReceivableNormal as varchar(max))) [CR- GL  - Interest Receivable Normal]
,ISNULL(Y.UnAppliedIntAmount,0) [Interest Receivable Normal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestIncomeNormal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestIncomeNormal as varchar(max)))end [Dr - GL - Interest Income Normal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestIncomeNormal as varchar(max))) [Dr - GL - Interest Income Normal]
,(CASE WHEN b.FacilityType in ('TL','DL') THEN ISNULL(Y.Overdueinterest,0) ELSE ISNULL(Y.Interest_due,0) END)[Interest Income Normal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.suspendedinterestnormal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.suspendedinterestnormal as varchar(max))) end[Cr - GL -Suspended Interest Normal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.suspendedinterestnormal as varchar(max))) [Cr - GL -Suspended Interest Normal]
,(CASE WHEN b.FacilityType in ('TL','DL') THEN ISNULL(Y.Overdueinterest,0) ELSE ISNULL(Y.Interest_due,0) END) [Suspended Interest Normal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestSuspensePenal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestSuspensePenal as varchar(max)))end [Dr - GL -Interest Suspense Penal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestSuspensePenal as varchar(max))) [Dr - GL -Interest Suspense Penal]
,ISNULL(Y.PenalUnAppliedIntAmount,0) [Interest Suspense Penal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestReceivablePenal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestReceivablePenal as varchar(max)))end [Cr - GL -Interest Receivable Penal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestReceivablePenal as varchar(max))) [Cr - GL -Interest Receivable Penal]
,ISNULL(Y.PenalUnAppliedIntAmount,0) [Interest Receivable Penal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.InterestIncomePenal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestIncomePenal as varchar(max))) end [Dr - GL - Interest Income Penal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.InterestIncomePenal as varchar(max))) [Dr - GL - Interest Income Penal]
,(CASE WHEN b.FacilityType in ('TL','DL') THEN ISNULL(Y.PenalOverdueinterest,0) ELSE ISNULL(Y.penal_due,0) END) [Interest Income Penal Amount]
,case when b.Branchcode='' or Currency2digitcode='' or au.suspendedinterestpenal='' then  '' else
(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.suspendedinterestpenal as varchar(max)))end [Cr - GL -Suspended Interest Penal]
--,(cast(b.Branchcode as varchar(max)) + cast(Currency2digitcode as varchar(max)) + cast(au.suspendedinterestpenal as varchar(max))) [Cr - GL -Suspended Interest Penal]
,(CASE WHEN b.FacilityType in ('TL','DL') THEN ISNULL(Y.PenalOverdueinterest,0) ELSE ISNULL(Y.penal_due,0) END) [Suspended Interest Penal Amount]
,'' [FREE_TEXT_1]
,'' [FREE_TEXT_2]
,'' [FREE_TEXT_3]
from			Pro.accountCal B 
LEFT JOIN		AdvacOtherFinancialDetail Y  ON B.AccountEntityID = Y.AccountEntityId and Y.EffectiveFromTimeKey <=@TimeKey and Y.EffectiveToTimeKey >=@TimeKey
LEFT JOIN		DimProduct D ON B.ProductAlt_Key = D.ProductAlt_Key	 and D.EffectiveToTimekey = 49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassName END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
				And				C.SourceAlt_Key=D.SourceAlt_Key
				And				C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassName END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) E ON  E.AssetClassAlt_Key=B.InitialAssetClassAlt_Key 
				And				C.SourceAlt_Key=D.SourceAlt_Key
				And				C.EffectiveToTimeKey=49999
 Inner Join		Pro.CUSTOMERCAL PC ON PC.RefCustomerID=B.RefCustomerID
 left join		(select distinct ProductCode,InterestSuspenseNormal,InterestReceivableNormal,InterestIncomeNormal,SuspendedInterestNormal,InterestSuspensePenal,InterestReceivablePenal,InterestIncomePenal,SuspendedInterestPenal,EffectiveFromTimeKey,EffectiveToTimeKey from DimGLProduct_AU) au on b.ProductCode = au.ProductCode and au.EffectiveToTimeKey = 49999
 left join		DimCurrency CY ON B.CurrencyAlt_Key = CY.CurrencyAlt_Key and CY.EffectiveToTimekey = 49999
 left join		DIMSOURCEDB DB ON B.SourceAlt_Key = DB.SourceAlt_Key and DB.EffectiveToTimekey = 49999
 where			B.SourceAlt_Key = 1 
and				B.EffectiveFromTimeKey <=@TimeKey and B.EffectiveToTimeKey >=@TimeKey
AND				B.InitialAssetClassAlt_Key = 1 
and B.FinalAssetClassAlt_Key > 1 
and				(	ISNULL(Y.UnAppliedIntAmount,0) > 0 
				OR	ISNULL(Y.Overdueinterest,0) > 0 
				OR  ISNULL(Y.PenalUnAppliedIntAmount,0) > 0 
				OR  ISNULL(Y.PenalOverdueinterest,0) > 0 
				OR	ISNULL(Y.Interest_due,0) > 0 
				OR	ISNULL(Y.penal_due,0) > 0
				)

 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedInterestReversal'
 
 End
 
GO
