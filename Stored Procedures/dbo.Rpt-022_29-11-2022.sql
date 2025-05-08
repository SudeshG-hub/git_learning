SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
CREATE BY		:	Baijayanti
CREATE DATE	    :	16-08-2022
DISCRIPTION		:   SMA Movement Report
*/

 CREATE PROC [dbo].[Rpt-022_29-11-2022]  
  @FromDate   AS VARCHAR(15)
 ,@ToDate     AS VARCHAR(15)

AS 

--DECLARE 
-- @FromDate   AS VARCHAR(15)='28/02/2022'
--,@ToDate     AS VARCHAR(15)='30/03/2022'


SET NOCOUNT ON ;  


DECLARE	@From1		DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @To1		DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))


SELECT 
DISTINCT 
DB.BranchCode,
AMH.CustomerACID,
CustomerID,
CustomerName, 
MovementToStatus,
CONVERT(VARCHAR(20),MovementToDate,103)            AS MovementToDate,
ProductCode,
ISNULL(TotOsAcc,0)                                 AS TotOsAcc,
AssetClassShortNameEnum

FROM Pro.ACCOUNT_MOVEMENT_HISTORY  AMH
LEFT JOIN CustomerBasicDetail  CBD                  ON CBD.CustomerID=AMH.RefCustomerID
                                                       AND CBD.EffectiveToTimeKey=49999

LEFT JOIN AdvAcBasicDetail   ACBD                   ON ACBD.CustomerACID=AMH.CustomerACID
                                                       AND ACBD.EffectiveToTimeKey=49999

INNER JOIN DimAssetClass   DAC                      ON AMH.FinalAssetClassAlt_Key=DAC.AssetClassAlt_Key
                                                       AND DAC.EffectiveToTimeKey=49999

LEFT JOIN DimGLProduct  DGLP                        ON DGLP.GLProductAlt_Key=ACBD.GLProductAlt_Key
                                                       AND DGLP.EffectiveToTimeKey=49999

LEFT JOIN DimBranch DB                              ON ACBD.BranchCode=DB.BranchCode
                                                       AND DB.EffectiveToTimeKey=49999

WHERE @From1>=MovementFromDate  AND @To1<=MovementToDate   
			   

OPTION(RECOMPILE)






GO
