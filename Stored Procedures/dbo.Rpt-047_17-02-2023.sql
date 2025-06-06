SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
CREATED BY   :-Baijayanti
CREATED DATE :-16/08/2022
REPORT NAME  :-Restructured Report
*/


CREATE PROCEDURE [dbo].[Rpt-047_17-02-2023]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26479

DECLARE @CurDate AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)


SELECT 
 ACH.UCIF_ID                                                     AS CIF
,CCH.CustomerName                                                AS CustomerName
,CustomerAcID                                                    AS AccountID
,''                                                              AS Industry
,CASE WHEN ISNULL(RestructureAmt,0)>0
      THEN 'Yes'
	  ELSE 'No'
	  END                                                        AS [Restructured - Y/N]
,ISNULL(CurrentLimit,0)                                          AS [SANCTION_LIMIT_LCY]
,ISNULL(Balance,0)                                               AS [Total Outstandings in LCY]
,DAC.AssetClassName                                              AS [Pre-restructuring Asset Class]
,CONVERT(VARCHAR(20),Restructure_NPA_Dt,103)                     AS [NPA Date]
,DAC1.AssetClassName                                             AS [Asset Class]
,CONVERT(VARCHAR(20),InDefaultDate,103)                          AS [Review Period Start Date]
,CONVERT(VARCHAR(20),DATEADD(DD,30,InDefaultDate),103)           AS [Review Period End Date]
,CASE WHEN DATEDIFF(DD,ReferenceDate,InDefaultDate)>=30
      THEN 0
	  ELSE DATEDIFF(DD,ReferenceDate,InDefaultDate)
	  END                                                        AS [Number of Days of Review Period in Excess of 30 Days]
,ISNULL(RestructureAmt,0)                                        AS [Amount restructured]
,CONVERT(VARCHAR(20),RP_ImplDate,103)                            AS [Resolution Plan Implementation Date]
,DATEDIFF(DD,RP_ImplDate,@CurDate)                               AS [Number of Days Exceeding Stipulated Implementation Date]
,''                                                              AS [Additional Provision Held (due to delay in implementation) - date and amount]
,''                                                              AS [Additional Provision Held (due to failed restructuring) - date and amount]
,''                                                              AS [External Rating of Restructured Debt]
,''                                                              AS [Date Twelve]
,CONVERT(VARCHAR(20),POS_10PerPaidDate,103)                      AS [Satisfactory Performance Status]
,CASE WHEN ACRD.UpgradeDate IS NOT NULL
      THEN 'Yes'
	  ELSE 'No'
	  END                                                        AS [Upgrade Eligibility]
,ISNULL(TotalProvision,0)                                        AS ProvisionAmount
,ISNULL(NetBalance,0)                                            AS NetBalanceProv
,ISNULL((ISNULL(TotalProvision,0)/NULLIF(NetBalance,0))*100,0)                                             AS ProvisionPer

FROM AdvAcRestructureDetail ACRD
INNER JOIN Pro.AccountCal_Hist  ACH          ON  ACH.CustomerACID=ACRD.RefSystemAcId
                                                 AND  ACH.EffectiveFromTimeKey<=@TimeKey AND ACH.EffectiveToTimeKey>=@TimeKey

LEFT JOIN RP_Portfolio_Details RPPD          ON RPPD.UCIC_ID=ACH.UCIF_ID
                                                AND ACH.RefCustomerID=RPPD.CustomerID
                                                AND RPPD.EffectiveFromTimeKey<=@TimeKey AND RPPD.EffectiveToTimeKey>=@TimeKey

LEFT JOIN RP_Lender_Details RPLD             ON RPPD.CustomerID=RPLD.CustomerID
                                                AND RPLD.EffectiveFromTimeKey<=@TimeKey AND RPLD.EffectiveToTimeKey>=@TimeKey

INNER JOIN Pro.CustomerCal_Hist  CCH         ON  CCH.RefCustomerID=ACH.RefCustomerID
                                                 AND  CCH.EffectiveFromTimeKey<=@TimeKey AND CCH.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAssetClass DAC                  ON DAC.AssetClassAlt_Key=ACRD.PreRestructureAssetClassAlt_Key
                                                AND  DAC.EffectiveFromTimeKey<=@TimeKey AND DAC.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DAC1                ON DAC1.AssetClassAlt_Key=ACH.FinalAssetClassAlt_Key
                                                AND  DAC1.EffectiveFromTimeKey<=@TimeKey AND DAC1.EffectiveToTimeKey>=@TimeKey

WHERE  ACRD.EffectiveFromTimeKey<=@TimeKey AND ACRD.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
