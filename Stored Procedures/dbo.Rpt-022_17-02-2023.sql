SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 

/*

CREATE BY      :   Baijayanti
CREATE DATE    :   16-08-2022
DISCRIPTION    :   SMA Movement Report

*/

CREATE PROC [dbo].[Rpt-022_17-02-2023] 
 @FromDate   AS VARCHAR(15)
,@ToDate     AS VARCHAR(15)

AS

--DECLARE
-- @FromDate   AS VARCHAR(15)='01/01/2022'
--,@ToDate     AS VARCHAR(15)='21/11/2086'

 
SET NOCOUNT ON ; 

DECLARE @From1  DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @To1   DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))
DECLARE @TimeKey  AS INT=(SELECT TimeKey FROM SysDayMatrix WHERE DATE=@To1)


SELECT
DISTINCT
ACH.BranchCode,
AMH.CustomerACID,
CCH.RefCustomerID,
CustomerName,
MovementToStatus,
CASE WHEN MovementFromStatus='SMA_0' OR MovementToStatus='SMA_0' THEN CONVERT(VARCHAR(20),MovementToDate,103) END            AS SMADate0,
CASE WHEN MovementFromStatus='SMA_1' OR MovementToStatus='SMA_1' THEN CONVERT(VARCHAR(20),MovementToDate,103) END            AS SMADate1,
CASE WHEN MovementFromStatus='SMA_2' OR MovementToStatus='SMA_2' THEN CONVERT(VARCHAR(20),MovementToDate,103) END            AS SMADate2,
ProductCode,
ISNULL(TotOsAcc,0)                                 AS TotOsAcc,
AssetClassShortNameEnum
,Null AS StatusAsOn
FROM Pro.ACCOUNT_MOVEMENT_HISTORY  AMH

INNER JOIN   Pro.AccountCal_Hist  ACH                 ON ACH.CustomerACID=AMH.CustomerACID
                                                       AND ACH.EffectiveFromTimeKey=@TimeKey AND ACH.EffectiveToTimeKey=@TimeKey 

INNER JOIN Pro.CustomerCal_Hist   CCH               ON CCH.RefCustomerID=AMH.RefCustomerID
                                                       AND CCH.EffectiveFromTimeKey=@TimeKey AND   CCH.EffectiveToTimeKey=@TimeKey 

INNER JOIN DimAssetClass   DAC                      ON AMH.FinalAssetClassAlt_Key=DAC.AssetClassAlt_Key
                                                       AND DAC.EffectiveFromTimeKey=@TimeKey AND   DAC.EffectiveToTimeKey=@TimeKey


WHERE @From1>=MovementFromDate  AND @To1<=MovementToDate  
      AND (MovementFromStatus IN('SMA_0','SMA_1','SMA_2') OR MovementToStatus IN('SMA_0','SMA_1','SMA_2'))
              
			                                       
OPTION(RECOMPILE)

GO
