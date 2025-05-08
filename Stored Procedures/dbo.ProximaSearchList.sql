SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--USE [ENBD_MISDB]
--GO
--/****** Object:  StoredProcedure [dbo].[ProximaSearchList]    Script Date: 11-03-2024 16:26:53 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO



   CREATE PROC [dbo].[ProximaSearchList]  
--Declare      
                @AccountID            Varchar (100)  = ''  
               ,@OperationFlag        INT            = 2  
            --  ,@ProcessDate    date=
                                                                          
AS  
       
       BEGIN  
  
SET NOCOUNT ON;  
Declare @TimeKey as Int  
      SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')  
	  DECLARE @ProcessDate DATE=(SELECT DATE FROM SysDayMatrix WHERE Timekey=@TimeKey)

      --set @ISIN =case when @ISIN IS NULL THEN '' Else @ISIN END                       
SET DATEFORMAT DMY  
BEGIN TRY  
  
  ---------------------------======================================DPD CalCULATION  Start===========================================

 IF OBJECT_ID('TempDB..#DPD') Is Not Null
Drop Table #DPD


SELECT            A.CustomerAcID
                 ,A.AccountEntityID
                 ,A.IntNotServicedDt
                 ,A.LastCrDate
                 ,A.ContiExcessDt
                 ,A.OverDueSinceDt
                 ,A.ReviewDueDt
                 ,A.StockStDt
                 ,A.DebitSinceDt
                 ,A.PrincOverdueSinceDt
                 ,A.IntOverdueSinceDt
                 ,A.OtherOverdueSinceDt
                 ,A.SourceAlt_Key
				 ,PenalInterestOverDueSinceDt
INTO #DPD
 FROM pro.AccountCal_Hist A
LEFT JOIN  AdvAcOtherFinancialDetail FIN    ON A.AccountEntityId = FIN.AccountEntityId
                                               AND FIN.EffectiveFromTimeKey<=@TimeKey
									           AND FIN.EffectiveToTimeKey>=@TimeKey

WHERE A.EffectiveFromTimeKey <= @Timekey and A.EffectiveToTimeKey >= @Timekey

OPTION(RECOMPILE)
---------------
Alter Table #DPD
Add        DPD_IntService Int
          ,DPD_NoCredit Int
          ,DPD_Overdrawn Int
          ,DPD_Overdue Int
          ,DPD_Renewal Int
          ,DPD_StockStmt Int
          ,DPD_PrincOverdue Int
          ,DPD_IntOverdueSince Int
          ,DPD_OtherOverdueSince Int
          ,DPD_Max Int
		  ,DPD_PenalInterestOverdue INT

-------------------

UPDATE A SET  A.DPD_IntService = (CASE WHEN  A.IntNotServicedDt IS NOT NULL THEN DATEDIFF(DAY,A.IntNotServicedDt,@ProcessDate)+1  ELSE 0 END)                          
             ,A.DPD_NoCredit = CASE WHEN (DebitSinceDt IS NULL OR DATEDIFF(DAY,DebitSinceDt,@ProcessDate)>=90)
                                                                                        THEN (CASE WHEN  A.LastCrDate IS NOT NULL
                                                                                        THEN DATEDIFF(DAY,A.LastCrDate,  @ProcessDate)+0
                                                                                        ELSE 0  
                                                                                        END)
                                                                                        ELSE 0 
																						END

                         ,A.DPD_Overdrawn= (CASE WHEN   A.ContiExcessDt IS NOT NULL    THEN DATEDIFF(DAY,A.ContiExcessDt,  @ProcessDate) + 1    ELSE 0 END)
                         ,A.DPD_Overdue =   (CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OverDueSinceDt,  @ProcessDate)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
                         ,A.DPD_Renewal =   (CASE WHEN  A.ReviewDueDt IS NOT NULL      THEN DATEDIFF(DAY,A.ReviewDueDt, @ProcessDate)  +1    ELSE 0 END)
                         ,A.DPD_StockStmt= (CASE WHEN  A.StockStDt IS NOT NULL THEN   DateDiff(Day,DATEADD(month,3,A.StockStDt),@ProcessDate)+1 ELSE 0 END)
                         ,A.DPD_PrincOverdue = (CASE WHEN  A.PrincOverdueSinceDt IS NOT NULL THEN DATEDIFF(DAY,A.PrincOverdueSinceDt,@ProcessDate)+1  ELSE 0 END)                          
                         ,A.DPD_IntOverdueSince =  (CASE WHEN  A.IntOverdueSinceDt IS NOT NULL      THEN DATEDIFF(DAY,A.IntOverdueSinceDt,  @ProcessDate)+1       ELSE 0 END)
                         ,A.DPD_OtherOverdueSince =   (CASE WHEN  A.OtherOverdueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.OtherOverdueSinceDt,  @ProcessDate)+1  ELSE 0 END)
						 ,A.DPD_PenalInterestOverdue=(CASE WHEN  A.OverDueSinceDt IS NOT NULL   THEN  DATEDIFF(DAY,A.PenalInterestOverDueSinceDt,  @ProcessDate)+(CASE WHEN SourceAlt_Key=6 THEN 0 ELSE 1 END )  ELSE 0 END)
FROM #DPD A


OPTION(RECOMPILE)

----New Condition Added By Report Team  02/08/2022 for 1 Augesut greter or equal ---

IF @TimeKey>=@TimeKey
BEGIN
UPDATE #DPD SET 
#DPD.DPD_IntService=0,
#DPD.DPD_NoCredit=0,
#DPD.DPD_Overdrawn=0,
#DPD.DPD_Overdue=0,
#DPD.DPD_Renewal=0,
#DPD.DPD_StockStmt=0,
#DPD.DPD_PrincOverdue=0,
#DPD.DPD_IntOverdueSince=0,
#DPD.DPD_OtherOverdueSince=0
FROM  Pro.ACCOUNTCAL_hist A
INNER JOIN AdvAcBalanceDetail C      ON A.AccountEntityId=C.AccountEntityId
INNER JOIN #DPD  DPD                 ON DPD.AccountEntityID=A.AccountEntityID
INNER JOIN DimProduct B              ON A.ProductCode=B.ProductCode 


WHERE ISNULL(A.Balance,0)=0 AND ISNULL(C.SignBalance,0)>=0
      AND B.EffectiveFromTimeKey <= @Timekey AND B.EffectiveToTimeKey >= @Timekey 
      AND C.EffectiveFromTimeKey <= @Timekey AND C.EffectiveToTimeKey >= @Timekey
      AND A.EffectiveFromTimeKey <= @Timekey AND A.EffectiveToTimeKey >= @Timekey
      AND A.DebitSinceDt IS NULL

OPTION(RECOMPILE)

END
------------------------------

 UPDATE #DPD SET DPD_IntService=0 WHERE isnull(DPD_IntService,0)<0
 UPDATE #DPD SET DPD_NoCredit=0 WHERE isnull(DPD_NoCredit,0)<0
 UPDATE #DPD SET DPD_Overdrawn=0 WHERE isnull(DPD_Overdrawn,0)<0
 UPDATE #DPD SET DPD_Overdue=0 WHERE isnull(DPD_Overdue,0)<0
 UPDATE #DPD SET DPD_Renewal=0 WHERE isnull(DPD_Renewal,0)<0
 UPDATE #DPD SET DPD_StockStmt=0 WHERE isnull(DPD_StockStmt,0)<0
 UPDATE #DPD SET DPD_PrincOverdue=0 WHERE isnull(DPD_PrincOverdue,0)<0
 UPDATE #DPD SET DPD_IntOverdueSince=0 WHERE isnull(DPD_IntOverdueSince,0)<0
 UPDATE #DPD SET DPD_OtherOverdueSince=0 WHERE isnull(DPD_OtherOverdueSince,0)<0
 UPDATE #DPD SET DPD_PenalInterestOverdue=0 WHERE isnull(DPD_PenalInterestOverdue,0)<0

UPDATE A SET A.DPD_Max=0  FROM #Dpd  A
UPDATE   A SET A.DPD_Max= (CASE    WHEN (isnull(A.DPD_IntService,0)>=isnull(A.DPD_NoCredit,0)
                                        AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdrawn,0)
                                                                                AND    isnull(A.DPD_IntService,0)>=isnull(A.DPD_Overdue,0)
                                                                                AND  isnull(A.DPD_IntService,0)>=isnull(A.DPD_Renewal,0)
                                                                                AND isnull(A.DPD_IntService,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN isnull(A.DPD_IntService,0)
                                   WHEN (isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_IntService,0)
                                                                        AND isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Overdrawn,0)
                                                                        AND    isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_Overdue,0)
                                                                        AND    isnull(A.DPD_NoCredit,0)>=  isnull(A.DPD_Renewal,0)
                                                                        AND isnull(A.DPD_NoCredit,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN   isnull(A.DPD_NoCredit ,0)
                                                                   WHEN (isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_NoCredit,0)  
                                                                        AND isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_IntService,0)  
                                                                                AND  isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_Overdue,0)
                                                                                AND   isnull(A.DPD_Overdrawn,0)>= isnull(A.DPD_Renewal,0)
                                                                                AND isnull(A.DPD_Overdrawn,0)>=isnull(A.DPD_StockStmt,0))
                                                                   THEN  isnull(A.DPD_Overdrawn,0)
                                                                   WHEN (isnull(A.DPD_Renewal,0)>=isnull(A.DPD_NoCredit,0)    
                                                                        AND isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_IntService,0)  
                                                                                AND  isnull(A.DPD_Renewal,0)>=isnull(A.DPD_Overdrawn,0)  
                                                                                AND  isnull(A.DPD_Renewal,0)>=   isnull(A.DPD_Overdue,0)  
                                                                                AND isnull(A.DPD_Renewal,0) >=isnull(A.DPD_StockStmt ,0))
                                                                   THEN isnull(A.DPD_Renewal,0)
                                       WHEN (isnull(A.DPD_Overdue,0)>=isnull(A.DPD_NoCredit,0)    
                                                                        AND isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_IntService,0)
                                                                            AND  isnull(A.DPD_Overdue,0)>=isnull(A.DPD_Overdrawn,0)  
                                                                                AND  isnull(A.DPD_Overdue,0)>=   isnull(A.DPD_Renewal,0)  
                                                                                AND isnull(A.DPD_Overdue ,0)>=isnull(A.DPD_StockStmt ,0))  
                                                                   THEN   isnull(A.DPD_Overdue,0)
                                                                   ELSE isnull(A.DPD_StockStmt,0)
                                                END)
                         
FROM  #DPD a

WHERE  (isnull(A.DPD_IntService,0)>0   OR isnull(A.DPD_Overdrawn,0)>0   OR  Isnull(A.DPD_Overdue,0)>0        
       OR isnull(A.DPD_Renewal,0) >0 OR isnull(A.DPD_StockStmt,0)>0 OR isnull(DPD_NoCredit,0)>0)


/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */  
 -- 	Select * From #temp
  
                  IF(@OperationFlag not in (16,17,20))  
             BEGIN  
                   IF OBJECT_ID('TempDB..#temp') IS NOT NULL  
               DROP TABLE  TempDB..#temp;  
                 SELECT     
				              -- A.EntityKey
							  AccountID 
                              ,UCICID  
                              ,CustomerID  
                              ,AccountOpenDate
							  ,LimitSanctionAmountinINR
                              ,BillLiabilityAmount 
							  ,SchemeProductCode 
							  ,SchemeType 
                              ,ACSegmentCode 
							  ,FacilityType
							  ,BillProductCode
							  ,BillNo 
							  ,BillAmount
							  ,BillDate
							  ,BillPurchaseDate
							  ,BillDueDate
							  ,BillExtendedDueDate
							  ,UnAppliedInterest 
                              ,BOS 
							  ,POS 
							  ,ProvisionAmount 
							  ,PrincipleAmount 
							  ,PrincipleOverdueAmount 
							  ,PrincipleOverdueSinceDate
							  ,InterestOverdueAmount 
							  ,InterestOverdueSinceDate
							  ,OtherOverdue 
							  ,NPADate
							  ,NPAReason 
							  ,FirstDateofDisbursement
							  ,AssetClassNorm 
							  ,SMADate 
							  ,SMAReason
							  ,SMAStatus 
							  ,SubAssetClassCode
							  ,FraudCommited
							  ,FraudDate
							  ,RFAFlag 
							  ,RFADate
							  ,TotalOverdue
							  ,MaxDPD
                 INTO #temp  
                 FROM  
                 (  
                     SELECT  
                             --  A.EntityKey
							  A.CustomerACID as AccountID
                              ,A.UCIF_ID  As UCICID
                              ,Y.RefCustomerID  As CustomerID
                              ,CONVERT (VARCHAR (10),A.AcOpenDt,103) AS AccountOpenDate 
							  ,A.CurrentLimit as LimitSanctionAmountinINR
                              ,A.Liability as BillLiabilityAmount
							  ,Z.ProductName AS SchemeProductCode
							  ,Z.SchemeType As SchemeType
                              ,A.ActSegmentCode as ACSegmentCode
							  ,A.FacilityType 
							 ,A.ProductCode AS BillProductCode
							  ,AFB.BillNo 
							  ,AFB.BillAmt as BillAmount
                              ,convert(varchar(10),AFB.BillDt,103) as BillDate
							  ,convert (varchar(10),AFB.BillPurDt,103) as BillPurchaseDate
							  ,convert (varchar(10),AFB.BillDueDt,103) as BillDueDate
							  ,convert (varchar (10),AFB.BillExtendedDueDt,103) as BillExtendedDueDate
							  ,x.UnAppliedIntAmount as UnAppliedInterest
                              ,X.Balance as BOS
							  ,x.PrincipalBalance as POS
							  ,x.TotalProv as ProvisionAmount
							  ,x.PrincipalBalance as PrincipleAmount
							  ,x.OverduePrincipal as PrincipleOverdueAmount
							  ,convert (varchar (10),x.OverduePrincipalDt,103) as PrincipleOverdueSinceDate
							  ,x.Overdueinterest as InterestOverdueAmount
							  ,convert (varchar(10),x.OverdueIntDt,103) as InterestOverdueSinceDate
							  ,x.OverOtherdue as OtherOverdue
							  ,convert(varchar(10),A.FinalNpaDt, 103)  as NPADate
							  ,A.NPA_Reason as NPAReason
							  ,convert (varchar (10),A.FirstDtOfDisb,103) as FirstDateofDisbursement 
							  ,A.Asset_Norm as AssetClassNorm
							  ,convert(varchar(10),A.SMA_Dt,103) as SMADate
							  ,A.SMA_Reason as SMAReason
							  ,A.FlgSMA as SMAStatus
							  ,c.AssetClassName as SubAssetClassCode
							  ,A.FlgFraud as FraudCommited
							  ,convert (varchar (10),A.FraudDate,103) as FraudDate
							  ,A.RFA AS RFAFlag
							  ,convert(varchar(10),A.FraudDate,103) as RFADate
							  ,X.OverDue as TotalOverdue
							  ,Pd.DPD_Max as MaxDPD
							  

							  
                          
                             
                           
       
                     FROM pro.AccountCal_Hist  A
                                inner join pro.CustomerCal_Hist Y on A.RefCustomerId=Y.RefCustomerID  
								INNER JOIN #DPD PD       ON  PD.CustomerAcID=A.CustomerAcID

                               left join dbo.AdvAcBalanceDetail X on A.AccountEntityId=X.AccountEntityId 
								left join dbo.AdvFacBillDetail AFB on A.AccountEntityId=AFB.AccountEntityId
                              -- Left join Dimcurrency B on A.CurrencyAlt_Key=B.CurrencyAlt_Key  
                               Left join DimAssetClass C on A.FinalAssetClassAlt_Key=C.AssetClassAlt_Key  
                              Left join DimProduct Z on A.ProductAlt_Key=z.ProductAlt_Key  
							  
                  
							  
                            --   left join dIMiNDUSTRY q on x.Industry_AltKey = Q.IndustryAlt_Key  
                               WHERE A.EffectiveFromTimeKey <= @TimeKey  
                           AND A.EffectiveToTimeKey >= @TimeKey  
						   AND Y.EffectiveFromTimeKey <= @TimeKey  
                           AND Y.EffectiveToTimeKey >= @TimeKey  
						   AND AFB.EffectiveFromTimeKey <= @TimeKey  
                           AND AFB.EffectiveToTimeKey >= @TimeKey  
                            AND C.EffectiveFromTimeKey <= @TimeKey  
                           AND C.EffectiveToTimeKey >= @TimeKey  
						    AND Z.EffectiveFromTimeKey <= @TimeKey  
                           AND Z.EffectiveToTimeKey >= @TimeKey  
    
                   	) s
     END    
                   
             	--Select * From TempDB..#temp
                


				SELECT *
                         FROM #temp A
                                     inner join pro.AccountCal_Hist B
                                  on A.AccountID= B.CustomerAcID
								  where A.AccountID=@AccountID
                                  
                                          
                       
                      

   END TRY  

      BEGIN CATCH  
        
      INSERT INTO dbo.Error_Log  
                        SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber  
                        ,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState  
                        ,GETDATE()  
  
      SELECT ERROR_MESSAGE()  
    --  RETURN -1  
     
      END CATCH  
  
  
   
   
    END;  
  
  
GO
