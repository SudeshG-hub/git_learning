SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ValidateExcel_DataUpload_RestructureAssetsUpload]  
 @MenuID INT=10,  
@UserLoginId  VARCHAR(20)='fnachecker',  
@Timekey INT=49999
,@filepath VARCHAR(MAX) ='IBPCUPLOAD.xlsx'  
WITH RECOMPILE  
AS  
  
  --fnasuperadmin_IBPCUPLOAD.xlsx
  --fnachecker_RestructuredAssetsUpload.xlsx
--DECLARE  
  
--@MenuID INT=24714,  
--@UserLoginId varchar(20)='fnachecker',  
--@Timekey int=49999
--,@filepath varchar(500)='RestructuredAssetsUpload.xlsx'  
  
BEGIN

BEGIN TRY  
--BEGIN TRAN  
  
--Declare @TimeKey int  
    --Update UploadStatus Set ValidationOfData='N' where FileNames=@filepath  
     
	 SET DATEFORMAT DMY

 --Select @Timekey=Max(Timekey) from dbo.SysProcessingCycle  
 -- where  ProcessType='Quarterly' ----and PreMOC_CycleFrozenDate IS NULL
 
 --Select   @Timekey=Max(Timekey) from sysDayMatrix where Cast(date as Date)=cast(getdate() as Date)
 Set  @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
                    Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
                       where A.CurrentStatus='C')

  PRINT @Timekey  
  
    
  
  DECLARE @FilePathUpload	VARCHAR(100)

			SET @FilePathUpload=@UserLoginId+'_'+@filepath
	PRINT '@FilePathUpload'
	PRINT @FilePathUpload

	IF EXISTS(SELECT 1 FROM dbo.MasterUploadData    where FileNames=@filepath )
	BEGIN
		Delete from dbo.MasterUploadData    where FileNames=@filepath  
		print @@rowcount
	END


IF (@MenuID=24714)	
BEGIN

  -----------------SELECT * FROM RetsructuredAssetsUpload_stg
	  -- IF OBJECT_ID('tempdb..RestructureAssets') IS NOT NULL  
	  IF OBJECT_ID('RestructureAssets') IS NOT NULL  
	  BEGIN  
	   DROP TABLE RestructureAssets  
	
	  END
	  
  IF NOT (EXISTS (SELECT 1 FROM RetsructuredAssetsUpload_stg where filname=@FilePathUpload))
  ----update RetsructuredAssetsUpload_stg set filname='2ndlvlchecker_RestructuredAssetsUpload.xlsx'
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
 	   into RestructureAssets 
	   from RetsructuredAssetsUpload_stg 
	   WHERE filname=@FilePathUpload

	  
END
 --drop table RestructureAssets
--alter table select * from RetsructuredAssetsUpload_stg
--alter column POSasonDateofRstrctr varchar(max)


  ------------------------------------------------------------------------------  
    ----SELECT * FROM RestructureAssets
	--SrNo	Territory	ACID	InterestReversalAmount	filname
	UPDATE RestructureAssets
	SET  
        ErrorMessage='There is no data in excel. Kindly check and upload again' 
		,ErrorinColumn='Pool ID,Pool Name,Customer ID,Account ID,POS,Interest Receivable,Balances,Dates'    
		,Srnooferroneousrows=''
 FROM RestructureAssets V  
 WHERE ISNULL(SrNo,'')=''
AND ISNULL(RestructureFacility,'')=''
AND ISNULL(AccountID,'')=''
--AND ISNULL(InvocationDate,'')=''
AND ISNULL(Equityconversion,'')=''
AND ISNULL(DateofConversionintoEquity,'')=''
AND ISNULL(PrinRpymntStartDate,'')=''
AND ISNULL(InttRpymntStartDate,'')=''
AND ISNULL(TypeofRestructuring,'')=''
--AND ISNULL(CovidMoratoriamMSME,'')=''
--AND ISNULL(CovidOTRCategory,'')=''
AND ISNULL(BankingRelationship,'')=''
AND ISNULL(DateofRestructuring,'')=''
AND ISNULL(RestructuringApprovingAuth,'')=''
AND ISNULL(DateofIstDefaultonCRILIC,'')=''
AND ISNULL(ReportingBank,'')=''
--AND ISNULL(DateofSigningICA,'')=''
AND ISNULL(amountRstrctr,'')='' 
--AND ISNULL(POSasonDateofRstrctr,'')=''
AND ISNULL(InvestmentGrade,'')=''
AND ISNULL(StatusofSpecificPeriod,'')=''
--AND ISNULL(CreditProvisionRs,'')=''
AND ISNULL(DFVProvisionRs,'')=''
--AND ISNULL(MTMProvisionRs,'')=''


  IF EXISTS(SELECT 1 FROM RestructureAssets WHERE ISNULL(ErrorMessage,'')<>'')
  BEGIN
  PRINT 'NO DATA'
  GOTO ERRORDATA;
  END

  
 -- /*validations on POOLID*/
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'POOLID cannot be blank . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'POOLID cannot be blank . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POOLID' ELSE   ErrorinColumn +','+SPACE(1)+'PoolID' END   
	--	,Srnooferroneousrows=V.SrNo
								
 --  FROM RestructureAssets V  
 --WHERE ISNULL(PoolID,'')=''

  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid PoolID.  Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid PoolID.  Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PoolID' ELSE   ErrorinColumn +','+SPACE(1)+'PoolID' END       
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(PoolID,'')<>''
 --AND LEN(PoolID)>20

  /*validations on Restructure Facility*/

  Print 'A'
  
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Restructure Facility cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Restructure Facility cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Restructure Facility' ELSE   ErrorinColumn +','+SPACE(1)+'Restructure Facility' END   
		,Srnooferroneousrows=V.SrNo
								--STUFF((SELECT ','+SRNO 
								--FROM RestructureAssets A
								--WHERE A.SrNo IN(SELECT V.SrNo  FROM RestructureAssets V  
								--WHERE ISNULL(SOLID,'')='')
								--FOR XML PATH ('')
								--),1,1,'')
   
   FROM RestructureAssets V  
 WHERE ISNULL(RestructureFacility,'')=''
 --select * from RestructureAssets where PoolType  in  ('With Risk' , 'With out Risk')
  Print 'A1'
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Restructure Facility.  Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Restructure Facility.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Restructure Facility' ELSE   ErrorinColumn +','+SPACE(1)+'Restructure Facility' END       
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(RestructureFacility,'')<>''
 AND LEN(RestructureFacility)>20
 Print 'A2'
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Restructure Facility.  Please check the values With Restructured OR Additional Finance OR FITL OR Other and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Restructure Facility.  Please check the values With Restructured OR Additional Finance OR FITL OR Other and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Restructure Facility' ELSE   ErrorinColumn +','+SPACE(1)+'Restructure Facility' END       
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE RestructureFacility  NOT in  ('Restructured' , 'Additional Finance','FITL','Other')


 
  /*validations on Revised Business Seg*/

  --Print 'A'
  


 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Revised Business Seg cannot be blank . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Revised Business Seg cannot be blank . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Revised Business Seg' ELSE   ErrorinColumn +','+SPACE(1)+'Revised Business Seg' END   
	--	,Srnooferroneousrows=V.SrNo
	--							--STUFF((SELECT ','+SRNO 
	--							--FROM RestructureAssets A
	--							--WHERE A.SrNo IN(SELECT V.SrNo  FROM RestructureAssets V  
	--							--WHERE ISNULL(SOLID,'')='')
	--							--FOR XML PATH ('')
	--							--),1,1,'')
   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(RevisedBusinessSeg,'')=''

 --UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Revised Business Seg,special characters - , /\ are allowed . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Revised Business Seg,special characters - , /\ are allowed . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Revised Business Seg' ELSE   ErrorinColumn +','+SPACE(1)+'Revised Business Seg' END   
	--	,Srnooferroneousrows=V.SrNo
 -- FROM RestructureAssets V 
 --WHERE ISNULL(RevisedBusinessSeg,'') LIKE'%[!@#$%^&*(),_+=]%'
 
 -------------------------------------------------------
 /*
 /*validations on Banking Relationship*/
  Print 'A3'
 
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Banking Relationship cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Banking Relationship cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Banking Relationship' ELSE   ErrorinColumn +','+SPACE(1)+'Banking Relationship' END   
		,Srnooferroneousrows=V.SrNo
								
   
   FROM RestructureAssets V  
 WHERE ISNULL(BankingRelationship,'')=''

 */
 --select * from RestructureAssets where PoolType  in  ('With Risk' , 'With out Risk')
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Banking Relationship.  Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid Banking Relationship.  Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Banking Relationship' ELSE   ErrorinColumn +','+SPACE(1)+'Banking Relationship' END       
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(BankingRelationship,'')<>''
-- AND LEN(BankingRelationship)>20
Print 'A4'
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Banking Relationship.  Please check the values 
		With Sole Banking OR Multiple Banking OR Consortium OR Consortium-WC OR Consortium-TL OR WC-MBA OR TL-MBA and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Banking Relationship.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Banking Relationship' ELSE   ErrorinColumn +','+SPACE(1)+'Banking Relationship' END       
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE BankingRelationship  NOT in  ('Sole Banking' , 'Multiple Banking','Consortium','Consortium-WC','Consortium-TL','WC-MBA','TL-MBA','')

 Print 'A5'
 ---------------------------------------------------------------------------------------------------------------------
   /*validations on Type of Restructuring*/
  
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Type of Restructuring cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Type of Restructuring cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Type of Restructuring' ELSE   ErrorinColumn +','+SPACE(1)+'Type of Restructuring' END   
		,Srnooferroneousrows=V.SrNo
								
   
   FROM RestructureAssets V  
 --WHERE ISNULL(TypeofRestructuring,'')=''
  WHERE ISNULL(TypeofRestructuring,'')=''
 --select * from RestructureAssets where PoolType  in  ('With Risk' , 'With out Risk')
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Banking Relationship.  Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid Banking Relationship.  Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Banking Relationship' ELSE   ErrorinColumn +','+SPACE(1)+'Banking Relationship' END       
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(BankingRelationship,'')<>''
-- AND LEN(BankingRelationship)>20
Print 'A6'
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Type of Restructuring.  Please check the values and upload again '
		--With IRAC OR Prudential Framework_June 07 Circular OR Resolution Framework_Covid OTR OR MSME_Old Circular OR MSME_Covid Circular
		--    OR DCCO OR Natural Calamity OR BIFR OR Other  and upload again     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Restructuring.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TypeofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'TypeofRestructuring' END     
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')  NOT in  ('IRAC Circular' , 'Under DCCO - PUI','Natural Calamity','Other')
  --WHERE ISNULL(TypeofRestructuring,'')  NOT in  ('IRAC Circular' , 'Prudential Framework (June 7,2020 circular)','Resolution Framework (COVID-OTR)','MSME_Old circular','MSME_COVID circular','MSME_COVID_RF 2.0','COVID_OTR_RF 2.0','Under DCCO - PUI','Natural Calamity','BIFR','Other')

---------------------------------------------------------------------------------------------------------------------
   /*validations on Covid Moratoriam MSME*/
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CovidMoratoriamMSME cannot be blank . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'CovidMoratoriamMSME cannot be blank . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidMoratoriamMSME' ELSE   ErrorinColumn +','+SPACE(1)+'CovidMoratoriamMSME' END   
	--	,Srnooferroneousrows=V.SrNo
								
   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(CovidMoratoriamMSME,'')=''
 
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CovidMoratoriamMSME cannot be blank . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'CovidMoratoriamMSME cannot be blank . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidMoratoriamMSME' ELSE   ErrorinColumn +','+SPACE(1)+'CovidMoratoriamMSME' END 
	--	,Srnooferroneousrows=V.SrNo
								
   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(TypeofRestructuring,'') IN('MSME_Old Circular' , 'MSME_Covid Circular') AND ISNULL(CovidMoratoriamMSME,'') NOT IN('YES','NO','NA')

 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'If Type of Restructuring in MSME_Old Circular or MSME_Covid Circular then only Covid Moratoriam MSME is enabled'
	--	--With IRAC OR Prudential Framework_June 07 Circular OR Resolution Framework_Covid OTR OR MSME_Old Circular OR MSME_Covid Circular
	--	--    OR DCCO OR Natural Calamity OR BIFR OR Other  and upload again     
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of CovidMoratoriamMSME.Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidMoratoriamMSME' ELSE   ErrorinColumn +','+SPACE(1)+'CovidMoratoriamMSME.' END     
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(TypeofRestructuring,'') not IN('MSME_Old Circular' , 'MSME_Covid Circular') and ISNULL(CovidMoratoriamMSME,'') NOT in ('')
 
 --------------------------------------------------------------------------------------------

 --validations on Equity conversion--- 

  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Cannot blank Invalid Type of Equity Conversion.Please check the values and upload again '   
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Equity Conversion.Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Equityconversion' ELSE   ErrorinColumn +','+SPACE(1)+'EquityConversion.' END     
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(EquityConversion,'')  NOT in  ('YES' , 'NO')

---validations on date of conversion into equity---

  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'If Equity conversion Yes then Date of conversion into equity is mandatory.Please check the values and upload again'   
						ELSE ErrorMessage+','+SPACE(1)+'If Equity conversion Yes then Date of conversion into equity is mandatory.Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofConversionintoEquity' ELSE   ErrorinColumn +','+SPACE(1)+'DateofConversionintoEquity.' END     
		,Srnooferroneousrows=V.SrNo
 
   FROM RestructureAssets V  
 where EquityConversion='YES' and isnull(DateofConversionintoEquity,'') = ''


 ---------------------------------------------------------------------------------------------
 ---Validation on Status of specific period----

  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Type of Status of Specific Period.Please check the values and upload again '    
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Status of Specific Period.Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'StatusofSpecificPeriod' ELSE   ErrorinColumn +','+SPACE(1)+'StatusofSpecificPeriod.' END     
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(StatusofSpecificPeriod,'')  NOT in ('','Under Specified Period','Bank specified Period over') 

 ----------------------------------------------------------------------------------------------------
 -----Validation on Investment Grade--------

  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Type of Status of Specific Period.Please check the values and upload again '    
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Status of Specific Period.Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InvestmentGrade' ELSE   ErrorinColumn +','+SPACE(1)+'InvestmentGrade.' END     
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(InvestmentGrade,'')  NOT in  ('NO','YES','NA','')

 --------------------------------------------------------------------------------------------
   /*validations on Covid - OTR Category*/
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CovidOTRCategory cannot be blank . Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'CovidOTRCategory cannot be blank . Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidOTRCategory' ELSE   ErrorinColumn +','+SPACE(1)+'CovidOTRCategory' END   
	--	,Srnooferroneousrows=V.SrNo
								
   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(CovidOTRCategory,'')=''

 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'In case otherwise display "Invalid Value entered in column Covid - OTR Category. Kindly enter either of the mentioned values and try again - Personal, other'     
	--					ELSE ErrorMessage+','+SPACE(1)+'In case otherwise display "Invalid Value entered in column Covid - OTR Category. Kindly enter either of the mentioned values and try again - Personal, other'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidOTRCategory' ELSE   ErrorinColumn +','+SPACE(1)+'CovidOTRCategory' END   
	--	,Srnooferroneousrows=V.SrNo
								
   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(TypeofRestructuring,'') IN('Resolution Framework (COVID-OTR)') AND ISNULL(CovidOTRCategory,'') NOT IN('Personal','Other')
 
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'If Type of Restructuring in Resolution Framework (COVID-OTR) then only Covid OTR Category is enabled'    
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of CovidMoratoriamMSME.Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CovidOTRCategory' ELSE   ErrorinColumn +','+SPACE(1)+'CovidOTRCategory.' END     
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(CovidOTRCategory,'')  NOT in  ('Personal','Other','')

 -----------------------------------------------------------

 Print 'A7'
 
/*VALIDATIONS ON AccountID */

  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Account ID cannot be blank.  Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Account ID cannot be blank.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM RestructureAssets A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM RestructureAssets V  
--								----				WHERE ISNULL(ACID,'')='' )
--								----FOR XML PATH ('')
--								----),1,1,'')   

FROM RestructureAssets V  
 WHERE ISNULL(AccountID,'')='' 
 

-- ----SELECT * FROM RestructureAssets
  Print 'A8'
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid Account ID found. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
  
		FROM RestructureAssets V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND V.AccountID NOT IN(SELECT CustomerACID FROM [CurDat].[AdvAcBasicDetail] 
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
						 )


 IF OBJECT_ID('TEMPDB..#DUB2') IS NOT NULL
 DROP TABLE #DUB2

 SELECT * INTO #DUB2 FROM(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY AccountID ) as rw  FROM RestructureAssets
 )X
 WHERE rw>1

 Print 'A9'
 UPDATE V
	SET  
        ErrorMessage=CASE WHEN ISNULL(V.ErrorMessage,'')='' THEN  'Duplicate Account ID found. Please check the values and upload again'     
						ELSE V.ErrorMessage+','+SPACE(1)+'Duplicate Account ID found. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(V.ErrorinColumn,'')='' THEN 'Account ID' ELSE V.ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
  
		FROM RestructureAssets V 
		INNer JOIN #DUB2 D ON D.AccountID=V.AccountID

Print 'A10'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Account ID are pending for authorization'     
						ELSE ErrorMessage+','+SPACE(1)+'Account ID are pending for authorization'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Account ID' ELSE ErrorinColumn +','+SPACE(1)+  'Account ID' END  
		,Srnooferroneousrows=V.SRNO
  
		FROM RestructureAssets V  
 WHERE ISNULL(V.AccountID,'')<>''
 AND (V.AccountID  IN (SELECT AccountID FROM RestructureAsset_Upload_Mod
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
								AND AuthorisationStatus in ('NP','MP','1A','FM','A')
						 ) OR
						 V.AccountID  IN (SELECT RefSystemAcId FROM AdvAcRestructureDetail_Mod
								WHERE EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey>=@Timekey
								AND AuthorisationStatus in ('NP','MP','1A','FM','A')
						 )
						 )

						 --------------------DisbursementDate
/*
Print 'An1'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DisbursementDate Can not be Blank . Please enter the DisbursementDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'DisbursementDate Can not be Blank. Please enter the DisbursementDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DisbursementDate' ELSE   ErrorinColumn +','+SPACE(1)+'DisbursementDate' END      
		,Srnooferroneousrows=V.SrNo

	
		 
 FROM RestructureAssets V  
 WHERE ISNULL(DisbursementDate,'')='' 

 */



-- SET DATEFORMAT DMY
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DisbursementDate' ELSE   ErrorinColumn +','+SPACE(1)+'DisbursementDate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE ISNULL(DisbursementDate,'')<>'' AND ISDATE(DisbursementDate)=0

-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DisbursementDate' ELSE   ErrorinColumn +','+SPACE(1)+'DisbursementDate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
--  WHERE (Case When ISDATE(DisbursementDate)=1 Then Case When Cast(DisbursementDate as date)>Cast(GETDATE() as Date) Then 1 
--                                     Else 0 END END) =1
 


 --WHERE (Case When ISDATE(DisbursementDate)=1 Then Case When Cast(DisbursementDate as date)>Cast(GETDATE() as Date) Then 1
 --            WHEN ISDATE(DisbursementDate)=1 Then Case When Cast(DisbursementDate as date)>Cast(GETDATE() as Date) Then 1 Else 0  END END )=1
 
 --select isdate(getdate())


------------------------------------------------ReferenceDate --------------------
/*
Print 'An2'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'ReferenceDate Can not be Blank . Please enter the ReferenceDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'ReferenceDate Can not be Blank. Please enter the ReferenceDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ReferenceDate' ELSE   ErrorinColumn +','+SPACE(1)+'ReferenceDate' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
 WHERE ISNULL(ReferenceDate,'')='' 

 */

--SET DATEFORMAT DMY
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ReferenceDate' ELSE   ErrorinColumn +','+SPACE(1)+'ReferenceDate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE ISNULL(ReferenceDate,'')<>'' AND ISDATE(ReferenceDate)=0

/*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ReferenceDate' ELSE   ErrorinColumn +','+SPACE(1)+'ReferenceDate' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(ReferenceDate)=1 Then Case When Cast(ReferenceDate as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(ReferenceDate as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)

			 */

 ------------------------------------------------InvocationDate --------------------
 /*
 Print 'An3'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InvocationDate Can not be Blank . Please enter the InvocationDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'InvocationDate Can not be Blank. Please enter the InvocationDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InvocationDate' ELSE   ErrorinColumn +','+SPACE(1)+'InvocationDate' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
 WHERE ISNULL(InvocationDate,'')='' 

 */

 Print 'An33'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		--,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InvocationDate' ELSE   ErrorinColumn +','+SPACE(1)+'InvocationDate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
---- WHERE ISNULL(InvocationDate,'')<>'' AND ISDATE(InvocationDate)=0

/*
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Disbursement Date '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InvocationDate' ELSE   ErrorinColumn +','+SPACE(1)+'InvocationDate' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(InvocationDate)=1 Then Case When Cast(InvocationDate as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(InvocationDate as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)

			 */
---------------------------------------------------------------------------
------------------------------------------------DateofConversionintoEquity --------------------
Print 'An4'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofConversionintoEquity Can not be Blank . Please enter the DateofConversionintoEquity and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DateofConversionintoEquity Can not be Blank. Please enter the DateofConversionintoEquity and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofConversionintoEquity' ELSE   ErrorinColumn +','+SPACE(1)+'DateofConversionintoEquity' END   
--		,Srnooferroneousrows=V.SrNo
		  

-- FROM RestructureAssets V  
-- WHERE ISNULL(DateofConversionintoEquity,'')='' 
Print 'An44'
SET DATEFORMAT DMY
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofConversionintoEquity' ELSE   ErrorinColumn +','+SPACE(1)+'DateofConversionintoEquity' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(DateofConversionintoEquity,'')<>'' AND ISDATE(DateofConversionintoEquity)=0
 /*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Disbursement Date '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofConversionintoEquity' ELSE   ErrorinColumn +','+SPACE(1)+'DateofConversionintoEquity' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(DateofConversionintoEquity)=1 Then Case When Cast(DateofConversionintoEquity as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(DateofConversionintoEquity as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)
			 */
---------------------------------------------------------------------------
------------------------------------------------PrinRpymntStartDate --------------------
/*Print 'An5'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'PrinRpymntStartDate Can not be Blank . Please enter the PrinRpymntStartDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'PrinRpymntStartDate Can not be Blank. Please enter the PrinRpymntStartDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrinRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'PrinRpymntStartDate' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
 WHERE ISNULL(PrinRpymntStartDate,'')='' 

 */

 Print 'An55'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrinRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'PrinRpymntStartDate' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(PrinRpymntStartDate,'')<>'' AND ISDATE(PrinRpymntStartDate)=0

 /*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Disbursement Date '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'PrinRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'PrinRpymntStartDate' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(PrinRpymntStartDate)=1 Then Case When Cast(PrinRpymntStartDate as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(PrinRpymntStartDate as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)

			 */

 ------------------------------------------------InttRpymntStartDate --------------------
 /*
 Print 'An6'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'InttRpymntStartDate Can not be Blank . Please enter the InttRpymntStartDate and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'InttRpymntStartDate Can not be Blank. Please enter the InttRpymntStartDate and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InttRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'InttRpymntStartDate' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
 WHERE ISNULL(InttRpymntStartDate,'')='' 

 */

 Print 'An66'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InttRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'InttRpymntStartDate' 
END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(InttRpymntStartDate,'')<>'' AND ISDATE(InttRpymntStartDate)=0

/* 
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Disbursement Date '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'InttRpymntStartDate' ELSE   ErrorinColumn +','+SPACE(1)+'InttRpymntStartDate' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(InttRpymntStartDate)=1 Then Case When Cast(InttRpymntStartDate as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(InttRpymntStartDate as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)
			 */
 ------------------------------------------------InttRpymntStartDate --------------------
-- Print 'An6'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'AssetClassatRstrctr Can not be Blank . Please enter the InttRpymntStartDate and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'AssetClassatRstrctr Can not be Blank. Please enter the InttRpymntStartDate and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AssetClassatRstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'AssetClassatRstrctr' END      
--		,Srnooferroneousrows=V.SrNo
		  

-- FROM RestructureAssets V  
-- WHERE ISNULL(AssetClassatRstrctr,'')='' 


-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Value entered in column Asset Class at Rstrctr. Kindly Check and upload Again '     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid Value entered in column Asset Class at Rstrctr. Kindly Check and upload Again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AssetClassatRstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'AssetClassatRstrctr' END      
--		,Srnooferroneousrows=V.SrNo
		  

-- FROM RestructureAssets V  
-- WHERE ISNULL(AssetClassatRstrctr,'') NOT IN('STANDARD','SUB-STANDARD','DOUBTFUL I','DOUBTFUL II','DOUBTFUL III','LOS')
-- ------------------------------------------------NPADate --------------------
-- Print 'An7'
----UPDATE RestructureAssets
----	SET  
----        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'NPADate Can not be Blank . Please enter the NPADate and upload again'     
----						ELSE ErrorMessage+','+SPACE(1)+ 'NPADate Can not be Blank. Please enter the NPADate and upload again'      END
----		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPADate' ELSE   ErrorinColumn +','+SPACE(1)+'NPADate' END      
----		,Srnooferroneousrows=V.SrNo
		  

---- FROM RestructureAssets V  
---- WHERE ISNULL(NPADate,'')='' 

-- Print 'An77'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPADate' ELSE   ErrorinColumn +','+SPACE(1)+'NPADate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE ISNULL(NPADate,'')<>'' AND ISDATE(NPADate)=0

 
--  UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Disbursement Date '     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Disbursement Date'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPADate' ELSE   ErrorinColumn +','+SPACE(1)+'NPADate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
--  WHERE (Case When ISDATE(NPADate)=1 Then Case When Cast(NPADate as date)>Cast(GETDATE() as Date) Then 1 
--             When Cast(NPADate as date)< Cast(DisbursementDate as date) Then 2                          Else 0 END END) in(1,2)

--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'ASSET Class is NPA. Please enter NPA DATE'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'ASSET Class is NPA. Please enter NPA DATE'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPADate' ELSE   ErrorinColumn +','+SPACE(1)+'NPADate' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE  ISNULL(AssetClassatRstrctr,'')  IN('SUB-STANDARD','DOUBTFUL I','DOUBTFUL II','DOUBTFUL III','LOS') AND  ISNULL(NPADate,'')='' 
-----------------------------------------------------------------------------

--------------------------------------------------NPA Quarter --------------------
-- Print 'An7'
----UPDATE RestructureAssets
----	SET  
----        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'NPA Quarter Can not be Blank . Please enter the NPA Quarter and upload again'     
----						ELSE ErrorMessage+','+SPACE(1)+ 'NPA Quarter Can not be Blank. Please enter the NPA Quarter and upload again'      END
----		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Quarter' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Quarter' END      
----		,Srnooferroneousrows=V.SrNo
		  

---- FROM RestructureAssets V  
---- WHERE ISNULL(NPAQuarter,'')='' 


-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'ASSET Class is NPA. Please enter NPA Quarter'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'ASSET Class is NPA. Please enter NPA Quarter'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'NPA Quarter' ELSE   ErrorinColumn +','+SPACE(1)+'NPA Quarter' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE  ISNULL(AssetClassatRstrctr,'')  IN('SUB-STANDARD','DOUBTFUL I','DOUBTFUL II','DOUBTFUL III','LOS') AND  ISNULL(NPAQuarter,'')=''
 ---------------------------------------------------------------------------------------------------------------------
   /*validations on Type of Restructuring*/
  
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Type of Restructuring cannot be blank . Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Type of Restructuring cannot be blank . Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Type of Restructuring' ELSE   ErrorinColumn +','+SPACE(1)+'Type of Restructuring' END   
		,Srnooferroneousrows=V.SrNo
								
   
   FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')=''
 --select * from RestructureAssets where PoolType  in  ('With Risk' , 'With out Risk')
  
 -- UPDATE RestructureAssets
	--SET  
 --       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Banking Relationship.  Please check the values and upload again'     
	--					ELSE ErrorMessage+','+SPACE(1)+'Invalid Banking Relationship.  Please check the values and upload again'     END
	--	,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Banking Relationship' ELSE   ErrorinColumn +','+SPACE(1)+'Banking Relationship' END       
	--	,Srnooferroneousrows=V.SrNo

   
 --  FROM RestructureAssets V  
 --WHERE ISNULL(BankingRelationship,'')<>''
-- AND LEN(BankingRelationship)>20
--Print 'A6'
--  UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Type of Restructuring.  Please check the values 
--		With IRAC OR Prudential Framework_June 07 Circular OR Resolution Framework_Covid OTR OR MSME_Old Circular OR MSME_Covid Circular
--		    OR DCCO OR Natural Calamity OR BIFR OR Other  and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Restructuring.  Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TypeofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'TypeofRestructuring' END     
--		,Srnooferroneousrows=V.SrNo

   
--   FROM RestructureAssets V  
-- WHERE ISNULL(TypeofRestructuring,'')  NOT in  ('IRAC' , 'Prudential Framework_June 07 Circular','Resolution Framework_Covid OTR'
--                                          ,'MSME_Old Circular','MSME_Covid Circular','DCCO','Natural Calamity','BIFR','Other')
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid Type of Restructuring.  Please check the values 
		With IRAC OR DCCO OR Natural Calamity OR  Other and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+'Invalid Type of Restructuring.  Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'TypeofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'TypeofRestructuring' END     
		,Srnooferroneousrows=V.SrNo

   
   FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')  NOT in  ('IRAC Circular' ,'Under DCCO - PUI','Natural Calamity','Other')

------------------------------------------------DateofRestructuring --------------------
Print 'An8'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofRestructuring Can not be Blank . Please enter the DateofRestructuring and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DateofRestructuring Can not be Blank. Please enter the DateofRestructuring and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuring' END      
--		,Srnooferroneousrows=V.SrNo
		  
		  
-- FROM RestructureAssets V  
-- WHERE ISNULL(DateofRestructuring,'')='' 
 Print 'An88'

UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuring' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(DateofRestructuring,'')<>'' AND ISDATE(DateofRestructuring)=0

 /*
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Invocation Date  '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Invocation Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuring' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(DateofRestructuring)=1 Then Case When Cast(DateofRestructuring as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(DateofRestructuring as date)< Cast(InvocationDate as date) Then 2                          Else 0 END END) in(1,2)
			 */
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Date of Restructuring can not be blank. Please check and Upload again  '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Date of Restructuring can not be blank. Please check and Upload again '      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuringf' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE ISNULL(TypeofRestructuring,'')<>'' AND ISNULL(DateofRestructuring,'')=''


---------------------------------------------------------------------------
/*
-----------------------------------------------Restructuring Approving Auth --------------------
Print 'An8'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Restructuring Approving Auth Can not be Blank . Please enter the Restructuring Approving Auth and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Restructuring Approving Auth Can not be Blank. Please enter the DateofRestructuring and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Restructuring Approving Auth' ELSE   ErrorinColumn +','+SPACE(1)+'Restructuring Approving Auth' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')<>'' AND ISNULL(RestructuringApprovingAuth,'')='' 

 
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'For Restructuring Approving Auth column, special characters -  /\ are allowed. Kindly check and try again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'For Restructuring Approving Auth, special characters -  /\ are allowed. Kindly check and try again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Restructuring Approving Auth' ELSE ErrorinColumn +','+SPACE(1)+  'Restructuring Approving Auth' END  
		,Srnooferroneousrows=V.SrNo
 FROM RestructureAssets V  
 WHERE  ISNULL(RestructuringApprovingAuth,'') LIKE'%[!@#$%^&*(),_+=]%' 

 */

 ------------------------------------------------Date of Ist Default on CRILIC --------------------
Print 'An8'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'   END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofIstDefaultonCRILIC' ELSE   ErrorinColumn +','+SPACE(1)+'DateofIstDefaultonCRILIC' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(DateofIstDefaultonCRILIC,'')<>'' AND ISDATE(DateofIstDefaultonCRILIC)=0


 /* 
  UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Invocation Date  '     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Invocation Date'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuring' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
  WHERE (Case When ISDATE(DateofIstDefaultonCRILIC)=1 Then Case When Cast(DateofIstDefaultonCRILIC as date)>Cast(GETDATE() as Date) Then 1 
             When Cast(DateofIstDefaultonCRILIC as date)< Cast(DateofRestructuring as date) Then 2                          Else 0 END END) in(1,2)

*/
------------------------------------------------Reporting Bank --------------------
/*
Print 'An8'
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'ReportingBank can not be blank. Please check and Upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'ReportingBank can not be blank. Please check and Upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ReportingBank' ELSE   ErrorinColumn +','+SPACE(1)+'ReportingBank' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(DateofIstDefaultonCRILIC,'')<>'' AND ISNULL(ReportingBank,'')=''

 */

 /*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Reporting Bank column, special characters -  /\ are allowed. Kindly check and try again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Reporting Bank column, special characters -  /\ are allowed. Kindly check and try again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'ReportingBank' ELSE ErrorinColumn +','+SPACE(1)+  'ReportingBank' END  
		,Srnooferroneousrows=V.SrNo
 FROM RestructureAssets V  
 WHERE  ISNULL(RestructuringApprovingAuth,'') LIKE'%[!@#$%^&*(),_+=]%' 

 */
------------------------------------------------DateofSigningICA --------------------

--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DateofSigningICA Can not be Blank . Please enter the DateofSigningICA and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DateofSigningICA Can not be Blank. Please enter the DateofSigningICA and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSigningICA' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSigningICA' END      
--		,Srnooferroneousrows=V.SrNo
		  

-- FROM RestructureAssets V  
-- WHERE ISNULL(DateofSigningICA,'')='' 

-- Print 'An99'

-- SET DATEFORMAT DMY
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Please enter the date in format ‘dd-mm-yyyy’'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSigningICA' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSigningICA' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE ISNULL(DateofSigningICA,'')<>'' AND ISDATE(DateofSigningICA)=0

   
--  UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid date format.Date should be less than equal to current date and greater than Date of Restructuring  '     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid date format. Date should be less than equal to current date and greater than Date of Restructuring'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofRestructuring' ELSE   ErrorinColumn +','+SPACE(1)+'DateofRestructuring' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
--   WHERE (Case When ISDATE(DateofSigningICA)=1   AND  ISDATE(DateofRestructuring)=1
--  then Case When Cast(DateofSigningICA as date)>Cast(GETDATE() as Date) Then 1 
--             When Cast(DateofSigningICA as date)< Cast(DateofRestructuring as date) Then 2     Else 0 END END) in(1,2)
/*
UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Date of Signing ICA can not be blank. Please check and upload again.'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Date of Signing ICA can not be blank. Please check and upload again.'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DateofSigningICA' ELSE   ErrorinColumn +','+SPACE(1)+'DateofSigningICA' END      
		,Srnooferroneousrows=V.SrNo
	  
	   
 FROM RestructureAssets V  
 WHERE ISNULL(CovidOTRCategory,'') IN ('Others') AND ISNULL(BankingRelationship,'') IN('Consortium', 'Consortium-WC', 'Consortium-TL', 'WC-MBA', 'TL-MBA')
 AND ISNULL(DateofSigningICA,'')=''
 */
---------------------------------------------------------------------------
Print 'An10'

------------------------------------------------O/S as on date of Rstrctr --------------------

UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'amountRstrctr Can only be Numeric . Please enter the amountRstrctr and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'amountRstrctr Can only be Numeric . Please enter the amountRstrctr and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'amountRstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'amountRstrctr' END      
		,Srnooferroneousrows=V.SrNo
		  

 FROM RestructureAssets V  
  WHERE (ISNUMERIC(amountRstrctr)=0 AND ISNULL(amountRstrctr,'')<>'') OR 
 ISNUMERIC(amountRstrctr) LIKE '%^[0-9]%'
/*
 Print 'An99'

UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'O/S as on date of Rstrctr Can not be Blank . Please enter the O/S as on date of Rstrctr and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'O/S as on date of Rstrctr Can not be Blank . Please enter the O/S as on date of Rstrctr and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'O/S as on date of Rstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'O/S as on date of Rstrctr' END      
		,Srnooferroneousrows=V.SrNo
	  

 FROM RestructureAssets V  
 WHERE ISNULL(OSasonDateofRstrctr,'')='' AND ISNULL(TypeofRestructuring,'')<>''
 */
-- ------------------------------------------------POS as on date of Rstrctr--------------------

--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'POS as on date of Rstrctr Can only be Numeric . Please enter the POS as on date of Rstrctr and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'POS as on date of Rstrctr Can only be Numeric . Please enter the POS as on date of Rstrctr and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POS as on date of Rstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'POS as on date of Rstrctr' END      
--		,Srnooferroneousrows=V.SrNo
		  

-- FROM RestructureAssets V  
--  WHERE (ISNUMERIC(POSasonDateofRstrctr)=0 AND ISNULL(POSasonDateofRstrctr,'')<>'') OR 
-- ISNUMERIC(POSasonDateofRstrctr) LIKE '%^[0-9]%'
----/*
-- Print 'An99'
--UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'POS as on date of Rstrctr Can not be Blank . Please enter the POS as on date of Rstrctr and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'POS as on date of Rstrctr Can not be Blank . Please enter the POS as on date of Rstrctr and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'POS as on date of Rstrctr' ELSE   ErrorinColumn +','+SPACE(1)+'POS as on date of Rstrctr' END      
--		,Srnooferroneousrows=V.SrNo
	  

-- FROM RestructureAssets V  
-- WHERE ISNULL(OSasonDateofRstrctr,'')='' AND ISNULL(TypeofRestructuring,'')<>''
-- */
-- /*

 ------------------------------------------------Investment Grade--------------------
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'No value expected when Banking Relation is other than Consortium, Consortium-WC, Consortium-TL, WC-MBC, TL-MBA'    
						ELSE ErrorMessage+','+SPACE(1)+ 'No value expected when Banking Relation is other than Consortium, Consortium-WC, Consortium-TL, WC-MBC, TL-MBA'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Investment Grade' ELSE   ErrorinColumn +','+SPACE(1)+'Investment Grade' END      
		,Srnooferroneousrows=V.SrNo
	  

FROM RestructureAssets V  
  WHERE (ISNULL(BankingRelationship,'') NOT IN('Consortium', 'Consortium-WC', 'Consortium-TL', 'WC-MBA', 'TL-MBA') AND ISNULL(InvestmentGrade,'')<>'')


   UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'This column is mandatory when Banking Relation is either Consortium, Consortium-WC, Consortium-TL, WC-MBC, TL-MBA. Kindly enter Y or N and upload again'    
						ELSE ErrorMessage+','+SPACE(1)+ 'This column is mandatory when Banking Relation is either Consortium, Consortium-WC, Consortium-TL, WC-MBC, TL-MBA. Kindly enter Y or N and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'Investment Grade' ELSE   ErrorinColumn +','+SPACE(1)+'Investment Grade' END      
		,Srnooferroneousrows=V.SrNo
	  
	  
FROM RestructureAssets V  
  WHERE (ISNULL(BankingRelationship,'')  IN('Consortium', 'Consortium-WC', 'Consortium-TL', 'WC-MBA', 'TL-MBA') AND ISNULL(InvestmentGrade,'')NOT IN('Yes','No'))


--  */

-------------------------------------------------CreditProvisionRs
/*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'CreditProvisionRs cannot be blank. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'CreditProvisionRs cannot be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CreditProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'CreditProvisionRs' END  
		,Srnooferroneousrows=V.SRNO
--								----STUFF((SELECT ','+SRNO 
--								----FROM RestructureAssets A
--								----WHERE A.SrNo IN(SELECT V.SrNo FROM RestructureAssets V
--								----WHERE ISNULL(InterestReversalAmount,'')='')
--								----FOR XML PATH ('')
--								----),1,1,'')   

 FROM RestructureAssets V  
 WHERE ISNULL(CreditProvisionRs,'')=''

-- */

-- Print 'An101'
-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid CreditProvisionRs. Please check the values and upload again'     
--					ELSE ErrorMessage+','+SPACE(1)+'Invalid CreditProvisionRs. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CreditProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'CreditProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO


-- FROM RestructureAssets V  
-- WHERE (ISNUMERIC(CreditProvisionRs)=0 AND ISNULL(CreditProvisionRs,'')<>'') OR 
-- ISNUMERIC(CreditProvisionRs) LIKE '%^[0-9]%'
--Print 'An11' 

-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid CreditProvisionRs. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid CreditProvisionRs. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CreditProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'CreditProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
----								----STUFF((SELECT ','+SRNO 
----								----FROM RestructureAssets A
----								----WHERE A.SrNo IN(SELECT V.SrNo FROM RestructureAssets V
----								---- WHERE ISNULL(InterestReversalAmount,'') LIKE'%[,!@#$%^&*()_-+=/]%'
----								----)
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM RestructureAssets V  
-- WHERE ISNULL(CreditProvisionRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'

-- Print 'An111'
--  UPDATE RestructureAssets
--	SET  
--        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid CreditProvisionRs. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid CreditProvisionRs. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CreditProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'CreditProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
----								----STUFF((SELECT ','+SRNO 
----								----FROM RestructureAssets A
----								----WHERE A.SrNo IN(SELECT SRNO FROM RestructureAssets WHERE ISNULL(InterestReversalAmount,'')<>''
----								---- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
----								---- )
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM RestructureAssets V  
-- WHERE ISNULL(CreditProvisionRs,'')<>''
-- --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
-- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(CreditProvisionRs,0)) <0
----/*
-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  ' CreditProvisionRs can not be blank. Please check the values and upload again'     
--					ELSE ErrorMessage+','+SPACE(1)+'CreditProvisionRs can not be blank. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CreditProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'CreditProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO


-- FROM RestructureAssets V  
-- WHERE ISNULL(TypeofRestructuring,'')<>'' AND ISNULL(CreditProvisionRs,'')=''
-- */
-- -----------------------------------------------------------------
-- Print 'An12'
 -----------------------------------------------DFVProvisionRs
-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'DFVProvisionRs cannot be blank. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'DFVProvisionRs cannot be blank. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'DFVProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
----								----STUFF((SELECT ','+SRNO 
----								----FROM RestructureAssets A
----								----WHERE A.SrNo IN(SELECT V.SrNo FROM RestructureAssets V
----								----WHERE ISNULL(InterestReversalAmount,'')='')
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM RestructureAssets V  
-- WHERE ISNULL(DFVProvisionRs,'')=''

 Print 'An121'

 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DFVProvisionRs. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'Invalid DFVProvisionRs. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'DFVProvisionRs' END  
		,Srnooferroneousrows=V.SRNO
 

 FROM RestructureAssets V  
 WHERE (ISNUMERIC(DFVProvisionRs)=0 AND ISNULL(DFVProvisionRs,'')<>'') OR 
 ISNUMERIC(DFVProvisionRs) LIKE '%^[0-9]%'
Print 'An122' 

 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid DFVProvisionRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DFVProvisionRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'DFVProvisionRs' END  
		,Srnooferroneousrows=V.SRNO
  

 FROM RestructureAssets V  
 WHERE ISNULL(DFVProvisionRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'
 Print 'An123'
  UPDATE RestructureAssets
	SET  
        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid DFVProvisionRs. Please check the values and upload again'     
						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid DFVProvisionRs. Please check the values and upload again'     END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'DFVProvisionRs' END  
		,Srnooferroneousrows=V.SRNO
 

 FROM RestructureAssets V  
 WHERE ISNULL(DFVProvisionRs,'')<>''
 --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
 AND TRY_CONVERT(DECIMAL(25,2),ISNULL(DFVProvisionRs,0)) <0
/*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  ' DFVProvisionRs can not be blank. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'DFVProvisionRs can not be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'DFVProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'DFVProvisionRs' END  
		,Srnooferroneousrows=V.SRNO


 FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')<>'' AND ISNULL(DFVProvisionRs,'')=''

 */

 -----------------------------------------------------------------
 Print 'An13'
 -----------------------------------------------MTMProvisionRs
-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'MTMProvisionRs cannot be blank. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'MTMProvisionRs cannot be blank. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MTMProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'MTMProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
----								----STUFF((SELECT ','+SRNO 
----								----FROM RestructureAssets A
----								----WHERE A.SrNo IN(SELECT V.SrNo FROM RestructureAssets V
----								----WHERE ISNULL(InterestReversalAmount,'')='')
----								----FOR XML PATH ('')
----								----),1,1,'')   

-- FROM RestructureAssets V  
-- WHERE ISNULL(MTMProvisionRs,'')=''
--  Print 'An131'
-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid MTMProvisionRs. Please check the values and upload again'     
--					ELSE ErrorMessage+','+SPACE(1)+'Invalid MTMProvisionRs. Please check the values and upload again'      END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MTMProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'MTMProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
 

-- FROM RestructureAssets V  
-- WHERE (ISNUMERIC(MTMProvisionRs)=0 AND ISNULL(MTMProvisionRs,'')<>'') OR 
-- ISNUMERIC(MTMProvisionRs) LIKE '%^[0-9]%'
--Print 'An14'

-- UPDATE RestructureAssets
--	SET  
--        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  'Invalid MTMProvisionRs. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid MTMProvisionRs. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MTMProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'MTMProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
 

-- FROM RestructureAssets V  
-- WHERE ISNULL(MTMProvisionRs,'') LIKE'%[,!@#$%^&*()_-+=/]%'
--  Print 'An141'
--  UPDATE RestructureAssets
--	SET  
--        ErrorMessage= CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'Invalid MTMProvisionRs. Please check the values and upload again'     
--						ELSE ErrorMessage+','+SPACE(1)+ 'Invalid MTMProvisionRs. Please check the values and upload again'     END
--		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MTMProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'MTMProvisionRs' END  
--		,Srnooferroneousrows=V.SRNO
 

-- FROM RestructureAssets V  
-- WHERE ISNULL(MTMProvisionRs,'')<>''
-- --AND TRY_CONVERT(DECIMAL(25,2),ISNULL(InterestReversalAmount,0)) <0
-- AND TRY_CONVERT(DECIMAL(25,2),ISNULL(MTMProvisionRs,0)) <0

 /*
 UPDATE RestructureAssets
	SET  
        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN  ' MTMProvisionRs can not be blank. Please check the values and upload again'     
					ELSE ErrorMessage+','+SPACE(1)+'MTMProvisionRs can not be blank. Please check the values and upload again'      END
		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'MTMProvisionRs' ELSE ErrorinColumn +','+SPACE(1)+  'MTMProvisionRs' END  
		,Srnooferroneousrows=V.SRNO


 FROM RestructureAssets V  
 WHERE ISNULL(TypeofRestructuring,'')<>'' AND ISNULL(MTMProvisionRs,'')=''

 */
 ---------------------------------



 Print '123'
 goto valid

  END
	
   ErrorData:  
   print 'no'  

		SELECT *,'Data'TableName
		FROM dbo.MasterUploadData WHERE FileNames=@filepath 
		return

   valid:
		IF NOT EXISTS(Select 1 from  RetsructuredAssetsUpload_stg WHERE filname=@FilePathUpload)
		BEGIN
		PRINT 'NO ERRORS'
			
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Flag) 
			SELECT '' SRNO , '' ColumnName,'' ErrorData,'' ErrorType,@filepath,'SUCCESS' 
			
		END
		ELSE
		BEGIN
			PRINT 'VALIDATION ERRORS'
			print @filepath
			Insert into dbo.MasterUploadData
			(SR_No,ColumnName,ErrorData,ErrorType,FileNames,Srnooferroneousrows,Flag) 
			SELECT SrNo,ErrorinColumn,ErrorMessage,ErrorinColumn,@filepath,Srnooferroneousrows,'SUCCESS' 
			FROM RestructureAssets 


			
		--	----SELECT * FROM RestructureAssets 

		--	--ORDER BY ErrorMessage,RestructureAssets.ErrorinColumn DESC
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

		 IF EXISTS(SELECT 1 FROM RetsructuredAssetsUpload_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM RetsructuredAssetsUpload_stg
		 WHERE filname=@FilePathUpload

		 PRINT 1

		 PRINT 'ROWS DELETED FROM DBO.RetsructuredAssetsUpload_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
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

	----SELECT * FROM RestructureAssets

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

	IF EXISTS(SELECT 1 FROM RetsructuredAssetsUpload_stg WHERE filname=@FilePathUpload)
		 BEGIN
		 DELETE FROM RetsructuredAssetsUpload_stg
		 WHERE filname=@FilePathUpload

		 PRINT 'ROWS DELETED FROM DBO.RetsructuredAssetsUpload_stg'+CAST(@@ROWCOUNT AS VARCHAR(100))
		 END

END CATCH

END

GO
