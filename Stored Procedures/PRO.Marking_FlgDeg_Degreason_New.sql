SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*=========================================
 AUTHER : TRILOKI KHANNA
 CREATE DATE : 27-11-2019
 MODIFY DATE : 27-11-2019
 DESCRIPTION : MARKING OF FLGDEG AND DEG REASON 
 --EXEC [Pro].[Marking_FlgDeg_Degreason] @TIMEKEY=26477
=============================================*/
CREATE PROCEDURE [PRO].[Marking_FlgDeg_Degreason_New]
@TIMEKEY INT
AS
BEGIN
  SET NOCOUNT ON 
   BEGIN TRY
DECLARE @ProcessDate DATE=(SELECT DATE FROM SYSDAYMATRIX WHERE TimeKey=@TIMEKEY)

/*---------------INTIAL LEVEL FLG DEG SET N------------------------------------------*/

UPDATE A SET A.FLGDEG='N'
FROM PRO.AccountCal A

/*---------------UPDATE DEG FLAG AT CUSTOMER LEVEL------------------------------------*/

UPDATE B SET B.FlgDeg='N' FROM   PRO.CustomerCal B 

/*---------------UPDATE DEG FLAG AT ACCOUNT LEVEL-----------------------------------------*/
UPDATE A SET A.FLGDEG  =(CASE WHEN  ISNULL(A.DPD_INTSERVICE,0)>=A.REFPERIODINTSERVICE  THEN 'Y' 
							WHEN   ISNULL(A.DPD_OVERDRAWN,0)>=A.REFPERIODOVERDRAWN    THEN 'Y' 
							WHEN   ISNULL(A.DPD_NOCREDIT,0)>=A.REFPERIODNOCREDIT      THEN 'Y'
                            WHEN   ISNULL(A.DPD_OVERDUE,0) >=A.REFPERIODOVERDUE       THEN 'Y' 
                            WHEN   ISNULL(A.DPD_STOCKSTMT,0)>=A.REFPERIODSTKSTATEMENT THEN 'Y' 
							WHEN   ISNULL(A.DPD_RENEWAL,0)>=A.REFPERIODREVIEW         THEN 'Y'
						ELSE 'N'  END)
FROM PRO.ACCOUNTCAL A   INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE  (a.FinalAssetClassAlt_Key IN(SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortNameEnum IN('STD') and EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY))
AND (ISNULL(A.Asset_Norm,'NORMAL')<>'ALWYS_STD') 
AND (B.FlgProcessing='N')
AND ISNULL(InMonthMark,'N')='Y'
AND ISNULL(B.FlgMoc,'N')='N' 
--AND ISNULL(A.Balance,0)>0
AND A.FacilityType NOT IN ('LC','BG','NF')

UPDATE A SET A.FLGDEG='Y'
FROM PRO.ACCOUNTCAL A  
WHERE InttServiced='N' and FinalAssetClassAlt_Key=1
AND A.FacilityType not IN ('LC','BG','NF')

UPDATE pro.ACCOUNTCAL SET FLGDEG='N'
 from pro.ACCOUNTCAL
where FLGDEG='Y' 
--and FacilityType='TL'
and 
(
isnull(IntOverdue,0)=0
and
isnull(PrincOverdue,0)=0
and
isnull(OtherOverdue,0)=0
and
isnull(OverdueAmt,0)=0
and  
isnull(balance,0)=0
)

/* RESTRUCTURE DEGRADE */


		/* UPDATE DPD_Breach_Date FOR 'RESOLUTION'  */
		UPDATE A
			SET DPD_Breach_Date=@ProcessDate
				,ZeroDPD_Date=null
				,SP_ExpiryExtendedDate=null
		FROM  PRO.AdvAcRestructureCal A
			INNER JOIN PRO.ACCOUNTCAL B
				ON A.AccountEntityId =B.AccountEntityID
			INNER JOIN DimParameter D 
				ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
				AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				AND D.DimParameterName='TypeofRestructuring' 
		WHERE DPD_Breach_Date IS NULL
			AND D.ParameterShortNameEnum IN('COVID_OTR_RF','COVID_OTR_RF_2')
			AND(   (FacilityType NOT IN('CC','OD') AND ISNULL(DPD_MaxFin,0)>30)
					OR (FacilityType IN('CC','OD') AND ISNULL(B.DPD_Overdrawn,0)>60
					   )
				)
		/* update DPD_Breach_Date -  'MSME_OLD','MSME_COVID' */	
		UPDATE A
			SET DPD_Breach_Date=@ProcessDate
				,ZeroDPD_Date=null
				,SP_ExpiryExtendedDate=null
		FROM  PRO.AdvAcRestructureCal A
			INNER JOIN PRO.ACCOUNTCAL B
				ON A.AccountEntityId =B.AccountEntityID
			INNER JOIN DimParameter D 
				ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
				AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				AND D.DimParameterName='TypeofRestructuring' 
		WHERE DPD_Breach_Date IS  NULL
			AND D.ParameterShortNameEnum IN('MSME_OLD','MSME_COVID','MSME_COVID_RF2')
			AND ( ISNULL(DPD_MaxNonFin,0)>=90 OR ISNULL(DPD_MaxFin,0)>30 )


		UPDATE A
			SET ZeroDPD_Date=@ProcessDate
		FROM  PRO.AdvAcRestructureCal A
			INNER JOIN PRO.ACCOUNTCAL B
				ON A.AccountEntityId =B.AccountEntityID
			INNER JOIN DimParameter D 
				ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
				AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				AND D.DimParameterName='TypeofRestructuring' 
		WHERE DPD_Breach_Date IS NOT NULL
			AND D.ParameterShortNameEnum IN('MSME_OLD','MSME_COVID','MSME_COVID_RF2')
			AND ( ISNULL(DPD_MaxNonFin,0)<90 AND ISNULL(DPD_MaxFin,0)<=30)
			AND ZeroDPD_Date IS NULL 
			AND  (CASE WHEN ISNULL(SP_ExpiryDate,'1900-01-01')>=ISNULL(SP_ExpiryExtendedDate,'1900-01-01') 
							THEN SP_ExpiryDate ELSE SP_ExpiryExtendedDate END)> @ProcessDate

		UPDATE A
			SET SP_ExpiryExtendedDate=CASE WHEN SP_ExpiryDate < DATEADD(yy,1,@ProcessDate)
												THEN DATEADD(yy,1,@ProcessDate)
											ELSE  NULL END
		FROM  PRO.AdvAcRestructureCal A
			INNER JOIN PRO.ACCOUNTCAL B
				ON A.AccountEntityId =B.AccountEntityID
			INNER JOIN DimParameter D 
				ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
				AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				AND D.DimParameterName='TypeofRestructuring' 
		WHERE DPD_Breach_Date IS NOT NULL
			AND D.ParameterShortNameEnum IN('MSME_OLD','MSME_COVID','MSME_COVID_RF2')
			and ZeroDPD_Date=@ProcessDate


		/* update DPD_Breach_Date -  'PRUDENTIAL','IRAC','OTHER' */
		UPDATE A
			SET DPD_Breach_Date=@ProcessDate
				,ZeroDPD_Date=null
				,SP_ExpiryExtendedDate=null
		FROM  PRO.AdvAcRestructureCal A
			INNER JOIN PRO.ACCOUNTCAL B
				ON A.AccountEntityId =B.AccountEntityID
			INNER JOIN DimParameter D 
				ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
				AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
				AND D.DimParameterName='TypeofRestructuring' 
		WHERE DPD_Breach_Date IS NULL
			AND D.ParameterShortNameEnum IN('PRUDENTIAL','IRAC','OTHER')
			AND ( 
					(FacilityType NOT IN('CC','OD') AND  ISNULL(DPD_MaxFin,0)>0 )
				  OR( 
						(FacilityType IN('CC','OD') 
							AND (ISNULL(DPD_MaxFin,0)>=30 OR ISNULL(DPD_MaxNonFin,0)>=90)
						) 
					)
				)


  /*  RESOLUTION  COVID- PERAONl AND OTHERS */
		UPDATE A SET FlgDeg='Y'
					--,DegDate=CASE WHEN PreRestructureNPA_Date IS NOT NULL 
					--				THEN PreRestructureNPA_Date
					--			ELSE 
					--					A.RestructureDt
					--			END
					,A.DegReason=CASE WHEN Res_POS_to_CurrentPOS_Per<=30
										THEN 'Restructured slippage'
									ELSE '' END
		from PRO.AdvAcRestructureCal A
			INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
							AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
							AND D.DimParameterName='TypeofRestructuring' 
			INNER JOIN DimParameter E ON E.EffectiveFromTimeKey <=@timekey AND E.EffectiveToTimeKey>=@timekey 
							AND E.ParameterAlt_Key=A.COVID_OTR_CatgAlt_Key
							AND D.DimParameterName='Covid - OTR Category' 
			inner join pro.ACCOUNTCAL ac
				on a.AccountEntityId =ac.AccountEntityID
		WHERE D.ParameterShortNameEnum IN('COVID_OTR_RF','OVID_OTR_RF_2')
			 AND A.FinalAssetClassAlt_Key=1
			AND (	(E.ParameterShortNameEnum ='PERSONAL' and ac.FlgDeg='Y')
				  OR (E.ParameterShortNameEnum ='OTHER' AND DPD_Breach_Date IS NOT NULL  and SP_ExpiryDate>@ProcessDate) 	
				)

/* 'MSME_OLD','MSME_COVID' */
		UPDATE A SET FlgDeg='Y'
					--,DegDate=CASE WHEN PreRestructureNPA_Date IS NOT NULL 
					--			THEN PreRestructureNPA_Date
					--		 ELSE 
					--			A.RestructureDt
					--		 END
					--,A.DegReason ='Restructured slippage'
		from PRO.AdvAcRestructureCal A
			INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
							AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			INNER JOIN PRO.ACCOUNTCAL AC
				ON A.AccountEntityId=AC.AccountEntityId
				and ac.FlgDeg='Y'
		WHERE  D.DimParameterName='TypeofRestructuring' 
			AND ParameterShortNameEnum IN('MSME_OLD','MSME_COVID','MSME_COVID_RF2')
			and A.FinalAssetClassAlt_Key=1

/*  'IRAC' ,'OTHER','PRUDENTIAL' */
		UPDATE A SET FlgDeg='Y'
						--,DegDate=CASE WHEN PreRestructureNPA_Date IS NOT NULL 
						--		THEN PreRestructureNPA_Date 
						--	ELSE A.RestructureDt END
			from PRO.AdvAcRestructureCal A
			INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
								AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
			WHERE  D.DimParameterName='TypeofRestructuring' 
				AND ParameterShortNameEnum IN('IRAC' ,'OTHER','PRUDENTIAL')
				and FinalAssetClassAlt_Key=1
				--and (isnull(SP_ExpiryExtendedDate,SP_ExpiryDate)>@ProcessDate
				--	)


	UPDATE A
		SET A.FlgDeg=B.FlgDeg
	--	   ,A.FinalNpaDt=B.DegDate
	--	   ,DegReason=ISNULL(a.DegReason,'')+',DEGRADE BY RESTRUCTURE'	
	FROM PRO.ACCOUNTCAL A
		INNER JOIN PRO.AdvAcRestructureCal B
			ON A.AccountEntityID =B.AccountEntityId
	WHERE B.FlgDeg='Y'
		and a.FinalAssetClassAlt_Key=1
		
	
/*END OF RFESTR WORK */


/* START OF PUI WORK*/

---The NPA reason in this case will be “Original DCCO is Crossed */
DECLARE @DysOfDelay int=90
		---FinnalDCCO_Date   - Original DCCO, CIO DCCO and FreshDCCO
UPDATE A
			SET DEFAULT_REASON=	
					CASE 
						/* 1. The original DCCO or CIO_DCCO whichever is higher is passed more than -90- days and revised DCCO is blank and Actual DCCO is blank. The NPA reason in this case will be “Original DCCO/ CIO_DCCO is Crossed” (Put case to find which date is applicable)*/
						WHEN ( DATEDIFF(DD,FinnalDCCO_Date, @ProcessDate)>@DysOfDelay 
									AND RevisedDCCO IS NULL 
									
								) 
								THEN 'Original DCCO/ CIO_DCCO is Crossed'

						/*2. Original DCCO is passed and revised DCCO is also passed more than -90 days and Actual DCCO is blank. The NPA reason in this case will be “Revised DCCO is crossed” */
						WHEN ( FinnalDCCO_Date<@ProcessDate
									AND RevisedDCCO IS NOT NULL AND DATEDIFF(DD,RevisedDCCO,@ProcessDate )>90
								) 
								THEN 'Revised DCCO is crossed'

						/*3. In case of Revised DCCO is not blank and Cost Overrun % is more than 10% or Revised DE ratio is higher than Original DE ratio, the NPA Reason in this case would be “Cost Overrun or Revised DE Ration is more than Permissible Limits”   */	
						WHEN ( RevisedDCCO IS NOT NULL AND CostOverrun='Y'  
										AND (
												(isnull(CostOverRunPer,0)>10 )
												OR (isnull(RevisedDebt,0)>isnull(OriginalDebt,0))
											)
										AND (DATEADD(YY,(CASE WHEN ProjCategory='Infra' THEN  2 ELSE 1 END),FinnalDCCO_Date)>RevisedDCCO  
												AND DATEADD(YY,(CASE WHEN ProjCategory='Infra' THEN  4 ELSE 2 END),FinnalDCCO_Date)<RevisedDCCO )
										-- add condition for infra 2/4 and non infra 1/2 yr and non 
								)
								THEN  'Cost Overrun or Revised DE Ratio is more than Permissible Limits'
									
						WHEN ( TakeOutFinance='Y' AND AssetClassSellerBookAlt_key>1
								)
								THEN 'The account is NPA in sellers book'
					END
	FROM PRO.PUI_cAL A						
		WHERE FinalAssetClassAlt_Key=1
			AND ActualDCCO_Date IS NULL 

		UPDATE A
				 SET RESTRUCTURING='Y'
				 , RestructureDate=@ProcessDate
		FROM  PRO.PUI_CAL A
		WHERE (BeyonControlofPromoters='Y' OR CourtCaseArbitration='Y')
			AND RevisedDCCO<=DATEADD(YY,(CASE WHEN ProjCategory='Infra' THEN  2 ELSE 1 END),FinnalDCCO_Date)
					

		UPDATE A
			SET A.FLG_DEG ='Y'
				,A.NPA_DATE=@ProcessDate
		FROM PRO.PUI_cAL A
			WHERE isnull(DEFAULT_REASON,'')<>''

/* END  OF PUI WORK*/





 /* ------------------------UPDATE DEG FLAG AT CUSTOMER LEVEL----------------------------------*/

UPDATE B SET B.FlgDeg='Y' FROM PRO.ACCOUNTCAL A INNER JOIN  PRO.CustomerCal B 
ON A.RefCustomerID=B.RefCustomerID
WHERE A.FlgDeg='Y' AND (B.FlgProcessing='N')

 /*---------------------ASSIGNE DEG REASON------------------------------------------------------*/


UPDATE A SET A.DegReason= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY INT NOT SERVICED'   ELSE 'DEGRADE BY INT NOT SERVICED' END)
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND (A.DPD_INTSERVICE>=A.REFPERIODINTSERVICE OR A.InttServiced='N'))
 
UPDATE A SET A.DegReason= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY CONTI EXCESS'   ELSE 'DEGRADE BY CONTI EXCESS' END)
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND A.DPD_OVERDRAWN>=A.REFPERIODOVERDRAWN) 

UPDATE A SET DegReason= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY NO CREDIT'   ELSE 'DEGRADE BY NO CREDIT' END)  
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND A.DPD_NOCREDIT>=A.REFPERIODNOCREDIT ) 

UPDATE A SET DegReason= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY STOCK STATEMENT'   ELSE 'DEGRADE BY STOCK STATEMENT' END)    
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND A.DPD_STOCKSTMT>=A.REFPERIODSTKSTATEMENT) 

UPDATE A SET A.DEGREASON= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY REVIEW DUE DATE'   ELSE 'DEGRADE BY REVIEW DUE DATE' END)    
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND A.DPD_RENEWAL>=A.REFPERIODREVIEW) 

UPDATE A SET A.DegReason= (CASE WHEN ISNULL(A.DegReason,'') <> '' THEN ISNULL(A.DegReason,'')+',DEGRADE BY OVERDUE'   ELSE 'DEGRADE BY OVERDUE' END)             
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID =B.RefCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='Y' AND A.DPD_OVERDUE >=A.REFPERIODOVERDUE)

 UPDATE A SET DegReason=B.DegReason
 FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.SourceSystemCustomerID =B.SourceSystemCustomerID
WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='N')AND B.DegReason IS NOT NULL AND A.FinalAssetClassAlt_Key>1 AND A.DegReason IS NULL

 
	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='Marking_FlgDeg_Degreason'

	-----------------Added for DashBoard 04-03-2021
Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

END TRY
BEGIN  CATCH

	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='Marking_FlgDeg_Degreason'

END CATCH
SET NOCOUNT OFF
END







GO
