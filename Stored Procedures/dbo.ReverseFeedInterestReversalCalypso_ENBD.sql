SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[ReverseFeedInterestReversalCalypso_ENBD]


AS

Begin




Declare @TIMEKEY as Int =(Select Timekey from Automate_Advances where ext_flg='Y')

Declare @PrevTimekey as Int =(Select Timekey-1 from Automate_Advances where ext_flg='Y')
Declare @Date as Date =(Select Date from Automate_Advances where ext_flg='Y')




DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReverseFeedProvisionAccountCalypso','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID

Select Distinct		
					@Date as [Date of Data]
					,'Calypso' as [Source System]					
					,X.IssuerID as [ISSUER_ID]	
					,UcifId as [CIF ID]				
					,IssuerName as [ISSUER_NAME]
					,A.RefInvID [InvID]
					,ISNULL(A.ISIN,'') [ISIN]
					,'' as [DERIVATIVE_REF_NO]
					,NPIDt [NPI_DATE]
					,C.SrcSysClassName [NPI_CLASSIFICATION]
					,CurrencyCode as [Currency Code]
					,REPLACE(ISNULL(Interest_DividendDueDate,''),'1900-01-01','') as  [ACC_DATE]
					,ISNULL(Interest_DividendDueAmount,0.00)  as [ACC_AMOUNT]
					,0.00 [MTM Income Amount]
					,0.00 [Overdue Coupon Amount]	
					,'' [FREE_TEXT_1]
					,'' [FREE_TEXT_2]
					,'' [FREE_TEXT_3]					
from				InvestmentFinancialDetail A
INNER JOIN			InvestmentBasicDetail B ON A.InvEntityId = B.InvEntityId
INNER JOIN			InvestmentIssuerDetail X on X.IssuerEntityId = B.IssuerEntityId
LEFT Join			(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)	SrcSysClassName ,
								EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  C ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
And					C.EffectiveToTimeKey=49999
LEFT Join			(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)	SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  E ON  E.AssetClassAlt_Key=A.InitialAssetAlt_Key 
And					C.EffectiveToTimeKey=49999 

LEFT JOIN		DimCurrency CY ON A.CurrencyAlt_Key = CY.CurrencyAlt_Key and CY.EffectiveToTimeKey = 49999
where				A.EffectiveFromTimeKey <=@TimeKey and A.EffectiveToTimeKey >=@TimeKey
AND					B.EffectiveFromTimeKey <=@TimeKey and B.EffectiveToTimeKey >=@TimeKey
AND					X.EffectiveFromTimeKey <=@TimeKey and X.EffectiveToTimeKey >=@TimeKey
AND				A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1 


UNION


Select Distinct		
					@Date as [Date of Data]
					,'Calypso' as [Source System]					
					,'' as [ISSUER_ID]	
					,A.UCIC_ID as [CIF ID]				
					,'' as [ISSUER_NAME]
					,'' [InvID]
					,'' [ISIN]
					,DerivativeRefNo as [DERIVATIVE_REF_NO]
					,A.NPIDt [NPI_DATE]
					,C.SrcSysClassName [NPI_CLASSIFICATION]
					,'INR' as [Currency Code]
					,'' [ACC_DATE]
					,0.00 [ACC_AMOUNT]
					,ISNULL((case when MTMIncomeAmt < 0 then 0 else MTMIncomeAmt end),0.00) [MTM Income Amount]
					,ISNULL(OverdueCouponAmt,0.00) [Overdue Coupon Amount]	
					,'' [FREE_TEXT_1]
					,'' [FREE_TEXT_2]
					,'' [FREE_TEXT_3]
from			curdat.DerivativeDetail A
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  C ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
And				C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  E ON  E.AssetClassAlt_Key=A.InitialAssetAlt_Key 
And				C.EffectiveToTimeKey=49999 
where			A.EffectiveFromTimeKey <=@TimeKey and A.EffectiveToTimeKey >=@TimeKey
AND				A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1 


-------------------------
 
 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReverseFeedProvisionAccountCalypso'

 
 End

GO
