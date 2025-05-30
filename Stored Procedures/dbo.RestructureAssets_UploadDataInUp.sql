SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE  [dbo].[RestructureAssets_UploadDataInUp]
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
	
	--@Authlevel varchar(5)

AS

--DECLARE @Timekey INT=24928,
--	@UserLoginID VARCHAR(100)='FNAOPERATOR',
--	@OperationFlag INT=1,
--	@MenuId INT=24714,
--	@AuthMode	CHAR(1)='N',
--	@filepath VARCHAR(MAX)='',
--	@EffectiveFromTimeKey INT=24928,
--	@EffectiveToTimeKey	INT=49999,
--    @Result		INT=0 ,
--	@UniqueUploadID INT=41
BEGIN
SET DATEFORMAT DMY
	SET NOCOUNT ON;
	--Declare @CollIDAutoGenerated   Int
 --   Declare @CollateralID		   varchar(30)=''
   --DECLARE @Timekey INT
   --SET @Timekey=(SELECT MAX(TIMEKEY) FROM dbo.SysProcessingCycle
			--	WHERE ProcessType='Quarterly')

			Set @Timekey=(
			select CAST(B.timekey as int)from SysDataMatrix A
			Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
			 where A.CurrentStatus='C'
			 )

	PRINT @TIMEKEY

	SET @EffectiveFromTimeKey=@TimeKey
	SET @EffectiveToTimeKey=49999


	DECLARE @FilePathUpload	VARCHAR(100)
				   SET @FilePathUpload=@UserLoginId+'_'+@filepath
					PRINT '@FilePathUpload'
					PRINT @FilePathUpload


		BEGIN TRY

		--BEGIN TRAN
		
IF (@MenuId=24714)
BEGIN
 --Set @FilePathUpload='mismaker_CollateralUpload_3.xlsx'
 --select * from SysCRisMacMenu where menucaption like '%Restru%'
	IF (@OperationFlag=1)

	BEGIN

		IF NOT (EXISTS (SELECT 1 FROM RetsructuredAssetsUpload_stg  where filname=@FilePathUpload))

							BEGIN
									 --Rollback tran
									SET @Result=-8

								RETURN @Result
							END
			
                   Print 'Sachin'

		IF EXISTS(SELECT 1 FROM RetsructuredAssetsUpload_stg WHERE filname=@FilePathUpload)
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
		   ,'Restructure Assets Upload'
		   ,@EffectiveFromTimeKey
		   ,@EffectiveToTimeKey
		   ,@UserLoginID
		   ,GETDATE()

		   --sp
			   PRINT @@ROWCOUNT

		   DECLARE @ExcelUploadId INT
	SET 	@ExcelUploadId=(
	SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory
	)
		
			Insert into UploadStatus (FileNames,UploadedBy,UploadDateTime,UploadType)
		Values(@filepath,@UserLoginID ,GETDATE(),'Restructure Assets Upload')

/*
		SET @CollIDAutoGenerated=0
				
         
					Select @CollIDAutoGenerated= MAX(Convert(Int,ISNULL(CollateralID,0))) From(
					Select MAX(Convert(Int,ISNULL(CollateralID,0))) as CollateralID from Curdat.AdvSecurityDetail
					UNION ALL
					Select MAX(Convert(Int,ISNULL(CollateralID,0))) as CollateralID from DBO.AdvSecurityDetail_Mod
					UNION ALL
					Select MAX(Convert(Int,ISNULL(CollateralID,0))) as CollateralID from Curdat.AdvSecurityValueDetail
					UNION ALL
					 Select MAX(Convert(Int,ISNULL(CollateralID,0))) as CollateralID from DBO.AdvSecurityValueDetail_Mod
					 UNION ALL
					 Select MAX(Convert(Int,ISNULL(CollateralID,0))) as CollateralID from DBO.CollateralDetailUpload_Mod
					 )X

					IF (@CollIDAutoGenerated IS NULL)

						SET   @CollIDAutoGenerated=1000001

					ELSE 
					    SET    @CollIDAutoGenerated=Convert(Int,@CollIDAutoGenerated)+1

						--Print '@CollIDAutoGenerated'
						--Print @CollIDAutoGenerated
					 
					 SET @CollateralID=Convert(Varchar(30),@CollIDAutoGenerated)

					 PRINT '@ExcelUploadId'
					 PRINT @ExcelUploadId


					 */

	 SET dateformat DMY
	 --alter table RestructureAsset_Upload_Mod
	 --add SrNo INT
		INSERT INTO [RestructureAsset_Upload_Mod]
		(
		      SrNo
              ,AccountID
             --,AccountEntityID
             ,UploadID
             ,RestructureFacility
             --,RevisedBusinessSeg
             --,DisbursementDate
             --,ReferenceDate
             --,InvocationDate
			 ,EquityConversion 
             ,StatusOfSpecificPeriod 
             ,DateofConversionintoEquity
             ,PrinRpymntStartDate
             ,InttRpymntStartDate
             --,AssetClassatRstrctr
             --,IfNPANPADate
             --,NPAQuarter
             ,TypeofRestructuring
             --,CovidMoratoriamMSME
             --,CovidOTRCategory
             ,BankingRelationship
             ,DateofRestructuring
             ,RestructuringApprovingAuth
             ,DateofIstDefaultonCRILIC
             ,ReportingBank
             --,DateofSigningICA
             ,OSasonDateofRstrctr  
            -- ,PamountRstrctr
             ,InvestmentGrade
             --,CreditProvisionRs
             ,DFVProvisionRs
             --,MTMProvisionRs
             ,SheetName
             ,AuthorisationStatus
             ,EffectiveFromTimeKey
             ,EffectiveToTimeKey
             ,CreatedBy
             ,DateCreated
             --,ModifiedBy
             --,DateModified
             --,ApprovedBy
             --,DateApproved
--D2Ktimestamp
		)
		
		SELECT
			        SrNo
                   ,AccountID
				   --,@AccountEntityID
				   ,@ExcelUploadId
                   ,RestructureFacility
                   --,RevisedBusinessSeg
                   --,Case When isnull(DisbursementDate,'')<>'' Then  Convert(date,DisbursementDate,105) Else NULL END as DisbursementDate
                   --,Case When isnull(ReferenceDate,'')<>'' Then  Convert(date,ReferenceDate,105) Else NULL END as ReferenceDate
                   --,Case When isnull(InvocationDate,'')<>'' Then  Convert(date,InvocationDate,105) Else NULL END as InvocationDate
                    ,EquityConversion 
                    ,StatusOfSpecificPeriod 
				   ,Case When isnull(DateofConversionintoEquity,'')<>'' Then  Convert(date,DateofConversionintoEquity,105) Else NULL END as DateofConversionintoEquity
                   ,Case When isnull(PrinRpymntStartDate,'')<>'' Then  Convert(date,PrinRpymntStartDate,105) Else NULL END as PrinRpymntStartDate
                   ,Case When isnull(InttRpymntStartDate,'')<>'' Then  Convert(date,InttRpymntStartDate,105) Else NULL END as InttRpymntStartDate
                   --,AssetClassatRstrctr
                   --,Case When isnull(NPADate,'')<>'' Then  Convert(date,NPADate,105) Else NULL END as NPADate
                   --,NPAQuarter
                   ,TypeofRestructuring
                   --,CovidMoratoriamMSME
                   --,CovidOTRCategory
                   ,BankingRelationship
                   ,Case When isnull(DateofRestructuring,'')<>'' Then  Convert(date,DateofRestructuring,105) Else NULL END as DateofRestructuring
                   ,RestructuringApprovingAuth
                   ,Case When isnull(DateofIstDefaultonCRILIC,'')<>'' Then  Convert(date,DateofIstDefaultonCRILIC,105) Else NULL END as DateofIstDefaultonCRILIC
                   ,ReportingBank
                   --,Case When isnull(DateofSigningICA,'')<>'' Then  Convert(date,DateofSigningICA,105) Else NULL END as DateofSigningICA
					,case when isnull(amountRstrctr,'')<>'' then cast(amountRstrctr as decimal(16,2))  else NULLIF(amountRstrctr,'') end amountRstrctr
                  -- ,case when isnull(PamountRstrctr,'')<>'' then cast(PamountRstrctr as decimal(16,2))  else NULLIF(PamountRstrctr,'') end as PamountRstrctr
                   ,InvestmentGrade
                   --,case when CreditProvisionRs='' then  NULL
				               -- else cast(isnull(CreditProvisionRs,0) as decimal(16,2)) end as CreditProvisionRs
                   ,case when DFVProvisionRs='' then null				              
				   else cast(isnull(DFVProvisionRs,'') as decimal(16,2)) end as DFVProvisionRs
                   --,case when MTMProvisionRs='' then null
				               -- else cast(isnull(MTMProvisionRs,'') as decimal(16,2))  end as  MTMProvisionRs
                   ,filname
				    ,'NP'
				   ,@Timekey
			       ,49999
		          ,@UserLoginID
			       ,GETDATE()
			  
		--select *	
		FROM RetsructuredAssetsUpload_stg
		where filname=@FilePathUpload

	

		
		---DELETE FROM STAGING DATA Sachin

		 DELETE FROM RetsructuredAssetsUpload_stg
		 WHERE filname=@FilePathUpload

		 --RETURN @ExcelUploadId

		



END
		   ----DECLARE @UniqueUploadID INT
	--SET 	@UniqueUploadID=(SELECT MAX(UniqueUploadID) FROM  ExcelUploadHistory)
	END


	IF (@OperationFlag=16)----AUTHORIZE

	BEGIN
		
		UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='1A'
			,ApprovedByfirstlevel	=@UserLoginID
			,DateApprovedByfirstlevel	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='1A'
			,ApprovedByfirstlevel	=@UserLoginID
			,DateApprovedByfirstlevel	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID


			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='1A',
				ApprovedByfirstlevel=@UserLoginID,
				DateApprovedfirstlevel=GETDATE()
				WHERE UniqueUploadID=@UniqueUploadID
				AND UploadType='Restructure Assets Upload'
				 

	End
	IF (@OperationFlag=20)----AUTHORIZE

	BEGIN
		
		UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID

			UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='A'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID


--,PreRestrucNPA_Date
	INSERT INTO [Curdat].[AdvAcRestructureDetail](
RefSystemAcId					 
,AccountEntityId
,RefCustomerId
,RestructureCatgAlt_Key  ---RestructureFacility
--,RevisedBusinessSegment   ---RevisedBusinessSeg
--,DisbursementDate
--,RefDate
--,InvocationDate
,EquityConversion 
,StatusOfSpecificPeriod 
,ConversionDate
,PrincRepayStartDate
,InttRepayStartDate
--,RestructureAssetClassAlt_key
--,PreRestrucNPA_Date
--,Npa_Qtr
,RestructureTypeAlt_Key
--,FlgMorat
--,COVID_OTR_CatgAlt_Key
,BankingRelationTypeAlt_Key
,RestructureDt
,RestructureApprovingAuthority
,CRILIC_Fst_DefaultDate
,FstDefaultReportingBank   --,ReportingBank  
--,ICA_SignDate
,RestructureAmt
--,RestructurePOS
,InvestmentGrade
--,CreditProvision
,DFVProvision
--,MTMProvision
,AuthorisationStatus
			,EffectiveFromTimeKey
			,EffectiveToTimeKey
			,CreatedBy
			,DateCreated
			,ModifiedBy
			,DateModified
			,ApprovedBy
			,DateApproved



						)

						select 
                     AccountID
				   , B.AccountEntityID
				   ,B.RefCustomerId
				   --,@ExcelUploadId
                   ,I.ParameterAlt_Key    RestructureFacility
                   --,RevisedBusinessSeg
                   --,Case When DisbursementDate<>'' Then  Convert(date,DisbursementDate) Else NULL END as DisbursementDate
                   --,Case When ReferenceDate<>'' Then  Convert(date,ReferenceDate) Else NULL END as ReferenceDate
                   --,Case When InvocationDate<>'' Then  Convert(date,InvocationDate) Else NULL END as InvocationDate
                   ,EquityConversion 
                   ,StatusOfSpecificPeriod 
				   ,Case When DateofConversionintoEquity<>'' Then  Convert(date,DateofConversionintoEquity) Else NULL END as DateofConversionintoEquity
                   ,Case When PrinRpymntStartDate<>'' Then  Convert(date,PrinRpymntStartDate) Else NULL END as PrinRpymntStartDate
                   ,Case When InttRpymntStartDate<>'' Then  Convert(date,InttRpymntStartDate) Else NULL END as InttRpymntStartDate
                   --,DA.AssetClassAlt_Key AssetClassatRstrctr
				   ----,A.AssetClassatRstrctr AssetClassatRstrctr
       --            ,Case When IfNPANPADate<>'' Then  Convert(date,IfNPANPADate) Else NULL END as IfNPANPADate
       --            ,NPAQuarter
                   ,J.ParameterAlt_Key  TypeofRestructuring
                  -- ,K.ParameterAlt_Key  CovidMoratoriamMSME
                   --,L.ParameterAlt_Key CovidOTRCategory
                   ,M.ParameterAlt_Key BankingRelationship
                   ,Case When DateofRestructuring<>'' Then  Convert(date,DateofRestructuring) Else NULL END as DateofRestructuring
                   ,RestructuringApprovingAuth
                   ,Case When DateofIstDefaultonCRILIC<>'' Then  Convert(date,DateofIstDefaultonCRILIC) Else NULL END as DateofIstDefaultonCRILIC
                   ,ReportingBank
                   --,Case When DateofSigningICA<>'' Then  Convert(date,DateofSigningICA) Else NULL END as DateofSigningICA
                   ,OSasonDateofRstrctr as amountRstrctr
                   --,PamountRstrctr
                   ,InvestmentGrade
                   --,CreditProvisionRs
                   ,DFVProvisionRs
                   --,MTMProvisionRs
       ----           -- ,SheetName
				   ------ ,'NP'
				   ------,@Timekey
			    ------   ,49999
		     ------     ,@UserLoginID
			    ------   ,GETDATE()

				   ,A.AuthorisationStatus
					,@Timekey
					,49999
					,A.CreatedBy
					,A.DateCreated
					,A.ModifiedBy
					,A.DateModified
					,@UserLoginID
					,Getdate()
			
			--select * 
			FROM [RestructureAsset_Upload_Mod] A
			INNER Join CURDAT.AdvAcBasicDetail B ON B.CustomerACID=A.AccountID
			             and B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@Timekey

						 LEFT JOIn DimassetClass DA ON DA.AssetClassShortName=A.AssetClassatRstrctr
                
				--select * from DimAssetClass

					 LEFT Join (

						Select  ParameterAlt_Key,ParameterName,'RestructureFacility' as Tablename 
						from DimParameter where DimParameterName='RestructureFacility'
						And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)I
						ON I.ParameterName=A.RestructureFacility

						 LEFT Join (

						Select  ParameterAlt_Key,ParameterName,'TypeofRestructuring' as Tablename 
						from DimParameter where DimParameterName='TypeofRestructuring'
						And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)J
						ON J.ParameterName=A.TypeofRestructuring

						LEFT Join (

						Select  ParameterAlt_Key,ParameterName,'CovidMoratorium' as Tablename 
						from DimParameter where DimParameterName='DimYesNoNA'
						And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)K
						ON K.ParameterName=(CASE WHEN A.CovidMoratoriamMSME='Y' THEN 'Yes' 
						                        when A.CovidMoratoriamMSME='N' THEN 'NO' 
												else 'NA' end )

						LEFT Join (

						Select  ParameterAlt_Key,ParameterName,'Covid - OTR Category' as Tablename 
						from DimParameter where DimParameterName='Covid - OTR Category'
						And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)L
						ON L.ParameterName=A.CovidOTRCategory

						LEFT Join (

						Select  ParameterAlt_Key,ParameterName,'BankingRelationship' as Tablename 
						from DimParameter where DimParameterName='BankingRelationship'
						And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)M
						ON M.ParameterName=A.BankingRelationship

						

						
			WHERE  A.UploadId=@UniqueUploadID and A.EffectiveToTimeKey>=@Timekey

		

				UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='A',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Restructure Assets Upload'

				


	END


	IF (@OperationFlag=17)----REJECT

	BEGIN
		
		UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus='NP'

			UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus='NP'
			----SELECT * FROM IBPCPoolDetail

			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Restructure Assets Upload'



	END

IF (@OperationFlag=21)----REJECT

	BEGIN
		
		UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus in('NP','1A')

			UPDATE 
			[RestructureAsset_Upload_Mod] 
			SET 
			AuthorisationStatus	='R'
			,ApprovedBy	=@UserLoginID
			,DateApproved	=GETDATE()
			
			WHERE UploadId=@UniqueUploadID
			AND AuthorisationStatus in('NP','1A')
			----SELECT * FROM IBPCPoolDetail

			UPDATE
				ExcelUploadHistory
				SET AuthorisationStatus='R',ApprovedBy=@UserLoginID,DateApproved=GETDATE()
				WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
				AND UniqueUploadID=@UniqueUploadID
				AND UploadType='Restructure Assets Upload'



	END


END


	--COMMIT TRAN
		---SET @Result=CASE WHEN  @OperationFlag=1 THEN @UniqueUploadID ELSE 1 END
		SET @Result=CASE WHEN  @OperationFlag=1 AND @MenuId=24714 THEN @ExcelUploadId 
					ELSE 1 END

		
		 Update UploadStatus Set InsertionOfData='Y',InsertionCompletedOn=GETDATE() where FileNames=@filepath

		 ---- IF EXISTS(SELECT 1 FROM IBPCPoolDetail_stg WHERE filEname=@FilePathUpload)
		 ----BEGIN
			----	 DELETE FROM IBPCPoolDetail_stg
			----	 WHERE filEname=@FilePathUpload

			----	 PRINT 'ROWS DELETED FROM IBPCPoolDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		 ----END
		 

		RETURN @Result
		--RETURN @ExcelUploadId
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
