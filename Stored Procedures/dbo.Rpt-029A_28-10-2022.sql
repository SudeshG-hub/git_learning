SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
 CREATE BY   :- Baijayanti
 CREATE DATE :- 09/08/2022
 DESCRIPTION :- Calypso For Provision Report

 */ 

 
CREATE PROCEDURE [dbo].[Rpt-029A_28-10-2022]	
    @TimeKey AS INT,
	@Cost AS FLOAT,
	@SelectReport AS INT
	
AS

--DECLARE
--    @Timekey AS INT=26372,
--	@SelectReport AS INT=2,
--	@Cost AS FLOAT=1
	


SELECT
DISTINCT
'Calypso'                                                                  AS SourceSystem,
DB.BranchName,
IID.UcifId                                                                 AS UCIC_ID,
IID.IssuerID                                                               AS IssuerID,
IID.IssuerName                                                             AS IssuerName,
IBD.InvID                                                                  AS 'InvestmentID/Derv No.',
IBD.InvestmentNature                                                       AS InvestmentNature,
CONVERT(VARCHAR(15),IBD.MaturityDt,103)                                    AS MaturityDt,
CASE WHEN IBD.ReStructureDate IS NOT NULL 
     THEN 'Y'
     ELSE 'N'
	 END                                                                   AS Restructured_Y_N,
CONVERT(VARCHAR(15),IBD.ReStructureDate,103)                               AS ReStructureDate,
IFD.HoldingNature                                                          AS HoldingNature,	
--------CHANGED ON 18-04-2022--------------												                       
ISNULL(IFD.BookValueINR,0)/@Cost                                           AS BookValue,
ISNULL(IFD.MTMValueINR,0)/@Cost                                            AS MTMValue,														                       
ISNULL(IFD.TotalProvison,0)/@Cost                                          AS TotalProvison,
IFD.DPD                                                                    AS DPD,
ISNULL(IFD.Interest_DividendDueAmount,0)/@Cost                             AS OVERDUE_AMOUNT,
0                                                                          AS PartialRedumptionDueAmount,
CONVERT(VARCHAR(15),IFD.PartialRedumptionDueDate,103)                      AS PartialRedumptionDueDate,

DA.AssetClassName                                                          AS NPIAssetClass,
''                                                AS CouponOverDueSinceDt,
'Investment'                                      AS Flag,
InstrName                                         AS InstrumentName,
''                                                AS OverDueSinceDt,
ISNULL(OVERDUE_AMOUNT,0)/@Cost                    AS DueAmtReceivable,

CONVERT(VARCHAR(20),IFD.NPIDt,103)                AS NPADate,
CASE WHEN DA.AssetClassAlt_Key=1 
     THEN ISNULL(DPSTD.ProvisionSecured,0)  
	 ELSE ISNULL(DPS.ProvisionSecured,0) 
	 END                                          AS ProvisionPerSecured,
CASE WHEN DA.AssetClassAlt_Key=1 
     THEN ISNULL(DPSTD.ProvisionUnSecured,0) 
	 ELSE ISNULL(DPS.ProvisionUnSecured,0)  
	 END                                          AS ProvisionPerUnSecured,
0                                                 AS BalanceOutstanding,
0                                                 AS PrincipalOutstanding,
0                                                 AS NetBalance,
0                                                 AS SecurityValue,
0                                                 AS SecurityValueappropriated,
''                                                AS SecurityType,
''                                                AS ValuationDate,
0                                                 AS SecuredOutstanding,
0                                                 AS UnsecuredOutstanding,
0                                                 AS SecurityUsedRV,
0                                                 AS InterestInSuspenseAmount,
0                                                 AS Totalincomesuspended,
0                                                 AS NetNPA,
0                                                 AS PrevQtrBalanceOutstanding,
0                                                 AS PrevQtrSecuredOutstanding,
0                                                 AS PrevQtrUnsecuredOutstanding,
0                                                 AS PrevQtrTotalProvision,
0                                                 AS PrevQtrProvisionSecured,
0                                                 AS PrevQtrProvisionUnsecured,
0                                                 AS PrevQtrNetNPA,
0                                                 AS NPAIncrease,
0                                                 AS NPADecrease,
0                                                 AS STDProvisionIncrease,
0                                                 AS STDProvisionDecrease,
0                                                 AS NPAProvisionIncrease,
0                                                 AS NPAProvisionDecrease,
0                                                 AS NetNPAIncrease,
0                                                 AS NetNPADecrease,
0                                                 AS ActualProvision,
0                                                 AS ShortfallinProvisionHeld ,
0                                                 AS ProvisionSecured,
0                                                 AS ProvisionUnsecured,
0                                                 AS [Total Provision %]

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

LEFT JOIN DimBranch DB                                       ON DB.BranchCode=IBD.BranchCode
                                                                AND DB.EffectiveFromTimeKey<=@TimeKey 
                                                                AND DB.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimProvision_Seg DPS                               ON DPS.ProvisionAlt_Key=IFD.ProvisionAlt_Key
                                                                AND DPS.EffectiveFromTimeKey<=@TimeKey 
                                                                AND DPS.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimProvision_SegStd DPSTD                          ON DPSTD.ProvisionAlt_Key=IFD.ProvisionAlt_Key
                                                                AND DPSTD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND DPSTD.EffectiveToTimeKey>=@TimeKey

WHERE  @SelectReport=2 


UNION ALL

SELECT
DISTINCT
SourceSystem                                                             AS SourceSystem,
DB.BranchName,
UCIC_ID,
CustomerID                                                               AS IssuerID,
CustomerName                                                             AS IssuerName,
DerivativeRefNo                                                          AS 'InvestmentID/Derv No.',
''                                                                       AS InvestmentNature,
CONVERT(VARCHAR(15),Duedate,103)                                         AS MaturityDt,
''                                                                       AS Restructured_Y_N,
''                                                                       AS ReStructureDate,
''                                                                       AS HoldingNature,													                       
(CASE WHEN ISNULL(OsAmt,0)<0
      THEN ISNULL(OsAmt,0)*-1
      ELSE ISNULL(OsAmt,0)
	  END)/@Cost                                                         AS BookValue,
ISNULL(MTMIncomeAmt,0)/@Cost                                             AS MTMValue,													                       
ISNULL(TotalProvison,0)/@Cost                                            AS TotalProvison,
DPD                                                                      AS DPD,
ISNULL(OverdueCouponAmt,0)/@Cost                                         AS OVERDUE_AMOUNT,
0                                                                        AS PartialRedumptionDueAmount,
''                                                                       AS PartialRedumptionDueDate,
DA.AssetClassName                                                        AS NPIAssetClass,
CONVERT(VARCHAR(15),CouponOverDueSinceDt,103)                            AS CouponOverDueSinceDt,
'Derivative'                                                             AS Flag,
Derivative.InstrumentName                                                AS InstrumentName,
CONVERT(VARCHAR(20),Derivative.OverDueSinceDt,103)                       AS OverDueSinceDt,
ISNULL(Derivative.DueAmtReceivable,0)/@Cost                              AS DueAmtReceivable,
CONVERT(VARCHAR(20),Derivative.NPIDt,103)                                AS NPADate,
CASE WHEN DA.AssetClassAlt_Key=1 
     THEN ISNULL(DPSTD.ProvisionSecured,0)  
	 ELSE ISNULL(DPS.ProvisionSecured,0) 
	 END                                          AS ProvisionPerSecured,
CASE WHEN DA.AssetClassAlt_Key=1 
     THEN ISNULL(DPSTD.ProvisionUnSecured,0) 
	 ELSE ISNULL(DPS.ProvisionUnSecured,0)  
	 END                                          AS ProvisionPerUnSecured,
0                                                 AS BalanceOutstanding,
0                                                 AS PrincipalOutstanding,
0                                                 AS NetBalance,
0                                                 AS SecurityValue,
0                                                 AS SecurityValueappropriated,
''                                                AS SecurityType,
''                                                AS ValuationDate,
0                                                 AS SecuredOutstanding,
0                                                 AS UnsecuredOutstanding,
0                                                 AS SecurityUsedRV,
0                                                 AS InterestInSuspenseAmount,
0                                                 AS Totalincomesuspended,
0                                                 AS NetNPA,
0                                                 AS PrevQtrBalanceOutstanding,
0                                                 AS PrevQtrSecuredOutstanding,
0                                                 AS PrevQtrUnsecuredOutstanding,
0                                                 AS PrevQtrTotalProvision,
0                                                 AS PrevQtrProvisionSecured,
0                                                 AS PrevQtrProvisionUnsecured,
0                                                 AS PrevQtrNetNPA,
0                                                 AS NPAIncrease,
0                                                 AS NPADecrease,
0                                                 AS STDProvisionIncrease,
0                                                 AS STDProvisionDecrease,
0                                                 AS NPAProvisionIncrease,
0                                                 AS NPAProvisionDecrease,
0                                                 AS NetNPAIncrease,
0                                                 AS NetNPADecrease,
0                                                 AS ActualProvision,
0                                                 AS ShortfallinProvisionHeld ,
0                                                 AS ProvisionSecured,
0                                                 AS ProvisionUnsecured,
0                                                 AS [Total Provision %]

FROM CURDAT.DerivativeDetail Derivative

INNER JOIN DimAssetClass DA                        ON DA.AssetClassAlt_Key=Derivative.FinalAssetClassAlt_Key
                                                      AND DA.EffectiveFromTimeKey<=@TimeKey 
                                                      AND DA.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimBranch DB                              ON DB.BranchCode=Derivative.BranchCode
                                                       AND DB.EffectiveFromTimeKey<=@TimeKey 
                                                       AND DB.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimProvision_Seg DPS                      ON DPS.ProvisionAlt_Key=Derivative.ProvisionAlt_Key
                                                       AND DPS.EffectiveFromTimeKey<=@TimeKey 
                                                       AND DPS.EffectiveToTimeKey>=@TimeKey
												  
LEFT JOIN DimProvision_SegStd DPSTD                 ON DPSTD.ProvisionAlt_Key=Derivative.ProvisionAlt_Key
                                                       AND DPSTD.EffectiveFromTimeKey<=@TimeKey 
                                                       AND DPSTD.EffectiveToTimeKey>=@TimeKey

WHERE  @SelectReport=2 AND Derivative.EffectiveFromTimeKey<=@TimeKey AND Derivative.EffectiveToTimeKey>=@TimeKey
       
	
	
	
ORDER BY UCIC_ID															

OPTION(RECOMPILE)

																


   
GO
