SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec [HostSystemStatusReport]
CREATE PROCEDURE [dbo].[HostSystemStatusReport_upgrade_old]
--(
--@Date datetime
--)
AS
BEGIN

Declare @TimeKey int = (select timekey from Automate_advances where Ext_flg = 'Y')

Declare @Date Date = (select Date from Automate_advances where Ext_flg = 'Y')

select distinct UCIF_ID 
into #temp
from pro.AccountCAL_hist with (nolock)
where Effectivefromtimekey <= @TimeKey 
and EffectiveToTimeKey >= @Timekey 
and  CustomerAcID in (
SELECT distinct CustomerAcID FROM pro.AccountCAL WHERE InitialAssetClassAlt_Key > 1 AND FinalAssetClassAlt_Key = 1)

delete from HostSystemStatus where EffectiveFromTimeKey <= @Timekey and EffectiveToTimeKey >= @Timekey

INSERT into HostSystemStatus (
[UCIC Code]
,CustomerID
,CustomerName
,AccountNo
,[Host System Name]
,OSBalance
,[Report Date]
,ActSegmentCode
,[Account Level Business Segment]
,[Business Seg Desc]
,[Base Account Scheme Code]
,[Base Account Scheme Owner]
,[Host System Status]
,Main_Classification
,Remarks
,[Closed Date]
,[Cr/Dr]
,EffectiveFromTimekey
,EffectiveToTimekey)
SELECT 
	A.UCIF_ID as [UCIC Code], 
	A.RefCustomerID CustomerID, 
	CustomerName,
	CustomerAcid AccountNo
	,SourceName as [Host System Name]
	,Balance OSBalance
	,@Date [Report Date]
	,B.ActSegmentCode
	,CASE WHEN SourceName='Ganaseva' THEN 'FI'
		  WHEN SourceName='VisionPlus' THEN 'Credit Card'
		else S.AcBuRevisedSegmentCode end  [Account Level Business Segment],
		AcBuSegmentDescription [Business Seg Desc]
	,b.ProductCode as [Base Account Scheme Code]
	,NULL as [Base Account Scheme Owner]
	,SMA_Class as [Host System Status]
	,NULL [Main_Clasification]
	,NULL [Remarks]
	,NULL [Closed Date]
	,(CASE WHEN isnull(Balance,0) < 0 then 'Dr'  ELSE 'Cr' END) [Cr/Dr]
	,A.EffectiveFromTimeKey
	,a.EffectiveToTimeKey
FROM PRO.CustomerCal_Hist A
	INNER JOIN PRO.ACCOUNTCAL_Hist B
		ON A.CustomerEntityID=B.CustomerEntityID 
    LEFT JOIN DIMSOURCEDB src
		on b.SourceAlt_Key =src.SourceAlt_Key	
	LEFT JOIN DIMPRODUCT PD
		ON PD.EffectiveToTimeKey=49999
		AND PD.PRODUCTALT_KEY=b.PRODUCTALT_KEY
	left join DimAssetClass a1
		on a1.EffectiveToTimeKey=49999
		and a1.AssetClassAlt_Key=b.InitialAssetClassAlt_Key
	left join DimAssetClass a2
		on a2.EffectiveToTimeKey=49999
		and a2.AssetClassAlt_Key=b.FinalAssetClassAlt_Key
	LEFT JOIN DimAcBuSegment S  ON B.ActSegmentCode=S.AcBuSegmentCode and S.EffectiveToTimeKey  = 49999
	WHERE CustomerAcID in (	select CustomerAcID
							from  pro.AccountCal_Hist with(nolock)
							where UCIF_ID in (select UCIF_ID from #temp) 
							 AND EffectiveFromTimeKey <= @Timekey 
							 and EffectiveToTimeKey >= @TimeKey
						  )
 AND A.EffectiveFromTimeKey <= @Timekey and A.EffectiveToTimeKey >= @TimeKey
 AND B.EffectiveFromTimeKey <= @Timekey and B.EffectiveToTimeKey >= @TimeKey

	END
	
GO
