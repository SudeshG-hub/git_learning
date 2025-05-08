SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 

 

 

/*=========================================

AUTHER : TRILOKI KHANNA

alter DATE : 27-11-2019

MODIFY DATE : 27-11-2019

DESCRIPTION : MARKING OF FLGDEG AND DEG REASON

 --EXEC [PRO].[Marking_NPA_Reason_NPAAccount]  @TIMEKEY=26476

 

 

=============================================*/

CREATE PROCEDURE [PRO].[Marking_NPA_Reason_NPAAccount]
@TIMEKEY INT
with recompile
AS

BEGIN
    SET NOCOUNT ON

  BEGIN TRY

DECLARE @PROCESSDATE DATE =(SELECT DATE FROM SYSDAYMATRIX WHERE TIMEKEY=@TIMEKEY)

DECLARE @REFPERIODNOCREDITUPG INT =(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODNOCREDITUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)
DECLARE @REFPERIODSTKSTATEMENTUPG INT=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODSTKSTATEMENTUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)
DECLARE @REFPERIODREVIEWUPG INT=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODREVIEWUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)

UPDATE   A SET  A.NPA_Reason=(CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', Degarde Account due to ALWYS_NPA and balance >=0' ELSE  'Degarde Account due to ALWYS_NPA and balance >=0' END)
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID =B.CUSTOMERENTITYID
WHERE A.ASSET_NORM='ALWYS_NPA' AND isnull(FinalAssetClassAlt_Key,1)<>1 AND  (B.FLGPROCESSING='N')

UPDATE A SET A.NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY INT NOT SERVICED' ELSE  'DEGRADE BY INT NOT SERVICED' END) 
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND (A.DPD_INTSERVICE>0 OR A.InttServiced='N' OR A.UnserviedInt > 0))

UPDATE A SET A.NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY CONTI EXCESS' ELSE  'DEGRADE BY CONTI EXCESS' END)
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_OVERDRAWN>0) 

UPDATE A SET NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY NO CREDIT' ELSE  'DEGRADE BY NO CREDIT' END) 
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_NOCREDIT>=@REFPERIODNOCREDITUPG )

 UPDATE A SET A.NPA_Reason= (CASE WHEN A.NPA_Reason IS NULL THEN  '' ELSE CONCAT(A.NPA_Reason,' , ') END)+'DEGRADE BY OVERDUE'            
	FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
	WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_OVERDUE >0)  
			and ISNULL(a.DegReason,'') not like '%NPA Due to overdue – Buyout Portfolio%' 
			AND ISNULL(a.DegReason,'') not like '%NPA with Seller%' -- Buyout changes

	UPDATE A SET A.NPA_Reason= (CASE WHEN A.NPA_Reason IS NULL THEN  '' ELSE CONCAT(A.NPA_Reason,' , ') END)+'NPA Due to overdue – Buyout Portfolio'            
	FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
	WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_OVERDUE >0)  
	and a.DegReason like '%NPA Due to overdue – Buyout Portfolio%' -- Buyout changes

UPDATE A SET A.NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY DEBIT BALANCE' ELSE  'DEGRADE BY DEBIT BALANCE' END)   
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
INNER JOIN DimProduct C ON  A.ProductAlt_Key=C.ProductAlt_Key AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_OVERDUE >0) 
AND A.DebitSinceDt IS NOT NULL --AND ISNULL(C.SrcSysProductCode,'N')='SAVING'

UPDATE A SET NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY STOCK STATEMENT' ELSE  'DEGRADE BY STOCK STATEMENT' END)
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1 AND A.DPD_STOCKSTMT>=@REFPERIODSTKSTATEMENTUPG) 

UPDATE A SET A.NPA_Reason= (CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGRADE BY REVIEW DUE DATE' ELSE  'DEGRADE BY REVIEW DUE DATE' END)  
FROM PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.CustomerEntityID =B.CustomerEntityID
WHERE (B.FlgProcessing='N')  AND ( isnull(FinalAssetClassAlt_Key,1)<>1AND A.DPD_RENEWAL>=@REFPERIODREVIEWUPG) 

UPDATE A SET A.NPA_REASON=(CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+', DEGARDE BY MOC' ELSE  'DEGARDE BY MOC' END)
FROM   PRO.ACCOUNTCAL A INNER JOIN  pro.ChangedMocAclStatus B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID
AND (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)
and a.Asset_Norm='NORMAL'

                UPDATE B SET NPA_Reason=(CASE WHEN isnull(B.NPA_Reason,'') <> '' THEN isnull(B.NPA_Reason,'')+', PERCOLATION BY PAN CARD ' + ' '+ A.PANNO ELSE  'PERCOLATION BY PAN CARD ' + ' '+ A.PANNO END)
                  FROM PRO.CUSTOMERCAL A INNER JOIN PRO.AccountCal B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                WHERE B.FinalAssetClassAlt_Key>1   AND B.NPA_Reason IS NULL
                AND A.DEGREASON LIKE '%PERCOLATION BY PAN CARD%'

                UPDATE B SET NPA_Reason=(CASE WHEN isnull(B.NPA_Reason,'') <> '' THEN isnull(B.NPA_Reason,'')+', PERCOLATION BY AADHAR CARD ' + ' '+ A.AADHARCARDNO  ELSE  'PERCOLATION BY AADHAR CARD ' + ' '+ A.AADHARCARDNO  END)
                  FROM PRO.CUSTOMERCAL A INNER JOIN PRO.AccountCal B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                WHERE B.FinalAssetClassAlt_Key>1   AND B.NPA_Reason IS NULL
                AND A.DEGREASON LIKE '%PERCOLATION BY AADHAR CARD%'

IF OBJECT_ID('TEMPDB..#TEMPTABLE_PERCOLATION') IS NOT NULL
    DROP TABLE #TEMPTABLE_PERCOLATION

                                SELECT A.REFCUSTOMERID AS REFCUSTOMERID,
                                       A.CustomerAcID AS CustomerAcID,
                                                   A.NPA_Reason
                                INTO #TEMPTABLE_PERCOLATION
                  FROM PRO.ACCOUNTCAL  A 
                                                INNER JOIN PRO.CUSTOMERCAL B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                WHERE  A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY
                AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY
                AND A.NPA_Reason IS NOT NULL
                AND A.FinalAssetClassAlt_Key>1
                ORDER BY A.REFCUSTOMERID


                UPDATE A          
                 SET NPA_Reason=CASE WHEN ISNULL(A.NPA_Reason,'') <> '' THEN ISNULL(A.NPA_Reason,'')+', Link By AccountId' + ' ' + B.CustomerAcID ELSE 'Link By AccountId' + ' ' + B.CustomerAcID END
                 FROM PRO.AccountCal A
                 INNER JOIN (     select A.REFCUSTOMERID
                                ,STUFF((SELECT ', ' + B.CustomerACID
                                                                                                                                                                from #TEMPTABLE_PERCOLATION B
                                                                                                                                                                WHERE B.REFCUSTOMERID = A.REFCUSTOMERID
                                                                                                                                                                ORDER BY CustomerACID
                                                                                                                                                                FOR XML PATH('')),1,1,'') CustomerACID
                                                                                                                                                FROM #TEMPTABLE_PERCOLATION A                                                                                                                                    
                                                                                                                                                GROUP BY A.REFCUSTOMERID) B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                INNER JOIN DIMPRODUCT P ON  P.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND P.EFFECTIVETOTIMEKEY>=@TIMEKEY
                 AND (P.PRODUCTALT_KEY =A.PRODUCTALT_KEY)
                WHERE  A.FinalAssetClassAlt_Key>1 and NPA_reason is NULL
                                AND  (isnull(A.DPD_Max,0)<90  OR  A.DPD_Renewal<=@REFPERIODREVIEWUPG OR A.DPD_NoCredit <= @REFPERIODNOCREDITUPG OR A.DPD_StockStmt <= @REFPERIODSTKSTATEMENTUPG)
                                AND (A.FLGDEG='N')--A.NPA_Reason IS NULL AND (A.FLGDEG='N')  As per Mail Changes done by Triloki 25/02/2020


                UPDATE   A SET  A.NPA_Reason='ALWYS_NPA Due To Writeoff Amount' 
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID =B.CUSTOMERENTITYID
WHERE A.ASSET_NORM='ALWYS_NPA' AND isnull(FinalAssetClassAlt_Key,1)<>1 AND  (B.FLGPROCESSING='N')
AND A.WriteOffAmount>0

IF OBJECT_ID('TEMPDB..#TEMPTABLE_PERCOLATIONWRITEOFF') IS NOT NULL
    DROP TABLE #TEMPTABLE_PERCOLATIONWRITEOFF

                                SELECT A.REFCUSTOMERID AS REFCUSTOMERID,
                                       A.CustomerAcID AS CustomerAcID,
                                                   A.NPA_Reason
                                INTO #TEMPTABLE_PERCOLATIONWRITEOFF
                  FROM PRO.ACCOUNTCAL  A 
                                                INNER JOIN PRO.CUSTOMERCAL B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                WHERE  A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY
                AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY
                AND A.FinalAssetClassAlt_Key>1
                AND (A.FLGDEG='N') and A.WriteOffAmount>0 AND A.NPA_Reason='ALWYS_NPA Due To Writeoff Amount'
                ORDER BY A.REFCUSTOMERID

                UPDATE A SET NPA_Reason='Link By W/o AccountId' + ' ' + B.CustomerAcID
                FROM PRO.AccountCal A INNER JOIN #TEMPTABLE_PERCOLATIONWRITEOFF B ON A.REFCUSTOMERID=B.REFCUSTOMERID
                WHERE  A.FinalAssetClassAlt_Key>1 AND A.NPA_Reason <>'ALWYS_NPA Due To Writeoff Amount' AND (A.FLGDEG='N')

UPDATE   A SET  A.NPA_Reason=(CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+' Degarde Account due to ALWYS_NPA and balance >=0'   ELSE 'Degarde Account due to ALWYS_NPA and balance >=0'END) 
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID =B.CUSTOMERENTITYID
WHERE B.ASSET_NORM='ALWYS_NPA' AND isnull(FinalAssetClassAlt_Key,1)<>1 AND  (B.FLGPROCESSING='N')
And A.NPA_Reason is null

UPDATE   A SET  A.NPA_Reason=(CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+' Degarde Account due to ALWYS_NPA and balance >=0'   ELSE 'Degarde Account due to ALWYS_NPA and balance >=0'END) 
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.UcifEntityID =B.UcifEntityID  
WHERE B.ASSET_NORM='ALWYS_NPA' AND isnull(FinalAssetClassAlt_Key,1)<>1 AND  (B.FLGPROCESSING='N')
And A.NPA_Reason is null And B.UcifEntityID>0

update pro.accountcal set NPA_Reason='NPA DUE TO FRAUD MARKING'
Where DegReason like '%Fraud%'

UPDATE   A SET  A.NPA_Reason=ISNULL(A.NPA_Reason,'')+'PERCOLATION BY UCIC_ID '+B.UCIF_ID 
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.UcifEntityID =B.UcifEntityID 
WHERE  isnull(FinalAssetClassAlt_Key,1)<>1 AND  (B.FLGPROCESSING='N')
And A.NPA_Reason is null And B.UcifEntityID>0

                UPDATE A SET A.NPA_Reason= 'NPA DUE TO FRAUD MARKING'           
                FROM PRO.AccountCal A
                where a.FlgFraud='Y' AND FinalAssetClassAlt_Key>1

                UPDATE A SET A.NPA_Reason= 'NPA DUE TO RFA MARKING'            
                FROM PRO.AccountCal A
                where a.RFA='Y' AND FinalAssetClassAlt_Key>1

                ------------------------------------------------------------------UPDATE NPA REASON DUE TO EROSION--------------------------
UPDATE   B SET  B.FlgErosion = A.FlgErosion, B.ErosionDt = A.ErosionDt
FROM PRO.CustomerCal_Hist A  INNER JOIN PRO.CUSTOMERCAL B ON A.UcifEntityID =B.UcifEntityID 
WHERE A.FlgErosion = 'Y' and B.SysAssetClassAlt_Key = A.SysAssetClassAlt_Key
and B.SysAssetClassAlt_Key in (3,6)  and  A.SysAssetClassAlt_Key in (3,6)
 and A.EffectiveFromTimeKey <= @TIMEKEY -1
and A.EffectiveToTimeKey >= @TIMEKEY -1

UPDATE   A SET  A.NPA_Reason=(CASE WHEN isnull(A.NPA_Reason,'') <> '' THEN isnull(A.NPA_Reason,'')+' ,DEGRADE DUE TO EROSION'   ELSE 'DEGRADE DUE TO EROSION' END) 
FROM PRO.ACCOUNTCAL A  INNER JOIN PRO.CUSTOMERCAL B ON A.UcifEntityID =B.UcifEntityID 
WHERE B.FlgErosion = 'Y'

UPDATE PRO.ACLRUNNINGPROCESSSTATUS
SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1
WHERE RUNNINGPROCESSNAME='Marking_NPA_Reason_NPAAccount'

              --------------Added for DashBoard 04-03-2021
                Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

 

END TRY

BEGIN  CATCH

 

UPDATE PRO.ACLRUNNINGPROCESSSTATUS

SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1

WHERE RUNNINGPROCESSNAME='Marking_NPA_Reason_NPAAccount'

END CATCH

SET NOCOUNT OFF

END

 

 

 

 

 

GO
