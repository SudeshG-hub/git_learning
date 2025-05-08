SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*==============================================
 AUTHER : TRILOKI SHANKER KHANNA
 CREATE DATE : 22-02-2021
 MODIFY DATE : 22-02-2021
 DESCRIPTION : INSERT DATA PRO.ContinousExcessSecDtAccountCalLogic
 EXEC PRO.ContinousExcessSecDtAccountCalLogic

 ================================================*/

CREATE PROCEDURE [PRO].[ContinousExcessSecDtAccountCalLogic]
AS
BEGIN

DECLARE  @vEffectivefrom  Int SET @vEffectiveFrom=(SELECT TimeKey FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')
DECLARE @TimeKey  Int SET @TimeKey=(SELECT TimeKey FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')
DECLARE @DATE AS DATE =(SELECT Date FROM [dbo].Automate_Advances WHERE EXT_FLG='Y')


IF OBJECT_ID('TEMPDB..#ContinousExcessSecDtAccountCal') IS NOT NULL
   DROP TABLE #ContinousExcessSecDtAccountCal


   SELECT CustomerAcID INTO #ContinousExcessSecDtAccountCal FROM PRO.AccountCal A
		 INNER JOIN (
		    SELECT C.AccountEntityID,SUM(isnull(CurrentValue,0)) CurrentValue
            FROM CURDAT.AdvSecurityVAlueDetail B
			INNER  JOIN CURDAT.AdvSecurityDetail Advsec on Advsec.SecurityEntityID=b.SecurityEntityID
			 INNER JOIN PRO.AccountCal C ON Advsec.AccountEntityID=C.AccountEntityID  
			  AND Advsec.SecurityAlt_Key = Advsec.SecurityAlt_Key
                			             AND  Advsec.EffectiveFromTimeKey < = @TimeKey
                                        AND Advsec.EffectiveToTimeKey   >= @TimeKey
			INNER JOIN DimSecurity D ON D.EffectiveFromTimeKey<=@TIMEKEY
													AND D.EffectiveToTimeKey>=@TIMEKEY
													AND D.SecurityAlt_Key=Advsec.SecurityAlt_Key 
			WHERE  Advsec.SecurityType='P'	
				AND D.SecurityCRM='Y'
			
								 	    
			GROUP BY C.AccountEntityID
			 ) E  ON A.AccountEntityID=E.AccountEntityID
			 and 	ISNULL(A.Balance,0)>0
			 and ISNULL(A.Balance,0)>ISNULL(A.SecurityValue,0) 
	EXCEPT
   SELECT CustomerAcID FROM Pro.ContinousExcessSecDtAccountCal where Effectivetotimekey=49999


 
   INSERT INTO Pro.ContinousExcessSecDtAccountCal
   (
	     CustomerAcID
		,AccountEntityId
		,Balance
		,SecurityValue
		,ContinousExcessSecDt
		,EffectiveFromTimeKey
		,EffectiveToTimeKey
   )

SELECT 

 B.CustomerAcID AS CustomerAcID
,B.AccountEntityId AS AccountEntityId
,B.Balance AS Balance
,B.SecurityValue AS SecurityValue
,@DATE AS ContinousExcessSecDt
,@TimeKey AS EffectiveFromTimeKey
,49999 AS  EffectiveToTimeKey
FROM #ContinousExcessSecDtAccountCal A INNER JOIN
 PRO.AccountCal B ON A.CustomerACID=B.CustomerACID




 IF OBJECT_ID('TEMPDB..#ContinousExcessSecDtAccountCalEXP') IS NOT NULL
   DROP TABLE #ContinousExcessSecDtAccountCalEXP


   SELECT CustomerAcID INTO #ContinousExcessSecDtAccountCalEXP  FROM PRO.AccountCal A
		 INNER JOIN (
		    SELECT C.AccountEntityID,SUM(isnull(CurrentValue,0)) CurrentValue
            FROM CURDAT.AdvSecurityVAlueDetail B
			INNER  JOIN CURDAT.AdvSecurityDetail Advsec on Advsec.SecurityEntityID=b.SecurityEntityID
			 INNER JOIN PRO.AccountCal C ON Advsec.AccountEntityID=C.AccountEntityID  
			  AND Advsec.SecurityAlt_Key = Advsec.SecurityAlt_Key
                			             AND  Advsec.EffectiveFromTimeKey < = @TimeKey
                                        AND Advsec.EffectiveToTimeKey   >= @TimeKey
			INNER JOIN DimSecurity D ON D.EffectiveFromTimeKey<=@TIMEKEY
													AND D.EffectiveToTimeKey>=@TIMEKEY
													AND D.SecurityAlt_Key=Advsec.SecurityAlt_Key 
			WHERE  Advsec.SecurityType='P'	
					AND D.SecurityCRM='Y'
			
								 	    
			GROUP BY C.AccountEntityID
			 ) E  ON A.AccountEntityID=E.AccountEntityID
			 and 	ISNULL(A.Balance,0)>0
			 and ISNULL(A.Balance,0)>ISNULL(A.SecurityValue,0) 


/*------EXPIRE DATA FOR ---------------------*/

UPDATE A SET A.EffectiveToTimekey=@TimeKey-1
FROM Pro.ContinousExcessSecDtAccountCal A LEFT OUTER JOIN  
(
select   A.CustomerAcID  from Pro.ContinousExcessSecDtAccountCal a inner join #ContinousExcessSecDtAccountCalEXP b
 on a.CustomerAcID=b.CustomerAcID 
) C 
ON A.CustomerAcID=C.CustomerAcID
WHERE C.CustomerAcID IS NULL AND A.EffectiveToTimekey=49999

 DROP TABLE #ContinousExcessSecDtAccountCal
 DROP TABLE #ContinousExcessSecDtAccountCalEXP
	
	
END












GO
