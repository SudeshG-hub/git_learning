SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
CREATED BY   :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-Buyout Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-044]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26479


SELECT 
 CIFId
,ENBDAcNo                                      AS AUNo
,BuyoutPartyLoanNo
,CustomerName
,CONVERT(VARCHAR(20),PartnerNPADate,103)       AS FinalNpaDt
,PartnerAssetClass                             AS AssetClass
,PartnerDPD                                    AS DPD
,DP.ProductCode
,DP.ProductName
,ISNULL(ACH.Balance,0)                         AS Balance
,ISNULL(ACH.NetBalance,0)                      AS NetBalance
,ISNULL(ACH.TotalProvision,0)                  AS TotalProvision
,ISNULL((ISNULL(ACH.TotalProvision,0)/NULLIF(ACH.NetBalance,0))*100,0)             AS FinalProvPercentage
,ISNULL(int_receivable_adv,0)                  AS InterestReceivable
,ISNULL(PrincOutStd,0)                         AS PrincipalOutstanding
,''                                            AS PoolName
,''                                            AS Category
,0                                             AS Charges
,ISNULL(Accrued_interest,0)				       AS AccuredInterest
,[Action]
,CONVERT(VARCHAR(20),OverDueSinceDt,103)       AS OverDueDate

FROM BuyoutFinalDetails  BOFD
INNER JOIN Pro.AccountCal_Hist ACH                                  ON ACH.CustomerAcID=BOFD.ENBDAcNo
										                               AND  ACH.EffectiveFromTimeKey<=@TimeKey AND ACH.EffectiveToTimeKey>=@TimeKey
										                            
INNER JOIN Pro.CustomerCal_Hist CCH                                 ON ACH.RefCustomerID=CCH.RefCustomerID
										                               AND  CCH.EffectiveFromTimeKey<=@TimeKey AND CCH.EffectiveToTimeKey>=@TimeKey
										                            
LEFT JOIN AdvAcOtherFinancialDetail ACOFD                           ON ACH.AccountEntityID=ACOFD.AccountEntityID
										                               AND  ACOFD.EffectiveFromTimeKey<=@TimeKey AND ACOFD.EffectiveToTimeKey>=@TimeKey                       
										                            
LEFT JOIN DimProduct DP                                             ON ACH.ProductAlt_Key=DP.ProductAlt_Key
										                               AND  DP.EffectiveFromTimeKey<=@TimeKey AND DP.EffectiveToTimeKey>=@TimeKey

WHERE   BOFD.EffectiveFromTimeKey<=@TimeKey AND BOFD.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
