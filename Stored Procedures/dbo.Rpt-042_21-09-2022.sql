SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
CREATED BY  :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-Securitization Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-042_21-09-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26372


SELECT 

DS.SourceName
,CustomerID
,CustomerName
,AccountID
,ISNULL(AccountBalance,0)                       AS AccountBalance
,ISNULL(InterestReceivable,0)                   AS InterestReceivable
,ISNULL(POS,0)                                  AS POS
,PoolID
,PoolName
,SecuritisationType
,ISNULL(ExposureAmount,0)                       AS ExposureAmount
,CONVERT(VARCHAR(20),SecMarkingDate,103)        AS SecMarkingDate
,CONVERT(VARCHAR(20),ScrInDate,103)             AS ScrInDate
,CONVERT(VARCHAR(20),MaturityDate,103)          AS MaturityDate
,CONVERT(VARCHAR(20),ScrOutDate,103)            AS ScrOutDate
,ISNULL(InterestAccruedinRs,0)                  AS InterestAccruedinRs
,Remark

FROM SecuritizedFinalACDetail SFACD
INNER JOIN DimSourceDB DS          ON DS.SourceAlt_Key=SFACD.SourceAlt_Key
                                      AND  SFACD.EffectiveFromTimeKey<=@TimeKey AND SFACD.EffectiveToTimeKey>=@TimeKey
                                      AND  DS.EffectiveFromTimeKey<=@TimeKey AND DS.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
