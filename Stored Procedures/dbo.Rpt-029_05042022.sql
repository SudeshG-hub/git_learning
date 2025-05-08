SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt-029_05042022]
      @TimeKey AS INT,
	  @Cost    AS FLOAT
AS

--DECLARE 
--      @TimeKey AS INT=25992,
--	  @Cost    AS FLOAT=1

DECLARE @Date AS DATE=(SELECT [DATE] FROM SysDayMatrix WHERE TimeKey=@TimeKey)
DECLARE @LastQtrDateKey INT = (SELECT LastQtrDateKey FROM sysdaymatrix WHERE timekey=@TimeKey)

-----------------------------------Provision


SELECT 
CONVERT(VARCHAR(20),@Date, 103)                  AS  [Process_date]
,A.UCIF_ID                                       AS UCIC
,A.RefCustomerID                                 AS CustomerID
,CustomerName
,B.BranchCode
,BranchName
,CustomerAcID
,SourceName
,B.FacilityType
,SchemeType
,B.ProductCode
,ProductName
,ActSegmentCode
,AcBuSegmentDescription
,AcBuRevisedSegmentCode
,DPD_Max
,CASE  WHEN A.SourceAlt_Key = 6 
        THEN 'CD' 
		ELSE '' 
		END                                                          AS [Cycle Past due]
,CONVERT(VARCHAR(20),FinalNpaDt,103)                                 AS FinalNpaDt
,A2.AssetClassName                                                   AS FinalAssetName
,NPANorms								                             
,ISNULL(B.NetBalance,0)/@Cost                                        AS NetBalance
,ISNULL(SecurityValue,0)/@Cost                                       AS SecurityValue
,ISNULL(ApprRV,0)/@Cost                                              AS ApprRV
,ISNULL(B.SecuredAmt,0)/@Cost                                        AS SecuredAmt
,ISNULL(B.UnSecuredAmt,0)/@Cost                                      AS UnSecuredAmt
,ISNULL(B.TotalProvision,0)/@Cost                                    AS TotalProvision
,ISNULL(B.Provsecured,0)/@Cost                                       AS Provsecured
,ISNULL(B.ProvUnsecured,0)/@Cost                                     AS ProvUnsecured
,(ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0))/@Cost           AS [Net NPA]
,(ISNULL(B.Provsecured,0)/NULLIF(B.SecuredAmt,0))*100                AS [ProvisionSecured%]
,(ISNULL(B.ProvUnsecured,0)/NULLIF(B.UnSecuredAmt,0))*100            AS [ProvisionUnSecured%]
,(ISNULL(B.TotalProvision,0)/NULLIF(B.NetBalance,0))*100             AS [ProvisionTotal%]
,ISNULL(Y.NetBalance,0)/@Cost                                        AS [Prev. Qtr. Balance Outstanding]
,ISNULL(Y.SecuredAmt,0)/@Cost	                                     AS [Prev. Qtr. Secured Outstanding]
,ISNULL(Y.UnSecuredAmt,0)/@Cost	                                     AS [Prev. Qtr. Unsecured Outstanding]
,ISNULL(Y.TotalProvision,0)/@Cost	                                 AS [Prev. Qtr.Provision Total]
,ISNULL(Y.Provsecured,0)/@Cost	                                     AS [Prev. Qtr.Provision Secured]
,ISNULL(Y.ProvUnsecured,0)/@Cost	                                 AS [Prev. Qtr. Provision Unsecured]
,ISNULL(Y.NetNPA,0)/@Cost	                                         AS [Prev. Qtr. Net NPA]
,(CASE WHEN (ISNULL(B.NetBalance,0) - ISNULL(Y.netBalance,0)) < 0 
       THEN 0 
	   ELSE (ISNULL(B.NetBalance,0) - ISNULL(Y.netBalance,0)) 
	   END)/@Cost                                                    AS NPAIncrease

,(CASE WHEN (ISNULL(B.NetBalance,0) - ISNULL(Y.netBalance,0)) >= 0 
       THEN 0 
	   ELSE (ISNULL(B.NetBalance,0) - ISNULL(Y.netBalance,0)) 
	   END)/@Cost                                                    AS NPADecrease

,(CASE WHEN (ISNULL(B.TotalProvision,0) - ISNULL(Y.TotalProvision,0)) < 0 
       THEN 0 
	   ELSE (ISNULL(B.TotalProvision,0) - ISNULL(Y.TotalProvision,0)) 
	   END)/@Cost                                                     AS ProvisionIncrease

,(CASE WHEN (ISNULL(B.TotalProvision,0) - ISNULL(Y.TotalProvision,0)) >= 0 
       THEN 0 
	   ELSE (ISNULL(B.TotalProvision,0) - ISNULL(Y.TotalProvision,0)) 
	   END)/@Cost                                                     AS ProvisionDecrease

,(CASE WHEN ((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y.NetNPA,0)) < 0 
       THEN 0 
	   ELSE ((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y.NetNPA,0)) 
	   END)/@Cost                                                     AS NetNPAIncrease

,(CASE WHEN ((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y.NetNPA,0)) >= 0 
       THEN 0 
	   ELSE ((ISNULL(B.NetBalance,0)-ISNULL(B.TotalProvision,0)) - ISNULL(Y.NetNPA,0)) 
	   END)/@Cost                                                     AS NetNPAnDecrease
FROM PRO.CUSTOMERCAL A
INNER JOIN PRO.ACCOUNTCAL B       	ON A.CustomerEntityID=B.CustomerEntityID
                                       AND A.EffectiveFromTimeKey<=@TimeKey
									   AND A.EffectiveToTimeKey>=@TimeKey
                                       AND B.EffectiveFromTimeKey<=@TimeKey
									   AND B.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DIMSOURCEDB src	        ON B.SourceAlt_Key =src.SourceAlt_Key
                                       AND src.EffectiveFromTimeKey<=@TimeKey
									   AND src.EffectiveToTimeKey>=@TimeKey
	

LEFT JOIN DIMPRODUCT PD          	ON  PD.PRODUCTALT_KEY=B.PRODUCTALT_KEY
                                        AND PD.EffectiveFromTimeKey<=@TimeKey
									    AND PD.EffectiveToTimeKey>=@TimeKey


LEFT JOIN DimAssetClass A2	        ON A2.AssetClassAlt_Key=B.FinalAssetClassAlt_Key
                                       AND A2.EffectiveFromTimeKey<=@TimeKey
									   AND A2.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimAcBuSegment S          ON B.ActSegmentCode=S.AcBuSegmentCode
                                       AND S.EffectiveFromTimeKey<=@TimeKey
									   AND S.EffectiveToTimeKey>=@TimeKey

LEFT JOIN DimBranch X               ON B.BranchCode = X.BranchCode
                                       AND X.EffectiveFromTimeKey<=@TimeKey
									   AND X.EffectiveToTimeKey>=@TimeKey
LEFT JOIN (
SELECT 
A. CustomerEntityID,
ISNULL(NetBalance,0)                                 AS NetBalance,
ISNULL(SecuredAmt,0)                                 AS SecuredAmt,
ISNULL(UnSecuredAmt,0)                               AS UnSecuredAmt,
ISNULL(TotalProvision,0)                             AS TotalProvision,
ISNULL(Provsecured,0)                                AS Provsecured,
ISNULL(ProvUnsecured,0)                              AS ProvUnsecured,
(ISNULL(NetBalance,0)-ISNULL(totalprovision,0))      AS NetNPA
FROM PRO.CUSTOMERCAL A
INNER JOIN PRO.ACCOUNTCAL B	          ON A.CustomerEntityID=B.CustomerEntityID

WHERE B.EffectiveFromTimeKey <= @LastQtrDateKey AND B.EffectiveToTimeKey >=@LastQtrDateKey
      AND A.EffectiveFromTimeKey <= @LastQtrDateKey AND A.EffectiveToTimeKey >=@LastQtrDateKey)Y 	ON A.CustomerEntityID = Y.CustomerEntityID

OPTION(RECOMPILE)
GO
