SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [dbo].[Rpt-039-SCF_source]
	@TimeKey  INT,
	@SelectReport AS INT
	AS 


--DECLARE  @TimeKey AS INT=26471,
--         @SelectReport AS INT=3

DECLARE @ProcessDate DATE=(SELECT DATE FROM Sysdaymatrix WHERE Timekey=@TimeKey)
Declare @Prevquakey INT
set @Prevquakey=(Select LastFinYearKey from sysdaymatrix where Timekey=@TimeKey)

--------------------------------------------------------------------

Drop table if exists #main


Select *into #main from ( 
select distinct
CONVERT(VARCHAR(10),@ProcessDate,103)                                       AS CurrentProcessingDate
,H.SourceName
,A.UCIF_ID
,A.RefCustomerID as CustomerID
,A.BranchCode
,DB.BranchName
,A.CustomerAcID
,A.FacilityType
,D.SchemeType
,D.ProductCode                                                            AS Scheme_Code														  
,D.ProductName                                                            As Scheme_Description
,''  [BillNo]
,''  [BillDt]
,''  [BillAmt]
,''  [BillPurDt]
,''  [Bill_liability_amount]
,''  [BillDueDt]
,''  [BillExtendedDueDt]
,''  [Bill_DPD]
,''  [Limit_expiry_Dt]
,ISNULL(A.Balance,0)                                                       AS Balance_in_INR
,ISNULL(IntOverdue,0)                                                      AS Overdue_Interest
,''  [UnAppliedIntt]
,CONVERT(VARCHAR(20),A.IntOverdueSinceDt,103)                              AS Overdue_Interest_Date
,''  [BillProductCode]
,''  [NPA_Date]
,''  [Prev_Qtr_Balance_outstanding]
,''  [Prev_Qtr_Unsecured_Outstanding]

,CASE           WHEN A.SMA_Class='STD' THEN 'STANDARD'
	            WHEN A.SMA_Class='SMA_0' THEN 'SMA 0'
				WHEN A.SMA_Class='SMA_1' THEN 'SMA 1'
				WHEN A.SMA_Class='SMA_2' THEN 'SMA 2' 
				END As Asset_Classification

,''  [Balance_Outstanding]
,ISNULL(A.PrincOutStd,0)                                                   As Principal_Outstanding
, ISNULL(A.NetBalance,0)                                                   AS [Net Balance]
,ISNULL(A.UnSecuredAmt,0)                                                  AS Unsecured_Outstanding
,ISNULL(A.TotalProvision,0)                                                          As Total_provision 
,ISNULL(A.Provsecured,0)                                                             As Provision_Unsecured
,''  [Net_NPA]                                          
,(ISNULL(ProvUnSecured,0)/NULLIF(UnSecuredAmt,0))*100                      AS ProvPerUnSecured_Percent
,''   [Additional_Provision_percent]
,(ISNULL(TotalProvision,0)/NULLIF(NetBalance,0))*100                       AS Total_Provision_percent

, '' [Prev. Qtr. Balance outstanding]
, '' [Prev. Qtr. Unsecured Outstanding]
, '' [Prev. Qtr. Total Provision]
, '' [Prev. Qtr. Provision Unsecured]
, '' [Prev. Qtr. Net NPA]
, '' [NPA Increase]
, '' [NPA Decrease]
, '' [STD Provision Increase]
, '' [STD Provision Decrease]
, '' [NPA Provision Increase]
, '' [NPA Provision Decrease]
, '' [Net NPA Increase]
, '' [Net NPA Decrease]
,CASE WHEN FinalAssetClassAlt_key = 1 THEN 0 ELSE ISNULL(FIN.UnAppliedIntAmount,0)		END	 AS [InterestInSuspenseAmount]
,'' [Total income suspended ]
,'' [Actual Provision]
,'' [Shortfall in Provision Held vs Calculated Regulatory Provision]


,case WHEN ISNULL(FlgFraud,'N')='Y'   THEN 'Yes'  ELSE 'No'                 END As [Fraud Flag]

,ISNULL(A.CurrentLimit ,0)                                                  AS [Limit Sanction Amount in INR]                           


FROM Pro.AccountCal_Hist A

INNER JOIN Pro.CustomerCal_Hist F                 ON F.CustomerEntityId=A.CustomerEntityId 
                                                     AND F.EffectiveFromTimeKey<=@TimeKey  
												     AND F.EffectiveToTimeKey>=@TimeKey
													 AND A.EffectiveFromTimeKey<=@TimeKey  
													 AND A.EffectiveToTimeKey>=@TimeKey

LEFT JOIN AdvCustNPADetail ACND                   ON ACND.CustomerEntityId=A.CustomerEntityId 
                                                     AND ACND.EffectiveFromTimeKey<=@TimeKey  
												     AND ACND.EffectiveToTimeKey>=@TimeKey

LEFT JOIN AdvAcOtherFinancialDetail FIN           ON A.AccountEntityId = FIN.AccountEntityId
                                                      AND FIN.EffectiveFromTimeKey<=@TimeKey
									                  AND FIN.EffectiveToTimeKey>=@TimeKey

LEFT JOIN SaletoARCFinalACFlagging SARC           ON SARC.AccountId=A.CustomerAcID
                                                     AND SARC.EffectiveFromTimeKey<=@TimeKey
									                 AND SARC.EffectiveToTimeKey>=@TimeKey

LEFT JOIN RP_Portfolio_Details  RPD               ON RPD.CustomerId=A.RefCustomerID
                                                      AND RPD.EffectiveFromTimeKey<=@TimeKey
									                  AND RPD.EffectiveToTimeKey>=@TimeKey 

LEFT JOIN DimAssetClass  DAC                      ON DAC.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                     AND DAC.EffectiveFromTimeKey<=@TimeKey  
													 AND DAC.EffectiveToTimeKey>=@TimeKey

INNER JOIN DIMSOURCEDB H                          ON H.SourceAlt_Key=A.SourceAlt_Key   
                                                     AND H.EffectiveFromTimeKey<=@TimeKey  
													 AND H.EffectiveToTimeKey>=@TimeKey


LEFT JOIN	DimProduct D                          ON A.ProductAlt_Key=D.ProductAlt_Key 
                                                     AND D.EffectiveFromTimeKey<=@TimeKey  
													 AND D.EffectiveToTimeKey>=@TimeKey

LEFT JOIN	DimBranch DB                          ON A.BranchCode=DB.BranchCode 
                                                     AND DB.EffectiveFromTimeKey<=@TimeKey  
													 AND DB.EffectiveToTimeKey>=@TimeKey

LEFT JOIN	  DimAssetClassMapping C         ON C.AssetClassAlt_Key=A.FinalAssetClassAlt_Key 
                                                      AND C.SourceAlt_Key=D.SourceAlt_Key
                                                      AND C.EffectiveFromTimeKey<=@TimeKey  
													  AND C.EffectiveToTimeKey>=@TimeKey 

											where 		  FinalAssetClassAlt_Key>1  AND A.SourceAlt_Key=3 and  @SelectReport =3
											
										
)A order by CustomerID



Select * from #main
GO
