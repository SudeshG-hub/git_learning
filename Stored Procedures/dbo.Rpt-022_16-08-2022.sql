SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*
CREATE BY		:	Baijayanti
CREATE DATE	    :	26-05-2021
DISCRIPTION		:   SMA Movement- Ac Level listing
*/

 create PROC [dbo].[Rpt-022_16-08-2022]  
  @UserName AS VARCHAR(20)
 ,@MisLocation AS VARCHAR(20)
 ,@CustFacility AS VARCHAR(10)
 ,@FromDate   AS VARCHAR(15)
 ,@ToDate     AS VARCHAR(15)
 ,@Cost   AS FLOAT
 ,@MovementStatus   AS VARCHAR(MAX)

AS 

--DECLARE 
-- @UserName AS VARCHAR(20)='D2K'	
--,@MisLocation AS VARCHAR(20)=''
--,@CustFacility AS VARCHAR(10)=3
--,@FromDate   AS VARCHAR(15)='30/09/2020'
--,@ToDate     AS VARCHAR(15)='21/11/2086'
--,@Cost   AS FLOAT=1
--,@MovementStatus   AS VARCHAR(MAX)='1,2,3,4,5,6,7,8,9,10'


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

DECLARE	@From1		DATE=(SELECT Rdate FROM dbo.DateConvert(@FromDate))
DECLARE @To1		DATE=(SELECT Rdate FROM dbo.DateConvert(@ToDate))


SELECT  
DB.BranchCode,
AMH.CustomerACID,
CustomerID,
CustomerName, 
MovementToStatus,
CONVERT(VARCHAR(20),MovementToDate,103)            AS MovementToDate,
ProductCode,
SUM(ISNULL(TotOsAcc,0))/@Cost                      AS TotOsAcc,
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

WHERE @From1=MovementFromDate  AND @To1=MovementToDate   
      AND (CASE WHEN MovementFromStatus='STD' AND  MovementToStatus='SMA_0'
                THEN 1
                WHEN MovementFromStatus='SMA_0' AND  MovementToStatus='STD'
	            THEN 2
                WHEN MovementFromStatus='SMA_0' AND  MovementToStatus='SMA_1'
	            THEN 3
                WHEN MovementFromStatus='SMA_1' AND  MovementToStatus='STD'
	            THEN 4
                WHEN MovementFromStatus='SMA_1' AND  MovementToStatus='SMA_0'
	            THEN 5
                WHEN MovementFromStatus='SMA_1' AND  MovementToStatus='SMA_2'
	            THEN 6
                WHEN MovementFromStatus='SMA_2' AND  MovementToStatus='SMA_1'
	            THEN 7
                WHEN MovementFromStatus='SMA_2' AND  MovementToStatus='SMA_0'
	            THEN 8
                WHEN MovementFromStatus='SMA_2' AND  MovementToStatus='STD'
	            THEN 9
                WHEN MovementFromStatus='SMA_2' AND  MovementToStatus IN('SUB','DB1','DB2','DB3','LOS')
	            THEN 10
	            END)   IN (SELECT * FROM[Split](@MovementStatus,','))  
				
GROUP BY
DB.BranchCode,
AMH.CustomerACID,
CustomerID,
CustomerName, 
MovementToStatus,	
MovementToDate,
ProductCode,
AssetClassShortNameEnum
			   

OPTION(RECOMPILE)






GO
