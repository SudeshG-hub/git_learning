SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROC [dbo].[Rpt-025A_17-02-2023]
	@TimeKey  INT,
	@SelectReport AS INT
	AS 


--DECLARE  @TimeKey AS INT=26479,
--         @SelectReport AS INT=2

-------------------------------------------------------------
DECLARE @DATE AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)
------------------------------------------------------------
 IF(OBJECT_ID('TEMPDB..#InvestmentDerivative_Account')IS NOT NULL)
     DROP TABLE #InvestmentDerivative_Account


SELECT * INTO #InvestmentDerivative_Account FROM(
SELECT
DISTINCT
IID.UcifId                                                                 AS UCIC_ID,
IID.IssuerName                                                             AS IssuerName,
IBD.InvID                                                                  AS 'InvestmentID/Derv No.',												                       
ISNULL(IFD.BookValue,0)                                                    AS BookValue,
FD.RFA_DateReportingByBank                                                 AS FraudDate,
IFD.MOC_Date,
IFD.FlgMoc,
IFD.MOC_Reason
FROM dbo.InvestmentBasicDetail IBD
INNER JOIN DBO.InvestmentFinancialdetail     IFD			ON  IFD.InvEntityId=IBD.InvEntityId 
															    AND IFD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IFD.EffectiveToTimeKey>=@TimeKey
																AND IBD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IBD.EffectiveToTimeKey>=@TimeKey
																
INNER JOIN DBO.InvestmentIssuerDetail   IID				    ON  IID.IssuerEntityId=IBD.IssuerEntityId 
															    AND IID.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IID.EffectiveToTimeKey>=@TimeKey

LEFT JOIN	 Fraud_Details		FD							ON  IID.IssuerID=FD.RefCustomerID  
															    AND FD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND FD.EffectiveToTimeKey>=@TimeKey

UNION ALL

SELECT
DISTINCT
UCIC_ID,
CustomerName                                                             AS IssuerName,
DerivativeRefNo                                                          AS 'InvestmentID/Derv No.'	,												                       
ISNULL(MTMIncomeAmt,0)                                                   AS BookValue,
FD.RFA_DateReportingByBank                                               AS FraudDate,
MOC_Date,
FlgMoc,
MOC_Reason
FROM CURDAT.DerivativeDetail Derivative
LEFT JOIN Fraud_Details		FD					  ON  Derivative.CustomerID=FD.RefCustomerID 
													  AND FD.EffectiveFromTimeKey<=@TimeKey 
                                                      AND FD.EffectiveToTimeKey>=@TimeKey

WHERE Derivative.EffectiveFromTimeKey<=@TimeKey AND Derivative.EffectiveToTimeKey>=@TimeKey

)DATA

OPTION(RECOMPILE)

--------------------------------------
 IF(OBJECT_ID('TEMPDB..#InvestmentDerivative_Cust')IS NOT NULL)
     DROP TABLE #InvestmentDerivative_Cust


SELECT * INTO #InvestmentDerivative_Cust FROM(
SELECT
DISTINCT
IID.UcifId                                                                 AS UCIC_ID,
IID.IssuerID                                                               AS IssuerID,
IID.IssuerName                                                             AS IssuerName,													                       
CONVERT(VARCHAR(15),IFD.NPIDt,103)                                         AS NPIDt,
IFD.MOC_Date,
IFD.FlgMoc,
IFD.MOC_Reason,
DA.AssetClassName                                                          AS NPIAssetClass,
IFD.AddlProvisionPer
FROM dbo.InvestmentBasicDetail IBD
INNER JOIN DBO.InvestmentFinancialdetail     IFD			ON  IFD.InvEntityId=IBD.InvEntityId 
															    AND IFD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IFD.EffectiveToTimeKey>=@TimeKey
																AND IBD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IBD.EffectiveToTimeKey>=@TimeKey
																
INNER JOIN DBO.InvestmentIssuerDetail   IID				    ON  IID.IssuerEntityId=IBD.IssuerEntityId 
															    AND IID.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IID.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DA                                 ON DA.AssetClassAlt_Key=IFD.FinalAssetClassAlt_Key
                                                                AND DA.EffectiveFromTimeKey<=@TimeKey 
                                                                AND DA.EffectiveToTimeKey>=@TimeKey
UNION ALL

SELECT
DISTINCT
UCIC_ID,
CustomerID                                                               AS IssuerID,
CustomerName                                                             AS IssuerName,													                       
CONVERT(VARCHAR(15),NPIDt,103)                                           AS NPIDt,
MOC_Date,
FlgMoc,
MOC_Reason,
DA.AssetClassName                                                        AS NPIAssetClass,
AddlProvisionPer
FROM CURDAT.DerivativeDetail Derivative

INNER JOIN DimAssetClass DA                        ON DA.AssetClassAlt_Key=Derivative.FinalAssetClassAlt_Key
                                                      AND DA.EffectiveFromTimeKey<=@TimeKey 
                                                      AND DA.EffectiveToTimeKey>=@TimeKey

WHERE Derivative.EffectiveFromTimeKey<=@TimeKey AND Derivative.EffectiveToTimeKey>=@TimeKey

)DATA

OPTION(RECOMPILE)
------------------------------------------------
IF(OBJECT_ID('TEMPDB..#CalypsoAccountLevelMOC')IS NOT NULL)
   DROP TABLE #CalypsoAccountLevelMOC

SELECT *
INTO #CalypsoAccountLevelMOC
FROM CalypsoAccountLevelMOC_Mod
WHERE EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey
	  AND ChangeField IS NOT NULL AND AuthorisationStatus='A'

OPTION(RECOMPILE)

---------------------------------------------------
IF(OBJECT_ID('TEMPDB..#CalypsoCustomerlevelMOC')IS NOT NULL)
   DROP TABLE #CalypsoCustomerlevelMOC

SELECT *
INTO #CalypsoCustomerlevelMOC
FROM CalypsoCustomerlevelMOC_Mod
WHERE EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey
	  AND ChangeField IS NOT NULL AND  AuthorisationStatus='A'

OPTION(RECOMPILE)

---------------------------------------------------------------------------

SELECT 

DISTINCT 

	'Post Moc' Moc_Status 
	,CONVERT(VARCHAR(20),@DATE,103)                                  AS CurrentProcessingDate
	---------RefColumns---------
    ,InvA.UCIC_ID                                                                  
    ,InvC.IssuerID
    ,InvA.IssuerName                                                              
    ,InvA.[InvestmentID/Derv No.]                                                        	
    ,CONVERT(VARCHAR(20),CCLM.NPADate,103)                               AS FinalNpaDt	
	,E.AssetClassName                                                 AS FinalAssetClassName
	,ISNULL(CCLM.AdditionalProvision,0)                                  AS AddlProvision	 
	----Edit--------
	,ISNULL(CALM.BookValue,0)                                            AS BookValue										      
    ,ISNULL(CALM.InterestReceivable,0)                                   AS UnserviedInt
	,ISNULL(CALM.AdditionalProvisionAbsolute,0)                          AS AdditionalProvisionAbsolute	
	,CONVERT(VARCHAR(20),CALM.FraudDate,103)                             AS FraudDate												      
	,CONVERT(VARCHAR(20),CALM.TwoDate,103)                               AS TwoDate	

	,CASE WHEN InvA.FlgMoc='Y' OR InvC.FlgMoc='Y'
	      THEN CONVERT(VARCHAR(20),ISNULL(InvA.MOC_Date,InvC.MOC_Date),103)
		  ELSE CONVERT(VARCHAR(20),ISNULL(CALM.MOCDate,CCLM.MOCDate),103)
		  END                                                           AS MOC_Dt
	,ISNULL(CALM.CreatedBy,CCLM.CreatedBy)                              AS MakerID
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateCreated,CCLM.DateCreated),103)                          AS MakerDate
	,ISNULL(CALM.ApprovedByFirstLevel,CCLM.ApprovedByFirstLevel)        AS CheckerID
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateApprovedFirstLevel,CCLM.DateApprovedFirstLevel),103)    AS CheckerDate
	,ISNULL(CALM.ApprovedBy,CCLM.ApprovedBy)                            AS ReviewerID 
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateApproved,CCLM.DateApproved),103)                        AS ReviewerDate
	,CASE WHEN InvA.FlgMoc='Y' OR InvC.FlgMoc='Y'
	      THEN ISNULL(InvA.MOC_Reason,InvC.MOC_Reason)
		  ELSE ISNULL(CALM.MOCReason,CCLM.MOCReason)
		  END                                                           AS MOCReason

FROM  #InvestmentDerivative_Account InvA
LEFT JOIN #CalypsoAccountLevelMOC CALM            ON InvA.[InvestmentID/Derv No.]=CALM.AccountID
											      
LEFT JOIN #InvestmentDerivative_Cust  InvC        ON InvA.UCIC_ID=InvC.UCIC_ID
											      
LEFT JOIN #CalypsoCustomerlevelMOC CCLM           ON CCLM.UcifID=InvC.UCIC_ID
											      
											      
LEFT JOIN DimAssetClass E                        ON E.AssetClassAlt_Key=CCLM.AssetClassAlt_Key 
                                                     AND E.EffectiveFromTimeKey<=@TimeKey
											         AND E.EffectiveToTimeKey>=@TimeKey
											      

WHERE (InvA.FlgMoc='Y'  OR InvC.FlgMoc='Y' OR CALM.MOCDate IS NOT NULL  OR CCLM.MOCDate IS NOT NULL) AND @SelectReport=2

UNION ALL

SELECT 

DISTINCT

    'Pre Moc' Moc_Status 
	,CONVERT(VARCHAR(20),@DATE,103)                                  AS CurrentProcessingDate
	---------RefColumns---------
    ,InvA.UCIC_ID                                                                  
    ,InvC.IssuerID
    ,InvA.IssuerName                                                              
    ,InvA.[InvestmentID/Derv No.]                                                        	
    ,CONVERT(VARCHAR(20),InvC.NPIDt,103)                                 AS FinalNpaDt	
	,InvC.NPIAssetClass                                                  AS FinalAssetClassName
	,ISNULL(InvC.AddlProvisionPer,0)                                     AS AddlProvision	 
	----Edit--------
	,ISNULL(InvA.BookValue,0)                                            AS BookValue										      
    ,0                                                                   AS UnserviedInt
	,0                                                                   AS AdditionalProvisionAbsolute	
	,CONVERT(VARCHAR(20),InvA.FraudDate,103)                             AS FraudDate												      
	,CONVERT(VARCHAR(20),TWO.StatusDate,103)                             AS TwoDate	

	,CASE WHEN InvA.FlgMoc='Y' OR InvC.FlgMoc='Y'
	      THEN CONVERT(VARCHAR(20),ISNULL(InvA.MOC_Date,InvC.MOC_Date),103)
		  END                                                           AS MOC_Dt
	,ISNULL(CALM.CreatedBy,CCLM.CreatedBy)                              AS MakerID
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateCreated,CCLM.DateCreated),103)                          AS MakerDate
	,ISNULL(CALM.ApprovedByFirstLevel,CCLM.ApprovedByFirstLevel)        AS CheckerID
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateApprovedFirstLevel,CCLM.DateApprovedFirstLevel),103)    AS CheckerDate
	,ISNULL(CALM.ApprovedBy,CCLM.ApprovedBy)                            AS ReviewerID 
	,CONVERT(VARCHAR(20),ISNULL(CALM.DateApproved,CCLM.DateApproved),103)                        AS ReviewerDate
	,CASE WHEN InvA.FlgMoc='Y' OR InvC.FlgMoc='Y'
	      THEN ISNULL(InvA.MOC_Reason,InvC.MOC_Reason)
		  END                                                           AS MOCReason

FROM  #InvestmentDerivative_Account InvA
LEFT JOIN #CalypsoAccountLevelMOC CALM            ON InvA.[InvestmentID/Derv No.]=CALM.AccountID
											      
LEFT JOIN #InvestmentDerivative_Cust  InvC        ON InvA.UCIC_ID=InvC.UCIC_ID
											      
LEFT JOIN #CalypsoCustomerlevelMOC CCLM           ON CCLM.UcifID=InvC.UCIC_ID

LEFT JOIN (SELECT  DISTINCT ACID,StatusDate,ISNULL(Amount,0) Amount FROM  ExceptionFinalStatusType
                             WHERE StatusType='TWO'
                         AND EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey) TWO
                               ON   InvA.[InvestmentID/Derv No.]=TWO.ACID 
											      											      

WHERE (InvA.FlgMoc='Y'  OR InvC.FlgMoc='Y' OR CALM.MOCDate IS NOT NULL  OR CCLM.MOCDate IS NOT NULL) AND @SelectReport=2

ORDER BY UCIC_ID,IssuerID,[InvestmentID/Derv No.],Moc_Status DESC


OPTION(RECOMPILE)

DROP TABLE #CalypsoAccountLevelMOC,#CalypsoCustomerlevelMOC,#InvestmentDerivative_Account,#InvestmentDerivative_Cust


 

GO
