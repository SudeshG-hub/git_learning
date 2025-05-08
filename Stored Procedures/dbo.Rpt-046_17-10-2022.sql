SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[Rpt-046_17-10-2022] 
   @TimeKey   AS INT
AS

--DECLARE 
--   @TimeKey   AS INT=26479


DECLARE @CurDate AS DATE=(SELECT DATE FROM SysDayMatrix WHERE TimeKey=@TimeKey)

SELECT 
       [UCIC_ID]
      ,RPPD.[CustomerID]
      ,[CustomerName]
	  ,[PAN_No]
      ,DBRP.BankName
      ,BA.ArrangementDescription
      ,BRP.BankName                                              AS LeadBank
	  ,CASE WHEN DefaultStatus='in defualt'
	        THEN CONVERT(VARCHAR(20),InDefaultDate,103)
			WHEN DefaultStatus='Out-Defualt'
			THEN CONVERT(VARCHAR(20),OutOfDefaultDate,103)
			END                                                  AS DefaultDate
	  ,DefaultStatus                                             AS [RP_Status]
      ,EB.BucketName                                             AS Bucketvalue
	  ,CONVERT(VARCHAR(20),ReferenceDate,103)                    AS [ReferenceDate]
      ,CONVERT(VARCHAR(20),ReviewExpiryDate,103)                 AS [ReviewExpiryDate]

      ,CONVERT(VARCHAR(20),RP_ApprovalDate,103)                  AS [RP_ApprovalDate]
      ,DPN.ParameterName                                         AS [RP_Nature]
	  ,''                                                        AS [AdviseNatureofRP]

      ,CASE WHEN DATEDIFF(DD,ReviewExpiryDate,@CurDate)<0
	        THEN ''
			ELSE DATEDIFF(DD,ReviewExpiryDate,@CurDate)
			END                                                  AS [DaysPassedReviewPeriodDate]
      ,CONVERT(VARCHAR(20),RPPD.RP_ExpiryDate,103)               AS [ResolutionPlanImplementationDate]
      ,DPI.ParameterName                                         AS [ImplStatus]
      ,CONVERT(VARCHAR(20),Actual_Impl_Date,103)                 AS [Actual_Impl_Date]
      ,CASE WHEN DATEDIFF(DD,RPPD.RP_ExpiryDate,@CurDate)<0
	        THEN ''
			ELSE DATEDIFF(DD,RPPD.RP_ExpiryDate,@CurDate)
			END                                                  AS [DaysPassedResolutionImplementationDate]
	  ,CONVERT(VARCHAR(20),RP_OutOfDateAllBanksDeadline,103)     AS [OutOfDefaultDate]
      ,CONVERT(VARCHAR(20),Revised_RP_Expiry_Date,103)           AS [Revised_RP_Expiry_Date]
      ,CONVERT(VARCHAR(20),RiskReviewExpiryDate,103)             AS [RiskReviewExpiryDate]
	  ,''                                                        AS [WhetherYesBankExposure_Y_N]
	  ,''                                                        AS [Asset Classification]
	  ,''                                                        AS Segment
	  ,''                                                        AS RM
	  ,''                                                        AS TL


  FROM RP_Portfolio_Details RPPD
  INNER JOIN RP_Lender_Details RPLD                ON RPPD.CustomerID=RPLD.CustomerID
                                                      AND RPPD.EffectiveFromTimeKey<=@TimeKey 
												      AND RPPD.EffectiveToTimeKey>=@TimeKey
													  AND RPLD.EffectiveFromTimeKey<=@TimeKey 
												      AND RPLD.EffectiveToTimeKey>=@TimeKey

  LEFT JOIN DimExposureBucket EB                  ON RPPD.ExposureBucketAlt_Key=EB.ExposureBucketAlt_Key
                                                      AND EB.EffectiveFromTimeKey<=@TimeKey 
												      AND EB.EffectiveToTimeKey>=@TimeKey
											       
  LEFT JOIN DimBankingArrangement BA              ON BA.BankingArrangementAlt_Key=RPPD.BankingArrangementAlt_Key
                                                      AND BA.EffectiveFromTimeKey<=@TimeKey 
												      AND BA.EffectiveToTimeKey>=@TimeKey
											       													  
  LEFT JOIN DimParameter  DPN	                  ON RPPD.RPNatureAlt_Key=DPN.ParameterAlt_Key
                                                      AND DPN.EffectiveFromTimeKey<=@TimeKey 
												      AND DPN.EffectiveToTimeKey>=@TimeKey
												      AND DPN.DimParameterName='DimNatureResolutionPlan'  
													  
													  												   
  LEFT JOIN DimParameter DPI                      ON RPPD.RP_ImplStatusAlt_Key=DPI.ParameterAlt_Key
                                                      AND DPI.EffectiveFromTimeKey<=@TimeKey 
												      AND DPI.EffectiveToTimeKey>=@TimeKey
													  AND DPI.DimParameterName='ImplementationStatus'
													  											       
  LEFT JOIN DimBankRP BRP                         ON BRP.BankRPAlt_Key=RPPD.LeadBankAlt_Key
                                                      AND BRP.EffectiveFromTimeKey<=@TimeKey 
												      AND BRP.EffectiveToTimeKey>=@TimeKey

  LEFT JOIN DimBankRP DBRP                         ON DBRP.BankRPAlt_Key=RPLD.ReportingLenderAlt_Key
                                                      AND DBRP.EffectiveFromTimeKey<=@TimeKey 
												      AND DBRP.EffectiveToTimeKey>=@TimeKey


ORDER BY RPPD.[CustomerID]

  OPTION(RECOMPILE)
GO
