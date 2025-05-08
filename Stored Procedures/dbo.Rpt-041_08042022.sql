SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
 CREATE BY   :- KALIK DEV 
 CREATE DATE :- 26/10/2021
 DESCRIPTION :-  Investment Asset Classification Processing

 */

 
CREATE PROCEDURE [dbo].[Rpt-041_08042022]	
    @TimeKey AS INT,
	@Cost AS FLOAT,
	@AssetClass AS VARCHAR(10)
	
AS

--DECLARE
--    @Timekey AS INT=26176,
--	@Cost AS FLOAT=1,
--	@AssetClass AS VARCHAR(10)='STANDARD'
	


 SELECT
IID.IssuerID                                                               AS IssuerID,
IID.IssuerName                                                             AS IssuerName,
IBD.InvestmentNature                                                       AS InvestmentNature,
CONVERT(VARCHAR(15),IBD.MaturityDt,103)                                    AS MaturityDt,
CONVERT(VARCHAR(15),IBD.ReStructureDate,103)                               AS ReStructureDate,
IFD.HoldingNature                                                          AS HoldingNature,													                       
ISNULL(IFD.BookValue,0)/@Cost                                              AS BookValue,
ISNULL(IFD.MTMValue,0)/@Cost                                               AS MTMValue,													                       
CONVERT(VARCHAR(15),IFD.NPIDt,103)                                         AS NPIDt,
ISNULL(IFD.TotalProvison,0)/@Cost                                          AS TotalProvison,
IFD.GL_Code                                                                AS GL_Code,
IFD.GL_Description                                                         AS GL_Description,
IFD.DPD                                                                    AS DPD,
ISNULL(IFD.OVERDUE_AMOUNT,0)/@Cost                                         AS OVERDUE_AMOUNT,
CONVERT(VARCHAR(15),IFD.PartialRedumptionDueDate,103)                      AS PartialRedumptionDueDate,
IFD.FLGDEG                                                                 AS FLGDEG,
IFD.DEGREASON                                                              AS DEGREASON,
IFD.FLGUPG                                                                 AS FLGUPG,
CONVERT(VARCHAR(15),IFD.UpgDate,103)                                       AS UpgDate,
IFD.AssetClass                                                             AS AssetClass
FROM dbo.InvestmentBasicDetail IBD
INNER JOIN DBO.InvestmentFinancialdetail     IFD			ON  IFD.InvEntityId=IBD.InvEntityId 
															    AND IFD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IFD.EffectiveToTimeKey>=@TimeKey
																AND IBD.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IBD.EffectiveToTimeKey>=@TimeKey
																
INNER JOIN DBO.InvestmentIssuerDetail   IID				    ON   IID.IssuerEntityId=IBD.IssuerEntityId 
															    AND IID.EffectiveFromTimeKey<=@TimeKey 
                                                                AND IID.EffectiveToTimeKey>=@TimeKey

WHERE  ((@AssetClass='STANDARD' AND IFD.AssetClass='STANDARD')
	     OR (@AssetClass='NPA' AND ISNULL(IFD.AssetClass,'')<>'STANDARD')
		 OR (@AssetClass='<ALL>'))


OPTION(RECOMPILE)

																


   
GO
