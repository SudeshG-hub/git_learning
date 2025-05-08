SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROC [dbo].[CustomerAccountMOC_A]
 	   @TimeKey				INT
	  ,@CrModApBy				VARCHAR(20)='MOCUPLOAD'
	--,@D2Ktimestamp	        TIMESTAMP     =0 OUTPUT 
	 ,@Result                INT   =0 OUTPUT
	--,@ErrorMsg				Varchar(max)='' OUTPUT
	--WITH RECOMPILE
AS

SET DATEFORMAT dmy


--TRUNCATE TABLE Sample_Data
--INSERT INTO Sample_Data
--SELECT * FROM #Sample_Data


DECLARE @PROCESSINGDATE DATE=(SELECT DATE FROM SYSDAYMATRIX WHERE TIMEKEY=@TIMEKEY)
DECLARE @SetID INT =(SELECT ISNULL(MAX(ISNULL(SETID,0)),0)+1 FROM [PRO].[ProcessMonitor] WHERE TimeKey=@TIMEKEY )
 SET @TIMEKEY= (SELECT TIMEKEY FROM SYSDAYMATRIX WHERE TIMEKEY=@TIMEKEY)

DECLARE @MocTimeKey INT = @Timekey
		
	
BEGIN TRY
 BEGIN TRAN 

 
	DECLARE @EntityKey INT=0

	DROP TABLE IF EXISTS #CustNpa

	SELECT A.CustomerEntityId,A.RefCustomerID CustomerID 
			,ACL.AssetClassShortName   AssetClassShortName
			,ACL1.AssetClassShortName  PostMoc_AssetClassShortName
			,A.SysNPA_Dt NPADate   
			,B.SysNPA_Dt PostMoc_NPAdt
			,a.DbtDt
			,b.DbtDt PostMoc_DBtdt
			,ACL.AssetClassAlt_Key 
			,acl1.AssetClassAlt_Key PostMocAssetClassAlt_key
			,A.LossDt 
			,B.LossDt PostMoc_LossDt
	INTO #CustNpa
FROM PREMOC.CUSTOMERCAL A
	inner JOIN PRO.CUSTOMERCAL B
		ON A.CustomerEntityID=b.CustomerEntityID
		AND (A.EffectiveFromTimeKey<=@MocTimeKey and A.EffectiveToTimeKey>=@MocTimeKey)
	inner join DimAssetClass ACL ON	  A.SysAssetClassAlt_Key= ACL.AssetClassAlt_Key
		AND (ACL.EffectiveFromTimeKey<=@MocTimeKey and ACL.EffectiveToTimeKey>=@MocTimeKey)
	inner join DimAssetClass ACL1 ON	  B.SysAssetClassAlt_Key= ACL1.AssetClassAlt_Key
		AND (ACL1.EffectiveFromTimeKey<=@MocTimeKey and ACL1.EffectiveToTimeKey>=@MocTimeKey)
WHERE (ACL.AssetClassShortName<>ACL1.AssetClassShortName)
	 OR (A.SysNPA_Dt <>B.SysNPA_Dt)

UPDATE #CustNpa SET PostMoc_NPAdt=NULL WHERE PostMoc_AssetClassShortName='STD'



PRINT 'START MOC FOR ADVCUSTNPADETAIL'
IF OBJECT_ID('Tempdb..#TmpCustNPA') IS NOT NULL
				DROP TABLE #TmpCustNPA	
			
			SELECT NPA.* 
				INTO #TmpCustNPA
			FROM AdvCustNPADetail NPA
				INNER JOIN #CustNpa B
					ON npa.CustomerEntityId=B.CustomerEntityID
					AND (NPA.EffectiveFromTimeKey<=@MocTimeKey AND NPA.EffectiveToTimeKey>=@MocTimeKey)

		PRINT CAST(@@ROWCOUNT AS VARCHAR(20))+'Row In Temp Table For ADVCUSTNPADETAIL'
		print 'TEST'

--return
		PRINT 'Expire Data'
				UPDATE NPA SET
						NPA.EffectiveToTimeKey =@TimeKey -1 
					FROM AdvCustNPAdetail NPA
						INNER JOIN #TmpCustNPA T						
							ON NPA.CustomerEntityId=T.CustomerEntityId
							AND (NPA.EffectiveFromTimeKey<=@MocTimeKey AND NPA.EffectiveToTimeKey>=@MocTimeKey)
						inner join DimAssetClass ACL
							ON ACL.EffectiveFromTimeKey<=@TimeKey AND ACL.EffectiveToTimeKey>=@TimeKey
							AND ACL.AssetClassAlt_Key=T.Cust_AssetClassAlt_Key
						WHERE (NPA.EffectiveFromTimeKey<@MocTimeKey OR  ACL.AssetClassShortName='STD')


				DELETE NPA
				FROM AdvCustNPAdetail NPA
					INNER JOIN #TmpCustNPA T						
						ON NPA.CustomerEntityId=T.CustomerEntityId
						AND (NPA.EffectiveFromTimeKey<=@MocTimeKey AND NPA.EffectiveToTimeKey>=@MocTimeKey)
					WHERE NPA.EffectiveFromTimeKey=@MocTimeKey AND NPA.EffectiveToTimeKey>=@MocTimeKey


				PRINT CAST(@@ROWCOUNT AS VARCHAR(20))+'Row In Expire From ADVCUSTNPADETAIL'
						PRINT 'INSERT INTO PREMOC.NPA DETAIL '



	--select * from #TmpCustNPA

			SELECT  @EntityKey=MAX(EntityKey) FROM PreMoc.AdvCustNPADetail
			INSERT INTO PreM.AdvCustNPADetail
						(
							EntityKey
							,CustomerEntityId     
							,Cust_AssetClassAlt_Key
							,NPADt                
							,LastInttChargedDt    
							,DbtDt                
							,LosDt                
							,DefaultReason1Alt_Key
							,DefaultReason2Alt_Key
							,StaffAccountability  
							,LastIntBooked        
							,RefCustomerID        
							,AuthorisationStatus  
							,EffectiveFromTimeKey 
							,EffectiveToTimeKey   
							,CreatedBy            
							,DateCreated          
							,ModifiedBy           
							,DateModified         
							,ApprovedBy           
							,DateApproved         						      
							,MocStatus            
							,MocDate              
							,MocTypeAlt_Key 
							----,WillfulDefault
							----,WillfulDefaultReasonAlt_Key
							----,WillfulRemark
							----,WillfulDefaultDate
							,NPA_Reason      
						)
				SELECT		@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
							,npa.CustomerEntityId     
							,npa.Cust_AssetClassAlt_Key
							,npa.NPADt                
							,npa.LastInttChargedDt    
							,npa.DbtDt                
							,npa.LosDt                
							,npa.DefaultReason1Alt_Key
							,npa.DefaultReason2Alt_Key
							,npa.StaffAccountability  
							,npa.LastIntBooked        
							,npa.RefCustomerID        
							,npa.AuthorisationStatus  
							,@MocTimeKey EffectiveFromTimeKey 
							,@MocTimeKey EffectiveToTimeKey   
							,npa.CreatedBy            
							,npa.DateCreated          
							,npa.ModifiedBy           
							,npa.DateModified         
							,npa.ApprovedBy           
							,npa.DateApproved         						      
							,'Y' MocStatus            
							,GETDATE() MocDate              
							,210 MocTypeAlt_Key  
							----,NPA.WillfulDefault
							----,NPA.WillfulDefaultReasonAlt_Key
							----,NPA.WillfulRemark
							----,NPA.WillfulDefaultDate
							,NPA.NPA_Reason   
					FROM #TmpCustNPA NPA
						LEFT JOIN PreMoc.AdvCustNPADetail T				
							ON(T.EffectiveFromTimeKey<=@MocTimeKey AND T.EffectiveToTimeKey>=@MocTimeKey)
							AND T.CustomerEntityId=NPA.CustomerEntityId
					WHERE T.CustomerEntityId IS NULL

				PRINT CAST(@@ROWCOUNT AS VARCHAR(5))+' Row Inserted in Premoc.AdvCustNPADetail'

print 'TEST2'
			PRINT 'UPDATE RECORD FOR SAME TIME KEY'
				 UPDATE NPA SET
						Cust_AssetClassAlt_Key =  DM.AssetClassAlt_Key
						,NPADt=     SD.PostMoc_NPAdt  
						--,DbtDt=   ISNULL(SD.PostMoc_DBtdt,DbtDt)
						,DbtDt = CASE WHEN PostMocAssetClassAlt_key = 6 THEN NULL ELSE ISNULL(SD.PostMoc_DBtdt,sd.DbtDt) END
						,LosDt   =CASE WHEN PostMocAssetClassAlt_key = 6 THEN SD.PostMoc_DBtdt ELSE PostMoc_LossDt END
						--,CreatedBy=@CrModApBy
						--,DateCreated=GETDATE()
						,ModifiedBy=@CrModApBy
						,DateModified=getdate()
						,MocStatus= 'Y'               
						,MocDate= GetDate()                
						,MocTypeAlt_Key= 210    
				FROM AdvCustNPAdetail NPA
						INNER JOIN #CustNpa sd
							ON SD.CustomerEntityId=sd.CustomerEntityId
						INNER JOIN DimAssetClass DM						
								ON (DM.EffectiveFromTimeKey<=@MocTimeKey AND DM.EffectiveToTimeKey>=@MocTimeKey)
								AND SD.PostMocAssetClassAlt_key=DM.AssetClassAlt_Key
								AND DM.AssetClassShortName<>'STD'      
						WHERE NPA.EffectiveFromTimeKey=@MocTimeKey AND NPA.EffectiveToTimeKey=@MocTimeKey
						
						PRINT CAST(@@ROWCOUNT AS VARCHAR(5))+' Row UPdate  IN AdvCustNPADetail'

						PRINT 'INSERT IN NPA FOR CURRENT TIME KEY'

						PRINT '11'

			SELECT  @EntityKey=MAX(EntityKey) FROM AdvCustNPADetail
			INSERT INTO AdvCustNPADetail 
						(
							EntityKey
							,CustomerEntityId      
							,Cust_AssetClassAlt_Key
							,NPADt                 
							,LastInttChargedDt     
							,DbtDt                 
							,LosDt                 
							,DefaultReason1Alt_Key 
							,DefaultReason2Alt_Key 
							,StaffAccountability   
							,LastIntBooked         
							,RefCustomerID         
							,AuthorisationStatus   
							,EffectiveFromTimeKey  
							,EffectiveToTimeKey    
							,CreatedBy             
							,DateCreated           
							,ModifiedBy            
							,DateModified          
							,ApprovedBy            
							,DateApproved          
							--,D2Ktimestamp          
							,MocStatus             
							,MocDate      
							,MocTypeAlt_Key  
							----,WillfulDefault
							----,WillfulDefaultReasonAlt_Key
							----,WillfulRemark
							----,WillfulDefaultDate
							,NPA_Reason      
						)
				--declare @MocTimeKey int =4383						
					SELECT 
							@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
							,NPA.CustomerEntityId      
							,DM.AssetClassAlt_Key
							,ISNULL(Convert(date,PostMoc_NPAdt,103),NPA.NPADt)     
							,NPA.LastInttChargedDt     
							--,ISNULL(SD.PostMoc_DBtdt,DbtDt)
							--,npa.LosDt
							, CASE WHEN PostMocAssetClassAlt_key = 6 THEN NULL ELSE ISNULL(SD.PostMoc_DBtdt,sd.DbtDt) END
							, CASE WHEN PostMocAssetClassAlt_key = 6 THEN SD.PostMoc_DBtdt ELSE NPA.LosDt END
							,NPA.DefaultReason1Alt_Key 
							,NPA.DefaultReason2Alt_Key 
							,NPA.StaffAccountability   
							,NPA.LastIntBooked         
							,NPA.RefCustomerID         
							,NPA.AuthorisationStatus   
							,@MocTimeKey  EffectiveFromTimeKey  
							,@MocTimeKey  EffectiveToTimeKey    
							,@CrModApBy            
							,GETDATE()         
							,NPA.ModifiedBy            
							--,@CrModApBy
							,NPA.DateModified          
							,NPA.ApprovedBy            
							,NPA.DateApproved          
							--,NPA.D2Ktimestamp          
							,'Y'  MocStatus             
							,GetDate() MocDate               
							,210 MocTypeAlt_Key  
							----,NPA.WillfulDefault
							----,NPA.WillfulDefaultReasonAlt_Key
							----,NPA.WillfulRemark
							----,NPA.WillfulDefaultDate
							,NPA.NPA_Reason    
					FROM #TmpCustNPA NPA
						INNER JOIN  #CustNpa SD						
								ON NPA.CustomerEntityId = SD.CustomerEntityId
								  
						INNER JOIN DimAssetClass DM						
								ON (DM.EffectiveFromTimeKey<=@MocTimeKey AND DM.EffectiveToTimeKey>=@MocTimeKey)
								AND SD.PostMocAssetClassAlt_key=DM.AssetClassAlt_Key 
						LEFT JOIN AdvCustNPADetail AA
								ON AA.EffectiveFromTimeKey=@TimeKey AND AA.EffectiveToTimeKey=@TimeKey
								AND NPA.CustomerEntityId=AA.CustomerEntityId
						WHERE AA.CustomerEntityId IS NULL
							AND dm.AssetClassGroup='NPA'

					PRINT CAST(@@ROWCOUNT AS VARCHAR(5))+'INSERT IN NPA FOR CURRENT TIME KEY'
					PRINT '12'

		PRINT 'INSERT IN NPA FOR LIVE'
					SELECT  @EntityKey=MAX(EntityKey) FROM AdvCustNPADetail

			INSERT INTO AdvCustNPADetail
					(
						EntityKey
						,CustomerEntityId     
						,Cust_AssetClassAlt_Key
						,NPADt                
						,LastInttChargedDt    
						,DbtDt                
						,LosDt                
						,DefaultReason1Alt_Key
						,DefaultReason2Alt_Key
						,StaffAccountability  
						,LastIntBooked        
						,RefCustomerID        
						,AuthorisationStatus  
						,EffectiveFromTimeKey 
						,EffectiveToTimeKey   
						,CreatedBy            
						,DateCreated          
						,ModifiedBy           
						,DateModified         
						,ApprovedBy           
						,DateApproved         
						--,D2Ktimestamp         
						,MocStatus            
						,MocDate              
						,MocTypeAlt_Key 
						----,WillfulDefault
						----,WillfulDefaultReasonAlt_Key
						----,WillfulRemark
						----,WillfulDefaultDate
						,NPA_Reason     
					)
				select 
					@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey				
					,NPA.CustomerEntityId     
					,NPA.Cust_AssetClassAlt_Key
					,NPA.NPADt
					,NPA.LastInttChargedDt    
					,NPA.DbtDt                
					,NPA.LosDt                
					,NPA.DefaultReason1Alt_Key
					,NPA.DefaultReason2Alt_Key
					,NPA.StaffAccountability  
					,NPA.LastIntBooked        
					,NPA.RefCustomerID        
					,NPA.AuthorisationStatus  
					,@MocTimeKey+1  EffectiveFromTimeKey 
					,NPA.EffectiveToTimeKey   
					,NPA.CreatedBy            
					,NPA.DateCreated          
					,NPA.ModifiedBy           
					--,@CrModApBy
					,NPA.DateModified         
					,NPA.ApprovedBy           
					,NPA.DateApproved         
					--,NPA.D2Ktimestamp         
					,MocStatus            
					,MocDate              
					,MocTypeAlt_Key 
					----,NPA.WillfulDefault
					----,NPA.WillfulDefaultReasonAlt_Key
					----,NPA.WillfulRemark
					----,NPA.WillfulDefaultDate
					,NPA.NPA_Reason    
			FROM #TmpCustNPA NPA
				WHERE NPA.EffectiveToTimeKey>@MocTimeKey

			
			PRINT CAST(@@ROWCOUNT AS VARCHAR(5))+'INSERT IN NPA FOR LIVE'
			PRINT 'UPDATE SOURCE TABLE FOR NPA DETAIL'


			-------ADD FRESH NPA RECORDS FROM MOC

	SELECT  @EntityKey=MAX(EntityKey) FROM AdvCustNPADetail
			INSERT INTO AdvCustNPAdetail
					 (
					 ENTITYKEY
					 ,CustomerEntityId
					,Cust_AssetClassAlt_Key
					,NPADt
					,LastInttChargedDt
					,DbtDt
					,LosDt
					,DefaultReason1Alt_Key
					,DefaultReason2Alt_Key
					,StaffAccountability
					,LastIntBooked
					,RefCustomerID
					,AuthorisationStatus
					,EffectiveFromTimeKey
					,EffectiveToTimeKey
					,CreatedBy
					,DateCreated
					,ModifiedBy
					,DateModified
					,ApprovedBy
					,DateApproved
					,MocStatus
					,MocDate
					,MocTypeAlt_Key
					--,WillfulDefault
					--,WillfulDefaultReasonAlt_Key
					--,WillfulRemark
					--,WillfulDefaultDate
					,NPA_Reason
					 )
					 select 
					 @EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
					 ,a.CustomerEntityId
					,C.AssetClassAlt_Key
					---,CONVERT(DATE, A.PostMoc_NPAdt,103)
					,A.PostMoc_NPAdt
					,NULL LastInttChargedDt
					,a.PostMoc_DBtdt DbtDt
					,LosDt
					,NULL DefaultReason1Alt_Key
					,NULL DefaultReason2Alt_Key
					,NULL StaffAccountability
					,NULL LastIntBooked
					,a.CustomerID
					,NULL AuthorisationStatus
					,@MocTimeKey EffectiveFromTimeKey
					,@MocTimeKey EffectiveToTimeKey
					,@CrModApBy CreatedBy
					, GETDATE() DateCreated
					,NULL ModifiedBy
					,NULL DateModified
					,NULL ApprovedBy
					,NULL DateApproved
					,'Y' MocStatus
					,GETDATE() MocDate
					,210 MocTypeAlt_Key
					----,NULL WillfulDefault
					----,NULL WillfulDefaultReasonAlt_Key
					----,NULL WillfulRemark
					----,NULL WillfulDefaultDate
					,NULL NPA_Reason
				 FROM #CustNpa A  
					 INNER JOIN DimAssetClass C ON C.AssetClassAlt_Key=ISNULL(A.PostMocAssetClassAlt_key,'')
							AND C.EffectiveFromTimeKey<=@MocTimeKey AND C.EffectiveToTimeKey>=@MocTimeKey
					LEFT OUTER join AdvCustNPAdetail d on D.CustomerEntitYID=A.CustomerEntitYID
							AND (D.EffectiveFromTimeKey<=@MocTimeKey AND D.EFFECTIVETOTIMEKEY>=@MocTimeKey)
				WHERE ISNULL(c.AssetClassGroup,'')='NPA' --AND ISNULL(POSTMOCASSETCLASSIFICATION,'')<>'STD'
					and d.CustomerEntitYID is null


/*	START MOC FOR BALANCE DETAIL*/
	DROP TABLE IF EXISTS #AcDataMoc
		
		select CustomerEntityID,RefCustomerID CustomerID, CustomerAcID,AccountEntityID,AddlProvision,TotalProvision TotalProv ,Balance,UnserviedInt UnAppliedIntAmount
			,DFVAmt,FlgRestructure,RestructureDate,FlgFITL,FinalAssetClassAlt_Key AssetClassAlt_Key,FinalNpaDt NpaDate,RePossession ,PrincOutStd PrincipalBalance
			,CAST(''  AS VARCHAR(30)) RefSystemAcId
			INTO #AcDataMoc
		FROM PRO.ACCOUNTCAL

		UPDATE A SET A.RefSystemAcId=B.SystemACID
		FROM #AcDataMoc A
			 INNER JOIN AdvAcBasicDetail B
				ON B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeKey >=@TimeKey
				AND A.AccountEntityID=B.AccountEntityId
		IF OBJECT_ID('Tempdb..#TmpAcBalance') IS NOT NULL
			DROP TABLE #TmpAcBalance
			
		SELECT a.* 
				INTO #TmpAcBalance
			FROM dbo.AdvAcBalanceDetail a
			 INNER JOIN #AcDataMoc b
					ON a.EffectiveFromTimeKey<=@MocTimeKey AND a.EffectiveToTimeKey>=@MocTimeKey
					AND a.AccountEntityId=b.AccountEntityId
				WHERE (A.AssetClassAlt_Key<>b.AssetClassAlt_Key 
						OR ISNULL(A.BAlance,0)<>ISNULL(b.Balance,0)
						OR ISNULL(A.UnAppliedIntAmount,0)=ISNULL(B.UnAppliedIntAmount,0)
						OR ISNULL(A.PrincipalBalance,0)=ISNULL(B.PrincipalBalance,0)
						OR ISNULL(A.TotalProv,0)=ISNULL(B.TotalProv,0)
						OR ISNULL(A.DFVAmt,0)=ISNULL(B.DFVAmt,0)

					
						
						)
				PRINT 'Expire data'

				UPDATE AABD SET
					AABD.EffectiveToTimeKey =@MocTimeKey -1 
				FROM dbo.AdvAcBalanceDetail AABD
					INNER JOIN #TmpAcBalance T						
						ON AABD.AccountEntityId=T.AccountEntityId
						AND (AABD.EffectiveFromTimeKey<=@MocTimeKey AND AABD.EffectiveToTimeKey>=@MocTimeKey)
					WHERE AABD.EffectiveFromTimeKey<@MocTimeKey
		
				DELETE AABD
				FROM dbo.AdvAcBalanceDetail AABD
					INNER JOIN #TmpAcBalance T						
						ON AABD.AccountEntityId=T.AccountEntityId
						AND (AABD.EffectiveFromTimeKey<=@MocTimeKey AND AABD.EffectiveToTimeKey>=@MocTimeKey)
					WHERE AABD.EffectiveFromTimeKey=@MocTimeKey AND AABD.EffectiveToTimeKey>=@MocTimeKey
		
		PRINT 'Insert data in Premoc.Balance '
	
	SELECT  @EntityKey=MAX(EntityKey) FROM PREMOC.AdvAcBalanceDetail

				INSERT INTO PREMOC.AdvAcBalanceDetail
							(
								EntityKey
								,AccountEntityId
								,AssetClassAlt_Key
								,BalanceInCurrency
								,Balance
								,SignBalance
								,LastCrDt
								,OverDue
								,TotalProv
								----,DirectBalance
								----,InDirectBalance
								----,LastCrAmt
								,RefCustomerId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,OverDueSinceDt
								,MocStatus
								,MocDate
								,MocTypeAlt_Key
								,Old_OverDueSinceDt
								,Old_OverDue
								,ORG_TotalProv
								,IntReverseAmt
								,PS_Balance
								,NPS_Balance
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								,CreatedBy
								----,PS_NPS_FLAG
								,OverduePrincipal
								,Overdueinterest
								,AdvanceRecovery
								,NotionalInttAmt
								,PrincipalBalance
								,UnAppliedIntAmount
								,DFVAmt
							)

						SELECT
								@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								,T.AccountEntityId
								,T.AssetClassAlt_Key
								,T.BalanceInCurrency
								,T.Balance
								,T.SignBalance
								,T.LastCrDt
								,T.OverDue
								,T.TotalProv
								----,T.DirectBalance
								----,T.InDirectBalance
								----,T.LastCrAmt
								,T.RefCustomerId
								,T.RefSystemAcId
								,T.AuthorisationStatus
								,@MocTimeKey EffectiveFromTimeKey
								,@MocTimeKey EffectiveToTimeKey
								,T.OverDueSinceDt
								,'Y' MocStatus            
								,GETDATE() MocDate   
								,T.MocTypeAlt_Key
								,T.Old_OverDueSinceDt
								,T.Old_OverDue
								,T.ORG_TotalProv
								,T.IntReverseAmt
								,T.PS_Balance
								,T.NPS_Balance
								,T.DateCreated
								,T.ModifiedBy
								,T.DateModified
								,T.ApprovedBy
								,T.DateApproved
								,T.CreatedBy
								----,T.PS_NPS_FLAG
								,T.OverduePrincipal
								,T.Overdueinterest
								,T.AdvanceRecovery
								,T.NotionalInttAmt
								,T.PrincipalBalance
								,t.UnAppliedIntAmount
								,T.DFVAmt
						 FROM #TmpAcBalance T
							LEFT JOIN PreMoc.AdvAcBalanceDetail PRE
								ON (PRE.EffectiveFromTimeKey<=@MocTimeKey AND PRE.EffectiveToTimeKey>=@MocTimeKey)
								AND PRE.AccountEntityId=T.AccountEntityId --AND PRE.AccountEntityId IS NULL
							WHERE PRE.AccountEntityId IS NULL


					PRINT 'UPDATE RECORED FOR CURRENT TIME KEY'

					UPDATE AABD SET
						ModifiedBy=@CrModApBy
						,DateModified=getdate()
						, MocStatus='Y'
						,MocDate=GetDate() 
						,MocTypeAlt_Key=210 
						,AABD.AssetClassAlt_Key=bb.AssetClassAlt_Key
						,AABD.BalanceInCurrency=bb.balance
						,AABD.Balance=bb.balance
						,AABD.PS_Balance=CASE WHEN  aabd.PS_Balance >0 THEN ((ISNULL(bb.Balance,0))) ELSE AABD.PS_Balance END
						,AABD.NPS_Balance= CASE WHEN  aabd.NPS_Balance>0 THEN((ISNULL(bb.Balance,0))) ELSE AABD.NPS_Balance END
						,aabd.UnAppliedIntAmount=bb.UnAppliedIntAmount
						,aabd.PrincipalBalance=bb.PrincipalBalance
						,aabd.TotalProv=bb.TotalProv
						,AABD.DFVAmt=BB.DFVAmt
			----select 1
				 FROM dbo.AdvAcBalanceDetail AABD
					INNER JOIN #TmpAcBalance T						
						ON AABD.AccountEntityId=T.AccountEntityId
					INNER JOIN #AcDataMoc  bb
							on bb.AccountEntityId=t.AccountEntityId
					WHERE AABD.EffectiveFromTimeKey=@MocTimeKey AND AABD.EffectiveToTimeKey=@MocTimeKey
			
					PRINT 'Insert data for Current TimeKey'	 
			

	SELECT  @EntityKey=MAX(EntityKey) FROM dbo.AdvAcBalanceDetail

				INSERT INTO AdvAcBalanceDetail
							(
								EntityKey
								,AccountEntityId
								,AssetClassAlt_Key
								,BalanceInCurrency
								,Balance
								,SignBalance
								,LastCrDt
								,OverDue
								,TotalProv
								,RefCustomerId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,OverDueSinceDt
								,MocStatus
								,MocDate
								,MocTypeAlt_Key
								,Old_OverDueSinceDt
								,Old_OverDue
								,ORG_TotalProv
								,IntReverseAmt
								,PS_Balance
								,NPS_Balance
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								,CreatedBy
								----,PS_NPS_FLAG
								,OverduePrincipal
								,Overdueinterest
								,AdvanceRecovery
								,NotionalInttAmt
								,PrincipalBalance
								,UnAppliedIntAmount
								,DFVAmt
							)
						SELECT 
								@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								,A.AccountEntityId
								,sd.AssetClassAlt_Key
								,CASE WHEN SD.AccountEntityId IS NULL THEN A.BalanceInCurrency ELSE ((ISNULL(SD.Balance,0)))  END
								,CASE WHEN SD.AccountEntityId IS NULL THEN A.Balance ELSE ((ISNULL(SD.Balance,0)))  END
								,A.SignBalance
								,A.LastCrDt
								,A.OverDue
								,sd.TotalProv
								,A.RefCustomerId
								,A.RefSystemAcId
								,A.AuthorisationStatus
								,@MocTimeKey AS EffectiveFromTimeKey
								,@MocTimeKey AS EffectiveToTimeKey
								,A.OverDueSinceDt
								,'Y' MocStatus
								,GETDATE() MocDate
								,210 MocTypeAlt_Key
								,A.Old_OverDueSinceDt
								,A.Old_OverDue
								,A.ORG_TotalProv
								,A.IntReverseAmt
								,CASE WHEN  A.PS_Balance>0 THEN   ((ISNULL(SD.Balance,0)))   ELSE  A.PS_Balance END PS_Balance
								,CASE WHEN  A.NPS_Balance>0 THEN   ((ISNULL(SD.Balance,0)))   ELSE  A.NPS_Balance END NPS_Balance
								,GETDATE() DateCreated
								,A.ModifiedBy
								,A.DateModified
								,A.ApprovedBy
								,A.DateApproved
								,@CrModApBy CreatedBy
								,A.OverduePrincipal
								,A.Overdueinterest
								,A.AdvanceRecovery
								,A.NotionalInttAmt
								,sd.PrincipalBalance
								,sd.UnAppliedIntAmount
								,SD.DFVAmt
					FROM #TmpAcBalance A
						LEFT JOIN #AcDataMoc SD
							ON A.AccountEntityId=SD.AccountEntityId
						LEFT JOIN dbo.AdvAcBalanceDetail	 O
								ON A.AccountEntityId=O.AccountEntityId	
								 AND (o.EffectiveFromTimeKey=@MocTimeKey AND o.EffectiveToTimeKey=@MocTimeKey)												
					WHERE  O.AccountEntityId IS NULL	
			
					PRINT 'Insert data for live TimeKey'
			
			SELECT  @EntityKey=MAX(EntityKey) FROM dbo.AdvAcBalanceDetail

						INSERT INTO dbo.AdvAcBalanceDetail
									(
										EntityKey,
										AccountEntityId
										,AssetClassAlt_Key
										,BalanceInCurrency
										,Balance
										,SignBalance
										,LastCrDt
										,OverDue
										,TotalProv
										,RefCustomerId
										,RefSystemAcId
										,AuthorisationStatus
										,EffectiveFromTimeKey
										,EffectiveToTimeKey
										,OverDueSinceDt
										,MocStatus
										,MocDate
										,MocTypeAlt_Key
										,Old_OverDueSinceDt
										,Old_OverDue
										,ORG_TotalProv
										,IntReverseAmt
										,PS_Balance
										,NPS_Balance
										,DateCreated
										,ModifiedBy
										,DateModified
										,ApprovedBy
										,DateApproved
										,CreatedBy
										,OverduePrincipal
										,Overdueinterest
										,AdvanceRecovery
										,NotionalInttAmt
										,PrincipalBalance
										,UnAppliedIntAmount
										,DFVAmt
									)
												
								
												
								SELECT 
										@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
										,T.AccountEntityId
										,T.AssetClassAlt_Key
										,T.BalanceInCurrency
										,T.Balance
										,T.SignBalance
										,T.LastCrDt
										,T.OverDue
										,T.TotalProv
										,T.RefCustomerId
										,T.RefSystemAcId
										,T.AuthorisationStatus
										,@MocTimeKey+1
										,T.EffectiveToTimeKey
										,T.OverDueSinceDt
										,T.MocStatus
										,T.MocDate
										,T.MocTypeAlt_Key
										,T.Old_OverDueSinceDt
										,T.Old_OverDue
										,T.ORG_TotalProv
										,T.IntReverseAmt
										,T.PS_Balance
										,T.NPS_Balance
										,T.DateCreated
										,T.ModifiedBy
										,T.DateModified
										,T.ApprovedBy
										,T.DateApproved
										,T.CreatedBy
										,T.OverduePrincipal
										,T.Overdueinterest
										,T.AdvanceRecovery
										,T.NotionalInttAmt
										,T.PrincipalBalance
										,t.UnAppliedIntAmount
										,T.DFVAmt
							FROM #TmpAcBalance T
							WHERE T.EffectiveToTimeKey>@MocTimeKey

/********************************************/
/*	ADVACBASIC DETAIL*/		
	IF OBJECT_ID('Tempdb..#AccountBasic') IS NOT NULL
				DROP TABLE #AccountBasic	
			

			SELECT abd.* 
				INTO #AccountBasic
			FROM AdvAcBasicDetail abd
				INNER JOIN #AcDataMoc t  ON (abd.AccountEntityId=T.AccountEntityId)
					AND (abd.EffectiveFromTimeKey<=@MocTimeKey AND abd.EffectiveToTimeKey>=@MocTimeKey)
				WHERE ISNULL(ABD.AdditionalProv,0)<>ISNULL(T.AddlProvision,0)


					SELECT  @EntityKey=MAX(AC_KEY) FROM PREMOC.AdvAcBasicDetail

						INSERT INTO PreMoc.AdvAcBasicDetail
									(
										AC_KEY
										,BranchCode
										,AccountEntityId
										,CustomerEntityId
										,SystemACID
										,CustomerACID
										,GLAlt_Key
										,ProductAlt_Key
										,GLProductAlt_Key
										,FacilityType
										,SectorAlt_Key
										,SubSectorAlt_Key
										,ActivityAlt_Key
										,IndustryAlt_Key
										,SchemeAlt_Key
										,DistrictAlt_Key
										,AreaAlt_Key
										,VillageAlt_Key
										,StateAlt_Key
										,CurrencyAlt_Key
										,OriginalSanctionAuthAlt_Key
										,OriginalLimitRefNo
										,OriginalLimit
										,OriginalLimitDt
										,DtofFirstDisb
										,EmpCode
										,FlagReliefWavier
										,UnderLineActivityAlt_Key
										,MicroCredit
										,segmentcode
										,ScrCrError
										,AdjDt
										,AdjReasonAlt_Key
										,MarginType
										,Pref_InttRate
										,CurrentLimitRefNo
										,ProcessingFeeApplicable
										,ProcessingFeeAmt
										,ProcessingFeeRecoveryAmt
										,GuaranteeCoverAlt_Key
										,AccountName
										,ReferencePeriod
										,AssetClass
										,D2K_REF_NO
										,InttAppFreq
										,JointAccount
										,LastDisbDt
										,ScrCrErrorBackup
										,AccountOpenDate
										,Ac_LADDt
										,Ac_DocumentDt
										,CurrentLimit
										,InttTypeAlt_Key
										,InttRateLoadFactor
										,Margin
										,TwentyPointReference
										,BSR1bCode
										,CurrentLimitDt
										,Ac_DueDt
										,DrawingPowerAlt_Key
										,RefCustomerId
										,D2KACID
										,AuthorisationStatus
										,EffectiveFromTimeKey
										,EffectiveToTimeKey
										,CreatedBy
										,DateCreated
										,ModifiedBy
										,DateModified
										,ApprovedBy
										,DateApproved							
										,MocStatus
										,MocDate
										,MocTypeAlt_Key
										,AcCategegoryAlt_Key
										,OriginalSanctionAuthLevelAlt_Key
										,AcTypeAlt_Key
										,AcCategoryAlt_Key
										,ScrCrErrorSeq
										,SourceAlt_Key
										,LoanSeries
										,LoanRefNo
										,SecuritizationCode
										,Full_Disb
										,OriginalBranchcode
									)
							SELECT		@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
										,abd.BranchCode
										,abd.AccountEntityId
										,abd.CustomerEntityId
										,abd.SystemACID
										,abd.CustomerACID
										,abd.GLAlt_Key
										,abd.ProductAlt_Key
										,abd.GLProductAlt_Key
										,abd.FacilityType
										,abd.SectorAlt_Key
										,abd.SubSectorAlt_Key
										,abd.ActivityAlt_Key
										,abd.IndustryAlt_Key
										,abd.SchemeAlt_Key
										,abd.DistrictAlt_Key
										,abd.AreaAlt_Key
										,abd.VillageAlt_Key
										,abd.StateAlt_Key
										,abd.CurrencyAlt_Key
										,abd.OriginalSanctionAuthAlt_Key
										,abd.OriginalLimitRefNo
										,abd.OriginalLimit
										,abd.OriginalLimitDt
										,abd.DtofFirstDisb
										,abd.EmpCode
										,abd.FlagReliefWavier
										,abd.UnderLineActivityAlt_Key
										,abd.MicroCredit
										,abd.segmentcode
										,abd.ScrCrError
										,abd.AdjDt
										,abd.AdjReasonAlt_Key
										,abd.MarginType
										,abd.Pref_InttRate
										,abd.CurrentLimitRefNo
										,abd.ProcessingFeeApplicable
										,abd.ProcessingFeeAmt
										,abd.ProcessingFeeRecoveryAmt
										,abd.GuaranteeCoverAlt_Key
										,abd.AccountName
										,abd.ReferencePeriod
										,abd.AssetClass
										,abd.D2K_REF_NO
										,abd.InttAppFreq
										,abd.JointAccount
										,abd.LastDisbDt
										,abd.ScrCrErrorBackup
										,abd.AccountOpenDate
										,abd.Ac_LADDt
										,abd.Ac_DocumentDt
										,abd.CurrentLimit
										,abd.InttTypeAlt_Key
										,abd.InttRateLoadFactor
										,abd.Margin
										,abd.TwentyPointReference
										,abd.BSR1bCode
										,abd.CurrentLimitDt
										,abd.Ac_DueDt
										,abd.DrawingPowerAlt_Key
										,abd.RefCustomerId
										,abd.D2KACID
										,abd.AuthorisationStatus
										,@MocTimeKey EffectiveFromTimeKey
										,@MocTimeKey EffectiveToTimeKey
										,abd.CreatedBy
										,abd.DateCreated
										,abd.ModifiedBy
										,abd.DateModified
										,abd.ApprovedBy
										,abd.DateApproved							
										,'Y' MocStatus            
										,GETDATE() MocDate   
										,abd.MocTypeAlt_Key
										,abd.AcCategoryAlt_Key
										,abd.OriginalSanctionAuthLevelAlt_Key
										,abd.AcTypeAlt_Key
										,abd.AcCategoryAlt_Key
										,abd.ScrCrErrorSeq
										,abd.SourceAlt_Key
										,abd.LoanSeries
										,abd.LoanRefNo
										,ABD.SecuritizationCode
										,ABD.Full_Disb
										,ABD.OriginalBranchcode
								FROM AdvAcBasicDetail abd
									INNER JOIN #AccountBasic b
										on abd.AccountEntityId=b.AccountEntityid
										and abd.EffectiveFromTimeKey<=@MocTimeKey and abd.EffectiveToTimeKey>=@MocTimeKey
									LEFT JOIN PreMoc.AdvAcBasicDetail T				
										ON(T.EffectiveFromTimeKey<=@MocTimeKey AND T.EffectiveToTimeKey>=@MocTimeKey)
										AND T.CustomerACID=abd.CustomerACID
								WHERE T.CustomerEntityId IS NULL


			UPDATE abd SET
					abd.EffectiveToTimeKey =@MocTimeKey -1 
				FROM AdvAcBasicDetail abd
					 INNER JOIN #AccountBasic T
						ON abd.AccountEntityId=T.AccountEntityId
						AND (abd.EffectiveFromTimeKey<=@MocTimeKey AND abd.EffectiveToTimeKey>=@MocTimeKey)
					WHERE abd.EffectiveFromTimeKey<@MocTimeKey

					DELETE abd 
						FROM AdvAcBasicDetail abd
										  INNER JOIN #AccountBasic T
								ON abd.AccountEntityId=T.AccountEntityId
							WHERE abd.EffectiveFromTimeKey=@MocTimeKey AND abd.EffectiveToTimeKey>=@MocTimeKey
					
	print 'TEST2111'
				PRINT 'UPDATE RECORD FOR SAME TIME KEY'
					 UPDATE abd SET
	
							 MocStatus= 'Y'               
							,MocDate= GetDate()                
							,MocTypeAlt_Key= 210   
							,abd.AdditionalProv=A.AddlProvision 
							,ModifiedBy=@CrModApBy
							,DateModified=getdate()
					FROM AdvAcBasicDetail abd
							INNER JOIN  #AcDataMoc A
								ON (ABD.EffectiveFromTimeKey<=@MocTimeKey AND ABD.EffectiveToTimeKey>=@MocTimeKey)
								AND ABD.AccountEntityId = A.AccountEntityId																				   
							WHERE ABD.EffectiveFromTimeKey=@MocTimeKey AND ABD.EffectiveToTimeKey=@MocTimeKey

--------			PRINT 'INSERT IN ACCOUNT FOR CURRENT TIME KEY'
				

				SELECT  @EntityKey=MAX(AC_KEY) FROM AdvAcBasicDetail
			INSERT INTO AdvAcBasicDetail 
						(
							Ac_Key
							,BranchCode
							,AccountEntityId
							,CustomerEntityId
							,SystemACID
							,CustomerACID
							,GLAlt_Key
							,ProductAlt_Key
							,GLProductAlt_Key
							,FacilityType
							,SectorAlt_Key
							,SubSectorAlt_Key
							,ActivityAlt_Key
							,IndustryAlt_Key
							,SchemeAlt_Key
							,DistrictAlt_Key
							,AreaAlt_Key
							,VillageAlt_Key
							,StateAlt_Key
							,CurrencyAlt_Key
							,OriginalSanctionAuthAlt_Key
							,OriginalLimitRefNo
							,OriginalLimit
							,OriginalLimitDt
							,Pref_InttRate
							,CurrentLimitRefNo
							----,ProcessingFeeApplicable
							----,ProcessingFeeAmt
							----,ProcessingFeeRecoveryAmt
							,GuaranteeCoverAlt_Key
							,AccountName
							----,ReferencePeriod
							,AssetClass
							----,D2K_REF_NO
							----,InttAppFreq
							,JointAccount
							,LastDisbDt
							,ScrCrErrorBackup
							,AccountOpenDate
							,Ac_LADDt
							,Ac_DocumentDt
							,CurrentLimit
							,InttTypeAlt_Key
							,InttRateLoadFactor
							,Margin
							----,TwentyPointReference
							----,BSR1bCode
							,CurrentLimitDt
							,Ac_DueDt
							,DrawingPowerAlt_Key
							,RefCustomerId
							----,D2KACID
							,AuthorisationStatus
							,EffectiveFromTimeKey
							,EffectiveToTimeKey
							,CreatedBy
							,DateCreated
							,ModifiedBy
							,DateModified
							,ApprovedBy
							,DateApproved							
							,MocStatus
							,MocDate
							,MocTypeAlt_Key
							,IsLAD
						--	,FacilitiesNo
							,FincaleBasedIndustryAlt_key
							,AcCategoryAlt_Key
							,OriginalSanctionAuthLevelAlt_Key
							,AcTypeAlt_Key
							,ScrCrErrorSeq
							---,D2k_OLDAscromID
							,BSRUNID
							,AdditionalProv
							,ProjectCost
							,DtofFirstDisb
							----,EmpCode
							,FlagReliefWavier
							,UnderLineActivityAlt_Key
							,MicroCredit
							,segmentcode
							,ScrCrError
							,AdjDt
							,AdjReasonAlt_Key
							,MarginType
							,AclattestDevelopment
							,SourceAlt_Key
							,LoanSeries
							,LoanRefNo
							,SecuritizationCode
							,Full_Disb
							,OriginalBranchcode
						)
					--declare @MocTimeKey int =4383						
					SELECT 
							@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey,
							ABD.BranchCode
							,ABD.AccountEntityId
							,ABD.CustomerEntityId
							,ABD.SystemACID
							,ABD.CustomerACID
							,ABD.GLAlt_Key
							,ABD.ProductAlt_Key
							,ABD.GLProductAlt_Key
							,ABD.FacilityType
							,ABD.SectorAlt_Key
							,ABD.SubSectorAlt_Key
							,ABD.ActivityAlt_Key
							,ABD.IndustryAlt_Key
							,ABD.SchemeAlt_Key
							,ABD.DistrictAlt_Key
							,ABD.AreaAlt_Key
							,ABD.VillageAlt_Key
							,ABD.StateAlt_Key
							,ABD.CurrencyAlt_Key
							,ABD.OriginalSanctionAuthAlt_Key
							,ABD.OriginalLimitRefNo
							,ABD.OriginalLimit
							,ABD.OriginalLimitDt
							,ABD.Pref_InttRate
							,ABD.CurrentLimitRefNo
							----,ProcessingFeeApplicable
							----,ProcessingFeeAmt
							----,ProcessingFeeRecoveryAmt
							,ABD.GuaranteeCoverAlt_Key
							,ABD.AccountName
							----,ReferencePeriod
							,ABD.AssetClass
							----,D2K_REF_NO
							----,InttAppFreq
							,ABD.JointAccount
							,ABD.LastDisbDt
							,ABD.ScrCrErrorBackup
							,ABD.AccountOpenDate
							,ABD.Ac_LADDt
							,ABD.Ac_DocumentDt
							,ABD.CurrentLimit
							,ABD.InttTypeAlt_Key
							,ABD.InttRateLoadFactor
							,ABD.Margin
							----,TwentyPointReference
							----,BSR1bCode
							,ABD.CurrentLimitDt
							,ABD.Ac_DueDt
							,ABD.DrawingPowerAlt_Key
							,ABD.RefCustomerId
							----,D2KACID
							,ABD.AuthorisationStatus
							,@MocTimeKey EffectiveFromTimeKey
							,@MocTimeKey EffectiveToTimeKey
							,@CrModApBy CreatedBy
							,GETDATE() DateCreated
							,ABD.ModifiedBy
							,ABD.DateModified
							,ABD.ApprovedBy
							,ABD.DateApproved							
							,'Y' MocStatus
							,GETDATE() MocDate
							,210 MocTypeAlt_Key
							,ABD.IsLAD
							--,FacilitiesNo
							,ABD.FincaleBasedIndustryAlt_key
							,ABD.AcCategoryAlt_Key
							,ABD.OriginalSanctionAuthLevelAlt_Key
							,ABD.AcTypeAlt_Key
							,ABD.ScrCrErrorSeq
							--,D2k_OLDAscromID
							,ABD.BSRUNID
							,T.AddlProvision
							,ABD.ProjectCost
							,ABD.DtofFirstDisb
							----,EmpCode
							,ABD.FlagReliefWavier
							,ABD.UnderLineActivityAlt_Key
							,ABD.MicroCredit
							,ABD.segmentcode
							,ABD.ScrCrError
							,ABD.AdjDt
							,ABD.AdjReasonAlt_Key
							,ABD.MarginType
							,ABD.AclattestDevelopment
							,ABD.SourceAlt_Key
							,ABD.LoanSeries
							,ABD.LoanRefNo
							,ABD.SecuritizationCode
							,ABD.Full_Disb
							,ABD.OriginalBranchcode
					FROM #AccountBasic abd
						INNER JOIN #AcDataMoc T
							ON T.AccountEntityID=ABD.AccountEntityId
						LEFT JOIN AdvAcBasicDetail bb
							on  (bb.EffectiveFromTimeKey=@MocTimeKey AND bb.EffectiveToTimeKey=@MocTimeKey)
						where (ABD.EffectiveFromTimeKey<=@MocTimeKey AND ABD.EffectiveToTimeKey>=@MocTimeKey)
							and bb.AccountEntityId is null


--------		PRINT 'INSERT IN ACCOUNT FOR LIVE'

				SELECT  @EntityKey=MAX(AC_KEY) FROM AdvAcBasicDetail

						INSERT INTO AdvAcBasicDetail 
								(
									Ac_Key
									,BranchCode
									,AccountEntityId
									,CustomerEntityId
									,SystemACID
									,CustomerACID
									,GLAlt_Key
									,ProductAlt_Key
									,GLProductAlt_Key
									,FacilityType
									,SectorAlt_Key
									,SubSectorAlt_Key
									,ActivityAlt_Key
									,IndustryAlt_Key
									,SchemeAlt_Key
									,DistrictAlt_Key
									,AreaAlt_Key
									,VillageAlt_Key
									,StateAlt_Key
									,CurrencyAlt_Key
									,OriginalSanctionAuthAlt_Key
									,OriginalLimitRefNo
									,OriginalLimit
									,OriginalLimitDt
									,Pref_InttRate
									,CurrentLimitRefNo
									----,ProcessingFeeApplicable
									----,ProcessingFeeAmt
									----,ProcessingFeeRecoveryAmt
									,GuaranteeCoverAlt_Key
									,AccountName
									----,ReferencePeriod
									,AssetClass
									----,D2K_REF_NO
									----,InttAppFreq
									,JointAccount
									,LastDisbDt
									,ScrCrErrorBackup
									,AccountOpenDate
									,Ac_LADDt
									,Ac_DocumentDt
									,CurrentLimit
									,InttTypeAlt_Key
									,InttRateLoadFactor
									,Margin
									----,TwentyPointReference
									----,BSR1bCode
									,CurrentLimitDt
									,Ac_DueDt
									,DrawingPowerAlt_Key
									,RefCustomerId
									----,D2KACID
									,AuthorisationStatus
									,EffectiveFromTimeKey
									,EffectiveToTimeKey
									,CreatedBy
									,DateCreated
									,ModifiedBy
									,DateModified
									,ApprovedBy
									,DateApproved							
									,MocStatus
									,MocDate
									,MocTypeAlt_Key
									,IsLAD
									--,FacilitiesNo
									,FincaleBasedIndustryAlt_key
									,AcCategoryAlt_Key
									,OriginalSanctionAuthLevelAlt_Key
									,AcTypeAlt_Key
									,ScrCrErrorSeq
									--,D2k_OLDAscromID
									,BSRUNID
									,AdditionalProv
									,ProjectCost
									,DtofFirstDisb
									----,EmpCode
									,FlagReliefWavier
									,UnderLineActivityAlt_Key
									,MicroCredit
									,segmentcode
									,ScrCrError
									,AdjDt
									,AdjReasonAlt_Key
									,MarginType
									,AclattestDevelopment
									,SourceAlt_Key
									,LoanSeries
									,LoanRefNo
									,SecuritizationCode
									,Full_Disb
									,OriginalBranchcode
								)
						--declare @MocTimeKey int =4383						
							SELECT 
									@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
									,BranchCode
									,AccountEntityId
									,CustomerEntityId
									,SystemACID
									,CustomerACID
									,GLAlt_Key
									,ProductAlt_Key
									,GLProductAlt_Key
									,FacilityType
									,SectorAlt_Key
									,SubSectorAlt_Key
									,ActivityAlt_Key
									,IndustryAlt_Key
									,SchemeAlt_Key
									,DistrictAlt_Key
									,AreaAlt_Key
									,VillageAlt_Key
									,StateAlt_Key
									,CurrencyAlt_Key
									,OriginalSanctionAuthAlt_Key
									,OriginalLimitRefNo
									,OriginalLimit
									,OriginalLimitDt
									,Pref_InttRate
									,CurrentLimitRefNo
									----,ProcessingFeeApplicable
									----,ProcessingFeeAmt
									----,ProcessingFeeRecoveryAmt
									,GuaranteeCoverAlt_Key
									,AccountName
									----,ReferencePeriod
									,AssetClass
									----,D2K_REF_NO
									----,InttAppFreq
									,JointAccount
									,LastDisbDt
									,ScrCrErrorBackup
									,AccountOpenDate
									,Ac_LADDt
									,Ac_DocumentDt
									,CurrentLimit
									,InttTypeAlt_Key
									,InttRateLoadFactor
									,Margin
									----,TwentyPointReference
									----,BSR1bCode
									,CurrentLimitDt
									,Ac_DueDt
									,DrawingPowerAlt_Key
									,RefCustomerId
									----,D2KACID
									,AuthorisationStatus
									,@MocTimeKey+1 EffectiveFromTimeKey
									,EffectiveToTimeKey
									,CreatedBy
									,DateCreated
									,ModifiedBy
									,DateModified
									,ApprovedBy
									,DateApproved							
									,MocStatus
									,MocDate
									,MocTypeAlt_Key
									,IsLAD
									--,FacilitiesNo
									,FincaleBasedIndustryAlt_key
									,AcCategoryAlt_Key
									,OriginalSanctionAuthLevelAlt_Key
									,AcTypeAlt_Key
									,ScrCrErrorSeq
									---,D2k_OLDAscromID
									,BSRUNID
									,AdditionalProv
									,ProjectCost
									,DtofFirstDisb
									----,EmpCode
									,FlagReliefWavier
									,UnderLineActivityAlt_Key
									,MicroCredit
									,segmentcode
									,ScrCrError
									,AdjDt
									,AdjReasonAlt_Key
									,MarginType
									,AclattestDevelopment
									,SourceAlt_Key
									,LoanSeries
									,LoanRefNo
									,SecuritizationCode
									,Full_Disb
									,OriginalBranchcode
							FROM #AccountBasic
							WHERE EffectiveToTimeKey>@MocTimeKey




/****************************************************/
/*	ADVACFINANCIALDETAIL TABLE	*/
	
	DROP TABLE IF EXISTS #AdvAcFin
	SELECT F.*
	INTO #AdvAcFin
	FROM AdvAcFinancialDetail F
	INNER JOIN #AcDataMoc B
			ON (F.EffectiveFromTimeKey<=@MocTimeKey AND F.EffectiveToTimeKey>=@MocTimeKey)
			AND F.AccountEntityId=B.AccountEntityId
		--AND F.AccountEntityId = S.AccountEntityId
		WHERE ISNULL(F.NpaDt,'1900-01-01') <> ISNULL(B.NpaDate,'1900-01-01') 


				SELECT  @EntityKey=MAX(ENTITYKEY) FROM PREMOC.AdvAcFinancialDetail

			INSERT INTO PREMOC.AdvAcFinancialDetail
							(
								ENTITYKEY
								, AccountEntityId
								,Ac_LastReviewDueDt
								,Ac_ReviewTypeAlt_key
								,Ac_ReviewDt
								,Ac_ReviewAuthAlt_Key
								,Ac_NextReviewDueDt
								,DrawingPower
								,InttRate
								----,IrregularType
								----,IrregularityDt
								,NpaDt
								,BookDebts
								,UnDrawnAmt
								----,TotalDI
								----,UnAppliedIntt
								----,LegalExp
								,UnAdjSubSidy
								,LastInttRealiseDt
								,MocStatus
								,MOCReason
								----,WriteOffAmt_HO
								----,InterestRateCodeAlt_Key
								----,WriteOffDt
								----,OD_Dt
								,LimitDisbursed
								----,WriteOffAmt_BR
								,RefCustomerId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,CreatedBy
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								
								,MocDate
								,MocTypeAlt_Key
								,CropDuration
								,Ac_ReviewAuthLevelAlt_Key
							)

						SELECT
								 @EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								 ,T.AccountEntityId
								,T.Ac_LastReviewDueDt
								,T.Ac_ReviewTypeAlt_key
								,T.Ac_ReviewDt
								,T.Ac_ReviewAuthAlt_Key
								,T.Ac_NextReviewDueDt
								,T.DrawingPower
								,T.InttRate
								----,T.IrregularType
								----,T.IrregularityDt
								,T.NpaDt
								,T.BookDebts
								,T.UnDrawnAmt
								----,T.TotalDI
								----,T.UnAppliedIntt
								----,T.LegalExp
								,T.UnAdjSubSidy
								,T.LastInttRealiseDt
								,'Y' MocStatus
								,T.MOCReason
								----,T.WriteOffAmt_HO
								----,T.InterestRateCodeAlt_Key
								----,T.WriteOffDt
								----,T.OD_Dt
								,T.LimitDisbursed
								----,T.WriteOffAmt_BR
								,T.RefCustomerId
								,T.RefSystemAcId
								,T.AuthorisationStatus
								,@MocTimeKey EffectiveFromTimeKey
								,@MocTimeKey EffectiveToTimeKey
								,T.CreatedBy
								,T.DateCreated
								,T.ModifiedBy
								,T.DateModified
								,T.ApprovedBy
								,T.DateApproved
								,GETDATE() MocDate
								,T.MocTypeAlt_Key
								,T.CropDuration
								,T.Ac_ReviewAuthLevelAlt_Key
						 FROM #AdvAcFin T
							LEFT JOIN PREMOC.AdvAcFinancialDetail PRE
								ON (PRE.EffectiveFromTimeKey<=@MocTimeKey AND PRE.EffectiveToTimeKey>=@MocTimeKey)
								AND PRE.AccountEntityId=T.AccountEntityId
							WHERE PRE.AccountEntityId IS NULL



				UPDATE ACFD SET
					ACFD.EffectiveToTimeKey =@MocTimeKey -1 
				FROM AdvAcFinancialDetail ACFD
					INNER JOIN #AdvAcFin T						
						ON ACFD.AccountEntityId=T.AccountEntityId
						AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
					WHERE ACFD.EffectiveFromTimeKey<@MocTimeKey


				DELETE ACFD 
					FROM AdvAcFinancialDetail ACFD
						INNER JOIN #AdvAcFin T						
							ON ACFD.AccountEntityId=T.AccountEntityId
							AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
						WHERE ACFD.EffectiveFromTimeKey=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey


PRINT 'UPDATE RECORED FOR CURRENT TIME KEY'

					UPDATE ACFD SET
						ModifiedBy=@CrModApBy
						,DateModified=getdate()
						,MocStatus='Y'
						,MocDate=GetDate() 
						,MocTypeAlt_Key=210 
						,ACFD.NpaDt=BB.NpaDate
				 FROM AdvAcFinancialDetail ACFD
					INNER JOIN #AdvAcFin T						
						ON ACFD.AccountEntityId = T.AccountEntityId
						AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
					inner join #AcDataMoc  bb
						ON BB.AccountEntityId=T.AccountEntityId
					WHERE ACFD.EffectiveFromTimeKey=@MocTimeKey AND ACFD.EffectiveToTimeKey=@MocTimeKey		
		 

		PRINT 'Insert data for Current TimeKey'	 

				SELECT  @EntityKey=MAX(ENTITYKEY) FROM AdvAcFinancialDetail
			
							INSERT INTO AdvAcFinancialDetail
										(
											ENTITYKEY
											,AccountEntityId
											,Ac_LastReviewDueDt
											,Ac_ReviewTypeAlt_key
											,Ac_ReviewDt
											,Ac_ReviewAuthAlt_Key
											,Ac_NextReviewDueDt
											,DrawingPower
											,InttRate
											----,IrregularType
											----,IrregularityDt
											,NpaDt
											,BookDebts
											,UnDrawnAmt
											----,TotalDI
											----,UnAppliedIntt
											----,LegalExp
											,UnAdjSubSidy
											,LastInttRealiseDt
											,MocStatus
											,MOCReason
											----,WriteOffAmt_HO
											----,InterestRateCodeAlt_Key
											----,WriteOffDt
											----,OD_Dt
											,LimitDisbursed
											----,WriteOffAmt_BR
											,RefCustomerId
											,RefSystemAcId
											,AuthorisationStatus
											,EffectiveFromTimeKey
											,EffectiveToTimeKey
											,CreatedBy
											,DateCreated
											,ModifiedBy
											,DateModified
											,ApprovedBy
											,DateApproved
											,MocDate
											,MocTypeAlt_Key
											,CropDuration
											,Ac_ReviewAuthLevelAlt_Key
										)
													
									
															
									SELECT	@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
												,A.AccountEntityId
											,A.Ac_LastReviewDueDt
											,A.Ac_ReviewTypeAlt_key
											,A.Ac_ReviewDt
											,A.Ac_ReviewAuthAlt_Key
											,A.Ac_NextReviewDueDt
											,A.DrawingPower
											,A.InttRate
											----,IrregularType
											----,IrregularityDt
											,T.NpaDate
											,A.BookDebts
											,A.UnDrawnAmt
											----,TotalDI
											----,UnAppliedIntt
											----,LegalExp
											,A.UnAdjSubSidy
											,A.LastInttRealiseDt
											,'Y' MocStatus
											,A.MOCReason
											----,WriteOffAmt_HO
											----,InterestRateCodeAlt_Key
											----,WriteOffDt
											----,OD_Dt
											,A.LimitDisbursed
											----,WriteOffAmt_BR
											,A.RefCustomerId
											,A.RefSystemAcId
											,A.AuthorisationStatus
											,@MocTimeKey	EffectiveFromTimeKey
											,@MocTimeKey	EffectiveToTimeKey
											,A.CreatedBy
											,A.DateCreated
											,A.ModifiedBy
											,A.DateModified
											,A.ApprovedBy
											,A.DateApproved
											,GETDATE() MocDate
											,A.MocTypeAlt_Key
											,A.CropDuration
											,A.Ac_ReviewAuthLevelAlt_Key
									FROM #AdvAcFin A
										INNER JOIN #AcDataMoc T
											ON A.AccountEntityId = T.AccountEntityId
										LEFT JOIN AdvAcFinancialDetail O
											ON(O.EffectiveFromTimeKey=@MocTimeKey AND O.EffectiveToTimeKey=@MocTimeKey)
											AND O.AccountEntityId=A.AccountEntityId
								WHERE o.AccountEntityId IS NULL


						PRINT 'Insert data for live TimeKey'
						SELECT  @EntityKey=MAX(ENTITYKEY) FROM PREMOC.AdvAcFinancialDetail

						INSERT INTO AdvAcFinancialDetail
									(
											EntityKey
											,AccountEntityId
											,Ac_LastReviewDueDt
											,Ac_ReviewTypeAlt_key
											,Ac_ReviewDt
											,Ac_ReviewAuthAlt_Key
											,Ac_NextReviewDueDt
											,DrawingPower
											,InttRate
											----,IrregularType
											----,IrregularityDt
											,NpaDt
											,BookDebts
											,UnDrawnAmt
											----,TotalDI
											----,UnAppliedIntt
											----,LegalExp
											,UnAdjSubSidy
											,LastInttRealiseDt
											,MocStatus
											,MOCReason
											----,WriteOffAmt_HO
											----,InterestRateCodeAlt_Key
											----,WriteOffDt
											----,OD_Dt
											,LimitDisbursed
											----,WriteOffAmt_BR
											,RefCustomerId
											,RefSystemAcId
											,AuthorisationStatus
											,EffectiveFromTimeKey
											,EffectiveToTimeKey
											,CreatedBy
											,DateCreated
											,ModifiedBy
											,DateModified
											,ApprovedBy
											,DateApproved
											,MocDate
											,MocTypeAlt_Key
											,CropDuration
											,Ac_ReviewAuthLevelAlt_Key
									)
												
								
												
								SELECT 
										   @EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
										   ,AccountEntityId
											,Ac_LastReviewDueDt
											,Ac_ReviewTypeAlt_key
											,Ac_ReviewDt
											,Ac_ReviewAuthAlt_Key
											,Ac_NextReviewDueDt
											,DrawingPower
											,InttRate
											--,IrregularType
											----,IrregularityDt
											,NpaDt
											,BookDebts
											,UnDrawnAmt
											----,TotalDI
											----,UnAppliedIntt
											----,LegalExp
											,UnAdjSubSidy
											,LastInttRealiseDt
											,MocStatus
											,MOCReason
											----,WriteOffAmt_HO
											----,InterestRateCodeAlt_Key
											----,WriteOffDt
											----,OD_Dt
											,LimitDisbursed
											----,WriteOffAmt_BR
											,RefCustomerId
											,RefSystemAcId
											,AuthorisationStatus
											,@MocTimeKey +1  EffectiveFromTimeKey
											,EffectiveToTimeKey
											,CreatedBy
											,DateCreated
											,ModifiedBy
											,DateModified
											,ApprovedBy
											,DateApproved
											,MocDate
											,MocTypeAlt_Key
											,CropDuration
											,Ac_ReviewAuthLevelAlt_Key
									FROM #AdvAcFin T
									WHERE T.EffectiveToTimeKey>@MocTimeKey	

/****************************************************/
/*	AdvAcOtherDetail TABLE	*/
	
	DROP TABLE IF EXISTS #FITL_CHANGE  ---755 FUNDED INTEREST TERM LOAN
	SELECT A.AccountEntityId,B.RefSystemAcId,B.FlgFitl
	INTO #FITL_cHANGE
	FROM PreMoc.ACCOUNTCAL A
	INNER JOIN #AcDataMoc B
			ON (A.EffectiveFromTimeKey=@MocTimeKey AND A.EffectiveToTimeKey=@MocTimeKey)
			AND B.AccountEntityId=B.AccountEntityId
		where ISNULL(a.FlgFitl,'A')<>ISNULL(b.FlgFitl,'A')		


	DROP table if exists #AccOth

	SELECT A.* INTO #AccOth
		FROM AdvAcOtherDetail A
			INNER JOIN #FITL_cHANGE B
				ON A.AccountEntityId=B.AccountEntityId
				AND (A.EffectiveFromTimeKey=@MocTimeKey AND A.EffectiveToTimeKey=@MocTimeKey)


			SELECT @EntityKey=MAX(ENTITYKEY) FROM PREMOC.AdvAcOtherDetail

		INSERT INTO PREMOC.AdvAcOtherDetail
							(
								EntityKey
								,AccountEntityId
								,GovGurAmt
								,SplCatg1Alt_Key
								,SplCatg2Alt_Key
								,RefinanceAgencyAlt_Key
								,RefinanceAmount
								,BankAlt_Key
								,TransferAmt
								,ProjectId
								,ConsortiumId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,CreatedBy
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								,MocStatus
								,MocDate
								,SplCatg3Alt_Key
								,SplCatg4Alt_Key
								,MocTypeAlt_Key
								,GovGurExpDt
								---,SplFlag							
							)

						SELECT
								@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								,A.AccountEntityId
								,A.GovGurAmt
								,A.SplCatg1Alt_Key
								,A.SplCatg2Alt_Key
								,A.RefinanceAgencyAlt_Key
								,A.RefinanceAmount
								,A.BankAlt_Key
								,A.TransferAmt
								,A.ProjectId
								,A.ConsortiumId
								,A.RefSystemAcId
								,A.AuthorisationStatus
								,@MocTimeKey EffectiveFromTimeKey
								,@MocTimeKey EffectiveToTimeKey
								,A.CreatedBy
								,A.DateCreated
								,A.ModifiedBy
								,A.DateModified
								,A.ApprovedBy
								,A.DateApproved
								,'Y' MocStatus
								,GETDATE() MocDate
								,A.SplCatg3Alt_Key
								,A.SplCatg4Alt_Key
								,A.MocTypeAlt_Key
								,A.GovGurExpDt
								---,SplFlag		
						FROM #AccOth A
							LEFT JOIN PREMOC.AdvAcOtherDetail B
								ON (B.EffectiveFromTimeKey<=@TimeKey AND B.EffectiveToTimeLey>=@TimeKey)
								AND a.AccountEntityId=B.AccountEntityID
							WHERE B.AccountEntityId IS NULL


				UPDATE ACFD SET
					ACFD.EffectiveToTimeKey =@MocTimeKey -1 
				FROM AdvAcOtherDetail ACFD
					INNER JOIN #AccOth T						
						ON ACFD.AccountEntityId=T.AccountEntityId
						AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
					WHERE ACFD.EffectiveFromTimeKey<@MocTimeKey


				DELETE ACFD 
					FROM AdvAcOtherDetail ACFD
						INNER JOIN #AccOth T						
							ON ACFD.AccountEntityId=T.AccountEntityId
							AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
						WHERE ACFD.EffectiveFromTimeKey=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey


					PRINT 'UPDATE RECORED FOR CURRENT TIME KEY'

					UPDATE ACFD SET
						ModifiedBy=@CrModApBy
						,DateModified=getdate()
						,MocStatus='Y'
						,MocDate=GetDate() 
						,MocTypeAlt_Key=210 
						,ACFD.SplCatg4Alt_Key=755
				 FROM AdvAcOtherDetail ACFD
					INNER JOIN #AccOth T						
						ON ACFD.AccountEntityId = T.AccountEntityId
						AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
					inner join #AcDataMoc  bb
						ON BB.AccountEntityId=T.AccountEntityId
						AND BB.FlgFITL='Y'
					WHERE ACFD.EffectiveFromTimeKey=@MocTimeKey AND ACFD.EffectiveToTimeKey=@MocTimeKey		
					 
					UPDATE ACFD SET
						ModifiedBy=@CrModApBy
						,DateModified=getdate()
						,MocStatus='Y'
						,MocDate=GetDate() 
						,MocTypeAlt_Key=210 
						,ACFD.SplCatg1Alt_Key= CASE WHEN  ACFD.SplCatg1Alt_Key=755 THEN NULL ELSE ACFD.SplCatg1Alt_Key END			
						,ACFD.SplCatg2Alt_Key= CASE WHEN  ACFD.SplCatg2Alt_Key=755 THEN NULL ELSE ACFD.SplCatg2Alt_Key END			
						,ACFD.SplCatg3Alt_Key= CASE WHEN  ACFD.SplCatg3Alt_Key=755 THEN NULL ELSE ACFD.SplCatg3Alt_Key END			
						,ACFD.SplCatg4Alt_Key= CASE WHEN  ACFD.SplCatg4Alt_Key=755 THEN NULL ELSE ACFD.SplCatg4Alt_Key END			
					FROM AdvAcOtherDetail ACFD
					INNER JOIN #AccOth T						
						ON ACFD.AccountEntityId = T.AccountEntityId
						AND (ACFD.EffectiveFromTimeKey<=@MocTimeKey AND ACFD.EffectiveToTimeKey>=@MocTimeKey)
					inner join #AcDataMoc  bb
						ON BB.AccountEntityId=T.AccountEntityId
						AND BB.FlgFITL='N'
					WHERE ACFD.EffectiveFromTimeKey=@MocTimeKey AND ACFD.EffectiveToTimeKey=@MocTimeKey		

		
		
		PRINT 'Insert data for Current TimeKey'	 
			SELECT @EntityKey=MAX(ENTITYKEY) FROM AdvAcOtherDetail
			
						INSERT INTO AdvAcOtherDetail
							(
								EntityKey
								,AccountEntityId
								,GovGurAmt
								,SplCatg1Alt_Key
								,SplCatg2Alt_Key
								,RefinanceAgencyAlt_Key
								,RefinanceAmount
								,BankAlt_Key
								,TransferAmt
								,ProjectId
								,ConsortiumId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,CreatedBy
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								,MocStatus
								,MocDate
								,SplCatg3Alt_Key
								,SplCatg4Alt_Key
								,MocTypeAlt_Key
								,GovGurExpDt
								---,SplFlag							
							)

						SELECT
								@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								,T.AccountEntityId
								,A.GovGurAmt
								,A.SplCatg1Alt_Key
								,A.SplCatg2Alt_Key
								,A.RefinanceAgencyAlt_Key
								,A.RefinanceAmount
								,A.BankAlt_Key
								,A.TransferAmt
								,A.ProjectId
								,A.ConsortiumId
								,T.RefSystemAcId
								,A.AuthorisationStatus
								,@MocTimeKey EffectiveFromTimeKey
								,@MocTimeKey EffectiveToTimeKey
								,A.CreatedBy
								,A.DateCreated
								,A.ModifiedBy
								,A.DateModified
								,A.ApprovedBy
								,A.DateApproved
								,'Y' MocStatus
								,GETDATE() MocDate
								,A.SplCatg3Alt_Key
								,755 SplCatg4Alt_Key
								,A.MocTypeAlt_Key
								,A.GovGurExpDt
								---,SplFlag		
						FROM #FITL_CHANGE T
							LEFT JOIN #AccOth A
								ON T.AccountEntityID =A.AccountEntityId
							LEFT JOIN AdvAcOtherDetail B
								ON (B.EffectiveFromTimeKey=@TimeKey AND B.EffectiveToTimeKey=@TimeKey)
								AND a.AccountEntityId=B.AccountEntityID
							WHERE B.AccountEntityId IS NULL
								AND T.FlgFITL='Y'


						PRINT 'Insert data for live TimeKey'

			SELECT @EntityKey=MAX(ENTITYKEY) FROM AdvAcOtherDetail

						INSERT INTO AdvAcOtherDetail
							(
								EntityKey
								,AccountEntityId
								,GovGurAmt
								,SplCatg1Alt_Key
								,SplCatg2Alt_Key
								,RefinanceAgencyAlt_Key
								,RefinanceAmount
								,BankAlt_Key
								,TransferAmt
								,ProjectId
								,ConsortiumId
								,RefSystemAcId
								,AuthorisationStatus
								,EffectiveFromTimeKey
								,EffectiveToTimeKey
								,CreatedBy
								,DateCreated
								,ModifiedBy
								,DateModified
								,ApprovedBy
								,DateApproved
								,MocStatus
								,MocDate
								,SplCatg3Alt_Key
								,SplCatg4Alt_Key
								,MocTypeAlt_Key
								,GovGurExpDt
								---,SplFlag							
							)

						SELECT
								 @EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
								,A..AccountEntityId
								,A.GovGurAmt
								,A.SplCatg1Alt_Key
								,A.SplCatg2Alt_Key
								,A.RefinanceAgencyAlt_Key
								,A.RefinanceAmount
								,A.BankAlt_Key
								,A.TransferAmt
								,A.ProjectId
								,A.ConsortiumId
								,A.RefSystemAcId
								,A.AuthorisationStatus
								,@MocTimeKey+ EffectiveFromTimeKey
								,A.EffectiveToTimeKey
								,A.CreatedBy
								,A.DateCreated
								,A.ModifiedBy
								,A.DateModified
								,A.ApprovedBy
								,A.DateApproved
								,MocStatus
								,GETDATE() MocDate
								,A.SplCatg3Alt_Key
								,a.SplCatg4Alt_Key
								,A.MocTypeAlt_Key
								,A.GovGurExpDt
								---,SplFlag		
						FROM #AccOth A
							
									WHERE a.EffectiveToTimeKey>@MocTimeKey	



	/*	ExceptionalDegrationDetail	*/
		
		DROP TABLE IF EXISTS #ExcpSplFlgs
		select * into #ExcpSplFlgs
		from (
				select		 RefCustomerID CustomerID,CustomerACId,'Inherent Weakness'		SplFlg,WeakAccount			FlgValue, 0 as SplFlgAltKey,WeakAccountDate	 FlgDate FROM pro.ACCOUNTCAL
				UNION ALL select RefCustomerID CustomerID,CustomerACId,'SARFAESI'			SplFlg,Sarfaesi			FlgValue, 0 as SplFlgAltKey,SarfaesiDate		 FlgDate FROM pro.ACCOUNTCAL
				UNION ALL select RefCustomerID CustomerID,CustomerACId,'Unusual Bounce'		SplFlg,FlgUnusualBounce    FlgValue, 0 as SplFlgAltKey,UnusualBounceDate	 FlgDate FROM pro.ACCOUNTCAL
				UNION ALL select RefCustomerID CustomerID,CustomerACId,'Uncleared Effect'	SplFlg,FlgUnClearedEffect  FlgValue, 0 as SplFlgAltKey,UnClearedEffectDate FlgDate FROM pro.ACCOUNTCAL
				UNION ALL select RefCustomerID CustomerID,CustomerACId,'Repossesed'			SplFlg,RePossession		FlgValue, 0 as SplFlgAltKey,RepossessionDate	 FlgDate FROM pro.ACCOUNTCAL
				UNION ALL select RefCustomerID CustomerID,CustomerACId,'Fraud Committed'	 SplFlg,FlgFraud			FlgValue, 0 as SplFlgAltKey,FraudDate			 FlgDate FROM pro.ACCOUNTCAL
			)	A												

		UPDATE A
			SET SplFlgAltKey=b.ParameterAlt_Key
		FROM #ExcpSplFlgs A
			INNER JOIN  DimParameter B
				ON DimParameterName='UploadFLagType'
				AND (B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey)
				and B.ParameterShortName=A.SplFlg

	/* DELETE MATCHED RECORDS WITH FLG AND DATE */
	DELETE B 
	FROM ExceptionalDegrationDetail A
		INNER JOIN #ExcpSplFlgs B
			ON  (A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey)
			AND A.CUSTOMERID=B.CUSTOMERID
			AND A.ACCOUNTID=B.CustomerAcID
			AND A.FlagAlt_Key=B.SplFlgAltKey
			and b.FlgValue='Y'
			AND ISNULL(A.Date,'1900-01-01')=ISNULL(B.FlgDate,'1900-01-01')
	

		/* DELETE MATCHED RECORDS WITH FLG AND DATE */
	drop table if exists #ActionData

	SELECT B.CustomerID,B.CustomerAcID, B.SplFlgAltKey,B.FlgDate,B.FlgValue,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
		,A.CreatedBy,A.DateCreated,A.ModifiedBy,A.DateModified,A.ApprovedBy,A.DateApproved,A.MarkingAlt_Key,A.Amount
		,'DateChange'  ActionType
		into #ActionData
	FROM ExceptionalDegrationDetail A
		INNER JOIN #ExcpSplFlgs B
			ON  (A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey)
			AND A.CUSTOMERID=B.CUSTOMERID
			AND A.ACCOUNTID=B.CustomerAcID
			AND A.FlagAlt_Key=B.SplFlgAltKey
			and b.FlgValue='Y'
			AND ISNULL(A.Date,'1900-01-01')<>ISNULL(B.FlgDate,'1900-01-01')

	INSERT INTO #ActionData
	SELECT B.CustomerID,B.CustomerAcID, B.SplFlgAltKey,B.FlgDate,B.FlgValue,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
		,A.CreatedBy,A.DateCreated,A.ModifiedBy,A.DateModified,A.ApprovedBy,A.DateApproved,A.MarkingAlt_Key,A.Amount
		,'NewTobeAdd'  ActionType
	FROM #ExcpSplFlgs b
		left JOIN ExceptionalDegrationDetail a
			ON  (A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey)
			AND A.CUSTOMERID=B.CUSTOMERID
			AND A.ACCOUNTID=B.CustomerAcID
			AND A.FlagAlt_Key=B.SplFlgAltKey
			where b.FlgValue='Y'
				and A.CustomerID is null
	
	INSERT INTO #ActionData
	SELECT B.CustomerID,B.CustomerAcID, B.SplFlgAltKey,B.FlgDate,B.FlgValue,A.EffectiveFromTimeKey,A.EffectiveToTimeKey
		,A.CreatedBy,A.DateCreated,A.ModifiedBy,A.DateModified,A.ApprovedBy,A.DateApproved,A.MarkingAlt_Key,A.Amount
		,'ToBeRemoved'  ActionType
	FROM #ExcpSplFlgs b
		inner JOIN ExceptionalDegrationDetail a
			ON  (A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey)
			AND A.CUSTOMERID=B.CUSTOMERID
			AND A.ACCOUNTID=B.CustomerAcID
			AND A.FlagAlt_Key=B.SplFlgAltKey
			where b.FlgValue='N'
			
	
	drop table if exists #DateChange
	select A.* into  #OrgData
	FROM ExceptionalDegrationDetail  A
		INNER JOIN #ActionData B
			ON  (A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey)
			AND A.CUSTOMERID=B.CUSTOMERID
			AND A.ACCOUNTID=B.CustomerAcID
			AND A.FlagAlt_Key=B.SplFlgAltKey
		WHERE b.ActionType in('DateChange' ,'ToBeRemoved') 
		

			SELECT @EntityKey=MAX(Entity_Key) FROM PREMOC.ExceptionalDegrationDetail

	INSERT INTO PREMOC.ExceptionalDegrationDetail
		(
			Entity_Key
			,DegrationAlt_Key
			,SourceAlt_Key
			,AccountID
			,CustomerID
			,FlagAlt_Key
			,Date
			,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,MarkingAlt_Key
			,Amount
		
		)
	SELECT 
			@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
			,DegrationAlt_Key
			,A.SourceAlt_Key
			,A.AccountID
			,A.CustomerID
			,A.FlagAlt_Key
			,A.Date
			,A.AuthorisationStatus
			,@MocTimeKey EffectiveFromTimeKey
			,@MocTimeKey EffectiveToTimeKey
			,A.CreatedBy
			,A.DateCreated
			,A.ModifiedBy
			,A.DateModified
			,A.ApprovedBy
			,A.DateApproved
			,A.MarkingAlt_Key
			,A.Amount
		FROM #OrgData A
			LEFT JOIN PREMOC.ExceptionalDegrationDetail B
				ON (B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey)
				and A.CustomerID =B.CustomerID
				AND a.AccountID=B.AccountID
				AND a.FlagAlt_Key=b.FlagAlt_Key
		WHERE B.CustomerID IS NULL


		UPDATE  B
			SET EffectiveToTimeKey=@MocTimeKey-1
		FROM ExceptionalDegrationDetail B
			INNER JOIN #ActionData T
				ON (B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey)
				AND B.EffectiveFromTimeKey<@MocTimeKey
				and T.CustomerID =B.CustomerID
				AND T.CustomerAcID=B.AccountID
				AND T.SplFlgAltKey=b.FlagAlt_Key
			WHERE ActionType IN('DateChange' ,'ToBeRemoved') 	
		
		DELETE B
		FROM ExceptionalDegrationDetail B
			INNER JOIN #ActionData T
				ON (B.EffectiveFromTimeKey=@TimeKey and B.EffectiveToTimeKey>@TimeKey)
				AND B.EffectiveFromTimeKey<@MocTimeKey
				and T.CustomerID =B.CustomerID
				AND T.CustomerAcID=B.AccountID
				AND T.SplFlgAltKey=b.FlagAlt_Key
			WHERE ActionType IN('DateChange' ,'ToBeRemoved') 	


		UPDATE B
			SET B.Date=T.FlgDate
		FROM ExceptionalDegrationDetail B
			INNER JOIN #ActionData T
				ON (B.EffectiveFromTimeKey=@TimeKey and B.EffectiveToTimeKey=@TimeKey)
				AND B.EffectiveFromTimeKey<@MocTimeKey
				and T.CustomerID =B.CustomerID
				AND T.CustomerAcID=B.AccountID
				AND T.SplFlgAltKey=b.FlagAlt_Key
			WHERE ActionType IN('DateChang') 	


		---- MOC TIMEEY INSERT

			SELECT @EntityKey=MAX(Entity_Key) FROM ExceptionalDegrationDetail

		INSERT INTO ExceptionalDegrationDetail
			(
			Entity_Key
			,DegrationAlt_Key
			,SourceAlt_Key
			,AccountID
			,CustomerID
			,FlagAlt_Key
			,Date
			,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,MarkingAlt_Key
			,Amount
		
		)
	SELECT 
			@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
			,DegrationAlt_Key
			,B.SourceAlt_Key
			,A.CustomerAcID AccountID
			,A.CustomerID
			,A.SplFlgAltKey FlagAlt_Key
			,A.FlgDate Date
			,NULL AuthorisationStatus
			,@MocTimeKey EffectiveFromTimeKey
			,@MocTimeKey EffectiveToTimeKey
			,A.CreatedBy
			,A.DateCreated
			,A.ModifiedBy
			,A.DateModified
			,A.ApprovedBy
			,A.DateApproved
			,A.MarkingAlt_Key
			,A.Amount
		FROM #ActionData A
			LEFT JOIN ExceptionalDegrationDetail B
				ON (B.EffectiveFromTimeKey=@TimeKey and B.EffectiveToTimeKey>=@TimeKey)
				and A.CustomerID =B.CustomerID
				AND a.CustomerAcID=B.AccountID
				AND a.SplFlgAltKey=b.FlagAlt_Key
		WHERE B.CustomerID IS NULL
			AND A.FlgValue ='Y'


	/* INSERT DATA ON FUTURE TIMEKEY */
			SELECT @EntityKey=MAX(Entity_Key) FROM ExceptionalDegrationDetail

		INSERT INTO ExceptionalDegrationDetail
		(
			Entity_Key
			,DegrationAlt_Key
			,SourceAlt_Key
			,AccountID
			,CustomerID
			,FlagAlt_Key
			,Date
			,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,MarkingAlt_Key
			,Amount
		
		)
	SELECT 
			@EntityKey+ROW_NUMBER() OVER( ORDER BY (SELECT 1) ) EntityKey
			,DegrationAlt_Key
			,A.SourceAlt_Key
			,A.AccountID
			,A.CustomerID
			,A.FlagAlt_Key
			,A.Date
			,A.AuthorisationStatus
			,@MocTimeKey+1 EffectiveFromTimeKey
			,@MocTimeKey EffectiveToTimeKey
			,A.CreatedBy
			,A.DateCreated
			,A.ModifiedBy
			,A.DateModified
			,A.ApprovedBy
			,A.DateApproved
			,A.MarkingAlt_Key
			,A.Amount
		FROM #OrgData A
		WHERE A.EffectiveToTimeKey>@MocTimeKey



	SET @Result=1
				
				COMMIT TRAN
				Return @Result
END TRY 

BEGIN CATCH
	ROLLBACK TRAN
	SELECT ERROR_LINE(),ERROR_MESSAGE()
	SET @Result=-1
	RETURN @Result
END CATCH
		        













GO
