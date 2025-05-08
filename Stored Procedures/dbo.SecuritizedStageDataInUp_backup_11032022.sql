SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create PROCEDURE  [dbo].[SecuritizedStageDataInUp_backup_11032022]
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

--DECLARE @Timekey INT=24928,
--	@UserLoginID VARCHAR(100)='FNAOPERATOR',
--	@OperationFlag INT=1,
--	@MenuId INT=163,
--	@AuthMode	CHAR(1)='N',
--	@filepath VARCHAR(MAX)='',
--	@EffectiveFromTimeKey INT=24928,
--	@EffectiveToTimeKey	INT=49999,
--    @Result		INT=0 ,
--	@UniqueUploadID INT=41
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


	DECLARE @FilePathUpload	VARCHAR(100)
				   SET @FilePathUpload=@UserLoginId+'_'+@filepath
					PRINT '@FilePathUpload'
					PRINT @FilePathUpload


		BEGIN TRY

		--BEGIN TRAN
		
IF (@MenuId=1461)
BEGIN


	IF (@OperationFlag=1)

	BEGIN

		IF NOT (EXISTS (SELECT 1 FROM SecuritizedDetail_stg  where filname=@FilePathUpload))

							BEGIN
									 --Rollback tran
									SET @Result=-8

								RETURN @Result
							END
			


		IF EXISTS(SELECT 1 FROM SecuritizedDetail_stg WHERE FILNAME=@FilePathUpload)
		BEGIN
		
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
		   ,'Securitized Upload'
		   ,@EffectiveFromTimeKey
		   ,@EffectiveToTimeKey
		   ,@UserLoginId
		   ,GETDATE()

		   PRINT @@ROWCOUNT

		   DECLARE @ExcelUploadId INT
	SET 	@ExcelUploadId=(SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory)
		
			Insert into UploadStatus (FileNames,UploadedBy,UploadDateTime,UploadType)
		Values(@filepath,@UserLoginID ,GETDATE(),'Securitized Upload')
		
		INSERT INTO SecuritizedDetail_MOD
		(
			SrNo
			,UploadID
			,SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,CustomerID
			,AccountID
			,POS
			,InterestReceivable
			,AuthorisationStatus	
			,EffectiveFromTimeKey	
			,EffectiveToTimeKey	
			,CreatedBy	
			,DateCreated
			,SecuritizedExposureAmt	
			,OSBalance
			,SecuritisationExposureinRs
			,DateofSecuritisationreckoning
			,DateofSecuritisationmarking
			,MaturityDate
		)

		SELECT
			SrNo
			,@ExcelUploadId
			,SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,CustomerID
			,AccountID
			,PrincipalOutstandinginRs
			,InterestReceivableinRs
			,'NP'	
			,@Timekey
			,49999	
			,@UserLoginID
			,GETDATE()
			,SecuritisationExposureinRs
			,OSBalanceinRs
			,SecuritisationExposureinRs
			,DateofSecuritisationreckoning
			,DateofSecuritisationmarking
			,MaturityDate
		FROM SecuritizedDetail_stg
		where FilName=@FilePathUpload


		Declare @SummaryId int
		Set @SummaryId=IsNull((Select Max(SummaryId) from SecuritizedSummary_Mod),0)

		INSERT INTO SecuritizedSummary_stg
		(
			UploadID
			,SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,POS
			,NoOfAccount
			,SecuritisationExposureAmt
			,SecuritisationReckoningDate
			,SecuritisationMarkingDate
			,MaturityDate
			,TotalPosBalance
			,TotalInttReceivable
		)

		SELECT
			@ExcelUploadId
			,@SummaryId+Row_Number() over(Order by PoolID)
			,PoolID
			,PoolName
			,SecuritisationType
			,Sum(IsNull(Cast(PrincipalOutstandinginRs as decimal(16,2)),0)+IsNull(Cast(InterestReceivableinRs as Decimal(16,2)),0))
			,Count(PoolID)
			,SUM(ISNULL(Cast(SecuritisationExposureinRs as Decimal(16,2)),0))
			,DateofSecuritisationReckoning
			,DateofSecuritisationMarking
			,MaturityDate
			,Sum(IsNull(Cast(PrincipalOutstandinginRs as decimal(16,2)),0))
			,Sum(IsNull(Cast(InterestReceivableinRs as Decimal(16,2)),0))
		FROM SecuritizedDetail_stg
		where FilName=@FilePathUpload
		Group by PoolID,PoolName,SecuritisationType,DateofSecuritisationReckoning,DateofSecuritisationMarking,MaturityDate

--		--INSERT INTO SecuritizedSummary_Mod
--		--(
--		--	UploadID
--		--	,SummaryID
--		--	,PoolID
--		--	,PoolName
--		--	,BalanceOutstanding
--		--	,NoOfAccount
--		--	,AuthorisationStatus	
--		--	,EffectiveFromTimeKey	
--		--	,EffectiveToTimeKey	
--		--	,CreatedBy	
--		--	,DateCreated	
--		--)

--		--SELECT
--		--	@ExcelUploadId
--		--	,@SummaryId+Row_Number() over(Order by PoolID)
--		--	,PoolID
--		--	,PoolName
--		--	,Sum(IsNull(POS,0)+IsNull(InterestReceivable,0))
--		--	,Count(PoolID)
--		--	,'NP'	
--		--	,@Timekey
--		--	,49999	
--		--	,@UserLoginID	
--		--	,GETDATE()
--		--FROM SecuritizedDetail_stg
--		--where FilName=@FilePathUpload
--		--Group by PoolID,PoolName

		PRINT @@ROWCOUNT
		
--		---DELETE FROM STAGING DATA
		 DELETE FROM SecuritizedDetail_stg
		 WHERE filname=@FilePathUpload

--		 ----RETURN @ExcelUploadId

END
--		   ----DECLARE @UniqueUploadID INT
--	--SET 	@UniqueUploadID=(SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory)
	END

----------------Two level Auth. changes----------------------

IF (@OperationFlag=16)----AUTHORIZE

	BEGIN
		
		UPDATE 
			SecuritizedDetail_MOD 
			SET 
			AuthorisationStatus	='1A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			UPDATE 
			SecuritizedSummary_Mod 
			SET 
			AuthorisationStatus	='1A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			
		   UPDATE 
		   ExcelUploadHistory
		   SET AuthorisationStatus='1A'
		   ,ApprovedBy	=@UserLoginID
		   where UniqueUploadID=@UniqueUploadID
		   AND UploadType='Securitized Upload'
	END

	IF (@OperationFlag=20)----AUTHORIZE

	BEGIN
		
		UPDATE 
			SecuritizedDetail_MOD 
			SET 
			AuthorisationStatus	='A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			UPDATE 
			SecuritizedSummary_Mod 
			SET 
			AuthorisationStatus	='A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			Update  A
			Set A.EffectiveToTimeKey=A.EffectiveFromTimeKey-1
			from SecuritizedDetail A
			inner join SecuritizedDetail_mod B
			ON A.AccountID=B.AccountID
			AND B.EffectiveFromTimeKey <=@Timekey
			AND B.EffectiveToTimeKey >=@Timekey
			Where B.UploadId=@UniqueUploadID
			AND A.EffectiveToTimeKey >=49999
		 
			 

			-----maintain history
			INSERT INTO SecuritizedDetail(SummaryID
						,PoolID
						,PoolName
						,SecuritisationType
						,CustomerID
						,AccountID
						,POS
						,InterestReceivable
						,AuthorisationStatus
						,EffectiveFromTimeKey
						,EffectiveToTimeKey
						,CreatedBy
						,DateCreated
						,ModifyBy
						,DateModified
						,ApprovedBy
						,DateApproved
						,SecuritizedExposureAmt
						,OSBalance
						,SecuritisationExposureinRs
						,DateofSecuritisationreckoning
						,DateofSecuritisationmarking
						,MaturityDate
						)
			SELECT SummaryID
					,PoolID
					,PoolName
					,SecuritisationType
					,CustomerID
					,AccountID
					,POS
					,InterestReceivable
					,AuthorisationStatus
					,@Timekey
					,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,SecuritizedExposureAmt
					,OSBalance
					,SecuritisationExposureinRs
					,DateofSecuritisationreckoning
					,DateofSecuritisationmarking
					,MaturityDate
			FROM SecuritizedDetail_MOD A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey


			Update  A
			Set A.EffectiveToTimeKey=A.EffectiveFromTimeKey-1
			from SecuritizedFinalACDetail A
			inner join SecuritizedDetail_mod B
			ON A.AccountID=B.AccountID
			AND B.EffectiveFromTimeKey <=@Timekey
			AND B.EffectiveToTimeKey >=@Timekey
			Where B.UploadId=@UniqueUploadID
			AND A.EffectiveToTimeKey >=49999

			/*
---new add
alter table SecuritizedFinalACDetail
add ScrOutDate date,ScrInDate Date


*/


			 INSERT INTO SecuritizedFinalACDetail  
          (   SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,CustomerID
			,AccountID
			,POS
			,InterestReceivable
			,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifyBy
			,DateModified
			,ApprovedBy
			,DateApproved
			,ExposureAmount
			,ScrInDate
			,AccountBalance
  
            )  
			SELECT SummaryID
					,PoolID
					,PoolName
					,SecuritisationType
					,CustomerID
					,AccountID
					,POS
					,InterestReceivable
					,AuthorisationStatus
					,@Timekey,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,SecuritizedExposureAmt
					,GETDATE()
					,OSBalance
			FROM SecuritizedDetail_MOD A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey


			Insert into SecuritizedFinalACSummary
			(
			SummaryID
			,PoolID
			,PoolName
			,SecuritisationType
			,POS
			,SecuritisationExposureAmt
			,SecuritisationReckoningDate
			,SecuritisationMarkingDate
			,MaturityDate
			,NoOfAccount
			,AuthorisationStatus
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
			--,ScrInDate 
			)
			SELECT SummaryID
					,PoolID
					,PoolName
					,SecuritisationType
					,POS
					,SecuritisationExposureAmt
					,SecuritisationReckoningDate
					,SecuritisationMarkingDate
					,MaturityDate
					,NoOfAccount
					,AuthorisationStatus
					,@Timekey
					,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
					,TotalPosBalance
					,TotalInttReceivable
					--,GETDATE()
			FROM SecuritizedSummary_Mod A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey




			INSERT INTO SecuritizedSummary(
					SummaryID
					,PoolID
					,PoolName
					,SecuritisationType
					,POS
					,SecuritisationExposureAmt
					,SecuritisationReckoningDate
					,SecuritisationMarkingDate
					,DateofRemoval
					,NoOfAccount
					,AuthorisationStatus
						,EffectiveFromTimeKey
						,EffectiveToTimeKey
						,CreatedBy
						,DateCreated
						,ModifyBy
						,DateModified
						,ApprovedBy
						,DateApproved)
			SELECT SummaryID
					,PoolID
					,PoolName
					,SecuritisationType
					,POS         --,BalanceOutstanding
					,SecuritisationExposureAmt
					,SecuritisationReckoningDate
					,SecuritisationMarkingDate
					,MaturityDate
					,NoOfAccount
					,AuthorisationStatus
					,@Timekey
					,49999
					,CreatedBy
					,DateCreated
					,ModifyBy
					,DateModified
					,@UserLoginID
					,Getdate()
			FROM SecuritizedSummary_Mod A
			WHERE  A.UploadId=@UniqueUploadID and EffectiveToTimeKey>=@Timekey

			/*--------------------Adding Flag To AdvAcOtherDetail------------Pranay 21-03-2021--------*/ 


IF OBJECT_ID('TempDB..#SecuritizeNew') Is Not NUll
Drop Table #SecuritizeNew

Select A.RefSystemAcId,A.SplFlag into #SecuritizeNew FROM DBO.AdvAcOtherDetail A
     INNER JOIN SecuritizedDetail_MOD B ON A.RefSystemAcId=B.AccountID
			WHERE  B.UploadId=@UniqueUploadID and B.EffectiveToTimeKey>=@Timekey
			AND A.EffectiveToTimeKey=49999 And A.SplFlag Like '%Securitised%'

  UPDATE A
	SET  
        A.SplFlag=CASE WHEN ISNULL(A.SplFlag,'')='' THEN 'Securitised'     
						ELSE A.SplFlag+','+'Securitised'     END
		   
   FROM DBO.AdvAcOtherDetail A
   --INNER JOIN #Temp V  ON A.AccountEntityId=V.AccountEntityId
  INNER JOIN SecuritizedDetail_MOD B ON A.RefSystemAcId=B.AccountID
			WHERE  B.UploadId=@UniqueUploadID and B.EffectiveToTimeKey>=@Timekey
			AND A.EffectiveToTimeKey=49999
			AND Not Exists (Select 1 from #SecuritizeNew N Where N.RefSystemAcId=A.RefSystemAcId)
-------------------------------------------

			UPDATE A
			SET 
			A.POS=ROUND(B.POS,2)
			,a.ModifyBy=@UserLoginID
			,a.DateModified=GETDATE()
			FROM SecuritizedDetail A
			INNER JOIN SecuritizedDetail_MOD  B ON (A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey)
																AND  (B.EffectiveFromTimeKey<=@Timekey AND B.EffectiveToTimeKey>=@Timekey)	
																AND A.AccountID=B.AccountID

				WHERE B.AuthorisationStatus='A'
				AND B.UploadId=@UniqueUploadID

				UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='A',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Securitized Upload'

				


	END

	IF (@OperationFlag=17)----REJECT

	BEGIN
		
		UPDATE 
			SecuritizedDetail_MOD 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus='NP'

			UPDATE 
			SecuritizedSummary_Mod 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus='NP'
			
			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Securitized Upload'
	END

			IF (@OperationFlag=21)----REJECT

	BEGIN
		
		UPDATE 
			SecuritizedDetail_MOD 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus in('NP','1A')

			UPDATE 
			SecuritizedSummary_Mod 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus in ('NP','1A')
--			----SELECT * FROM IBPCPoolDetail

			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Securitized Upload'



	END


END
-------------------------------------Attendance Log----------------------------	
	IF @OperationFlag IN (1,2,3,16,17,18,20,21) AND @AuthMode ='Y'
		BEGIN
					print 'log table'

		          declare @DateCreated1 datetime
				SET	@DateCreated1     =Getdate()

				--declare @ReferenceID1 varchar(max)
				--set @ReferenceID1 = (case when @OperationFlag in (16,20,21) then @SourceAlt_Key else @SourceAlt_Key end)


					IF @OperationFlag IN(16,17,18,20,21) 
						BEGIN 
						       Print 'Authorised'
					
			
								EXEC LogDetailsInsertUpdate_Attendence -- MAINTAIN LOG TABLE
							    @BranchCode=''   ,  ----BranchCode
								@MenuID=@MenuID,
								@ReferenceID=@UniqueUploadID ,-- ReferenceID ,
								@CreatedBy=NULL,
								@ApprovedBy=@UserLoginID, 
								@CreatedCheckedDt=@DateCreated1,
								@Remark=NULL,
								@ScreenEntityAlt_Key=16  ,---ScreenEntityId -- for FXT060 screen
								@Flag=@OperationFlag,
								@AuthMode=@AuthMode
						END
					ELSE
						BEGIN
						       Print 'UNAuthorised'
						    -- Declare
						    -- set @CreatedBy  =@UserLoginID
							 
							EXEC LogDetailsInsertUpdate_Attendence -- MAINTAIN LOG TABLE
								@BranchCode=''   ,  ----BranchCode
								@MenuID=@MenuID,
								@ReferenceID=@UniqueUploadID ,-- ReferenceID ,
								@CreatedBy=@UserLoginID,
								@ApprovedBy=NULL, 						
								@CreatedCheckedDt=@DateCreated1,
								@Remark=NULL,
								@ScreenEntityAlt_Key=16  ,---ScreenEntityId -- for FXT060 screen
								@Flag=@OperationFlag,
								@AuthMode=@AuthMode
						END

		END
---------------------------------------------------------------------------------------


	--COMMIT TRAN
		---SET @Result=CASE WHEN  @OperationFlag=1 THEN @UniqueUploadID ELSE 1 END
		SET @Result=CASE WHEN  @OperationFlag=1  AND @MenuId=1461 THEN @ExcelUploadId 
					ELSE 1 END

		
		 Update UploadStatus Set InsertionOfData='Y',InsertionCompletedOn=GETDATE() where FileNames=@filepath

--		 ---- IF EXISTS(SELECT 1 FROM SecuritizedDetail_stg WHERE filEname=@FilePathUpload)
--		 ----BEGIN
--			----	 DELETE FROM SecuritizedDetail_stg
--			----	 WHERE filEname=@FilePathUpload

--			----	 PRINT 'ROWS DELETED FROM SecuritizedDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
--		 ----END
		 

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
