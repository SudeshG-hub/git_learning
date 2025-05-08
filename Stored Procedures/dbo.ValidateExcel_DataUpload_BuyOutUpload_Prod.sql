SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[ValidateExcel_DataUpload_BuyOutUpload_Prod] 
@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='fnachecker',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='BuyoutUPLOAD.xlsx'  
WITH RECOMPILE  
AS  
  


--DECLARE  
  
--@MenuID INT=1466,  
--@UserLoginId varchar(20)=N'2ndlvlchecker',  
--@Timekey int=N'25999'
--,@filepath varchar(500)=N'BuyoutUpload (3).xlsx'  
  
BEGIN

BEGIN TRY  
--BEGIN TRAN  
  
--Declare @TimeKey int  
    --Update UploadStatus Set ValidationOfData='N' where FileNames=@filepath  
     
	 SET DATEFORMAT DMY

 --Select @Timekey=Max(Timekey) from dbo.SysProcessingCycle  
 -- where  ProcessType='Quarterly' ----and PreMOC_CycleFrozenDate IS NULL
 
 Set  @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
                    Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
                       where A.CurrentStatus='C')

--Select   @Timekey=Max(Timekey) from sysDayMatrix where Cast(date as Date)=cast(getdate() as Date)

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


IF (@MenuID=1466)	
BEGIN


	  -- IF OBJECT_ID('tempdb..#UploadBuyout') IS NOT NULL  
	  --BEGIN  
	  -- DROP TABLE #UploadBuyout  
	
	  --END
	  IF OBJECT_ID('UploadBuyout') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  UploadBuyout
	
	  END
	  
  IF NOT (EXISTS (SELECT * FROM BuyoutDetails_stg where filname=@FilePathUpload))

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
 	   into UploadBuyout 
	   from BuyoutDetails_stg 
	   WHERE filname=@FilePathUpload

	  
END
  ------------------------------------------------------------------------------  
  --select * from BuyoutDetails_stg
    ----SELECT * FROM UploadBuyout
	--SrNo	Territory	ACID	InterestReversalAmount	filname
	UPDATE UploadBuyout
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='SlNo,AUNo,PoolName,Category,BuyoutPartyLoanNo,CustomerName,PAN,AadharNo,PrincipalOutstanding,
		InterestReceivable,Charges,AccuredInterest,DPD,AssetClass'    
		,Srnooferroneousrows=''
 FROM UploadBuyout V  
 WHERE ISNULL(SlNo,'')=''
AND ISNULL(AUNo,'')=''
AND ISNULL(PoolName,'')=''
AND ISNULL(Category,'')=''
AND ISNULL(BuyoutPartyLoanNo,'')=''
AND ISNULL(CustomerName,'')=''
AND ISNULL(PAN,'')=''
AND ISNULL(AadharNo,'')=''
AND ISNULL(PrincipalOutstanding,'')=''
AND ISNULL(InterestReceivable,'')=''
AND ISNULL(Charges,'')=''
AND ISNULL(AccuredInterest,'')=''
AND ISNULL(DPD,'')=''
AND ISNULL(AssetClass,'')=''
--WHERE ISNULL(V.SrNo,'')=''
-- ----AND ISNULL(Territory,'')=''
-- AND ISNULL(AccountID,'')=''
-- AND ISNULL(PoolID,'')=''
-- AND ISNULL(filname,'')=''

  IF EXISTS(SELECT 1 FROM UploadBuyout WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO ERRORDATA;
  END



-----validations on Srno
	print 'Validation Error MSG'
	 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 	'SlNo is mandatory. Kindly check and upload again' 
		                  ELSE ErrorMessage+','+SPACE(1)+ 'SlNo is mandatory. Kindly check and upload again'
		  END
		,ErrorinColumn='SRNO'    
		,Srnooferroneousrows=''
	FROM UploadBuyout V  
	WHERE ISNULL(v.SlNo,'')=''  
	 Print '1'

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid SlNo, kindly check and upload again'     
								  ELSE ErrorMessage+','+SPACE(1)+ 'Invalid SlNo, kindly check and upload again'      END
		,ErrorinColumn='SRNO'    
		,Srnooferroneousrows=SlNo
		
 FROM UploadBuyout V  
 WHERE ISNULL(v.SlNo,'')='0'  OR ISNUMERIC(v.SlNo)=0
  Print '2'
  
  IF OBJECT_ID('TEMPDB..#R') IS NOT NULL
  DROP TABLE #R

  SELECT * INTO #R FROM(
  SELECT *,ROW_NUMBER() OVER(PARTITION BY SlNo ORDER BY SlNo)ROW
   FROM UploadBuyout
   )A
   WHERE ROW>1

 PRINT 'DUB'  


  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate SlNo, kindly check and upload again' 
					ELSE ErrorMessage+','+SPACE(1)+     'Duplicate SlNo, kindly check and upload again' END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE ErrorinColumn +','+SPACE(1)+  'SlNo' END
		,Srnooferroneousrows=SlNo
		--STUFF((SELECT DISTINCT ','+SlNo 
		--						FROM UploadBuyout
		--						FOR XML PATH ('')
		--						),1,1,'')
         
		
 FROM UploadBuyout V  
	WHERE  V.SlNo IN(SELECT SlNo FROM #R )
	Print '3'
/*validations on AUNo*/
  
  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'AUNo cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'AUNo cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AUNo' ELSE   ErrorinColumn +','+SPACE(1)+'AUNo' END   
		,Srnooferroneousrows=V.SlNo
								--STUFF((SELECT ','+SlNo 
								--FROM UploadBuyout A
								--WHERE A.SlNo IN(SELECT V.SlNo  FROM UploadBuyout V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM UploadBuyout V  
 WHERE ISNULL(AUNo,'')=''


  


 
  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid AUNo.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid AUNo.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AUNo' ELSE   ErrorinColumn +','+SPACE(1)+'AUNo' END       
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SlNo 
	--							FROM UploadBuyout A
	--							WHERE A.SlNo IN(SELECT V.SlNo FROM UploadBuyout V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM UploadBuyout V  
 WHERE ISNULL(AUNo,'')<>''
 AND LEN(AUNo)>20

  
  
 ----------------------------------------------
 /*validations on PoolName*/
  
  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PoolName cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'PoolName cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END   
		,Srnooferroneousrows=V.SlNo
								--STUFF((SELECT ','+SlNo 
								--FROM UploadBuyout A
								--WHERE A.SlNo IN(SELECT V.SlNo  FROM UploadBuyout V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM UploadBuyout V  
 WHERE ISNULL(PoolName,'')=''


  


 
  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PoolName.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid PoolName.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END       
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SlNo 
	--							FROM UploadBuyout A
	--							WHERE A.SlNo IN(SELECT V.SlNo FROM UploadBuyout V  
 --WHERE ISNULL(SOLID,'')<>''
 --AND  LEN(SOLID)>10)
	--							FOR XML PATH ('')
	--							),1,1,'')
   
   FROM UploadBuyout V  
 WHERE ISNULL(PoolName,'')<>''
 AND LEN(PoolName)>20


-------------------------------------------------
/*VALIDATIONS ON Category */


UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
		'Category is mandatory. Kindly check and upload again' 
		ELSE 
		case WHEN (v.Category = 'With Risk Sharing' OR v.Category = 'Without With Risk Sharing') then v.Category else 'Invalid value in Category. Kindly enter value ‘With Risk Sharing’ or ‘Without Risk Sharing’ and upload again' END END  
		,ErrorinColumn='Category'    
		,Srnooferroneousrows=''
	FROM UploadBuyout v  
	WHERE ISNULL(v.Category,'')=''  

----------------------------------------------------------------

/* Commented on 14-05-2021 sunil on shishir advice  */

--UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in Category. Kindly enter value ‘With Risk Sharing’ or ‘Without Risk Sharing’ and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+'Invalid value in Category. Kindly enter value ‘With Risk Sharing’ or ‘Without Risk Sharing’ and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Category' ELSE   ErrorinColumn +','+SPACE(1)+'Category' END       
--		,Srnooferroneousrows=V.SlNo
--	FROM UploadBuyout v  
--	WHERE ISNULL(v.Category,'')<>''  
--	And V.Category Not In ('With Risk Sharing','Without With Risk Sharing')


-------------Added on 18-05-2021 sunil on mohsin advice

UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in Category. Kindly enter value ‘Agri’ or ‘Marginal’ or ‘Small’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid value in Category. Kindly enter value ‘Agri’ or ‘Marginal’ or ‘Small’and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Category' ELSE   ErrorinColumn +','+SPACE(1)+'Category' END       
		,Srnooferroneousrows=V.SlNo
	FROM UploadBuyout v  
	WHERE ISNULL(v.Category,'')<>''  
	And V.Category Not In ('Agri','Marginal','Small')



/*VALIDATIONS ON BuyoutPartyLoanNo */

  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'BuyoutPartyLoanNo cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'BuyoutPartyLoanNo cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'BuyoutPartyLoanNo' ELSE ErrorinColumn +','+SPACE(1)+  'BuyoutPartyLoanNo' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadBuyout A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadBuyout V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM UploadBuyout V  
 WHERE ISNULL(BuyoutPartyLoanNo,'')='' 
 

-- ----SELECT * FROM UploadBuyout
  
--  UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid BuyoutPartyLoanNo found. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+'Invalid BuyoutPartyLoanNo found. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'BuyoutPartyLoanNo' ELSE ErrorinColumn +','+SPACE(1)+  'BuyoutPartyLoanNo' END  
--		,Srnooferroneousrows=V.SlNo
----								--STUFF((SELECT ','+SlNo 
----								--FROM UploadBuyout A
----								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadBuyout V
----								-- WHERE ISNULL(V.ACID,'')<>''
----								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
----								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
----								--										Timekey=@Timekey
----								--		))
----								--FOR XML PATH ('')
----								--),1,1,'')   
--		FROM UploadBuyout V  
-- WHERE ISNULL(V.BuyoutPartyLoanNo,'')<>''
-- AND V.BuyoutPartyLoanNo NOT IN(SELECT CustomerACID FROM [CurDat].[AdvAcBasicDetail] 
--								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--						 )


 IF OBJECT_ID('TEMPDB..#DUB2') IS NOT NULL
 DROP TABLE #DUB2

 SELECT * INTO #DUB2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY BuyoutPartyLoanNo ORDER BY BuyoutPartyLoanNo ) ROW FROM UploadBuyout
 )X
 WHERE ROW>1
   
   UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate records found.BuyoutPartyLoanNo are repeated.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Duplicate records found. BuyoutPartyLoanNo are repeated.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'BuyoutPartyLoanNo' ELSE   ErrorinColumn +','+SPACE(1)+'BuyoutPartyLoanNo' END     
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SRNO 
	--							FROM #UploadNewAccount A
	--							WHERE A.SrNo IN(SELECT V.SrNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SRNO IN(SELECT Srno FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(BuyoutPartyLoanNo,'')<>''
 AND BuyoutPartyLoanNo IN(SELECT BuyoutPartyLoanNo FROM #DUB2 GROUP BY BuyoutPartyLoanNo)


------------------------------------------------------------

/*VALIDATIONS ON CustomerName */

  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CustomerName cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'CustomerName cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerName' ELSE ErrorinColumn +','+SPACE(1)+  'CustomerName' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM UploadBuyout V  
 WHERE ISNULL(CustomerName,'')='' 
 

-- ----SELECT * FROM UploadBuyout
  
--  UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'CustomerName Can not be blank. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+'CustomerName Can not be blank. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerName' ELSE ErrorinColumn +','+SPACE(1)+  'CustomerName' END  
--		,Srnooferroneousrows=V.SlNo
----								--STUFF((SELECT ','+SRNO 
----								--FROM UploadBuyout A
----								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
----								-- WHERE ISNULL(V.ACID,'')<>''
----								--		AND V.ACID NOT IN(SELECT SystemAcid FROM AxisIntReversalDB.IntReversalDataDetails 
----								--										WHERE -----EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
----								--										Timekey=@Timekey
----								--		))
----								--FOR XML PATH ('')
----								--),1,1,'')   
--		FROM UploadBuyout V  
-- WHERE ISNULL(V.CustomerName,'')<>''
-- And V.CustomerName Not In (Select B.CustomerName from curdat.AdvAcBasicDetail A 
--							Inner Join curdat.CustomerBasicDetail B ON A.RefCustomerId=B.CustomerId
--							And A.EffectiveToTimeKey=49999 and B.EffectiveToTimeKey=49999
--							Inner Join UploadBuyout C on A.CustomerACID=C.BuyoutPartyLoanNo)
 
--------------------------------------------------------------------------------
/*
/*validations on PAN */

UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
		'The column ‘PAN’ is mandatory. Kindly check and upload again' 
		ELSE ErrorMessage+','+SPACE(1)+ 'PAN is mandatory. Kindly check and upload again'
		END
		,ErrorinColumn='PAN'    
		,Srnooferroneousrows=''
	FROM UploadBuyout V  
	WHERE V.PAN IN(SELECT PAN FROM curdat.advcustrelationship 
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
						 )
*/
/*--------------------validations on PAN-------------------- PRANAY 22-03-2021 */

/* Commneted on 14-05-2021 sunil of shishir sir advice  */

--UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
--		'PAN can not be blank. Kindly check and upload again' 
--		ELSE ErrorMessage+','+SPACE(1)+ 'PAN can not be blank. Kindly check and upload again' 
--		END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PAN' ELSE ErrorinColumn +','+SPACE(1)+  'PAN' END  
--		--,ErrorinColumn='PAN'    
--		,Srnooferroneousrows=''
--	FROM UploadBuyout V  
--	WHERE ISNULL(V.PAN,'')=''


--UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
--		'Invalid PAN. PAN length must be 10 characters, first 5 characters must be an alphabet,next 4 character must be numeric 0-9, & last(10th) character must be an alphabet'
--		ELSE ErrorMessage+','+SPACE(1)+ 'Invalid PAN. PAN length must be 10 characters, first 5 characters must be an alphabet,next 4 character must be numeric 0-9, & last(10th) character must be an alphabet'
--		END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PAN' ELSE ErrorinColumn +','+SPACE(1)+  'PAN' END  
--		--,ErrorinColumn='PAN'    
--		,Srnooferroneousrows=''
--	FROM UploadBuyout V  
--	WHERE ISNULL(V.PAN,'')<>''
--	AND 	V.PAN  not LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]' OR Len(PAN)<>10


-----------------------------------------------------------
/*validations on AadharNo */

/*  Commneted on 14-05-2021 sunil of shishir sir advice     */

--UPDATE UploadBuyout
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
--		'The column ‘AadharNo’ is mandatory. Kindly check and upload again' 
--		ELSE ErrorMessage+','+SPACE(1)+ 'AadharNo is mandatory. Kindly check and upload again'
--		END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AadharNo' ELSE ErrorinColumn +','+SPACE(1)+  'AadharNo' END  
--		--,ErrorinColumn='AadharNo'    
--		,Srnooferroneousrows=''
--	FROM UploadBuyout V  
--	WHERE V.AadharNo IN(SELECT AadhaarId FROM curdat.advcustrelationship 
--								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
--						 )

 
/*validations on PrincipalOutstanding */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PrincipalOutstanding cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PrincipalOutstanding cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstanding' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstanding' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(PrincipalOutstanding,'')=''

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid PrincipalOutstanding. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid PrincipalOutstanding. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstanding' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstanding' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM UploadBuyout A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadBuyout V  
 WHERE (ISNUMERIC(PrincipalOutstanding)=0 AND ISNULL(PrincipalOutstanding,'')<>'') OR 
 ISNUMERIC(PrincipalOutstanding) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid PrincipalOutstanding. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid PrincipalOutstanding. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstanding' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstanding' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(PrincipalOutstanding,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadBuyout
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PrincipalOutstanding. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid PrincipalOutstanding. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrincipalOutstanding' ELSE ErrorinColumn +','+SPACE(1)+  'PrincipalOutstanding' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT SRNO FROM UploadBuyout WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(PrincipalOutstanding,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(PrincipalOutstanding,0)) <0

 -----------------------------------------------------------------
 

/*validations on InterestReceivable */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InterestReceivable cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'InterestReceivable cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivable' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivable' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(InterestReceivable,'')=''

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivable. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid InterestReceivable. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivable' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivable' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM UploadBuyout A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadBuyout V  
 WHERE (ISNUMERIC(InterestReceivable)=0 AND ISNULL(InterestReceivable,'')<>'') OR 
 ISNUMERIC(InterestReceivable) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivable. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivable. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivable' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivable' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(InterestReceivable,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadBuyout
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid InterestReceivable. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivable. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivable' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivable' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT SRNO FROM UploadBuyout WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(InterestReceivable,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReceivable,0)) <0

 -----------------------------------------------------------------

 /*validations on Charges */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Charges cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Charges cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Charges' ELSE ErrorinColumn +','+SPACE(1)+  'Charges' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(Charges,'')=''

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Charges. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid Charges. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Charges' ELSE ErrorinColumn +','+SPACE(1)+  'Charges' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM UploadBuyout A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadBuyout V  
 WHERE (ISNUMERIC(Charges)=0 AND ISNULL(Charges,'')<>'') OR 
 ISNUMERIC(Charges) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Charges. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid Charges. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Charges' ELSE ErrorinColumn +','+SPACE(1)+  'Charges' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(Charges,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadBuyout
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Charges. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid Charges. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Charges' ELSE ErrorinColumn +','+SPACE(1)+  'Charges' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT SRNO FROM UploadBuyout WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(Charges,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(Charges,0)) <0

 
 -----------------------------------------------------------------

 
 /*validations on AccuredInterest */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'AccuredInterest cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'AccuredInterest cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccuredInterest' ELSE ErrorinColumn +','+SPACE(1)+  'AccuredInterest' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AccuredInterest,'')=''

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid AccuredInterest. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid AccuredInterest. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccuredInterest' ELSE ErrorinColumn +','+SPACE(1)+  'AccuredInterest' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM UploadBuyout A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadBuyout V  
 WHERE (ISNUMERIC(AccuredInterest)=0 AND ISNULL(AccuredInterest,'')<>'') OR 
 ISNUMERIC(AccuredInterest) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid AccuredInterest. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid AccuredInterest. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccuredInterest' ELSE ErrorinColumn +','+SPACE(1)+  'AccuredInterest' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AccuredInterest,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadBuyout
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid AccuredInterest. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid AccuredInterest. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccuredInterest' ELSE ErrorinColumn +','+SPACE(1)+  'AccuredInterest' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT SRNO FROM UploadBuyout WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AccuredInterest,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(AccuredInterest,0)) <0


 ---------------------------------------------------------------------
 /*validations on DPD */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DPD cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'DPD cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD' ELSE ErrorinColumn +','+SPACE(1)+  'DPD' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(DPD,'')=''

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DPD. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid DPD. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD' ELSE ErrorinColumn +','+SPACE(1)+  'DPD' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SRNO 
--								--FROM UploadBuyout A
--								--WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadBuyout V  
 WHERE (ISNUMERIC(DPD)=0 AND ISNULL(DPD,'')<>'') OR 
 ISNUMERIC(DPD) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DPD. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DPD. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD' ELSE ErrorinColumn +','+SPACE(1)+  'DPD' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM UploadBuyout V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(DPD,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadBuyout
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid DPD. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DPD. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD' ELSE ErrorinColumn +','+SPACE(1)+  'DPD' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SRNO 
--								----FROM UploadBuyout A
--								----WHERE A.SrNo IN(SELECT SRNO FROM UploadBuyout WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(DPD,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(Charges,0)) <0


 
----------------For Flag Checking in main table

 
UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Already Buyout Flag is present. Please Check the Account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Already Buyout Flag is present. Please Check the Account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'BuyoutPartyLoanNo' ELSE   ErrorinColumn +','+SPACE(1)+'BuyoutPartyLoanNo' END      
		,Srnooferroneousrows=''
		--STUFF((SELECT ','+SRNO 
		--						FROM #UploadNewAccount A
		--						WHERE A.SrNo IN(SELECT V.SrNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadBuyout V  
 Inner Join Dbo.AdvAcOtherDetail A ON V.BuyoutPartyLoanNo=A.RefSystemAcId And A.EffectiveToTimeKey=49999
 WHERE A.SplFlag like '%Buyout%'

 /*           Commented on 19-05-2021  by advice of Ravish
 ----------------------------------------------------
/*validations on AssetClass */

 UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 
		
		'AssetClass is mandatory. Kindly check and upload again' 
		ELSE ErrorMessage+','+SPACE(1)+ 'AssetClass is mandatory. Kindly check and upload again'
		END
		,ErrorinColumn='AssetClass'    
		,Srnooferroneousrows=''
	FROM UploadBuyout V  
	WHERE ISNULL(v.AssetClass,'')=''  

	*/
--------------------------------------------------------------------------

/*      Commented on 19-05-2021  by advice of Ravish

/*-------------------PoolName-Validation------------------------- */ -- changes done on 21-03-21 Pranay 
 Declare @PoolNameCnt int=0,@Category int=0
 --DROP TABLE IF EXISTS PoolNameData

 IF OBJECT_ID('PoolNameBuyoutData') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  PoolNameBuyoutData
	
	  END

 SELECT * into PoolNameBuyoutData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY AUNO  ORDER BY  AUNO ) 
 ROW ,AUNO,PoolName,BuyoutPartyLoanNo FROM UploadBuyout
 )X
 WHERE ROW=1


 SELECT @PoolNameCnt=COUNT(*) FROM PoolNameBuyoutData a
 INNER JOIN UploadBuyout b
 ON a.AUNO=b.AUNO 
 WHERE a.PoolName<>b.PoolName

 IF @PoolNameCnt>0
 BEGIN
  PRINT 'PoolName ERROR'
   UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Different AUNO of same combination of PoolName is Available. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different AUNO of same combination of PoolName and Category is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END     
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SlNo 
	--							FROM #UploadNewAccount A
	--							WHERE A.SlNo IN(SELECT V.SlNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SlNo IN(SELECT SlNo FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AUNO,'')<>''
 AND  BuyoutPartyLoanNo IN(
				 SELECT DISTINCT B.BuyoutPartyLoanNo from PoolNameBuyoutData a
				 INNER JOIN UploadBuyout b
				 on a.AUNO=b.AUNO 
				 where a.PoolName<>b.PoolName
				 )

 END

 -------------Category----------------------------------changes done on 21-03-21 Pranay 

--DROP TABLE IF EXISTS CategoryData
 IF OBJECT_ID('CategoryData') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  CategoryData
	
	  END

  SELECT * into CategoryData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY AUNO  ORDER BY  AUNO ) 
 ROW ,AUNO,Category,BuyoutPartyLoanNo FROM UploadBuyout
 )X
 WHERE ROW=1


 select @Category=COUNT(*) from CategoryData a
 INNER JOIN UploadBuyout b
 on a.AUNO=b.AUNO 
 where a.Category<>b.Category

  IF @Category>0
 BEGIN
  PRINT 'Category ERROR'

  UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Different AUNO of same combination of Category is Available. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different AUNO of same combination of PoolName and Category is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Category' ELSE   ErrorinColumn +','+SPACE(1)+'Category' END     
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SlNo 
	--							FROM #UploadNewAccount A
	--							WHERE A.SlNo IN(SELECT V.SlNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SlNo IN(SELECT SlNo FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AUNO,'')<>''
 AND BuyoutPartyLoanNo IN(
				 SELECT DISTINCT B.BuyoutPartyLoanNo from CategoryData a
				 INNER JOIN UploadBuyout b
				 on a.AUNO=b.AUNO 
				 where a.Category<>b.Category
				 )
 END

 /*Same PoolName present in Multiple AUNO*/ -- pRANAY 21-03-21

Declare @PoolNameCnt1 int=0
 --DROP TABLE IF EXISTS PoolNameData1
 IF OBJECT_ID('PoolNameBuyoutData1') IS NOT NULL  
	  BEGIN
	    
		DROP TABLE  PoolNameBuyoutData1
	
	  END

 SELECT * into PoolNameBuyoutData1  
 FROM(SELECT ROW_NUMBER() OVER(PARTITION BY AUNO  ORDER BY  AUNO ) ROW,
			AUNO,PoolName,BuyoutPartyLoanNo FROM UploadBuyout
	 )X
 WHERE ROW=1


 SELECT @PoolNameCnt1=COUNT(*)
  FROM PoolNameBuyoutData1 a
 inner JOIN UploadBuyout b
 ON a.PoolName=b.PoolName 
 WHERE a.AUNO<>b.AUNO

 IF @PoolNameCnt1>0
 BEGIN
  PRINT 'Same PoolName present in Multiple AUNO'
   UPDATE UploadBuyout
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Same PoolName present in Multiple AUNO. Please check the values and upload again' END    
						--ELSE ErrorMessage+','+SPACE(1)+ 'Different AUNO of same combination of PoolName and Category is Available. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolName' ELSE   ErrorinColumn +','+SPACE(1)+'PoolName' END     
		,Srnooferroneousrows=V.SlNo
	--	STUFF((SELECT ','+SlNo 
	--							FROM #UploadNewAccount A
	--							WHERE A.SlNo IN(SELECT V.SlNo FROM #UploadNewAccount V  
 --WHERE ISNULL(ACID,'')<>'' AND ISNULL(TERRITORY,'')<>''
 ----AND SlNo IN(SELECT SlNo FROM #DUB2))
 --AND ACID IN(SELECT ACID FROM #DUB2 GROUP BY ACID))

	--							FOR XML PATH ('')
	--							),1,1,'')   

 FROM UploadBuyout V  
 WHERE ISNULL(AUNO,'')<>''
 AND  BuyoutPartyLoanNo IN(
				 SELECT DISTINCT A.BuyoutPartyLoanNo from PoolNameBuyoutData1 a
				 INNER JOIN UploadBuyout b
				 ON a.PoolName=b.PoolName 
				WHERE a.AUNO<>b.AUNO
				 )

 END

 */


 Print '123'
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Data'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  BuyoutDetails_stg WHERE filname=@FilePathUpload)
		BEGIN
		PRINT 'NO ERRORS'
			
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT '' SRNO , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 
			
		END
		ELSE
		BEGIN
			PRINT 'VALIDATION ERRORS1'
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Srnooferroneousrows,Flag) 
			SELECT SlNo,ErrorinColumn,ErrorMessage,ErrorinColumn,@filepath,Srnooferroneousrows,'SUCCESS' 
			FROM UploadBuyout 

			PRINT 'VALIDATION ERRORS'
			
		--	----SELECT * FROM UploadBuyout 

		--	--ORDER BY ErrorMessage,UploadBuyout.ErrorinColumn DESC
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
	Print 'Validation=Y'
    Update UploadStatus Set ValidationOfData='Y',ValidationOfDataCompletedOn=GetDate()   
    where FileNames=@filepath  
  
   END  


  final:
  Print 'ERR'
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

		 IF EXISTS(SELECT 1 FROM BuyoutDetails_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM BuyoutDetails_stg
		 WHERE filname=@FilePathUpload

		 PRINT 1

		 PRINT 'ROWS DELETED FROM DBO.BuyoutDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
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

	----SELECT * FROM UploadBuyout

	print 'p'
  ------to delete file if it has errors
		--if exists(Select  1 from dbo.MasterUploadData where FileNames=@filepath and ISNULL(ErrorData,'')<>'')
		--begin
		--print 'ppp'
		-- IF EXISTS(SELECT 1 FROM BuyoutDetails_stg WHERE filname=@FilePathUpload)
		-- BEGIN
		-- print '123'
		-- DELETE FROM BuyoutDetails_stg
		-- WHERE filname=@FilePathUpload

		-- PRINT 'ROWS DELETED FROM DBO.BuyoutDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		-- END
		-- END

   
END  TRY
  
  BEGIN CATCH
	

	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	--IF EXISTS(SELECT 1 FROM BuyoutDetails_stg WHERE filname=@FilePathUpload)
	--	 BEGIN
	--	 DELETE FROM BuyoutDetails_stg
	--	 WHERE filname=@FilePathUpload

	--	 PRINT 'ROWS DELETED FROM DBO.BuyoutDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
	--	 END

END CATCH

END
  
GO
