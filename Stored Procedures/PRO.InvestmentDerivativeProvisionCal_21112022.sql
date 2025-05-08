SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




----/*=========================================
---- AUTHER : TRILOKI KHANNA
---- CREATE DATE : 27-11-2019
---- MODIFY DATE : 27-11-2019
---- DESCRIPTION : UPDATE InvestmentDataProcessing
---- --EXEC [PRO].[InvestmentDataProcessing] @TIMEKEY=26351
----=============================================*/


CREATE PROCEDURE [PRO].[InvestmentDerivativeProvisionCal_21112022]
@TIMEKEY INT
WITH RECOMPILE
/*=========================================
-- AUTHOR : TRILOKI KHANNA
-- CREATE DATE : 09-04-2021
-- MODIFY DATE : 07-07-2022
-- DESCRIPTION : Test Case Cover in This SP

--=============================================*/
AS
BEGIN
  SET NOCOUNT ON
   BEGIN TRY
   ---GIT testing ----
--DECLARE @TIMEKEY INT=@TimeKey


----/*----------------PROVISION ALT KEY ALL  ACCOUNTS--------------------------------*/
/*  INVESTMENT  */

		UPDATE A SET PROVISIONALT_KEY=0
		from InvestmentFinancialDetail  A
		where  (A.EffectiveFromTimeKey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey)

		UPDATE A SET A.ProvisionAlt_Key=D.ProvisionAlt_Key
		FROM InvestmentFinancialDetail A 
		INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FinalAssetClassAlt_Key,1) 
			 AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
			 INNER JOIN DimProvision_Seg d
				ON D.EffectiveFromTimeKey <=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY
				AND c.AssetClassShortName=d.PROVISIONSHORTNAMEENUM
			WHERE  C.ASSETCLASSGROUP='NPA'  AND
			 (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)
			  and d.SEGMENT='IRAC'


			 UPDATE A 
				SET TotalProvison =(CASE WHEN ISNULL(B.ASSETCLASSSHORTNAMEENUM,'STD')='LOS' 
												THEN BookValueINR
										ELSE (ISNULL(A.BookValueINR,0) * ISNULL(C.PROVISIONUNSECURED,0)/100 )  
										 END)

				FROM InvestmentFinancialDetail A  
				INNER JOIN DIMASSETCLASS B ON B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
											AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY      
											AND ISNULL(A.FinalAssetClassAlt_Key,1) =B.ASSETCLASSALT_KEY 
				INNER JOIN DIMPROVISION_SEG C ON C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
										  AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY      
										  AND ISNULL(A.PROVISIONALT_KEY,1) = C.PROVISIONALT_KEY 

				WHERE  FinalAssetClassAlt_Key>1 AND A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY  
 


			 /* STD PROVISION ALTKEY */
			UPDATE A SET A.ProvisionAlt_Key=D.ProvisionAlt_Key
			FROM   InvestmentFinancialDetail A 
			INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FinalAssetClassAlt_Key,1) 
				 AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
				 INNER JOIN DimProvision_SegSTD d
					ON D.EffectiveFromTimeKey <=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY
					  and d.ProvisionName='Other Portfolio' 
			WHERE  C.ASSETCLASSGROUP='STD'  AND
			 (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)


			/* STD PROVISION Amount */
			 UPDATE A 
				SET TotalProvison =(CASE WHEN ISNULL(B.ASSETCLASSSHORTNAMEENUM,'STD')='LOS' 
												THEN BookValueINR
										ELSE (ISNULL(A.BookValueINR,0) * ISNULL(C.PROVISIONUNSECURED,0)/100 )  
										 END)

				FROM  InvestmentFinancialDetail A  
				INNER JOIN DIMASSETCLASS B ON B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
											AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY      
											AND ISNULL(A.FinalAssetClassAlt_Key,1) =B.ASSETCLASSALT_KEY 
				INNER JOIN DimProvision_SegStd C ON C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
										  AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY      
										  AND ISNULL(A.PROVISIONALT_KEY,1) = C.PROVISIONALT_KEY 
				WHERE  FinalAssetClassAlt_Key=1 AND A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY  

			 OPTION(RECOMPILE)
 
----/*----------------PROVISION ALT KEY ALL  ACCOUNTS--------------------------------*/
/* DERIVATIVE */
		UPDATE A SET PROVISIONALT_KEY=0
		FROM   [CurDat].[DerivativeDetail]  A
		where  (A.EffectiveFromTimeKey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey)


		/* NPA PROVISION ALTKEY */
		UPDATE A SET A.ProvisionAlt_Key=D.ProvisionAlt_Key
			FROM   [CurDat].[DerivativeDetail] A 
		INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FinalAssetClassAlt_Key,1) 
			 AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
			 INNER JOIN DimProvision_Seg d
				ON D.EffectiveFromTimeKey <=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY
				AND c.AssetClassShortName=d.PROVISIONSHORTNAMEENUM
		WHERE  C.ASSETCLASSGROUP='NPA'  AND
		 (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)
		  and d.SEGMENT='IRAC'



		/* NPA PROVISION maount */
		 UPDATE A 
			SET TotalProvison =(CASE WHEN ISNULL(B.ASSETCLASSSHORTNAMEENUM,'STD')='LOS' 
											THEN POS
									ELSE (ISNULL((CASE WHEN A.MTMIncomeAmt < 0 THEN 0 ELSE A.MTMIncomeAmt END),0) * ISNULL(C.PROVISIONUNSECURED,0)/100 )  
									 END)

			FROM   [CurDat].[DerivativeDetail] A  
			INNER JOIN DIMASSETCLASS B ON B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
										AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY      
										AND ISNULL(A.FinalAssetClassAlt_Key,1) =B.ASSETCLASSALT_KEY 
			INNER JOIN DIMPROVISION_SEG C ON C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
									  AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY      
									  AND ISNULL(A.PROVISIONALT_KEY,1) = C.PROVISIONALT_KEY 

			WHERE  FinalAssetClassAlt_Key>1 AND A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY  
 

		 /* STD PROVISION ALTKEY */
		UPDATE A SET A.ProvisionAlt_Key=D.ProvisionAlt_Key
			FROM   [CurDat].[DerivativeDetail] A 
		INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=isnull(A.FinalAssetClassAlt_Key,1) 
			 AND (C.EffectiveFromTimeKey<=@TIMEKEY AND C.EffectiveToTimeKey>=@TIMEKEY)
			 INNER JOIN DimProvision_SegSTD d
				ON D.EffectiveFromTimeKey <=@TIMEKEY AND D.EffectiveToTimeKey>=@TIMEKEY
				  and d.ProvisionName='Other Portfolio' 
		WHERE  C.ASSETCLASSGROUP='STD'  AND
		 (A.EffectiveFromTimeKey<=@TIMEKEY AND A.EffectiveToTimeKey>=@TIMEKEY)



		/* STD PROVISION maount */
		 UPDATE A 
			SET TotalProvison =(CASE WHEN ISNULL(B.ASSETCLASSSHORTNAMEENUM,'STD')='LOS' 
											THEN POS
									ELSE (ISNULL((CASE WHEN A.MTMIncomeAmt < 0 THEN 0 ELSE A.MTMIncomeAmt END),0) * ISNULL(C.PROVISIONUNSECURED,0)/100 )  
									 END)

			FROM   [CurDat].[DerivativeDetail] A  
			INNER JOIN DIMASSETCLASS B ON B.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
										AND B.EFFECTIVETOTIMEKEY>=@TIMEKEY      
										AND ISNULL(A.FinalAssetClassAlt_Key,1) =B.ASSETCLASSALT_KEY 
			INNER JOIN DimProvision_SegStd C ON C.EFFECTIVEFROMTIMEKEY<=@TIMEKEY
									  AND C.EFFECTIVETOTIMEKEY>=@TIMEKEY      
									  AND ISNULL(A.PROVISIONALT_KEY,1) = C.PROVISIONALT_KEY 
			WHERE  FinalAssetClassAlt_Key=1 AND A.EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND A.EFFECTIVETOTIMEKEY>=@TIMEKEY  
 
		OPTION(RECOMPILE)


		UPDATE [CurDat].[DerivativeDetail] SET TotalProvison=0
		WHERE TotalProvison<0 AND EFFECTIVEFROMTIMEKEY<=@TIMEKEY    AND EFFECTIVETOTIMEKEY>=@TIMEKEY 

		--UPDATE [CurDat].[DerivativeDetail] SET TotalProvison=0
		--WHERE EFFECTIVEFROMTIMEKEY<=@TIMEKEY    AND EFFECTIVETOTIMEKEY>=@TIMEKEY AND DEGREASON LIKE '%PERCOLATION%' 
			
		UPDATE InvestmentFinancialDetail set TotalProvison=0
		where Asset_Norm='ALWYS_STD' and EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND EFFECTIVETOTIMEKEY>=@TIMEKEY 
		
		
		UPDATE InvestmentFinancialDetail set TotalProvison=0
		where FinalAssetClassAlt_Key = 1  and EFFECTIVEFROMTIMEKEY<=@TIMEKEY     AND EFFECTIVETOTIMEKEY>=@TIMEKEY   

	--------------Added for DashBoard 04-03-2021
	Update BANDAUDITSTATUS set CompletedCount=CompletedCount+1 where BandName='ASSET CLASSIFICATION'

	
END TRY
BEGIN  CATCH

	UPDATE PRO.ACLRUNNINGPROCESSSTATUS 
	SET COMPLETED='N',ERRORDATE=GETDATE(),ERRORDESCRIPTION=ERROR_MESSAGE(),COUNT=ISNULL(COUNT,0)+1
	WHERE RUNNINGPROCESSNAME='InvestmentDataProcessing'
END CATCH


SET NOCOUNT OFF
END



















GO
