SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[ReverseFeedDataInsertENBD] 

AS

BEGIN


Declare @TimeKey AS INT =(Select TimeKey from Automate_Advances where EXT_FLG='Y')

Declare @Date AS Date =(Select Date from Automate_Advances where EXT_FLG='Y')

IF (select count(1) from Pro.CustomerCal_Hist where EffectiveFromTimeKey = @TimeKey) > 0 
and (select count(1) from Pro.AccountCal_Hist where EffectiveFromTimeKey = @TimeKey) > 0 
BEGIN
Delete from ReverseFeedData where EffectiveFromTimekey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey

Insert into ReverseFeedData(DateofData,BranchCode,CustomerID,AccountID,AssetClass,AssetSubClass,NPADate,SourceAlt_Key
,SourceSystemName,EffectiveFromTimeKey,EffectiveToTimeKey,UpgradeDate,UCIF_ID,ProductName,DPD,CustomerName)

Select  @Date as DateofData,A.BranchCode,A.RefCustomerID,A.CustomerACid,A.FinalAssetClassAlt_Key, B.SrcSysClassCode,A.FinalNPADt,A.SourceAlt_Key,C.SourceName,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
,A.UpgDate,A.UCIF_ID,E.ProductName,A.DPD_Max,D.CustomerName
 from Pro.ACCOUNTCAL A
Inner Join DimAssetClass B On A.FinalAssetClassAlt_Key=B.AssetClassAlt_key
And B.EffectiveFromTimekey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
Inner JOIN DIMSOURCEDB C ON A.SourceAlt_Key=C.SourceAlt_key
And C.EffectiveFromTimekey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
Inner JOIN Pro.CustomerCal D ON A.CustomerEntityID=D.CustomerEntityID
Inner Join DimProduct E ON E.ProductAlt_Key=A.ProductAlt_key
And E.EffectiveFromTimekey<=@TimeKey AND E.EffectiveToTimeKey>=@TimeKey
where A.InitialAssetClassAlt_Key=1 AND A.FinalAssetClassAlt_Key>1

UNION ALL

Select  @Date as DateofData,A.BranchCode,A.RefCustomerID,A.CustomerACid,A.FinalAssetClassAlt_Key,B.SrcSysClassCode, A.FinalNPADt,A.SourceAlt_Key,C.SourceName,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
,A.UpgDate,A.UCIF_ID,E.ProductName,A.DPD_Max,D.CustomerName
 from Pro.ACCOUNTCAL A
Inner Join DimAssetClass B On A.FinalAssetClassAlt_Key=B.AssetClassAlt_key
And B.EffectiveFromTimekey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
Inner JOIN DIMSOURCEDB C ON A.SourceAlt_Key=C.SourceAlt_key
And C.EffectiveFromTimekey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
Inner JOIN Pro.CustomerCal D ON A.CustomerEntityID=D.CustomerEntityID
Inner Join DimProduct E ON E.ProductAlt_Key=A.ProductAlt_key
And E.EffectiveFromTimekey<=@TimeKey AND E.EffectiveToTimeKey>=@TimeKey 
where A.InitialAssetClassAlt_Key>1 AND A.FinalAssetClassAlt_Key=1

UNION ALL

Select  @Date as DateofData,A.BranchCode,A.RefCustomerID,A.CustomerACid,A.FinalAssetClassAlt_Key,B.SrcSysClassCode, A.FinalNPADt,A.SourceAlt_Key,C.SourceName,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
,A.UpgDate,A.UCIF_ID,E.ProductName,A.DPD_Max,D.CustomerName
 from Pro.ACCOUNTCAL A
Inner Join DimAssetClass B On A.FinalAssetClassAlt_Key=B.AssetClassAlt_key
And B.EffectiveFromTimekey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
Inner JOIN DIMSOURCEDB C ON A.SourceAlt_Key=C.SourceAlt_key
And C.EffectiveFromTimekey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
Inner JOIN Pro.CustomerCal D ON A.CustomerEntityID=D.CustomerEntityID
Inner Join DimProduct E ON E.ProductAlt_Key=A.ProductAlt_key
And E.EffectiveFromTimekey<=@TimeKey AND E.EffectiveToTimeKey>=@TimeKey 
where A.InitialAssetClassAlt_Key>1 AND A.FinalAssetClassAlt_Key > 1 AND (A.InitialAssetClassAlt_Key<>FinalAssetClassAlt_Key OR A.InitialNpaDt <> A.FinalNpaDt)



-------------------ADDED BY SUDESH 26122021

--update Reversefeeddata set NPADate = DateofData 
--where assetclass = 2 
--and NPADate is NULL and cast(dateofData as date) = @Date


update Reversefeeddata set UpgradeDate = DateofData 
where assetclass = 1
and UpgradeDate is NULL and cast(dateofData as date) = @Date
--UNION ALL

--Select  @Date as DateofData,A.BranchCode,A.RefCustomerID,A.CustomerACid,A.FinalAssetClassAlt_Key,B.SrcSysClassCode, A.FinalNPADt,A.SourceAlt_Key,C.SourceName,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
--,A.UpgDate,A.UCIF_ID,E.ProductName,A.DPD_Max,D.CustomerName
-- from Pro.ACCOUNTCAL A
--Inner Join DimAssetClass B On A.FinalAssetClassAlt_Key=B.AssetClassAlt_key
--And B.EffectiveFromTimekey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
--Inner JOIN DIMSOURCEDB C ON A.SourceAlt_Key=C.SourceAlt_key
--And C.EffectiveFromTimekey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
--Inner JOIN Pro.CustomerCal D ON A.CustomerEntityID=D.CustomerEntityID
--Inner Join DimProduct E ON E.ProductAlt_Key=A.ProductAlt_key
--And E.EffectiveFromTimekey<=@TimeKey AND E.EffectiveToTimeKey>=@TimeKey 
--where A.InitialAssetClassAlt_Key>1 AND A.FinalAssetClassAlt_Key<>FinalAssetClassAlt_Key

END
END

GO
