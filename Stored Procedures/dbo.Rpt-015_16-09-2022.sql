SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
CREATE BY		:	Baijayanti
CREATE DATE	    :	16-08-2022
DISCRIPTION		:   NPA Movement Report 
*/

 CREATE PROC [dbo].[Rpt-015_16-09-2022]  
  @TimeKey AS INT
AS 

--DECLARE 
-- @TimeKey AS INT=25999



SET NOCOUNT ON ;  


DECLARE @PerQtrKey INT=(SELECT LastQtrDateKey FROM SysDayMatrix WHERE TimeKey=@TimeKey)

---------------------------------------------Final Selection---------------------------


SELECT 
CONVERT(VARCHAR(20),NPAProcessingDate,103)                          AS Created_Date,
Movement_Flag,
CustomerAcid,
DACI.AssetClassGroup                                                AS I_AssetClassGroup,
CONVERT(VARCHAR(20),NPADt,103)                                      AS NPADt,
ISNULL(InitialNPABalance,0)                                         AS InitialNPABalance,
ISNULL(InitialUnservicedInterest,0)                                 AS InitialUnservicedInterest,
ISNULL(InitialGNPABalance,0)                                        AS InitialGNPABalance,
ISNULL(InitialProvision,0)                                          AS InitialProvision,
ISNULL(InitialNNPABalance,0)                                        AS InitialNNPABalance,
ISNULL(ExistingNPA_Addition,0)                                      AS ExistingNPA_Addition,
ISNULL(FreshNPA_Addition,0)                                         AS FreshNPA_Addition,
ISNULL(ReductionDuetoUpgradeAmount,0)                               AS ReductionDuetoUpgradeAmount,
ISNULL(ReductionDuetoRecovery_ExistingNPA,0)                        AS ReductionDuetoRecovery_ExistingNPA,
ISNULL(ReductionDuetoWrite_OffAmount,0)                             AS ReductionDuetoWrite_OffAmount,
ISNULL(ReductionDuetoRecovery_Arcs,0)                               AS ReductionDuetoRecovery_Arcs,
DACF.AssetClassGroup                                                AS F_AssetClassGroup,
MovementNature,
ISNULL(FinalNPABalance,0)                                           AS FinalNPABalance,
ISNULL(FinalUnservicedInterest,0)                                   AS FinalUnservicedInterest,
ISNULL(FinalGNPABalance,0)                                          AS FinalGNPABalance,
MovementStatus,
ISNULL(FinalProvision,0)                                            AS FinalProvision, 
ISNULL(FinalNNPABalance,0)									        AS FinalNNPABalance,
ISNULL(TotalAddition_GNPA,0)								        AS TotalAddition_GNPA,
ISNULL(TotalReduction_GNPA,0)								        AS TotalReduction_GNPA,
ISNULL(TotalAddition_Provision,0)							        AS TotalAddition_Provision,
ISNULL(TotalReduction_Provision,0)							        AS TotalReduction_Provision,
ISNULL(TotalAddition_UnservicedInterest,0)					        AS TotalAddition_UnservicedInterest,
ISNULL(TotalReduction_UnservicedInterest,0)					        AS TotalReduction_UnservicedInterest

FROM NPAMovement NPAM 
LEFT JOIN AdvAcFinancialDetail ACFD        ON ACFD.RefSystemAcId=NPAM.CustomerACID
										       AND ACFD.EffectiveFromTimeKey<=@TimeKey 
										       AND ACFD.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DACI              ON NPAM.InitialAssetClassAlt_Key=DACI.AssetClassAlt_Key
                                              AND DACI.EffectiveFromTimeKey<=@TimeKey 
											  AND DACI.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DACF              ON NPAM.FinalAssetClassAlt_Key=DACF.AssetClassAlt_Key
                                              AND DACF.EffectiveFromTimeKey<=@TimeKey 
											  AND DACF.EffectiveToTimeKey>=@TimeKey

WHERE Timekey=@TimeKey


OPTION(RECOMPILE)

GO
