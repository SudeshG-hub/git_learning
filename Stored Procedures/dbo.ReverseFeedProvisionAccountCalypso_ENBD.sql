SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ReverseFeedProvisionAccountCalypso_ENBD]


AS

Begin



Declare @TIMEKEY as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

Declare @PrevTimekey as Int =(Select Timekey-1 from Automate_Advances where ext_flg='Y')
Declare @Date as Date =(Select Date from Automate_Advances where ext_flg='Y')

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReverseFeedProvisionAccountCalypso','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID

Select Distinct		@Date as Date_of_Data,
					'Calypso' SOURCE_SYSTEM,
					x.UcifId as [CIF ID],
					A.RefIssuerID IssuerID,
					ISNULL(A.ISIN,'') ISIN,
					A.RefInvID  InvID,
					'' as DERIVATIVE_REF_NO,
					B.BranchCode as [SOL_ID]
					,InstrName as SCHM_CODE
					,CurrencyCode as [Currency Code]
					,ISNULL(A.TotalProvison,0) as TOT_PROVISION
					,ISNULL(I.TotalProvison,0) as TOTAL_PROV_PREV
					,(CASE WHEN ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) END)INCR_TOTAL_PROV
					,(CASE WHEN ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) END)DECR_TOTAL_PROV					
from			InvestmentFinancialDetail A
INNER JOIN		InvestmentBasicDetail B ON A.InvEntityId = B.InvEntityId
inner join		InvestmentiSSUERDetail X ON B.IssuerEntityId = x.IssuerEntityId 
and				x.EffectiveFromTimeKey <=@TimeKey and X.EffectiveToTimeKey >=@TimeKey
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassName END)								SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) C ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
And				C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassName END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) E ON  E.AssetClassAlt_Key=A.InitialAssetAlt_Key 
And				C.EffectiveToTimeKey=49999 
LEFT JOIN		InvestmentFinancialDetail I 
ON				A.InvEntityId = I.InvEntityId 
and				I.EffectiveFromTimeKey <= @PrevTimekey and I.EffectiveToTimeKey >= @PrevTimekey
LEFT JOIN		DimCurrency CY ON A.CurrencyAlt_Key = CY.CurrencyAlt_Key and CY.EffectiveToTimeKey = 49999
where			
				--(	(A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1) 
				--	OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key = 1) 
				--	OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key > 1 and (A.InitialAssetAlt_Key != A.FinalAssetClassAlt_Key))
				--)	AND
				A.EffectiveFromTimeKey <=@TimeKey and A.EffectiveToTimeKey >=@TimeKey
AND				B.EffectiveFromTimeKey <=@TimeKey and B.EffectiveToTimeKey >=@TimeKey
AND				((CASE WHEN ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) END) ) > 0 
				OR ((CASE WHEN ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) END) ) > 0 

UNION

Select Distinct		@Date as Date_of_Data,
					'Calypso' SOURCE_SYSTEM,
					A.UCIC_ID [CIF ID],
					'' IssuerID,
					'' ISIN,
					''  InvID,
					A.DerivativeRefNo as DERIVATIVE_REF_NO,
					A.BranchCode as [SOL_ID]
					,A.InstrumentName as SCHM_CODE
					,'INR' as [Currency Code]
					,cast(ISNULL(A.TotalProvison,0) as varchar(max)) as TOT_PROVISION
					,cast(ISNULL(I.TotalProvison,0) as varchar(max)) as TOTAL_PROV_PREV
					,cast((CASE WHEN ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) END)   as varchar(max))INCR_TOTAL_PROV
					,cast((CASE WHEN ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) END)   as varchar(max))DECR_TOTAL_PROV	
from			curdat.DerivativeDetail A
LEFT JOIN		curdat.DerivativeDetail I ON A.DerivativeRefNo = I.DerivativeRefNo and I.EffectiveFromTimeKey <= @PrevTimekey and I.EffectiveToTimeKey >= @PrevTimekey
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  C ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
And				C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  E ON  E.AssetClassAlt_Key=A.InitialAssetAlt_Key 
And				C.EffectiveToTimeKey=49999 
WHERE			
				--(	(A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1) 
				--	OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key = 1) 
				--	OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key > 1 and (A.InitialAssetAlt_Key != A.FinalAssetClassAlt_Key))
				--)	AND
				A.EffectiveFromTimeKey <=@TimeKey and A.EffectiveToTimeKey >=@TimeKey
AND				((CASE WHEN ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(A.TotalProvison,0)-ISNULL(I.TotalProvison,0) END) ) > 0 
				OR ((CASE WHEN ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) < 0 THEN 0 ELSE ISNULL(I.TotalProvison,0)-ISNULL(A.TotalProvison,0) END) ) > 0 


-------------------------
 
 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedProvisionAccountCalypso'

 
 End



GO
