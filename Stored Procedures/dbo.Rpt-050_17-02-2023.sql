SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
CREATED BY   :-Baijayanti
CREATED DATE :-30/08/2022
REPORT NAME  :-For Finacle RFA Fraud Report
*/


CREATE PROCEDURE [dbo].[Rpt-050_17-02-2023]
      @TimeKey AS INT,
	  @SelectReport AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26479,
--	  @SelectReport AS INT=1

DECLARE @CurDate AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)

SELECT 
DISTINCT
 ACH.UCIF_ID                                                     AS CIF
,CCH.RefCustomerID                                               AS CustomerID
,CCH.CustomerName                                                AS CustomerName
,FD.RefCustomerACID                                              AS AccountID
,''                                                              AS Industry
,FlgRestructure                                                  AS [Restructured - Y/N]
,ISNULL(CurrentLimit,0)                                          AS [SANCTION_LIMIT_LCY]
,ISNULL(Balance,0)                                               AS [Total Outstandings in LCY]
,CONVERT(VARCHAR(20),FraudDeclarationDate,103)                   AS [Date of Classification as Red Flag Account]
,CONVERT(VARCHAR(20),DateofRemovalofRFAClassification,103)       AS [Date of Re-classification from Red Flag Account Status]
,DATEDIFF(DD,FraudOccuranceDate,@CurDate)                        AS [Days Delay (over six months from classification) in reclassification of RFA]
,CONVERT(VARCHAR(20),FraudOccuranceDate,103)                     AS [Date of Classification as Fraud]
,AssetClassName                                                  AS [Asset Classification]
,CONVERT(VARCHAR(20),NPADateBeforeFraud,103)                     AS [NPA Date]

FROM Fraud_details FD
INNER JOIN Pro.AccountCal_Hist  ACH          ON  ACH.CustomerACID=FD.RefCustomerACID
                                                 AND  ACH.EffectiveFromTimeKey<=@TimeKey AND ACH.EffectiveToTimeKey>=@TimeKey

INNER JOIN Pro.CustomerCal_Hist  CCH         ON  CCH.RefCustomerID=ACH.RefCustomerID
                                                 AND  CCH.EffectiveFromTimeKey<=@TimeKey AND CCH.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAssetClass DAC                  ON DAC.AssetClassAlt_Key=FD.CurrentAssetClassAltKey
                                                AND  DAC.EffectiveFromTimeKey<=@TimeKey AND DAC.EffectiveToTimeKey>=@TimeKey

WHERE FD.EffectiveFromTimeKey<=@TimeKey AND FD.EffectiveToTimeKey>=@TimeKey AND @SelectReport=1


OPTION(RECOMPILE)
GO
