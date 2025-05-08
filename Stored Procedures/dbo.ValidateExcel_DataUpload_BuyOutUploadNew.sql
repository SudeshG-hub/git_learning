SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[ValidateExcel_DataUpload_BuyOutUploadNew]
@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='fnachecker',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='IBPCUPLOAD.xlsx'  
WITH RECOMPILE  
AS  
  
  --fnasuperadmin_IBPCUPLOAD.xlsx

--DECLARE  
  
--@MenuID INT=1458,  
--@UserLoginId varchar(20)='FNASUPERADMIN',  
--@Timekey int=49999
--,@filepath varchar(500)='fnasuperadmin_IBPCUPLOAD.xlsx'  
  
BEGIN

BEGIN TRY  
--BEGIN TRAN  
  
--Declare @TimeKey int  
    --Update UploadStatus Set ValidationOfData='N' where FileNames=@filepath  
     
	 SET DATEFORMAT DMY

 --Select @Timekey=Max(Timekey) from dbo.SysProcessingCycle  
 -- where  ProcessType='Quarterly' ----and PreMOC_CycleFrozenDate IS NULL
 
 Select   @Timekey= (select CAST(B.timekey as int)from SysDataMatrix A
                    Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
                       where A.CurrentStatus='C')

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

	  -- IF OBJECT_ID('tempdb..BuyoutUploadDetail') IS NOT NULL  
	  IF OBJECT_ID('BuyoutUploadDetail') IS NOT NULL  
	  BEGIN  
	   DROP TABLE BuyoutUploadDetail  
	   
	  END




  IF NOT (EXISTS (SELECT * FROM BuyoutUploadDetails_stg where filname=@FilePathUpload))

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
 	   into BuyoutUploadDetail
	   from BuyoutUploadDetails_stg 
	   WHERE filname=@FilePathUpload

	  
END

  ------------------------------------------------------------------------------  
   
	--SrNo	Territory	ACID	InterestReversalAmount	filname
	
	UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='UCIC,CustomerName,AssetID,LiabID,Segment,CRE,Balances,CollateralSubType,Nmae Of Security Provider,Seniority Charge,Security Status'
		,Srnooferroneousrows=''
 FROM BuyoutUploadDetail V  
 WHERE ISNULL(ReportDate,'')=''
 AND ISNULL(AccountNo,'')=''
AND ISNULL(SchemeCode,'')=''
AND ISNULL(NPAClassificationwithSeller,'')=''

AND ISNULL(DateofNPAwithSeller,'')=''
AND ISNULL(DPDwithSeller,'')=''
AND ISNULL(PeakDPDwithSeller,'')=''

AND ISNULL(PeakDPDDate,'')=''







  
--WHERE ISNULL(V.SrNo,'')=''
-- ----AND ISNULL(Territory,'')=''
-- AND ISNULL(AccountID,'')=''
-- AND ISNULL(PoolID,'')=''
-- AND ISNULL(filname,'')=''

  IF EXISTS(SELECT 1 FROM BuyoutUploadDetail WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO ERRORDATA;
  END

      /*validations on Sl. No.*/
 ------------------------------------------------------------

  Declare @DuplicateCnt int=0
   UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SrNo cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'SrNo cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SrNo' ELSE   ErrorinColumn +','+SPACE(1)+'SrNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(SlNo,'')='' or ISNULL(SlNo,'0')='0'


  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SrNo cannot be greater than 16 character . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'SrNo cannot be greater than 16 character . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SrNo' ELSE   ErrorinColumn +','+SPACE(1)+'SrNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE Len(SlNo)>16

  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Sl. No., kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Sl. No., kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SrNo' ELSE   ErrorinColumn +','+SPACE(1)+'SrNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(SlNo)=0 AND ISNULL(SlNo,'')<>'') OR 
 ISNUMERIC(SlNo) LIKE '%^[0-9]%'

 UPDATE BuyoutUploadDetail
	SET  
  ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Special characters not allowed, kindly remove and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Special characters not allowed, kindly remove and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SrNo' ELSE   ErrorinColumn +','+SPACE(1)+'SrNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
   WHERE ISNULL(SlNo,'') LIKE'%[,!@#$%^&*()_-+=/]%'

   --
  SELECT @DuplicateCnt=Count(1)
FROM BuyoutUploadDetail
GROUP BY  SlNo
HAVING COUNT(SlNo) >1;

IF (@DuplicateCnt>0)

 UPDATE		BuyoutUploadDetail
SET			ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate Sl. No., kindly check and upload again'     
						 ELSE ErrorMessage+','+SPACE(1)+'Duplicate Sl. No., kindly check and upload again'     END
			,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SrNo' ELSE   ErrorinColumn +','+SPACE(1)+'SrNo' END   
			,Srnooferroneousrows=V.SlNo			
   FROM		BuyoutUploadDetail V  
   Where	ISNULL(SlNo,'') In(  
								   SELECT SlNo
									FROM BuyoutUploadDetail a
									GROUP BY  SlNo
									HAVING COUNT(SlNo) >1
							   )

							   
----------------------------------------------
 

----------------------------------------------
  
  /*validations on Account No*/
   Declare @Count Int,@I Int,@Entity_Key Int
   Declare @CustomerAcID Varchar(100)=''
   Declare @CustomerAcIDFound Int=0
     Declare @CustomerName Varchar(250)=''
	  Declare @CustName Varchar(250)=''
	  Declare @CustomerNameFound Int=0


  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CustomerAcID cannot be blank . Please check the values and upload again.'
     
						ELSE ErrorMessage+','+SPACE(1)+' CustomerAcID cannot be blank . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerAcID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerAcID' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(AccountNo,'')=''  


 
  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CustomerAcID cannot greater than 25 Character. Please check the values and upload again.'
     
						ELSE ErrorMessage+','+SPACE(1)+' CustomerAcID cannot greater than 25 Character. Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerAcID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerAcID' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE  Len(ISNULL(AccountNo,''))>25


 IF OBJECT_ID('TempDB..#tmp') IS NOT NULL DROP TABLE #tmp; 
  
  Select  ROW_NUMBER() OVER(ORDER BY  CONVERT(INT,EntityKey) ) RecentRownumber,EntityKey,AccountNo into #tmp from BuyoutUploadDetail
                  
 Select @Count=Count(*) from #tmp
  
   SET @I=1
   SET @Entity_Key=0
     SET @CustomerAcID =0
   SET @CustomerNameFound =0

   SET @CustomerAcID=''
     While(@I<=@Count)
               BEGIN 
			     Select @CustomerAcID =AccountNo,@Entity_Key=EntityKey  from #tmp where RecentRownumber=@I 
							order By EntityKey

					  Select      @CustomerAcIDFound=Count(1)
				from Curdat.AdvAcBasicDetail  A Where CustomerAcID=@CustomerAcID

				IF @CustomerAcIDFound =0
				    Begin
				 Update BuyoutUploadDetail
										   SET   ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN ' CustomerAcID is invalid. Kindly check the entered CustomerAcID'     
											 ELSE ErrorMessage+','+SPACE(1)+' CustomerAcID is invalid. Kindly check the entered CustomerAcID'      END
											 ,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerAcID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerAcID' END   
										   Where EntityKey=@Entity_Key
					END

				
					  SET @I=@I+1
					  SET @CustomerAcID=''
								
								
			   END

UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Only special characters  _  are allowed, kindly remove and try again'     
						ELSE ErrorMessage+','+SPACE(1)+'Only special characters  _  are allowed, kindly remove and try again'    END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerAcID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerAcID' END       
		,Srnooferroneousrows=V.SlNo

   
   FROM BuyoutUploadDetail V  
  WHERE ISNULL(AccountNo,'')  like '%[-/,!@#$%^&*()+=]%'


  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Record is pending for authorization for this Account ID. Kindly authorize or Reject the record '     
						ELSE ErrorMessage+','+SPACE(1)+' Record is pending for authorization for this Account ID. Kindly authorize or Reject the record '     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerAcID' ELSE ErrorinColumn +','+SPACE(1)+  'CustomerAcID' END  
		,Srnooferroneousrows=V.SlNo
  
		FROM BuyoutUploadDetail V  
 WHERE ISNULL(V.AccountNo,'')<>''
 AND V.AccountNo  IN (SELECT Distinct CustomerAcID FROM BuyoutUploadDetails_Mod
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
								AND AuthorisationStatus in ('NP','MP','1A') 
						 )
 -------------------------------------------------------------------------

 ----------------------------------------------
  
 ----------------------------------------------
  
  /*validations on Scheme*/
    Declare @DuplicateSchemeInt int=0

	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SchemeCode cannot be blank . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'SchemeCode cannot be blank . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SchemeCode' ELSE   ErrorinColumn +','+SPACE(1)+'SchemeCode' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(SchemeCode,'')='' 

	
	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SchemeCode cannot greater than 25 Character. Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'SchemeCode cannot greater than 25 Character. Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SchemeCode' ELSE   ErrorinColumn +','+SPACE(1)+'SchemeCode' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE Len(ISNULL(SchemeCode,''))>25
  
	

	IF OBJECT_ID('SchemeTypeData') IS NOT NULL  
	  BEGIN  
	   DROP TABLE SchemeTypeData 
	
	  END

	   SELECT * into SchemeTypeData  FROM(
 SELECT ROW_NUMBER() OVER(PARTITION BY SchemeCode  ORDER BY  SchemeCode ) 
 ROW ,SchemeCode FROM BuyoutUploadDetail
)X
 WHERE ROW=1

 
  SELECT  @DuplicateSchemeInt=COUNT(*) FROM BuyoutUploadDetail A
 Left JOIN DimBuyoutSchemeCode B
 ON  A.SchemeCode=B.SchemeCode
 Where B.SchemeCode IS NULL

    IF @DuplicateSchemeInt>0

	BEGIN
	       UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘SchemeCode’. Kindly enter the values as mentioned in the ‘SchemeCode’ master and upload again. Click on ‘Download Master value’ to download the valid values for thecolumn
'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid value in column ‘SchemeCode’. Kindly enter the values as mentioned in the ‘SchemeCode’ master and upload again. Click on ‘Download Master value’ to download the valid values for the column'     END  
        ,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SchemeCode' ELSE   ErrorinColumn +','+SPACE(1)+'SchemeCode' END     
		,Srnooferroneousrows=V.SlNo
		 FROM BuyoutUploadDetail V  
 WHERE ISNULL(SchemeCode,'')<>''
 AND  V.SchemeCode IN(
				SELECT  A.SchemeCode FROM BuyoutUploadDetail A
						 Left JOIN DimBuyoutSchemeCode B
						 ON  A.SchemeCode=B.SchemeCode
						 Where B.SchemeCode IS NULL

				 )
	END





	



	

	 ---------------------------------------------------

	  ----------------------------------------------
  
  /*validations on NPA Classification with Seller */
    --Declare @DuplicateAssetCnt int=0

	-- UPDATE BuyoutUploadDetail
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'NPA Classification with Seller cannot be blank or grtater than 3 Character. Please check the values and upload again.'     
	--					ELSE ErrorMessage+','+SPACE(1)+'NPA Classification with Seller cannot be blank or grtater than 3 Character. Please check the values and upload again.'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Classification with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Classification with Seller' END   
	--	,Srnooferroneousrows=V.SlNo
								
   
 --  FROM BuyoutUploadDetail V  
 --WHERE ISNULL(NPAClassificationwithSeller,'')='' Or LEn(ISNULL(NPAClassificationwithSeller,'0') )>3


 
	-- UPDATE BuyoutUploadDetail
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'NPA Classification with Seller cannot be blank or grtater than 3 Character. Please check the values and upload again.'     
	--					ELSE ErrorMessage+','+SPACE(1)+'NPA Classification with Seller cannot be blank or grtater than 3 Character. Please check the values and upload again.'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Classification with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Classification with Seller' END   
	--	,Srnooferroneousrows=V.SlNo
								
   
 --  FROM BuyoutUploadDetail V  
 --WHERE ISNULL(NPAClassificationwithSeller,'')='' 

  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘NPA Classification with Seller’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid value in column ‘NPA Classification with Seller’. Kindly enter ‘Y or N’ and upload again'    END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Classification with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Classification with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(NPAClassificationwithSeller,'') NOT IN('Y','N','','NULL')


	

	 ---------------------------------------------------


  /*validations on Date of NPA with Seller */
    --Declare @DuplicateAssetCnt int=0

	SET DATEFORMAT DMY

	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Date of NPA with Seller cannot be blank When NPA Classification with Seller is Y . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Date of NPA with Seller cannot be blank When NPA Classification with Seller is Y . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Date of NPA with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'Date of NPA with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(NPAClassificationwithSeller,'')='Y' AND ISNULL(DateofNPAwithSeller,'')=''

 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN '’Date of NPA with Seller’ must be in ddmmyyyy format. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'’Date of NPA with Seller’ must be in ddmmyyyy format. Kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Date with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Date with Seller' END       
		,Srnooferroneousrows=V.SlNo

   
  FROM BuyoutUploadDetail V  
 WHERE   ISDATE(DateofNPAwithSeller)=0 AND ISNULL(DateofNPAwithSeller,'')<>''

 --------------------------------------------------------------------
	

	 ---------------------------------------------------	 

	 /*validations on DPD with Seller */
    --Declare @DuplicateAssetCnt int=0

	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DPD with Seller cannot be blank . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'DPD with Seller cannot be blank . . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'DPD with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE  ISNULL(DPDwithSeller,'')=''

  UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DPD with Seller cannot be greater than 4 digits . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'DPD with Seller cannot be greater than 4 digits. Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'DPD with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE  Len(ISNULL(DPDwithSeller,''))>4


UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid DPD with Seller., kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid DPD with Seller, kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'DPD with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(DPDwithSeller)=0 AND ISNULL(DPDwithSeller,'')<>'') OR 
 ISNUMERIC(DPDwithSeller) LIKE '%^[0-9]%'


 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Special characters are not allowed, kindly remove and try again'     
						ELSE ErrorMessage+','+SPACE(1)+'Special characters are not allowed,  kindly remove and try again'    END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'DPD with Seller' END       
		,Srnooferroneousrows=V.SlNo

   
   FROM BuyoutUploadDetail V  
  WHERE ISNULL(DPDwithSeller,'')<>'' AND ISNULL(DPDwithSeller,'')  like '%[,/-_!@#$%^&*()+=]%'

 Declare @ErrorCount INT=0
  Declare @ErrorCount3 INT=0
Declare @ErrorCount2 INT=0
 Declare @ErrorCount4 INT=0

 Select @ErrorCount=Count(1)
    FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(DPDwithSeller)=0 AND ISNULL(DPDwithSeller,'')<>'') OR 
 ISNUMERIC(DPDwithSeller) LIKE '%^[0-9]%'

  Select @ErrorCount3=Count(1) 
    FROM BuyoutUploadDetail V  
  WHERE ISNULL(DPDwithSeller,'')<>'' AND ISNULL(DPDwithSeller,'')  like '%[,/-_!@#$%^&*()+=]%'

  
   Select @ErrorCount2=Count(1)
    FROM BuyoutUploadDetail V  
  WHERE ISNULL(PeakDPDwithSeller,'')<>'' AND ISNULL(PeakDPDwithSeller,'')  like '%[,/-_!@#$%^&*()+=]%'

   Select @ErrorCount4=Count(1)
    FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(PeakDPDwithSeller)=0 AND ISNULL(PeakDPDwithSeller,'')<>'') OR 
 ISNUMERIC(PeakDPDwithSeller) LIKE '%^[0-9]%'


 IF (@ErrorCount=0 AND @ErrorCount3=0 AND @ErrorCount2=0 AND @ErrorCount4=0)
 BEGIN


  
UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Peak DPD should be greater or equal to  Seller DPD , kindly remove and try again'     
						ELSE ErrorMessage+','+SPACE(1)+'Peak DPD should be greater or equal to  Seller DPD, kindly remove and try again'    END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'DPD with Seller' END       
		,Srnooferroneousrows=V.SlNo

   
   FROM BuyoutUploadDetail V  
  WHERE ISNULL(DPDwithSeller,'')<>'' AND Convert(Int,ISNULL(PeakDPDwithSeller,'0'))<  Convert(Int,ISNULL(DPDwithSeller,'0'))
  AND ISNULL(PeakDPDwithSeller,'')<>''
END

--DPDwithSeller
--PeakDPDwithSeller

	 ---------------------------------------------------	
 ---------------------------------------------------	 

	 /*validations on Peak DPD with Seller */
    --Declare @DuplicateAssetCnt int=0

	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Peak DPD with Seller cannot be greater than 4 digits . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Peak DPD with Seller cannot be greater than 4 digits . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Peak DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'Peak DPD with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE ISNULL(PeakDPDwithSeller,'')<>'' AND Len(ISNULL(PeakDPDwithSeller,''))>4 

UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Peak DPD with Seller., kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Peak DPD with Seller, kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Peak DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'Peak DPD with Seller' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(PeakDPDwithSeller)=0 AND ISNULL(PeakDPDwithSeller,'')<>'') OR 
 ISNUMERIC(PeakDPDwithSeller) LIKE '%^[0-9]%'

 Declare @ErrorCount1 INT=0

 Select @ErrorCount1=Count(1)
    FROM BuyoutUploadDetail V  
  WHERE (ISNUMERIC(PeakDPDwithSeller)=0 AND ISNULL(PeakDPDwithSeller,'')<>'') OR 
 ISNUMERIC(PeakDPDwithSeller) LIKE '%^[0-9]%'

 --IF @ErrorCount1=0
 --BEGIN
UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Special characters are not allowed, kindly remove and try again'     
						ELSE ErrorMessage+','+SPACE(1)+'Special characters are not allowed,  kindly remove and try again'    END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Peak DPD with Seller' ELSE   ErrorinColumn +','+SPACE(1)+'Peak DPD with Seller' END       
		,Srnooferroneousrows=V.SlNo

   
   FROM BuyoutUploadDetail V  
  WHERE ISNULL(PeakDPDwithSeller,'')<>'' AND ISNULL(PeakDPDwithSeller,'')  like '%[,/-_!@#$%^&*()+=]%'	

  --END
 

	 ---------------------------------------------------	
	
		 ---------------------------------------------------


  /*validations on Peak DPD Date*/
    --Declare @DuplicateAssetCnt int=0

	-- UPDATE BuyoutUploadDetail
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Peak DPD Date cannot be blank when Peak DPD with Seller is present . Please check the values and upload again.'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Peak DPD Date cannot be blank when Peak DPD with Seller is present . Please check the values and upload again.'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Peak DPD Date' ELSE   ErrorinColumn +','+SPACE(1)+'Peak DPD Date' END   
	--	,Srnooferroneousrows=V.SlNo
								
   
 --  FROM BuyoutUploadDetail V  
 --WHERE  ISNULL(PeakDPDwithSeller,'')<>''  AND ISNULL(PeakDPDDate,'')=''

 SET DATEFORMAT DMY

 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Peak DPD Date must be in ddmmyyyy format. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Peak DPD Date must be in ddmmyyyy format. Kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Peak DPD Date' ELSE   ErrorinColumn +','+SPACE(1)+'Peak DPD Date' END       
		,Srnooferroneousrows=V.SlNo

   
  FROM BuyoutUploadDetail V  
 WHERE   ISDATE(PeakDPDDate)=0 AND ISNULL(PeakDPDDate,'')<>''

 --------------------------------------------------------------------

 		 ---------------------------------------------------


  /*validations on Report Date*/
    --Declare @DuplicateAssetCnt int=0

	SET DATEFORMAT DMY

	 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Report Date cannot be blank . Please check the values and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Report Date cannot be blank  . Please check the values and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Report Date' ELSE   ErrorinColumn +','+SPACE(1)+'Report Date' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM BuyoutUploadDetail V  
 WHERE  ISNULL(ReportDate,'')=''

 UPDATE BuyoutUploadDetail
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Report Date must be in ddmmyyyy format. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Report Date must be in ddmmyyyy format. Kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Report Date' ELSE   ErrorinColumn +','+SPACE(1)+'Report Date' END       
		,Srnooferroneousrows=V.SlNo

   
  FROM BuyoutUploadDetail V  
 WHERE   ISDATE(ReportDate)=0 AND ISNULL(ReportDate,'')<>''


 PRINT 'FinalEND'
 --------------------------------------------------------------------
	

	    ---------------------------------------------------
 ---------------------------------------------------
 Print '123'
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Data'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  BuyoutUploadDetails_stg WHERE filname=@FilePathUpload)
		BEGIN
		PRINT 'NO ERRORS'
			
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT '' SRNO , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 
			
		END
		ELSE
		BEGIN
			PRINT 'VALIDATION ERRORS'
			PRINT '@filepath'
			PRINT @filepath
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Srnooferroneousrows,Flag) 
			SELECT SlNo,ErrorinColumn,ErrorMessage,ErrorinColumn,@filepath,Srnooferroneousrows,'SUCCESS' 
			FROM BuyoutUploadDetail 

			print 'Row Effected'

			print @@ROWCOUNT
			
		--	----SELECT * FROM BuyoutUploadDetail 

		--	--ORDER BY ErrorMessage,BuyoutUploadDetail.ErrorinColumn DESC
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
	
		ORDER BY CONVERT(INT,SR_No)

		 IF EXISTS(SELECT 1 FROM BuyoutUploadDetails_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 Print '1'
		 DELETE FROM BuyoutUploadDetails_stg
		 WHERE filname=@FilePathUpload



		 PRINT '2';

		 PRINT 'ROWS DELETED FROM DBO.BuyoutUploadDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
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

	----SELECT * FROM BuyoutUploadDetail

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
