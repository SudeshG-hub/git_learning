SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
CREATED BY   :-Baijayanti
CREATED DATE :-12/08/2022
REPORT NAME  :-IBPC Report As On
*/


CREATE PROCEDURE [dbo].[Rpt-045_17-10-2022]
      @TimeKey AS INT
AS

--DECLARE 
--      @TimeKey AS INT=26372


SELECT 

 DS.SourceName
,CustomerID
,CustomerName
,AccountID
,ISNULL(AccountBalance,0)         AS AccountBalance
,ISNULL(InterestReceivable,0)     AS InterestReceivable
,ISNULL(POS,0)                    AS POS
,PoolID
,PoolName
,PoolType
,CONVERT(VARCHAR(20),IBPCMarkingDate,103)               AS IBPCMarkingDate
,CONVERT(VARCHAR(20),MaturityDate,103)					AS MaturityDate
,CASE WHEN FlagAlt_Key='Y'	
      THEN 'Yes'
	  WHEN FlagAlt_Key='N'
	  THEN 'No'
	  END				                                AS IBPCFlag
,ISNULL(ExposureAmount,0)                               AS ExposureAmount
,Remark

FROM IBPCFinalPoolDetail IBPCD
INNER JOIN DimSourceDB DS          ON DS.SourceAlt_Key=IBPCD.SourceAlt_Key
                                      AND  IBPCD.EffectiveFromTimeKey<=@TimeKey AND IBPCD.EffectiveToTimeKey>=@TimeKey
                                      AND  DS.EffectiveFromTimeKey<=@TimeKey AND DS.EffectiveToTimeKey>=@TimeKey

OPTION(RECOMPILE)
GO
