SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*
CREATE BY		:	Baijayanti
CREATE DATE	    :	09-04-2021
DISCRIPTION		:   NPA Erosion Report
*/

 create PROC [dbo].[Rpt-014_18-08-2022]  
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
--,@TimeKey AS INT=26114
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


----------------------------------Security Data-------------------------
-------------------------Per------------------------
IF(OBJECT_ID('tempdb..#Per_Security') IS NOT NULL)
DROP TABLE #Per_Security

SELECT
AccountEntityId,
SUM(ISNULL(CurrentValue,0))        Per_SecurityValue   
INTO #Per_Security
FROM AdvSecurityDetail  ASD 
INNER JOIN  AdvSecurityValueDetail    ASVD     ON ASD.SecurityEntityID=ASVD.SecurityEntityID

WHERE ASD.EffectiveFromTimeKey<=@PerQtrKey AND ASD.EffectiveToTimeKey>=@PerQtrKey
      AND ASVD.EffectiveFromTimeKey<=@PerQtrKey AND ASVD.EffectiveToTimeKey>=@PerQtrKey

GROUP BY
AccountEntityId

OPTION(RECOMPILE)

--------------------Cur-----------------------------------
IF(OBJECT_ID('tempdb..#Cur_Security') IS NOT NULL)
DROP TABLE #Cur_Security

SELECT
AccountEntityId,
SUM(ISNULL(CurrentValue,0))        Cur_SecurityValue   
INTO #Cur_Security
FROM AdvSecurityDetail  ASD 
INNER JOIN  AdvSecurityValueDetail    ASVD     ON ASD.SecurityEntityID=ASVD.SecurityEntityID

WHERE ASD.EffectiveFromTimeKey<=@TimeKey AND ASD.EffectiveToTimeKey>=@TimeKey
      AND ASVD.EffectiveFromTimeKey<=@TimeKey AND ASVD.EffectiveToTimeKey>=@TimeKey

GROUP BY
AccountEntityId

OPTION(RECOMPILE)

------------------------------------------------------------------
----------------------------------Per AssetClass------------------------
IF(OBJECT_ID('tempdb..#Per_AssetClass') IS NOT NULL)
DROP TABLE #Per_AssetClass

SELECT
ACBD.AccountEntityId,
AssetClassShortNameEnum          
INTO #Per_AssetClass
FROM AdvAcBasicDetail  ACBD 
INNER JOIN  AdvAcBalanceDetail ACBAL    ON ACBD.AccountEntityId=ACBAL.AccountEntityId

INNER JOIN DimAssetClass DAC          ON ACBAL.AssetClassAlt_Key=DAC.AssetClassAlt_Key
                                         AND DAC.EffectiveFromTimeKey<=@PerQtrKey AND DAC.EffectiveToTimeKey>=@PerQtrKey

WHERE ACBD.EffectiveFromTimeKey<=@PerQtrKey AND ACBD.EffectiveToTimeKey>=@PerQtrKey
      AND ACBAL.EffectiveFromTimeKey<=@PerQtrKey AND ACBAL.EffectiveToTimeKey>=@PerQtrKey



OPTION(RECOMPILE)

------------------------------------------------
---------------------------------------------Final Selection---------------------------


SELECT 
 CBD.CustomerId
,CBD.CustomerName
,SUM(ISNULL(PS.Per_SecurityValue,0))/@Cost                                      AS Per_SecurityValue
,SUM(ISNULL(CS.Cur_SecurityValue,0))/@Cost                                      AS Cur_SecurityValue
,((SUM(ISNULL(CS.Cur_SecurityValue,0))/@Cost)/(NULLIF(SUM(ISNULL(ACBAL.Balance,0)),0)/@Cost))*100        AS Security_Erosion
,PAC.AssetClassShortNameEnum                                                    AS Prv_AssetClass
,DAC.AssetClassShortNameEnum                                                    AS Current_AssetClass
,SUM(ISNULL(ACBAL.Balance,0))/@Cost                                             AS Balance_Outstanding


FROM AdvAcBasicDetail ACBD 
INNER JOIN CustomerBasicDetail CBD        ON ACBD.CustomerEntityId=CBD.CustomerEntityId
                                             AND CBD.EffectiveFromTimeKey<=@TimeKey 
										     AND CBD.EffectiveToTimeKey>=@TimeKey
										     AND ACBD.EffectiveFromTimeKey<=@TimeKey 
										     AND ACBD.EffectiveToTimeKey>=@TimeKey

INNER JOIN AdvAcBalanceDetail ACBAL       ON ACBD.AccountEntityId=ACBAL.AccountEntityId
                                             AND ACBAL.EffectiveFromTimeKey<=@TimeKey 
											 AND ACBAL.EffectiveToTimeKey>=@TimeKey

LEFT JOIN #Per_Security  PS               ON ACBD.AccountEntityId=PS.AccountEntityId
									      
LEFT JOIN #Cur_Security  CS               ON ACBD.AccountEntityId=CS.AccountEntityId


LEFT JOIN #Per_AssetClass  PAC            ON ACBD.AccountEntityId=PAC.AccountEntityId


INNER JOIN DimAssetClass DAC              ON ACBAL.AssetClassAlt_Key=DAC.AssetClassAlt_Key
                                             AND DAC.EffectiveFromTimeKey<=@TimeKey 
											 AND DAC.EffectiveToTimeKey>=@TimeKey

WHERE (ISNULL(CS.Cur_SecurityValue,0)/NULLIF(ISNULL(ACBAL.Balance,0),0))*100 <50 

GROUP BY
 CBD.CustomerId
,CBD.CustomerName
,PAC.AssetClassShortNameEnum
,DAC.AssetClassShortNameEnum

OPTION(RECOMPILE)

GO
