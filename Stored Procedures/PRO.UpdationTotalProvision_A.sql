SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*==============================          
Author : TRILOKI KHANNA   
CREATE DATE : 27-11-2019          
MODIFY DATE : 27-11-2019         
DESCRIPTION : UPDATE TOTAL PROVISION          
--EXEC [pro].[UpdationTotalProvision] @TimeKey =25410            
=========================================*/                
CREATE PROCEDURE [PRO].[UpdationTotalProvision_A]              
@TimeKey int   
with recompile               
AS              
  BEGIN              
   SET NOCOUNT ON;              
              
 BEGIN TRY    
 
 DECLARE @vEffectivefrom  Int SET @vEffectiveFrom=(SELECT TimeKey FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')          
 Declare @vEffectiveto INT Set @vEffectiveto= (select Timekey-1 from [dbo].Automate_Advances where EXT_FLG='Y')
 DECLARE @DATE AS DATE =(SELECT Date FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')

 UPDATE  PRO.ACCOUNTCAL              
 SET TOTALPROVISION = 0  ,BANKTOTALPROVISION=0,RBITOTALPROVISION=0

 
 UPDATE  PRO.CUSTOMERCAL              
 SET TOTPROVISION = 0  ,BANKTOTPROVISION=0,RBITOTPROVISION=0
              
 UPDATE A                   
 SET  
	   TOTALPROVISION       =(ISNULL(A.PROVSECURED,0) + ISNULL(A.PROVUNSECURED,0)  + (ISNULL(A.ADDLPROVISION,0))+ ISNULL(A.PROVCOVERGOVGUR,0)+  ISNULL(A.PROVDFV,0)) 
      ,BANKTOTALPROVISION  =(ISNULL(A.BANKPROVSECURED,0) + ISNULL(A.BANKPROVUNSECURED,0)  + (ISNULL(A.ADDLPROVISION,0))+ ISNULL(A.PROVCOVERGOVGUR,0)+   ISNULL(A.PROVDFV,0)) 
	  ,RBITOTALPROVISION   =(ISNULL(A.RBIPROVSECURED,0) +  ISNULL(A.RBIPROVUNSECURED,0)  +  (ISNULL(A.ADDLPROVISION,0))+ ISNULL(A.PROVCOVERGOVGUR,0)+   ISNULL(A.PROVDFV,0))                                           
 FROM  PRO.ACCOUNTCAL    A             
 
 UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=0 WHERE ISNULL(TOTALPROVISION,0)<0
 UPDATE PRO.ACCOUNTCAL SET BANKTOTALPROVISION=0 WHERE ISNULL(BANKTOTALPROVISION,0)<0
 UPDATE PRO.ACCOUNTCAL SET RBITOTALPROVISION=0 WHERE ISNULL(RBITOTALPROVISION,0)<0

 
 UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=NetBalance WHERE ISNULL(TOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0
 UPDATE PRO.ACCOUNTCAL SET BANKTOTALPROVISION=NetBalance WHERE ISNULL(BANKTOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0
 UPDATE PRO.ACCOUNTCAL SET RBITOTALPROVISION=NetBalance WHERE ISNULL(RBITOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0

 UPDATE A SET TOTALPROVISION=RBITOTALPROVISION,PROVSECURED=RBIPROVSECURED,PROVUNSECURED=RBIPROVUNSECURED,ADDLPROVISION=ADDLPROVISION,PROVCOVERGOVGUR=PROVCOVERGOVGUR,PROVDFV=PROVDFV
 FROM PRO.ACCOUNTCAL A  where ISNULL(A.RBITOTALPROVISION,0)>ISNULL(A.BANKTOTALPROVISION,0)


/* RESTRUCTURE PROV WORK */

--Select * 
	UPDATE A SET 
		 A.FinalAssetClassAlt_Key=b.FinalAssetClassAlt_Key
		,A.InitialAssetClassAlt_Key=B.InitialAssetClassAlt_Key
		,A.AppliedNormalProvPer=CASE WHEN B.FinalAssetClassAlt_Key =1 THEN SP.ProvisionSecured
												ELSE np.ProvisionSecured END
		,A.FinalNpaDt=b.FinalNpaDt
		
		,A.RestructureStage=A.RestructureStage
								+ (CASE WHEN  B.FinalAssetClassAlt_Key>1  and RIGHT(RestructureStage,3)='STD'
										THEN '-NPA'
									WHEN  B.FinalAssetClassAlt_Key=1  and RIGHT(RestructureStage,3)='NPA'
										THEN '-STD'
									ELSE ''
								  END)
		,A.UpgradeDate=CASE WHEN B.UpgDate IS NOT NULL THEN  B.UpgDate ELSE A.UpgradeDate END
		,A.SurvPeriodEndDate=CASE WHEN B.UpgDate IS NOT NULL THEN DATEADD(yy,1,b.UpgDate) ELSE A.SurvPeriodEndDate END
	FROM [PRO].[AdvAcRestructureCal] A
		INNER JOIN PRO.ACCOUNTCAL B ON A.AccountEntityId=B.AccountEntityId
		LEFT JOIN DimProvision_SegStd SP
			ON SP.EffectiveFromTimeKey<=@TimeKey AND SP.EffectiveToTimeKey>=@TimeKey
			AND SP.ProvisionAlt_Key=B.ProvisionAlt_Key
		LEFT JOIN DimProvision_Seg NP
			ON NP.EffectiveFromTimeKey<=@TimeKey AND NP.EffectiveToTimeKey>=@TimeKey
			AND NP.ProvisionAlt_Key=B.ProvisionAlt_Key
	WHERE A.EffectiveFromTimeKey<=@TimeKey And A.EffectiveToTimeKey>=@TimeKey

	UPDATE A SET
		A.RestructureStage='STD-STD-NPA-STD'
	FROM [PRO].[AdvAcRestructureCal] A
		WHERE RestructureStage='STD-STD-NPA-STD-NPA-STD'

	UPDATE A SET
		A.RestructureStage='NPA-STD-NPA-STD'
	FROM [PRO].[AdvAcRestructureCal] A
		WHERE RestructureStage='NPA-STD-NPA-STD-NPA-STD'


	/* 1- RESOLUTION FRAMEWORK - CALCUCATE PROV  */

		UPDATE A SET
				AddlProvPer=(CASE WHEN isnull(PreRestructureAssetClassAlt_Key,0)>1 
									THEN isnull(PreRestructureNPA_Prov,0) 
								ELSE 10 
							END)
			FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('COVID_OTR_RF','COVID_OTR_RF_2')
		WHERE FinalAssetClassAlt_Key =1  
		---and RestructureStage in('NPA-STD','STD-STD') 
	
	
		UPDATE A SET
				ProvReleasePer= CASE WHEN E.ParameterShortNameEnum='Personal'
										THEN 
											CASE WHEN Res_POS_to_CurrentPOS_Per<=30 
												THEN AddlProvPer/2
											ELSE 
												AddlProvPer
											END

								 WHEN E.ParameterShortNameEnum='Other' --AND D.ParameterShortNameEnum ='COVID_OTR_RF'
										and SP_ExpiryDate<@DATE
										THEN
											CASE WHEN Res_POS_to_CurrentPOS_Per<=30 
												THEN AddlProvPer/2
											ELSE 
												AddlProvPer
											END
								END
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('COVID_OTR_RF','COVID_OTR_RF_2')
		INNER JOIN DimParameter E ON E.EffectiveFromTimeKey <=@timekey AND E.EffectiveToTimeKey>=@timekey 
				AND E.ParameterAlt_Key=A.COVID_OTR_CatgAlt_Key
				AND E.DimParameterName='Covid - OTR Category' 		
		WHERE FinalAssetClassAlt_Key =1  
		AND  ISNULL(Res_POS_to_CurrentPOS_Per,0)>=20 
		---and RestructureStage in('NPA-STD','STD-STD') 


/* 1- MSME_OLD AND MSME_COVID FRAMEWORK  */

		UPDATE A SET
				AddlProvPer= (CASE WHEN  FinalAssetClassAlt_Key>1 -- CURRENT NPA
											THEN  5
								   WHEN A.FinalAssetClassAlt_Key=1 AND isnull(PreRestructureAssetClassAlt_Key,0)>1  -- CURRENT STD -PRE RESTR NPA
										THEN isnull(PreRestructureNPA_Prov,0)+5
								   WHEN  A.FinalAssetClassAlt_Key=1 AND isnull(PreRestructureAssetClassAlt_Key,0)=1  -- CURRENT STD AND PRE RESTR NPA
										THEN (CASE WHEN FlgMorat ='Y' THEN 15 ELSE 5 END)
								END)
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('MSME_COVID','MSME_OLD')

		UPDATE A SET
				AddlProvPer= (CASE WHEN A.FinalAssetClassAlt_Key=1 AND isnull(PreRestructureAssetClassAlt_Key,0)>1  -- CURRENT STD -PRE RESTR NPA
										THEN isnull(PreRestructureNPA_Prov,0)+10
									ELSE  10 
								END)
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('MSME_COVID_RF2')

		--UPDATE A SET
		--		AddlProvPer= (CASE WHEN ParameterShortNameEnum='MSME_COVID_RF2' THEN 10 ELSE 5 END )
		--					+(CASE WHEN  A.FinalAssetClassAlt_Key=1 AND isnull(PreRestructureAssetClassAlt_Key,0)>1 
		--							THEN isnull(PreRestructureNPA_Prov,0) 
		--						  WHEN  A.FinalAssetClassAlt_Key>1 
		--								THEN 0 --ppliedNormalProvPer
		--							ELSE 0 
		--						END)
		--FROM PRO.AdvAcRestructureCal A
		--INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		--	AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
		--	AND D.DimParameterName='TypeofRestructuring' 
		--	AND d.ParameterShortNameEnum IN('MSME_COVID','MSME_OLD','MSME_COVID_RF2')
		---WHERE --DPD_Breach_Date IS NULL OR DPD_Breach_Date>SP_ExpiryDate
			--FinalAssetClassAlt_Key=1

	/* RELEASE */
		UPDATE A SET
				ProvReleasePer=AddlProvPer
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('MSME_COVID','MSME_OLD')
		WHERE( DPD_Breach_Date IS NULL AND SP_ExpiryDate<@DATE)
			AND FinalAssetClassAlt_Key=1 -----???

		------/* MSME_COVID_RF2 */	
		------UPDATE A SET
		------		AddlProvPer=10 +isnull(AppliedNormalProvPer,0)
		------FROM PRO.AdvAcRestructureCal A
		------INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		------	AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
		------	AND D.DimParameterName='TypeofRestructuring' 
		------	AND d.ParameterShortNameEnum IN('MSME_COVID_RF2')
			
	/* RELASE MSME_COVID_RF2 */	
		UPDATE A SET
				ProvReleasePer=AddlProvPer
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('MSME_COVID_RF2')
		WHERE ( DPD_Breach_Date IS NULL AND SP_ExpiryDate<@DATE)
	
	/* PRUDENTIAL */
		UPDATE A SET
				AddlProvPer=15
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('PRUDENTIAL')
		WHERE ((DPD_Breach_Date IS NOT NULL and SP_ExpiryDate>=@DATE) OR POS_10PerPaidDate IS NULL )
			AND FinalAssetClassAlt_Key >1

		UPDATE A SET
				AddlProvPer=5
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('PRUDENTIAL')
		WHERE SurvPeriodEndDate>@DATE
			AND FinalAssetClassAlt_Key =1

/* IRAC / OTHER */
		UPDATE A SET
				AddlProvPer=5
		FROM PRO.AdvAcRestructureCal A
		INNER JOIN ADVACRESTRUCTUREDETAIL B
			ON B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
			AND A.AccountEntityId =B.AccountEntityId
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
			AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			AND D.DimParameterName='TypeofRestructuring' 
			AND d.ParameterShortNameEnum IN('IRAC','OTHER')
		WHERE FinalAssetClassAlt_Key=1
			AND A.SurvPeriodEndDate IS NOT NULL AND A.SurvPeriodEndDate>=@DATE
			--??? DCCO  CONDITION



	/* CALCULATE FINAL PROVISION PERCENTAGE */
	UPDATE A SET FinalProvPer=(isnull(AddlProvPer,0)-isnull(ProvReleasePer,0))-
				(CASE WHEN (ISNULL(D.ParameterShortNameEnum,'') ='PRUDENTIAL' AND A.FinalAssetClassAlt_Key>1 )
						OR (ISNULL(D.ParameterShortNameEnum,'') IN('MSME_COVID','MSME_OLD','MSME_COVID_RF2') AND FinalAssetClassAlt_Key <>1 )
							THEN 0
						ELSE ISNULL(AppliedNormalProvPer,0)
				END)
		FROM pro.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
		AND D.DimParameterName='TypeofRestructuring' 
					

	--UPDATE A SET FinalProvPer=(isnull(AddlProvPer,0)-isnull(ProvReleasePer,0))-ISNULL(AppliedNormalProvPer,0)
	--	FROM pro.AdvAcRestructureCal A
		UPDATE A SET FinalProvPer=100
		FROM pro.AdvAcRestructureCal A WHERE FinalProvPer>=100

		UPDATE A SET FinalProvPer=0
		FROM pro.AdvAcRestructureCal A WHERE FinalProvPer<=0


		/* FOR RESTR FACILITY - FITL  THEN NO PROVISION WILL COMPUTED - AS PEPR EMAIL DTD 23-09-2021 OBS POINT MO.17(LAS OBS) IN ATTACHED EXCEL FILE */
		UPDATE A
			SET A.AddlProvPer=0,ProvReleasePer =0,FinalProvPer =0
		FROM pro.AdvAcRestructureCal A
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		AND D.ParameterAlt_Key=A.RestructureFacilityTypeAlt_Key
		AND D.DimParameterName='RestructureFacility' 
		and d.ParameterShortNameEnum='FITL'



	/*  CALCULATE RESTRUCTURE PROVISION */
	UPDATE A SET A.SecuredProvision=isnull(B.SecuredAmt,0)*isnull((FinalProvPer),0)/100 
				,A.UnSecuredProvision=isnull(B.UnSecuredAmt,0)*isnull((FinalProvPer),0)/100 
		from pro.AdvAcRestructureCal A
			inner join PRO.ACCOUNTCAL B
				ON A.AccountEntityId=B.AccountEntityID
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
		and D.DimParameterName='TypeofRestructuring' 
		AND ISNULL(D.ParameterShortNameEnum,'')<>'MSME_OLD' 

	UPDATE A SET A.RestructureProvision=isnull(SecuredProvision,0)+isnull(UnSecuredProvision,0)
		from pro.AdvAcRestructureCal A

		/* IN CASE OF MSME OLD PROVISION CALCULATION ON CURRENT POS  */	
	UPDATE A SET A.RestructureProvision=ISNULL(RestructureProvision,0)+isnull(A.CurrentPOS,0)*isnull((FinalProvPer),0)/100 
		from pro.AdvAcRestructureCal A
			inner join PRO.ACCOUNTCAL B
				ON A.AccountEntityId=B.AccountEntityID
		INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
		AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
		and D.DimParameterName='TypeofRestructuring' 
		AND ISNULL(D.ParameterShortNameEnum,'')='MSME_OLD' 

	/* ADD RESTRUCTURE PROVIISION IN TOTAL PROVIISION */
	UPDATE A
		SET A.TotalProvision=ISNULL(TotalProvision,0)+ISNULL(RestructureProvision,0)
	FROM PRO.ACCOUNTCAL  A
		INNER JOIN PRO.AdvAcRestructureCal B
			ON A.AccountEntityID =B.AccountEntityId

	 UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=NetBalance WHERE ISNULL(TOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0


	 	UPDATE A	
		SET A.FlgDeg ='N'
		from PRO.AdvAcRestructureCal A
			INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@tIMEKEY AND D.EffectiveToTimeKey>=@tIMEKEY 
							AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				and A.FlgDeg='Y'
		WHERE  D.DimParameterName='TypeofRestructuring' 
			AND ParameterShortNameEnum NOT IN('PRUDENTIAL','IRAC','OTHER')

/* END OF RESTRUCTURE */ 
  	/* PUI PROVISION WORK */	
	/* PROVISION */
	UPDATE A
		SET A.FinalAssetClassAlt_Key =b.FinalAssetClassAlt_Key
	FROM PRO.PUI_CAL A
		inner join pro.ACCOUNTCAL b
			on a.AccountEntityId=b.AccountEntityId
			
	UPDATE A
		SET PUI_ProvPer=(5-ISNULL(p.ProvisionSecured,0))
	FROM PRO.PUI_CAL A
		INNER JOIN PRO.ACCOUNTCAL b
			on a.AccountEntityId=b.AccountEntityId
		lEFT JOIN DimProvision_SegStd p
			ON (p.EffectiveFromTimeKey<=@TimeKey aNd p.EffectiveToTimeKey>=@TimeKey)
			AND P.ProvisionAlt_Key=b.ProvisionAlt_Key
		WHERE RESTRUCTURING='Y'
			AND dateadd(YY,2,a.RestructureDate)>=@DATE
			and a.FinalAssetClassAlt_Key=1


		UPDATE A 
			 SET A.SecuredProvision=isnull(B.SecuredAmt,0)*isnull((PUI_ProvPer),0)/100 
				,A.UnSecuredProvision=isnull(B.UnSecuredAmt,0)*isnull((PUI_ProvPer),0)/100 
		from PRO.PUI_CAL A
			InNeR JOIn PRO.ACCOUNTCAL b
				on a.AccountEntityId=b.AccountEntityId	
		 where isnull(PUI_ProvPer,0)>0

	UPDATE A
		SET A.TotalProvision=ISNULL(TotalProvision,0)+(ISNULL(b.SecuredProvision,0)+ISNULL(b.UnSecuredProvision,0))
	FROM PRO.ACCOUNTCAL  A
		INNER JOIN PRO.PUI_CAL B
			ON A.AccountEntityID =B.AccountEntityId
		WHERE ISNULL(PUI_ProvPer,0)>0

		UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=NetBalance WHERE ISNULL(TOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0

		update PRO.ACCOUNTCAL set TotalProvision=0 ,Provsecured=0,ProvDFV=0,ProvUnsecured=0,ProvCoverGovGur=0,AddlProvision=0,
		BankProvsecured=0,BankProvUnsecured=0,BankTotalProvision=0,RBIProvsecured=0,RBIProvUnsecured=0,RBITotalProvision=0
		 where FacilityType  IN ('LC','BG','NF') and FINALASSETCLASSALT_KEY=1

/* END OF PUI PROV WORK */ 


/* RESOLUTION PLAN - PROVISION */

		UPDATE A         --- ALL THE CONDITION TO BE CHANGED AND CHECKED HERE BEFORE FINAL DEPLOYMENT
		SET  TotalProvision = TotalProvision+(A.NetBalance*
								(CASE 
										WHEN (ISNULL(RPDescription,'')<>'IBC') 
											AND DATEDIFF(DD,B.RP_ImplDate,GETDATE()) BETWEEN 2 AND 154
												THEN 20.00

										WHEN (ISNULL(RPDescription,'')<>'IBC') 
											AND DATEDIFF(DD,B.RP_ImplDate,GETDATE()) >154
												THEN 35.00

										WHEN (ISNULL(RPDescription,'')='IBC') 
											AND B.IBCFillingDate IS NOT NULL
											AND B.IBCAddmissionDate IS NULL
											AND DATEDIFF(DD,B.RP_ImplDate,GETDATE()) BETWEEN 2 AND 154
												THEN 10.00

										WHEN (ISNULL(RPDescription,'')='IBC') 
											AND B.IBCFillingDate IS NOT NULL
											AND B.IBCAddmissionDate IS NULL
											AND DATEDIFF(DD,B.RP_ImplDate,GETDATE()) >154
												THEN 17.50
									END	)/100	)
		FROM PRO.AccountCal A  
			INNER JOIN RP_Portfolio_Details B
				ON B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
				AND A.CustomerEntityID=B.CustomerEntityID
			INNER JOIN DimResolutionPlanNature C
				ON C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
				AND B.RPNatureAlt_Key=C.RPNatureAlt_Key
		WHERE B.Actual_Impl_Date is null

--SELECT * FROM DimResolutionPlanNature

--select IBCFillingDate,IBCAddmissionDate, from RP_Portfolio_Details

--select * from dimparameter where DimParameterName like '%nature%'


/* END OF RESOLUTION PLAN PROV */
 IF OBJECT_ID('TEMPDB..#TOTALPROVCUST') IS NOT NULL
     DROP TABLE #TOTALPROVCUST

SELECT					CUSTOMERENTITYID,
						SUM(ISNULL(TOTALPROVISION,0)) TOTALPROVISION, 
						SUM(ISNULL(BANKTOTALPROVISION,0)) BANKTOTPROVISION ,
						SUM(ISNULL(RBITOTALPROVISION,0)) RBITOTPROVISION 
						INTO #TOTALPROVCUST  FROM PRO.ACCOUNTCAL
GROUP BY CUSTOMERENTITYID


UPDATE A SET A.TOTPROVISION=B.TOTALPROVISION,A.BANKTOTPROVISION=B.BANKTOTPROVISION,A.RBITOTPROVISION=B.RBITOTPROVISION
FROM PRO.CUSTOMERCAL A INNER JOIN #TOTALPROVCUST B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID

DROP TABLE #TOTALPROVCUST

UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='UpdationTotalProvision'

	-----------------Added for DashBoard 04-03-2021
Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

END TRY
BEGIN  CATCH

	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='UpdationTotalProvision'
END CATCH  
   SET NOCOUNT OFF                   
END 






GO
