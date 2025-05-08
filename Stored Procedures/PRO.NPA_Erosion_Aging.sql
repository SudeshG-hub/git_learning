SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 

/*=========================================

AUTHER : TRILOKI KHANNA

alter DATE : 27-11-2019

MODIFY DATE : 27-11-2019

DESCRIPTION : UPDATE  SysAssetClassAlt_Key  NPA Erosion Aging

--EXEC [PRO].[NPA_Erosion_Aging] @TIMEKEY=26306

=============================================*/

CREATE PROCEDURE [PRO].[NPA_Erosion_Aging]

@TIMEKEY INT

--WITH RECOMPILE

AS

BEGIN

  SET NOCOUNT ON

   BEGIN TRY

 

--declare @timekey int=26306

DECLARE @PROCESSDATE DATE =(SELECT DATE FROM SysDayMatrix WHERE TimeKey=@TIMEKEY)

 

 

--IF (       (MONTH(@PROCESSDATE) IN(3,12) AND DAY(@PROCESSDATE)=31)

--               OR (MONTH(@PROCESSDATE) IN(6,9)  AND DAY(@PROCESSDATE)=30)

--             )

--- AS PER DISCUSSIONS AND DOCUMENT EORION WILL BE EXECUTING PN QTR END DATE

--BEGIN

                                --DECLARE @MoveToDB1 DECIMAL(5,2) =(SELECT cast(RefValue/100.00 as decimal(5,2))FROM PRO.refperiod where BusinessRule='MoveToDB1' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                --DECLARE @MoveToLoss DECIMAL(5,2)=(SELECT cast(RefValue/100.00 as decimal(5,2)) FROM PRO.refperiod where BusinessRule='MoveToLoss' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

 

                                DECLARE @MoveToDB1 DECIMAL(5,2) =(SELECT cast(RefValue/100.00 as decimal(5,2))FROM DIMSECURITYEROSIONMASTER where BusinessRule='Sub-Standard to Doubtful 1' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                DECLARE @MoveToLoss DECIMAL(5,2)=(SELECT cast(RefValue/100.00 as decimal(5,2)) FROM DIMSECURITYEROSIONMASTER where BusinessRule='Direct Loss' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

 

 

                                IF OBJECT_ID('TEMPDB..#CTE_CustomerWiseBalance') IS NOT NULL

                                   DROP TABLE #CTE_CustomerWiseBalance

 

 

                                SELECT A.RefCustomerID,SUM(ISNULL(A.PrincOutStd,0)) NetBalance INTO #CTE_CustomerWiseBalance

                                FROM PRO.ACCOUNTCAL A INNER JOIN PRO.CUSTOMERCAL B ON A.RefCustomerID=B.RefCustomerID

                                WHERE   ( b.SysAssetClassAlt_Key NOT IN (select AssetClassAlt_Key

                                from DimAssetClass where AssetClassShortName ='STD' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY )

                                AND SecApp='S'  --AND ISNULL(B.FlgDeg,'N')<>'Y'

                                )

                                AND (ISNULL(B.FlgProcessing,'N')='N')

                                 and ISNULL(A.PrincOutStd,0)>0

                                GROUP BY A.RefCustomerID

 

 

                                                /*----INTIAL LEVEL LossDt FlgErosion,ErosionDt NULL ------*/

                                                UPDATE B SET   B.FlgErosion='N',B.ErosionDt=NULL  FROM PRO.CustomerCal B

                                                --------/*---UPDATING ASSET CLASS ON DUE TO EROSION OF SECURITY AND DBTDT AND LOSS DT DUE TO EROSION */

                                               

                                UPDATE  B SET B.SysAssetClassAlt_Key=

                                                                               

                                                                                                                  (CASE WHEN  ISNULL(B.CurntQtrRv,0)< (ISNULL(C.NetBalance,0) *@MoveToLoss) AND D.AssetClassShortName<>'LOS' THEN   (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='LOS' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                   WHEN  ISNULL(B.CurntQtrRv,0) <(ISNULL(B.PrvQtrRV,0) *@MoveToDB1) AND (ISNULL(C.NetBalance,0)>= ISNULL(B.CurntQtrRv,0)) AND  D.AssetClassShortName IN('SUB')  THEN   (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='DB1' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                   ELSE B.SysAssetClassAlt_Key

                                                                                                                   END)

                                                                               

                                                                                                ,B.LossDt=CASE WHEN  ISNULL(B.CurntQtrRv,0)< (ISNULL(C.NetBalance,0) *@MoveToLoss) AND D.AssetClassShortName<>'LOS' THEN @PROCESSDATE

                                                                                                                                                ELSE LossDt  END

                                                                               

                                                                                                ,B.DbtDt= CASE  WHEN  ISNULL(B.CurntQtrRv,0) <(ISNULL(B.PrvQtrRV,0) *@MoveToDB1) AND (ISNULL(C.NetBalance,0)>= ISNULL(B.CurntQtrRv,0))AND

                                                                                                                                                   D.AssetClassShortName IN('SUB')   THEN @PROCESSDATE ELSE DbtDt END -- Change 08/06/2018

 

                                                                                                ,B.FlgErosion=  CASE WHEN  ISNULL(B.CurntQtrRv,0)< (ISNULL(C.NetBalance,0) *@MoveToLoss) AND D.AssetClassShortName<>'LOS' THEN  'Y'

                                                                                                                                   WHEN    ISNULL(B.CurntQtrRv,0) <(ISNULL(B.PrvQtrRV,0) *@MoveToDB1) AND (ISNULL(C.NetBalance,0)>= ISNULL(B.CurntQtrRv,0))

                                                                                                                                                AND  D.AssetClassShortName IN('SUB')  THEN  'Y'

                                                                                                                                   ELSE 'N'

                                                                                                                   END

                                                                               

                                                                                                ,B.ErosionDt=CASE WHEN  ISNULL(B.CurntQtrRv,0)< (ISNULL(C.NetBalance,0) *@MoveToLoss) AND D.AssetClassShortName<>'LOS' THEN  @PROCESSDATE

                                                                               

                                                                                                                                                                                WHEN  ISNULL(B.CurntQtrRv,0) <(ISNULL(B.PrvQtrRV,0) *@MoveToDB1) AND (ISNULL(C.NetBalance,0)>= ISNULL(B.CurntQtrRv,0))

                                                                                                                                                                                                  AND  D.AssetClassShortName IN('SUB')  THEN  @PROCESSDATE

                                                                                                                                   ELSE B.ErosionDt

                                                                                                                   END

                                FROM  PRO.AccountCal A INNER JOIN PRO.CustomerCal B ON A.RefCustomerID=B.RefCustomerID

                                INNER JOIN #CTE_CustomerWiseBalance C ON C.RefCustomerID=B.RefCustomerID

                                INNER JOIN DimAssetClass D ON D.AssetClassAlt_Key=B.SysAssetClassAlt_Key AND (D.EffectiveFromTimeKey<=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY)

                                WHERE ISNULL(A.PrincOutStd,0)>0  AND D.AssetClassShortName<>'STD'  AND (ISNULL(B.FlgProcessing,'N')='N')

                                --and ISNULL(B.CurntQtrRv,0)>0

                                /*----and ISNULL(B.PrvQtrRV,0)>0   --  commented on 23102021 for ignore this condition */

 

--END  -----END OF EROSION UPDATED=S

 

 

--OPTION(RECOMPILE)

 

/*-------------------UPDATING ASSET CLASS DUE TO AGING--------*/

 

 

--DECLARE @SUB_Days INT =(SELECT RefValue FROM PRO.refperiod WHERE BusinessRule='SUB_Days')

--DECLARE @DB1_Days INT =(SELECT RefValue FROM PRO.refperiod WHERE BusinessRule='DB1_Days')

--DECLARE @DB2_Days INT =(SELECT RefValue FROM PRO.refperiod WHERE BusinessRule='DB2_Days')

 

 

DECLARE @SUB_Days INT =(SELECT RefValue FROM DIMNPAAGEINGMASTER WHERE BusinessRule='Sub-Standard to Doubtful 1' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

DECLARE @DB1_Days INT =(SELECT RefValue FROM DIMNPAAGEINGMASTER WHERE BusinessRule='Doubtful 1 to Doubtful 2' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

DECLARE @DB2_Days INT =(SELECT RefValue FROM DIMNPAAGEINGMASTER WHERE BusinessRule='Doubtful 2 to Doubtful 3' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

 

 

/*------INTIAL LEVEL  DBTDT IS SET TO NULL------*/

 

/*---CALCULATE SysAssetClassAlt_Key,DbtDt ------------------ */

 

UPDATE A SET A.SysAssetClassAlt_Key= (

                                        CASE  WHEN  DATEADD(MONTH,@SUB_Days,A.SysNPA_Dt)>@PROCESSDATE AND  B.AssetClassShortName NOT IN('DB1','DB2','DB3')

                                                                                                                                                                                                                THEN (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='SUB' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                                                  WHEN  DATEADD(MONTH,@SUB_Days,A.SysNPA_Dt)<=@PROCESSDATE AND  DATEADD(MONTH,@SUB_Days+@DB1_Days,A.SysNPA_Dt)>@PROCESSDATE AND  B.AssetClassShortName NOT IN('DB2','DB3')

                                                                                                                                                                                                                THEN (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='DB1' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                                      WHEN  DATEADD(MONTH,@SUB_Days+@DB1_Days,A.SysNPA_Dt)<=@PROCESSDATE AND  DATEADD(MONTH,@SUB_Days+@DB1_Days+@DB2_Days,A.SysNPA_Dt)>@PROCESSDATE AND  B.AssetClassShortName NOT IN('DB3')

                                                                                                                                                                                                THEN (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='DB2' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                                       WHEN  DATEADD(MONTH,(@DB1_Days+@SUB_Days+@DB2_Days),A.SysNPA_Dt)<=@PROCESSDATE  THEN (SELECT AssetClassAlt_Key FROM DimAssetClass WHERE AssetClassShortName='DB3' AND EffectiveFromTimeKey<=@TIMEKEY AND EffectiveToTimeKey>=@TIMEKEY)

                                                                                                                                                   ELSE A.SysAssetClassAlt_Key

                                                                                                                                                   END)

          ,A.DBTDT= (CASE

                                                                                                                                                       WHEN  DATEADD(MONTH,@SUB_Days,A.SysNPA_Dt)<=@PROCESSDATE AND  DATEADD(MONTH,@SUB_Days+@DB1_Days,A.SysNPA_Dt)>@PROCESSDATE  THEN DATEADD(MONTH,@SUB_Days,A.SysNPA_Dt)

                                                                                                                                                       WHEN  DATEADD(MONTH,@SUB_Days+@DB1_Days,A.SysNPA_Dt)<=@PROCESSDATE AND  DATEADD(MONTH,@SUB_Days+@DB1_Days+@DB2_Days,A.SysNPA_Dt)>@PROCESSDATE   THEN DATEADD(MONTH,@SUB_Days,A.SysNPA_Dt)

                                                                                                                                                       WHEN  DATEADD(MONTH,(@DB1_Days+@SUB_Days+@DB2_Days),A.SysNPA_Dt)<=@PROCESSDATE THEN DATEADD(MONTH,(@SUB_Days),A.SysNPA_Dt)

                                                                                                                                                                   ELSE DBTDT

                                                                                                                                                   END)

 

FROM PRO.CustomerCal A

                                INNER JOIN DimAssetClass B  ON A.SysAssetClassAlt_Key =B.AssetClassAlt_Key

                                                AND  B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY

WHERE B.AssetClassShortName NOT IN('STD','LOS')

AND ISNULL(A.FlgDeg,'N')<>'Y'  AND (ISNULL(A.FlgProcessing,'N')='N')

AND A.SYSNPA_DT IS NOT NULL  AND ISNULL(A.FlgErosion,'N')<>'Y'

 

OPTION(RECOMPILE)

 

 

---HANDLE ASSET CLASS FROM SOURCE DOUBT FUL BUT ON THE BASES OF NPA SUB SO CONDITION MODIFY---

 

UPDATE A SET SysAssetClassAlt_Key=SrcAssetClassAlt_Key

FROM PRO.CustomerCal A INNER JOIN DimAssetClass B ON A.SrcAssetClassAlt_Key =B.AssetClassAlt_Key

WHERE B.AssetClassShortName IN('DB1','DB2','DB3')

AND ISNULL(A.FlgDeg,'N')<>'Y' AND (ISNULL(A.FlgProcessing,'N')='N')

AND A.SYSNPA_DT IS NOT NULL

AND SysAssetClassAlt_Key=2  AND ISNULL(FlgMoc,'N')<>'Y'

 

 

 

UPDATE A SET SysAssetClassAlt_Key=SrcAssetClassAlt_Key

FROM PRO.CustomerCal A INNER JOIN DimAssetClass B ON A.SrcAssetClassAlt_Key =B.AssetClassAlt_Key

WHERE B.AssetClassShortName IN('DB2')

AND ISNULL(A.FlgDeg,'N')<>'Y' AND (ISNULL(A.FlgProcessing,'N')='N')

AND A.SYSNPA_DT IS NOT NULL

AND SysAssetClassAlt_Key in(2,3) AND ISNULL(FlgMoc,'N')<>'Y'

 

 

UPDATE A SET SysAssetClassAlt_Key=SrcAssetClassAlt_Key

FROM PRO.CustomerCal A INNER JOIN DimAssetClass B ON A.SrcAssetClassAlt_Key =B.AssetClassAlt_Key

WHERE B.AssetClassShortName IN('DB3')

AND ISNULL(A.FlgDeg,'N')<>'Y' AND (ISNULL(A.FlgProcessing,'N')='N')

AND A.SYSNPA_DT IS NOT NULL

AND SysAssetClassAlt_Key in(2,3,4) AND ISNULL(FlgMoc,'N')<>'Y'

 

 

UPDATE A SET SysAssetClassAlt_Key=SrcAssetClassAlt_Key

FROM PRO.CustomerCal A INNER JOIN DimAssetClass B ON A.SrcAssetClassAlt_Key =B.AssetClassAlt_Key

WHERE B.AssetClassShortName IN('LOS')

AND ISNULL(A.FlgDeg,'N')<>'Y' AND (ISNULL(A.FlgProcessing,'N')='N')

AND A.SYSNPA_DT IS NOT NULL

AND SysAssetClassAlt_Key in(2,3,4,5) AND ISNULL(FlgMoc,'N')<>'Y'

 

 

------------------------------------

 

UPDATE PRO.ACLRUNNINGPROCESSSTATUS

                SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1

                WHERE RUNNINGPROCESSNAME='NPA_Erosion_Aging'

 

               

 

                -----------------Added for DashBoard 04-03-2021

--Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

 

END TRY

BEGIN  CATCH

 

                UPDATE PRO.ACLRUNNINGPROCESSSTATUS

                SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1

                WHERE RUNNINGPROCESSNAME='NPA_Erosion_Aging'

END CATCH

 

 

SET NOCOUNT OFF

END

 

 

 

 

 

 

 

 

 

 

 

 

 

GO
