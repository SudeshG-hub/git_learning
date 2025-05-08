SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
        
    
                
                
/*=========================================                
 AUTHER : TRILOKI SHNAKER KHANNA                
 CREATE DATE : 15-02-2021                
 MODIFY DATE : 22-02-2021                
 DESCRIPTION : INSERT DATA FOR PRO.CUSTOMER CAL AND PRO.ACCOUNT CAL TABLE AND UPDATE SOME OTHER COLUMN                
EXEC [PRO].[InsertDataforAssetClassficationAUSFB] @TIMEKEY=@timekey,@BRANCHCODE=NULL,@ISMOC='N'                
=============================================*/                
                
                
/*=========================================                
 AUTHOR : TRILOKI KHANNA                
 CREATE DATE : 09-04-2021                
 MODIFY DATE : 09-04-2021                
 DESCRIPTION : Test Case Cover in This SP                
                
 RefCustomerID TestCase                
2 Degradation - Non Agri with Always STD = Y                
15 Degradation - CC/OD: Non Agri - Interest Servicing with Always STD = Y                
16 Degradation - CC/OD: Non Agri - Conti Excess Date with Always STD = Y                
17 Degradation - CC/OD: Non Agri - Last Credit Date with Always STD = Y                
18 Degradation - CC/OD: Non Agri - Stock Stmt Date with Always STD = Y                
19 Degradation - CC/OD: Non Agri - Last Review Due Date with Always STD = Y                
20 Degradation - CC/OD: Agri - Interest Servicing with Always STD = Y                
21 Degradation - CC/OD: Agri - Conti Excess Date with Always STD = Y                
22 Degradation - CC/OD: Agri - Last Credit Date with Always STD = Y                
23 Degradation - CC/OD: Agri - Last Review Due Date with Always STD = Y                
25 Degradation - Non Agri - Interest Servicing Conti Excess Date with Always STD =Y                
27 Degradation - Agri - Interest Servicing Conti Excess Date with Always STD =Y                
29 Degradation - Non Agri - Interest Servicing Conti Excess Date Last Credit Date with Always STD =Y                
31 Degradation - Agri - Interest Servicing Conti Excess Date Last Credit Date with Always STD =Y                
33 Degradation - Non Agri - Interest Servicing Conti Excess Date Last Credit Date Stock Stmt Date with Always STD =Y                
35 Degradation - Agri - Interest Servicing Conti Excess Date Last Credit Date Last Review Due Date with Always STD =Y                
37 Degradation - Non Agri -OverDue Interest Servicing Conti Excess Date Last Credit Date Stock Stmt Date Last Review Due Date with Always STD =Y                
46 NULL                
118 Identification of SMA-0 (Always_STD Ac)                
65 Security Valuation date validations - Current Asset Expired                
66 Security Valuation date validations - Current Asset Active                
67 Security Valuation date validations - Fixed Asset Expired                
68 Security Valuation date validations - Fixed Asset Active                
69 Security Valuation date validations - Permanent Asset Expired                
70 Security Valuation date validations - Permanent Asset Active                
76 Populaton of Secured Amount - FlgSecured = S                
77 Populaton of Secured Amount - FlgSecured = U                
78 Populaton of UnSecured Amount - FlgSecured = S                
79 Populaton of UnSecured Amount - FlgSecured = U                
92 Populaton of Secured Amount - FlgSecured = C                
93 Populaton of UnSecured Amount - FlgSecured = C                
                
=============================================*/                
                
---sp_rename 'pro.InsertDataforAssetClassficationAUSFB','pro.InsertDataforAssetClassficationAUSFBbkp_27jan22'          
          
 create   PROCEDURE [PRO].[InsertDataforAssetClassficationAUSFB]                
@TIMEKEY INT,                
@BRANCHCODE VARCHAR(20)=NULL,                
@ISMOC CHAR(1)='N'                
with recompile                
AS                
BEGIN                 
                
      SET NOCOUNT ON   
  BEGIN  TRY                      
                 
    -- DECLARE @TIMEKEY INT = (SELECT TIMEKEY FROM PRO.EXTDATE_MISDB WHERE FLG = 'Y')                
  --DECLARE @TimeKey  Int =(SELECT TimeKey FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')                
  DECLARE @ProcessingDate DATE=(SELECT DATE FROM SYSDAYMATRIX WHERE TIMEKEY=@TIMEKEY)                
  DECLARE @SETID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 FROM [PRO].[PROCESSMONITOR] WHERE TIMEKEY=@TIMEKEY)                
  DECLARE @LastQtrDateKey INT=(select LastQtrDateKey from sysdaymatrix where timekey=@TIMEKEY)                
  DECLARE @LastMonthDateKey INT=(select LastMonthDateKey from sysdaymatrix where timekey=@TIMEKEY)                
  DECLARE @PrvDateKey INT=(select timekey-1 from sysdaymatrix where TimeKey=@TIMEKEY)                
  DECLARE @PROCESSMONTH DATE =(select date from SysDayMatrix where TimeKey=@TIMEKEY)                
  DECLARE @PROCESSDAY VARCHAR(10)=DATENAME(WEEKDAY, (select date from SysDayMatrix where TimeKey=@TIMEKEY))                
                
  --DECLARE @PANCARDFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='PANCARDNO' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
  --DECLARE @AADHARCARDFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='AADHARCARD' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
  DECLARE @PANCARDFLAG CHAR(1)=(SELECT 'Y' FROM solutionglobalparameter WHERE ParameterName='PAN Aadhar Dedup Integration' and  ParameterValueAlt_Key=1 AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
  DECLARE @AADHARCARDFLAG CHAR(1)=(SELECT 'Y' FROM solutionglobalparameter WHERE ParameterName='PAN Aadhar Dedup Integration' and  ParameterValueAlt_Key=1 AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
  DECLARE @JOINTACCOUNTFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='JOINT ACCOUNT' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
  DECLARE @UCFICFLAG CHAR(1)=(SELECT REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE='UCFIC' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
                  
  DECLARE  @6MnthBackTimeKey SmallInt,@6MonthBackDate Date                
  SET @6MonthBackDate = DATEADD(M,-6,@ProcessingDate)                
                
                
                
  TRUNCATE TABLE  PRO.CUSTOMERCAL                
  TRUNCATE TABLE  PRO.ACCOUNTCAL                
  DELETE FROM    PRO.PROCESSMONITOR  WHERE TIMEKEY=@TIMEKEY                
                
                
                  
  UPDATE PRO.ACLRUNNINGPROCESSSTATUS SET COMPLETED='N',COUNT=0,ERRORDESCRIPTION=NULL , ERRORDATE=NULL                
                   
   --ALTER INDEX INDEX_CUSTOMERENTITYID ON PRO.CUSTOMERCAL DISABLE                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'INSERT DATA FOR PRO.CUSTOMERCAL CAL TABLE','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
 /*--------------INSERT DATA FOR PRO.CUSTOMERCAL CAL TABLE--------------------------*/                
                
INSERT INTO PRO.CUSTOMERCAL                
(                
EffectiveFromTimeKey,                
EffectiveToTimeKey                    
,BRANCHCODE                       
,CUSTOMERENTITYID                  
,RefCustomerID                    
,CUSTOMERNAME                                                    
,CONSTITUTIONALT_KEY                
,FlgDeg,                
FlgUpg,                
FlgMoc,                
FlgSMA,                
FlgProcessing,                
FlgErosion,                
FlgPNPA,                
FlgPercolation,                
FlgInMonth,                
FlgDirtyRow,                
SrcNPA_Dt,                
SysNPA_Dt,                
SplCatg1Alt_Key,                
SplCatg2Alt_Key,           
SplCatg3Alt_Key,                
SplCatg4Alt_Key,                
SourceSystemCustomerID,                
Asset_Norm,                
UCIF_ID,                
UcifEntityID                
,SourceAlt_Key                
)                
SELECT                    
@TIMEKEY EffectiveFromTimeKey,                
@TIMEKEY EffectiveToTimeKey,                   
ParentBranchCode BRANCHCODE,                 
CBD.CUSTOMERENTITYID,                     
CBD.CUSTOMERID,                 
CBD.CUSTOMERNAME,                  
CBD.ConstitutionAlt_Key                              
,'N' AS FlgDeg,                
'N' AS FlgUpg,                
'N' AS FlgMoc,                
'N' AS FlgSMA ,                
'N' AS FlgProcessing,                
'N' AS FlgErosion,                
'N' AS FlgPNPA,                
'N' AS FlgPercolation,                
'N' AS FlgInMonth,                
'N' AS FlgDirtyRow ,                
NULL AS SrcNPA_Dt,                
NULL AS SysNPA_Dt,                
0 SplCatg1Alt_Key,                
0 SplCatg2Alt_Key,                
0 SplCatg3Alt_Key,                
0 SplCatg4Alt_Key,                
CBD.CustomerId AS SourceSystemCustomerID                
,'NORMAL' AS Asset_Norm                
,CBD.UCIF_ID                
,CBD.UcifEntityID                
,CBD.SourceSystemAlt_Key                
                
FROM dbo.CUSTOMERBASICDETAIL CBD  INNER MERGE JOIN dbo.AdvAcBasicDetail ABD ON CBD.CustomerEntityId=ABD.CustomerEntityId                
WHERE (CBD.EffectiveFromTimeKey<=@TIMEKEY AND CBD.EffectiveToTimeKey>=@TIMEKEY) AND (ABD.EffectiveFromTimeKey<=@TIMEKEY AND ABD.EffectiveToTimeKey>=@TIMEKEY)                
AND  (CASE WHEN @BRANCHCODE IS NULL AND @ISMOC='N' THEN '0'                
           WHEN @BRANCHCODE IS NULL AND @ISMOC='Y' THEN CBD.MocStatus                
     WHEN @BRANCHCODE IS NOT NULL AND @ISMOC='N' THEN CBD.CustomerId                
  END)                
   IN (                
       CASE WHEN @BRANCHCODE IS NULL AND @ISMOC='N' THEN '0'                
            WHEN @BRANCHCODE IS NULL AND @ISMOC='Y' THEN 'Y'                
      WHEN @BRANCHCODE IS NOT NULL AND @ISMOC='N' THEN                 
   (                 
    SELECT  ACFD.REFCustomerId  FROM CurDat.AdvCustFinancialDetail ACFD                
    WHERE ACFD.EffectiveFromTimeKey<=@TIMEKEY AND ACFD.EffectiveToTimeKey>=@TIMEKEY                
       AND BranchCode=@BRANCHCODE                
    GROUP BY  ACFD.REFCustomerId                 
   ) END                
   )                
----------Added on 24-02-2022        
UNION        
           
SELECT                                          
@TIMEKEY EffectiveFromTimeKey,              
@TIMEKEY EffectiveToTimeKey,                 
ParentBranchCode BRANCHCODE,               
CBD.CUSTOMERENTITYID,                   
CBD.CUSTOMERID,               
CBD.CUSTOMERNAME,                
CBD.ConstitutionAlt_Key                            
,'N' AS FlgDeg,              
'N' AS FlgUpg,              
'N' AS FlgMoc,              
'N' AS FlgSMA ,              
'N' AS FlgProcessing,              
'N' AS FlgErosion,              
'N' AS FlgPNPA,              
'N' AS FlgPercolation,              
'N' AS FlgInMonth,              
'N' AS FlgDirtyRow   ,              
NULL AS SrcNPA_Dt,              
NULL AS SysNPA_Dt,              
0 SplCatg1Alt_Key,              
0 SplCatg2Alt_Key,              
0 SplCatg3Alt_Key,              
0 SplCatg4Alt_Key,              
CBD.CustomerId AS SourceSystemCustomerID              
,'NORMAL' AS Asset_Norm              
,CBD.UCIF_ID              
,CBD.UcifEntityID              
,CBD.SourceSystemAlt_Key              
                
FROM dbo.CUSTOMERBASICDETAIL CBD  INNER MERGE JOIN dbo.AdvNFAcBasicDetail ABD ON CBD.CustomerEntityId=ABD.CustomerEntityId              
WHERE (CBD.EffectiveFromTimeKey<=@TIMEKEY AND CBD.EffectiveToTimeKey>=@TIMEKEY) AND (ABD.EffectiveFromTimeKey<=@TIMEKEY AND ABD.EffectiveToTimeKey>=@TIMEKEY)              
AND  (CASE WHEN @BRANCHCODE IS NULL AND @ISMOC='N' THEN '0'              
           WHEN @BRANCHCODE IS NULL AND @ISMOC='Y' THEN CBD.MocStatus              
     WHEN @BRANCHCODE IS NOT NULL AND @ISMOC='N' THEN CBD.CustomerId              
  END)              
   IN (              
       CASE WHEN @BRANCHCODE IS NULL AND @ISMOC='N' THEN '0'              
            WHEN @BRANCHCODE IS NULL AND @ISMOC='Y' THEN 'Y'              
      WHEN @BRANCHCODE IS NOT NULL AND @ISMOC='N' THEN               
   (               
    SELECT  ACFD.REFCustomerId  FROM CurDat.AdvCustFinancialDetail ACFD              
    WHERE ACFD.EffectiveFromTimeKey<=@TIMEKEY AND ACFD.EffectiveToTimeKey>=@TIMEKEY              
       AND BranchCode=@BRANCHCODE              
    GROUP BY  ACFD.REFCustomerId               
   ) END              
   )        
              
GROUP BY                 
ParentBranchCode,                
CBD.CUSTOMERENTITYID,                     
CBD.CUSTOMERID,                 
CBD.CUSTOMERNAME,                  
CBD.ConstitutionAlt_Key                 
,CBD.UCIF_ID                
,CBD.UcifEntityID                  
,CBD.SourceSystemAlt_Key                           
OPTION(MAXDOP 1)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='INSERT DATA FOR PRO.CUSTOMERCAL CAL TABLE'                
                
/*----------------------INSERT DATA FOR PRO.ACCOUNTCAL CAL TABLE------------------ */                
           
                
/*------------------ACCOUNT DATA INSERT------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'INSERT DATA IN ACCOUNTCAL TABLE','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
                
                
INSERT INTO PRO.ACCOUNTCAL                
(                
ACCOUNTENTITYID                
,CUSTOMERACID                
,FLGDEG                
,FLGDIRTYROW                
,FLGINMONTH                
,FLGSMA                
,FLGPNPA                
,FLGUPG                
,FLGFITL                
,FLGABINITIO                
,REFPERIODOVERDUEUPG                
,REFPERIODOVERDRAWNUPG                
,REFPERIODNOCREDITUPG                
,REFPERIODINTSERVICEUPG                
,REFPERIODSTKSTATEMENTUPG                
,REFPERIODREVIEWUPG                
,EFFECTIVEFROMTIMEKEY                
,EFFECTIVETOTIMEKEY                
,ASSET_NORM                
,SPLCATG1ALT_KEY                
,SPLCATG2ALT_KEY                
,SPLCATG3ALT_KEY                
,SPLCATG4ALT_KEY                
,BALANCE                
,BALANCEINCRNCY                
,NETBALANCE                
,CURRENCYALT_KEY                
,SOURCEALT_KEY                
,SECAPP                
,PROVCOVERGOVGUR                
,BANKPROVSECURED                
,BANKPROVUNSECURED                
,BANKTOTALPROVISION                
,RBIPROVSECURED                
,RBIPROVUNSECURED                
,RBITOTALPROVISION                
,APPGOVGUR                
,USEDRV                
,COMPUTEDCLAIM                
,PROVPERSECURED                
,PROVPERUNSECURED                
,REFPERIODOVERDUE                 
,REFPERIODOVERDRAWN                   
,REFPERIODNOCREDIT                  
,REFPERIODINTSERVICE                  
,REFPERIODSTKSTATEMENT                
,REFPERIODREVIEW                
,INITIALASSETCLASSALT_KEY                
,FINALASSETCLASSALT_KEY                
,RefCustomerID                 
,SourceSystemCustomerID                
,CUSTOMERENTITYID                
,BranchCode                
,ProductAlt_Key                                                        
,CURRENTLIMIT                           
,CURRENTLIMITDT                 
,SchemeAlt_Key                 
,SubSectorAlt_Key                
,FacilityType                
,InttRate                
,AcOpenDt                
,FirstDtOfDisb                
,PrvAssetClassAlt_Key                
,FlgSecured                
,UCIF_ID                
,UcifEntityID                
)                SELECT                
ACCOUNTENTITYID=ACCOUNTENTITYID                
,CUSTOMERACID=CUSTOMERACID                
,FLGDEG='N'                
,FLGDIRTYROW ='N'                
,FLGINMONTH='N'                
,FLGSMA='N'                
,FLGPNPA='N'                
,FLGUPG='N'                
,FLGFITL='N'                
,FLGABINITIO='N'                
,REFPERIODOVERDUEUPG=(SELECT TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODOVERDUEUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODOVERDRAWNUPG=(SELECT TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODOVERDRAWNUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODNOCREDITUPG =(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODNOCREDITUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODINTSERVICEUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODINTSERVICEUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODSTKSTATEMENTUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODSTKSTATEMENTUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODREVIEWUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODREVIEWUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,EFFECTIVEFROMTIMEKEY=@TIMEKEY                
,EFFECTIVETOTIMEKEY=@TIMEKEY                
,ASSET_NORM='NORMAL'                
,SPLCATG1ALT_KEY=0                
,SPLCATG2ALT_KEY=0                
,SPLCATG3ALT_KEY=0                
,SPLCATG4ALT_KEY=0                
,BALANCE=0.00                
,BALANCEINCRNCY =0.00                
,NETBALANCE =0.00                
,CURRENCYALT_KEY=62                
,ABD.SOURCEALT_KEY AS  SOURCEALT_KEY                
,'U' AS SecApp                  
,PROVCOVERGOVGUR=0.00                
,BANKPROVSECURED=0.00                
,BANKPROVUNSECURED=0.00                
,BANKTOTALPROVISION=0.00                
,RBIPROVSECURED=0.00                
,RBIPROVUNSECURED=0.00                
,RBITOTALPROVISION=0.00                
,APPGOVGUR=0.00                
,USEDRV=0.00                
,COMPUTEDCLAIM=0.00                
,PROVPERSECURED=0.00                
,PROVPERUNSECURED=0.00                
,REFPERIODOVERDUE =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODOVERDUE' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODOVERDRAWN   =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODOVERDRAWN' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODNOCREDIT  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODNOCREDIT' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODINTSERVICE   =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODINTSERVICE' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODSTKSTATEMENT  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODSTKSTATEMENT' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,REFPERIODREVIEW  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODREVIEW' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)                
,1 AS INITIALASSETCLASSALT_KEY                
,1 AS FINALASSETCLASSALT_KEY                
,ABD.RefCustomerID AS RefCustomerID                 
,ABD.RefCustomerID AS SourceSystemCustomerID                
,CBD.CUSTOMERENTITYID                 
,ABD.BRANCHCODE                
,ABD.ProductAlt_Key                                                        
,ABD.CURRENTLIMIT                  
,ABD.CURRENTLIMITDT                 
,ABD.SchemeAlt_Key                 
,ABD.SubSectorAlt_Key                 
,ABD.FacilityType                
,ABD.Pref_InttRate AS InttRate                
,ABD.AccountOpenDate AS AcOpenDt                
,ABD.DtofFirstDisb AS FirstDtOfDisb                
,1 AS PrvAssetClassAlt_Key                
,'U' AS FlgSecured                
,CBD.UCIF_ID                
,CBD.UcifEntityID                
FROM   dbo.AdvAcBasicDetail  ABD  INNER  HASH JOIN  PRO.CUSTOMERCAL   CBD ON abd.CUSTOMERENTITYID=CBD.CUSTOMERENTITYID                   
LEFT JOIN DimGLProduct C ON C.GLProductAlt_Key =ABD.GLProductAlt_Key                
AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)                                 
WHERE (ABD.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND ABD.EFFECTIVETOTIMEKEY > =@TIMEKEY )                
GROUP BY                                                          
 ABD.BRANCHCODE                           
 ,ABD.CUSTOMERENTITYID                           
 ,ABD.ACCOUNTENTITYID                           
 ,ABD.SYSTEMACID                           
 ,ABD.CUSTOMERACID                          
 ,ABD.GLALT_KEY                          
 ,ABD.GLPRODUCTALT_KEY                          
 ,ABD.PRODUCTALT_KEY                          
 ,ABD.SEGMENTCODE                           
 ,ABD.ACCOUNTOPENDATE                           
 ,ABD.FacilityType                         
 ,ABD.DTOFFIRSTDISB                                  
 ,ABD.CURRENTLIMIT                           
 ,ABD.CURRENTLIMITDT                 
 ,ABD.CURRENCYALT_KEY                  
 ,ABD.REFCUSTOMERID                   
 ,ABD.SCHEMEALT_KEY                 
 ,ABD.ACTIVITYALT_KEY                 
 ,ABD.InttTypeAlt_Key                
 ,ABD.SubSectorAlt_Key                  
 ,ABD.OriginalLimitDt                    
 ,CBD.CUSTOMERENTITYID                  
 ,ABD.Pref_InttRate                    
 ,ABD.SOURCEALT_KEY                  
 ,CBD.UCIF_ID                
,CBD.UcifEntityID                               
------------------Added on 24-02-2022        
UNION        
        
SELECT              
ACCOUNTENTITYID=ACCOUNTENTITYID              
,CUSTOMERACID=CUSTOMERACID              
,FLGDEG='N'              
,FLGDIRTYROW ='N'              
,FLGINMONTH='N'              
,FLGSMA='N'              
,FLGPNPA='N'              
,FLGUPG='N'              
,FLGFITL='N'              
,FLGABINITIO='N'              
,REFPERIODOVERDUEUPG=(SELECT TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODOVERDUEUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODOVERDRAWNUPG=(SELECT TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODOVERDRAWNUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODNOCREDITUPG =(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODNOCREDITUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODINTSERVICEUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODINTSERVICEUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODSTKSTATEMENTUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODSTKSTATEMENTUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODREVIEWUPG=(SELECT  TOP 1 CAST(REFVALUE AS INT) FROM PRO.REFPERIOD WHERE BUSINESSRULE='REFPERIODREVIEWUPG' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,EFFECTIVEFROMTIMEKEY=@TIMEKEY              
,EFFECTIVETOTIMEKEY=@TIMEKEY              
,ASSET_NORM='NORMAL'              
,SPLCATG1ALT_KEY=0              
,SPLCATG2ALT_KEY=0              
,SPLCATG3ALT_KEY=0              
,SPLCATG4ALT_KEY=0              
,BALANCE=0.00              
,BALANCEINCRNCY =0.00              
,NETBALANCE =0.00              
,CURRENCYALT_KEY=62       
,2 AS  SOURCEALT_KEY              
,'U' AS SecApp                
,PROVCOVERGOVGUR=0.00              
,BANKPROVSECURED=0.00              
,BANKPROVUNSECURED=0.00              
,BANKTOTALPROVISION=0.00              
,RBIPROVSECURED=0.00              
,RBIPROVUNSECURED=0.00              
,RBITOTALPROVISION=0.00              
,APPGOVGUR=0.00              
,USEDRV=0.00              
,COMPUTEDCLAIM=0.00              
,PROVPERSECURED=0.00              
,PROVPERUNSECURED=0.00              
,REFPERIODOVERDUE =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODOVERDUE' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODOVERDRAWN   =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODOVERDRAWN' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODNOCREDIT  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODNOCREDIT' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODINTSERVICE   =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODINTSERVICE' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODSTKSTATEMENT  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODSTKSTATEMENT' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,REFPERIODREVIEW  =(SELECT TOP 1 REFVALUE FROM PRO.REFPERIOD WHERE BUSINESSRULE = 'REFPERIODREVIEW' AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY)              
,1 AS INITIALASSETCLASSALT_KEY              
,1 AS FINALASSETCLASSALT_KEY              
,ABD.RefCustomerID AS RefCustomerID               
,ABD.RefCustomerID AS SourceSystemCustomerID              
,CBD.CUSTOMERENTITYID               
,ABD.BRANCHCODE            
,ABD.ProductAlt_Key                                                      
,ABD.CURRENTLIMIT                         
,ABD.CURRENTLIMITDT               
,NULL SchemeAlt_Key               
,ABD.SubSectorAlt_Key               
,ABD.FacilityType              
,NULL AS InttRate              
,ABD.AccountOpenDate AS AcOpenDt              
,ABD.DtofFirstDisb AS FirstDtOfDisb              
,1 AS PrvAssetClassAlt_Key              
,'U' AS FlgSecured              
,CBD.UCIF_ID              
,CBD.UcifEntityID              
FROM   dbo.AdvNFAcBasicDetail  ABD  INNER  HASH JOIN  PRO.CUSTOMERCAL   CBD ON abd.CUSTOMERENTITYID=CBD.CUSTOMERENTITYID                 
LEFT JOIN DimGLProduct C ON C.GLProductAlt_Key =ABD.GLProductAlt_Key              
AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)                                                         
WHERE (ABD.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND ABD.EFFECTIVETOTIMEKEY > =@TIMEKEY )              
GROUP BY                                                        
 ABD.BRANCHCODE                         
 ,ABD.CUSTOMERENTITYID                         
 ,ABD.ACCOUNTENTITYID                         
 ,ABD.SYSTEMACID                         
 ,ABD.CUSTOMERACID                        
 ,ABD.GLPRODUCTALT_KEY                        
 ,ABD.PRODUCTALT_KEY                        
 ,ABD.ACCOUNTOPENDATE                         
 ,ABD.FacilityType                       
 ,ABD.DTOFFIRSTDISB                                
 ,ABD.CURRENTLIMIT                         
 ,ABD.CURRENTLIMITDT               
 ,ABD.CURRENCYALT_KEY                
 ,ABD.REFCUSTOMERID                 
 ,ABD.ACTIVITYALT_KEY               
 ,ABD.SubSectorAlt_Key                
 ,ABD.OriginalLimitDt                  
 ,CBD.CUSTOMERENTITYID                
 ,CBD.UCIF_ID              
,CBD.UcifEntityID                            
        
OPTION (MAXDOP 1)                 
                
--alter index all on PRO.CUSTOMERCAL  rebuild                
--alter index all on PRO.accountcal   rebuild                  
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='INSERT DATA IN ACCOUNTCAL TABLE'                
                
                
/*------------------UPDATE PANNO IN CUSTOMER CAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE PANNO','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.PANNO=B.PAN FROM PRO.CUSTOMERCAL A                 
INNER JOIN DBO.AdvCustRelationship B                 
ON  A.CustomerEntityId=B.CustomerEntityId                
WHERE (B.PAN LIKE '%[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]%')                
AND( B.PAN NOT LIKE '%FORMO%' AND PAN NOT LIKE '%FORPM%' AND PAN NOT LIKE '%FORMF%' )                
AND (B.PAN IS NOT NULL)                
AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
UPDATE PRO.CUSTOMERCAL SET  PANNO=NULL WHERE PANNO='FORMO6161O'                
UPDATE PRO.CUSTOMERCAL SET  PANNO=NULL WHERE PANNO='FORPM6060F'                
UPDATE PRO.CUSTOMERCAL SET  PANNO=NULL WHERE PANNO='FORPM6060P'                
UPDATE PRO.CUSTOMERCAL SET  PANNO=NULL WHERE PANNO='FORMF6060F'                
UPDATE PRO.CUSTOMERCAL SET  PANNO=NULL WHERE PANNO='AAAAA1111A'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE PANNO'                
                
                
/*------------------UPDATE AADHAR NUMBER IN CUSTOMER CAL------------------*/                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE AADHAR NUMBER IN CUSTOMER CAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.AADHARCARDNO=B.AadhaarId FROM PRO.CUSTOMERCAL A                 
INNER JOIN DBO.AdvCustRelationship B                 
ON  A.CustomerEntityId=B.CustomerEntityId                
WHERE LEN(LTRIM(RTRIM(B.AadhaarId)))=12 AND B.AadhaarId LIKE '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'                
AND (B.AadhaarId IS NOT NULL)                
AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='000000000000'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='111111111111'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='222222222222'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='333333333333'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='444444444444'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='555555555555'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='666666666666'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='777777777777'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='888888888888'                
UPDATE PRO.CUSTOMERCAL SET AADHARCARDNO=NULL  WHERE AADHARCARDNO='999999999999'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE AADHAR NUMBER IN CUSTOMER CAL'                
                
                
                
----/*------------------INSERT INVALID PANCARDNO|AADHARCARDNO------------------*/                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'INSERT INVALID PANCARDNO|AADHARCARDNO','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
 DELETE  FROM  PRO.INVALIDPANAADHAR WHERE EFFECTIVEFROMTIMEKEY=@TIMEKEY AND EFFECTIVETOTIMEKEY=@TIMEKEY                
                
INSERT INTO PRO.INVALIDPANAADHAR                
(                
DATEOFDATA                
,CUSTOMERID                
,SOURCESYSTEMCUSTOMERID                
,CUSTOMERNAME                
,SOURCESYSTEMNAME                
,PANNO                
,AADHARCARD                
,EFFECTIVEFROMTIMEKEY                
,EFFECTIVETOTIMEKEY                
)                
SELECT @PROCESSINGDATE,A.RefCustomerID,A.SOURCESYSTEMCUSTOMERID,A.CUSTOMERNAME ,NULL AS SOURCESYSTEMNAME,B.PAN,NULL,@TIMEKEY,@TIMEKEY                 
FROM PRO.CUSTOMERCAL A                 
INNER JOIN DBO.AdvCustRelationship B                 
ON  A.CustomerEntityId=B.CustomerEntityId                
WHERE (B.PAN NOT LIKE '%[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]%')                
AND (B.PAN IS NOT NULL)                
AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
UNION ALL                
                
SELECT @PROCESSINGDATE,A.RefCustomerID,A.SOURCESYSTEMCUSTOMERID,A.CUSTOMERNAME ,NULL AS SOURCESYSTEMNAME, B.PAN,NULL,@TIMEKEY,@TIMEKEY FROM PRO.CUSTOMERCAL A                 
INNER JOIN DBO.AdvCustRelationship B                 
ON  A.CustomerEntityId=B.CustomerEntityId                
WHERE  ( B.PAN  LIKE '%FORMO%'  OR  B.PAN  LIKE '%FORPM%' OR  B.PAN  LIKE '%FORMF%')                
AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
INSERT INTO PRO.INVALIDPANAADHAR                
(                
DATEOFDATA                
,CUSTOMERID                
,SOURCESYSTEMCUSTOMERID                
,CUSTOMERNAME                
,SOURCESYSTEMNAME                
,PANNO                
,AADHARCARD                
,EFFECTIVEFROMTIMEKEY                
,EFFECTIVETOTIMEKEY                
)                
SELECT @PROCESSINGDATE,A.RefCustomerID,A.SOURCESYSTEMCUSTOMERID,A.CUSTOMERNAME , NULL AS SOURCESYSTEMNAME,NULL,B.AadhaarId,@TIMEKEY,@TIMEKEY FROM PRO.CUSTOMERCAL A                 
INNER JOIN DBO.AdvCustRelationship B                 
ON  A.CustomerEntityId=B.CustomerEntityId                
WHERE  B.AadhaarId NOT LIKE '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'                
AND (B.AadhaarId IS NOT NULL)                 
AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
           
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='INSERT INVALID PANCARDNO|AADHARCARDNO'                
                
                
                
/*-------------UPDATE ProductCode IN ACCOUNTCAL-------------------------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE ProductCode IN ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
---Condition Change Required  Modification Done---                 
                
UPDATE A SET ProductCode=C.ProductCode                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B ON A.AccountEntityID=B.AccountEntityID                
INNER  JOIN DimProduct C ON B.ProductAlt_Key=C.ProductAlt_Key                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
AND (C.EffectiveFromTimeKey<=@TIMEKEY and C.EffectiveToTimeKey>=@TIMEKEY)                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE ProductCode IN ACCOUNTCAL'                
                
---Condition Change Required  Modification Done---                 
                
  /*------------********UPDATE DRAWINGPOWER|REVIEWDUEDT FOR ALL ACCOUNT******--------------------*/                 
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE DRAWINGPOWER|REVIEWDUEDT FOR ALL ACCOUNT','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A SET A.DRAWINGPOWER=ISNULL(B.DRAWINGPOWER,0),                
--A.ReviewDueDt= (case when FACILITYTYPE in('DL','TL','PC','BP','BD') then null else DATEADD(DAY,90, B.Ac_NextReviewDueDt)   end )                
A.ReviewDueDt= (case when FACILITYTYPE in('DL','TL','PC','BP','BD') then null else  B.Ac_NextReviewDueDt   end )                
--,WriteOffAmount=ISNULL(B.WriteOffAmt_HO,0)                
FROM PRO.ACCOUNTCAL A INNER MERGE JOIN   dbo.AdvAcFinancialDetail  B                 
ON   (B.EFFECTIVEFROMTIMEKEY<= @TimeKey AND B.EFFECTIVETOTIMEKEY>=@TimeKey)                
AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                  
----------Added on 24-02-2022        
UPDATE A SET FACILITYTYPE=B.FACILITYTYPE,ReviewDueDt=Review_RenewDueDt  -----NON FUNDED CONDITION  ADDED IN ACL 24/02/2022 AS PER BANK REQUIREMENT        
FROM PRO.ACCOUNTCAL A INNER MERGE JOIN   curdat.AdvNFAcBasicDetail  B         
ON   (B.EFFECTIVEFROMTIMEKEY<= @TimeKey AND B.EFFECTIVETOTIMEKEY>=@TimeKey)     
AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID          
OPTION (MAXDOP 1)                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE DRAWINGPOWER|REVIEWDUEDT FOR ALL ACCOUNT'                
                
                
   /*------------********UPDATE FacilityType FOR TLDL ACCOUNT******--------------------*/                 
                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE Asset_Norm|FacilityType ISLAD  ACCOUNT','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
---Condition Change Required  Modification Done---                 
                
                
UPDATE A SET Asset_Norm='ALWYS_STD'--'CONDI_STD'                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B                
ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
AND ISNULL(B.ISLAD,0)=1                 
                
                
                
                
                
                
UPDATE A SET Asset_Norm='ALWYS_STD'                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B                
ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
AND assetclass='1'                
                
UPDATE A SET Asset_Norm='ALWYS_NPA'                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B                
ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
AND assetclass='2'                
                
---Condition Change Required  Modification Done---                 
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Asset_Norm|FacilityType ISLAD  ACCOUNT'                
                
                
                
/*-------------UPDATE BANK ASSET CLASSIFICATION IN ACCOUNTCALL------------------------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE BANK ASSET CLASSIFICATION IN ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A SET AccountStatus=B.SourceAssetClass                
             FROM pro.AccountCal A                
   INNER JOIN AdvAcBalanceDetail B                
   ON A.AccountEntityID=B.AccountEntityID                
   WHERE B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY         
                  
UPDATE  pro.AccountCal                
SET pro.AccountCal.BankAssetClass =C.AssetClassAlt_Key                
    FROM pro.AccountCal A                
   INNER JOIN AdvAcBalanceDetail B                
   ON A.AccountEntityID=B.AccountEntityID                
   Inner Join DimAssetClassMapping C ON C.SrcSysClassCode=A.AccountStatus                
   And C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY                
   Inner Join DIMSOURCEDB D On D.SourceAlt_Key=A.SourceAlt_Key                
   And D.EffectiveFromTimeKey<=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY                
  WHERE B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY                
   And D.SourceDBName<>'VISIONPLUS'                
                
                
UPDATE  pro.AccountCal                
SET pro.AccountCal.BankAssetClass = Case when A.AccountStatus=0 then 1                 
    when A.AccountStatus in (1,2) then 2 end                
    FROM pro.AccountCal A                
   INNER JOIN AdvAcBalanceDetail B                
   ON A.AccountEntityID=B.AccountEntityID                
   --Inner Join DimAssetClassMapping C ON C.SrcSysClassCode=A.AccountStatus                
   --And C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY                
   Inner Join DIMSOURCEDB D On D.SourceAlt_Key=A.SourceAlt_Key                
   And D.EffectiveFromTimeKey<=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY                
   WHERE B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY                
   And D.SourceDBName='VISIONPLUS'                
                  
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE BANK ASSET CLASSIFICATION IN ACCOUNTCAL'                
                
                
                
                
                
                
                
   /*------------********UPDATE ContiExcessDt FOR CC ACCOUNT******--------------------*/                 
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE ContiExcessDt FOR CC ACCOUNT','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                   
   ---Condition Change Required Modification Done ---                 
                     
 --EXEC PRO.ContExcsSinceDt             ----  Commented on 23/12/2021 by Sunil, Triloki Sir  After Discussion with Bank                 
                
 EXEC [PRO].[ContExcsSinceDtDebit]      ------------Added on 02-07-2021                
                
 /*      Commented on 23/12/2021 by Sunil, Triloki Sir  After Discussion with Bank                 
 UPDATE A SET                   
 A.ContiExcessDt=B.ContExcsSinceDt                
 FROM PRO.ACCOUNTCAL A INNER MERGE JOIN  [PRO].[ContExcsSinceDtAccountCal]  B                 
 ON   (B.EFFECTIVEFROMTIMEKEY<= @TimeKey AND B.EFFECTIVETOTIMEKEY>=@TimeKey)                
 AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                  
     OPTION (MAXDOP 1)                
  */                
                
  -------Added on 23/12/2021 by Sunil, Triloki Sir  After Discussion with Bank                 
                
  UPDATE A SET                   
 A.ContiExcessDt=B.ContExcsSinceDt                
 FROM PRO.ACCOUNTCAL A INNER MERGE JOIN  dbo.ADVFACCCDETAIL  B                 
 ON   (B.EFFECTIVEFROMTIMEKEY<= @TimeKey AND B.EFFECTIVETOTIMEKEY>=@TimeKey)                
 AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                  
     OPTION (MAXDOP 1)                
                
                
  UPDATE A SET                   
 A.DebitSinceDt=B.ContExcsSinceDebitDt                
 FROM PRO.ACCOUNTCAL A INNER MERGE JOIN  [PRO].[ContExcsSinceDtDebitAccountCal]  B                 
 ON   (B.EFFECTIVEFROMTIMEKEY<= @TimeKey AND B.EFFECTIVETOTIMEKEY>=@TimeKey)                
 AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                  
     OPTION (MAXDOP 1)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE ContiExcessDt FOR CC ACCOUNT'                
                
                
/*---------------******UPDATE Balance,OverdueAmt,OverDueSinceDt FROM AdvACBalanceDetail*******----------------------*/                  
                 
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE Balance,OverdueAmt,OverDueSinceDt FOR ALL ACCOUNT','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A                      
                
SET                 
 A.Balance=B.Balance,                
 --A.LastCrDate=(case when facilityType in('DL','TL','BP','BD','PC')  then null else  B.LastCrDt end),                
    --A.CreditsinceDt=B.LastCrDt,                
 A.CommonMocTypeAlt_Key=B.MocTypeAlt_Key,                
 A.FlgMoc=B.MocStatus,                
 A.MOC_Dt=B.MocDate,                
    A.OverDueSinceDt=B.OverDueSinceDt,                
    A.OverdueAmt=B.OverDue,                
    A.PrincOverdue=B.OverduePrincipal,               
    A.IntOverdue=B.Overdueinterest,                 
 A.PrincOutStd=B.PrincipalBalance,                
 A.AdvanceRecovery=B.AdvanceRecovery,                
 A.NotionalInttAmt=B.NotionalInttAmt,                
 A.DFVAmt=B.DFVAmt,                
 A.PrincOverdueSinceDt=B.OverduePrincipalDt,                
 A.IntOverdueSinceDt=B.OverdueIntDt,                
 A.OtherOverdue=B.OverOtherdue,                
 A.OtherOverdueSinceDt=B.OverdueOtherDt                
                 
                
FROM PRO.ACCOUNTCAL A INNER MERGE JOIN   dbo.ADVACBALANCEDETAIL  B                 
ON   (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
AND  A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                 
OPTION (MAXDOP 1)                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Balance,OverdueAmt,OverDueSinceDt FOR ALL ACCOUNT'                
                  
                
                  
/*------------------UPDATE OVERDUE SINCE DATE DUE TO DPD MAX FOR VISION PLUS DATA ONLY------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE OVERDUE SINCE DATE DUE TO DPD MAX FOR VISION PLUS DATA ONLY','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.OVERDUESINCEDT=DATEADD(DAY,-DPD + 1,@PROCESSINGDATE)     -- 14/07/2022 Overduesince date issue added + 1          
FROM PRO.AccountCal A INNER  JOIN dbo.AdvFacCreditCardDetail B ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY) AND ISNULL(B.DPD,0)>0            
                
                
UPDATE A SET Liability=B.Liability,CD=B.CD                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvFacCreditCardDetail B ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE OVERDUE SINCE DATE DUE TO DPD MAX FOR VISION PLUS DATA ONLY'                
                
                
                
----IF OBJECT_ID('TEMPDB..#TEMPTABLE_VISIONPLUS_ASSETCLASS') IS NOT NULL                
----  DROP TABLE #TEMPTABLE_VISIONPLUS_ASSETCLASS                
                
----  SELECT  SOURCESYSTEMCUSTOMERID,                
----MAX(CASE WHEN CD IN(5,6,7,8,9) THEN 2 ELSE 1 END ) ASSETCLASS ,                
----MIN(CASE WHEN CD IN(5,6,7,8,9) THEN FinalNpaDt ELSE NULL END) FinalNpaDt                  
----INTO #TEMPTABLE_VISIONPLUS_ASSETCLASS                
----FROM PRO.ACCOUNTCAL A                
----INNER JOIN DIMSOURCEDB B                
----ON A.SourceAlt_Key=B.SourceAlt_Key                
----WHERE SourceName='VISIONPLUS' AND B.EffectiveFromTimeKey<=@Timekey and B.EffectiveToTimeKey>=@Timekey                
----GROUP BY SOURCESYSTEMCUSTOMERID                
                
                
----IF OBJECT_ID('TEMPDB..#MAXDPD') IS NOT NULL                
----  DROP TABLE #MAXDPD                
                  
----SELECT A.SOURCESYSTEMCUSTOMERID,MIN(B.DPD_Max) AS DPD_Max INTO #MAXDPD  FROM #TEMPTABLE_VISIONPLUS_ASSETCLASS A                
----INNER JOIN PRO.ACCOUNTCAL B  ON A.SOURCESYSTEMCUSTOMERID=B.SOURCESYSTEMCUSTOMERID                
----WHERE  A.ASSETCLASS=2 AND B.DPD_Max>0                
----GROUP BY  A.SOURCESYSTEMCUSTOMERID                
                
----UPDATE B SET FinalNpaDt=DATEADD(DAY,-(A.DPD_Max-90),@PROCESSINGDATE)                
----FROM #MAXDPD A INNER JOIN #TEMPTABLE_VISIONPLUS_ASSETCLASS B ON A.SOURCESYSTEMCUSTOMERID=B.SOURCESYSTEMCUSTOMERID                
----WHERE B.FinalNpaDt IS NULL and A.DPD_Max>=90                
---------------------------------                
                
----UPDATE B SET FinalNpaDt=DATEADD(DAY,-A.DPD_Max,@PROCESSINGDATE)                
----FROM #MAXDPD A INNER JOIN #TEMPTABLE_VISIONPLUS_ASSETCLASS B ON A.SOURCESYSTEMCUSTOMERID=B.SOURCESYSTEMCUSTOMERID                
----WHERE B.FinalNpaDt IS NULL                
                
----UPDATE A SET A.SRCASSETCLASSALT_KEY=ISNULL(B.ASSETCLASS,1)                
----            ,A.SYSASSETCLASSALT_KEY=ISNULL(B.ASSETCLASS,1)                
----      ,A.SRCNPA_DT=B.FinalNpaDt                
----      ,A.SYSNPA_DT=B.FinalNpaDt                
----FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLE_VISIONPLUS_ASSETCLASS B                
----ON A.SOURCESYSTEMCUSTOMERID=B.SOURCESYSTEMCUSTOMERID                
                
                
/*-----update SrcAssetClass_Key key|SysAssetClassAlt_Key in customer Cal table--------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'SrcAssetClass_Key key|SysAssetClassAlt_Key','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                          
  ------UPDATE A SET                 
------A.SrcAssetClassAlt_Key=isnull(c.Cust_AssetClassAlt_Key,1),                
------A.SysAssetClassAlt_Key=isnull(c.Cust_AssetClassAlt_Key,1),                
------A.SrcNPA_Dt=isnull(C.NPADt,null),                
------A.SysNPA_Dt=isnull(C.NPADt,null),                
------A.DbtDt=isnull(C.DbtDt,null),                
------A.LossDt=isnull(C.LosDt,null)                
------FROM PRO.CUSTOMERCAL A  LEFT hash JOIN dbo.AdvCustNPAdetail C                
------ ON C.CustomerEntityId=A.CustomerEntityId                
------AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY)                 
                
UPDATE A SET                 
A.SrcAssetClassAlt_Key=isnull(c.SysAssetClassAlt_Key,1),                
A.SysAssetClassAlt_Key=isnull(c.SysAssetClassAlt_Key,1),                
A.SrcNPA_Dt=isnull(C.SysNPA_Dt,null),                
A.SysNPA_Dt=isnull(C.SysNPA_Dt,null),                
A.DbtDt=isnull(C.DbtDt,null),                
A.LossDt=isnull(C.LossDt,null)                
--,A.NpaTagDate=ISNULL(C.NpaTagDate,null)                
FROM PRO.CUSTOMERCAL A  LEFT hash JOIN PRO.customercal_hist C                
 ON C.CustomerEntityId=A.CustomerEntityId                
AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY-1 AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY-1)                 
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='SrcAssetClass_Key key|SysAssetClassAlt_Key'                
                  
                   
                  
/*------------------UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY PAN NO------------------*/                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY PAN NO','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
IF ISNULL(@PANCARDFLAG,'N')='Y'                
BEGIN                
                
IF OBJECT_ID('TEMPDB..#TEMPTABLEPANCARD') IS NOT NULL                
  DROP TABLE #TEMPTABLEPANCARD                
                   
 SELECT PANNO,MAX(ISNULL(SYSASSETCLASSALT_KEY,1)) SYSASSETCLASSALT_KEY                
 ,MIN(SYSNPA_DT) SYSNPA_DT                 
  INTO #TEMPTABLEPANCARD FROM PRO.CUSTOMERCAL A                
   INNER JOIN DIMSOURCEDB  B ON B.SOURCEALT_KEY=A.SOURCEALT_KEY AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
   WHERE PANNO IS NOT NULL AND  ISNULL(SYSASSETCLASSALT_KEY,1)<>1                
  GROUP BY  PANNO                
                
 ALTER TABLE  #TEMPTABLEPANCARD ADD SOURCEDBNAME VARCHAR (20)                
                
                 
 UPDATE A SET SOURCEDBNAME=C.SOURCEDBNAME                
  FROM #TEMPTABLEPANCARD  A                
  INNER JOIN PRO.CUSTOMERCAL B ON A.PANNO=B.PANNO            
  INNER JOIN DIMSOURCEDB  C ON B.SOURCEALT_KEY=C.SOURCEALT_KEY  AND C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY                 
  WHERE A.SYSNPA_DT=B.SYSNPA_DT                
                   
 UPDATE A SET A.SYSASSETCLASSALT_KEY=B.SYSASSETCLASSALT_KEY                
              ,A.SYSNPA_DT=B.SYSNPA_DT                  
  FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLEPANCARD B ON A.PANNO=B.PANNO                
                
  UPDATE A SET DEGREASON='PERCOLATION BY PAN CARD ' + ' ' + B.SOURCEDBNAME + '  ' + B.PANNO                 
   FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLEPANCARD B ON A.PANNO=B.PANNO                
  WHERE A.SRCASSETCLASSALT_KEY=1 AND A.SYSASSETCLASSALT_KEY>1                
   AND A.DEGREASON IS NULL                
                
                
                 
END                  
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY PAN NO'                
                
/*------------------UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY AADHAR CARD NO------------------*/                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY AADHARCARD NO','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
IF ISNULL(@AADHARCARDFLAG,'N')='Y'                
BEGIN                
                
IF OBJECT_ID('TEMPDB..#TEMPTABLE_ADHARCARD') IS NOT NULL                
    DROP TABLE #TEMPTABLE_ADHARCARD                
                
 SELECT AADHARCARDNO,MAX(ISNULL(SYSASSETCLASSALT_KEY,1)) SYSASSETCLASSALT_KEY                
 ,MIN(SYSNPA_DT) SYSNPA_DT ,B.SOURCEDBNAME                
                
  INTO #TEMPTABLE_ADHARCARD FROM PRO.CUSTOMERCAL A                
  INNER JOIN DIMSOURCEDB  B ON B.SOURCEALT_KEY=A.SOURCEALT_KEY AND B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
 WHERE A.AADHARCARDNO IS NOT NULL AND  ISNULL(A.SYSASSETCLASSALT_KEY,1)<>1                
                
 GROUP BY  AADHARCARDNO,B.SOURCEDBNAME                
                
 UPDATE A SET A.SYSASSETCLASSALT_KEY=B.SYSASSETCLASSALT_KEY                
              ,A.SYSNPA_DT=B.SYSNPA_DT                  
  FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLE_ADHARCARD B ON A.AADHARCARDNO=B.AADHARCARDNO                
    UPDATE A SET DEGREASON='PERCOLATION BY AADHAR CARD ' + ' ' + B.SOURCEDBNAME + '  ' + B.AADHARCARDNO                 
    FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLE_ADHARCARD B ON A.AADHARCARDNO=B.AADHARCARDNO                
  WHERE A. SRCASSETCLASSALT_KEY=1 AND A.SYSASSETCLASSALT_KEY>1                
   AND A.DEGREASON IS NULL                
END                  
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE SYSASSETCLASSALT_KEY|SYSNPA_DT BY AADHARCARD NO'                
                
                  
/*-----UPDATE SplCatg Alt_Key ACCOUNT LEVEL--------------- */                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'SplCatg Alt_Key ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A SET                 
 A.SplCatg1Alt_Key=ISNULL(B.SplCatg1Alt_Key,0)                
,A.SplCatg2Alt_Key=ISNULL(B.SplCatg2Alt_Key,0)                
,A.SplCatg3Alt_Key=ISNULL(B.SplCatg3Alt_Key,0)                
,A.SplCatg4Alt_Key=ISNULL(B.SplCatg4Alt_Key,0)                
FROM PRO.ACCOUNTCAL A INNER  JOIN dbo.AdvAcOtherDetail B ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
AND B.EffectiveFromTimeKey<=@TIMEKEY  AND B.EffectiveToTimeKey>=@TIMEKEY                 
                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='SplCatg Alt_Key ACCOUNT LEVEL'                
                 
/*-----UPDATE SplCatg Alt_Key CUSTOMER LEVEL--------------- */                
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE SplCatg Alt_Key CUSTOMER LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                          
UPDATE A SET                 
 A.SplCatg1Alt_Key=ISNULL(B.SplCatg1Alt_Key,0)                
,A.SplCatg2Alt_Key=ISNULL(B.SplCatg2Alt_Key,0)                
,A.SplCatg3Alt_Key=ISNULL(B.SplCatg3Alt_Key,0)                
,A.SplCatg4Alt_Key=ISNULL(B.SplCatg4Alt_Key,0)                
FROM PRO.CUSTOMERCAL A INNER  JOIN dbo.AdvCustOtherDetail B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
AND B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE SplCatg Alt_Key CUSTOMER LEVEL'                
                    
                 
                
/*----MARKING OF ALWAYS STD Account LEVEL----------------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'MARKING OF ALWAYS STD Account LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                       
Update ACL                 
SET Asset_Norm='ALWYS_STD'                
FROM  PRO.AccountCal ACL                
LEFT  JOIN DimScheme DSE ON DSE.EffectiveFromTimeKey<=@TimeKey                 
         AND DSE.EffectiveToTimeKey >=@TimeKey                
         AND ACL.SchemeAlt_Key = DSE.SchemeAlt_Key                 
                
                
LEFT OUTER  JOIN DimAcSplCategory DAS1 ON DAS1.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS1.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg1Alt_Key,0) =DAS1.SplCatAlt_Key                 
                               AND ISNULL(DAS1.AssetClass,'NORMAL')  = 'ALWYS_STD'                 
LEFT OUTER  JOIN DimAcSplCategory DAS2 ON DAS2.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS2.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg2Alt_Key,0) =DAS2.SplCatAlt_Key                
                               AND ISNULL(DAS2.AssetClass,'NORMAL')  = 'ALWYS_STD'                
LEFT OUTER  JOIN DimAcSplCategory DAS3 ON    DAS3.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS3.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg3Alt_Key,0) =DAS3.SplCatAlt_Key                 
                               AND ISNULL(DAS3.AssetClass,'NORMAL')  = 'ALWYS_STD'                 
LEFT OUTER  JOIN DimAcSplCategory DAS4 ON    DAS4.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS4.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg4Alt_Key,0) =DAS4.SplCatAlt_Key                 
                               AND ISNULL(DAS4.AssetClass,'NORMAL')  = 'ALWYS_STD'                                      
WHERE  ((ISNULL(DSE.AssetClass,'NORMAL')  = 'ALWYS_STD')                 
          OR (ISNULL(DAS1.AssetClass,'NORMAL') = 'ALWYS_STD')                
     OR (ISNULL(DAS2.AssetClass,'NORMAL') = 'ALWYS_STD')                
     OR (ISNULL(DAS3.AssetClass,'NORMAL') = 'ALWYS_STD')                
     OR (ISNULL(DAS4.AssetClass,'NORMAL') = 'ALWYS_STD'))                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='MARKING OF ALWAYS STD Account LEVEL'                
/*--------marking  always NPA account table level----------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'marking  always NPA account table level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                       
Update ACL                 
set Asset_Norm='ALWYS_NPA'                
FROM  PRO.AccountCal ACL                
LEFT  JOIN DimScheme DSE ON DSE.EffectiveFromTimeKey<=@TimeKey                 
         AND DSE.EffectiveToTimeKey >=@TimeKey                
         AND ACL.SchemeAlt_Key = DSE.SchemeAlt_Key                 
                 
LEFT OUTER  JOIN DimAcSplCategory DAS1 ON DAS1.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS1.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg1Alt_Key,0) =DAS1.SplCatAlt_Key                 
                               AND ISNULL(DAS1.AssetClass,'NORMAL')  = 'ALWYS_NPA'                 
LEFT OUTER  JOIN  DimAcSplCategory DAS2 ON DAS2.EffectiveFromTimeKey<=@TimeKey                 
                          AND DAS2.EffectiveToTimeKey >=@TimeKey                
           AND ISNULL(ACL.SplCatg2Alt_Key,0) =DAS2.SplCatAlt_Key                
                                AND ISNULL(DAS2.AssetClass,'NORMAL')  = 'ALWYS_NPA'                
LEFT OUTER  JOIN DimAcSplCategory DAS3 ON    DAS3.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS3.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg3Alt_Key,0) =DAS3.SplCatAlt_Key                 
                               AND ISNULL(DAS3.AssetClass,'NORMAL')  = 'ALWYS_NPA'                 
LEFT OUTER   JOIN DimAcSplCategory DAS4 ON    DAS4.EffectiveFromTimeKey<=@TimeKey                 
                         AND DAS4.EffectiveToTimeKey >=@TimeKey                
          AND ISNULL(ACL.SplCatg4Alt_Key,0) =DAS4.SplCatAlt_Key                 
                               AND ISNULL(DAS4.AssetClass,'NORMAL')  = 'ALWYS_NPA'                              
WHERE ((ISNULL(DSE.AssetClass,'NORMAL')  = 'ALWYS_NPA')                 
    OR (ISNULL(DAS1.AssetClass,'NORMAL')  = 'ALWYS_NPA')                
   OR (ISNULL(DAS2.AssetClass,'NORMAL')  = 'ALWYS_NPA')                
   OR (ISNULL(DAS3.AssetClass,'NORMAL')  = 'ALWYS_NPA')                
   OR (ISNULL(DAS4.AssetClass,'NORMAL')  = 'ALWYS_NPA'))                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='marking  always NPA account table level'                
                    
                
                
/*-----------------marking  always STD CUSTOMER  level------------*/                 
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'marking  always STD CUSTOMER  level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                       
Update A                  
SET Asset_Norm='ALWYS_STD'                
FROM  PRO.CustomerCal A                 
LEFT  JOIN DimConstitution DCO ON DCO.EffectiveFromTimeKey<=@TimeKey                 
               AND DCO.EffectiveToTimeKey >=@TimeKey                
         AND A.ConstitutionAlt_Key = DCO.ConstitutionAlt_Key                
LEFT  JOIN DimSplCategory DAS1 ON DAS1.EffectiveFromTimeKey<=@TimeKey                 
                  AND DAS1.EffectiveToTimeKey >=@TimeKey                
            AND A.SplCatg1Alt_Key = DAS1.SplCatAlt_Key                 
LEFT OUTER  JOIN DimSplCategory DAS2 ON DAS2.EffectiveFromTimeKey<=@TimeKey                 
                       AND DAS2.EffectiveToTimeKey >=@TimeKey                
                 AND A.SplCatg2Alt_Key  = DAS2.SplCatAlt_Key                 
LEFT OUTER  JOIN DimSplCategory DAS3 ON DAS3.EffectiveFromTimeKey<=@TimeKey                 
                       AND DAS3.EffectiveToTimeKey >=@TimeKey                
                 AND A.SplCatg3Alt_Key  = DAS3.SplCatAlt_Key                 
LEFT OUTER   JOIN DimSplCategory DAS4 ON DAS4.EffectiveFromTimeKey<=@TimeKey                 
                       AND DAS4.EffectiveToTimeKey >=@TimeKey                
                 AND A.SplCatg4Alt_Key  = DAS4.SplCatAlt_Key                 
WHERE ((ISNULL(DCO.AssetClass,'NORMAL')  = 'ALWYS_STD')                 
  OR (ISNULL(DAS1.AssetClass,'NORMAL')  = 'ALWYS_STD')                 
  OR (ISNULL(DAS2.AssetClass,'NORMAL')  = 'ALWYS_STD')                 
  OR (ISNULL(DAS3.AssetClass,'NORMAL')  = 'ALWYS_STD'                 
  OR  ISNULL(DAS4.AssetClass,'NORMAL')  = 'ALWYS_STD'))                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='marking  always STD CUSTOMER  level'                
                
/*---marking  always NPA CUSTOMER table level------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'marking  always NPA CUSTOMER table level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                  
UPDATE A                  
SET Asset_Norm='ALWYS_NPA'                
FROM PRO.CustomerCal A                 
LEFT  JOIN DimConstitution DCO ON (DCO.EffectiveFromTimeKey<=@TimeKey                 
               AND DCO.EffectiveToTimeKey >=@TimeKey)                
         AND A.ConstitutionAlt_Key =DCO.ConstitutionAlt_Key                
LEFT  JOIN DimSplCategory DAS1 ON (DAS1.EffectiveFromTimeKey<=@TimeKey                 
               AND DAS1.EffectiveToTimeKey >=@TimeKey)                
         AND A.SplCatg1Alt_Key  = DAS1.SplCatAlt_Key                 
LEFT OUTER  JOIN DimSplCategory DAS2 ON (DAS2.EffectiveFromTimeKey<=@TimeKey                 
                    AND DAS2.EffectiveToTimeKey >=@TimeKey)                
              AND A.SplCatg2Alt_Key  = DAS2.SplCatAlt_Key                 
LEFT OUTER  JOIN DimSplCategory DAS3 ON (DAS3.EffectiveFromTimeKey<=@TimeKey                 
                    AND DAS3.EffectiveToTimeKey >=@TimeKey)                
AND A.SplCatg3Alt_Key  = DAS3.SplCatAlt_Key                 
LEFT OUTER  JOIN DimSplCategory DAS4 ON (DAS4.EffectiveFromTimeKey<=@TimeKey                 
                    AND DAS4.EffectiveToTimeKey >=@TimeKey)                
      AND A.SplCatg4Alt_Key  = DAS4.SplCatAlt_Key                 
WHERE ((ISNULL(DCO.AssetClass,'NORMAL')  = 'ALWYS_NPA')                 
  OR   (ISNULL(DAS1.AssetClass,'NORMAL')  = 'ALWYS_NPA')                 
  OR   (ISNULL(DAS2.AssetClass,'NORMAL')  = 'ALWYS_NPA')                 
  OR   (ISNULL(DAS3.AssetClass,'NORMAL')  = 'ALWYS_NPA'                 
  OR    ISNULL(DAS4.AssetClass,'NORMAL')  = 'ALWYS_NPA'))                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='marking  always NPA CUSTOMER table level'                
                    
                
 /*----UPDATE ACCOUNTS WHOSE CUSTOMER IS IN ALWAYS STANDAED CATEGORY---------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE Accounts whose customer is in always standaed category','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE ABD SET Asset_Norm='ALWYS_STD'                
FROM PRO.AccountCal  ABD                
INNER HASH JOIN PRO.CustomerCal  CBD ON ABD.CustomerEntityId=CBD.CustomerEntityID                
WHERE CBD.Asset_Norm='ALWYS_STD'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Accounts whose customer is in always standaed category'                
                   
 /*----UPDATE ACCOUNTS WHOSE CUSTOMER IS IN ALWAYS NPA CATEGORY--------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE Accounts whose customer is in always NPA category','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
                
UPDATE ABD SET Asset_Norm='ALWYS_NPA'                
FROM PRO.AccountCal  ABD       
INNER HASH JOIN PRO.CustomerCal CBD ON ABD.CustomerEntityId=CBD.CustomerEntityID                
WHERE CBD.Asset_Norm='ALWYS_NPA'                
AND ABD.Asset_Norm<>'ALWYS_STD'                
                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Accounts whose customer is in always NPA category'                
                    
/*-------CurrAssetClassAlt_Key update in Account Cal from customer Cal systemAssetclassalt_key--------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'CurrAssetClassAlt_Key update in Account Cal from customer Cal systemAssetclassalt_key','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
                
--UPDATE A                
--SET A.INITIALASSETCLASSALT_KEY=ISNULL(B.SysAssetClassAlt_Key,1)                
--   ,A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)                
--   ,A.PrvAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)                
--FROM PRO.ACCOUNTCAL A LEFT  OUTER JOIN   PRO.CUSTOMERCAL  B                 
--ON   (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)                 
--AND A.CustomerEntityID=B.CustomerEntityID                
                
--OPTION (MAXDOP 1)                
                
                
----UPDATE A SET  A.INITIALASSETCLASSALT_KEY=isnull(c.Cust_AssetClassAlt_Key,1)                
----       ,A.PrvAssetClassAlt_Key=ISNULL(C.Cust_AssetClassAlt_Key,1)                
----FROM PRO.ACCOUNTCAL A  LEFT hash JOIN dbo.AdvCustNPAdetail C                
---- ON C.CustomerEntityId=A.CustomerEntityId                
----AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
                
UPDATE A SET  A.INITIALASSETCLASSALT_KEY=isnull(c.SysAssetClassAlt_Key,1)                
       ,A.PrvAssetClassAlt_Key=ISNULL(C.SysAssetClassAlt_Key,1)                
FROM PRO.ACCOUNTCAL A  LEFT hash JOIN PRO.CustomerCal_Hist C                
 ON C.CustomerEntityId=A.CustomerEntityId                
AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY-1 AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY-1)                
                
                
UPDATE A                
SET A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)                
FROM PRO.ACCOUNTCAL A LEFT  OUTER JOIN   PRO.CUSTOMERCAL  B                 
ON    A.CustomerEntityID=B.CustomerEntityID                
AND (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
                
                
UPDATE A                
SET A.FinalAssetClassAlt_Key=ISNULL(B.SysAssetClassAlt_Key,1)                
FROM PRO.ACCOUNTCAL A LEFT  OUTER JOIN   PRO.CUSTOMERCAL  B                 
ON    A.UcifEntityID=B.UcifEntityID                
AND (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
                
                
  UPDATE C SET C.FinalAssetClassAlt_Key=A.SYSASSETCLASSALT_KEY                
              --,C.FinalNpaDt=A.SYSNPA_DT                  
  FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLEPANCARD B ON A.PANNO=B.PANNO                
  Inner JOIN Pro.ACCOUNTCAL C ON C.UcifEntityID=A.UcifEntityID                
                
                
OPTION (MAXDOP 1)                
                
                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='CurrAssetClassAlt_Key update in Account Cal from customer Cal systemAssetclassalt_key'
  
    
      
        
          
            
               
               
                
/*---------UPDATE INITIALNPADT AND FINALNPADT AT ACCOUNT  LEVEL FROM CUSTOMER TO ACCOUNT------------- */                
                
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE InitialNpaDt AND FinalNpaDt AT Account  level from customer to account','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
--UPDATE A SET  A.InitialNpaDt=B.SrcNPA_Dt                
--             ,A.FinalNpaDt=B.SrcNPA_Dt                
--FROM PRO.ACCOUNTCAL  A INNER  JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
--WHERE A.INITIALASSETCLASSALT_KEY<>1                
                
------UPDATE A SET  A.InitialNpaDt=isnull(C.NPADt,null)                
------     FROM PRO.ACCOUNTCAL A  LEFT hash JOIN dbo.AdvCustNPAdetail C                
------ ON C.CustomerEntityId=A.CustomerEntityId                
------AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
                
UPDATE A SET  A.InitialNpaDt=isnull(C.SysNPA_Dt,null)                
     FROM PRO.ACCOUNTCAL A  LEFT hash JOIN PRO.CustomerCal_Hist C                
 ON C.CustomerEntityId=A.CustomerEntityId                
AND (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY-1 AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY-1)                
                
                
UPDATE A SET  A.FinalNpaDt=B.SrcNPA_Dt                
FROM PRO.ACCOUNTCAL  A INNER  JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
--WHERE A.INITIALASSETCLASSALT_KEY<>1                
                
                
UPDATE A SET  A.FinalNpaDt=B.SrcNPA_Dt                
FROM PRO.ACCOUNTCAL  A INNER  JOIN PRO.CUSTOMERCAL B ON A.UcifEntityID=B.UcifEntityID                
--WHERE A.INITIALASSETCLASSALT_KEY<>1                
                
  UPDATE C SET C.FinalNpaDt=A.SYSNPA_DT                  
  FROM PRO.CUSTOMERCAL A INNER JOIN #TEMPTABLEPANCARD B ON A.PANNO=B.PANNO                
  Inner JOIN Pro.ACCOUNTCAL C ON C.UcifEntityID=A.UcifEntityID                
                
                
UPDATE PRO.ACCOUNTCAL SET INITIALASSETCLASSALT_KEY=1,INITIALNPADT=NULL,FINALNPADT=NULL,FINALASSETCLASSALT_KEY=1,PrvAssetClassAlt_Key=1                
WHERE ASSET_NORM='ALWYS_STD' AND INITIALASSETCLASSALT_KEY<>1                 
                
                
 UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE InitialNpaDt AND FinalNpaDt AT Account  level from customer to account'        
  
    
      
        
                 
                 
                
 /*--------marking always NPA account table level where WriteOffAmount>0----------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'marking always NPA account table level where WriteOffAmount>0','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
---------Added on 20012022 by Triloki Sir on Bank Discusion to change asset class always Los            
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
   ,A.FinalAssetClassAlt_Key=6                 
   ,A.FinalNpaDt=CASE WHEN StatusDate is Not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,A.NPA_Reason='NPA DUE TO WRITEOFF MARKING'                
   ,A.WriteOffAmount=Amount                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
 ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.StatusType='TWO' And A.FinalAssetClassAlt_Key=1                
                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
   ,A.NPA_Reason='NPA DUE TO WRITEOFF MARKING'                
   ,A.WriteOffAmount=Amount                
   ,A.FinalAssetClassAlt_Key=6               
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
 ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.StatusType='TWO' And A.FinalAssetClassAlt_Key>1                
                
                
UPDATE C SET C.Asset_Norm='ALWYS_NPA'                
   ,C.SYSASSETCLASSALT_KEY=6                
   ,C.SYSNPA_DT=CASE WHEN StatusDate is Not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,C.DEGREASON='NPA DUE TO WRITEOFF MARKING'                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
 ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
 INNER JOIN PRO.CUSTOMERCAL C ON C.CustomerEntityId=A.CustomerEntityId                
where B.StatusType='TWO' And C.SysAssetClassAlt_Key=1                
                
 UPDATE C SET C.Asset_Norm='ALWYS_NPA'                
  ,C.SYSASSETCLASSALT_KEY=6                
  ,C.DEGREASON='NPA DUE TO WRITEOFF MARKING'                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
 ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
 INNER JOIN PRO.CUSTOMERCAL C ON C.CustomerEntityId=A.CustomerEntityId                
where B.StatusType='TWO' And C.SysAssetClassAlt_Key>1                   
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='marking always NPA account table level where WriteOffAmount>0'                
                
/*--------marking always NPA account table level where WriteOffAmount>0----------------*/                
        
                
                
 /*---------UPDATE PrvQtrRV  AT Customer level--------------------- */     /*---TO BE REMOVE GET VALUE FROM FUNCTION*/                
                 
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE PrvQtrRV  AT Customer level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
 ---Condition Change Required  Modification Done---                 
                
IF OBJECT_ID('TEMPDB..#PRVQTRRV') IS NOT NULL                
DROP TABLE #PRVQTRRV                
                
DECLARE @PRVQTRRV INT =(SELECT LastQtrDateKey FROM SYSDAYMATRIX WHERE TimeKey=@TIMEKEY)                
                
SELECT *                  
INTO #PRVQTRRV                 
FROM dbo.AdvCustSecurityFunpre(@PRVQTRRV)                
                  
UPDATE A SET A.PRVQTRRV= ISNULL(B.Total_PriSec,0)+ISNULL(B.Total_CollSec,0)  FROM PRO.CUSTOMERCAL A INNER  JOIN #PRVQTRRV B                
ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
                
                
 UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE PrvQtrRV  AT Customer level'                
                    
                
--/*----UPDATE SECURITY VALUE AT ACCOUNT LEVEL------------*/                
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE SECURITY VALUE AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
---Condition Change Required  Modification Done---                 
                
IF OBJECT_ID('TEMPDB..#TEMPSECURITY') IS NOT NULL                
DROP TABLE #TEMPSECURITY                
                
SELECT *                  
INTO #TEMPSECURITY                
FROM dbo.AdvAcSecurityFun(@TIMEKEY,'0')                
                  
UPDATE A SET A.SecurityValue= ISNULL(B.Total_PriSec,0)+ISNULL(B.Total_CollSec,0)  FROM PRO.AccountCal A INNER  JOIN #TEMPSECURITY B                
ON A.AccountEntityID=B.AccountEntityID                
                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='update security value at account level'                
                   
   /*------------------UPDATE FINAL CURNTQTRRV AT  CUSTOMER LEVEL------------------*/                 
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE FINAL CURNTQTRRV AT  CUSTOMER LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                 
UPDATE A SET A.CURNTQTRRV=ISNULL(A.CURNTQTRRV,0) FROM PRO.CUSTOMERCAL A  INNER JOIN                 
(                
SELECT A.CUSTOMERENTITYID,SUM(ISNULL(A.SecurityValue,0)) as CURNTQTRRV FROM PRO.ACCOUNTCAL A                 
INNER JOIN PRO.CUSTOMERCAL B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
WHERE  ISNULL(A.FLGABINITIO,'N')<>'Y'  AND A.FINALASSETCLASSALT_KEY NOT IN (6)                
GROUP BY A.CUSTOMERENTITYID                
) B ON A.CUSTOMERENTITYID=B.CUSTOMERENTITYID                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE FINAL CURNTQTRRV AT  CUSTOMER LEVEL'                
                   
/*----UPDATE SECURITY FLAG WHERE SECURITY AT CUSTOMER LEVEL BUT  SecApp UNSECURED AT ACCOUNT LEVEL------------*/                
                   
    INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
  SELECT ORIGINAL_LOGIN(),'UPDATE SECURITY FLAG WHERE SECURITY AT CUSTOMER LEVEL BUT  SecApp UNSECURED AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                 
 ---Condition Change Required Modification Done--- ---                 
                
UPDATE A SET SecApp='S'                
FROM  PRO.AccountCal A                
WHERE ISNULL(SecurityValue,0)>0                
AND A.SecApp='U'                
AND (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE A SET FlgSecured='D'                
FROM  PRO.AccountCal A                
WHERE ISNULL(SecurityValue,0)>0                
AND A.FlgSecured='U'                
AND (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)                
                
------------Added on 21/07/2021                
                
UPDATE A SET FlgSecured='S'                
FROM  PRO.AccountCal A                
WHERE ISNULL(SecurityValue,0)>0                
AND A.FinalAssetClassAlt_Key=2                
AND (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)                
                
                
 ---Condition Change Required  Modification Done---                 
                
UPDATE A SET FlgSecured='S'                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B ON A.AccountEntityID=B.AccountEntityID                
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
AND B.FlgSecured='S'                
AND A.FlgSecured='U'                
                
---------------Added on 19-03-2022 for NonFund Flg Secured -------        
            
UPDATE A SET FlgSecured=B.FlgSecuredNF              
FROM PRO.AccountCal A INNER  JOIN curdat.AdvNFAcBasicDetail B ON A.AccountEntityID=B.AccountEntityID              
WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)              
AND B.FlgSecuredNF is Not Null              
AND A.FlgSecured='U'              
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY     
AND DESCRIPTION='UPDATE SECURITY FLAG WHERE SECURITY AT CUSTOMER LEVEL BUT  SecApp UNSECURED AT ACCOUNT LEVEL'                
                
/*----UPDATE FLGABINITIO MARK AT ACCOUNT LEVEL---------*/                
                
                
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'update FlgAbinitio MARK at account level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
 ---Condition Change Required Modification Done---                 
                
----UPDATE A SET  A.FlgAbinitio='Y'                
----FROM  PRO.AccountCal A INNER JOIN  dbo.AdvSecurityValueDetail B ON                 
----   (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
----INNER  JOIN dbo.AdvSecurityDetail Advsec on Advsec.SecurityEntityID=b.SecurityEntityID                
----AND ( Advsec.EffectiveFromTimeKey < = @TimeKey AND Advsec.EffectiveToTimeKey   >= @TimeKey)                
---- AND  ISNULL(Advsec.SecurityAlt_Key,0)=990 AND A.AccountEntityId=Advsec.AccountEntityID                
                
 UPDATE A SET A.FlgAbinitio='Y'                
            FROM PRO.AccountCal A INNER JOIN ADVACOTHERDETAIL B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SPLFLAG LIKE '%Ab-Initio%'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='update FlgAbinitio MARK at account level'                
                   
/*----UPDATE FLGFITL MARK AT ACCOUNT LEVEL------------*/                
                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'update FlgFITL MARK at account level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A                  
SET A.FLGFITL='Y'                
FROM PRO.ACCOUNTCAL A                 
WHERE (ISNULL(A.SplCatg1Alt_Key,0)=755 OR ISNULL(A.SplCatg2Alt_Key,0)=755 OR ISNULL(A.SplCatg3Alt_Key,0)=755  OR ISNULL(A.SplCatg4Alt_Key,0)=755)                
                 
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='update FlgFITL MARK at account level'                
                   
                
   /*------------********UPDATE PaymentPending FOR NPA ACCOUNT******--------------------*/                 
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE PaymentPending FOR NPA ACCOUNT','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                   
IF OBJECT_ID('Tempdb..#CREDIT6Month') IS NOT NULL                
DROP TABLE #CREDIT6Month                 
                
Select SUM(ISNULL(TxnAmount,0)) TxnAmount,TXN.CustomerAcID,TXN.AccountEntityId                
INTO #CREDIT6Month                 
FROM ACDAILYTXNDETAIL TXN inner join                  
advacbasicdetail ABCD on TXN.AccountEntityId=ABCD.AccountEntityId                
inner join pro.accountcal ACCAL ON ABCD.AccountEntityId=ACCAL.AccountEntityId                
 where  TxnDate Between @6MonthBackDate and @ProcessingDate                
 AND CAST(TXN.TxnDate AS DATE) > CAST(ACCAL.FinalNpaDt AS DATE)                
AND TxnType='CREDIT' and TxnSubType in ('RECOVERY','OTHER CREDIT')                
AND ABCD.EffectiveFromTimeKey<=@TIMEKEY AND ABCD.EffectiveToTimeKey>=@TIMEKEY                
AND ACCAL.EffectiveFromTimeKey<=@TIMEKEY AND ACCAL.EffectiveToTimeKey>=@TIMEKEY                
AND ISNULL(TxnAmount,0)>0                
and FinalAssetClassAlt_Key>1        
group by TXN.CustomerAcID,TXN.AccountEntityId                
                
--UPDATE A SET PaymentPending='Y'                
--FROM PRO.ACCOUNTCAL A                
--INNER JOIN #CREDIT6Month B                
--ON A.AccountEntityId=B.AccountEntityId                
                
                
--UPDATE A SET RePossession=B.RePossession                
--FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B ON A.AccountEntityID=B.AccountEntityID                
--WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
                
--UPDATE A SET RCPending=B.RCPending                
--FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcBasicDetail B ON A.AccountEntityID=B.AccountEntityID                
--WHERE  (B.EffectiveFromTimeKey<=@TIMEKEY and B.EffectiveToTimeKey>=@TIMEKEY)                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE PaymentPending FOR NPA ACCOUNT'                
                
                   
/*------------------UPDATE OVERDUESINCEDT FROM BILL DETAIL TABLE------------------*/                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                
SELECT ORIGINAL_LOGIN(),'UPDATE OVERDUESINCEDT FROM BILL DETAIL TABLE ','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
                
/*------------------CALCULATE MINIMUMN BILL DUE DATE AND BillExtendedDueDt  DATE------------------*/                
                
IF OBJECT_ID('TEMPDB..#TEMPTABLEMINDATEEBill') IS NOT NULL                
    DROP TABLE #TEMPTABLEMINDATEEBill                
                
SELECT REFSYSTEMACID,MIN(BILLDUEDT) BILLDUEDT,MIN(BillExtendedDueDt) BillExtendedDueDt                 
INTO #TEMPTABLEMINDATEEBill                
FROM dbo.ADVFACBILLDETAIL                 
WHERE EFFECTIVEFROMTIMEKEY=@TIMEKEY AND EFFECTIVETOTIMEKEY=@TIMEKEY                 
AND ISNULL(BALANCE,0)>0                
GROUP BY REFSYSTEMACID                
                
/*------------------UPDATE MINIMUMN DATE IN ACCOUNT CAL TABLE------------------*/                
IF OBJECT_ID('TEMPDB..#TEMPTABLEMINOVERDUEDT') IS NOT NULL                
    DROP TABLE #TEMPTABLEMINOVERDUEDT                
                
SELECT REFSYSTEMACID,PRO.GETMINIMUMDATE(BILLDUEDT,BillExtendedDueDt,NULL) AS MINOVERDUE                 
INTO #TEMPTABLEMINOVERDUEDT                
FROM #TEMPTABLEMINDATEEBill                 
                
                
UPDATE PRO.ACCOUNTCAL SET OVERDUESINCEDT=B.MINOVERDUE                
FROM  PRO.ACCOUNTCAL A                 
INNER JOIN #TEMPTABLEMINOVERDUEDT B ON A.CUSTOMERACID=B.REFSYSTEMACID AND B.MINOVERDUE < = @PROCESSINGDATE                
                
                
                
IF OBJECT_ID('TEMPDB..#TEMPTABLEMINDATEPC') IS NOT NULL                
    DROP TABLE #TEMPTABLEMINDATEPC                
                
SELECT REFSYSTEMACID,MIN(PCDueDt) PCDueDt,MIN(PCExtendedDueDt) PCExtendedDueDt                 
INTO #TEMPTABLEMINDATEPC                
FROM dbo.ADVFACPCDETAIL                 
WHERE EFFECTIVEFROMTIMEKEY=@TIMEKEY AND EFFECTIVETOTIMEKEY=@TIMEKEY                 
AND ISNULL(BALANCE,0)>0                
GROUP BY REFSYSTEMACID           
                
/*------------------UPDATE MINIMUMN DATE IN ACCOUNT CAL TABLE------------------*/                
IF OBJECT_ID('TEMPDB..#TEMPTABLEMINOVERDUEDTPC') IS NOT NULL                
    DROP TABLE ##TEMPTABLEMINOVERDUEDTPC                
                
SELECT REFSYSTEMACID,PRO.GETMINIMUMDATE(PCDueDt,PCExtendedDueDt,NULL) AS MINOVERDUE                 
INTO #TEMPTABLEMINOVERDUEDTPC                
FROM #TEMPTABLEMINDATEPC                 
                
                
UPDATE PRO.ACCOUNTCAL SET OVERDUESINCEDT=B.MINOVERDUE                
FROM  PRO.ACCOUNTCAL A                 
INNER JOIN #TEMPTABLEMINOVERDUEDTPC B ON A.CUSTOMERACID=B.REFSYSTEMACID AND B.MINOVERDUE < = @PROCESSINGDATE                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE OVERDUESINCEDT FROM BILL DETAIL TABLE'                
                
                
                
/*-----UPDATE COVERGOVGUR BILL AT ACCOUNT LEVEL-------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE CoverGovGur BILL AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE  A SET A.COVERGOVGUR =C.COVERGOVGUR FROM PRO.ACCOUNTCAL A                 
INNER  JOIN(                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)) COVERGOVGUR FROM dbo.ADVFACBILLDETAIL A                
INNER  JOIN PRO.ACCOUNTCAL  B ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID              
WHERE  (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
GROUP BY A.ACCOUNTENTITYID)  C ON A.ACCOUNTENTITYID=C.ACCOUNTENTITYID                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE CoverGovGur BILL AT ACCOUNT LEVEL'                
                   
/*-----UPDATE COVERGOVGUR PC AT ACCOUNT LEVEL-------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE CoverGovGur PC AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE  A SET A.COVERGOVGUR =C.COVERGOVGUR FROM PRO.ACCOUNTCAL A                 
INNER  JOIN(                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)) COVERGOVGUR                
 FROM dbo.ADVFACPCDETAIL A             
INNER  JOIN PRO.ACCOUNTCAL  B ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
WHERE  (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
GROUP BY A.ACCOUNTENTITYID)  C ON A.ACCOUNTENTITYID=C.ACCOUNTENTITYID                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE CoverGovGur PC AT ACCOUNT LEVEL'                
                   
/*-----UPDATE COVERGOVGUR DL AT ACCOUNT LEVEL-------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE CoverGovGur DL AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A SET A.CoverGovGur=ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)                
FROM PRO.ACCOUNTCAL A INNER  JOIN dbo.ADVFACDLDETAIL B                
ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
WHERE ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)>0                
AND (B.EffectiveFromTimeKey<=@timekey and B.EffectiveToTimeKey>=@timekey)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE CoverGovGur DL AT ACCOUNT LEVEL'                
                   
/*-----UPDATE COVERGOVGUR CC AT ACCOUNT LEVEL-------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE CoverGovGur CC AT ACCOUNT LEVEL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
UPDATE A SET A.CoverGovGur=ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)                
FROM PRO.ACCOUNTCAL A INNER  JOIN dbo.AdvFacCCDetail B                
ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
WHERE ISNULL(ISNULL(CLAIMCOVERAMT,0)+ ISNULL(CLAIMRECEIVEDAMT,0),0)>0                
AND (B.EffectiveFromTimeKey<=@timekey and B.EffectiveToTimeKey>=@timekey)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE CoverGovGur CC AT ACCOUNT LEVEL'                
                  
                
  /*---------UPDATE PRVQTRINT,CURQTRINT,CURQTRCREDIT,PREQTRCREDIT-------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE PrvQtrInt,CurQtrInt,CurQtrCredit,PreQtrCredit','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
---Condition Change Required  Modification Done---                 
                
/*------------------Update PRVQTRINT,CURQTRINT,CURQTRCREDIT,PREQTRCREDIT------------------*/                 
                
----IF (@PROCESSMONTH = EOMONTH(@PROCESSMONTH))                
----BEGIN                
----EXEC [PRO].[UpdateCADCADURefBalRecovery] @TimeKey=@TimeKey                
----END               
                
EXEC [PRO].[UpdateCADCADURefBalRecovery] @TimeKey=@TimeKey                
                
                
--------New Condition Added for Normal Processing last Month CurQtrCredit and CurQtrInt 03/06/2021----                
----IF (@PROCESSMONTH <> EOMONTH(@PROCESSMONTH))                
----BEGIN                
----UPDATE a set CurQtrCredit=b.CurQtrCredit,CurQtrInt=b.CurQtrInt                
----from pro.accountcal a                
----inner join pro.accountcal_hist b                
----on a.CustomerAcID=b.CustomerAcID                
----where a.FinalAssetClassAlt_Key>1                
----AND (B.EffectiveFromTimeKey<=@LastMonthDateKey and B.EffectiveToTimeKey>=@LastMonthDateKey)                
----END                
               
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE PrvQtrInt,CurQtrInt,CurQtrCredit,PreQtrCredit'                
                
                
/*------------------UPDATE INTSERVICESDT IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE INTNOTSERVICEDDT IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.InttServiced='N'                
          -- ,A.INTNOTSERVICEDDT= DATEADD(DAY,-90,@PROCESSINGDATE)                
FROM PRO.ACCOUNTCAL A                 
INNER JOIN DimProduct C  ON A.ProductAlt_Key=C.ProductAlt_Key                 
WHERE ISNULL(A.Balance,0)>0  AND ISNULL(A.CurQtrCredit,0)<ISNULL(A.CurQtrInt,0)                 
AND  a.FacilityType IN('CC','OD')                
AND (DATEADD(DAY,90,A.FirstDtOfDisb)<@PROCESSINGDATE AND A.FirstDtOfDisb IS NOT NULL AND Asset_Norm<>'ALWYS_STD' )                
AND C.EffectiveFromTimeKey<=@timekey AND C.EffectiveToTimeKey>=@timekey                
AND isnull(C.ProductSubGroup,'N') NOT in('Agri Busi','Agri TL','KCC')                
                
--UPDATE A SET A.InttServiced='N',INTNOTSERVICEDDT=NULL                
UPDATE A SET A.InttServiced=NULL                
FROM PRO.ACCOUNTCAL A                 
INNER JOIN DimProduct C  ON A.ProductAlt_Key=C.ProductAlt_Key                 
WHERE   a.FacilityType IN('CC','OD')                
AND (DATEADD(DAY,90,A.DebitSinceDt)>@PROCESSINGDATE AND A.DebitSinceDt IS NOT NULL AND Asset_Norm<>'ALWYS_STD' )                
AND C.EffectiveFromTimeKey<=@timekey AND C.EffectiveToTimeKey>=@timekey                
AND isnull(C.ProductSubGroup,'N') NOT in('Agri Busi','Agri TL','KCC')                
AND InttServiced='N'                
                
  /*              
UPDATE A SET A.OVERDUEAMT=B.DEMANDAMT                
            ,A.INTNOTSERVICEDDT=B.DEMANDDATE                
     --,A.InttServiced='N'                
FROM PRO.ACCOUNTCAL A  INNER JOIN DimProduct C                 
 ON A.ProductAlt_Key=C.ProductAlt_Key                 
INNER JOIN                 
(                
SELECT  AccountEntityID ,SUM(BalanceDemand) DEMANDAMT,MIN(DemandOverDueDate) DEMANDDATE                 
FROM CurDat.AdvAcDemandDetail                
where EffectiveFromTimeKey<=@timekey AND EffectiveToTimeKey>=@timekey                
and ISNULL(BalanceDemand,0) > 0                
GROUP BY AccountEntityID                
) B  ON A.AccountEntityID=B.AccountEntityID                 
AND C.EffectiveFromTimeKey<=@timekey AND C.EffectiveToTimeKey>=@timekey                
AND C.ProductSubGroup  in('Agri Busi','Agri TL','KCC')                
*/      
------Changed by Triloki sir and Sunil on 25-04-2022      
                
UPDATE A SET A.INTNOTSERVICEDDT=A.IntOverdueSinceDt                
               
FROM PRO.ACCOUNTCAL A  INNER JOIN DimProduct C                 
 ON A.ProductAlt_Key=C.ProductAlt_Key                 
AND C.EffectiveFromTimeKey<=@timekey AND C.EffectiveToTimeKey>=@timekey                
AND C.ProductSubGroup  in('Agri Busi','Agri TL','KCC')                
      
      
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE INTNOTSERVICEDDT IN PRO.ACCOUNTCAL'                
                
                
/*------------OVERDUE SINCE DATE IS AVAILABLE BUT OVERDUE AMOUT IS ZERO-----------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'OVERDUE SINCE DATE IS AVAILABLE BUT OVERDUE AMOUT IS ZERO','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
--UPDATE A  SET A.OverDueSinceDt=(CASE WHEN isnull(A.OverdueAmt,0)<=0 THEN NULL ELSE A.OverDueSinceDt END)                
--FROM PRO.AccountCal A                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='OVERDUE SINCE DATE IS AVAILABLE BUT OVERDUE AMOUT IS ZERO'                
                   
                
----/*-----Stock statement date Data Preperation----------------------------------------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'Stock statement date Data Preperation','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
/*                
---------------Commented on 16082021 by Sunil                
                
IF OBJECT_ID('Tempdb..#Stock') IS NOT NULL                
DROP TABLE #Stock                
SELECT  AccountEntityId,MIN(ValuationDt) StkSmtDt,'S' TYPE                
INTO #Stock                
FROM(SELECT Advsec.AccountEntityId ,SecurityShortNameEnum,ISNULL(MAX(SecDtl.ValuationDate),'9999-01-01') ValuationDt                 
                FROM dbo.ADvSecurityValueDetail SecDtl                
     INNER  JOIN dbo.AdvSecurityDetail Advsec on Advsec.SecurityEntityID=SecDtl.SecurityEntityID                
                INNER  JOIN DimSecurity sec ON SecDtl.EffectiveFromTimeKey < = @TimeKey                
                                          AND SecDtl.EffectiveToTimeKey   >= @TimeKey                
                        AND Sec.EffectiveFromTimeKey < = @TimeKey                
                                          AND Sec.EffectiveToTimeKey > = @TimeKey                
                        AND Advsec.SecurityAlt_Key = Sec.SecurityAlt_Key                
                                AND  Advsec.EffectiveFromTimeKey < = @TimeKey                
                                        AND Advsec.EffectiveToTimeKey   >= @TimeKey                
   WHERE SecurityShortNameEnum IN('HYP-STOCK','HYP-BDEBT')                
   AND  Advsec.SecurityType='P' and ValuationDate is not null                
   GROUP BY Advsec.AccountEntityId,SecurityShortNameEnum) ST                
   GROUP BY AccountEntityId                
                
*/                
                
----CREATE CLUSTERED INDEX #Stock_IX ON #Stock(AccountEntityId)                
----CREATE NONCLUSTERED INDEX #StockNON ON #Stock(AccountEntityId,StkSmtDt)                
                
----IF OBJECT_ID('Tempdb..#Stock2') IS NOT NULL                
----DROP TABLE #Stock2                
----SELECT  AccountEntityId,MIN(ValuationDt) StkSmtDt,'W' TYPE                
----INTO #Stock2                
----FROM(SELECT SecDtl.AccountEntityId ,SecurityShortNameEnum,ISNULL(MAX(SecDtl.ValuationDt),'9999-01-01') ValuationDt                 
----            FROM dbo.ADvSecurityValueDetail SecDtl                
----            INNER  JOIN DimSecurity sec ON SecDtl.EffectiveFromTimeKey < = @TimeKey                
----                                          AND SecDtl.EffectiveToTimeKey   >= @TimeKey                
----                        AND Sec.EffectiveFromTimeKey < = @TimeKey                
----                                          AND Sec.EffectiveToTimeKey > = @TimeKey                
----            AND SecDtl.SecurityAlt_Key = Sec.SecurityAlt_Key                
----   WHERE SecurityShortNameEnum IN('PLD- WAREC-GEN','PLD- WAREC-NBHC','PLD- WAREC-NCMSL','PLD- WAREC-CWC','CARNC','CSRNC','WHRDMAT'                
----            ,'WHRMSW','WHRNG','WHRSACML','WHRSSL')                
----   AND  SecDtl.SecurityType='P'                 
----   GROUP BY SecDtl.AccountEntityId,SecurityShortNameEnum) ST                
----   GROUP BY AccountEntityId                
                
----CREATE CLUSTERED INDEX #Stock2_IX ON #Stock2(AccountEntityId)                
----CREATE NONCLUSTERED INDEX #Stock2NON ON #Stock2(AccountEntityId,StkSmtDt)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='STOCK STATEMENT DATE DATA PREPERATION'                
                
                
/*-----UPDATE STOCK STATEMENT DATE IN PRO.ACCOUNTCAL----------------------------------------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'update stock statement date in pro.accountcal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
/*                
--------------Commented on 16082021 by Sunil                
                
UPDATE A SET A.StockStDt=StkSmtDt                
FROM PRO.AccountCal A                 
INNER  JOIN #Stock SD ON A.AccountEntityId=SD.AccountEntityId                
where A.FacilityType='CC'                
                
*/                
                
---------------Added on 16082021 by Sunil                
                
UPDATE A SET A.StockStDt=SD.StockStmtDt               
FROM PRO.AccountCal A                 
INNER  JOIN Dbo.ADVFACCCDETAIL SD ON A.AccountEntityId=SD.AccountEntityId                 
ANd SD.EffectiveFromTimeKey<=@TIMEKEY And SD.EffectiveToTimeKey>=@TIMEKEY                
where A.FacilityType='CC'                
                
--------------------------                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='update stock statement date in pro.accountcal'                
                 
                
                
/*------UPDATE DerecognisedInterest1 AMT IN PRO.ACCOUNTCAL---------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE DerecognisedInterest1 AMT IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
IF OBJECT_ID('TEMPDB..#TEMPDerecognisedInterest1') IS NOT NULL                
  DROP TABLE #TEMPDerecognisedInterest1                
                
CREATE TABLE #TEMPDerecognisedInterest1                
(                
AccountEntityId int,                
DerecognisedInterest1 DECIMAL(18,2)                
)                
                
INSERT INTO #TEMPDerecognisedInterest1(AccountEntityId,DerecognisedInterest1)                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(DerecognisedInterest1,0)) DerecognisedInterest1 FROM dbo.ADVFACBILLDETAIL A                
WHERE (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
AND ISNULL(DerecognisedInterest1,0)>0                
GROUP BY A.ACCOUNTENTITYID                
                
UNION ALL                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(DerecognisedInterest1,0)) DerecognisedInterest1 FROM dbo.ADVFACPCDETAIL A                
WHERE (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
AND ISNULL(DerecognisedInterest1,0)>0                
GROUP BY A.ACCOUNTENTITYID                
                
UNION ALL                
SELECT B.ACCOUNTENTITYID,SUM(ISNULL(B.DerecognisedInterest1,0)) DerecognisedInterest1 FROM dbo.ADVFACCCDETAIL B                
WHERE (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY) AND ISNULL(DerecognisedInterest1,0)>0                
GROUP BY B.ACCOUNTENTITYID                
UNION ALL                
SELECT C.ACCOUNTENTITYID,SUM(ISNULL(C.DerecognisedInterest1,0)) DerecognisedInterest1 FROM dbo.ADVFACDLDETAIL C             
WHERE (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY) AND ISNULL(DerecognisedInterest1,0)>0                
GROUP BY C.ACCOUNTENTITYID                 
                
                
/*-----UPDATE DerecognisedInterest1 IN PRO.ACCOUNTCAL TABLE ----------------------------*/                
                
UPDATE A SET A.DerecognisedInterest1=B.DerecognisedInterest1                
FROM PRO.AccountCal A INNER JOIN #TEMPDerecognisedInterest1 B ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE DerecognisedInterest1 AMT IN PRO.ACCOUNTCAL'                
                   
                
                
/*------UPDATE DerecognisedInterest2 AMT IN PRO.ACCOUNTCAL---------------------*/                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE DerecognisedInterest2 AMT IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
IF OBJECT_ID('TEMPDB..#TEMPDerecognisedInterest2') IS NOT NULL                
  DROP TABLE #TEMPDerecognisedInterest2                
                
CREATE TABLE #TEMPDerecognisedInterest2                
(                
AccountEntityId int,                
DerecognisedInterest2 DECIMAL(18,2)                
)                
                
INSERT INTO #TEMPDerecognisedInterest2(AccountEntityId,DerecognisedInterest2)                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(DerecognisedInterest2,0)) DerecognisedInterest2 FROM dbo.ADVFACBILLDETAIL A                
WHERE (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
AND ISNULL(DerecognisedInterest2,0)>0                
GROUP BY A.ACCOUNTENTITYID                
                
UNION ALL                
SELECT A.ACCOUNTENTITYID,SUM(ISNULL(DerecognisedInterest2,0)) DerecognisedInterest2 FROM dbo.ADVFACPCDETAIL A                
WHERE (A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
AND ISNULL(DerecognisedInterest2,0)>0                
GROUP BY A.ACCOUNTENTITYID                
                
UNION ALL                
SELECT B.ACCOUNTENTITYID,SUM(ISNULL(B.DerecognisedInterest2,0)) DerecognisedInterest2 FROM dbo.ADVFACCCDETAIL B                
WHERE (B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY) AND ISNULL(DerecognisedInterest2,0)>0                
GROUP BY B.ACCOUNTENTITYID      UNION ALL                
SELECT C.ACCOUNTENTITYID,SUM(ISNULL(C.DerecognisedInterest2,0)) DerecognisedInterest2 FROM dbo.ADVFACDLDETAIL C                
WHERE (C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY) AND ISNULL(DerecognisedInterest2,0)>0                
GROUP BY C.ACCOUNTENTITYID                 
                
                
/*-----UPDATE DerecognisedInterest2 IN PRO.ACCOUNTCAL TABLE ----------------------------*/                
                
UPDATE A SET A.DerecognisedInterest2=B.DerecognisedInterest2                
FROM PRO.AccountCal A INNER JOIN #TEMPDerecognisedInterest2 B ON A.ACCOUNTENTITYID=B.ACCOUNTENTITYID                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE DerecognisedInterest2 AMT IN PRO.ACCOUNTCAL'                
                
/*-------------UPDATE GovGurAmt FROM ADVACOTHERDETAIL-------------------------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE GovGurAmt FROM ADVACOTHERDETAIL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
                
UPDATE A SET A.GovtGtyAmt=ISNULL(B.GovGurAmt,0)                
FROM PRO.AccountCal A INNER  JOIN dbo.AdvAcOtherDetail  B ON A.AccountEntityID=B.AccountEntityId        
AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
WHERE  ISNULL(B.GovGurAmt,0)>0                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE GovGurAmt FROM ADVACOTHERDETAIL'                
                
                
                
/*-------------UPDATE UnserviedInt FROM AdvAcFinancialDetail-------------------------------------*/                
                
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE UnserviedInt FROM ADVACBALANCEDETAIL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
                
update A SET UnserviedInt=B.Overdueinterest                
FROM PRO.AccountCal  A                
inner join dbo.ADVACBALANCEDETAIL  B on (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY )                
and a.AccountEntityID=B.AccountEntityId                  
Inner Join dbo.ADVFACCCDETAIL  C on (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY )                
and C.AccountEntityID=B.AccountEntityId                 
WHERE ISNULL(B.Overdueinterest,0)>0                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE  IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE UnserviedInt FROM ADVACBALANCEDETAIL'                
                
                
                
/*------------------UPDATE FRAUD ACCOUNT MARKING  IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE FRAUD ACCOUNT MARKING  IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.SplCatg4Alt_Key=870                
   ,A.FinalAssetClassAlt_Key=6                
   ,A.FinalNpaDt=CASE WHEN StatusDate is Not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,A.NPA_Reason='NPA DUE TO FRAUD MARKING'                
   ,A.FlgFraud='Y'                
   ,A.FraudDate=StatusDate                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.StatusType='Fraud Committed' And A.FinalAssetClassAlt_Key=1                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.SplCatg4Alt_Key=870                
   ,A.FinalAssetClassAlt_Key=6                
   ,A.NPA_Reason='NPA DUE TO FRAUD MARKING'                
   ,A.FlgFraud='Y'                
   ,A.FraudDate=StatusDate                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.StatusType='Fraud Committed' And A.FinalAssetClassAlt_Key>1                
                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE FRAUD ACCOUNT MARKING  IN PRO.ACCOUNTCAL'                
                
                
/*------------------UPDATE FRAUD ACCOUNT MARKING  IN PRO.CustomerCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE FRAUD ACCOUNT MARKING  IN PRO.CustomerCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
                
UPDATE C SET C.Asset_Norm='ALWYS_NPA'                
            ,C.SplCatg4Alt_Key=870                
   ,C.SYSASSETCLASSALT_KEY=6               
   ,C.SYSNPA_DT=CASE WHEN StatusDate is Not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,C.DEGREASON='NPA DUE TO FRAUD MARKING'                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
INNER JOIN PRO.CUSTOMERCAL C ON C.CustomerEntityId=A.CustomerEntityId                
where B.StatusType='Fraud Committed' And C.SysAssetClassAlt_Key=1                
                
                
UPDATE C SET C.Asset_Norm='ALWYS_NPA'                
            ,C.SplCatg4Alt_Key=870                
   ,C.SYSASSETCLASSALT_KEY=6                
   ,C.DEGREASON='NPA DUE TO FRAUD MARKING'                
FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
INNER JOIN PRO.CUSTOMERCAL C ON C.CustomerEntityId=A.CustomerEntityId                
where B.StatusType='Fraud Committed' And C.SysAssetClassAlt_Key>1          -- Date 16 Apr modify condition to validate NPA records only - Triloki      
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE FRAUD ACCOUNT MARKING  IN PRO.CustomerCal'                
                
                
/*------------------UPDATE IBPC MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE IBPC MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.IsIBPC='Y'                
            FROM PRO.AccountCal A INNER JOIN IBPCFinalPoolDetail B                 
ON A.CustomerAcID=B.AccountID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE IBPC MARKING  IN PRO.AccountCal'                
                
/*------------------UPDATE Securitised MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE Securitised MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.IsSecuritised='Y'                
            FROM PRO.AccountCal A INNER JOIN SecuritizedFinalACDetail B                 
ON A.CustomerAcID=B.AccountID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Securitised MARKING  IN PRO.AccountCal'                
                
/*------------------UPDATE PUI MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE PUI MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.PUI='Y'                
            FROM PRO.AccountCal A INNER JOIN AdvAcPUIDetailMain B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE A SET A.FlgRestructure='Y'                
   ,A.RestructureDate=B.RestructureDt                
            FROM PRO.AccountCal A INNER JOIN CurDat.AdvAcRestructureDetail B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE PUI MARKING  IN PRO.AccountCal'                
                
/*------------------UPDATE RFA MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE RFA MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.RFA='Y'                
            FROM PRO.AccountCal A INNER JOIN ADVACOTHERDETAIL B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SPLFLAG LIKE 'RFA%'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE RFA MARKING  IN PRO.AccountCal'                
                
/*------------------UPDATE NonCooperative MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE NonCooperative MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.IsNonCooperative='Y'                
            FROM PRO.AccountCal A INNER JOIN ADVACOTHERDETAIL B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SPLFLAG LIKE '%NonCooperative%'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE NonCooperative MARKING  IN PRO.AccountCal'                
                
                
                
                
/*------------------UPDATE Repossessed ACCOUNT MARKING  IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE Repossessed ACCOUNT MARKING  IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET  A.RePossession='Y'                
   FROM PRO.AccountCal A INNER JOIN AdvAcOtherDetail B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SplFlag LIKE '%Repossed%'                 
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.FinalAssetClassAlt_Key=2                
   ,A.FinalNpaDt=CASE WHEN REPOSSESSIONDATE is NULL then @PROCESSINGDATE else  REPOSSESSIONDATE end  --FinalNpaDt                
   ,A.NPA_Reason='NPA DUE TO Repossessed Account'                
   ,A.RePossession='Y'                
   FROM PRO.AccountCal A INNER JOIN AdvAcOtherDetail B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SplFlag LIKE '%Repossed%' and FinalAssetClassAlt_Key=1                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.NPA_Reason='NPA DUE TO Repossessed Account'                
   ,A.RePossession='Y'                
   FROM PRO.AccountCal A INNER JOIN AdvAcOtherDetail B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.SplFlag LIKE '%Repossed%' and FinalAssetClassAlt_Key>1                
                
update a set SysAssetClassAlt_Key=b.FinalAssetClassAlt_Key,SysNPA_Dt=b.FinalNpaDt,a.DegReason=b.NPA_Reason,a.Asset_Norm=b.Asset_Norm                
FROM pro.customercal a                
inner join PRO.AccountCal b                
on a.CustomerEntityID=b.CustomerEntityID                
where b.RePossession='Y'                 
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Repossessed ACCOUNT MARKING  IN PRO.ACCOUNTCAL'                
                
             
                
/*------------------UPDATE Inherent Weakness  ACCOUNT MARKING  IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE Inherent Weakness ACCOUNT MARKING  IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.FinalAssetClassAlt_Key=2                
   ,A.FinalNpaDt=CASE WHEN StatusDate is Not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,A.NPA_Reason='NPA DUE TO Inherent Weakness Account'                
   ,A.WeakAccount='Y'                
   FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where  B.StatusType='Inherent Weakness' and FinalAssetClassAlt_Key=1                
                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.NPA_Reason='NPA DUE TO Inherent Weakness Account'                
   ,A.WeakAccount='Y'                
   FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where  B.StatusType='Inherent Weakness' and FinalAssetClassAlt_Key>1                
                
                
                
update a set SysAssetClassAlt_Key=b.FinalAssetClassAlt_Key,SysNPA_Dt=b.FinalNpaDt,a.DegReason=b.NPA_Reason,a.Asset_Norm=b.Asset_Norm                
FROM pro.customercal a                
inner join PRO.AccountCal b                
on a.CustomerEntityID=b.CustomerEntityID                
where b.WeakAccount='Y'                 
                
                
UPDATE A SET A.FlgUnusualBounce='Y'                
            ,A.UnusualBounceDate=StatusDate                
                   
   FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where  B.StatusType='Unusual Bounce'                 
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Inherent Weakness ACCOUNT MARKING  IN PRO.ACCOUNTCAL'                
                
                
                
/*------------------UPDATE SARFAESI ACCOUNT MARKING IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE SARFAESI ACCOUNT MARKING IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.FinalAssetClassAlt_Key=2                
   ,A.FinalNpaDt=CASE WHEN StatusDate is not NULL then StatusDate  else  @PROCESSINGDATE end                
   ,A.NPA_Reason='NPA DUE TO SARFAESI  Account'                
   ,A.Sarfaesi='Y'                
   FROM PRO.AccountCal A                 
   INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where  B.StatusType='SARFAESI' AND FinalAssetClassAlt_Key=1                
                
                
                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.NPA_Reason='NPA DUE TO SARFAESI  Account'              
   ,A.Sarfaesi='Y'                
   FROM PRO.AccountCal A                 
   INNER JOIN ExceptionFinalStatusType B                 
ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where  B.StatusType='SARFAESI' AND FinalAssetClassAlt_Key>1                
                
                
                
update a set SysAssetClassAlt_Key=b.FinalAssetClassAlt_Key,SysNPA_Dt=b.FinalNpaDt,a.DegReason=b.NPA_Reason,a.Asset_Norm=b.Asset_Norm                
FROM pro.customercal a                
inner join PRO.AccountCal b                
on a.CustomerEntityID=b.CustomerEntityID                
where b.Sarfaesi='Y'                 
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE SARFAESI ACCOUNT MARKING IN PRO.ACCOUNTCAL'                
                
                
/*------------------UPDATE RC-Pending MARKING  IN PRO.AccountCal------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE RC-Pending MARKING  IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
UPDATE A SET A.RCPending='Y'                
            FROM PRO.AccountCal A INNER JOIN ExceptionFinalStatusType B   ON A.CustomerAcID=B.ACID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where B.StatusType='RC Pending'                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR'))                 
AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE RC-Pending MARKING  IN PRO.AccountCal'                
                
/*------------------UPDATE Written-Off Accounts ACCOUNT MARKING  IN PRO.ACCOUNTCAL------------------*/                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE Written-Off Accounts MARKING IN PRO.ACCOUNTCAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
/*                
UPDATE A SET A.Asset_Norm='ALWYS_NPA'                
            ,A.SplCatg4Alt_Key=860                
   ,A.FinalAssetClassAlt_Key=2                
   ,A.FinalNpaDt=CASE WHEN FinalNpaDt is NULL then @PROCESSINGDATE else  FinalNpaDt end                
   ,A.NPA_Reason='NPA DUE TO Written-Off Account'                
   FROM PRO.AccountCal A INNER JOIN AdvAcOtherDetail B                 
ON A.AccountEntityID=B.AccountEntityID AND (B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY)                
where 860 IN (ISNULL(B.SplCatg1Alt_Key,0),ISNULL(B.SplCatg2Alt_Key,0),ISNULL(B.SplCatg3Alt_Key,0),ISNULL(B.SplCatg4Alt_Key,0))                
and FinalAssetClassAlt_Key=1                
*/                
---------  Changed on 22-05-2021                 
Update B Set B.Asset_Norm='ALWYS_NPA'                
FROM PRO.AccountCal A INNER JOIN Pro.CUSTOMERCAL B                 
ON A.UcifEntityID=B.UcifEntityID                
Where A.Asset_Norm='ALWYS_NPA' And B.UcifEntityID>0                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Written-Off Accounts MARKING IN PRO.ACCOUNTCAL'                
                
                
                
INSERT INTO PRO.PROCESSMONITOR(USERID,DESCRIPTION,MODE,STARTTIME,ENDTIME,TIMEKEY,SETID)                 
SELECT ORIGINAL_LOGIN(),'UPDATE CONDI_STD IN PRO.AccountCal','RUNNING',GETDATE(),NULL,@TIMEKEY,@SETID                
                
                
                
---Condition Change Required  Modification Done---                 
                
------UPDATE A SET A.Asset_Norm=(CASE WHEN A.Balance-ISNULL(e.CurrentValue,0) <=0 THEN 'ALWYS_STD'ELSE 'CONDI_STD' END)                
UPDATE A SET A.Asset_Norm='CONDI_STD'                 
   FROM PRO.AccountCal A                
   INNER JOIN (                
      SELECT C.AccountEntityID,SUM(isnull(CurrentValue,0)) CurrentValue                
            FROM dbo.AdvSecurityVAlueDetail B                
   INNER  JOIN dbo.AdvSecurityDetail Advsec on Advsec.SecurityEntityID=b.SecurityEntityID                
    INNER JOIN PRO.AccountCal C ON Advsec.AccountEntityID=C.AccountEntityID                  
     AND Advsec.SecurityAlt_Key = Advsec.SecurityAlt_Key                
                                AND  Advsec.EffectiveFromTimeKey < = @TimeKey                
                                        AND Advsec.EffectiveToTimeKey   >= @TimeKey                
   INNER JOIN DimSecurity D ON D.EffectiveFromTimeKey<=@TIMEKEY                
             AND D.EffectiveToTimeKey>=@TIMEKEY                
             AND D.SecurityAlt_Key=Advsec.SecurityAlt_Key                 
   WHERE  Advsec.SecurityType='P'                 
   --AND ISNULL(D.SecurityShortNameEnum,'') IN('PLD-NSC','PLD-KVP','PLD-G SEC','ASGN-LIFE POL','LI-FDR','LI-FDRSUBSI','LI-NRE DEP'                
                                                  --    ,'LI-NRNR DEP','LI-FCNR-DEP','LI-RD-DEP','DEPNFBR')                 
   AND D.SecurityCRM='Y'                
  --  and ISNULL(C.Asset_Norm,'NORMAL')='CONDI_STD'                  
                              
  GROUP BY C.AccountEntityID                
    ) E  ON A.AccountEntityID=E.AccountEntityID                
    and  ISNULL(A.Balance,0)>0   AND ISNULL(A.Balance,0)>ISNULL(A.SecurityValue,0)                
                
    ---Condition Change Required  Modification Done---                  
                
    EXEC  PRO.ContinousExcessSecDtAccountCalLogic                
                
                    
   UPDATE A SET ContiExcessDt=ContinousExcessSecDt                
   FROM PRO.AccountCal A                
   INNER JOIN Pro.ContinousExcessSecDtAccountCal B                
   ON A.CustomerAcID=B.CustomerAcID                
   WHERE B.EffectiveFromTimeKey<=@TIMEKEY AND B.EffectiveToTimeKey>=@TIMEKEY                
                   
   ---As per discussion with bank ContiExcessDt null for KCC product 03/06/2021-----                
                   
    UPDATE  A set ContiExcessDt=null                
    FROM PRO.ACCOUNTCAL A                 
    INNER JOIN DimProduct C  ON A.ProductAlt_Key=C.ProductAlt_Key                 
    WHERE C.ProductSubGroup  in('Agri Busi','Agri TL','KCC')                
    AND C.EffectiveFromTimeKey<=@timekey AND C.EffectiveToTimeKey>=@timekey                     
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE'                 
WHERE IDENTITYKEY = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND  TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE CONDI_STD IN PRO.AccountCal'                
                
                
/*      Commented on 20-05-2021 as it is not required for ACL                
                
   /*------------********UPDATE Last Credit Date******--------------------*/                 
INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
SELECT ORIGINAL_LOGIN(),'UPDATE Last Credit Date','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                     
  ---Condition Change Required Modification Done  ---                 
                
 EXEC PRO.LastCreditDtAccountCalUpdate                
                
 UPDATE A SET                   
 A.LastCrDate=B.LastCrDate                
 FROM PRO.ACCOUNTCAL A INNER MERGE JOIN  [PRO].[LastCreditDtAccountCal]  B                
 ON   (B.EFFECTIVEFROMTIMEKEY<= @TIMEKEY AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY)                
 AND  A.CustomerAcID=B.CustomerAcID                  
                
   OPTION (MAXDOP 1)                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE Last Credit Date'                
                
*/                
                
/*---------UPDATE AddlProvisionAmount  AT Account level--------------------- */                    
                 
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE AddlProvisionAmount  AT Account level','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                
                
 ---Condition Change Required ---                 
                
                
--IF OBJECT_ID('TEMPDB..#AddlProvisionAmount') IS NOT NULL                
--DROP TABLE #AddlProvisionAmount                
                
--select AccountEntityID,CustomerAcID,AddlProvisionPer, AddlProvision,MOCTYPE                
--into #AddlProvisionAmount                
--from pro.accountcal_hist   A                
--where A.EffectiveFromTimeKey<=@LastQtrDateKey and A.EffectiveToTimeKey>=@LastQtrDateKey                 
--and AddlProvision>0                 
----and MOCTYPE='Manual'                
                
                 
--UPDATE B SET ADDLPROVISIONPER=A.ADDLPROVISIONPER,ADDLPROVISION=A.ADDLPROVISION,MOCTYPE=A.MOCTYPE                
--FROM #ADDLPROVISIONAMOUNT A                
--INNER JOIN PRO.ACCOUNTCAL B                
--ON A.CUSTOMERACID=B.CUSTOMERACID                
                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE AddlProvisionAmount  AT Account level'                
                    
                
----UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=B.NPADATE,A.FLGMOC='Y',A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.MOCREASON,DEGREASON='NPA DUE TO MOC',A.MOC_DT=B.DATECREATED,A.MOCTYPE=B.MOCTYPE                
----  FROM PRO.CUSTOMERCAL A                
---- INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----     INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME<>'STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----         DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='MANUAL' AND B.EFFECTIVETOTIMEKEY=49999                
                
----UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=B.NPADATE,A.FLGMOC='Y',A.ASSET_NORM='NORMAL',A.MOCREASON=B.MOCREASON,DEGREASON='NPA DUE TO MOC',A.MOC_DT=B.DATECREATED,A.MOCTYPE=B.MOCTYPE                
----FROM PRO.CUSTOMERCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----    INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME<>'STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='AUTO' AND  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
                
----UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=NULL,A.DBTDT =NULL,A.FLGMOC='Y',A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.MOCREASON,DEGREASON='STD DUE TO MOC',A.MOC_DT=B.DATECREATED,A.MOCTYPE=B.MOCTYPE                
---- FROM PRO.CUSTOMERCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----  INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME='STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='MANUAL' AND B.EFFECTIVETOTIMEKEY=49999                
                
----UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=NULL,A.DBTDT =NULL,A.FLGMOC='Y',A.ASSET_NORM='NORMAL',A.MOCREASON=B.MOCREASON,DEGREASON='STD DUE TO MOC',A.MOC_DT=B.DATECREATED,A.MOCTYPE=B.MOCTYPE                
---- FROM PRO.CUSTOMERCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
---- INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME='STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='AUTO' AND  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
                
----UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=B.NPADATE,A.FlgMoc='Y',A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.MOCREASON,DEGREASON='NPA DUE TO MOC',A.MOC_DT=B.DATECREATED                
----       FROM PRO.ACCOUNTCAL A                
---- INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----     INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME<>'STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='MANUAL' AND B.EFFECTIVETOTIMEKEY=49999                
                
----UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=B.NPADATE,A.FLGMOC='Y',A.ASSET_NORM='NORMAL',A.MOCREASON=B.MOCREASON,DEGREASON='NPA DUE TO MOC',A.MOC_DT=B.DATECREATED                
----FROM PRO.ACCOUNTCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----    INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME<>'STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='AUTO' AND  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
                
----UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=NULL,A.FLGMOC='Y',A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.MOCREASON,DEGREASON='STD DUE TO MOC',A.MOC_DT=B.DATECREATED                
---- FROM PRO.ACCOUNTCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
----  INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME='STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='MANUAL' AND B.EFFECTIVETOTIMEKEY=49999                
                
----UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=NULL,A.FLGMOC='Y',A.ASSET_NORM='NORMAL',A.MOCREASON=B.MOCREASON,DEGREASON='STD DUE TO MOC',A.MOC_DT=B.DATECREATED            
---- FROM PRO.ACCOUNTCAL A                
----INNER JOIN DATAUPLOAD.MocCustomerDailyDataUpload B ON A.REFCUSTOMERID=B.CUSTOMERID                
---- INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSSHORTNAME= B.ASSETCLASSIFICATION AND                
----                           DA.ASSETCLASSSHORTNAME='STD' AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE B.MOCTYPE='AUTO' AND  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY                
                
                
                
----UPDATE  A SET DBTDT=@PROCESSINGDATE FROM PRO.CUSTOMERCAL A                  
----INNER JOIN DIMASSETCLASS DA       ON  DA.ASSETCLASSALT_KEY= A.SYSASSETCLASSALT_KEY AND                
----                           DA.ASSETCLASSSHORTNAME IN ('DB1','DB2','DB3') AND                  
----                           DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND                
----                   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY                
----WHERE DBTDT IS NULL                
                
----UPDATE DATAUPLOAD.MocCustomerDailyDataUpload SET EFFECTIVETOTIMEKEY=EFFECTIVEFROMTIMEKEY WHERE MOCTYPE='AUTO'                
                
                
                
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)                
 SELECT ORIGINAL_LOGIN(),'UPDATE MOC CHANGES','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID                            
/*  UPDATE MOC STATUS  */                
 DECLARE @PrevMonthTimeKey INT=(SELECT LastMonthDateKey FROM SysDayMatrix WHERE TimeKey =@TIMEKEY)                
                
                
 DROP TABLE IF EXISTS #MOC_DATA                
 SELECT UcifEntityID,MAX(SysAssetClassAlt_Key) SysAssetClassAlt_Key,MIN(SysNPA_Dt) SysNPA_Dt                  
  INTO #MOC_DATA                
 FROM PRO.CustomerCal_Hist                 
 WHERE EffectiveFromTimeKey<=@PrevMonthTimeKey AND EffectiveToTimeKey >=@PrevMonthTimeKey                
 AND LTRIM(RTRIM(MOCTYPE))='Manual'                
 GROUP BY UcifEntityID                
                
                
 UPDATE A                
  SET A.Asset_Norm=CASE WHEN B.SysAssetClassAlt_Key=1 THEN 'ALWYS_STD'                
        ELSE 'ALWYS_NPA' END                
   ,MOCTYPE='Manual'                
   ,SysAssetClassAlt_Key=B.SysAssetClassAlt_Key                
   ,SrcAssetClassAlt_Key=B.SysAssetClassAlt_Key                
   ,SysNPA_Dt=B.SysNPA_Dt                
   ,SrcNPA_Dt=b.SysNPA_Dt                
 FROM pro.CustomerCal A                
  INNER JOIN #MOC_DATA  B                
   ON A.UcifEntityID=B.UcifEntityID                
                
 UPDATE A                
  SET A.Asset_Norm=CASE WHEN B.SysAssetClassAlt_Key=1 THEN 'ALWYS_STD'                
        ELSE 'ALWYS_NPA' END                
   ,MOCTYPE='Manual'                
   ,FinalAssetClassAlt_Key=B.SysAssetClassAlt_Key                
   ,InitialAssetClassAlt_Key=b.SysAssetClassAlt_Key                
   ,InitialNpaDt=B.SysNPA_Dt                
   ,FinalNpaDt=b.SysNPA_Dt                
 FROM pro.ACCOUNTCAL A                
  INNER JOIN #MOC_DATA  B                
   ON A.UcifEntityID=B.UcifEntityID                
                
UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='UPDATE MOC CHANGES'                
                    
                
/* -------------------------------end of moc updates   */                
              
-------------ADDED ON 18/02/2022        
        
/*  UPDATE MOC AND ADHOC CHANGES */        
 INSERT INTO PRO.ProcessMonitor(UserID,Description,MODE,StartTime,EndTime,TimeKey,SetID)        
 SELECT ORIGINAL_LOGIN(),'MOC UPDATES AUTO AND MANUAL','RUNNING',GETDATE(),NULL,@TIMEKEY,@SetID        
        
        
/* ADHOC CHANGE WORK */        
         
   UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=B.NPA_Date,A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.Reason,DEGREASON='NPA DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
       FROM PRO.CUSTOMERCAL A        
    INNER JOIN AdhocACL_ChangeDetails B ON A.CustomerEntityId=B.CustomerEntityId        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME<>'STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND    DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
   UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=B.NPA_Date,A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.Reason,DEGREASON='NPA DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
       FROM PRO.CUSTOMERCAL A        
    INNER JOIN AdhocACL_ChangeDetails B ON A.UcifEntityID=B.UcifEntityID        
       and isnull(A.UcifEntityID,0)<>0        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME<>'STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND    DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE  B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
   UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=NULL,A.DBTDT =NULL,A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.REASON,DEGREASON='STD DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
    FROM PRO.CUSTOMERCAL A        
   INNER JOIN AdhocACL_ChangeDetails B ON A.CustomerEntityId=B.CustomerEntityId        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME='STD' AND      DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
   DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
   UPDATE A SET A.SYSASSETCLASSALT_KEY=DA.ASSETCLASSALT_KEY,A.SYSNPA_DT=NULL,A.DBTDT =NULL,A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.REASON,DEGREASON='STD DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
    FROM PRO.CUSTOMERCAL A        
   INNER JOIN AdhocACL_ChangeDetails B ON A.UcifEntityID=B.UcifEntityID        
         and isnull(A.UcifEntityID,0)<>0        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME='STD' AND      DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
          DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
        
   UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=B.NPA_Date,A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.REASON,DEGREASON='NPA DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
       FROM PRO.ACCOUNTCAL A        
    INNER JOIN AdhocACL_ChangeDetails B ON A.CustomerEntityId=B.CustomerEntityId        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME<>'STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
          DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
   UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=B.NPA_Date,A.ASSET_NORM='ALWYS_NPA',A.MOCREASON=B.REASON,DEGREASON='NPA DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
       FROM PRO.ACCOUNTCAL A        
    INNER JOIN AdhocACL_ChangeDetails B ON A.UcifEntityID=B.UcifEntityID        
       and isnull(A.UcifEntityID,0)<>0        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME<>'STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
          DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
        
   UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=NULL,A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.REASON,DEGREASON='STD DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
    FROM PRO.ACCOUNTCAL A        
   INNER JOIN AdhocACL_ChangeDetails B ON A.CustomerEntityId=B.CustomerEntityId        
     INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME='STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
          DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
   UPDATE A SET A.FinalAssetClassAlt_Key=DA.ASSETCLASSALT_KEY,A.FinalNpaDt=NULL,A.ASSET_NORM='ALWYS_STD',A.MOCREASON=B.REASON,DEGREASON='STD DUE TO Adhoc',A.MOC_DT=B.DATECREATED        
    FROM PRO.ACCOUNTCAL A        
   INNER JOIN AdhocACL_ChangeDetails B ON A.UcifEntityID=B.UcifEntityID        
     and isnull(A.UcifEntityID,0)<>0        
    INNER JOIN DIMASSETCLASS DA       ON  DA.AssetClassAlt_Key= B.AssetClassAlt_Key AND        
            DA.ASSETCLASSSHORTNAME='STD' AND          
            DA.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND        
          DA.EFFECTIVETOTIMEKEY>=@TIMEKEY        
   WHERE B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND  B.EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
   UPDATE AdhocACL_ChangeDetails SET EFFECTIVETOTIMEKEY=@TIMEKEY  where  EFFECTIVEFROMTIMEKEY<=@TIMEKEY AND EFFECTIVETOTIMEKEY>=@TIMEKEY        
        
  UPDATE PRO.PROCESSMONITOR SET ENDTIME=GETDATE() ,MODE='COMPLETE' WHERE IdentityKey = (SELECT IDENT_CURRENT('PRO.PROCESSMONITOR')) AND TIMEKEY=@TIMEKEY AND DESCRIPTION='MOC UPDATES AUTO AND MANUAL'         
      
/* END OF ADHOC CHAMGE */        
          
        
        
                
                  
                  
/*RESTRUCTURE UPDATES */                
                
TRUNCATE TABLE [PRO].[AdvAcRestructureCal]                 
                
------------------------Insert Data for Base Columns                 
INSERT INTO [PRO].[AdvAcRestructureCal]                
 (                
   AccountEntityId                
   ,AssetClassAlt_KeyOnInvocation                
   ,PreRestructureAssetClassAlt_Key                
   ,PreRestructureNPA_Date                
   ,ProvPerOnRestrucure                
   ,RestructureTypeAlt_Key                
   ,COVID_OTR_CatgAlt_Key                
   ,RestructureDt                
   ,SP_ExpiryDate                
   ,RestructurePOS                
   ,DPD_AsOnRestructure                
   ,RestructureFailureDate                
   --,DPD_30_90_Breach_Date                
   ,ZeroDPD_Date                
   ,SP_ExpiryExtendedDate                
   ,Res_POS_to_CurrentPOS_Per                
   ,CurrentDPD                
   ,TotalDPD                
   ,VDPD                
   ,AddlProvPer                
   ,ProvReleasePer                
   ,UpgradeDate                
   ,SurvPeriodEndDate                
   ,PreDegProvPer                
   ,NonFinDPD                
   ,InitialAssetClassAlt_Key                
   ,FinalAssetClassAlt_Key                
   ,RestructureProvision                
   ,SecuredProvision                
   ,UnSecuredProvision                
   ,FlgDeg                
   ,FlgUpg                
   ,DegDate                
   ,RestructureStage                
   ,EffectiveFromTimeKey                
   ,EffectiveToTimeKey                
 )                
SELECT                 
   AccountEntityId                
   ,AssetClassAlt_KeyOnInvocation                
   ,PreRestructureAssetClassAlt_Key                
   ,PreRestructureNPA_Date                
   ,ProvPerOnRestrucure                
   ,RestructureTypeAlt_Key               
   ,COVID_OTR_CatgAlt_Key                
   ,RestructureDt                
   ,DATEADD(YY,1,(CASE WHEN ISNULL(PrincRepayStartDate,'1900-01-01')>=ISNULL(InttRepayStartDate,'1900-01-01')                 
         THEN PrincRepayStartDate ELSE InttRepayStartDate END)                
        ) SP_ExpiryDate                
   ,RestructurePOS                
   ,DPD_AsOnRestructure                
   ,NULL RestructureFailureDate                
   --,DPD_30_90_Breach_Date                
   ,ZeroDPD_Date                
   ,NULL SP_ExpiryExtendedDate                
   ,0 Res_POS_to_CurrentPOS_Per                
   ,0 CurrentDPD                
   ,0 TotalDPD                
   ,0 VDPD                
   ,0 AddlProvPer                
   ,0 ProvReleasePer                
   ,UpgradeDate                
   ,SurvPeriodEndDate                
   ,PreDegProvPer                
   ,0 NonFinDPD                
   ,1 InitialAssetClassAlt_Key                
   ,1 FinalAssetClassAlt_Key                
   ,0 RestructureProvision                
   ,0 SecuredProvision                
   ,0 UnSecuredProvision                
   ,'N' FlgDeg                
   ,'N' FlgUpg                
   ,NULL DegDate                
   ,RestructureStage                
   ,@Timekey EffectiveFromTimeKey                
   ,@Timekey EffectiveToTimeKey                
 FROM AdvAcRestructureDetail                 
 WHERE EffectiveFromTimeKey<=@TimeKey and EffectiveToTimeKey>=@Timekey                
                 
----------------Update Total OS, Total POS,CrntQtrAssetClass----------------                
                
--Select *                 
Update A SET                 
   A.CurrentPOS=b.PrincOutStd                
  ,A.CurrentTOS=Balance                
  ,A.FinalAssetClassAlt_Key=b.FinalAssetClassAlt_Key                
  ,A.InitialAssetClassAlt_Key=B.InitialAssetClassAlt_Key                
  --,A.Res_POS_to_CurrentPOS_Per=CASE WHEN ISNULL(RestructurePOS,0)<= ISNULL(B.PrincOutStd,0.00)  THEN 0                
  -- ELSE  CAST( (CAST((cast((ISNULL(a.RestructurePOS,0.00)-ISNULL(B.PrincOutStd,0.00)) as decimal(22,2)) /ISNULL(A.RestructurePOS,1)) AS DECIMAL(20,2)))*100 AS DECIMAL(5,2))                
  --  END                
  ,A.AppliedNormalProvPer=CASE WHEN B.FinalAssetClassAlt_Key =1 THEN SP.ProvisionSecured                
            ELSE B.FinalProvisionPer END                
  ,A.FinalNpaDt=b.FinalNpaDt                
  --,A.UpgradeDate=b.UpgDate                
  ,A.SurvPeriodEndDate=case when A.UpgradeDate is not null then DATEADD(yy,1,A.UpgradeDate) else null end                
  ,CurrentDPD=B.DPD_Max                
  ,a.SP_ExpiryDate =case when A.SP_ExpiryDate is null then dateadd(yy,1,a.RestructureDt) else a.SP_ExpiryDate end                
 FROM [PRO].[AdvAcRestructureCal] A                
                
  INNER JOIN PRO.ACCOUNTCAL B ON A.AccountEntityId=B.AccountEntityId                
  LEFT JOIN DimProvision_SegStd SP                
   ON SP.EffectiveFromTimeKey<=@TimeKey AND SP.EffectiveFromTimeKey>=@TimeKey                
   AND SP.ProvisionAlt_Key=B.ProvisionAlt_Key                
  LEFT JOIN DimProvision_Seg NP                
   ON NP.EffectiveFromTimeKey<=@TimeKey AND NP.EffectiveFromTimeKey>=@TimeKey                
   AND NP.ProvisionAlt_Key=B.ProvisionAlt_Key                
                   
 WHERE A.EffectiveFromTimeKey<=@TimeKey And A.EffectiveToTimeKey>=@TimeKey                
                
 --------For Additional POS Update                
 --Update A Set A.AdditionalPOS=isnuLL(B.PrincipalBalance,0)-isnull(A.CurrentPOS,0)                
 --FROM [PRO].[AdvAcRestructureCal] A                
 --INNER JOIN AUSFB_TEMPDB.dbo.TempAdVAcBalanceDetail B ON A.AccountEntityId=B.AccountEntityId                
 -- AND B.EffectiveFromTimeKey<=@TIMEKEY And B.EffectiveToTimeKey>=@TIMEKEY                
 -- Inner Join SecuritizedFinalACDetail C ON C.AccountID=B.RefSystemAcId                
 -- AND C.EffectiveFromTimeKey<=@TIMEKEY And C.EffectiveToTimeKey>=@TIMEKEY                
                  
  ---------------------------------------                
  --UPDATE A SET A.Res_POS_to_CurrentPOS_Per=CASE WHEN ISNULL(RestructurePOS,0)<= (ISNULL(a.CurrentPOS,0.00)+ISnull(A.AdditionalPOS,0))  THEN 0              
  -- ELSE  CAST( (CAST((cast((ISNULL(a.RestructurePOS,0.00)-(ISNULL(a.CurrentPOS,0.00)+ISnull(A.AdditionalPOS,0))) as decimal(22,2)) /ISNULL(A.RestructurePOS,1)) AS DECIMAL(20,2)))*100 AS DECIMAL(5,2))              
  --  END              
              
  --FROM [PRO].[AdvAcRestructureCal] A              
       /* aMar  - chaNGe oN 11032022 foR calcuLatE Res_POS_to_CurrentPOS_Per iN 2 DeCimal */        
 --UPDATE A SET A.Res_POS_to_CurrentPOS_Per=            
 --  case WHEN (ISNULL(RestructurePOS,0))>0         
 --   THEN        
 --    CASE WHEN ((ISNULL(RestructurePOS,0)-(ISNULL(A.CurrentPos,0.00)+ISnull(A.AdditionalPOS,0)))*100)/(ISNULL(RestructurePOS,0))>100        
 --       OR ((ISNULL(RestructurePOS,0)-(ISNULL(A.CurrentPos,0.00)+ISnull(A.AdditionalPOS,0)))*100)/(ISNULL(RestructurePOS,0))<0        
 --     THEN 0        
 --    ELSE CAST(ROUND(((ISNULL(RestructurePOS,0)-(ISNULL(A.CurrentPos,0.00)+ISnull(A.AdditionalPOS,0)))*100)/(ISNULL(RestructurePOS,0)),2) AS DECIMAL(5,2))        
 --   END        
 --  ELSE 0 END        
 -- FROM [PRO].[AdvAcRestructureCal] A                 
                 
 update A                
   set SP_ExpiryExtendedDate =dateadd(yy,1,ZeroDPD_Date)                
 FROM [PRO].[AdvAcRestructureCal] A                
 where ZeroDPD_Date is NOT NULL                
                 
 UPDATE a                
  set Res_POS_to_CurrentPOS_Per   = CASE WHEN ISNULL(Res_POS_to_CurrentPOS_Per,0)<0 THEN 0 ELSE Res_POS_to_CurrentPOS_Per END                
  FROM [PRO].[AdvAcRestructureCal] A                
                
                
/* END OF RESTRUCTURE WORK*/                
                
                
/* START OF PUI WORK*/                
                
--TRUNCATE TABLE PRO.PUI_CAL                
                
--INSERT INTO  PRO.PUI_CAL                
--  (CustomerEntityID                
--  ,AccountEntityId                
--  ,ProjectCategoryAlt_Key                
--  ,ProjectSubCategoryAlt_key                
--  ,DelayReasonChangeinOwnership                
--  ,ProjectAuthorityAlt_key                
--  ,OriginalDCCO                
--  ,OriginalProjectCost                
--  ,OriginalDebt                
--  ,Debt_EquityRatio                
--  ,ChangeinProjectScope                
--  ,FreshOriginalDCCO                
--  ,RevisedDCCO                
--  ,CourtCaseArbitration                
--  ,CIOReferenceDate                
--  ,CIODCCO                
--  ,TakeOutFinance                
--  ,AssetClassSellerBookAlt_key                
--  ,NPADateSellerBook                
--  ,Restructuring                
--  ,InitialExtension                
--  ,BeyonControlofPromoters                
--  ,DelayReasonOther                
--  ,FLG_UPG                
--  ,FLG_DEG                
--  ,DEFAULT_REASON                
--  ,ProjCategory                
--  ,NPA_DATE                
--  ,PUI_ProvPer                
--  ,RestructureDate                
--  ,ActualDCCO                
--  ,ActualDCCO_Date         
--  ,UpgradeDate                
--  ,FinalAssetClassAlt_Key                
--  ,DPD_Max                
--  ,EffectiveFromTimeKey                
--  ,EffectiveToTimeKey                
--  )                
                  
--SELECT   A.CustomerEntityID,B.AccountEntityId,B.ProjectCategoryAlt_Key,B.ProjectSubCategoryAlt_key,c.ChangeinOwnerShip                
--  ,B.ProjectAuthorityAlt_key,B.OriginalDCCO,B.OriginalProjectCost,B.OriginalDebt,B.Debt_EquityRatio                
--  ,C.ChangeinProjectScope,C.FreshOriginalDCCO,C.RevisedDCCO,C.CourtCaseArbitration,C.CIOReferenceDate,C.CIODCCO                
--  --,C.CostOverRun,C.RevisedProjectCost,C.RevisedDebt,C.RevisedDebt_EquityRatio,C.AuthorisationStatus                
--  ,C.TakeOutFinance,C.AssetClassSellerBookAlt_key,C.NPADateSellerBook,C.Restructuring                
--  --,((C.RevisedProjectCost-B.OriginalProjectCost)*100)/B.OriginalProjectCost OverRunPer                 
--  ,InitialExtension                
--  ,BeyonControlofPromoters                
--  ---,'Y' ChangeInManagement                
--  ,DelayReasonOther                
--  ,'N' FLG_UPG                
--  ,'N' FLG_DEG                
--  ,CAST('' AS varchar(50)) DEFAULT_REASON                
--  ,d.ProjectCategoryDescription ProjCategory                
--  ,CAST(NULL AS DATE) NPA_DATE                 
--  ,0.00 AS PUI_ProvPer                
--  ,cast(null as date) RestructureDate                
--  ,ActualDCCO_Achieved ActualDCCO                
--  ,ActualDCCO_Date                
--  ,cast(null as date) UpgradeDate                
--  ,A.FinalAssetClassAlt_Key                
--  ,A.DPD_Max                
--  ,@TimeKey EffectiveFromTimeKey                
--  ,@TimeKey EffectiveToTimeKey                
                
--FROM PRO.ACCOUNTCAL A                
-- INNER JOIN [dbo].[AdvAcPUIDetailMain] B                
--  ON A.AccountEntityID=B.AccountEntityId                
--  and (b.EffectiveFromTimeKey<=@TimeKey and b.EffectiveToTimeKey>=@TimeKey)                 
-- INNER JOIN [dbo].[AdvAcPUIDetailSub] c                
--  ON A.AccountEntityID=c.AccountEntityID                
--  and (c.EffectiveFromTimeKey<=@TimeKey and c.EffectiveToTimeKey>=@TimeKey)                 
-- --INNER JOIN DimParameter d                
-- --  ON ParameterAlt_Key=b.ProjectCategoryAlt_Key                
-- --  and (d.EffectiveFromTimeKey<=@TimeKey and d.EffectiveToTimeKey>=@TimeKey)                 
-- --  AND DimParameterName = 'ProjectCategory'                
-- INNER JOIN ProjectCategory d                
--   ON d.ProjectCategoryAltKey=b.ProjectCategoryAlt_Key                
--   and (d.EffectiveFromTimeKey<=@TimeKey and d.EffectiveToTimeKey>=@TimeKey)                 
--   --AND DimParameterName = 'ProjectCategory'                
  
  
DECLARE @PUI_Hist_TimeKey INT   
Select @PUI_Hist_TimeKey=MAX(EffectiveFromTimeKey ) FROM PRO.PUI_CAL_hist WHERE EffectiveFromTimeKey <=@TIMEKEY  
   
UPDATE A   
 SET A.RestructureDate=B.RestructureDate, A.Restructuring=B.Restructuring  
FROM PRO.PUI_CAL A  
 INNER JOIN PRO.PUI_CAL_hist B ON A.AccountEntityId=B.AccountEntityId  
 AND B.EffectiveToTimeKey=@PUI_Hist_TimeKey  
  
                
                
/* END OF PUI WORK*/                
                
                
                
UPDATE PRO.ACLRUNNINGPROCESSSTATUS                 
  SET COMPLETED='Y',ERRORDATE=NULL,ERRORDESCRIPTION=NULL,COUNT=ISNULL(COUNT,0)+1                
  WHERE RUNNINGPROCESSNAME='InsertDataforAssetClassficationAUSFB'                
                
                  
 --------------Added for DashBoard 04-03-2021                
 Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'                
                
END TRY                
BEGIN  CATCH                
                
  UPDATE PRO.ACLRUNNINGPROCESSSTATUS                 
  SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1                
  WHERE RUNNINGPROCESSNAME='InsertDataforAssetClassficationAUSFB'                
                
END CATCH                
END                
                
GO
