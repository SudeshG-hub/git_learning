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
CREATE PROCEDURE [PRO].[UpdationTotalProvision]              
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

/* IRAC / OTHER */
            /* FOR IRAC */
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

            /*FOR  NATURAL CALAMITY */          
            UPDATE A SET
                        AddlProvPer=5
            FROM PRO.AdvAcRestructureCal A
            INNER JOIN ADVACRESTRUCTUREDETAIL B
                  ON B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
                  AND A.AccountEntityId =B.AccountEntityId
            INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
                  AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
                  AND D.DimParameterName='TypeofRestructuring' 
                  AND isnull(d.ParameterShortNameEnum,'') NOT IN('IRAC','OTHER')
            inner join pro.ACCOUNTCAL ac
                  on ac.AccountEntityID=a.AccountEntityId
            WHERE a.FinalAssetClassAlt_Key=1
                  and ac.DPD_Max=0


      /* CALCULATE FINAL PROVISION PERCENTAGE */
      UPDATE A SET FinalProvPer=(isnull(AddlProvPer,0)-ISNULL(AppliedNormalProvPer,0))
            FROM pro.AdvAcRestructureCal A
            INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
            AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
            AND D.DimParameterName='TypeofRestructuring' 
                              

            UPDATE A SET FinalProvPer=100
            FROM pro.AdvAcRestructureCal A WHERE FinalProvPer>=100

            UPDATE A SET FinalProvPer=0
            FROM pro.AdvAcRestructureCal A WHERE FinalProvPer<=0


      /*  CALCULATE RESTRUCTURE PROVISION */
      UPDATE A SET A.SecuredProvision=isnull(B.SecuredAmt,0)*isnull((FinalProvPer),0)/100 
                        ,A.UnSecuredProvision=isnull(B.UnSecuredAmt,0)*isnull((FinalProvPer),0)/100 
            from pro.AdvAcRestructureCal A
                  inner join PRO.ACCOUNTCAL B
                        ON A.AccountEntityId=B.AccountEntityID
            INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
            AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
            and D.DimParameterName='TypeofRestructuring' 
            --------AND ISNULL(D.ParameterShortNameEnum,'')<>'MSME_OLD' 

      UPDATE A SET A.RestructureProvision=isnull(SecuredProvision,0)+isnull(UnSecuredProvision,0)
            from pro.AdvAcRestructureCal A


      /* ADD RESTRUCTURE PROVIISION IN TOTAL PROVIISION */
      UPDATE A
            SET A.TotalProvision=ISNULL(TotalProvision,0)+ISNULL(RestructureProvision,0)
      FROM PRO.ACCOUNTCAL  A
            INNER JOIN PRO.AdvAcRestructureCal B
                  ON A.AccountEntityID =B.AccountEntityId

       UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=NetBalance WHERE ISNULL(TOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0


/* END OF RESTRUCTURE */ 
      /* PUI PROVISION WORK */      
      /* PROVISION */
      UPDATE A
            SET A.FinalAssetClassAlt_Key =b.FinalAssetClassAlt_Key
      FROM PRO.PUI_CAL A
            INNER JOIN pro.ACCOUNTCAL b
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
                                                                              END   )/100 
                                                                        )
            FROM PRO.AccountCal A  
                  INNER JOIN RP_Portfolio_Details B
                        ON B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
                        AND A.RefCustomerID=B.CustomerID
                  INNER JOIN DimResolutionPlanNature C
                        ON C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
                        AND B.RPNatureAlt_Key=C.RPNatureAlt_Key
            WHERE B.Actual_Impl_Date is null

-------------Logic added 12082022 Sudesh for 100% + Provisions
update Pro.Accountcal set TotalProvision = NetBalance where TotalProvision >  Netbalance
/* END OF RESOLUTYION PLAN - PROVISION WORK */

/*   INDUSTRY SPECIFIC - PROVISION WORK */

 UPDATE B SET B.TotalProvision=ISNULL(B.TotalProvision,0) + (isnull(B.SecuredAmt,0)*isnull((ProvisionRate),0)/100) 
                        + (isnull(B.UnSecuredAmt,0)*isnull((ProvisionRate),0)/100 )
           from DimIndustrySpecific A
                  inner join PRO.ACCOUNTCAL B
                        ON A.CIF=B.RefCustomerID
            --INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey              
            WHERE B.FinalAssetClassAlt_key = 1 and A.EffectiveFromTimeKey <=@timekey AND A.EffectiveToTimeKey>=@timekey   
            --------AND ISNULL(D.ParameterShortNameEnum,'')<>'MSME_OLD' 

      UPDATE A SET A.RestructureProvision=isnull(SecuredProvision,0)+isnull(UnSecuredProvision,0)
            from pro.AdvAcRestructureCal A


     

       UPDATE PRO.ACCOUNTCAL SET TOTALPROVISION=NetBalance WHERE ISNULL(TOTALPROVISION,0)>NetBalance AND ISNULL(NetBalance,0)>0


/* END OF  INDUSTRY SPECIFIC - PROVISION WORK */




 IF OBJECT_ID('TEMPDB..#TOTALPROVCUST') IS NOT NULL
     DROP TABLE #TOTALPROVCUST

SELECT                              CUSTOMERENTITYID,
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
