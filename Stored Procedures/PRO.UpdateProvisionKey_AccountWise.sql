SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 

/*=========================================

AUTHER : TRILOKI KHANNA

alter DATE : 27-11-2019

MODIFY DATE : 27-11-2019

DESCRIPTION : UPDATE PROVISION ALT KEY AT ARCCOUNT LEVEL

EXEC [PRO].[UpdateProvisionKey_AccountWise]  @TimeKey=25140

==============================================*/

CREATE  PROCEDURE [PRO].[UpdateProvisionKey_AccountWise]

@TimeKey INT

WITH RECOMPILE

AS

BEGIN

    SET NOCOUNT ON

BEGIN TRY

DECLARE @EXTDATE AS DATE
SELECT @EXTDATE  = DATE FROM SYSDAYMATRIX  WHERE TIMEKEY=@TimeKey

DECLARE @SubStandard INT =                      (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Sub Standard'                    AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @SubStandardInfrastructure INT =        (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Sub Standard Infrastructure'     AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @SubStandardAbinitioUnsecured INT =     (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Sub Standard Ab initio Unsecured'AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @DoubtfulI INT =                        (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Doubtful-I'                      AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @DoubtfulII INT =                       (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Doubtful-II'                     AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @DoubtfulIII INT =                      (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Doubtful-III'                    AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)
DECLARE @Loss INT =                             (SELECT PROVISIONALT_KEY FROM DIMPROVISION_SEG WHERE SEGMENT='IRAC' AND PROVISIONNAME='Loss'							AND EFFECTIVEFROMTIMEKEY <=@TIMEKEY AND EFFECTIVETOTIMEKEY >=@TIMEKEY)

Declare @SUBSTDWillFullDft6TO12MONTH AS INT=		(SELECT ProvisionAlt_Key FROM dimprovision_seg WHERE EffectiveFromTimeKey < = @TimeKey and EffectiveToTimeKey >= @TimeKey and ProvisionShortNameEnum = 'SUB_WillFULLDFT')
Declare @SUBSTDAbinitioWillFullDft6TO12MONTH AS INT=(SELECT ProvisionAlt_Key FROM dimprovision_seg WHERE EffectiveFromTimeKey < = @TimeKey and EffectiveToTimeKey >= @TimeKey and ProvisionShortNameEnum = 'SUB_AbinitioWillFULLDFT')
Declare @DB1WillFullDft AS INT=						(SELECT ProvisionAlt_Key FROM dimprovision_seg WHERE EffectiveFromTimeKey < = @TimeKey and EffectiveToTimeKey >= @TimeKey and ProvisionShortNameEnum = 'DB1_WillFULLDFT')
Declare @DB2WillFullDft AS INT=						(SELECT ProvisionAlt_Key FROM dimprovision_seg WHERE EffectiveFromTimeKey < = @TimeKey and EffectiveToTimeKey >= @TimeKey and ProvisionShortNameEnum = 'DB2_WillFULLDFT')

UPDATE PRO.ACCOUNTCAL SET PROVISIONALT_KEY=0

/*----------------PROVISION ALT KEY ALL NPA ACCOUNTS--------------------------------*/
UPDATE A SET A.ProvisionAlt_Key=
                (CASE WHEN C.AssetClassShortName='SUB' THEN  @SubStandard--15.0000/15.0000
                                                                      WHEN C.AssetClassShortName='DB1' THEN  @DoubtfulI--25.0000/25.0000
                                                                                  WHEN C.AssetClassShortName='DB2' THEN  @DoubtfulII--40.0000/40.0000
                                                                                  WHEN C.AssetClassShortName='DB3' THEN  @DoubtfulIII--100.0000/100.0000
                                                                                  WHEN C.AssetClassShortName='LOS' THEN  @Loss--100.0000/100.0000
                                                                                  ELSE 0
                                                                                END)
FROM PRO.ACCOUNTCAL A
--INNER JOIN DimSourceDB B  ON A.SourceAlt_Key=B.SourceAlt_Key     AND (B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey)
INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FINALASSETCLASSALT_KEY,1)  --PnpaAssetClassAlt_key
     AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
WHERE  C.ASSETCLASSGROUP='NPA'

UPDATE A
        SET A.PROVISIONALT_KEY=@SubStandardAbinitioUnsecured
                FROM PRO.ACCOUNTCAL A
--INNER JOIN DimSourceDB B  ON A.SourceAlt_Key=B.SourceAlt_Key     AND (B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey)
INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FINALASSETCLASSALT_KEY,1)
     AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
WHERE  C.ASSETCLASSGROUP='NPA'
                AND C.AssetClassShortName  IN('SUB')
                AND A.FlgAbinitio='Y'
               
----/*---WillfulDefault update provision alt_key in account cal table ---------------------*/
update a set a.ProvisionAlt_Key= (case when  isnull(A.FlgAbinitio,'N')='Y' then @SUBSTDAbinitioWillFullDft6TO12MONTH
                                      else  @SUBSTDWillFullDft6TO12MONTH end)
from PRO.ACCOUNTCAL A
INNER JOIN ExceptionFinalStatusType B ON B.CustomerID=A.RefCustomerID
inner join DimAssetClass c on c.AssetClassAlt_Key=a.FinalAssetClassAlt_Key
   and c.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
where C.AssetClassShortName='SUB' AND isnull(A.FlgFITL,'N')<>'Y'
and FinalNpaDt between dateadd(month,-12,@EXTDATE) and dateadd(month,-6,@EXTDATE)  and B.StatusType='Wilful Default'

----/*--------WillfulDefault update provision alt_key in account cal table--------------------------*/
update a set a.ProvisionAlt_Key=@DB1WillFullDft
from PRO.ACCOUNTCAL A
INNER JOIN ExceptionFinalStatusType B ON B.CustomerID=A.RefCustomerID
inner join DimAssetClass c on c.AssetClassAlt_Key=a.FinalAssetClassAlt_Key
   and c.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
where C.AssetClassShortName='DB1' AND isnull(A.FlgFITL,'N')<>'Y' and   B.StatusType='Wilful Default'

----/*-------WillfulDefault update provision alt_key in account cal table--------------------------*/
UPDATE A SET A.PROVISIONALT_KEY=@DB2WILLFULLDFT
FROM PRO.ACCOUNTCAL A
INNER JOIN ExceptionFinalStatusType B ON B.CustomerID=A.RefCustomerID
inner join DimAssetClass c on c.AssetClassAlt_Key=a.FinalAssetClassAlt_Key
   and c.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey
where C.AssetClassShortName='DB2' AND isnull(A.FlgFITL,'N')<>'Y' and  B.StatusType='Wilful Default'

/*UPDATE PROISION ALT KEY FOR NPA (SUB) ACCOUNT AS PER SEGMENT UNSCURED - RETAIL, MSME AND MICRO  ON THE BASES OF NPA QTR NO */
/* prepare NPA Qtr No */
DECLARE @CurQtrDate DATE,@LastQtrDate DATE,@LastToLastQtrDate DATE, @LastToLastToLastQtrDate DATE

SELECT @CurQtrDate=CurQtrDate,@LastQtrDate=LastQtrDate,@LastToLastQtrDate=LastToLastQtrDate
FROM SYSDAYMATRIX WHERE TIMEKEY=@TimeKey

SET @LastToLastToLastQtrDate= EOMONTH(DATEADD(MM,-3,@LastToLastQtrDate))
DROP TABLE IF EXISTS #AC_NPA_QTR_NO

SELECT AccountEntityID,
                CASE WHEN FinalNpaDt  BETWEEN DATEADD(DD,1,@LastQtrDate) AND @CurQtrDate  THEN 1
                                WHEN FinalNpaDt  BETWEEN DATEADD(DD,1,@LastToLastQtrDate) AND @LastQtrDate THEN 2
                                WHEN FinalNpaDt  BETWEEN DATEADD(DD,1,@LastToLastToLastQtrDate) AND @LastToLastQtrDate THEN 3
                              ELSE 4  END NPA_QTR_NO
                                INTO  #AC_NPA_QTR_NO
FROM PRO.ACCOUNTCAL WHERE FinalAssetClassAlt_Key >1
AND FlgFraud='Y'

UPDATE A
                SET A.ProvisionAlt_Key=seg.ProvisionAlt_Key
FROM PRO.AccountCal A
                INNER JOIN DimSourceDB B ON A.SourceAlt_Key=B.SourceAlt_Key
                                AND B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey
                INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FINALASSETCLASSALT_KEY,1)
                                AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
                inner JOIN DimProduct  dp
                                on           (dp.EffectiveFromTimeKey<=@TimeKey AND dp.EffectiveToTimeKey>=@TimeKey)
                                and dp.ProductAlt_Key=a.ProductAlt_Key
                inner JOIN DimProvision_Seg     seg
                                on           (seg.EffectiveFromTimeKey<=@TimeKey AND seg.EffectiveToTimeKey>=@TimeKey)
                                and seg.Segment=dp.ProductSubGroup
                INNER JOIN #AC_NPA_QTR_NO NP
                                ON NP.AccountEntityID=A.AccountEntityID
                                AND NP.NPA_QTR_NO  BETWEEN SEG.LowerDPD AND   SEG.UpperDPD
                where  C.AssetClassGroup='NPA' AND seg.Segment='Fraud'
 
 

UPDATE A SET A.ProvisionAlt_Key=B.ProvisionAlt_Key
FROM PRO.ACCOUNTCAL A
INNER JOIN STD_ProvDetail B ON A.AccountEntityID=B.AccountEntityID
INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FINALASSETCLASSALT_KEY,1)
     AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
                AND (B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey>=@TimeKey)
WHERE  C.ASSETCLASSGROUP='STD'

 
Update A Set A.ProvisionAlt_Key=(Select ProvisionAlt_Key from DimProvision_SegStd where EffectiveToTimeKey=49999 and ProvisionName='Other Portfolio')
FROM PRO.ACCOUNTCAL A
INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FINALASSETCLASSALT_KEY,1)
     AND (C.EffectiveFromTimeKey<=@TimeKey AND C.EffectiveToTimeKey>=@TimeKey)
                And ISNULL(A.ProvisionAlt_Key,0)=0
WHERE  C.ASSETCLASSGROUP='STD'


/*RESTR WORK */
                UPDATE C
                       SET ProvisionAlt_Key=0
                                FROM pro.AdvAcRestructureCal A
                                INNER JOIN DimParameter D ON D.EffectiveFromTimeKey <=@timekey AND D.EffectiveToTimeKey>=@timekey
                                                AND D.ParameterAlt_Key=A.RestructureFacilityTypeAlt_Key
                                                AND D.DimParameterName='RestructureFacility'
                                                and d.ParameterShortNameEnum='FITL'
                                INNER JOIN PRO.ACCOUNTCAL C
                                                ON C.AccountEntityID=A.AccountEntityId

/* END OF RESTR */
                                                                                                                                 

UPDATE PRO.ACLRUNNINGPROCESSSTATUS

SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1

WHERE RUNNINGPROCESSNAME='UpdateProvisionKey_AccountWise'

 

-----------------Added for DashBoard 04-03-2021

--Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

 

END TRY

BEGIN  CATCH

               

UPDATE PRO.ACLRUNNINGPROCESSSTATUS

SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1

WHERE RUNNINGPROCESSNAME='UpdateProvisionKey_AccountWise'

 

END CATCH

   SET NOCOUNT OFF

END

 

 

 

GO
