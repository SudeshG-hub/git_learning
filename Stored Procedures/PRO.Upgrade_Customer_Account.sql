SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*=========================================
 AUTHER : SUDESH GAMBHIRA
 CREATE DATE : 27-05-2022
 MODIFY DATE : 27-05-2022
 DESCRIPTION : FIRST UPGRADE TO CUSTOMER LEVEL  AFTER THAT ACCOUNT LEVEL
 [PRO].[Upgrade_Customer_Account] 25267 
=============================================*/


CREATE PROCEDURE [PRO].[Upgrade_Customer_Account]
@TIMEKEY INT
WITH RECOMPILE
AS
BEGIN
  SET NOCOUNT ON
   BEGIN TRY
 
 
/*=========================================
 AUTHOR : SUDESH GAMBHIRA
 CREATE DATE : 27-05-2022
 MODIFY DATE : 27-05-2022
 DESCRIPTION : Upgrade Calypso-Finacle Test Case Cover in This SP

RefCustomerID     TestCase
143   Reversefeed Upgradation
94    UPG-TL/DL - Ac Level: Eligible for Upgrade
96    UPG-Bills/ PC - Ac Level: Eligible for Upgradae
98    UPG-CC/OD: Eligible for Upgrade
95    UPG-TL/DL - Ac Level: Not Eligible for Upgrade
97    UPG-Bills/ PC - Ac Level: Not Eligible for Upgradae
99    UPG-CC/OD: Not Eligible for Upgrade
=============================================*/

/*check the customer when all account to cutomer dpdmax must be 0*/

DECLARE @PROCESSDATE DATE=(SELECT Date FROM SysDayMatrix WHERE TimeKey=@TIMEKEY)


UPDATE PRO.ACCOUNTCAL SET FLGUPG='N'
UPDATE PRO.CUSTOMERCAL SET FLGUPG='N'


IF OBJECT_ID('TEMPDB..#TEMPTABLE') IS NOT NULL
      DROP TABLE #TEMPTABLE

SELECT A.UCIF_ID,TOTALCOUNT  INTO #TEMPTABLE FROM 
(
SELECT A.UCIF_ID,COUNT(1) TOTALCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.UCIF_ID=B.UCIF_ID 
WHERE (A.FlgProcessing='N' ) AND A.UCIF_ID IS NOT NULL
AND B.Asset_Norm NOT IN ('ALWYS_STD')
GROUP BY A.UCIF_ID
)
A INNER JOIN 
(
SELECT A.UCIF_ID,COUNT(1) TOTALDPD_MAXCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.UCIF_ID=B.UCIF_ID
WHERE (B.DPD_INTSERVICE<=B.REFPERIODINTSERVICEUPG
   and B.DPD_NOCREDIT <=B.REFPERIODNOCREDITUPG
   and B.DPD_OVERDRAWN <=B.REFPERIODOVERDRAWNUPG
   and B.DPD_OVERDUE<=B.REFPERIODOVERDUEUPG
   and B.DPD_RENEWAL<=B.REFPERIODREVIEWUPG
   and B.DPD_STOCKSTMT <=B.REFPERIODSTKSTATEMENTUPG)
   and B.InitialAssetClassAlt_Key not in(1)
AND (A.FlgProcessing='N')
AND B.Asset_Norm NOT IN ('ALWYS_NPA','ALWYS_STD')
AND  ISNULL(A.MocStatusMark,'N')='N' 
AND A.UCIF_ID IS NOT NULL
AND ISNULL(B.UNSERVIEDINT,0)=0 
AND ISNULL(DerecognisedInterest1,0) = 0
AND  ISNULL(B.AccountStatus,'N')<>'Z'
GROUP BY A.UCIF_ID

) B ON A.UCIF_ID=B.UCIF_ID AND A.TOTALCOUNT=B.TOTALDPD_MAXCOUNT


  /*------ UPGRADING CUSTOMER-----------*/
  
UPDATE A SET A.FlgUpg='U'
FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLE B ON A.UCIF_ID=B.UCIF_ID
 INNER JOIN DIMASSETCLASS C ON C.AssetClassAlt_Key=A.SYSASSETCLASSALT_KEY AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
WHERE  (not(isnull(A.ASSET_NORM,'NORMAL')='ALWYS_NPA' ) AND  C.ASSETCLASSGROUP ='NPA' AND not(ISNULL(A.FLGDEG,'N')='Y')) 
AND (ISNULL(A.FlgProcessing,'N')='N')




IF OBJECT_ID('TEMPDB..#TEMPTABLE1') IS NOT NULL
      DROP TABLE #TEMPTABLE1

SELECT A.UCIF_ID,TOTALCOUNT  INTO #TEMPTABLE1 FROM 
(
SELECT A.UCIF_ID,COUNT(1) TOTALCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.UCIF_ID=B.UCIF_ID 
WHERE (A.FlgProcessing='N' ) AND A.UCIF_ID IS NOT NULL
AND B.Asset_Norm NOT IN ('ALWYS_STD')
GROUP BY A.UCIF_ID
)
A INNER JOIN 
(
SELECT A.UCIF_ID,COUNT(1) TOTALDPD_MAXCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.UCIF_ID=B.UCIF_ID
WHERE (B.DPD_INTSERVICE<=B.REFPERIODINTSERVICEUPG
  and B.DPD_NOCREDIT <=B.REFPERIODNOCREDITUPG
   and B.DPD_OVERDRAWN <=B.REFPERIODOVERDRAWNUPG
   and B.DPD_OVERDUE<=B.REFPERIODOVERDUEUPG
   and B.DPD_RENEWAL<=B.REFPERIODREVIEWUPG
   and B.DPD_STOCKSTMT <=B.REFPERIODSTKSTATEMENTUPG)
   and B.FinalAssetClassAlt_Key not in(1)
AND (A.FlgProcessing='N')
AND B.Asset_Norm NOT IN ('ALWYS_NPA','ALWYS_STD')
AND  ISNULL(A.MocStatusMark,'N')='N' 
AND ISNULL(B.UNSERVIEDINT,0)=0 
AND A.UCIF_ID IS NOT NULL
AND  ISNULL(B.AccountStatus,'N')<>'Z'
GROUP BY A.UCIF_ID

) B ON A.UCIF_ID=B.UCIF_ID AND A.TOTALCOUNT=B.TOTALDPD_MAXCOUNT



  /*------ UPGRADING CUSTOMER-----------*/


UPDATE A SET A.FlgUpg='U'
FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLE1 B ON A.UCIF_ID=B.UCIF_ID
 INNER JOIN DIMASSETCLASS C ON C.AssetClassAlt_Key=A.SYSASSETCLASSALT_KEY AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
WHERE  (not(isnull(A.ASSET_NORM,'NORMAL')='ALWYS_NPA' ) AND  C.ASSETCLASSGROUP ='NPA' AND not(ISNULL(A.FLGDEG,'N')='Y')) AND (ISNULL(A.FlgProcessing,'N')='N')



IF OBJECT_ID('TEMPDB..#TEMPTABLERefCustomerID') IS NOT NULL
      DROP TABLE #TEMPTABLERefCustomerID

SELECT A.RefCustomerID,TOTALCOUNT  INTO #TEMPTABLERefCustomerID FROM 
(
SELECT A.RefCustomerID,COUNT(1) TOTALCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.RefCustomerID=B.RefCustomerID 
WHERE (A.FlgProcessing='N' ) AND A.UCIF_ID IS  NULL 
 and A.RefCustomerID is not null
 AND B.Asset_Norm NOT IN ('ALWYS_STD')
GROUP BY A.RefCustomerID
)
A INNER JOIN 
(
SELECT A.RefCustomerID,COUNT(1) TOTALDPD_MAXCOUNT FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.RefCustomerID=B.RefCustomerID
WHERE (B.DPD_INTSERVICE<=B.REFPERIODINTSERVICEUPG
   and B.DPD_NOCREDIT <=B.REFPERIODNOCREDITUPG
   and B.DPD_OVERDRAWN <=B.REFPERIODOVERDRAWNUPG
   and B.DPD_OVERDUE<=B.REFPERIODOVERDUEUPG
   and B.DPD_RENEWAL<=B.REFPERIODREVIEWUPG
   and B.DPD_STOCKSTMT <=B.REFPERIODSTKSTATEMENTUPG)
   and B.InitialAssetClassAlt_Key not in(1)
AND (A.FlgProcessing='N')
AND B.Asset_Norm NOT IN ('ALWYS_NPA','ALWYS_STD')
AND  ISNULL(A.MocStatusMark,'N')='N' 
AND ISNULL(B.UNSERVIEDINT,0)=0 
AND A.UCIF_ID IS  NULL 
AND A.RefCustomerID is not null
GROUP BY A.RefCustomerID

) B ON A.RefCustomerID=B.RefCustomerID AND A.TOTALCOUNT=B.TOTALDPD_MAXCOUNT


  /*-----------UPGRADING CUSTOMER----------*/


UPDATE A SET A.FlgUpg='U'
FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLERefCustomerID B ON A.RefCustomerID=B.RefCustomerID
 INNER JOIN DIMASSETCLASS C ON C.AssetClassAlt_Key=A.SYSASSETCLASSALT_KEY AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
WHERE  (not(isnull(A.ASSET_NORM,'NORMAL')='ALWYS_NPA' ) AND  C.ASSETCLASSGROUP ='NPA' AND not(ISNULL(A.FLGDEG,'N')='Y')) AND (ISNULL(A.FlgProcessing,'N')='N')



-------Changes done in case of Same Pan Number One Customer Upgrade and One Npa To handle that Issue ---

IF OBJECT_ID('TEMPDB..#PANUPDATEUPGRADE') IS NOT NULL
DROP TABLE #PANUPDATEUPGRADE

SELECT A.PANNO,A.TotalCountMAX,B.TotalCount
INTO #PANUPDATEUPGRADE
FROM
(

SELECT Count(1) TotalCountMAX,PANNO FROM PRO.CUSTOMERCAL WHERE PANNO IS NOT NULL
GROUP BY PANNO
) A
INNER JOIN
(
SELECT Count(1) TotalCount,PANNO FROM PRO.CUSTOMERCAL WHERE PANNO IS NOT NULL AND FLGUPG='U'
GROUP BY PANNO

) B ON A.PANNO=B.PANNO AND A.TotalCountMAX <> B.TotalCount


UPDATE B SET FLGUPG='N' from #PANUPDATEUPGRADE A
INNER JOIN PRO.CustomerCal B
ON A.PANNO=B.PANNO
WHERE B.FLGUPG='U'





/* RESTR UPGRADE */
      UPDATE A SET FLGUPG= CASE WHEN SP_ExpiryDate>=@PROCESSDATE
                                                THEN 'N'
                                          ELSE
                                                C.FlgUpg
                                          END
      from PRO.AdvAcRestructureCal A
      INNER JOIN PRO.ACCOUNTCAL B
            ON A.AccountEntityId=B.AccountEntityID
      INNER JOIN PRO.CUSTOMERCAL C
            ON C.CustomerEntityID =B.CustomerEntityID
      INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
                                    AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
      WHERE  D.DimParameterName='TypeofRestructuring' 
            AND ParameterShortNameEnum IN('IRAC','OTHER')
            AND C.FlgUpg ='U'

      UPDATE C 
            SET FLGUPG= 'N'
            ,C.DegReason=',DEGRADEY BY RESTRUCTURE'
      from PRO.AdvAcRestructureCal A
            INNER JOIN PRO.ACCOUNTCAL B
                  ON A.AccountEntityId=B.AccountEntityID
            INNER JOIN PRO.CUSTOMERCAL C
                  ON C.CustomerEntityID =B.CustomerEntityID
            INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey 
                  AND D.ParameterAlt_Key=A.RestructureTypeAlt_Key
                  AND D.DimParameterName='TypeofRestructuring' 
      WHERE A.FlgUpg ='N' AND C.FlgUpg ='U'
             AND ParameterShortNameEnum IN('IRAC','OTHER')

/* END OF RESTR UPGRADE */

/*pui UPGRADE */
DECLARE @DysOfDelay TINYINT=90
            UPDATE A
                  SET A.FLG_UPG =         CASE 
                                                      WHEN ActualDCCO_Date IS NOT NULL
                                                            
                                                                        OR RevisedDCCO >@PROCESSDATE
                                                                        OR (RevisedDCCO IS NULL AND FinnalDCCO_Date>@PROCESSDATE)
                                                              
                                                                        AND (
                                                                                    (Isnull(CostOverRunPer,0)<=10)
                                                                                    OR (isnull(RevisedDebt,0)<=isnull(OriginalDebt,0))
                                                                               )
                                                                  THEN 'U'                            
                                                      WHEN ( TakeOutFinance='N' ---AND AssetClassSellerBookAlt_key>1
                                                             )
                                                                  THEN 'U'
                                                END
                        
            FROM PRO.PUI_CAL A
                  INNER JOIN PRO.ACCOUNTCAL B
                        ON A.AccountEntityID=B.AccountEntityID
                  WHERE b.FinalAssetClassAlt_Key>1
                  AND B.DPD_Max=0 AND B.FlgUpg ='U'

      UPDATE C 
            SET FLGUPG= 'N'
      from PRO.PUI_CAL A
            INNER JOIN pro.CUSTOMERCAL C
                  ON C.CustomerEntityID =A.CustomerEntityID
      WHERE A.Flg_Upg ='N' AND C.FlgUpg ='U'

      /*END OF PUI WORK*/

-------Changes done in case of Same Pan Number One Customer Upgrade and One Npa To handle that Issue ---



UPDATE   PRO.CustomerCal SET SysNPA_Dt=NULL,
                                           DbtDt=NULL,
                                           LossDt=NULL,
                                           ErosionDt=NULL,
                                           FlgErosion='N',
                                           SysAssetClassAlt_Key=1
                                           ,FlgDeg='N'
WHERE FlgUpg='U'


/*--------MARKING UPGRADED ACCOUNT --------------*/

UPDATE B SET  B.UpgDate=@PROCESSDATE
             ,B.DegReason=NULL
                   ,B.FinalAssetClassAlt_Key=1
                   ,B.FlgDeg='N'
                   ,B.FinalNpaDt=null
             ,B.FlgUpg='U'
                   FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.RefCustomerID=B.RefCustomerID
WHERE  ISNULL(A.FlgUpg,'U')='U' AND (ISNULL(A.FlgProcessing,'N')='N')


UPDATE B SET  B.UpgDate=@PROCESSDATE
             ,B.DegReason=NULL
                   ,B.FinalAssetClassAlt_Key=1
                   ,B.FlgDeg='N'
                   ,B.FinalNpaDt=null
             ,B.FlgUpg='U'
                   FROM PRO.CUSTOMERCAL A INNER JOIN PRO.ACCOUNTCAL B ON A.RefCustomerID=B.RefCustomerID
WHERE  ISNULL(A.FlgUpg,'U')='U' AND (ISNULL(A.FlgProcessing,'N')='N')


/* 16-04-2021  -- ADDED THIS CODE FOR  COMMING NEW ACCOUNT BECOMING NPA DUE TO 
      EXISTING NPA CUSTOMER  AND ALSO UPGRADEING */

UPDATE A
       SET FLGUPG='N'
            ,UpgDate=NULL
FROM PRO.ACCOUNTCAL A WHERE InitialAssetClassAlt_Key =1 AND FinalAssetClassAlt_Key =1 AND FlgUpg='U'

UPDATE A set DegReason=NULL FROM PRO.CustomerCal A where SysAssetClassAlt_Key=1 and DegReason is not null



            /* MERGING DATA FOR ALL SOURCES FOR FIND LOWEST ASSET CLASS AND MIN NPA DATE */
      
      IF OBJECT_ID('TEMPDB..#CTE_PERC') IS NOT NULL
    DROP TABLE #CTE_PERC

      SELECT * INTO 
            #CTE_PERC
      FROM
            (           /* ADVANCE DATA */
                  SELECT UCIF_ID,MAX(ISNULL(SYSASSETCLASSALT_KEY,1)) SYSASSETCLASSALT_KEY ,MIN(SYSNPA_DT) SYSNPA_DT
                  ,'ADV' PercType
                  FROM PRO.CUSTOMERCAL A WHERE ( UCIF_ID IS NOT NULL and UCIF_ID<>'0' ) AND  ISNULL(SYSASSETCLASSALT_KEY,1)=1
                  GROUP BY  UCIF_ID
                  UNION
                  /* INVESTMENT DATA */
                  SELECT UcifId UCIF_ID,MAX(ISNULL(FinalAssetClassAlt_Key,1)) SYSASSETCLASSALT_KEY ,MIN(NPIDt) SYSNPA_DT
                  ,'INV' PercType
                  FROM InvestmentFinancialDetail A 
                        INNER JOIN InvestmentBasicDetail B
                              ON A.InvEntityId =B.InvEntityId
                              AND A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
                              AND B.EffectiveFromTimeKey <=@TIMEKEY AND B.EffectiveToTimeKey >=@TIMEKEY
                        INNER JOIN InvestmentIssuerDetail C
                              ON C.IssuerEntityId=B.IssuerEntityId
                              AND C.EffectiveFromTimeKey <=@TIMEKEY AND C.EffectiveToTimeKey >=@TIMEKEY
                  WHERE ISNULL(FinalAssetClassAlt_Key,1)=1
                  GROUP BY  UcifId
                  /* DERIVATIVE DATA */
                  UNION 
                        SELECT UCIC_ID,MAX(ISNULL(FinalAssetClassAlt_Key,1)) SYSASSETCLASSALT_KEY ,MIN(NPIDt) SYSNPA_DT
                        ,'DER' PercType
                  FROM CurDat.DerivativeDetail A 
                        WHERE  A.EffectiveFromTimeKey <=@TIMEKEY AND A.EffectiveToTimeKey >=@TIMEKEY
                              AND ISNULL(FinalAssetClassAlt_Key,1)=1
                  GROUP BY  UCIC_ID
            )A

      /*  FIND LOWEST ASSET CLASS AND IN NPA DATE IN AALL SOURCES */
      IF OBJECT_ID('TEMPDB..#TEMPTABLE_UCFIC1') IS NOT NULL
    DROP TABLE #TEMPTABLE_UCFIC1

      SELECT UCIF_ID, MAX(SYSASSETCLASSALT_KEY) SYSASSETCLASSALT_KEY, MIN(SYSNPA_DT)SYSNPA_DT
                  ,'XXX' PercType
            INTO #TEMPTABLE_UCFIC1 
      FROM #CTE_PERC
            GROUP BY UCIF_ID

      UPDATE A
            SET A.PercType=B.PercType
      FROM #TEMPTABLE_UCFIC1 A
            INNER JOIN #CTE_PERC B
                  ON A.UCIF_ID =B.UCIF_ID
                  AND A.SYSASSETCLASSALT_KEY =B.SYSASSETCLASSALT_KEY 
            

      DROP TABLE IF EXISTS #CTE_PERC

      /*  UPDATE LOWEST ASSET CLASS AND MIN NPA DATE IN - ADVANCE DATA */
      UPDATE A SET SysAssetClassAlt_Key=B.SYSASSETCLASSALT_KEY
                        ,A.SysNPA_Dt=B.SYSNPA_DT
                        ,A.DegReason=CASE WHEN A.SysAssetClassAlt_Key >1 AND B.SYSASSETCLASSALT_KEY =1 
                                                THEN  
                                                      NULL
                                                ELSE  A.DegReason
                                          END
      FROM PRO.CUSTOMERCAL A
            INNER JOIN #TEMPTABLE_UCFIC1 B ON A.UCIF_ID =B.UCIF_ID


      /* UPDATE INVESTMENT DATA - LOWEST ASSET CLASS AND MIN NPA DATE */
      UPDATE A SET A.FinalAssetClassAlt_Key=D.SYSASSETCLASSALT_KEY
                   ,A.NPIDt=D.SYSNPA_DT  
                        ,A.DegReason=CASE WHEN A.FinalAssetClassAlt_Key >1 AND D.SYSASSETCLASSALT_KEY =1 
                                                THEN  
                                                      NULL  
                                                             
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
                        INNER JOIN #TEMPTABLE_UCFIC1 D ON D.UCIF_ID =C.UcifId

      /*  UPDATE   LOWEST ASSET CLASS AND MIN NPA DATE IN -  DERIVATIVE DATA */
      UPDATE A SET FinalAssetClassAlt_Key=B.SYSASSETCLASSALT_KEY
                        ,A.NPIDt=SYSNPA_DT
                        ,A.DegReason=CASE WHEN A.FinalAssetClassAlt_Key >1 AND B.SYSASSETCLASSALT_KEY =1 
                                                THEN  
                                                      NULL 
                                                ELSE  A.DegReason
                                          END
      FROM CurDat.DerivativeDetail A
            INNER JOIN #TEMPTABLE_UCFIC1 B ON A.UCIC_ID =B.UCIF_ID
            AND A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY


            update A SET FLGDEG='N',FLGUPG = 'U',UPGDATE = @PROCESSDATE
            FROM CurDat.DerivativeDetail A
            where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
             and FinalAssetClassAlt_Key=1 and InitialAssetAlt_Key > 1

             update A SET AssetClass_AltKey=FinalAssetClassAlt_Key
             FROM CurDat.DerivativeDetail A
            where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
             and FinalAssetClassAlt_Key=1 and InitialAssetAlt_Key > 1

             update A SET AssetClass_AltKey=FinalAssetClassAlt_Key
             FROM DBO.InvestmentFinancialDetail A
            where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
             and FinalAssetClassAlt_Key=1 and InitialAssetAlt_Key > 1

             update A SET FLGDEG='N',FLGUPG = 'U',UPGDATE = @PROCESSDATE
            FROM InvestmentFinancialDetail A
            where  A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY
             and FinalAssetClassAlt_Key=1 and InitialAssetAlt_Key > 1


      DROP TABLE IF EXISTS #TEMPTABLE_UCFIC1

      
      /* INVESTMENT AND DERVATIVE PROVISION CALCULATION */
      EXEC [PRO].[InvestmentDerivativeProvisionCal] @TIMEKEY

      /* END OF PERCOLATION WORK */


       UPDATE A SET 
               A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
                ,A.FinalNpaDt=B.SysNPA_Dt
                  FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
                  ON  A.RefCustomerID=B.RefCustomerID AND A.SourceSystemCustomerID=B.SourceSystemCustomerID 
                  WHERE ISNULL(B.SysAssetClassAlt_Key,1)=1 AND B.RefCustomerID<>'0'

      UPDATE A SET 
               A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
                ,A.FinalNpaDt=B.SysNPA_Dt
                  FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
                  ON  A.SourceSystemCustomerID=B.SourceSystemCustomerID 
                  WHERE ISNULL(B.SysAssetClassAlt_Key,1)=1

      UPDATE A SET 
               A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)
                ,A.FinalNpaDt=B.SysNPA_Dt
                  FROM PRO.AccountCal A INNER   JOIN PRO.CustomerCal B 
                  ON  A.UcifEntityID=B.UcifEntityID 
                  WHERE ISNULL(B.SysAssetClassAlt_Key,1)=1
            
       
      -- UPDATE A SET DEGREASON=B.DEGREASON
      --FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.SourceSystemCustomerID =B.SourceSystemCustomerID
      --WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='N') AND B.Up IS NOT NULL AND A.FinalAssetClassAlt_Key=1 AND A.UpgReason IS NULL


      -- UPDATE A SET DEGREASON=B.DEGREASON
      --FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.SourceSystemCustomerID =B.SourceSystemCustomerID
      --WHERE (B.FlgProcessing='N')  AND (A.FLGDEG='N') AND B.DegReason IS NOT NULL AND A.FinalAssetClassAlt_Key>1

      -- AND A.DegReason IS NULL

      



UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
      SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1
      WHERE RUNNINGPROCESSNAME='Upgrade_Customer_Account'

      --------------Added for DashBoard 04-03-2021
      --Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

END TRY
BEGIN  CATCH

      UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
      SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1
      WHERE RUNNINGPROCESSNAME='Upgrade_Customer_Account'
END CATCH

SET NOCOUNT OFF
END








GO
