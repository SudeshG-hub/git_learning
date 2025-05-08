SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
CREATED BY   :-Baijayanti
CREATED DATE :-16/08/2022
REPORT NAME  :-Restructured Report
*/


CREATE PROCEDURE [dbo].[Rpt-047_17-10-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26479


SELECT 
 ACH.UCIF_ID                                                     AS CIF
,CCH.CustomerName                                                AS CustomerName
,CustomerAcID                                                    AS AccountID
,''                                                              AS Industry
,''                                                              AS [Restructured - Y/N]
,ISNULL(CurrentLimit,0)                                          AS [SANCTION_LIMIT_LCY]
,ISNULL(Balance,0)                                               AS [Total Outstandings in LCY]
,AssetClassName                                                  AS [Pre-restructuring Asset Class]
,CONVERT(VARCHAR(20),Restructure_NPA_Dt,103)                     AS [NPA Date]
,''                                                              AS [Asset Class]
,''                                                              AS [Review Period Start Date]
,''                                                              AS [Review Period End Date]
,''                                                              AS [Number of Days of Review Period in Excess of 30 Days]
,ISNULL(RestructureAmt,0)                                        AS [Amount restructured]
,''                                                              AS [Resolution Plan Implementation Date]
,''                                                              AS [Number of Days Exceeding Stipulated Implementation Date]
,''                                                              AS [Additional Provision Held (due to delay in implementation) - date and amount]
,''                                                              AS [Additional Provision Held (due to failed restructuring) - date and amount]
,''                                                              AS [External Rating of Restructured Debt]
,''                                                              AS [Date Twelve]
,CONVERT(VARCHAR(20),POS_10PerPaidDate,103)                      AS [Satisfactory Performance Status]
,''                                                              AS [Upgrade Eligibility]


FROM AdvAcRestructureDetail ACRD
INNER JOIN Pro.AccountCal_Hist  ACH          ON  ACH.CustomerACID=ACRD.RefSystemAcId
                                                 AND  ACH.EffectiveFromTimeKey<=@TimeKey AND ACH.EffectiveToTimeKey>=@TimeKey

INNER JOIN Pro.CustomerCal_Hist  CCH          ON  CCH.RefCustomerID=ACH.RefCustomerID
                                                 AND  CCH.EffectiveFromTimeKey<=@TimeKey AND CCH.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAssetClass DAC                  ON DAC.AssetClassAlt_Key=ACRD.PreRestructureAssetClassAlt_Key
                                                AND  DAC.EffectiveFromTimeKey<=@TimeKey AND DAC.EffectiveToTimeKey>=@TimeKey

WHERE  ACRD.EffectiveFromTimeKey<=@TimeKey AND ACRD.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
