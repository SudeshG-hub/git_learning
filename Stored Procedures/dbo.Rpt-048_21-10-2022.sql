SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
CREATED BY   :-Baijayanti
CREATED DATE :-16/08/2022
REPORT NAME  :-PUI Report
*/


CREATE PROCEDURE [dbo].[Rpt-048_21-10-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26372


SELECT 

 UCIFID
,PUIM.CustomerName
,PUIM.AccountID
,''                                                           AS [Industry]	
,Restructuring                                                AS [Restructured - Y/N]	
,ISNULL(CurrentLimit,0)                                       AS [SANCTION_LIMIT_LCY]	
,ISNULL(Balance,0)                                            AS [Total Outstandings in LCY]
,DPC.ProjectCategoryDescription                               AS [Project -Infrastructure / Non-infrastructure (non-CRE)]
,CONVERT(VARCHAR(20),OriginalDCCO,103)                        AS OriginalDCCO
,CONVERT(VARCHAR(20),RevisedDCCO,103)                         AS [Revised DCCO]	
,''                                                           AS [Days Delayed]
,DPCD.ParameterName                                           AS [Delay Reason :Legal/Arbitration; Beyond Control]
,''                                                           AS [Permitted Delay Date]	
,''                                                           AS [Days in Excess of Permitted Delay Date]	
,AssetClassName                                               AS [Asset Class]	
,CONVERT(VARCHAR(20),FinalNpaDt,103)                          AS [NPA Date]
,ISNULL(TotalProvision,0)                                     AS ProvisionAmount
,ISNULL(NetBalance,0)                                         AS NetBalanceProv
,ISNULL((ISNULL(TotalProvision,0)/NULLIF(NetBalance,0))*100,0)                                             AS ProvisionPer
	
FROM AdvAcPUIDetailMain PUIM

INNER JOIN Pro.AccountCal_Hist ACH        ON ACH.CustomerAcID=PUIM.AccountID
										  AND  ACH.EffectiveFromTimeKey<=@TimeKey AND ACH.EffectiveToTimeKey>=@TimeKey

LEFT JOIN AdvAcPUIDetailSub PUIS          ON PUIM.AccountID=PUIS.AccountID
                                          AND PUIS.EffectiveFromTimeKey<=@TimeKey AND PUIS.EffectiveToTimeKey>=@TimeKey

LEFT JOIN AdvAcProjectDetail ACPD         ON PUIM.AccountID=ACPD.AccountID
                                          AND ACPD.EffectiveFromTimeKey<=@TimeKey AND ACPD.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DAC              ON ACH.FinalAssetClassAlt_Key=DAC.AssetClassAlt_Key
                                          AND DAC.EffectiveFromTimeKey<=@TimeKey AND DAC.EffectiveToTimeKey>=@TimeKey

LEFT JOIN ProjectCategory DPC             ON PUIM.ProjectCategoryAlt_Key=DPC.ProjectCategoryAltKey
                                          AND DPC.EffectiveFromTimeKey<=@TimeKey AND DPC.EffectiveToTimeKey>=@TimeKey


LEFT JOIN DimParameter DPCD               ON ACPD.ProjectDelReason_AltKey=DPCD.ParameterAlt_Key
                                          AND DPCD.EffectiveFromTimeKey<=@TimeKey AND DPCD.EffectiveToTimeKey>=@TimeKey
										  AND DPCD.DimParameterName='ProdectDelReson'

WHERE PUIM.EffectiveFromTimeKey<=@TimeKey AND PUIM.EffectiveToTimeKey>=@TimeKey


OPTION(RECOMPILE)
GO
