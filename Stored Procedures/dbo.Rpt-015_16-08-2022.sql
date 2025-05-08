SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
CREATE BY		:	Baijayanti
CREATE DATE	    :	26-04-2021
DISCRIPTION		:   Base NPA Movement Report 
*/

 create PROC [dbo].[Rpt-015_16-08-2022]  
  @UserName AS VARCHAR(20)
 ,@MisLocation AS VARCHAR(20)
 ,@CustFacility AS VARCHAR(10)
 ,@TimeKey AS INT
 ,@Cost    AS FLOAT
AS 

--DECLARE 
-- @UserName AS VARCHAR(20)='D2K'	
--,@MisLocation AS VARCHAR(20)=''
--,@CustFacility AS VARCHAR(10)=3
--,@TimeKey AS INT=25999
--,@Cost    AS FLOAT=1


SET NOCOUNT ON ;  

DECLARE @Flag AS CHAR(5)            
DECLARE @Department AS VARCHAR(10)            
DECLARE @AuthenFlag AS CHAR(5)            
DECLARE @Code AS VARCHAR(10)            
            
SET @AuthenFlag = (SELECT dbo.AuthenticationFlag())            
SET @Flag = (SELECT dbo.ADflag())            
 IF @Flag='Y'             
 BEGIN            
   SET @Department = (LEFT(@MisLocation,2))            
   SET @Code = (RIGHT(@MisLocation,3))            
 END            
            
 ELSE IF @Flag='SQL'            
 BEGIN            
   IF @AuthenFlag = 'Y'            
    BEGIN            
     SET @Department = (SELECT TOP(1)UserLocation FROM DimUserInfo WHERE UserLoginID = @UserName	AND EffectiveToTimeKey=49999)            
     SET @Code = (SELECT TOP(1)UserLocationCode FROM DimUserInfo WHERE UserLoginID = @UserName		AND EffectiveToTimeKey=49999)        
    END            
                
   ELSE IF @AuthenFlag = 'N'            
       BEGIN            
     SET @Department = 'RO'            
     SET @Code       = '07'            
       END            
 END    
   

DECLARE @BankCode INT
	SET @BankCode=(SELECT BankAlt_Key FROM SysReportformat)

DECLARE @PerQtrKey INT=(SELECT LastQtrDateKey FROM SysDayMatrix WHERE TimeKey=@TimeKey)



---------------------------------------------Final Selection---------------------------


SELECT 
CONVERT(VARCHAR(20),NPAProcessingDate,103)                          AS Created_Date,
Movement_Flag,
''                                                                  AS MOC_Date,
CustomerAcid,
DACI.AssetClassGroup                                                AS I_AssetClassGroup,
CONVERT(VARCHAR(20),NPADt,103)                                      AS NPADt,
ISNULL(InitialNPABalance,0)/@Cost                                   AS InitialNPABalance,
ISNULL(InitialUnservicedInterest,0)/@Cost                           AS InitialUnservicedInterest,
ISNULL(InitialGNPABalance,0)/@Cost                                  AS InitialGNPABalance,
ISNULL(InitialProvision,0)/@Cost                                    AS InitialProvision,
ISNULL(InitialNNPABalance,0)/@Cost                                  AS InitialNNPABalance,
ISNULL(ExistingNPA_Addition,0)/@Cost                                AS ExistingNPA_Addition,
ISNULL(FreshNPA_Addition,0)/@Cost                                   AS FreshNPA_Addition,
ISNULL(ReductionDuetoUpgradeAmount,0)/@Cost                         AS ReductionDuetoUpgradeAmount,
ISNULL(ReductionDuetoRecovery_ExistingNPA,0)/@Cost                  AS ReductionDuetoRecovery_ExistingNPA,
ISNULL(ReductionDuetoWrite_OffAmount,0)/@Cost                       AS ReductionDuetoWrite_OffAmount,
ISNULL(ReductionDuetoRecovery_Arcs,0)/@Cost                         AS ReductionDuetoRecovery_Arcs,
DACF.AssetClassGroup                                                AS F_AssetClassGroup,
MovementNature,
ISNULL(FinalNPABalance,0)/@Cost                                     AS FinalNPABalance,
ISNULL(FinalUnservicedInterest,0)/@Cost                             AS FinalUnservicedInterest,
ISNULL(FinalGNPABalance,0)/@Cost                                    AS FinalGNPABalance,
MovementStatus,
ISNULL(FinalProvision,0)/@Cost                                      AS FinalProvision, 
ISNULL(FinalNNPABalance,0)/@Cost									AS FinalNNPABalance,
ISNULL(TotalAddition_GNPA,0)/@Cost								    AS TotalAddition_GNPA,
ISNULL(TotalReduction_GNPA,0)/@Cost								    AS TotalReduction_GNPA,
ISNULL(TotalAddition_Provision,0)/@Cost							    AS TotalAddition_Provision,
ISNULL(TotalReduction_Provision,0)/@Cost							AS TotalReduction_Provision,
ISNULL(TotalAddition_UnservicedInterest,0)/@Cost					AS TotalAddition_UnservicedInterest,
ISNULL(TotalReduction_UnservicedInterest,0)/@Cost					AS TotalReduction_UnservicedInterest

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
