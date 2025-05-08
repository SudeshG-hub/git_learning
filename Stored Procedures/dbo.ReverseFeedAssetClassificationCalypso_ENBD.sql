SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Proc [dbo].[ReverseFeedAssetClassificationCalypso_ENBD]

as 
Begin



Declare @TimeKey AS INT =(Select TimeKey from Automate_Advances where EXT_FLG='Y')

Declare @Date AS Date =(Select Date from Automate_Advances where EXT_FLG='Y')

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReversefeedAssetClassificationCalypso','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID


Select Distinct		@Date as DateofData,
					'Calypso' SOURCE_SYSTEM,
					X.UcifId as [CIF ID],
					A.RefIssuerID IssuerID,
					A.ISIN ISIN,
					A.RefInvID  Inv_ID,
					(CASE WHEN ISNULL(A.InitialAssetAlt_Key,1) = 1 THEN '001'  ELSE '002' END) CURR_ASST_MAIN_CLS,
					E.SrcSysClassName as CURR_ASST_SUB_CLS
					,(CASE WHEN ISNULL(A.FinalAssetClassAlt_Key,1) = 1 THEN '001' ELSE '002' END)  REV_ASST_MAIN_CLS
					,C.SrcSysClassName REV_ASST_SUB_CLS
					,A.NPIDt as [NPI Date]
					,B.BranchCode as [Branch ID]
					,DBTDate as DBTDT
					,(CASE WHEN A.FinalAssetClassAlt_Key > 1 THEN isnull(A.DegReason,'') END) FREE_TEXT_1
				,'' FREE_TEXT_2
				,'' FREE_TEXT_3
from				InvestmentFinancialDetail A
INNER JOIN			InvestmentBasicDetail B ON A.InvEntityId = B.InvEntityId
INNER JOIN			InvestmentIssuerDetail X on X.IssuerEntityId = B.IssuerEntityId
LEFT Join			(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  C ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
And					C.EffectiveToTimeKey=49999
LEFT Join			(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping)  E ON  E.AssetClassAlt_Key=ISNULL(A.InitialAssetAlt_Key,1)
And					C.EffectiveToTimeKey=49999 
where				A.EffectiveFromTimeKey <=@TimeKey and A.EffectiveToTimeKey >=@TimeKey
AND					B.EffectiveFromTimeKey <=@TimeKey and B.EffectiveToTimeKey >=@TimeKey
AND					X.EffectiveFromTimeKey <=@TimeKey and X.EffectiveToTimeKey >=@TimeKey
AND				(	(A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1) 
					OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key = 1) 
					OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key > 1 and (A.InitialAssetAlt_Key != A.FinalAssetClassAlt_Key))
				)



 UNION ALL


Select Distinct		@Date as DateofData,
					'Calypso' SOURCE_SYSTEM,
					A.UCIC_ID as [CIF ID],
					'' IssuerID,
					'' ISIN,
					''  Inv_ID,
					(CASE WHEN ISNULL(A.InitialAssetAlt_Key,1) = 1 THEN '001'  ELSE '002' END) CURR_ASST_MAIN_CLS,
					E.SrcSysClassName as CURR_ASST_SUB_CLS
					,(CASE WHEN ISNULL(A.FinalAssetClassAlt_Key,1) = 1 THEN '001' ELSE '002' END)  REV_ASST_MAIN_CLS
					,C.SrcSysClassName REV_ASST_SUB_CLS
					,A.NPIDt as [NPI Date]
					,A.BranchCode as [Branch ID]
					,DBTDate as DBTDT
					,(CASE WHEN A.FinalAssetClassAlt_Key > 1 THEN isnull(A.DegReason,'') END) FREE_TEXT_1
				,'' FREE_TEXT_2
				,'' FREE_TEXT_3
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
AND				(	(A.InitialAssetAlt_Key = 1 and A.FinalAssetClassAlt_Key > 1) 
					OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key = 1) 
					OR (A.InitialAssetAlt_Key > 1 and A.FinalAssetClassAlt_Key > 1 and (A.InitialAssetAlt_Key != A.FinalAssetClassAlt_Key))
				)


 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReversefeedAssetClassificationCalypso'
 
 End
GO
