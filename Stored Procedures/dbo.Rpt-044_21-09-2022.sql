SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
CREATED BY  :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-Buyout Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-044_21-09-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26372


SELECT 

AUNo
,BuyoutPartyLoanNo
,CustomerName
,PAN
,AadharNo
,AssetClassName
,CONVERT(VARCHAR(20),FinalNpaDt,103)       AS FinalNpaDt
,DPD
,ISNULL(InterestReceivable,0)              AS InterestReceivable
,ISNULL(PrincipalOutstanding,0)            AS PrincipalOutstanding
,PoolName
,Category
,ISNULL(Charges,0)                         AS Charges
,ISNULL(AccuredInterest,0)				   AS AccuredInterest
,ISNULL(NetBalance,0)					   AS NetBalance
,ISNULL(ApprRV,0)						   AS ApprRV
,ISNULL(SecuredAmt,0)					   AS SecuredAmt
,ISNULL(UnSecuredAmt,0)					   AS UnSecuredAmt
,ISNULL(SecurityValue,0)				   AS SecurityValue
,ISNULL(UsedRV,0)						   AS UsedRV
,ISNULL(Provsecured,0)					   AS Provsecured
,ISNULL(ProvUnsecured,0)				   AS ProvUnsecured
,ISNULL(TotalProvision,0)				   AS TotalProvision
,ISNULL(PrevProvPercentage,0)			   AS PrevProvPercentage
,ISNULL(FinalProvPercentage,0)			   AS FinalProvPercentage
,FLGUPG
,CONVERT(VARCHAR(20),UpgDate,103)          AS UpgDate
,FLGDEG
,DegReason
,Changes
,Remark

FROM BuyoutFinalDetails BOFD
LEFT JOIN DimAssetClass DAC          ON DAC.AssetClassAlt_Key=BOFD.FinalAssetClassAlt_Key                                     
                                        AND  DAC.EffectiveFromTimeKey<=@TimeKey AND DAC.EffectiveToTimeKey>=@TimeKey

WHERE   BOFD.EffectiveFromTimeKey<=@TimeKey AND BOFD.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
