SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
 CREATE BY   :- KALIK DEV 
 CREATE DATE :- 26/10/2021
 DESCRIPTION :-  Investment Asset Classification Processing

 */ 

 
CREATE PROCEDURE [dbo].[Rpt-041_05-08-2022]	
    @TimeKey AS INT,
	@Cost AS FLOAT,
	@AssetClass AS VARCHAR(10)
	
AS

--DECLARE
--    @Timekey AS INT=26372,
--	@Cost AS FLOAT=1,
--	@AssetClass AS VARCHAR(10)='<ALL>'
	


SELECT
IID.UcifId                                                                 AS UCIC_ID,
IID.IssuerID                                                               AS IssuerID,
IID.IssuerName                                                             AS IssuerName,
IBD.InvID                                                                  AS 'InvestmentID/Derv No.',
IBD.InvestmentNature                                                       AS InvestmentNature,
CONVERT(VARCHAR(15),IBD.MaturityDt,103)                                    AS MaturityDt,
CONVERT(VARCHAR(15),IBD.ReStructureDate,103)                               AS ReStructureDate,
IFD.HoldingNature                                                          AS HoldingNature,	
--------CHANGED ON 18-04-2022--------------												                       
--ISNULL(IFD.BookValue,0)/@Cost                                              AS BookValue,
--ISNULL(IFD.MTMValue,0)/@Cost                                               AS MTMValue,
ISNULL(IFD.BookValueINR,0)/@Cost                                              AS BookValue,
ISNULL(IFD.MTMValueINR,0)/@Cost                                               AS MTMValue,														                       
CONVERT(VARCHAR(15),IFD.NPIDt,103)                                         AS NPIDt,
ISNULL(IFD.TotalProvison,0)/@Cost                                          AS TotalProvison,
IFD.GL_Code                                                                AS GL_Code,
IFD.GL_Description                                                         AS GL_Description,
IFD.DPD                                                                    AS DPD,
ISNULL(IFD.Interest_DividendDueAmount,0)/@Cost                             AS OVERDUE_AMOUNT,
CONVERT(VARCHAR(15),IFD.PartialRedumptionDueDate,103)                      AS PartialRedumptionDueDate,
IFD.FLGDEG                                                                 AS FLGDEG,
IFD.DEGREASON                                                              AS DEGREASON,
IFD.FLGUPG                                                                 AS FLGUPG,
----CONVERT(VARCHAR(15),IFD.UpgDate,103)                                       AS UpgDate,
DA.AssetClassName                                                             AS NPIAssetClass
,''                                     AS CouponOverDueSinceDt
,IFD.SMA_Class                          AS SMA_Status
,'Investment'                           AS Flag,
InstrName                               AS InstrumentName,
''                                      AS OverDueSinceDt,
ISNULL(OVERDUE_AMOUNT,0)                AS DueAmtReceivable 

FROM dbo.InvestmentBasicDetail IBD
INNER JOIN DBO.InvestmentFinancialdetail     IFD			ON  IFD.InvEntityId=IBD.InvEntityId 
															    AND IFD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IFD.EffectiveToTimeKey>=@TimeKey
																AND IBD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IBD.EffectiveToTimeKey>=@TimeKey
																
INNER JOIN DBO.InvestmentIssuerDetail   IID				    ON   IID.IssuerEntityId=IBD.IssuerEntityId 
															    AND IID.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IID.EffectiveToTimeKey>=@TimeKey
LEFT JOIN DimAssetClass DA                                   ON DA.AssetClassAlt_Key=IFD.FinalAssetClassAlt_Key
                                                             AND DA.EffectiveToTimeKey=49999
WHERE  ((@AssetClass='STANDARD' AND DA.AssetClassName='STANDARD')
	     OR (@AssetClass='NPA' AND ISNULL(DA.AssetClassName,'')<>'STANDARD')
		 OR (@AssetClass='<ALL>'))


UNION ALL

SELECT
UCIC_ID,
CustomerID                                                               AS IssuerID,
CustomerName                                                             AS IssuerName,
DerivativeRefNo                                                          AS 'InvestmentID/Derv No.',
''                                                                       AS InvestmentNature,
CONVERT(VARCHAR(15),Duedate,103)                                         AS MaturityDt,
''                                                                       AS ReStructureDate,
''                                                                       AS HoldingNature,													                       
(CASE WHEN OsAmt<0
      THEN OsAmt*-1
      ELSE ISNULL(OsAmt,0)END)/@Cost                                      AS BookValue,
ISNULL(MTMIncomeAmt,0)/@Cost                                             AS MTMValue,													                       
CONVERT(VARCHAR(15),NPIDt,103)                                           AS NPIDt,
ISNULL(TotalProvison,0)/@Cost                                            AS TotalProvison,
''                                                                       AS GL_Code,
''                                                                       AS GL_Description,
DPD                                                                      AS DPD,
ISNULL(OverdueCouponAmt,0)/@Cost                                         AS OVERDUE_AMOUNT,
''                                                                       AS PartialRedumptionDueDate,
FLGDEG                                                                   AS FLGDEG,
DEGREASON                                                                AS DEGREASON,
FLGUPG                                                                   AS FLGUPG,
----CONVERT(VARCHAR(15),IFD.UpgDate,103)                                       AS UpgDate,
DA.AssetClassName                                                             AS NPIAssetClass
,CONVERT(VARCHAR(15),CouponOverDueSinceDt,103)                           AS CouponOverDueSinceDt
,''                                                                      AS SMA_Status
,'Derivative'                                                            AS Flag
,Derivative.InstrumentName                                               AS InstrumentName
,CONVERT(VARCHAR(20),Derivative.OverDueSinceDt,103)                      AS OverDueSinceDt
,ISNULL(Derivative.DueAmtReceivable,0)                                   AS DueAmtReceivable
FROM CURDAT.DerivativeDetail Derivative

LEFT JOIN DimAssetClass DA                        ON DA.AssetClassAlt_Key=Derivative.FinalAssetClassAlt_Key
                                                  AND DA.EffectiveToTimeKey=49999
												  

WHERE  ((@AssetClass='STANDARD' AND DA.AssetClassName='STANDARD')
	     OR (@AssetClass='NPA' AND ISNULL(DA.AssetClassName,'')<>'STANDARD')
		 OR (@AssetClass='<ALL>')) AND Derivative.EffectiveFromTimeKey<=@TimeKey AND Derivative.EffectiveToTimeKey>=@TimeKey
	
	
	
	ORDER BY UCIC_ID															

OPTION(RECOMPILE)

																


   
GO
