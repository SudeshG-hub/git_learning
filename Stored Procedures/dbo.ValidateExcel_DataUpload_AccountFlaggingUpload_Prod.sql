SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ValidateExcel_DataUpload_AccountFlaggingUpload_Prod]  
@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='fnachecker',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='TWOACUPLOAD.xlsx'  
,@UploadTypeParameterAlt_Key Int
WITH RECOMPILE  
AS  
  


--DECLARE  
  
--@MenuID INT=161,  
--@UserLoginId varchar(20)='FNASUPERADMIN',  
--@Timekey int=49999
--,@filepath varchar(500)='InterestReversalUpload (5).xlsx'  
  
BEGIN

BEGIN TRY  
--BEGIN TRAN  
  
--Declare @TimeKey int  
    --Update UploadStatus Set ValidationOfData='N' where FileNames=@filepath  
     
	 SET DATEFORMAT DMY

 --Select @Timekey=Max(Timekey) from dbo.SysProcessingCycle  
 -- where  ProcessType='Quarterly' ----and PreMOC_CycleFrozenDate IS NULL
 
 Select   @Timekey=Max(Timekey) from sysDayMatrix where Cast(date as Date)=cast(getdate() as Date)

  PRINT @Timekey  
  
 --  DECLARE @DepartmentId SMALLINT ,@DepartmentCode varchar(100)  
 --SELECT  @DepartmentId= DepartmentId FROM dbo.DimUserInfo   
 --WHERE EffectiveFromTimeKey <= @Timekey AND EffectiveToTimeKey >= @Timekey  
 --AND UserLoginID = @UserLoginId  
 --PRINT @DepartmentId  
 --PRINT @DepartmentCode  
  
    
  
 --SELECT @DepartmentCode=DepartmentCode FROM AxisIntReversalDB.DimDepartment   
 --    WHERE EffectiveFromTimeKey <= @Timekey AND EffectiveToTimeKey >= @Timekey   
 --    --AND DepartmentCode IN ('BBOG','FNA')  
 --    AND DepartmentAlt_Key = @DepartmentId  
  
 --    print @DepartmentCode  
     --Select @DepartmentCode=REPLACE('',@DepartmentCode,'_')  
     
       
  
   
  
  DECLARE @FilePathUpload	VARCHAR(100)

			SET @FilePathUpload=@UserLoginId+'_'+@filepath
	PRINT '@FilePathUpload'
	PRINT @FilePathUpload

	IF EXISTS(SELECT 1 FROM dbo.MasterUploadData    where FileNames=@filepath )
	BEGIN
		Delete from dbo.MasterUploadData    where FileNames=@filepath  
		print @@rowcount
	END


IF (@MenuID=1470)	
BEGIN


	  -- IF OBJECT_ID('tempdb..TwoAc') IS NOT NULL  
	  --BEGIN  
	  -- DROP TABLE TwoAc  
	
	  --END
	    IF OBJECT_ID('TwoAc') IS NOT NULL  
	  BEGIN  
	   DROP TABLE TwoAc  
	
	  END
	  
  IF NOT (EXISTS (SELECT * FROM AccountFlagging_Stg where filname=@FilePathUpload))

BEGIN
print 'NO DATA'
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT 0 SRNO , '' ColumnName,'No Record found' ErrorData,'No Record found' ErrorType,@filepath,'SUCCESS' 
			--SELECT 0 SRNO , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 

			goto errordata
    
END

ELSE
BEGIN
PRINT 'DATA PRESENT'
	   Select *,CAST('' AS varchar(MAX)) ErrorMessage,CAST('' AS varchar(MAX)) ErrorinColumn,CAST('' AS varchar(MAX)) Srnooferroneousrows
 	   into TwoAc 
	   from AccountFlagging_Stg 
	   WHERE filname=@FilePathUpload

	  
END
  ------------------------------------------------------------------------------  
    ----SELECT * FROM TwoAc
	--SrNo	Territory	ACID	InterestReversalAmount	filname
	UPDATE TwoAc
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='ACID,Amount,Date,Action'    
		,Srnooferroneousrows=''
 FROM TwoAc V  
 WHERE ISNULL(ACID,'')=''
AND ISNULL(Amount,'')=''
AND ISNULL(Date,'')=''
AND ISNULL(Action,'')=''

  
--WHERE

  IF EXISTS(SELECT 1 FROM TwoAc WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO ERRORDATA;
  END

  /*VALIDATIONS ON ACID */

  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Account cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ACID' ELSE ErrorinColumn +','+SPACE(1)+  'ACID' END  
		,Srnooferroneousrows=V.SrNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM TwoAc A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM TwoAc V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM TwoAc V  
 WHERE ISNULL(ACID,'')='' 
 

-- ----SELECT * FROM TwoAc
  /*------Account ID Validation----Pranay 22-03-2021---*/
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Account ID found. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ACID' ELSE ErrorinColumn +','+SPACE(1)+  'ACID' END  
		,Srnooferroneousrows=V.SrNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM TwoAc A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM TwoAc V
--								-- WHERE ISNULL(V.ACID,'')<>''
--								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
--								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--								--										Timekey=@Timekey
--								--		))
--								--FOR XML PATH ('')
--								--),1,1,'')   
		FROM TwoAc V  
 WHERE ISNULL(V.ACID,'')<>''
 AND V.ACID NOT IN(SELECT CustomerACID FROM [CurDat].[AdvAcBasicDetail] 
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
						 )

 UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Account ID can not be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Account ID can not be blank. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ACID' ELSE ErrorinColumn +','+SPACE(1)+  'ACID' END  
		,Srnooferroneousrows=V.SrNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM TwoAc A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM TwoAc V
--								-- WHERE ISNULL(V.ACID,'')<>''
--								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
--								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--								--										Timekey=@Timekey
--								--		))
--								--FOR XML PATH ('')
--								--),1,1,'')   
		FROM TwoAc V  
 WHERE ISNULL(V.ACID,'')=''

 ----
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Account ID cantains special character(s). Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Account ID cantains special character(s). Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ACID' ELSE ErrorinColumn +','+SPACE(1)+  'ACID' END  
		,Srnooferroneousrows=V.SrNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM TwoAc A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM TwoAc V
--								-- WHERE ISNULL(V.ACID,'')<>''
--								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
--								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--								--										Timekey=@Timekey
--								--		))
--								--FOR XML PATH ('')
--								--),1,1,'')   
		FROM TwoAc V  
 WHERE ISNULL(V.ACID,'') LIKE '%[^a-zA-Z0-9]%'


 IF OBJECT_ID('TEMPDB..#DUB2') IS NOT NULL
 DROP TABLE #DUB2

 SELECT * INTO #DUB2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY ACID ORDER BY ACID ) ROW FROM TwoAc
 )X
 WHERE ROW>1
   
   UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate records found.AccountID are repeated.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Duplicate records found. AccountID are repeated.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ACID' ELSE   ErrorinColumn +','+SPACE(1)+'ACID' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM TwoAc V  
 WHERE ISNULL(ACID,'')<>''
 AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID)



  
  /*validations on Amount*/
  
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'AMOUNT cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'AMOUNT cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Amount' ELSE   ErrorinColumn +','+SPACE(1)+'Amount' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
 WHERE ISNULL(Amount,'')='' --and ISNUMERIC(V.Amount)=0 



 
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'AMOUNT require numberic Values . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'AMOUNT require numberic Values . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Amount' ELSE   ErrorinColumn +','+SPACE(1)+'Amount' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
 WHERE ISNULL(Amount,'')<>'' AND ISNUMERIC(Amount)=0 





 ----------------------------------------------
 /*validations on Date*/
  
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DATE cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'DATE cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Date' ELSE   ErrorinColumn +','+SPACE(1)+'Date' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO   -- DATE cannot be blank . Please check the values and upload again
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
 WHERE ISNULL(Date,'')=''



  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format �dd-mm-yyyy�'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid date format. Please enter the date in format �dd-mm-yyyy�'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Date' ELSE   ErrorinColumn +','+SPACE(1)+'Date' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO   -- DATE cannot be blank . Please check the values and upload again
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
 WHERE ISNULL(Date,'')<>''and isdate(Date)=0




 ----------------------------------------------
 /*------------------validations on Action Flag -------Pranay 22-03-2021-----------------*/
  
  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Please enter (Y or N) value in Action column. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Please enter (Y or N) value in Action column. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Action' ELSE   ErrorinColumn +','+SPACE(1)+'Action' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
 WHERE v.Action NOT IN ('Y','N')
  

/*------------------validations on Action Flag -------02-04-2021-----------------*/
  
  DEclare @ParameterName as Varchar(100)
 Set @ParameterName = (select ParameterName from DimParameter where DimParameterName ='uploadflagtype' and EffectiveToTimeKey=49999 and ParameterAlt_Key=@UploadTypeParameterAlt_Key)

  

  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the selected flag. You can only add the marked flag for this account.'     
						ELSE ErrorMessage+','+SPACE(1)+'Account is not marked to the selected flag. You can only add the marked flag for this account.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Action' ELSE   ErrorinColumn +','+SPACE(1)+'Action' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
    WHERE v.Action IN ('N')
	And Not exists (Select 1 FRom ExceptionFinalStatusType A where A.ACID=V.ACID And A.StatusType=@ParameterName And A.EffectiveToTimeKey=49999)
  
  ------------------------------------------------------------------

  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account with selected flag is already pending for authorization. Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Account with selected flag is already pending for authorization. Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account' ELSE   ErrorinColumn +','+SPACE(1)+'Account' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
    WHERE v.Action IN ('N','Y')
	And  exists (Select 1 FRom AccountFlaggingDetails_Mod A where A.ACID=V.ACID And A.UploadTypeParameterAlt_Key=@UploadTypeParameterAlt_Key And A.EffectiveToTimeKey=49999 And AuthorisationStatus In ('NP','MP'))


-----------------------


  UPDATE TwoAc
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account with selected flag is already pending for authorization. Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Account with selected flag is already pending for authorization. Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account' ELSE   ErrorinColumn +','+SPACE(1)+'Account' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM TwoAc A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM TwoAc V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM TwoAc V  
    WHERE v.Action IN ('N','Y')
	And  exists (Select 1 FRom ExceptionalDegrationDetail_Mod A where A.AccountID=V.ACID And A.FlagAlt_Key=@UploadTypeParameterAlt_Key And A.EffectiveToTimeKey=49999 And AuthorisationStatus In ('NP','MP'))


-----------------------







 Print '123'
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Data'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  AccountFlagging_Stg WHERE filname=@FilePathUpload)
		BEGIN
		PRINT 'NO ERRORS'
			
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT '' SRNO , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 
			
		END
		ELSE
		BEGIN
			PRINT 'VALIDATION ERRORS'
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Srnooferroneousrows,Flag) 
			SELECT SrNo,ErrorinColumn,ErrorMessage,ErrorinColumn,@filepath,Srnooferroneousrows,'SUCCESS' 
			FROM TwoAc


			
		--	----SELECT * FROM TwoAc 

		--	--ORDER BY ErrorMessage,TwoAc.ErrorinColumn DESC
			goto final
		END

		

  IF EXISTS (SELECT 1 FROM  dbo.MasterUploadData   WHERE FileNames=@filepath AND  ISNULL(ERRORDATA,'')<>'') 
   -- added for delete Upload status while error while uploading data.  
   BEGIN  
   --SELECT * FROM #OAOLdbo.MasterUploadData
    delete from UploadStatus where FileNames=@filepath  
   END  
  --ELSE IF EXISTS (SELECT 1 FROM  UploadStatus where ISNULL(InsertionOfData,'')='' and FileNames=@filepath and UploadedBy=@UserLoginId)  -- added validated condition successfully, delete filename from Upload status  
  --  BEGIN  
  --  print 'RC'  
  --   delete from UploadStatus where FileNames=@filepath  
  --  END    --commented in [OAProvision].[GetStatusOfUpload] SP for checkin 'InsertionOfData' Flag  
  ELSE  
   BEGIN   
  
    Update UploadStatus Set ValidationOfData='Y',ValidationOfDataCompletedOn=GetDate()   
    where FileNames=@filepath  
  
   END  


  final:
IF EXISTS(SELECT 1 FROM dbo.MasterUploadData WHERE FileNames=@filepath AND ISNULL(ERRORDATA,'')<>''
		) 
	BEGIN
	PRINT 'ERROR'
		SELECT SR_No
				,ColumnName
				,ErrorData
				,ErrorType
				,FileNames
				,Flag
				,Srnooferroneousrows,'Validation'TableName
		FROM dbo.MasterUploadData
		WHERE FileNames=@filepath
		--(SELECT *,ROW_NUMBER() OVER(PARTITION BY ColumnName,ErrorData,ErrorType,FileNames ORDER BY ColumnName,ErrorData,ErrorType,FileNames )AS ROW 
		--FROM  dbo.MasterUploadData    )a 
		--WHERE A.ROW=1
		--AND FileNames=@filepath
		--AND ISNULL(ERRORDATA,'')<>''
	
		ORDER BY SR_No 

		 IF EXISTS(SELECT 1 FROM AccountFlagging_Stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM AccountFlagging_Stg
		 WHERE filname=@FilePathUpload

		 PRINT 1

		 PRINT 'ROWS DELETED FROM DBO.AccountFlagging_Stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		 END

	END
	ELSE
	BEGIN
	PRINT ' DATA NOT PRESENT'
		--SELECT *,'Data'TableName
		--FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		--ORDER BY ErrorData DESC
		SELECT SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows,'Data'TableName 
		FROM
		(
			SELECT *,ROW_NUMBER() OVER(PARTITION BY ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows
			ORDER BY ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows)AS ROW 
			FROM  dbo.MasterUploadData    
		)a 
		WHERE A.ROW=1
		AND FileNames=@filepath

	END

	----SELECT * FROM TwoAc

	print 'p'
  ------to delete file if it has errors
		--if exists(Select  1 from dbo.MasterUploadData where FileNames=@filepath and ISNULL(ErrorData,'')<>'')
		--begin
		--print 'ppp'
		-- IF EXISTS(SELECT 1 FROM IBPCPoolDetail_stg WHERE filname=@FilePathUpload)
		-- BEGIN
		-- print '123'
		-- DELETE FROM IBPCPoolDetail_stg
		-- WHERE filname=@FilePathUpload

		-- PRINT 'ROWS DELETED FROM DBO.IBPCPoolDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		-- END
		-- END

   
END  TRY
  
  BEGIN CATCH
	

	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	--IF EXISTS(SELECT 1 FROM IBPCPoolDetail_stg WHERE filname=@FilePathUpload)
	--	 BEGIN
	--	 DELETE FROM IBPCPoolDetail_stg
	--	 WHERE filname=@FilePathUpload

	--	 PRINT 'ROWS DELETED FROM DBO.IBPCPoolDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
	--	 END

END CATCH

END
  

GO
