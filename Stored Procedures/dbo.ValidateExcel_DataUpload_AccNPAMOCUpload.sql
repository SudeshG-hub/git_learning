SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[ValidateExcel_DataUpload_AccNPAMOCUpload]  
@MenuID INT=10,  
@UserLoginId  VARCHAR(20)='fnachecker',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='AccountMOCUpload.xlsx'  
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
 
  -- SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 

  --SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey)   
  SET @Timekey =(Select Timekey from SysDataMatrix Where MOC_Initialised='Y' AND ISNULL(MOC_Frozen,'N')='N')
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


IF (@MenuID=24715)	
BEGIN

	  -- IF OBJECT_ID('tempdb..UploadAccMOCPool') IS NOT NULL  
	  IF OBJECT_ID('UploadAccMOCPool') IS NOT NULL  
	  BEGIN  
	   DROP TABLE UploadAccMOCPool  
	
	  END
	  
	  
  IF NOT (EXISTS (SELECT * FROM [AccountLvlMOCDetails_stg] where filname=@FilePathUpload))
 

BEGIN
print 'NO DATA'
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT 0 SlNo , '' ColumnName,'No Record found' ErrorData,'No Record found' ErrorType,@filepath,'SUCCESS' 
			--SELECT 0 SlNo , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 

			goto errordata
    
END

ELSE
BEGIN
PRINT 'DATA PRESENT'
	   Select *,CAST('' AS varchar(MAX)) ErrorMessage,CAST('' AS varchar(MAX)) ErrorinColumn,CAST('' AS varchar(MAX)) Srnooferroneousrows
 	   into UploadAccMOCPool 
	   from AccountLvlMOCDetails_stg 
	   WHERE filname=@FilePathUpload
	   select 'a'
	   update A
	   set A.SourceAlt_Key = B.SourceAlt_Key
	   from UploadAccMOCPool A
	   INNER JOIN DIMSOURCEDB B 
	   ON A.SourceSystem = B.SourceName
	  select 'b'
END		
  ------------------------------------------------------------------------------  
    ----SELECT * FROM UploadAccMOCPool
	--SlNo	Territory	ACID	InterestReversalAmount	filename
	UPDATE UploadAccMOCPool
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='SlNo,Account ID,POS,Interest Receivable,Balances,Dates'    
		,Srnooferroneousrows=''
 FROM UploadAccMOCPool V  
 WHERE ISNULL(SlNo,'')=''
AND ISNULL(AccountID,'')=''
AND ISNULL(POSinRs,'')=''
AND ISNULL(InterestReceivableinRs,'')=''
AND ISNULL(AdditionalProvisionAbsoluteinRs,'')=''
--AND ISNULL(RestructureFlagYN,'')=''
--AND ISNULL(RestructureDate,'')=''
AND ISNULL(FITLFlagYN,'')=''
AND ISNULL(DFVAmount,'')=''
AND ISNULL(RePossesssionFlagYN,'')=''
AND ISNULL(RePossessionDate,'')=''
AND ISNULL(InherentWeaknessFlag,'')=''
AND ISNULL(InherentWeaknessDate,'')=''
AND ISNULL(SARFAESIFlag,'')=''
AND ISNULL(SARFAESIDate,'')=''
AND ISNULL(UnusualBounceFlag,'')=''
AND ISNULL(UnusualBounceDate,'')=''
AND ISNULL(UnclearedEffectsFlag,'')=''
AND ISNULL(UnclearedEffectsDate,'')=''
AND ISNULL(FraudFlag,'')=''
AND ISNULL(FraudDate,'')=''
AND ISNULL(MOCSource,'')=''
AND ISNULL(MOCReason,'')=''



UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Sr No is present and remaining  excel file is blank. Please check and Upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Sr No is present and remaining  excel file is blank. Please check and Upload again.'     END
	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Excel Vaildate ' ELSE   ErrorinColumn +','+SPACE(1)+'Excel Vaildate' END   
		,Srnooferroneousrows=''
	
   FROM UploadAccMOCPool V  
 WHERE 
 ISNULL(SlNo,'')<>''

AND ISNULL(POSinRs,'')=''
AND ISNULL(InterestReceivableinRs,'')=''
AND ISNULL(AdditionalProvisionAbsoluteinRs,'')=''
--AND ISNULL(RestructureFlagYN,'')=''
--AND ISNULL(RestructureDate,'')=''
AND ISNULL(FITLFlagYN,'')=''
AND ISNULL(DFVAmount,'')=''
AND ISNULL(RePossesssionFlagYN,'')=''
AND ISNULL(RePossessionDate,'')=''
AND ISNULL(InherentWeaknessFlag,'')=''
AND ISNULL(InherentWeaknessDate,'')=''
AND ISNULL(SARFAESIFlag,'')=''
AND ISNULL(SARFAESIDate,'')=''
AND ISNULL(UnusualBounceFlag,'')=''
AND ISNULL(UnusualBounceDate,'')=''
AND ISNULL(UnclearedEffectsFlag,'')=''
AND ISNULL(UnclearedEffectsDate,'')=''
AND ISNULL(FraudFlag,'')=''
AND ISNULL(FraudDate,'')=''
AND ISNULL(MOCSource,'')=''
AND ISNULL(MOCReason,'')=''
  
--WHERE ISNULL(V.SlNo,'')=''
-- ----AND ISNULL(Territory,'')=''
-- AND ISNULL(AccountID,'')=''
-- AND ISNULL(PoolID,'')=''
-- AND ISNULL(filename,'')=''

  IF EXISTS(SELECT 1 FROM UploadAccMOCPool WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO valid;
  END

   
  /*validations on SourceSystem*/
   UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account ID not existing with Source System; Please check and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+'Account ID not existing with Source System; Please check and upload again.'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SourceSystem/AccountID' ELSE   ErrorinColumn +','+SPACE(1)+'SourceSystem/AccountID' END   
		,Srnooferroneousrows=V.AccountID		
   FROM UploadAccMOCPool V  
   left JOIN AdvAcbasicdetail B 
   ON V.SourceAlt_key = B.SourceAlt_Key 
   and V.AccountId = B.CustomerAcID
   AND B.EffectiveFromTimeKey<=@Timekey AND B.EffectiveToTimeKey>=@Timekey
 WHERE (ISNULL(B.SourceAlt_Key,'')='' 
 OR ISNULL(B.CustomerAcID,'')='')

  /*validations on SlNo*/
  
 Declare @DuplicateCnt int=0
   UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SlNo cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'SlNo cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE   ErrorinColumn +','+SPACE(1)+'SlNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM UploadAccMOCPool V  
 WHERE ISNULL(SlNo,'')='' or ISNULL(SlNo,'0')='0'


  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SlNo cannot be greater than 16 character . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'SlNo cannot be greater than 16 character . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE   ErrorinColumn +','+SPACE(1)+'SlNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM UploadAccMOCPool V  
WHERE Len(SlNo)>16

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Sl. No., kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Sl. No., kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE   ErrorinColumn +','+SPACE(1)+'SlNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM UploadAccMOCPool V  
  WHERE (ISNUMERIC(SlNo)=0 AND ISNULL(SlNo,'')<>'') OR 
 ISNUMERIC(SlNo) LIKE '%^[0-9]%'

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Special characters not allowed, kindly remove and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Special characters not allowed, kindly remove and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE   ErrorinColumn +','+SPACE(1)+'SlNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM UploadAccMOCPool V  
   WHERE ISNULL(SlNo,'') LIKE'%[,!@#$%^&*()_-+=/]%- \ / _'

   --
  SELECT @DuplicateCnt=Count(1)
FROM UploadAccMOCPool
GROUP BY  SlNo
HAVING COUNT(SlNo) >1;

IF (@DuplicateCnt>0)

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Duplicate Sl. No., kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Duplicate Sl. No., kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SlNo' ELSE   ErrorinColumn +','+SPACE(1)+'SlNo' END   
		,Srnooferroneousrows=V.SlNo
								
   
   FROM UploadAccMOCPool V  
   Where ISNULL(SlNo,'') In(  
   SELECT SlNo
	FROM UploadAccMOCPool
	GROUP BY  SlNo
	HAVING COUNT(SlNo) >1

)


 ------------------------------------------------

/*VALIDATIONS ON AccountID */

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'The column ‘Account ID’ is mandatory. Kindly check and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'The column ‘Account ID’ is mandatory. Kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM UploadAccMOCPool V  
 WHERE ISNULL(AccountID,'')='' 
 

-- ----SELECT * FROM UploadAccMOCPool
  
  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Account ID found. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SlNo
  
		FROM UploadAccMOCPool V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND V.AccountID NOT IN(SELECT CustomerACID FROM AdvAcBasicDetail
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
						 )


 IF OBJECT_ID('TEMPDB..#DUB2') IS NOT NULL
 DROP TABLE #DUB2

 SELECT * INTO #DUB2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY AccountID ) as rw  FROM UploadAccMOCPool
 )X
 WHERE rw>1


 UPDATE V
	SET  
        ErrorMessage=CASE WHEN ISNULL(V.ErrorMessage,'')='' THEN  'Duplicate Account ID found. Please check the values and upload again'     
						ELSE V.ErrorMessage+','+SPACE(1)+'Duplicate Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(V.ErrorinColumn,'')='' THEN 'Account ID' ELSE V.ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SlNo
  
		FROM UploadAccMOCPool V 
		INNer JOIN #DUB2 D ON D.AccountID=V.AccountID

						
---------------------Authorization for Screen Same acc ID --------------------------

UPDATE UploadAccMOCPool
	SET  
  ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Account Level NPA MOC – Authorization’ menu'     
						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Account Level NPA MOC – Authorization’ menu'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SlNo
  
		FROM UploadAccMOCPool V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND V.AccountID  IN (SELECT Distinct AccountID FROM AccountlevelMOC_MOD
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
								AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A') and ISNULL(Screenflag,'') <> 'U'
						 )
---------------------------------------------------------------------------Upload for same account ID--------------
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Account Level NPA MOC Upload– Authorization’ menu'     
						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Account Level NPA MOC Upload– Authorization’ menu'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SlNo
  
		FROM UploadAccMOCPool V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND V.AccountID  IN (SELECT Distinct AccountID FROM AccountlevelMOC_MOD
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
								AND AuthorisationStatus in ('NP','MP','1A','FM') and ISNULL(Screenflag,'') = 'U'
						 )

---------------------------------------

 
/*VALIDATIONS ON POS in Rs */



 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid POSinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid POSinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POSinRs' ELSE ErrorinColumn +','+SPACE(1)+  'POSinRs' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SlNo 
--								--FROM UploadAccMOCPool A
--								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (ISNUMERIC(POSinRs)=0 AND ISNULL(POSinRs,'')<>'') OR 
 ISNUMERIC(POSinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid POSinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid POSinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POSinRs' ELSE ErrorinColumn +','+SPACE(1)+  'POSinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(POSinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘POS in Rs.’. Kindly check and upload value'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘POS in Rs.’. Kindly check and upload value'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POSinRs' ELSE ErrorinColumn +','+SPACE(1)+  'POSinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT SlNo FROM UploadAccMOCPool WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE ISNULL(POSinRs,'')<>''
AND (CHARINDEX('.',ISNULL(POSinRs,''))>0  AND Len(Right(ISNULL(POSinRs,''),Len(ISNULL(POSinRs,''))-CHARINDEX('.',ISNULL(POSinRs,''))))>2)


 -----------------------------------------------------------------
 /*validations on MOC Reason */

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid MOC Reason. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid MOC Reasons. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MOCReason' ELSE ErrorinColumn +','+SPACE(1)+  'MOCReason' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(MOCReason,'') NOT IN (select  ParameterName from DimParameter
			 where EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey and
			  DimParameterName	= 'DimMOCReason')
 
 --('Wrong UCIC Linkage','DPD Freeze','Wrong recovery appropriation in source system','Exceptional issue, requires IAD concurrence',
 --'Advances Adjustment','Security Value Update','CNPA','Restructure','Portfolio Buyout-Requires IAD Concurrence','NPA Date update',
 --'Litigation','NPA Settlement','Standard Settlement','Erosion in Security Value','Sale of Assets','RFA/Fraud','Additional Provision','NPA Divergence')


 ---------------------------------------------------------

/*validations on InterestReceivableinRs */

-- UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InterestReceivableinRs cannot be blank. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'InterestReceivableinRs cannot be blank. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
--		,Srnooferroneousrows=V.SlNo
----								----STUFF((SELECT ','+SlNo 
----								----FROM UploadAccMOCPool A
----								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
----								----WHERE ISNULL(InterestReversalAmount,'')='')
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(InterestReceivableinRs,'')=''

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivableinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid InterestReceivableinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SlNo 
--								--FROM UploadAccMOCPool A
--								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (ISNUMERIC(InterestReceivableinRs)=0 AND ISNULL(InterestReceivableinRs,'')<>'') OR 
 ISNUMERIC(InterestReceivableinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid InterestReceivableinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivableinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(InterestReceivableinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid InterestReceivableinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid InterestReceivableinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InterestReceivableinRs' ELSE ErrorinColumn +','+SPACE(1)+  'InterestReceivableinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT SlNo FROM UploadAccMOCPool WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(InterestReceivableinRs,'')<>''
AND (CHARINDEX('.',ISNULL(InterestReceivableinRs,''))>0  AND Len(Right(ISNULL(InterestReceivableinRs,''),Len(ISNULL(InterestReceivableinRs,''))-CHARINDEX('.',ISNULL(InterestReceivableinRs,''))))>2)

 -----------------------------------------------------------------
 

/*validations on Additional Provision - Absolute in Rs. */

-- UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘Additional Provision - Absolute in Rs.’. Kindly check and upload value'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘Additional Provision - Absolute in Rs.’. Kindly check and upload value'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AdditionalProvisionAbsoluteinRs' ELSE ErrorinColumn +','+SPACE(1)+  'AdditionalProvisionAbsoluteinRs' END  
--		,Srnooferroneousrows=V.SlNo
----								----STUFF((SELECT ','+SlNo 
----								----FROM UploadAccMOCPool A
----								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
----								----WHERE ISNULL(InterestReversalAmount,'')='')
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(AdditionalProvisionAbsoluteinRs,'')=''

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AdditionalProvisionAbsoluteinRs' ELSE ErrorinColumn +','+SPACE(1)+  'AdditionalProvisionAbsoluteinRs' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SlNo 
--								--FROM UploadAccMOCPool A
--								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (ISNUMERIC(AdditionalProvisionAbsoluteinRs)=0 AND ISNULL(AdditionalProvisionAbsoluteinRs,'')<>'') OR 
 ISNUMERIC(AdditionalProvisionAbsoluteinRs) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AdditionalProvisionAbsoluteinRs' ELSE ErrorinColumn +','+SPACE(1)+  'AdditionalProvisionAbsoluteinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(AdditionalProvisionAbsoluteinRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid AdditionalProvisionAbsoluteinRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AdditionalProvisionAbsoluteinRs' ELSE ErrorinColumn +','+SPACE(1)+  'AdditionalProvisionAbsoluteinRs' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT SlNo FROM UploadAccMOCPool WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE ISNULL(AdditionalProvisionAbsoluteinRs,'')<>''
AND (CHARINDEX('.',ISNULL(AdditionalProvisionAbsoluteinRs,''))>0  AND Len(Right(ISNULL(AdditionalProvisionAbsoluteinRs,''),Len(ISNULL(AdditionalProvisionAbsoluteinRs,''))-CHARINDEX('.',ISNULL(AdditionalProvisionAbsoluteinRs,''))))>2)


 --------------------------RESTRUCTURE FLAG ---------------------------------------

-- UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘Restructure Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘Restructure Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureFlag' ELSE ErrorinColumn +','+SPACE(1)+  'RestructureFlag' END  
--		,Srnooferroneousrows=V.SlNo
----								----STUFF((SELECT ','+SlNo 
----								----FROM UploadAccMOCPool A
----								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
----								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
----								----)
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(RestructureFlagYN,'') NOT IN('Y','N') AND  ISNULL(RestructureFlagYN,'')<>''
 
 
--UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the Restructured flag. You can only remove the marked flag for this account'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the Restructured flag. You can only remove the marked flag for this account'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureFlag' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureFlag' END      
--		,Srnooferroneousrows=V.SlNo
--		--STUFF((SELECT ','+SlNo 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM UploadAccMOCPool V  
-- Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
-- WHERE ISNULL(A.FlgRestructure,'') ='Y'
 
 
 
--UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the Restructured flag. You can only add the marked flag for this account'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the Restructured flag. You can only add the marked flag for this account'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureFlag' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureFlag' END      
--		,Srnooferroneousrows=V.SlNo
--		--STUFF((SELECT ','+SlNo 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM UploadAccMOCPool V  
--Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
-- WHERE ISNULL(A.FlgRestructure,'') ='N'
 


 -----------------------------------------------------------------

 /*validations on Restructure Date */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'RestructureDate Can not be Blank . Please enter the RestructureDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'RestructureDate Can not be Blank. Please enter the RestructureDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureDate' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(RestructureDate,'')='' 

-- SET DATEFORMAT DMY
--UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureDate' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureDate' END      
--		,Srnooferroneousrows=V.SlNo
--		--STUFF((SELECT ','+SlNo 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(RestructureDate,'')<>'' AND ISDATE(RestructureDate)=0


--  Set DateFormat DMY
-- UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Restructure date must be less than equal to current date. Kindly check and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Restructure date must be less than equal to current date. Kindly check and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureDate' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureDate' END      
--		,Srnooferroneousrows=V.SlNo
--		--STUFF((SELECT ','+SlNo 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE (Case When ISDATE(RestructureDate)=1 Then Case When Cast(RestructureDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1



--  UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Restructure Date is mandatory when value ‘Y’ is entered in column ‘Restructure Flag'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Restructure Date is mandatory when value ‘Y’ is entered in column ‘Restructure Flag'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RestructureDate' ELSE   ErrorinColumn +','+SPACE(1)+'RestructureDate' END      
--		,Srnooferroneousrows=V.SlNo
--		--STUFF((SELECT ','+SlNo 
--		--						FROM #UploadNewAccount A
--		--						WHERE A.SlNo IN(SELECT V.SlNo FROM #UploadNewAccount V  
--		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

--		--										)
--		--						FOR XML PATH ('')
--		--						),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(RestructureFlagYN,'') IN('Y') AND ISNULL(RestructureDate,'' )=''

 
 --------------------------FITLFLAG ---------------------------------------
 
 UPDATE	UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘FITL Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘FITL Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FITLFlag' ELSE ErrorinColumn +','+SPACE(1)+  'FITLFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  

  WHERE ISNULL(FITLFlagYN,'') NOT IN('Y','N') AND  ISNULL(FITLFlagYN,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the FITL flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the FITL flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FITLFLAG' ELSE   ErrorinColumn +','+SPACE(1)+'FITLFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'') 

 FROM UploadAccMOCPool V  
 Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FLGFITL,'') ='Y' and ISNULL(V.FITLFlagYN,'')='Y'
 
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the FITL flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the FITL flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FITL' ELSE   ErrorinColumn +','+SPACE(1)+'FITL' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FLGFITL,'') ='N' and ISNULL(V.FITLFlagYN,'')='N'
 
 
/*validations on DFVAmount */

-- UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘DFVAmount’. Kindly check and upload value'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘DFVAmount’. Kindly check and upload value'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVAmount' ELSE ErrorinColumn +','+SPACE(1)+  'DFVAmount' END  
--		,Srnooferroneousrows=V.SlNo
----								----STUFF((SELECT ','+SlNo 
----								----FROM UploadAccMOCPool A
----								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
----								----WHERE ISNULL(InterestReversalAmount,'')='')
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM UploadAccMOCPool V  
-- WHERE ISNULL(DFVAmount,'')=''

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DFVAmount Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid DFVAmount Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVAmount' ELSE ErrorinColumn +','+SPACE(1)+  'DFVAmount' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SlNo 
--								--FROM UploadAccMOCPool A
--								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (ISNUMERIC(DFVAmount)=0 AND ISNULL(DFVAmount,'')<>'') OR 
 ISNUMERIC(DFVAmount) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DFVAmount Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DFVAmount Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVAmount' ELSE ErrorinColumn +','+SPACE(1)+  'DFVAmount' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(DFVAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid DFVAmount Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DFVAmount Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVAmount' ELSE ErrorinColumn +','+SPACE(1)+  'DFVAmount' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT SlNo FROM UploadAccMOCPool WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(DFVAmount,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
AND (CHARINDEX('.',ISNULL(DFVAmount,''))>0  AND Len(Right(ISNULL(DFVAmount,''),Len(ISNULL(DFVAmount,''))-CHARINDEX('.',ISNULL(DFVAmount,''))))>2)

 
 --------------------------Repossesion  FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘Repossesion Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘Repossesion Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossesssionFlag' ELSE ErrorinColumn +','+SPACE(1)+  'RePossesssionFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  

  WHERE ISNULL(RePossesssionFlagYN,'') NOT IN('Y','N') AND  ISNULL(RePossesssionFlagYN,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the Repossesion flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the Repossesion flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossesssionFlag' ELSE   ErrorinColumn +','+SPACE(1)+'RePossesssionFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.RePossession,'') ='Y'
 
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the Re-Possession flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the Re-Possession flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossesssionFlag' ELSE   ErrorinColumn +','+SPACE(1)+'RePossesssionFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.RePossession,'') ='N'
 

 -----------------------------------------------------------------

 /*validations on RePossessionDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'RePossessionDate Can not be Blank . Please enter the RePossessionDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'RePossessionDate Can not be Blank. Please enter the RePossessionDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossessionDate' ELSE   ErrorinColumn +','+SPACE(1)+'RePossessionDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(RePossessionDate,'')='' 

 SET DATEFORMAT DMY

UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossessionDate' ELSE   ErrorinColumn +','+SPACE(1)+'RePossessionDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(RePossessionDate,'')<>'' AND ISDATE(RePossessionDate)=0


 
  Set DateFormat DMY
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'RePossession date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'RePossession date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossessionDate' ELSE   ErrorinColumn +','+SPACE(1)+'RePossessionDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (Case When ISDATE(RePossessionDate)=1 Then Case When Cast(RePossessionDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1

 
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Re-Possession Date is mandatory when value ‘Y’ is entered in column ‘Re-Possession Flag'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Re-Possession Date is mandatory when value ‘Y’ is entered in column ‘Re-Possession Flag'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossessionDate' ELSE   ErrorinColumn +','+SPACE(1)+'RePossessionDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(RePossesssionFlagYN,'')='Y' and ISNULL(RePossessionDate,'')=''
 
 --------------------------Inherent Weakness FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘Inherent Weakness Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘Inherent Weakness Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessFlag' ELSE ErrorinColumn +','+SPACE(1)+  'InherentWeaknessFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  

  WHERE ISNULL(InherentWeaknessFLAG,'') NOT IN('Y','N') AND  ISNULL(InherentWeaknessFLAG,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the Inherent Weakness flag. You can only remove the marked flag for this account'  
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the Inherent Weakness flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessFlag' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.WeakAccount,'') ='Y'
 
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the Inherent Weakness flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the Inherent Weakness flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessFlag' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.WeakAccount,'') ='N'
 

 -----------------------------------------------------------------

 /*validations on InherentWeaknessDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InherentWeaknessDate Can not be Blank . Please enter the InherentWeaknessDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'InherentWeaknessDate Can not be Blank. Please enter the InherentWeaknessDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessDate' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(InherentWeaknessDate,'')='' 

 SET DATEFORMAT DMY
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessDate' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(InherentWeaknessDate,'')<>'' AND ISDATE(InherentWeaknessDate)=0


 
  Set DateFormat DMY
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InherentWeakness date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'InherentWeakness date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessDate' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE (Case When ISDATE(InherentWeaknessDate)=1 Then Case When Cast(InherentWeaknessDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Inherent Weakness Date is mandatory when value ‘Y’ is entered in column ‘Inherent Weakness Flag'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Inherent Weakness Date is mandatory when value ‘Y’ is entered in column ‘Inherent Weakness Flag'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InherentWeaknessDate' ELSE   ErrorinColumn +','+SPACE(1)+'InherentWeaknessDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(InherentWeaknessFlag,'')='Y' and ISNULL(InherentWeaknessDate,'')=''
 
 
 --------------------------SARFAESI FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘SARFAESI Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘SARFAESI Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIFlag' ELSE ErrorinColumn +','+SPACE(1)+  'SARFAESIFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 
  WHERE ISNULL(SARFAESIFLAG,'') NOT IN('Y','N') AND  ISNULL(SARFAESIFLAG,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the SARFAESI flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the SARFAESI flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIFlag' ELSE   ErrorinColumn +','+SPACE(1)+'SARFAESIFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.Sarfaesi,'') ='Y'
 
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the SARFAESI flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the SARFAESI flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIFlag' ELSE   ErrorinColumn +','+SPACE(1)+'SARFAESIFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.Sarfaesi,'') ='N'

 

 -----------------------------------------------------------------

 /*validations on SARFAESIDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SARFAESIDate Can not be Blank . Please enter the SARFAESIDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'SARFAESIDate Can not be Blank. Please enter the SARFAESIDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIDate' ELSE   ErrorinColumn +','+SPACE(1)+'SARFAESIDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(SARFAESIDate,'')='' 

 SET DATEFORMAT DMY
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIDate' ELSE   ErrorinColumn +','+SPACE(1)+'SARFAESIDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(SARFAESIDate,'')<>'' AND ISDATE(SARFAESIDate)=0


  Set DateFormat DMY

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SARFAESI date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'SARFAESI date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SARFAESIDate' ELSE   ErrorinColumn +','+SPACE(1)+'SARFAESIDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE (Case When ISDATE(SARFAESIDate)=1 Then Case When Cast(SARFAESIDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1


 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'SARFAESI Date is mandatory when value ‘Y’ is entered in column ‘SARFAESI Flag'     
						ELSE ErrorMessage+','+SPACE(1)+ 'SARFAESI Date is mandatory when value ‘Y’ is entered in column ‘SARFAESI Flag'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'RePossessionDate' ELSE   ErrorinColumn +','+SPACE(1)+'RePossessionDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(SARFAESIFlag,'')='Y' and ISNULL(SARFAESIDate,'')=''


 
 --------------------------UnusualBounce FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘UnusualBounce Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘UnusualBounce Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceFlag' ELSE ErrorinColumn +','+SPACE(1)+  'UnusualBounceFlag' END  
		,Srnooferroneousrows=V.SlNo
  FROM UploadAccMOCPool V  
 
  WHERE ISNULL(UnusualBounceFLAG,'') NOT IN('Y','N') AND  ISNULL(UnusualBounceFLAG,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the UnusualBounce flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the UnusualBounce flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceFlag' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgUnusualBounce,'') ='Y'
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the UnusualBounce flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the UnusualBounce flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceFlag' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgUnusualBounce,'') ='N'
 

 -----------------------------------------------------------------

 /*validations on UnusualBounceDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'UnusualBounceDate Can not be Blank . Please enter the UnusualBounceDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'UnusualBounceDate Can not be Blank. Please enter the UnusualBounceDate and upload again'    END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(UnusualBounceDate,'')='' 

 SET DATEFORMAT DMY
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(UnusualBounceDate,'')<>'' AND ISDATE(UnusualBounceDate)=0


 Set DateFormat DMY

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'UnusualBounce date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'UnusualBounce date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (Case When ISDATE(UnusualBounceDate)=1 Then Case When Cast(UnusualBounceDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1

 
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Unusual Bounce Date is mandatory when value ‘Y’ is entered in column ‘Unusual Bounce Flag'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Unusual Bounce Date is mandatory when value ‘Y’ is entered in column ‘Unusual Bounce Flag'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnusualBounceDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnusualBounceDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(UnusualBounceFlag,'')='Y' and ISNULL(UnusualBounceDate,'')=''
 --------------------------UnclearedEffects FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘UnclearedEffects Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘UnclearedEffects Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsFlag' ELSE ErrorinColumn +','+SPACE(1)+  'UnclearedEffectsFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 
 WHERE ISNULL(UnclearedEffectsFLAG,'') NOT IN('Y','N') AND  ISNULL(UnclearedEffectsFLAG,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the UnclearedEffects flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the UnclearedEffects flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsFlag' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgUnClearedEffect,'') ='Y'
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the UnclearedEffects flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the UnclearedEffects flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsFlag' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgUnClearedEffect,'') ='N'
 
  
 -----------------------------------------------------------------

 /*validations on UnclearedEffectsDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'UnclearedEffectsDate Can not be Blank . Please enter the UnclearedEffectsDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'UnclearedEffectsDate Can not be Blank. Please enter the UnclearedEffectsDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(UnclearedEffectsDate,'')='' 

 SET DATEFORMAT DMY

UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(UnclearedEffectsDate,'')<>'' AND ISDATE(UnclearedEffectsDate)=0


 
  Set DateFormat DMY
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'UnclearedEffects date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'UnclearedEffects date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE (Case When ISDATE(UnclearedEffectsDate)=1 Then Case When Cast(UnclearedEffectsDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Uncleared Effects Date is mandatory when value ‘Y’ is entered in column ‘Uncleared Effects Flag’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Uncleared Effects Date is mandatory when value ‘Y’ is entered in column ‘Uncleared Effects Flag’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'UnclearedEffectsDate' ELSE   ErrorinColumn +','+SPACE(1)+'UnclearedEffectsDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(UnclearedEffectsFLAG,'')='Y' and ISNULL(UnclearedEffectsDate,'')=''
 --------------------------Fraud FLAG ---------------------------------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘Fraud Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘Fraud Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudFlag' ELSE ErrorinColumn +','+SPACE(1)+  'FraudFlag' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 
  WHERE ISNULL(FraudFLAG,'') NOT IN('Y','N') AND  ISNULL(FraudFLAG,'')<>''
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is already marked with the Fraud flag. You can only remove the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is already marked with the Fraud flag. You can only remove the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudFlag' ELSE   ErrorinColumn +','+SPACE(1)+'FraudFLAG' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgFraud,'') ='Y'
 
 
 
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account is not marked to the Fraud flag. You can only add the marked flag for this account'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Account is not marked to the Fraud flag. You can only add the marked flag for this account'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudFlag' ELSE   ErrorinColumn +','+SPACE(1)+'FraudFlag' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
Inner Join PRO.AccountCal_Hist  A ON V.AccountID=A.CustomerAcID And A.EffectiveToTimeKey=49999
 WHERE ISNULL(A.FlgFraud,'') ='N'
 
 

 -----------------------------------------------------------------

 /*validations on FraudDate */

 --UPDATE UploadAccMOCPool
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'FraudDate Can not be Blank . Please enter the FraudDate and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+ 'FraudDate Can not be Blank. Please enter the FraudDate and upload again'      END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudDate' ELSE   ErrorinColumn +','+SPACE(1)+'FraudDate' END      
	--	,Srnooferroneousrows=V.SlNo
	--	--STUFF((SELECT ','+SlNo 
	--	--						FROM #UploadNewAccount A
	--	--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
	--	--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
	--	--										)
	--	--						FOR XML PATH ('')
	--	--						),1,1,'')   

 --FROM UploadAccMOCPool V  
 --WHERE ISNULL(FraudDate,'')='' 

 Set DateFormat DMY
UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudDate' ELSE   ErrorinColumn +','+SPACE(1)+'FraudDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(FraudDate,'')<>'' AND ISDATE(FraudDate)=0


 
 Set DateFormat DMY
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Fraud date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Fraud date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudDate' ELSE   ErrorinColumn +','+SPACE(1)+'FraudDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE (Case When ISDATE(FraudDate)=1 Then Case When Cast(FraudDate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1
 

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Fraud Date is mandatory when value ‘Y’ is entered in column ‘Fraud Flag'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Fraud Date is mandatory when value ‘Y’ is entered in column ‘Fraud Flag'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'FraudDate' ELSE   ErrorinColumn +','+SPACE(1)+'FraudDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(FraudFlag,'')='Y' and ISNULL(FraudDate,'')=''
 ---------------------------------MOC Source---------------------------

 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘MOC Source’. Kindly enter the values as mentioned in the ‘MOC Source’ master and upload again. Click on ‘Download Master value’ to download the valid values for the 










column'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘MOC Source’. Kindly enter the values as mentioned in the ‘MOC Source’ master and upload again. Click on ‘Download Master value’ to download the valid values for the column'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MOCSource' ELSE   ErrorinColumn +','+SPACE(1)+'MOCSource' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 left JOIN  DimMOCType a 
 on v.MOCSOURCE = A.MOCTypeName
 WHERE A.MOCTypeName is NULL

 -----------------------------------MOC Reason-------------------------

 
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'MOC Reason Can not be Blank . Please enter the MOC Reason and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'MOC Reason Can not be Blank. Please enter the MOC Reason and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MOCReason' ELSE   ErrorinColumn +','+SPACE(1)+'MOCReason' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(MOCReason,'')='' 

 
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'MOC reason cannot be greater than 500 characters'     
						ELSE ErrorMessage+','+SPACE(1)+ 'MOC reason cannot be greater than 500 characters'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MOCReason' ELSE   ErrorinColumn +','+SPACE(1)+'MOCReason' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE LEN(MOCReason)>500
 
  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'For MOC reason column, special characters - , /\ are allowed. Kindly check and try again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'For MOC reason column, special characters - , /\ are allowed. Kindly check and try again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MOCReason' ELSE   ErrorinColumn +','+SPACE(1)+'MOCReason' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										WHERE ISNULL(AssetClass,'')<>'' AND ISNULL(AssetClass,'')<>'STD' and  ISNULL(NPADate,'')=''
		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE LEN(MOCReason) LIKE '%[!@#$%^&*()_+=]%'

 ---------------------------Validations on TWO Flag
 
 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid value in column ‘TWO Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid value in column ‘TWO Flag(Y/N)’. Kindly enter ‘Y or N’ and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TwoFlag' ELSE ErrorinColumn +','+SPACE(1)+  'TwoFlag' END  
		,Srnooferroneousrows=V.SlNo
  FROM UploadAccMOCPool V  
 
  WHERE ISNULL(TWOFlag,'') NOT IN('Y','N') AND  ISNULL(TWOFlag,'')<>''
 
 
 
/*VALIDATIONS ON TWO Date */

UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TwoDate' ELSE   ErrorinColumn +','+SPACE(1)+'TwoDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(TWODate,'')<>'' AND ISDATE(TWODate)=0

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'The column ‘TWO Date’ is mandatory. Kindly check and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'The column ‘TWO Date’ is mandatory. Kindly check and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TWO Date' ELSE ErrorinColumn +','+SPACE(1)+  'TWO Date' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM UploadAccMOCPool V  
 WHERE ISNULL(Twodate,'')=''  and ISNULL(TWOFlag,'') = 'Y'

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'TWO date must be less than equal to current date. Kindly check and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'TWO date must be less than equal to current date. Kindly check and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TwoDate' ELSE   ErrorinColumn +','+SPACE(1)+'TwoDate' END      
		,Srnooferroneousrows=V.SlNo
		--STUFF((SELECT ','+SlNo 
		--						FROM #UploadNewAccount A
		--						WHERE A.SlNo IN(SELECT V.SlNo  FROM #UploadNewAccount V  
		--										  WHERE ISNULL(NPADate,'')<>'' AND (CAST(ISNULL(NPADate ,'')AS Varchar(10))<>FORMAT(cast(NPADate as date),'dd-MM-yyyy'))

		--										)
		--						FOR XML PATH ('')
		--						),1,1,'')   

 FROM UploadAccMOCPool V  
WHERE (Case When ISDATE(Twodate)=1 Then Case When Cast(Twodate as date)>Cast(GETDATE() as Date) Then 1 Else 0 END END)=1

 -------------------------------Validations on TWO Amount-----------------

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid TWOAmount Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid TWOAmount Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TWOAmount' ELSE ErrorinColumn +','+SPACE(1)+  'TWOAmount' END  
		,Srnooferroneousrows=V.SlNo
--								--STUFF((SELECT ','+SlNo 
--								--FROM UploadAccMOCPool A
--								--WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								--WHERE (ISNUMERIC(InterestReversalAmount)=0 AND ISNULL(InterestReversalAmount,'')<>'') OR 
--								--ISNUMERIC(InterestReversalAmount) LIKE '%^[0-9]%'
--								--)
--								--FOR XML PATH ('')
--								--),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE (ISNUMERIC(TWOAmount)=0 AND ISNULL(TWOAmount,'')<>'') OR 
 ISNUMERIC(TWOAmount) LIKE '%^[0-9]%'
 PRINT 'INVALID' 

 UPDATE UploadAccMOCPool
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid TWOAmount. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid TWOAmount. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TWOAmount' ELSE ErrorinColumn +','+SPACE(1)+  'TWOAmount' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT V.SlNo FROM UploadAccMOCPool V
--								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--								----)
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(TWOAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'

  UPDATE UploadAccMOCPool
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid TWOAmount. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid TWOAmount. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TWOAmount' ELSE ErrorinColumn +','+SPACE(1)+  'TWOAmount' END  
		,Srnooferroneousrows=V.SlNo
--								----STUFF((SELECT ','+SlNo 
--								----FROM UploadAccMOCPool A
--								----WHERE A.SlNo IN(SELECT SlNo FROM UploadAccMOCPool WHERE ISNULL(InterestReversalAmount,'')<>''
--								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
--								---- )
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM UploadAccMOCPool V  
 WHERE ISNULL(TWOAmount,'')<>''
AND (CHARINDEX('.',ISNULL(TWOAmount,''))>0  AND Len(Right(ISNULL(TWOAmount,''),Len(ISNULL(TWOAmount,''))-CHARINDEX('.',ISNULL(TWOAmount,''))))>2)




  ----------------------------------------------
  
  /*validations on SourceSystem*/
--    Declare @DuplicateSourceSystemDataInt int=0

	

--	IF OBJECT_ID('SourceSystemData') IS NOT NULL  
--	  BEGIN  
--	   DROP TABLE SourceSystemData 
	
--	  END

--	   SELECT * into SourceSystemData  FROM(
-- SELECT ROW_NUMBER() OVER(PARTITION BY SourceSystem  ORDER BY  SourceSystem ) 
-- ROW ,SourceSystem FROM UploadAccMOCPool
--)X
-- WHERE ROW=1

 
--  SELECT  @DuplicateSourceSystemDataInt=COUNT(*) FROM UploadAccMOCPool A
-- Left JOIN DIMSOURCEDB B
-- ON  A.SourceSystem=B.SourceName
-- Where B.SourceName IS NULL

--    IF @DuplicateSourceSystemDataInt>0

--	BEGIN
--	       UPDATE UploadAccMOCPool
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid value in column ‘SourceSystem’. Kindly enter the values as mentioned in the ‘Segment’ master and upload again. Click on ‘Download Master value’ to download the valid values for the co
--lumn'     
--						ELSE ErrorMessage+','+SPACE(1)+'Invalid value in column ‘SourceSystem’. Kindly enter the values as mentioned in the ‘Segment’ master and upload again. Click on ‘Download Master value’ to download the valid values for the column'     END  
--        ,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'SourceSystem' ELSE   ErrorinColumn +','+SPACE(1)+'SourceSystem' END     
--		,Srnooferroneousrows=V.SlNo
--		 FROM UploadAccMOCPool V  
-- WHERE ISNULL(SourceSystem,'')<>''
-- AND  V.SourceSystem IN(
--                     SELECT  A.SourceSystem FROM UploadAccMOCPool A
--					 Left JOIN DIMSOURCEDB B
--					 ON  A.SourceSystem=B.SourceName
--					 Where B.SourceName IS NULL
--                 )
			
			
				 
--	END

 -----------------------------------------------------------
 --select * from DimMOCType
 Print '123'
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Data'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  AccountLvlMOCDetails_stg WHERE filname=@FilePathUpload)
		BEGIN
		PRINT 'NO ERRORS'
			
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT '' SlNo , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 
			
		END
		ELSE
		BEGIN
			PRINT 'VALIDATION ERRORS'
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Srnooferroneousrows,Flag) 
			SELECT SlNo,ErrorinColumn,ErrorMessage,ErrorinColumn,@filepath,Srnooferroneousrows,'SUCCESS' 
			FROM UploadAccMOCPool 


			
		--	----SELECT * FROM UploadAccMOCPool 

		--	--ORDER BY ErrorMessage,UploadAccMOCPool.ErrorinColumn DESC
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
print 'Jayadev'
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
		print 'Jayadev1'
		 IF EXISTS(SELECT 1 FROM AccountLvlMOCDetails_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM AccountLvlMOCDetails_stg
		 WHERE filname=@FilePathUpload
		 print 'Jayadev2'
		 PRINT 1

		 PRINT 'ROWS DELETED FROM DBO.AccountLvlMOCDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
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

	----SELECT * FROM UploadAccMOCPool

	print 'p'
  ------to delete file if it has errors
		--if exists(Select  1 from dbo.MasterUploadData where FileNames=@filepath and ISNULL(ErrorData,'')<>'')
		--begin
		--print 'ppp'
		-- IF EXISTS(SELECT 1 FROM AccountLvlMOCDetails_stg WHERE filename=@FilePathUpload)
		-- BEGIN
		-- print '123'
		-- DELETE FROM AccountLvlMOCDetails_stg
		-- WHERE filename=@FilePathUpload

		-- PRINT 'ROWS DELETED FROM DBO.AccountLvlMOCDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		-- END
		-- END

   
END  TRY
  
  BEGIN CATCH
	

	INSERT INTO dbo.Error_Log
				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber
				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState
				,GETDATE()

	--IF EXISTS(SELECT 1 FROM AccountLvlMOCDetails_stg WHERE filename=@FilePathUpload)
	--	 BEGIN
	--	 DELETE FROM AccountLvlMOCDetails_stg
	--	 WHERE filename=@FilePathUpload

	--	 PRINT 'ROWS DELETED FROM DBO.AccountLvlMOCDetails_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
	--	 END

END CATCH

END


GO
