SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*=========================================
 AUTHER : TRILOKI KHANNA
 CREATE DATE : 27-11-2019
 MODIFY DATE : 07-04-2022
 DESCRIPTION :UPDATE FINAL ASSET CLASS AND MIN NPA DATE UPDATE CUSTOMER LEVEL AT ACCOUNT LEVEL
 EXEC [PRO].[Final_AssetClass_Npadate] 26479
=============================================*/
CREATE  PROCEDURE [PRO].[Final_AssetClass_Npadate]
@TIMEKEY INT with recompile
AS
BEGIN
      SET NOCOUNT ON
  BEGIN TRY
		
         --DECLARE @PANCARDFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='PANCARDNO' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)
		--DECLARE @AADHARCARDFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='AADHARCARD' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)
		DECLARE @PANCARDFLAG CHAR(1)=(SELECT 'Y' FROM solutionglobalparameter WHERE ParameterName='PAN Aadhar Dedup Integration' and  ParameterValueAlt_Key=1 AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)
		DECLARE @AADHARCARDFLAG CHAR(1)=(SELECT 'Y' FROM solutionglobalparameter WHERE ParameterName='PAN Aadhar Dedup Integration' and  ParameterValueAlt_Key=1 AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)

DECLARE @JointAccountFlag char(1)=(select RefValue from pro.RefPeriod where BusinessRule='Joint Account' and EffectiveFromTimeKey<=@TIMEKEY and EffectiveToTimeKey>=@TIMEKEY)
DECLARE @UCFICFlag char(1)=(select RefValue from pro.RefPeriod where BusinessRule='UCFIC' and EffectiveFromTimeKey<=@TIMEKEY and EffectiveToTimeKey>=@TIMEKEY)


/*---update FINALAssetClassAlt_Key  of those account which are not synk customer asset class key---------------------*/

UPDATE B SET B.finalAssetClassAlt_Key=  CASE WHEN A.Asset_Norm<>'ALWYS_STD' THEN A.SysAssetClassAlt_Key 
ELSE (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='STD' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY) END
FROM PRO.CustomerCal  A INNER JOIN PRO.AccountCal B ON A.RefCustomerID=B.RefCustomerID AND (ISNULL(A.FlgProcessing,'N')='N')
AND A.RefCustomerID IS NOT  NULL

UPDATE B SET B.finalAssetClassAlt_Key=  CASE WHEN A.Asset_Norm<>'ALWYS_STD' THEN A.SysAssetClassAlt_Key 
ELSE (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='STD' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY) END
FROM PRO.CustomerCal  A INNER JOIN PRO.AccountCal B ON A.SourceSystemCustomerID=B.SourceSystemCustomerID AND (ISNULL(A.FlgProcessing,'N')='N')
where A.SysAssetClassAlt_Key<>B.FinalAssetClassAlt_Key AND B.RefCustomerID is null 



/*---------------NPA DATE UPDATE CUSTOMER TO ACCOUNT LEVEL----------------------------------*/



UPDATE B SET B.FinalNpaDt=A.SYSNPA_DT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B  ON A.SourceSystemCustomerID=B.SourceSystemCustomerID
WHERE ISNULL(B.ASSET_NORM,'NORMAL')<>'ALWYS_STD' AND (ISNULL(A.FlgProcessing,'N')='N') 
and  isnull(A.SysNPA_Dt,'')<>isnull(b.FinalNpaDt,'') 
AND ISNULL(A.FlgDeg,'N')='Y'


UPDATE A SET A.FINALASSETCLASSALT_KEY=1,FINALNPADT=NULL, DEGREASON=NULL FROM PRO.ACCOUNTCAL  A WHERE ASSET_NORM='ALWYS_STD' --- AND FINALASSETCLASSALT_KEY>1S_STD'

/*------UPDATING DEG REASON  FOR ACCOUNT WHERE  NO DEFAULT IS THERE------ */

UPDATE B SET  B.DEGREASON=NULL FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL  B ON A.SourceSystemCustomerID=B.SourceSystemCustomerID
WHERE A.FLGDEG='Y' AND B.DEGREASON IS NULL AND B.ASSET_NORM <>'ALWYS_STD' AND (ISNULL(A.FlgProcessing,'N')='N')

UPDATE B SET  B.DEGREASON='PERCOLATION BY OTHER ACCOUNT' FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL  B ON A.SourceSystemCustomerID=B.SourceSystemCustomerID
WHERE A.FLGDEG='Y' AND B.DEGREASON IS NULL AND B.ASSET_NORM <>'ALWYS_STD' AND (ISNULL(A.FlgProcessing,'N')='N')

	 
 UPDATE A SET DEGREASON=B.DEGREASON
  FROM PRO.ACCOUNTCAL A
INNER JOIN PRO.CUSTOMERCAL B
ON A.SOURCESYSTEMCUSTOMERID=B.SOURCESYSTEMCUSTOMERID
 WHERE A.DEGREASON='PERCOLATION BY OTHER ACCOUNT'

---------------------------------------------------------------------
--START OF MODIFICATION--HANDLING OF ACCOUNTS WITH FUTURE NPA DATE
---------------------------------------------------------------------


DECLARE @REF_DATE AS DATE = (SELECT Date FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')
UPDATE PRO.CustomerCal SET SysNPA_Dt = @REF_DATE WHERE ISNULL(SysNPA_Dt,'1900-01-01') > @REF_DATE

UPDATE PRO.AccountCal SET FinalNpaDt = @REF_DATE WHERE ISNULL(FinalNpaDt,'1900-01-01') > @REF_DATE

UPDATE PRO.CustomerCal SET SysNPA_Dt = @REF_DATE WHERE SysNPA_Dt IS NULL AND SysAssetClassAlt_Key>1
UPDATE PRO.AccountCal SET FinalNpaDt = @REF_DATE WHERE FinalNpaDt IS NULL AND FinalAssetClassAlt_Key>1


/*------------------------------UPDATE UNIFORM ASSET CLASSIFICATION--------------------------------*/

 /* START PERCOLATION WORK -- 31082021 */
	
	EXEC [PRO].[InvestmentDataProcessing] @TimeKey

	EXEC [PRO].[DerivativeDataProcessing] @TimeKey


		/* MERGING DATA FOR ALL SOURCES FOR FIND LOWEST ASSET CLASS AND MIN NPA DATE */
	
	IF OBJECT_ID('TEMPDB..#CTE_PERC') IS NOT NULL
    DROP TABLE #CTE_PERC

	SELECT * INTO 
		#CTE_PERC
	FROM
		(		/* ADVANCE DATA */
			SELECT UCIF_ID,CustomerAcID,MAX(ISNULL(FinalAssetClassAlt_Key,1)) SYSASSETCLASSALT_KEY ,MIN(FinalNpaDt) SYSNPA_DT
			,'ADV' PercType
			FROM PRO.ACCOUNTCAL A WHERE ( UCIF_ID IS NOT NULL and UCIF_ID<>'0' ) 
			AND  ISNULL(FinalAssetClassAlt_Key,1)<>1 and (DPD_NoCredit > 89
															OR DPD_Overdrawn > 0 
															OR DPD_Overdue > 0
															OR DPD_Renewal > 180
															OR DPD_StockStmt > 89
															OR InttServiced = 'N'
															OR Asset_Norm = 'ALWYS_NPA') 
			GROUP BY  UCIF_ID,CustomerAcID
			UNION
			/* INVESTMENT DATA */
			SELECT UcifId UCIF_ID,RefInvID,MAX(ISNULL(FinalAssetClassAlt_Key,1)) SYSASSETCLASSALT_KEY ,MIN(NPIDt) SYSNPA_DT
			,'INV' PercType
			FROM InvestmentFinancialDetail A 
				INNER JOIN InvestmentBasicDetail B
					ON A.InvEntityId =B.InvEntityId
					AND A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
					AND B.EffectiveFromTimeKey <=@TIMEKEY AND B.EffectiveToTimeKey >=@TIMEKEY
				INNER JOIN InvestmentIssuerDetail C
					ON C.IssuerEntityId=B.IssuerEntityId
					AND C.EffectiveFromTimeKey <=@TIMEKEY AND C.EffectiveToTimeKey >=@TIMEKEY
			WHERE ISNULL(FinalAssetClassAlt_Key,1)<>1   and DPD > 0 
			GROUP BY  UcifId,RefInvID
			/* DERIVATIVE DATA */
			UNION 
				SELECT UCIC_ID,CustomerACID,MAX(ISNULL(FinalAssetClassAlt_Key,1)) SYSASSETCLASSALT_KEY ,MIN(NPIDt) SYSNPA_DT
				,'DER' PercType
			FROM CurDat.DerivativeDetail A 
				WHERE  A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
					AND ISNULL(FinalAssetClassAlt_Key,1)<>1 and DPD > 0 
			GROUP BY  UCIC_ID,CustomerACID
		)A

	/*  FIND LOWEST ASSET CLASS AND IN NPA DATE IN AALL SOURCES */
	IF OBJECT_ID('TEMPDB..#TEMPTABLE_UCFIC1') IS NOT NULL
    DROP TABLE #TEMPTABLE_UCFIC1

	SELECT UCIF_ID,CustomerACID, MAX(SYSASSETCLASSALT_KEY) SYSASSETCLASSALT_KEY, MIN(SYSNPA_DT)SYSNPA_DT
			,'XXX' PercType
		INTO #TEMPTABLE_UCFIC1 
	FROM #CTE_PERC
		GROUP BY UCIF_ID,CustomerACID

	UPDATE A
		SET A.PercType=B.PercType 
	FROM #TEMPTABLE_UCFIC1 A
		INNER JOIN #CTE_PERC B
			ON A.UCIF_ID =B.UCIF_ID
			AND A.SYSASSETCLASSALT_KEY =B.SYSASSETCLASSALT_KEY 
			


	/*  UPDATE LOWEST ASSET CLASS AND MIN NPA DATE IN - ADVANCE DATA */
	UPDATE A SET SysAssetClassAlt_Key=B.SYSASSETCLASSALT_KEY
				,A.SysNPA_Dt=B.SYSNPA_DT
				,A.DegReason=CASE WHEN A.SysAssetClassAlt_Key =1 AND B.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN B.PercType ='INV' THEN	'PERCOLATION BY INVESTMENT INVID '  + B.CustomerACID 
													WHEN B.PercType ='DER' THEN	'PERCOLATION BY DERIVATIVE ACCOUNTID '  + B.CustomerACID  	
										ELSE A.DegReason
									END 
								ELSE  A.DegReason
							END				
	FROM PRO.CUSTOMERCAL A
		INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
		,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID

									FROM #TEMPTABLE_UCFIC1 A
									
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) B ON A.UCIF_ID =B.UCIF_ID


	/* UPDATE INVESTMENT DATA - LOWEST ASSET CLASS AND MIN NPA DATE */
	UPDATE A SET A.FinalAssetClassAlt_Key=D.SYSASSETCLASSALT_KEY
	             ,A.NPIDt=D.SYSNPA_DT  
				,A.DegReason=CASE WHEN A.FinalAssetClassAlt_Key =1 AND D.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN D.PercType ='ADV' THEN	'PERCOLATION BY LOAN ACCOUNTID ' + D.CustomerACID 
										 WHEN D.PercType ='DER' THEN	'PERCOLATION BY DERIVATIVE ACCOUNTID '  + D.CustomerACID  	
										ELSE A.DegReason
									END 
								ELSE  A.DegReason
							END
	 FROM InvestmentFinancialDetail A 
				INNER JOIN InvestmentBasicDetail B
					ON A.InvEntityId =B.InvEntityId
					AND A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
					AND B.EffectiveFromTimeKey <=@TIMEKEY AND B.EffectiveToTimeKey >=@TIMEKEY
				INNER JOIN InvestmentIssuerDetail C
					ON C.IssuerEntityId=B.IssuerEntityId
					AND C.EffectiveFromTimeKey <=@TIMEKEY AND C.EffectiveToTimeKey >=@TIMEKEY
				INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
		,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID

									FROM #TEMPTABLE_UCFIC1 A
									
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) D ON D.UCIF_ID =C.UcifId

	/*  UPDATE   LOWEST ASSET CLASS AND MIN NPA DATE IN -  DERIVATIVE DATA */
	UPDATE A SET FinalAssetClassAlt_Key=B.SYSASSETCLASSALT_KEY
				,A.NPIDt=SYSNPA_DT
				,A.DegReason=CASE WHEN A.FinalAssetClassAlt_Key =1 AND B.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN B.PercType ='ADV' THEN 'PERCOLATION BY LOAN ACCOUNTID ' + B.CustomerACID 
										 WHEN B.PercType ='INV' THEN 'PERCOLATION BY INVESTMENT INVID ' + B.CustomerACID  	
										ELSE A.DegReason
									END 
								ELSE  A.DegReason
							END
	FROM CurDat.DerivativeDetail A
		INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
					,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
					WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
					WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #TEMPTABLE_UCFIC1 B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID
									FROM #TEMPTABLE_UCFIC1 A									
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) B ON A.UCIC_ID =B.UCIF_ID
		AND A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY

		
	--DROP TABLE IF EXISTS #CTE_PERC


		update A SET FLGUPG='N',UPGDATE=NULL
		FROM CurDat.DerivativeDetail A
		where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
		 and FinalAssetClassAlt_Key>1

		 update A SET AssetClass_AltKey=FinalAssetClassAlt_Key
		 FROM CurDat.DerivativeDetail A
		where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
		 and FinalAssetClassAlt_Key>1

		 update A SET AssetClass_AltKey=FinalAssetClassAlt_Key
		 FROM DBO.InvestmentFinancialDetail A
		where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
		 and FinalAssetClassAlt_Key>1

		 update A SET FLGUPG='N',UPGDATE=NULL
		FROM InvestmentFinancialDetail A
		where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
		 and FinalAssetClassAlt_Key>1


	DROP TABLE IF EXISTS #TEMPTABLE_UCFIC1

	/* INVESTMENT AND DERVATIVE PROVISION CALCULATION */
	EXEC [PRO].[InvestmentDerivativeProvisionCal] @TIMEKEY

/* END OF PERCOLATION WORK */


	 UPDATE A SET 
	         A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
		    ,A.FinalNpaDt=B.SysNPA_Dt
			FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
			ON  A.RefCustomerID=B.RefCustomerID AND A.SourceSystemCustomerID=B.SourceSystemCustomerID 
			WHERE ISNULL(B.SysAssetClassAlt_Key,1)<>1 AND B.RefCustomerID<>'0'

	UPDATE A SET 
	         A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
		    ,A.FinalNpaDt=B.SysNPA_Dt
			FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
			ON  A.SourceSystemCustomerID=B.SourceSystemCustomerID 
			WHERE ISNULL(B.SysAssetClassAlt_Key,1)<>1

	UPDATE A SET 
	         A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
		    ,A.FinalNpaDt=B.SysNPA_Dt
			FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
			ON  A.UcifEntityID=B.UcifEntityID 
			WHERE ISNULL(B.SysAssetClassAlt_Key,1)<>1
		
	 
	 UPDATE A SET NPA_Reason=(B.DEGREASON + ISNULL(NPA_Reason,''))
	FROM PRO.AccountCal A 
	INNER JOIN PRO.CustomerCal B ON A.SourceSystemCustomerID =B.SourceSystemCustomerID
	WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='N') AND B.DegReason IS NOT NULL AND A.FinalAssetClassAlt_Key>1 AND A.DegReason IS NULL

	
	---------------------------------To update Percolation NPA Reason 

	
	/*  UPDATE LOWEST ASSET CLASS AND MIN NPA DATE IN - ADVANCE DATA */
	UPDATE A SET A.NPA_Reason=CASE WHEN  B.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN B.PercType ='INV' and A.NPA_Reason is  NULL THEN 'PERCOLATION BY INVESTMENT INVID '  + B.CustomerACID 
													WHEN B.PercType ='DER' and A.NPA_Reason is  NULL  THEN	'PERCOLATION BY DERIVATIVE ACCOUNTID '  + B.CustomerACID  	
										ELSE A.NPA_Reason
									END 
								ELSE  A.NPA_Reason
							END				
	FROM PRO.ACCOUNTCAL A
		INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
		,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID

									FROM #CTE_PERC A
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) B 
									ON A.UCIF_ID =B.UCIF_ID
									and B.PercType IN ('inv','der')
									
	/* UPDATE INVESTMENT DATA - LOWEST ASSET CLASS AND MIN NPA DATE */
	UPDATE A SET A.DegReason=CASE WHEN  D.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN D.PercType ='ADV' and A.DegReason not like '%PERC%'  THEN	ISNULL(A.DegReason,'') + ',PERCOLATION BY LOAN ACCOUNTID ' + D.CustomerACID 
										 WHEN D.PercType ='DER' and A.DegReason not like '%PERC%' THEN	ISNULL(A.DegReason,'') + ',PERCOLATION BY DERIVATIVE ACCOUNTID '  + D.CustomerACID  	
										ELSE A.DegReason
									END 
								ELSE  A.DegReason
							END
	 FROM InvestmentFinancialDetail A 
				INNER JOIN InvestmentBasicDetail B
					ON A.InvEntityId =B.InvEntityId
					AND A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
					AND B.EffectiveFromTimeKey <=@TIMEKEY AND B.EffectiveToTimeKey >=@TIMEKEY
				INNER JOIN InvestmentIssuerDetail C
					ON C.IssuerEntityId=B.IssuerEntityId
					AND C.EffectiveFromTimeKey <=@TIMEKEY AND C.EffectiveToTimeKey >=@TIMEKEY
				INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
		,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
				WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID

									FROM #CTE_PERC A
									
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) D 
									ON D.UCIF_ID =C.UcifId
									and D.PercType IN ('adv','der')

	/*  UPDATE   LOWEST ASSET CLASS AND MIN NPA DATE IN -  DERIVATIVE DATA */
	UPDATE A SET A.DegReason=CASE WHEN  B.SYSASSETCLASSALT_KEY >1 
								THEN  
									CASE WHEN B.PercType ='ADV' and A.DegReason not like '%PERC%' THEN ISNULL(A.DegReason,'') + ',PERCOLATION BY LOAN ACCOUNTID ' + B.CustomerACID 
										 WHEN B.PercType ='INV' and A.DegReason not like '%PERC%' THEN ISNULL(A.DegReason,'') + ',PERCOLATION BY INVESTMENT INVID ' + B.CustomerACID  	
										ELSE A.DegReason
									END 
								ELSE  A.DegReason
							END
	FROM CurDat.DerivativeDetail A
		INNER JOIN (select A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT
					,(CASE WHEN A.PercType = 'ADV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'ADV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
					WHEN  A.PercType = 'INV' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'INV' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
					WHEN  A.PercType = 'DER' THEN STUFF((SELECT ', ' + B.CustomerACID
										from #CTE_PERC B 
										WHERE B.PercType = 'DER' and B.UCIF_ID = A.UCIF_ID
										ORDER BY CustomerACID
										FOR XML PATH('')),1,1,'')
										END) CustomerACID
									FROM #CTE_PERC A									
									GROUP BY A.UCIF_ID,A.PercType,A.SYSASSETCLASSALT_KEY,A.SYSNPA_DT) B ON A.UCIC_ID =B.UCIF_ID and b.PercType IN ('adv','INV')
		AND A.EffectiveFromTimeKey<=@tIMEKEY AND A.EffectiveToTimeKey>=@tIMEKEY

	DROP TABLE IF EXISTS #CTE_PERC



	-- UPDATE A SET DEGREASON=B.DEGREASON
	--FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.SourceSystemCustomerID =B.SourceSystemCustomerID
	--WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='N') AND B.DegReason IS NOT NULL AND A.FinalAssetClassAlt_Key>1
	-- AND A.DegReason IS NULL

	 

UPDATE B SET B.FinalNpaDt=A.SYSNPA_DT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B  ON A.SourceSystemCustomerID=B.SourceSystemCustomerID
WHERE ISNULL(B.ASSET_NORM,'NORMAL')<>'ALWYS_STD' AND (ISNULL(A.FlgProcessing,'N')='N') 
and  isnull(A.SysNPA_Dt,'')<>isnull(b.FinalNpaDt,'') 
AND ISNULL(A.FlgDeg,'N')='N'
AND A.RefCustomerID<>'0'

/*---------------UPDATE ASSET CLASS STD WHERE ASSET NORM ALWAYS STD---------------*/




UPDATE A SET FinalAssetClassAlt_Key=1,FinalNpaDt=NULL, DEGREASON=NULL FROM PRO.AccountCal A WHERE A.ASSET_NORM ='ALWYS_STD'

	 ---UPDATE  MULTIPLE   DegReason IN PRO.CUSTOMERCAL TABLE-------

	 IF object_id('TEMPDB..#Data') is NOT NULL
     DROP TABLE #Data

	select distinct DegReason ,UcifEntityID  INTO #Data from PRO.AccountCal  WHERE DegReason IS NOT NULL AND FLGDEG='Y'



	--IF object_id('TEMPDB..#NPADegReason') is NOT NULL
	--DROP TABLE #NPADegReason
	--select UcifEntityID,STRING_AGG( DegReason,'')  DegReason 
	--into  #NPADegReason from #Data
	--group by UcifEntityID

	IF object_id('TEMPDB..#NPADegReason') is NOT NULL
	DROP TABLE #NPADegReason

		SELECT UcifEntityID,STUFF((SELECT ' ,' +DegReason  
				FROM #Data M1
		WHERE M2.UcifEntityID = M1.UcifEntityID
		FOR XML PATH('')),1,1,'')  AS DegReason
			into #NPADegReason
				FROM #Data M2
		GROUP BY UcifEntityID


	UPDATE A SET DegReason=B.DegReason  FROM PRO.CustomerCal A 
	INNER JOIN #NPADegReason B  ON A.UcifEntityID=B.UcifEntityID
	AND A.FlgDeg='Y'

	Update pro.CUSTOMERCAL set FlgUpg ='N' where SrcAssetClassAlt_Key =1 and SysAssetClassAlt_Key >1
	Update pro.CUSTOMERCAL set FlgDeg ='N' where SrcAssetClassAlt_Key >1 and SysAssetClassAlt_Key =1

	Update pro.AccountCal set FlgUpg ='N',UpgDate =null where InitialAssetClassAlt_Key  =1 and FinalAssetClassAlt_Key >1
	Update pro.AccountCal set FlgDeg ='N' where InitialAssetClassAlt_Key >1 and FinalAssetClassAlt_Key =1

		UPDATE A set DegReason='DEGRADE BY Overdue'
		from InvestmentFinancialDetail a
		where  A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
		and FinalAssetClassAlt_Key>1
		and DegReason is null


		UPDATE A set DegReason='DEGRADE BY Overdue'
		from CurDat.DerivativeDetail a
		where  A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
		and FinalAssetClassAlt_Key>1
		and DegReason is null


	UPDATE A SET A.DegReason= 'NPA DUE TO FRAUD MARKING'            
	FROM PRO.AccountCal A 
	where a.FlgFraud='Y' AND FinalAssetClassAlt_Key>1

	UPDATE A SET A.DegReason= 'NPA DUE TO RFA MARKING'            
	FROM PRO.AccountCal A 
	where a.RFA='Y' AND FinalAssetClassAlt_Key>1
	
	UPDATE A SET A.NPA_Reason= 'NPA DUE TO FRAUD MARKING'            
	FROM PRO.AccountCal A 
	where a.FlgFraud='Y' AND FinalAssetClassAlt_Key>1

	UPDATE A SET A.NPA_Reason= 'NPA DUE TO RFA MARKING'            
	FROM PRO.AccountCal A 
	where a.RFA='Y' AND FinalAssetClassAlt_Key>1

	
update InvestmentFinancialDetail
SET DBTDate = DATEADD(mm,12,NPIDt)
where EffectiveFromTimeKey <= @Timekey and EffectiveToTimeKey >= @Timekey
and DATEADD(mm,12,NPIDt) != DBTDate
	
update curdat.DerivativeDetail
SET DBTDate = DATEADD(mm,12,NPIDt)
where EffectiveFromTimeKey <= @Timekey and EffectiveToTimeKey >= @Timekey
and DATEADD(mm,12,NPIDt) != DBTDate


	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
		SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1
		WHERE RUNNINGPROCESSNAME='Final_AssetClass_Npadate'

   DROP TABLE #Data
   
   DROP TABLE #NPADegReason

   -----------------Added for DashBoard 04-03-2021
Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'
 
END TRY
BEGIN  CATCH
	
	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='Final_AssetClass_Npadate'
END CATCH
SET NOCOUNT OFF
END











GO
