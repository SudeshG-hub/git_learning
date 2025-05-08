SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*

CREATE BY           : Baijayanti
CREATE DATE         : 16-08-2022
DISCRIPTION         : NPA Movement Report

*/

 

CREATE PROC [dbo].[Rpt-015_17-02-2023] 
  @FromDate   AS VARCHAR(15)
 ,@ToDate     AS VARCHAR(15)
AS

 

--DECLARE
--  @FromDate   AS VARCHAR(15)='01/10/2022'
-- ,@ToDate     AS VARCHAR(15)='31/10/2022'


SET NOCOUNT ON ; 

 

DECLARE @From1  DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @To1    DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))

DECLARE @TimeKey  AS INT=(SELECT TimeKey FROM SysDayMatrix WHERE DATE=@To1)
---------------------------------------------Final Selection---------------------------


SELECT

CONVERT(VARCHAR(20),NPAProcessingDate,103)                          AS Created_Date,
Movement_Flag,
CustomerAcid,
DACI.AssetClassGroup                                                AS I_AssetClassGroup,
CONVERT(VARCHAR(20),NPADt,103)                                      AS NPADt,
 ''																	AS DB1dt
,''																	AS DB2dt
,''																	AS DB3Dt
,''                                                                 AS lOSSDT,
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
ISNULL(FinalNNPABalance,0)                                          AS FinalNNPABalance,
ISNULL(TotalAddition_GNPA,0)                                        AS TotalAddition_GNPA,
ISNULL(TotalReduction_GNPA,0)                                       AS TotalReduction_GNPA,
ISNULL(TotalAddition_Provision,0)                                   AS TotalAddition_Provision,
ISNULL(TotalReduction_Provision,0)                                  AS TotalReduction_Provision,
ISNULL(TotalAddition_UnservicedInterest,0)                          AS TotalAddition_UnservicedInterest,
ISNULL(TotalReduction_UnservicedInterest,0)                         AS TotalReduction_UnservicedInterest

FROM NPAMovement NPAM
INNER JOIN DimAssetClass DACI              ON NPAM.InitialAssetClassAlt_Key=DACI.AssetClassAlt_Key
                                              AND DACI.EffectiveFromTimeKey<=@TimeKey AND DACI.EffectiveToTimeKey>=@TimeKey

INNER JOIN DimAssetClass DACF              ON NPAM.FinalAssetClassAlt_Key=DACF.AssetClassAlt_Key
                                              AND DACF.EffectiveFromTimeKey<=@TimeKey AND DACF.EffectiveToTimeKey>=@TimeKey

LEFT JOIN AdvAcFinancialDetail ACFD        ON ACFD.RefSystemAcId=NPAM.CustomerACID
                                              AND ACFD.EffectiveFromTimeKey<=@TimeKey AND ACFD.EffectiveToTimeKey>=@TimeKey


WHERE NPAProcessingDate BETWEEN @From1 AND @To1

 

 

OPTION(RECOMPILE)

 
GO
