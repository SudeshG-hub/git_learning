SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE Proc [dbo].[ReverseFeedAssetClassificationFinacle_ENBD]

as 
Begin

Declare @TimeKey AS INT =(Select TimeKey from Automate_Advances where EXT_FLG='Y')

Declare @Date AS Date =(Select Date from Automate_Advances where EXT_FLG='Y')

DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 
FROM [PRO].[ReverseFeed_ProcessMonitor] WHERE TIMEKEY=@TIMEKEY)

INSERT INTO PRO.ReverseFeed_ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)
SELECT ORIGINAL_LOGIN(),'ReversefeedAssetClassificationFinacle','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID




Select Distinct
				A.DateofData [Date of Data],
				SourceSystemName [Source System],
				A.CustomerID [Customer ID],
				AccountID [Account ID],
				'IN' [Bank ID],
				A.BranchCode SOL_ID,
				(CASE WHEN ISNULL(B.InitialAssetClassAlt_Key,1) = 1 THEN '001'  ELSE '002' END) [Current Asset Class Code],
				E.SrcSysClassName as [Current Sub - Asset Class Code]
				,(CASE WHEN ISNULL(B.FinalAssetClassAlt_Key,1) = 1 THEN '001' ELSE '002' END)  [Revised Main Asset Class Code]
				,C.SrcSysClassName [Revised Sub Asset Class Code]
				,A.NPADate [NPA Date]
				,A.DPD DPD
				,(CASE WHEN B.FinalAssetClassAlt_Key > 1 THEN REPLACE(isnull(B.NPA_Reason,B.DegReason),',','') END) FREE_TEXT_1
				,'' FREE_TEXT_2
				,'' FREE_TEXT_3
from			ReverseFeedData A
Inner Join		Pro.accountCal B ON A.AccountID=B.CustomerAcid
Left Join		DimProduct D On B.ProductAlt_Key=D.ProductAlt_Key And D.EffectiveToTimeKey=49999
left Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
				 EffectiveFromTimeKey,EffectiveToTimeKey
				 from DimAssetClassMapping) C ON C.AssetClassAlt_Key=B.FinalAssetClassAlt_Key 
And				C.SourceAlt_Key=D.SourceAlt_Key
And				C.EffectiveToTimeKey=49999
LEFT Join		(select Distinct SourceAlt_Key,AssetClassAlt_Key,(CASE WHEN AssetClassAlt_Key = 1 THEN 'STD' ELSE SrcSysClassCode END)SrcSysClassName ,
					EffectiveFromTimeKey,EffectiveToTimeKey
					from DimAssetClassMapping) E 
ON				E.AssetClassAlt_Key=B.InitialAssetClassAlt_Key 
And				C.SourceAlt_Key=D.SourceAlt_Key
And				C.EffectiveToTimeKey=49999
Inner Join		Pro.CUSTOMERCAL PC ON PC.RefCustomerID=B.RefCustomerID
where			A.SourceAlt_Key = 1 
and				a.EffectiveFromTimeKey <=@TimeKey and a.EffectiveToTimeKey >=@TimeKey
AND				(	(B.InitialAssetClassAlt_Key = 1 and B.FinalAssetClassAlt_Key > 1) 
					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key = 1) 
					OR (B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key > 1 and (B.InitialAssetClassAlt_Key != B.FinalAssetClassAlt_Key OR B.InitialNpaDt != B.FinalNpaDt))
				)
 UNION

 
 

Select Distinct
				@Date [Date of Data],
				E.SourceName [Source System],
				B.RefCustomerID [Customer ID],
				CustomerAcID [Account ID],
				'IN' [Bank ID],
				B.BranchCode SOL_ID,
				(CASE WHEN ISNULL(DAC.AssetClassMappingAlt_Key,1) <  5 THEN '001'  ELSE '002' END) [Current Asset Class Code],
				DAC.SrcSysClassCode as [Current Sub - Asset Class Code]
				,(CASE WHEN ISNULL(B.FinalAssetClassAlt_Key,1) = 1 THEN '001' ELSE '002' END)  [Revised Main Asset Class Code]
				,(CASE WHEN SMA_Class = 'SMA_0' then 'SMA0'
				WHEN SMA_Class = 'SMA_1' then 'SMA1'
				WHEN SMA_Class = 'SMA_2' then 'SMA2' ELSE SMA_Class END) [Revised Sub Asset Class Code]
				,B.FinalNPADt [NPA Date]
				,B.DPD_Max DPD
				,(CASE WHEN  B.FlgSMA = 'Y' THEN isnull(B.SMA_Reason,'') END) FREE_TEXT_1
				,'' FREE_TEXT_2
				,'' FREE_TEXT_3
from			Pro.accountCal B 
Left Join		DimProduct D On B.ProductAlt_Key=D.ProductAlt_Key And D.EffectiveToTimeKey=49999
Inner Join		Pro.CUSTOMERCAL PC ON PC.RefCustomerID=B.RefCustomerID
LEFT JOIN		DimAssetClassMapping DAC ON B.BankAssetClass = DAC.AssetClassMappingAlt_Key 
and				DAC.EffectiveToTimeKey = 49999
left join		DimSourceDB E ON B.SourceAlt_Key = E.SourceAlt_Key
where			E.SourceAlt_Key = 1 
and				B.EffectiveFromTimeKey <=@TimeKey and B.EffectiveToTimeKey >=@TimeKey
ANd				(B.FinalAssetClassAlt_Key = 1 
and				REPLACE(SMA_CLASS,'_','')!= DAC.SrcSysClassCode)

 UPDATE PRO.ReverseFeed_ProcessMonitor SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.ReverseFeed_ProcessMonitor')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='ReversefeedAssetClassificationFinacle'
 
 End

GO
