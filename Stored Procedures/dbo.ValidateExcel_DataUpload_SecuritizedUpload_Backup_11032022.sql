SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ValidateExcel_DataUpload_SecuritizedUpload_Backup_11032022] 
@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='FNASUPERADMIN',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='SecuritizedUpload.xlsx'  
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
   -- Update UploadStatus Set ValidationOfData='N' where FileNames=@filepath  
     
	 SET DATEFORMAT DMY

 ----Select @Timekey=Max(Timekey) from dbo.SysProcessingCycle  
 ---- where  ProcessType='Quarterly' ----and PreMOC_CycleFrozenDate IS NULL
 
 Select   @Timekey=Max(Timekey) from sysDayMatrix where Cast(date as Date)=cast(getdate() as Date)

  PRINT @Timekey  
  
 --DECLARE @DepartmentId SMALLINT ,@DepartmentCode varchar(100)  
 --SELECT  @DepartmentId= DepartmentId FROM dbo.DimUserInfo   
 --WHERE EffectiveFromTimeKey <= @Timekey AND EffectiveToTimeKey >= @Timekey  
 --AND UserLoginID = @UserLoginId  
 --PRINT @DepartmentId  
 --PRINT @DepartmentCode  
  
    
  
-- SELECT @DepartmentCode=DepartmentCode FROM AxisIntReversalDB.DimDepartment   
--     WHERE EffectiveFromTimeKey <= @Timekey AND EffectiveToTimeKey >= @Timekey   
--     --AND DepartmentCode IN ('BBOG','FNA')  
--     AND DepartmentAlt_Key = @DepartmentId  
  
--     print @DepartmentCode  
--     --Select @DepartmentCode=REPLACE('',@DepartmentCode,'_')  
     
       
  
   
  
  DECLARE @FilePathUpload	VARCHAR(100)

			SET @FilePathUpload=@UserLoginId+'_'+@filepath
	PRINT '@FilePathUpload'
	PRINT @FilePathUpload

	IF EXISTS(SELECT 1 FROM dbo.MasterUploadData    where FileNames=@filepath )
	BEGIN
		Delete from dbo.MasterUploadData    where FileNames=@filepath  
		print @@rowcount
	END


--IF (@MenuID=14573)	
BEGIN


	  -- IF OBJECT_ID('tempdb..#Securitized') IS NOT NULL  
	  --BEGIN  
	  -- DROP TABLE #Securitized  
	
	  --END
	   --DROP TABLE IF EXISTS Securitized
	    IF OBJECT_ID('Securitized') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  Securitized
	
	  END 

  IF NOT (EXISTS (SELECT * FROM SecuritizedDetail_stg where filname=@FilePathUpload))

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
 	   into Securitized 
	   from SecuritizedDetail_stg 
	   WHERE filname=@FilePathUpload

END
--  ------------------------------------------------------------------------------  
--    ----SELECT * FROM Securitized
--	--SrNo	Territory	ACID	InterestReversalAmount	filname
	UPDATE Securitized
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='PoolName,PoolID,CustomerID,AccountID,SecuritisationType,OSBalanceinRs,InterestReceivableinRs,
		PrincipalOutstandinginRs,SecuritisationExposureinRs,Dates'    
		,Srnooferroneousrows=V.SrNo
 FROM Securitized V  
 WHERE 
 --ISNULL(V.SrNo,'')=''
-- ----AND ISNULL(Territory,'')=''
  ISNULL(PoolName,'')=''
 AND ISNULL(PoolID,'')=''
 AND ISNULL(CustomerID,'')=''
 AND ISNULL(AccountID,'')=''
 AND ISNULL(SecuritisationType,'')=''
 AND ISNULL(OSBalanceinRs,'')=''
 AND ISNULL(InterestReceivableinRs,'')=''
 AND ISNULL(PrincipalOutstandinginRs,'')=''
 AND ISNULL(SecuritisationExposureinRs,'')=''
 AND ISNULL(DateofSecuritisationReckoning,'')=''
 AND ISNULL(DateofSecuritisationMarking,'')=''
 AND ISNULL(MaturityDate,'')=''
 AND ISNULL(filname,'')=''

  IF EXISTS(SELECT 1 FROM Securitized WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO ERRORDATA;
  END

  
/*validations on POOLID*/
  
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'PoolID cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolID' ELSE   ErrorinColumn +','+SPACE(1)+'PoolID' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM Securitized A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM Securitized V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(PoolID,'')=''


  


 
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PoolID.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid PoolID.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolID' ELSE   ErrorinColumn +','+SPACE(1)+'PoolID' END       
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM Securitized A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND LEN(PoolID)>20

 ----------------------------------------------
 /*validations on PoolName*/
  
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolName cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'PoolName cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM Securitized A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM Securitized V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(PoolName,'')=''


  


 
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PoolName.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid PoolName.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END       
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM Securitized A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(PoolName,'')<>''
 AND LEN(PoolName)>20



 ------------------------------------------------------
 /*validations on SecuritisationType*/
  
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SecuritisationType cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'SecuritisationType cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationType' ELSE   ErrorinColumn +','+SPACE(1)+'SecuritisationType' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM Securitized A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM Securitized V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(SecuritisationType,'')=''


  


 
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid SecuritisationType.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid SecuritisationType.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationType' ELSE   ErrorinColumn +','+SPACE(1)+'SecuritisationType' END       
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM Securitized A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM Securitized V  
 WHERE ISNULL(SecuritisationType,'')<>''
 AND LEN(SecuritisationType)>40--20


 
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid SecuritisationType.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid SecuritisationType.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationType' ELSE   ErrorinColumn +','+SPACE(1)+'SecuritisationType' END       
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM Securitized A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM Securitized V  
 --WHERE ISNULL(SecuritisationType,'')<>'' And SecuritisationType not in ('PTC - Pass Thru Certificate','DA - Direct Assignment')

 WHERE ISNULL(SecuritisationType,'')<>'' And SecuritisationType not in ('PTC','DA')				---Changes on 19-05-2021 on advice of Ravish ------
 


 ------------------------------------------------

/*VALIDATIONS ON AccountID */

  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account ID cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Account ID cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM Securitized V  
 WHERE ISNULL(AccountID,'')='' 
 

-- ----SELECT * FROM Securitized
  
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Account ID found. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								-- WHERE ISNULL(V.ACID,'')<>''
--								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
--								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--								--										Timekey=@Timekey
--								--		))
--								--FOR XML PATH ('')
--								--),1,1,'')   
		FROM Securitized V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND V.AccountID NOT IN(SELECT CustomerACID FROM [CurDat].[AdvAcBasicDetail] 
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
						 )


 IF OBJECT_ID('TEMPDB..#DUB2') IS NOT NULL
 DROP TABLE #DUB2

 SELECT * INTO #DUB2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY AccountID ) ROW FROM Securitized
 )X
 WHERE ROW>1
   
   UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate records found.AccountID are repeated.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Duplicate records found. AccountID are repeated.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccountID' ELSE   ErrorinColumn +','+SPACE(1)+'AccountID' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(AccountID,'')<>''
 AND AccountID IN(SELECT AccountID FROM #DUB2 GROUP BY AccountID)


 ----------------------------------------------

 
/*VALIDATIONS ON CustomerID */

  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CustomerID cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'CustomerID cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE ErrorinColumn +','+SPACE(1)+  'CustomerID' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM Securitized V  
 WHERE ISNULL(CustomerID,'')='' 
 

-- ----SELECT * FROM Securitized
  
  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid CustomerID found. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid CustomerID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE ErrorinColumn +','+SPACE(1)+  'CustomerID' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								-- WHERE ISNULL(V.ACID,'')<>''
--								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
--								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--								--										Timekey=@Timekey
--								--		))
--								--FOR XML PATH ('')
--								--),1,1,'')   
		FROM Securitized V  
 WHERE ISNULL(V.CustomerID,'')<>''
  AND V.CustomerID NOT IN(SELECT RefCustomerId FROM [CurDat].[AdvAcBasicDetail] A
                                         Inner Join Securitized V on A.CustomerACID=V.AccountID
								WHERE A.EffectiveFromTimeKey<=@Timekey AND A.EffectiveToTimeKey>=@Timekey
						 )

 --AND V.CustomerID NOT IN(SELECT CustomerID FROM [CurDat].[CustomerBasicDetail] 
	--							WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
	--					 )


 ----------------------------------------------


---- ----SELECT * FROM Securitized
   


/*validations on PrincipalOutstandinginRs */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PrincipalOutstandinginRs cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PrincipalOutstandinginRs cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstandinginRs' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstandinginRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PrincipalOutstandinginRs,'')=''

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid PrincipalOutstandinginRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid PrincipalOutstandinginRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstandinginRs' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstandinginRs' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM Securitized V  
 WHERE (ISNUMERIC(PrincipalOutstandinginRs)=0 AND ISNULL(PrincipalOutstandinginRs,'')<>'') OR 
 ISNUMERIC(PrincipalOutstandinginRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid PrincipalOutstandinginRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid PrincipalOutstandinginRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstandinginRs' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstandinginRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PrincipalOutstandinginRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE Securitized
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PrincipalOutstandinginRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid PrincipalOutstandinginRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstandinginRs' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstandinginRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT SRNO FROM Securitized WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PrincipalOutstandinginRs,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(PrincipalOutstandinginRs,0)) <0

 -----------------------------------------------------------------
 

/*validations on InterestReceivableinRsinRs */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InterestReceivableinRs cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'InterestReceivableinRs cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(InterestReceivableinRs,'')=''

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivableinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid InterestReceivableinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM Securitized V  
 WHERE (ISNUMERIC(InterestReceivableinRs)=0 AND ISNULL(InterestReceivableinRs,'')<>'') OR 
 ISNUMERIC(InterestReceivableinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivableinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivableinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRsinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(InterestReceivableinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE Securitized
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid InterestReceivableinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivableinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT SRNO FROM Securitized WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(InterestReceivableinRs,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReceivableinRs,0)) <0

 -----------------------------------------------------------------
 

/*validations on PoolOSBalanceinRs */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'OSBalanceinRs cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'OSBalanceinRs cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'OSBalanceinRs' ELSE ErrorinColumn +','+SPACE(1)+  'OSBalanceinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(OSBalanceinRs,'')=''

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid OSBalanceinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid OSBalanceinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'OSBalanceinRs' ELSE ErrorinColumn +','+SPACE(1)+  'OSBalanceinRs' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM Securitized V  
 WHERE (ISNUMERIC(OSBalanceinRs)=0 AND ISNULL(OSBalanceinRs,'')<>'') OR 
 ISNUMERIC(OSBalanceinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid OSBalanceinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid OSBalanceinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'OSBalanceinRs' ELSE ErrorinColumn +','+SPACE(1)+  'OSBalanceinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(OSBalanceinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE Securitized
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid OSBalanceinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid OSBalanceinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'OSBalanceinRs' ELSE ErrorinColumn +','+SPACE(1)+  'OSBalanceinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT SRNO FROM Securitized WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(OSBalanceinRs,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(OSBalanceinRs,0)) <0

 -----------------------------------------------------------------

 

/*validations on SecuritisationExposureinRs */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SecuritisationExposureinRs cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'SecuritisationExposureinRs cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationExposureinRs' ELSE ErrorinColumn +','+SPACE(1)+  'SecuritisationExposureinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(SecuritisationExposureinRs,'')=''

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid SecuritisationExposureinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid SecuritisationExposureinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationExposureinRs' ELSE ErrorinColumn +','+SPACE(1)+  'SecuritisationExposureinRs' END  
		,Srnooferroneousrows=V.SRNO
--								--STUFF((SELECT ','+SRNO 
--								--FROM Securitized A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM Securitized V  
 WHERE (ISNUMERIC(SecuritisationExposureinRs)=0 AND ISNULL(SecuritisationExposureinRs,'')<>'') OR 
 ISNUMERIC(SecuritisationExposureinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid SecuritisationExposureinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid SecuritisationExposureinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationExposureinRs' ELSE ErrorinColumn +','+SPACE(1)+  'SecuritisationExposureinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM Securitized V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(SecuritisationExposureinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE Securitized
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid SecuritisationExposureinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid SecuritisationExposureinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationExposureinRs' ELSE ErrorinColumn +','+SPACE(1)+  'SecuritisationExposureinRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM Securitized A
--								----WHERE A.SrNo IN(SELECT SRNO FROM Securitized WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(SecuritisationExposureinRs,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(SecuritisationExposureinRs,0)) <0

 -----------------------------------------------------------------

 /*validations on DateofSecuritisationReckoning */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofSecuritisationReckoning Can not be Blank . Please enter the DateofSecuritisationReckoning and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'DateofSecuritisationReckoning Can not be Blank. Please enter the DateofSecuritisationReckoning and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationReckoning' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationReckoning' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(DateofSecuritisationReckoning,'')='' 


UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationReckoning' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationReckoning' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(DateofSecuritisationReckoning,'')<>'' AND ISDATE(DateofSecuritisationReckoning)=0


 
--UPDATE Securitized
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofSecuritisationReckoning Can not be Greater than Other Two. Please enter the Correct Date'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DateofSecuritisationReckoning Can not be Greater than Other Two. Please enter the Correct Date'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationReckoning' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationReckoning' END      
--		,Srnooferroneousrows=V.SrNo
--		--STUFF((SELECT ','+SRNO 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM Securitized V  
-- WHERE ISNULL(DateofSecuritisationReckoning,'')<>'' AND (Convert(Date,DateofSecuritisationReckoning,103)>Convert(Date,DateofSecuritisationMarking,103) OR Convert(Date,DateofSecuritisationReckoning,103)>Convert(Date,MaturityDate,103))



 --------------------------------------

 
 /*validations on DateofSecuritisationMarking */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofSecuritisationMarking Can not be Blank . Please enter the DateofSecuritisationMarking and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'DateofSecuritisationMarking Can not be Blank. Please enter the DateofSecuritisationMarking and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationMarking' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationMarking' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(DateofSecuritisationMarking,'')='' 


UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationMarking' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationMarking' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(DateofSecuritisationMarking,'')<>'' AND ISDATE(DateofSecuritisationMarking)=0


 
--UPDATE Securitized
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofSecuritisationMarking Can not be Greater than Other Maturity and not less to DateofSecuritisationMarking. Please enter the Correct Date'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DateofSecuritisationMarking Can not be Greater than Other Maturity and not less to DateofSecuritisationMarking. Please enter the Correct Date'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationMarking' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationMarking' END      
--		,Srnooferroneousrows=V.SrNo
--		--STUFF((SELECT ','+SRNO 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM Securitized V  
-- WHERE ISNULL(DateofSecuritisationMarking,'')<>'' AND (Convert(Date,DateofSecuritisationMarking,103)<Convert(Date,DateofSecuritisationReckoning,103) OR Convert(Date,DateofSecuritisationMarking,103)>Convert(Date,MaturityDate,103))



 --------------------------------------

 
 /*validations on MaturityDate */

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'MaturityDate Can not be Blank . Please enter the MaturityDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'MaturityDate Can not be Blank. Please enter the MaturityDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MaturityDate' ELSE   ErrorinColumn +','+SPACE(1)+'MaturityDate' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(MaturityDate,'')='' 


UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MaturityDate' ELSE   ErrorinColumn +','+SPACE(1)+'MaturityDate' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(MaturityDate,'')<>'' AND ISDATE(MaturityDate)=0

 /*          Commented on 21-05-2021 on advice of Shishir Sir
 ----------------For Flag Checking in main table

 
UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Already securitized Flag is present. Please Check the Account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Already securitized Flag is present. Please Check the Account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccountID' ELSE   ErrorinColumn +','+SPACE(1)+'AccountID' END      
		,Srnooferroneousrows=V.SrNo
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM Securitized V  
 Inner Join Dbo.AdvAcOtherDetail A ON V.AccountID=A.RefSystemAcId And A.EffectiveToTimeKey=49999
 WHERE A.SplFlag like '%Securitised%'
 */
 ------------------------------------------------------

 
--UPDATE Securitized
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'MaturityDate Can not be Less than Other Two. Please enter the Correct Date'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'MaturityDate Can not be Less than Other Two. Please enter the Correct Date'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MaturityDate' ELSE   ErrorinColumn +','+SPACE(1)+'MaturityDate' END      
--		,Srnooferroneousrows=V.SrNo
--		--STUFF((SELECT ','+SRNO 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM Securitized V  
-- WHERE ISNULL(MaturityDate,'')<>'' AND (Convert(Date,MaturityDate,103)<Convert(Date,DateofSecuritisationMarking,103) OR Convert(Date,MaturityDate,103)<Convert(Date,DateofSecuritisationMarking,103))




 --------------------------------------

 /*  Validations on MisMatch DateofSecuritisationReckoning  */
 /*
 IF OBJECT_ID('TEMPDB..#Date1') IS NOT NULL
 DROP TABLE #Date1

 SELECT * INTO #Date1 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY PoolID,DateofSecuritisationReckoning ORDER BY  PoolID,DateofSecuritisationReckoning ) ROW FROM Securitized
 )X
 WHERE ROW>1

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of DateofSecuritisationReckoning. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of DateofSecuritisationReckoning. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationReckoning' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationReckoning' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND PoolID IN(SELECT PoolID FROM #Date1 GROUP BY PoolID)
 */
 ---------------------------------
 
 /*  Validations on MisMatch DateofSecuritisationMarking  */
 /* IF OBJECT_ID('TEMPDB..#Date2') IS NOT NULL
 DROP TABLE #Date2

 SELECT * INTO #Date2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY PoolID,DateofSecuritisationMarking ORDER BY  PoolID,DateofSecuritisationMarking ) ROW FROM Securitized
 )X
 WHERE ROW>1

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of DateofSecuritisationMarking. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of DateofSecuritisationMarking. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationMarking' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationMarking' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND PoolID IN(SELECT PoolID FROM #Date2 GROUP BY PoolID)
 */
 ---------------------------------
 
 /*  Validations on MisMatch MaturityDate  */

 /*IF OBJECT_ID('TEMPDB..#Date3') IS NOT NULL
 DROP TABLE #Date3

 SELECT * INTO #Date3 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY PoolID,DateofSecuritisationMarking ORDER BY  PoolID,DateofSecuritisationMarking ) ROW FROM Securitized
 )X
 WHERE ROW>1

 UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of MaturityDate. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of MaturityDate. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MaturityDate' ELSE   ErrorinColumn +','+SPACE(1)+'MaturityDate' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND PoolID IN(SELECT PoolID FROM #Date3 GROUP BY PoolID)
 */

 
/*-------------------PoolName-Validation------------------------- */ -- changes done on 19-03-21 Pranay 
 Declare @PoolNameCnt int=0,@SecuritisationType int=0
 --DROP TABLE IF EXISTS PoolNameData
  IF OBJECT_ID('PoolNameSecuritizedData') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  PoolNameSecuritizedData
	
	  END 
 SELECT * into PoolNameSecuritizedData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) 
 ROW ,PoolID,PoolName,AccountID FROM Securitized
 )X
 WHERE ROW=1


 SELECT @PoolNameCnt=COUNT(*) FROM PoolNameSecuritizedData a
 INNER JOIN Securitized b
 ON a.PoolID=b.PoolID 
 WHERE a.PoolName<>b.PoolName

 IF @PoolNameCnt>0
 BEGIN
  PRINT 'PoolName ERROR'
   UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Different PoolID of same combination of PoolName is Available. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different PoolID of same combination of PoolName and SecuritisationType is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND  AccountID IN(
				 SELECT DISTINCT B.AccountID from PoolNameSecuritizedData a
				 INNER JOIN Securitized b
				 on a.PoolID=b.PoolID 
				 where a.PoolName<>b.PoolName
				 )

 END

 -------------SecuritisationType----------------------------------changes done on 20-03-21 Pranay 

DROP TABLE IF EXISTS SecuritisationTypeData
  SELECT * into SecuritisationTypeData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) 
 ROW ,PoolID,SecuritisationType,AccountID FROM Securitized
 )X
 WHERE ROW=1


 select @SecuritisationType=COUNT(*) from SecuritisationTypeData a
 INNER JOIN Securitized b
 on a.PoolID=b.PoolID 
 where a.SecuritisationType<>b.SecuritisationType

  IF @SecuritisationType>0
 BEGIN
  PRINT 'SecuritisationType ERROR'

  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Different PoolID of same combination of SecuritisationType is Available. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different PoolID of same combination of PoolName and SecuritisationType is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SecuritisationType' ELSE   ErrorinColumn +','+SPACE(1)+'SecuritisationType' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND AccountID IN(
				 SELECT DISTINCT B.AccountID from SecuritisationTypeData a
				 INNER JOIN Securitized b
				 on a.PoolID=b.PoolID 
				 where a.SecuritisationType<>b.SecuritisationType
				 )
 END

 /*Same PoolName present in Multiple poolID*/ -- pRANAY 20-03-21

Declare @PoolNameCnt1 int=0
 DROP TABLE IF EXISTS PoolNameSecuritizedData1
 SELECT * into PoolNameSecuritizedData1  
 FROM(SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) ROW,
			PoolID,PoolName,AccountID FROM Securitized
	 )X
 WHERE ROW=1


 SELECT @PoolNameCnt1=COUNT(*)
  FROM PoolNameSecuritizedData1 a
 inner JOIN Securitized b
 ON a.PoolName=b.PoolName 
 WHERE a.PoolID<>b.PoolID

 IF @PoolNameCnt1>0
 BEGIN
  PRINT 'Same PoolName present in Multiple poolID'
   UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Same PoolName present in Multiple poolID. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different PoolID of same combination of PoolName and SecuritisationType is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND  AccountID IN(
				 SELECT DISTINCT A.AccountID from PoolNameSecuritizedData1 a
				 INNER JOIN Securitized b
				 ON a.PoolName=b.PoolName 
				WHERE a.PoolID<>b.PoolID
				 )

 END

 -------------------DateofSecuritisationreckoning-------------------------- Pranay 20-03-21
 DECLARE @DateofSecuritisationreckoningCnt INT=0
 DROP TABLE IF EXISTS DateofSecuritisationreckoningData
 SELECT * INTO DateofSecuritisationreckoningData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) 
 ROW ,PoolID,DateofSecuritisationreckoning,AccountID FROM Securitized
 )X
 WHERE ROW=1


 SELECT @DateofSecuritisationreckoningCnt=COUNT(*) 
 FROM DateofSecuritisationreckoningData a
 INNER JOIN Securitized b
 ON a.PoolID=b.PoolID 
 WHERE a.DateofSecuritisationreckoning<>b.DateofSecuritisationreckoning

 IF @DateofSecuritisationreckoningCnt>0
 BEGIN
	PRINT 'DateofSecuritisationreckoning ERROR'

	UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of DateofSecuritisationreckoning. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of DateofSecuritisationreckoning. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationreckoning' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationreckoning' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND  AccountID IN(
				 SELECT DISTINCT B.AccountID from DateofSecuritisationreckoningData a
				 INNER JOIN Securitized  b
				 on a.PoolID=b.PoolID 
				 where a.DateofSecuritisationreckoning<>b.DateofSecuritisationreckoning
				 )

 END

 -------------------DateofSecuritisationmarking--------------------------Pranay 20-03-21
 DECLARE @DateofSecuritisationmarkingCnt INT=0
 DROP TABLE IF EXISTS DateofSecuritisationmarkingData
 SELECT * INTO DateofSecuritisationmarkingData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) 
 ROW ,PoolID,DateofSecuritisationmarking FROM Securitized
 )X
 WHERE ROW=1


 SELECT @DateofSecuritisationmarkingCnt=COUNT(*) 
 FROM DateofSecuritisationmarkingData a
 INNER JOIN Securitized b
 ON a.PoolID=b.PoolID 
 WHERE a.DateofSecuritisationmarking<>b.DateofSecuritisationmarking

 IF @DateofSecuritisationmarkingCnt>0
 BEGIN
	PRINT 'DateofSecuritisationmarking ERROR'

	UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of DateofSecuritisationmarking. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of DateofSecuritisationmarking. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSecuritisationmarking' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSecuritisationmarking' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND  AccountID IN(
				 SELECT DISTINCT B.AccountID from DateofSecuritisationmarkingData a
				 INNER JOIN Securitized b
				 on a.PoolID=b.PoolID 
				 where a.DateofSecuritisationmarking<>b.DateofSecuritisationmarking
				 )
 END

 -------------------@MaturityDate--------------------------Pranay 20-03-2021
 DECLARE @MaturityDateCnt int=0
 DROP TABLE IF EXISTS MaturityDateData
 SELECT * into MaturityDateData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY PoolID  ORDER BY  PoolID ) 
 ROW ,PoolID,MaturityDate FROM Securitized
 )X
 WHERE ROW=1


 SELECT @MaturityDateCnt=COUNT(*) 
 FROM MaturityDateData a
 INNER JOIN Securitized b
 ON a.PoolID=b.PoolID 
 WHERE a.MaturityDate<>b.MaturityDate

 IF @MaturityDateCnt>0
 BEGIN
  PRINT 'MaturityDate ERROR'

  UPDATE Securitized
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolID found different Dates of MaturityDate. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PoolID found different Dates of MaturityDate. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MaturityDate' ELSE   ErrorinColumn +','+SPACE(1)+'MaturityDate' END     
		,Srnooferroneousrows=V.SrNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM Securitized V  
 WHERE ISNULL(PoolID,'')<>''
 AND  AccountID IN(
				 SELECT DISTINCT B.AccountID from MaturityDateData a
				 INNER JOIN Securitized b
				 on a.PoolID=b.PoolID 
				 where a.MaturityDate<>b.MaturityDate
				 )


 END



 ---------------------------------



 
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Validation'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  SecuritizedDetail_stg WHERE filname=@FilePathUpload)
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
			FROM Securitized 


			
		--	----SELECT * FROM Securitized 

		--	--ORDER BY ErrorMessage,Securitized.ErrorinColumn DESC
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

		 IF EXISTS(SELECT 1 FROM SecuritizedDetail_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM SecuritizedDetail_stg
		 WHERE filname=@FilePathUpload

		 PRINT 1

		 PRINT 'ROWS DELETED FROM DBO.SecuritizedDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		 END

	END
	ELSE
	BEGIN
	PRINT ' DATA NOT PRESENT'
		--SELECT *,'Data'TableName
		--FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		--ORDER BY ErrorData DESC
		SELECT SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows,'Validation'TableName 
		FROM
		(
			SELECT *,ROW_NUMBER() OVER(PARTITION BY ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows
			ORDER BY ColumnName,ErrorData,ErrorType,FileNames,Flag,Srnooferroneousrows)AS ROW 
			FROM  dbo.MasterUploadData    
		)a 
		WHERE A.ROW=1
		AND FileNames=@filepath

	END

	----SELECT * FROM Securitized

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

	--IF EXISTS(SELECT 1 FROM SecuritizedDetail_stg WHERE filname=@FilePathUpload)
	--	 BEGIN
	--	 DELETE FROM SecuritizedDetail_stg
	--	 WHERE filname=@FilePathUpload

	--	 PRINT 'ROWS DELETED FROM DBO.SecuritizedDetail_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
	--	 END

END CATCH

END
GO
