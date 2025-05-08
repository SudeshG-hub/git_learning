SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
CREATED BY  :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-Sale To ARC Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-043_17-10-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26479


SELECT 

 DS.SourceName
,CustomerID
,CustomerName
,AccountID
,ISNULL(AccountBalance,0)                     AS AccountBalance
,ISNULL(InterestReceivable,0)                 AS InterestReceivable
,ISNULL(POS,0)                                AS POS
,ISNULL(ExposureAmount,0)                     AS ExposureAmount
,CONVERT(VARCHAR(20),DtofsaletoARC,103)       AS DtofsaletoARC
,CONVERT(VARCHAR(20),DateofApproval,103)      AS DateofApproval
,CASE WHEN FlagAlt_Key='Y'
      THEN 'Yes'
	  WHEN FlagAlt_Key='N'
	  THEN 'No'
	  END                                     AS Flag
,Remark

FROM SaletoARCFinalACFlagging SARCD
INNER JOIN DimSourceDB DS          ON DS.SourceAlt_Key=SARCD.SourceAlt_Key
                                      AND  SARCD.EffectiveFromTimeKey<=@TimeKey AND SARCD.EffectiveToTimeKey>=@TimeKey
                                      AND  DS.EffectiveFromTimeKey<=@TimeKey AND DS.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
