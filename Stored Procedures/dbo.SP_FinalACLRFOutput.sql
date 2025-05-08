SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_FinalACLRFOutput]
AS
BEGIN


Declare @Date date = (select Date from Automate_Advances where Ext_flg = 'Y')

Declare @Timekey int = (select Timekey from Automate_Advances where Ext_flg = 'Y')

-----------------------------------------ACL PROCESSING---------------
--------DBCC shrinkfile (log,1)
--------DBCC shrinkfile (log,1)
--------DBCC shrinkfile (log,1)
--------DBCC shrinkfile (log,1)
--------DBCC shrinkfile (log,1)

exec PRO.InsertDataforAssetClassficationENBD @Timekey

Exec Pro.MAINPROECESSFORASSETCLASSFICATION


---------------------------------------------------ACL OUTPUT ---------------

IF (select count(*) from ACL_NPA_DATA 
	where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')) > 0
	BEGIN
	delete from ACL_NPA_DATA where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')
	END

	INSERT INTO  ACL_NPA_DATA
SELECT 
      convert(nvarchar,GETDATE() , 105) AS  [Generation Date]
	  ,  convert(nvarchar,@Date, 105) Process_Date,
	A.UCIF_ID as UCIC, A.RefCustomerID CustomerID, CustomerName,B.Branchcode,CustomerAcid, b.Facilitytype ,b.ProductCode
	,ProductName
	,Balance,DrawingPower	,CurrentLimit,UnserviedInt UnAppliedIntt, ReviewDueDt,CreditSinceDt,b.ContiExcessDt,StockStDt,DebitSinceDt
	,LastCrDate,PreQtrCredit,PrvQtrInt,CurQtrCredit,CurQtrInt,
	--IntNotServicedDt	
	OverdueAmt	,OverDueSinceDt	
	,SecurityValue,NetBalance,PrincOutStd	,ApprRV,SecuredAmt,UnSecuredAmt,Provsecured	
	,ProvUnsecured
	,TotalProvision,RefPeriodOverdue	,RefPeriodOverDrawn	,RefPeriodNoCredit,
	RefPeriodIntService,RefPeriodStkStatement,RefPeriodReview,PrincOverdue,	PrincOverdueSinceDt,	
	IntOverdue,	IntOverdueSinceDt,	OtherOverdue,	OtherOverdueSinceDt,DPD_IntService,	DPD_NoCredit,	
	DPD_Overdrawn	,DPD_Overdue,	DPD_Renewal,	DPD_StockStmt,DPD_PrincOverdue	,DPD_IntOverdueSince	
	,DPD_OtherOverdueSince,DPD_Max	,InitialNpaDt,	FinalNpaDt,InitialAssetClassAlt_Key
	,a1.AssetClassShortNameEnum InitialAssetClass
	,FinalAssetClassAlt_Key ,a2.AssetClassShortNameEnum FialAssetClass
	,b.DegReason,b.FlgDeg, b.FlgUpg,NPA_Reason,FLGSECURED As SecuredFlag
	,a.Asset_Norm
	,b.CD
	,pd.NPANorms,b.WriteOffAmount
	,b.ActSegmentCode,ProductSubGroup
	,SourceName
	,ProductGroup
	,PD.SchemeType
	,CASE WHEN SourceName='Ganaseva' THEN 'FI'
		  WHEN SourceName='VisionPlus' THEN 'Credit Card'
		else S.AcBuRevisedSegmentCode end AcBuRevisedSegmentCode
----SELECT ActSegmentCode,* FROM PRO.ACCOUNTCAL
,a.DegDate
,REPLACE(isnull(B.MOC_Dt,A.MOC_Dt),',','')MOC_Dt
,REPLACE(isnull(B.MOCReason,A.MOCReason),',','')MOCReason
--into #data
FROM PRO.CUSTOMERCAL A
	INNER JOIN PRO.ACCOUNTCAL B
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
	LEFT JOIN DimAcBuSegment S  ON B.ActSegmentCode=S.AcBuSegmentCode
	and S.EffectiveToTimeKey = 49999
WHERE B.FinalAssetClassAlt_Key>1
	--AND isnull(b.WriteOffAmount,0)=0	--	 where B.FlgUpg='U'

select @Date as DateofData,'ACL_NPA_Data'TableName,count(1)Count from ACL_NPA_DATA where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')

IF (select count(1) from ACL_UPG_DATA 
	where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')) > 0
	BEGIN
	delete from ACL_UPG_DATA where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y') 
	 END


	INSERT INTO ACL_UPG_DATA
SELECT 
      convert(nvarchar,getdate() , 105) AS  [Generation Date]
	  ,  convert(nvarchar,@Date, 105) Process_Date,
	A.UCIF_ID as UCIC, A.RefCustomerID CustomerID, CustomerName,B.Branchcode,CustomerAcid, b.Facilitytype ,b.ProductCode
	,ProductName
	,Balance,DrawingPower	,CurrentLimit,UnserviedInt UnAppliedIntt, ReviewDueDt,CreditSinceDt,b.ContiExcessDt,StockStDt,DebitSinceDt
	,LastCrDate,PreQtrCredit,PrvQtrInt,CurQtrCredit,CurQtrInt,
	--IntNotServicedDt	
	OverdueAmt	,OverDueSinceDt	
	,SecurityValue,NetBalance,PrincOutStd	,ApprRV,SecuredAmt,UnSecuredAmt,Provsecured	
	,ProvUnsecured
	,TotalProvision,RefPeriodOverdue	,RefPeriodOverDrawn	,RefPeriodNoCredit,
	RefPeriodIntService,RefPeriodStkStatement,RefPeriodReview,PrincOverdue,	PrincOverdueSinceDt,	
	IntOverdue,	IntOverdueSinceDt,	OtherOverdue,	OtherOverdueSinceDt,DPD_IntService,	DPD_NoCredit,	
	DPD_Overdrawn	,DPD_Overdue,	DPD_Renewal,	DPD_StockStmt,DPD_PrincOverdue	,DPD_IntOverdueSince	
	,DPD_OtherOverdueSince,DPD_Max	,InitialNpaDt,	FinalNpaDt,InitialAssetClassAlt_Key
	,a1.AssetClassShortNameEnum InitialAssetClass
	,FinalAssetClassAlt_Key ,a2.AssetClassShortNameEnum FialAssetClass
	,b.DegReason,b.FlgDeg, b.FlgUpg,NPA_Reason,FLGSECURED As SecuredFlag
	,a.Asset_Norm
	,b.CD
	,pd.NPANorms,b.WriteOffAmount
	,b.ActSegmentCode,ProductSubGroup
	,SourceName
	,ProductGroup
	,PD.SchemeType
	,CASE WHEN SourceName='Ganaseva' THEN 'FI'
		  WHEN SourceName='VisionPlus' THEN 'Credit Card'
		else S.AcBuRevisedSegmentCode end AcBuRevisedSegmentCode
		,REPLACE(isnull(B.MOC_Dt,A.MOC_Dt),',','')MOC_Dt
,REPLACE(isnull(B.MOCReason,A.MOCReason),',','')MOCReason
FROM PRO.CUSTOMERCAL A
	INNER JOIN PRO.ACCOUNTCAL B
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
	LEFT JOIN DimAcBuSegment S  ON B.ActSegmentCode=S.AcBuSegmentCode
	-- where B.FinalAssetClassAlt_Key>1
	 where B.InitialAssetClassAlt_Key > 1 and B.FinalAssetClassAlt_Key = 1

	

	 select @Date as DateofData,'ACL_UPG_Data'TableName,count(1)Count from ACL_UPG_DATA  
	 where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')

	 

	
	
IF (select count(1) from INVESTMENT_DATA 
	where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')) > 0
	BEGIN
	delete from INVESTMENT_DATA where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')
	END
	INSERT INTO INVESTMENT_DATA
--/*
----SELECT convert(nvarchar,@Date, 105) Process_Date,B.BRANCHCODE,ISSUERID,ISSUERNAME,REF_TXN_SYS_CUST_ID,ISSUER_CATEGORY_CODE,UCIFID,PANNO,INVID
----,ISIN,I.INSTRUMENTTYPENAME
----,INSTRNAME,b.INVESTMENTNATURE,EXPOSURETYPE,MATURITYDT,HOLDINGNATURE,BOOKTYPE,BOOKVALUE,MTMVALUE,INTEREST_DIVIDENDDUEDATE,INTEREST_DIVIDENDDUEAMOUNT,DPD,FLGDEG,DEGREASON,FLGUPG,UPGDATE,TOTALPROVISON,AC.ASSETCLASSSHORTNAME ASSETCLASS

----FROM InvestmentIssuerDetail a
----	INNER JOIN InvestmentBasicDetail B
----		ON A.IssuerEntityId=B.IssuerEntityId
----		and a.EffectiveFromTimeKey<=@TIMEKEY and a.EffectiveToTimeKey>=@TIMEKEY
----		and b.EffectiveFromTimeKey<=@TIMEKEY and b.EffectiveToTimeKey>=@TIMEKEY
----	INNER JOIN InvestmentFinancialDetail c

----		ON b.InvEntityId=c.InvEntityId
----		and c.EffectiveFromTimeKey<=@TIMEKEY and c.EffectiveToTimeKey>=@TIMEKEY
----	INNER JOIN DimAssetClass AC
----		ON AC.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY
----		AND AC.AssetClassAlt_Key=C.FinalAssetClassAlt_Key
	
----	INNER JOIN DimInstrumentType I
----		ON I.EffectiveFromTimeKey<=@TIMEKEY AND I.EffectiveToTimeKey>=@TIMEKEY
----		AND B.InstrTypeAlt_Key=I.InstrumentTypeAlt_Key
--	*/
SELECT convert(nvarchar,@Date, 105) Process_Date,B.BRANCHCODE,ISSUERID,ISSUERNAME,REF_TXN_SYS_CUST_ID
	,ISSUER_CATEGORY_CODE,UCIFID,PANNO,INVID
	,ISIN,I.INSTRUMENTTYPENAME
	,INSTRNAME,b.INVESTMENTNATURE,EXPOSURETYPE,MATURITYDT,HOLDINGNATURE,BOOKTYPE,BOOKVALUE,MTMVALUE
	,INTEREST_DIVIDENDDUEDATE,INTEREST_DIVIDENDDUEAMOUNT,DPD,FLGDEG,DEGREASON,FLGUPG,UPGDATE,TOTALPROVISON
	,AC.ASSETCLASSSHORTNAME ASSETCLASS
	,C.PartialRedumptionDueDate,c.PartialRedumptionSettledY_N
--SELECT A.*
FROM InvestmentIssuerDetail a
	INNER JOIN InvestmentBasicDetail B
		ON A.IssuerEntityId=B.IssuerEntityId
		and a.EffectiveFromTimeKey<=@TimeKey and a.EffectiveToTimeKey>=@TimeKey
		and b.EffectiveFromTimeKey<=@TimeKey and b.EffectiveToTimeKey>=@TimeKey
	INNER JOIN InvestmentFinancialDetail c
		ON b.InvEntityId=c.InvEntityId
		and c.EffectiveFromTimeKey<=@TimeKey and c.EffectiveToTimeKey>=@TimeKey
	INNER JOIN DimAssetClass AC
		ON AC.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
		AND AC.AssetClassAlt_Key=C.FinalAssetClassAlt_Key
	LEFT JOIN DimInstrumentType I
		ON I.EffectiveFromTimeKey<=@TimeKey AND I.EffectiveToTimeKey>=@TimeKey
		AND B.InstrTypeAlt_Key=I.InstrumentTypeAlt_Key

--	/*

--	WHERE ISNULL(B.InvestmentNature,'') <>'EQUITY'	

--UNION ALL
	
	 
--SELECT convert(nvarchar,@Date, 105) Process_Date,B.BRANCHCODE,ISSUERID,ISSUERNAME,REF_TXN_SYS_CUST_ID,ISSUER_CATEGORY_CODE,UCIFID,PANNO,INVID
--,ISIN,NULL INSTRUMENTTYPENAME
--,INSTRNAME,b.INVESTMENTNATURE,EXPOSURETYPE,MATURITYDT,HOLDINGNATURE,BOOKTYPE,BOOKVALUE,MTMVALUE,INTEREST_DIVIDENDDUEDATE,INTEREST_DIVIDENDDUEAMOUNT,DPD,FLGDEG,DEGREASON,FLGUPG,UPGDATE,TOTALPROVISON,AC.ASSETCLASSSHORTNAME ASSETCLASS

----SELECT A.*
--FROM InvestmentIssuerDetail a
--	INNER JOIN InvestmentBasicDetail B
--		ON A.IssuerEntityId=B.IssuerEntityId
--		and a.EffectiveFromTimeKey<=@TimeKey and a.EffectiveToTimeKey>=@TimeKey
--		and b.EffectiveFromTimeKey<=@TimeKey and b.EffectiveToTimeKey>=@TimeKey
--	INNER JOIN InvestmentFinancialDetail c

--		ON b.InvEntityId=c.InvEntityId
--		and c.EffectiveFromTimeKey<=@TimeKey and c.EffectiveToTimeKey>=@TimeKey
--	INNER JOIN DimAssetClass AC
--		ON AC.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
--		AND AC.AssetClassAlt_Key=C.FinalAssetClassAlt_Key
--	WHERE B.InvestmentNature ='EQUITY'	
	
--	*/


		select @Date as DateofData,'Investment_Data'TableName,count(1)Count from INVESTMENT_DATA  where CONVERT(DATE,Process_Date,105) in (select convert(Date,Date,105) from Automate_Advances where Ext_flg = 'Y')



		END
GO
