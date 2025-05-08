SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE  [dbo].[Pro_CategoryUpload_InUp_05022022]
	@Timekey INT,
	@UserLoginID VARCHAR(100),
	@OperationFlag INT,
	@MenuId INT,
	@AuthMode	CHAR(1),
	@filepath VARCHAR(MAX),
	@EffectiveFromTimeKey INT,
	@EffectiveToTimeKey	INT,
    @Result		INT=0 OUTPUT,
	@UniqueUploadID INT 

AS

--DECLARE @Timekey INT=25999,
--	@UserLoginID VARCHAR(100)=N'fnachecker',
--	@OperationFlag INT=N'1',
--	@MenuId INT=N'1468',
--	@AuthMode	CHAR(1)=N'N',
--	@filepath VARCHAR(MAX)=N'ProvisionCategoryUpload (1).xlsx',
--	@EffectiveFromTimeKey INT=25999,
--	@EffectiveToTimeKey	INT=49999,
--    @Result		INT=0 ,
--	@UniqueUploadID INT=NULL
BEGIN
SET DATEFORMAT DMY
	SET NOCOUNT ON;

   
   --DECLARE @Timekey INT
   --SET @Timekey=(SELECT MAX(TIMEKEY) FROM dbo.SysProcessingCycle
			--	WHERE ProcessType='Quarterly')

			SET @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
							Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
							 where A.CurrentStatus='C')

	PRINT @TIMEKEY

	SET @EffectiveFromTimeKey=@TimeKey
	SET @EffectiveToTimeKey=49999

	----declare @UserLoginID VARCHAR(100)=N'fnachecker',@filepath VARCHAR(MAX)=N'ProvisionCategoryUpload (1).xlsx'
	DECLARE @FilePathUpload	VARCHAR(100)
				   SET @FilePathUpload=@UserLoginId+'_'+@filepath
					PRINT '@FilePathUpload'
					PRINT @FilePathUpload
					--fnachecker_ProvisionCategoryUpload (1).xlsx
		BEGIN TRY

		--BEGIN TRAN
		
IF (@MenuId=1468)
BEGIN

	IF (@OperationFlag=1)

	BEGIN
	--select * from categorydetails_stg filname

		IF NOT (EXISTS (SELECT 1 FROM categorydetails_stg  where filname=@FilePathUpload))
		
							BEGIN
                           --Rollback tran
									SET @Result=-8
									print 'an'
								print '123'
								RETURN @Result
						END

--select * from ExcelUploadHistory
		IF EXISTS(SELECT 1 FROM categorydetails_stg WHERE filname=@FilePathUpload)
		BEGIN
		print '321'
		INSERT INTO ExcelUploadHistory
	(
		UploadedBy	
		,DateofUpload	
		,AuthorisationStatus	
		--,Action	
		,UploadType
		,EffectiveFromTimeKey	
		,EffectiveToTimeKey	
		,CreatedBy	
		,DateCreated	
		
	)

	SELECT @UserLoginID
		   ,GETDATE()
		   ,'NP'
		   --,'NP'
		   ,'Provision Category Upload'
		   ,@EffectiveFromTimeKey
		   ,@EffectiveToTimeKey
		   ,@UserLoginID
		   ,GETDATE()

		   PRINT @@ROWCOUNT

		   DECLARE @ExcelUploadId INT
	SET 	@ExcelUploadId=(SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory)
		
			Insert into UploadStatus (FileNames,UploadedBy,UploadDateTime,UploadType)
		Values(@filepath,@UserLoginID ,GETDATE(),'Provision Category Upload')
 Print 'A'
		INSERT INTO AcCatUploadHistory_mod
		(    
SlNo
,UPLOADID
,ACID
,CustomerID
,CategoryID
,Action
			,AuthorisationStatus	
			,EffectiveFromTimeKey	
			,EffectiveToTimeKey	
			,CreatedBy	
			,DateCreated
	

		)

		SELECT
			SlNo
			,@ExcelUploadId
			       
            ,ACID
            ,CustomerID
            ,CategoryID
            ,Action
			,'NP'	
			,@Timekey
			,49999	
			,@UserLoginID
			,GETDATE()
			
			 
		FROM categorydetails_stg
		where FilName=@FilePathUpload
		/*
--------------------------------------------------Max percent
IF OBJECT_ID('TEMPDB..#EXISTDATA')IS NOT NULL
				DROP TABLE #EXISTDATA
				Declare @ProvisionPercent decimal(10,0)
								SELECT A.ACID
								, @ProvisionPercent=MAX(D.Provisionsecured)ProvisionPercent						
								--,d.provisionname
								 INTO #EXISTDATA	 
								 FROM categorydetails_stg A
								--INNER JOIN AdvAcBasicDetail B
								--			on B.CustomerAcId=A.acid
									INNER JOIN DimProvision_SegStd D
											ON A.CategoryID=D.BankCategoryID   
											group by A.ACID 

											--update STD_ProvDetail


	--				Select A.ACID,@ProvisionPercent=(case when A.ProvisionPercent>E.ProvisionPercent  then 1 else 0 end )from(																	
	--SELECT A.ACID, MAX(D.Provisionsecured)ProvisionPercent	 FROM AcCatUploadHistory A --
	--inner join  DimProvision_SegStd D on A.CategoryID=D.BankCategoryID  group by A.ACID
	--)A inner join  #EXISTDATA E on A.ACID=E.ACID

	--IF (@ProvisionPercent =1)
	--Begin
	*/
	
	--End






				
--------------------------------------------------------------------------------------

		--select * from categorydetails_stg
		--select * from AcCatUploadHistory
		--select * from DimProvision_SegStd
		--select ProvisionAlt_Key,* from STD_ProvDetail
/*
		Declare @SummaryId int
		Set @SummaryId=IsNull((Select Max(SummaryId) from IBPCPoolSummary_Mod),0)

		INSERT INTO IBPCPoolSummary_stg
		(
			UploadID
			,SummaryID
			,PoolID
			,PoolName
			,PoolType
			,BalanceOutstanding
			,NoOfAccount
			,IBPCExposureAmt
			,IBPCReckoningDate
			,IBPCMarkingDate
			,MaturityDate
			,TotalPosBalance
			,TotalInttReceivable
		)

		SELECT
			@ExcelUploadId
			,@SummaryId+Row_Number() over(Order by PoolID)
			,PoolID
			,PoolName
			,PoolType
			,Sum(IsNull(Cast(PrincipalOutstandinginRs as decimal(16,2)),0)+IsNull(Cast(InterestReceivableinRs as Decimal(16,2)),0))
			,Count(PoolID)
			,SUM(ISNULL(Cast(IBPCExposureinRs as Decimal(16,2)),0))
			,DateofIBPCreckoning
			,DateofIBPCmarking
			,MaturityDate
			,Sum(IsNull(Cast(PrincipalOutstandinginRs as decimal(16,2)),0))
			,Sum(IsNull(Cast(InterestReceivableinRs as Decimal(16,2)),0))
		FROM IBPCPoolDetail_stg
		where FilName=@FilePathUpload
		Group by PoolID,PoolName,PoolType,DateofIBPCreckoning,DateofIBPCmarking,MaturityDate

		--INSERT INTO IBPCPoolSummary_Mod
		--(
		--	UploadID
		--	,SummaryID
		--	,PoolID
		--	,PoolName
		--	,BalanceOutstanding
		--	,NoOfAccount
		--	,AuthorisationStatus	
		--	,EffectiveFromTimeKey	
		--	,EffectiveToTimeKey	
		--	,CreatedBy	
		--	,DateCreated	
		--)

		--SELECT
		--	@ExcelUploadId
		--	,@SummaryId+Row_Number() over(Order by PoolID)
		--	,PoolID
		--	,PoolName
		--	,Sum(IsNull(POS,0)+IsNull(InterestReceivable,0))
		--	,Count(PoolID)
		--	,'NP'	
		--	,@Timekey
		--	,49999	
		--	,@UserLoginID	
		--	,GETDATE()
		--FROM IBPCPoolDetail_stg
		--where FilName=@FilePathUpload
		--Group by PoolID,PoolName
*/
		PRINT @@ROWCOUNT
		
		---DELETE FROM STAGING DATA
		 DELETE FROM categorydetails_stg
		 WHERE FilName=@FilePathUpload

		 ----RETURN @ExcelUploadId

END
		   ----DECLARE @UniqueUploadID INT
	--SET 	@UniqueUploadID=(SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory)
	END
	
	IF (@OperationFlag=16)----AUTHORIZE

	BEGIN
		
		UPDATE 
			AcCatUploadHistory_MOD 
			SET 
			AuthorisationStatus	='1A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			
		   UPDATE 
		   ExcelUploadHistory
		   SET AuthorisationStatus='1A'
		   where UniqueUploadID=@UniqueUploadID
		   AND UploadType='Provision Category Upload'
	END

	IF (@OperationFlag=20)----AUTHORIZE

	BEGIN
		
		UPDATE 
			AcCatUploadHistory_MOD 
			SET 
			AuthorisationStatus	='A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			--UPDATE 
			--IBPCPoolSummary_MOD 
			--SET 
			--AuthorisationStatus	='A'
			--,ApprovedBy	=@UserLoginID
			--,DateApproved	=GETDATE()
			
			--WHERE UploadId=@UniqueUploadID
			--select * from AcCatUploadHistory
			-----maintain history

			--Select * 

			Update A Set A.FinalProv='N'
			from AcCatUploadHistory A
			Inner Join AcCatUploadHistory_MOD B ON A.ACID=B.ACID  And B.EffectiveToTimeKey=49999
			Where A.EffectiveToTimeKey=49999 and B.UploadId=@UniqueUploadID
			
			Update A Set A.EffectiveToTimeKey=@Timekey-1
			from AcCatUploadHistory A
			Inner Join AcCatUploadHistory_MOD B ON A.ACID=B.ACID And A.CategoryID=B.CategoryID And B.EffectiveToTimeKey=49999
			Where A.EffectiveToTimeKey=49999 and B.Action='R' And  B.UploadId=@UniqueUploadID

			INSERT INTO AcCatUploadHistory
			            (SlNo
                        ,UPLOADID
                         ,ACID
                         ,CustomerID
                         ,CategoryID
                         ,Action
						,AuthorisationStatus
						,EffectiveFromTimeKey
						,EffectiveToTimeKey
						,CreatedBy
						,DateCreated
						,ModifyBy
						,DateModified
						,ApprovedBy
						,DateApproved
						,FinalProv
						)
			SELECT SlNo
                        ,@UniqueUploadID
                         ,ACID
   ,CustomerID
                         ,CategoryID
                         ,Action
						 ,AuthorisationStatus
					,@Timekey,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,'Y'
				
			FROM AcCatUploadHistory_MOD A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey



			-------------------In Main Table -----------------------
			IF OBJECT_ID('TempDB..#STD') IS NOT NULL
			Drop Table #STD

			Select S.CustomerAcId as Acid,
			
			Case when A.ACID IS NULL Then 113 Else B.BankCategoryID End BankCategoryID,
			Case when A.ACID IS NULL Then 13 Else B.ProvisionAlt_Key End ProvisionAlt_Key,
			Case when A.ACID IS NULL Then .40 Else B.ProvisionSecured ENd ProvisionSecured
			into #STD
			from STD_ProvDetail S
			Left Join AcCatUploadHistory A ON S.CustomerAcId=A.ACID and A.EffectiveToTimeKey=49999 And A.Action='A'
			Left Join DimProvision_SegStd B On A.CategoryID=B.BankCategoryID and b.EffectiveToTimeKey=49999
			where S.EffectiveToTimeKey=49999

			IF OBJECT_ID('TempDB..#STD1') IS NOT NULL
			Drop Table #STD1
			
			Select A.* into #STD1 from #STD A
			Inner Join (Select ACID,Max(ProvisionSecured)ProvisionSecured from #STD Group By ACID) B ON A.ACID=B.ACID And A.ProvisionSecured=B.ProvisionSecured

			--Select * 
			
			Update A set A.EffectiveToTimeKey=@Timekey-1
			from STD_ProvDetail A
			Inner Join #STD1 B ON A.CustomerAcId=B.ACID
			Where A.EffectiveToTimeKey=49999


			Insert into STD_ProvDetail
			(
			DataDate
			,TerritoryAlt_Key
			,SourceAlt_Key
			,GL_Code
			,GLProductAlt_Key
			,CustomerID
			,CustomerEntityID
			,CustomerName
			,CustomerAcId
			,SystemAcId
			,AccountEntityID
			,InitialAssetClassAlt_Key
			,FinalAssetClassAlt_Key
			,SanctionDate
			,FacilityType
			,AdvType
			,IndustryCode
			,Balance
			,OrgProvisionAlt_Key
			,ProvisionAlt_Key
			,FinalProvCatSetId
			,TotalAdjAmt
			,NetAmt
			,TotalExclAmt
			,NetAmtForProv
			,FinalProvPer
			,GovtGtyAmt
			,DFVAmt
			,SecurityValue
			,ApprRV
			,SecuredAmt
			,UnSecuredAmt
			,CoverGovGur
			,ProvSecured
			,ProvUnsecured
			,ProvCoverGovGur
			,AddlProvision
			,TotalProvision
			,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,UploadCatFlag
			,ExpireStatus
			,AcsegDesc
			,Acseg
			,OriginalBal
			,ProcessingStatus
			,Sch9_ProcessingStatus
			,MOCSTATUS
			,SCH9_Freeze_Flag
			,APPROP_GOV_GTY
			,SCH9_ADJAMT
			,SCH9_NETAMT
			,SECTORSHORTNAME
			,FITL_Provision
			,FITL_PROV_SECU
			,FITL_PROV_UNSECU
			,FITL_PROV_GOVGUR
			,DFV_Provision
			,DFV_PROV_SECU
			,DFV_PROV_UNSECU
			,DFV_PROV_GOVGUR
			,AdjCategoryAlt_Key
			,SubSectorAlt_Key
			,OriginalAdjBal
)

Select 
DataDate
			,TerritoryAlt_Key
			,SourceAlt_Key
			,GL_Code
			,GLProductAlt_Key
			,CustomerID
			,CustomerEntityID
			,CustomerName
			,A.CustomerAcId
			,SystemAcId
			,AccountEntityID
			,InitialAssetClassAlt_Key
			,FinalAssetClassAlt_Key
			,SanctionDate
			,FacilityType
			,AdvType
			,IndustryCode
			,Balance
			,OrgProvisionAlt_Key
			,B.ProvisionAlt_Key ProvisionAlt_Key
			,FinalProvCatSetId
			,TotalAdjAmt
			,NetAmt
			,TotalExclAmt
			,NetAmtForProv
			,FinalProvPer
			,GovtGtyAmt
			,DFVAmt
			,SecurityValue
			,ApprRV
			,SecuredAmt
			,UnSecuredAmt
			,CoverGovGur
			,B.ProvisionSecured ProvSecured
			,ProvUnsecured
			,ProvCoverGovGur
			,AddlProvision
			,TotalProvision
			,AuthorisationStatus
			,@Timekey EffectiveFromTimeKey
			,49999 EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,UploadCatFlag
			,ExpireStatus
			,AcsegDesc
			,Acseg
			,OriginalBal
			,ProcessingStatus
			,Sch9_ProcessingStatus
			,MOCSTATUS
			,SCH9_Freeze_Flag
			,APPROP_GOV_GTY
			,SCH9_ADJAMT
			,SCH9_NETAMT
			,SECTORSHORTNAME
			,FITL_Provision
			,FITL_PROV_SECU
			,FITL_PROV_UNSECU
			,FITL_PROV_GOVGUR
			,DFV_Provision
			,DFV_PROV_SECU
			,DFV_PROV_UNSECU
			,DFV_PROV_GOVGUR
			,AdjCategoryAlt_Key
			,SubSectorAlt_Key
			,OriginalAdjBal

			From STD_ProvDetail A
			Inner Join #STD1 B ON A.CustomerAcId=B.ACID
			Inner Join (Select Max(Entitykey)Entitykey,CustomerAcid from std_provdetail 
			where EffectiveToTimeKey=@Timekey-1 Group By CustomerAcid)C ON A.CustomerAcid=C.CustomerAcid And A.Entitykey=C.Entitykey
			--Where A.EffectiveToTimeKey=@Timekey-1

----------------------------------------------------------------------------------------------------------

--select * from DimProvision_SegStd

--alter table AcCatUploadHistory_MOD
--add Provision


/*
			INSERT INTO IBPCPoolSummary(
					SummaryID
					,PoolID
					,PoolName
					,PoolType
					,BalanceOutstanding
					,IBPCExposureAmt
					,IBPCReckoningDate
					,IBPCMarkingDate
					,MaturityDate
					,NoOfAccount
						,EffectiveFromTimeKey
						,EffectiveToTimeKey
						,CreatedBy
						,DateCreated
						,ModifyBy
						,DateModified
						,ApprovedBy
						,DateApproved
						,TotalPosBalance
						,TotalInttReceivable
						)
			SELECT SummaryID
					,PoolID
					,PoolName
					,PoolType
					,BalanceOutstanding
					,IBPCExposureAmt
					,IBPCReckoningDate
					,IBPCMarkingDate
					,MaturityDate
					,NoOfAccount
					,@Timekey,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,TotalPosBalance
					,TotalInttReceivable
			FROM IBPCPoolSummary_Mod A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey

			*/
			-----------------Insert into Final Tables ----------
/*
			Insert into IBPCFinalPoolDetail
			(
			SummaryID
			,PoolID
			,PoolName
			,CustomerID
			,AccountID
			,POS
			,InterestReceivable
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifyBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,ExposureAmount
			)
			SELECT SummaryID
					,PoolID
					,PoolName
					,CustomerID
					,AccountID
					,POS
					,InterestReceivable
					,@Timekey,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,IBPCExposureAmt
			FROM IBPCPoolDetail_MOD A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey

			---Summary Final -----------

			Insert into IBPCFinalPoolSummary
			(
			SummaryID
			,PoolID
			,PoolName
			,PoolType
			,BalanceOutstanding
			,IBPCExposureAmt
			,IBPCReckoningDate
			,IBPCMarkingDate
			,MaturityDate
			,NoOfAccount
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifyBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,TotalPosBalance
			,TotalInttReceivable
			)
			SELECT SummaryID
					,PoolID
					,PoolName
					,PoolType
					,BalanceOutstanding
					,IBPCExposureAmt
					,IBPCReckoningDate
					,IBPCMarkingDate
					,MaturityDate
					,NoOfAccount
					,@Timekey,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,TotalPosBalance
					,TotalInttReceivable
			FROM IBPCPoolSummary_Mod A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey
select * from STD_ProvDetail
---------------------------------------------
*/


			UPDATE A
			SET 
			--A.POS=ROUND(B.POS,2)
			a.ModifyBy=@UserLoginID
			,a.DateModified=GETDATE()
			FROM AcCatUploadHistory A
			INNER JOIN AcCatUploadHistory_MOD  B ON (A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey)
																AND  (B.EffectiveFromTimeKey<=@Timekey AND B.EffectiveToTimeKey>=@Timekey)	
																AND A.ACID=B.ACID

				WHERE B.AuthorisationStatus='A'
				AND B.UploadId=@UniqueUploadID

				UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='A',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Provision Category Upload'

				


	END
	-------------------------------------------------------------------


		IF (@OperationFlag=21)----REJECT

	BEGIN
		
		UPDATE 
			AcCatUploadHistory_MOD 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus in('NP','1A')

			--UPDATE 
			--IBPCPoolSummary_MOD 
			--SET 
			--AuthorisationStatus	='R'
			--,ApprovedBy	=@UserLoginID
			--,DateApproved	=GETDATE()
			
			--WHERE UploadId=@UniqueUploadID
			--AND AuthorisationStatus='NP'
			------SELECT * FROM IBPCPoolDetail

			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Provision Category Upload'

	END

--------------------------------------------------------------------
	IF (@OperationFlag=17)----REJECT

	BEGIN
		
		UPDATE 
			AcCatUploadHistory_MOD 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus='NP'

			--UPDATE 
			--IBPCPoolSummary_MOD 
			--SET 
			--AuthorisationStatus	='R'
			--,ApprovedBy	=@UserLoginID
			--,DateApproved	=GETDATE()
			
			--WHERE UploadId=@UniqueUploadID
			--AND AuthorisationStatus='NP'
			------SELECT * FROM IBPCPoolDetail

			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Provision Category Upload'

	END


END


	--COMMIT TRAN
		---SET @Result=CASE WHEN  @OperationFlag=1 THEN @UniqueUploadID ELSE 1 END
		SET @Result=CASE WHEN  @OperationFlag=1 AND @MenuId=1468 THEN @ExcelUploadId 
					ELSE 1 END

		
		 Update UploadStatus Set InsertionOfData='Y',InsertionCompletedOn=GETDATE() where FileNames=@filepath

		 ---- IF EXISTS(SELECT 1 FROM IBPCPoolDetail_stg WHERE filEname=@FilePathUpload)
		 ----BEGIN
			----	 DELETE FROM IBPCPoolDetail_stg
			----	 WHERE filEname=@FilePathUpload

			----	 PRINT 'ROWS DELETED FROM IBPCPoolDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		 ----END
		 

		RETURN @Result
		------RETURN @UniqueUploadID
	END TRY
	BEGIN CATCH 
	   --ROLLBACK TRAN
	SELECT ERROR_MESSAGE(),ERROR_LINE()
	SET @Result=-1
	 Update UploadStatus Set InsertionOfData='Y',InsertionCompletedOn=GETDATE() where FileNames=@filepath
	RETURN -1
	END CATCH

END


GO
