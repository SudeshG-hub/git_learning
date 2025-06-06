SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SaletoARCACFlaggingDetailInUp]
    
  @AccountFlagAlt_Key INT    = 0   
  ,@SourceAlt_Key  INT    = 0   
  ,@SourceName  varchar(30)   =null  
  ,@AccountID  varchar(30)   =null  
  ,@CustomerID  varchar(30)   =null  
  ,@CustomerName  varchar(30)   =null  
  ,@FlagAlt_Key  varchar(30)   =null  
  ,@AccountBalance  Decimal(18,2)  =NULL  
  ,@POS     Decimal(18,2)  =NULL  
  ,@InterestReceivable Decimal(18,2)  =NULL  
  ,@ExposureAmount Decimal(18,2)  =NULL  
  ,@ChangeFields  varchar(200) =null  
  ,@ErrorHandle    int    = 0    
  ,@ExEntityKey  int    = 0    
  ,@SaletoARCACFlaggingDetail_changefields varchar(100)=null
  ,@DtofsaletoARC  Varchar(20)=null
  ,@DateofApproval Varchar(20)=null
  ---------D2k System Common Columns  --  
  ,@Remark     VARCHAR(500) = ''  
  ,@MenuID     SMALLINT  = 0  
  ,@OperationFlag    TINYINT   = 0  
  ,@AuthMode     CHAR(1)   = 'N'  
  ,@IsMOC      CHAR(1)   = 'N'  
  ,@EffectiveFromTimeKey  INT  = 0  
  ,@EffectiveToTimeKey  INT  = 0  
  ,@TimeKey     INT  = 0  
  ,@CrModApBy     VARCHAR(20)  =''  
  ,@D2Ktimestamp    INT    =0 OUTPUT   
  ,@Result     int    =0 OUTPUT  
   
AS  
BEGIN  
 SET NOCOUNT ON;  
  PRINT 1  

  DECLARE @Parameter varchar(max) = (select 'AccountID|' + ISNULL(@AccountID,' ') + '}'+ 'Flag|' + isnull(@FlagAlt_Key,' '))
	--DECLARE		@Result					INT				=0 
	exec SecurityCheckDataValidation 14609 ,@Parameter,@Result OUTPUT
				
	IF @Result = -1
	return -1

  DECLARE   
  
      @AuthorisationStatus  VARCHAR(5)   = NULL   
      ,@CreatedBy     VARCHAR(20)  = NULL  
      ,@DateCreated    SMALLDATETIME = NULL  
      ,@ModifiedBy    VARCHAR(20)  = NULL  
      ,@DateModified    SMALLDATETIME = NULL  
      ,@ApprovedBy    VARCHAR(20)  = NULL  
      ,@DateApproved    SMALLDATETIME = NULL  
  
  ----Added on 26-03-2021

  SET DATEFORMAT DMY


			SET @Timekey=(select CAST(B.timekey as int)from SysDataMatrix A
Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey
 where A.CurrentStatus='C')

	PRINT @TIMEKEY

	SET @EffectiveFromTimeKey=@TimeKey
	SET @EffectiveToTimeKey=49999


IF @OperationFlag=1  --- add  
 BEGIN  
 PRINT 1  
  -----CHECK DUPLICATE BILL NO AT BRANCH LEVEL  
  IF EXISTS(                      
     SELECT  1 FROM SaletoARCACFlaggingDetail WHERE AccountId=@AccountID AND ISNULL(AuthorisationStatus,'A')='A'   
     UNION  
     SELECT  1 FROM SaletoARCACFlaggingDetail_Mod  WHERE (EffectiveFromTimeKey <=@TimeKey AND EffectiveToTimeKey >=@TimeKey)  
               AND AccountId=@AccountID  
               AND  AuthorisationStatus in('NP','MP','DP','A','RM')   
    )   
    BEGIN  
       PRINT 2  
     SET @Result=-4  
     RETURN @Result -- CUSTOMERID ALEADY EXISTS  
    END  
 END  
  
 BEGIN TRY  
 --BEGIN TRANSACTION   
 -----  
   
 PRINT 3   
  --np- new,  mp - modified, dp - delete, fm - further modifief, A- AUTHORISED , 'RM' - REMARK   
 IF @OperationFlag =1 AND @AuthMode ='Y' -- ADD  
  BEGIN  
         PRINT 'Add'  
      SET @CreatedBy = @CrModApBy   
      SET @DateCreated = GETDATE()  
      SET @AuthorisationStatus='NP'  
      GOTO SaletoARCACFlaggingDetail_Insert  
    SaletoARCACFlaggingDetail_Insert_Add:  
  END  
  
  ELSE IF(@OperationFlag = 2 OR @OperationFlag = 3) AND @AuthMode = 'Y' --EDIT AND DELETE  
   BEGIN  
    Print 4  
    SET @CreatedBy= @CrModApBy  
    SET @DateCreated = GETDATE()  
    Set @Modifiedby=@CrModApBy     
    Set @DateModified =GETDATE()   
  
     PRINT 5  
  
     IF @OperationFlag = 2  
      BEGIN  
       PRINT 'Edit'  
       SET @AuthorisationStatus ='MP'  
         
      END  
      ELSE  
      BEGIN  
       PRINT 'DELETE'  
       SET @AuthorisationStatus ='DP'  
         
      END  
      ---FIND CREATED BY FROM MAIN TABLE  
     SELECT  @CreatedBy  = CreatedBy  
       ,@DateCreated = DateCreated   
     FROM SaletoARCACFlaggingDetail  
     WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
       AND AccountID =@AccountID  
  
     ---FIND CREATED BY FROM MAIN TABLE IN CASE OF DATA IS NOT AVAILABLE IN MAIN TABLE  
    IF ISNULL(@CreatedBy,'')=''  
    BEGIN  
     PRINT 'NOT AVAILABLE IN MAIN'  
     SELECT  @CreatedBy  = CreatedBy  
       ,@DateCreated = DateCreated   
     FROM SaletoARCACFlaggingDetail_Mod 
     WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
       AND AccountID =@AccountID         
       AND AuthorisationStatus IN('NP','MP','A','RM')  
    END  
    ELSE ---IF DATA IS AVAILABLE IN MAIN TABLE  
     BEGIN  
            Print 'AVAILABLE IN MAIN'  
      ----UPDATE FLAG IN MAIN TABLES AS MP  
      UPDATE SaletoARCACFlaggingDetail  
       SET AuthorisationStatus=@AuthorisationStatus
      WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
        AND AccountID =@AccountID  
  
     END  
     --UPDATE NP,MP  STATUS   
     IF @OperationFlag=2  
     BEGIN   
  
      UPDATE SaletoARCACFlaggingDetail_Mod  
       SET AuthorisationStatus='FM'  
       ,ModifiedBy=@Modifiedby  
       ,DateModified=@DateModified  
      WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
        AND AccountID =@AccountID  
        AND AuthorisationStatus IN('NP','MP','RM')  
     END  
  
     --GOTO AdvFacBillDetail_Insert  
     --AdvFacBillDetail_Insert_Edit_Delete:  
     GOTO SaletoARCACFlaggingDetail_Insert  
     SaletoARCACFlaggingDetail_Insert_Edit_Delete:  
    END  
  
   ELSE IF @OperationFlag =3 AND @AuthMode ='N'  
  BEGIN  
  -- DELETE WITHOUT MAKER CHECKER  
             
      SET @Modifiedby   = @CrModApBy   
      SET @DateModified = GETDATE()   
  
      UPDATE  SaletoARCACFlaggingDetail SET   
         ModifiedBy =@Modifiedby   
         ,DateModified =@DateModified   
         ,EffectiveToTimeKey =@EffectiveFromTimeKey-1  
        WHERE (EffectiveFromTimeKey=EffectiveFromTimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID  
      
  
  END  
  ELSE IF @OperationFlag=17 AND @AuthMode ='Y'   
  BEGIN  
    SET @ApprovedBy    = @CrModApBy   
    SET @DateApproved  = GETDATE()  
  
    UPDATE SaletoARCACFlaggingDetail_Mod  
     SET AuthorisationStatus='R'  
     ,ApprovedByFirstLevel  =@ApprovedBy  
     ,DateApprovedFirstLevel=@DateApproved  
     ,EffectiveToTimeKey =@EffectiveFromTimeKey-1  
    WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
      AND AccountID =@AccountID  
      AND AuthorisationStatus in('NP','MP','DP','RM')   
  
    IF EXISTS(SELECT 1 FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@Timekey) AND AccountID=@AccountID)  
    BEGIN  
     UPDATE SaletoARCACFlaggingDetail  
      SET AuthorisationStatus='A'  
     WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
       AND AccountID =@AccountID  
       AND AuthorisationStatus IN('MP','DP','RM')    
    END  
  END  
  
  
-----------------------Two level Auth. changes----------------- 

ELSE IF @OperationFlag=21 AND @AuthMode ='Y'   
  BEGIN  
    SET @ApprovedBy    = @CrModApBy   
    SET @DateApproved  = GETDATE()  
  
    UPDATE SaletoARCACFlaggingDetail_Mod  
     SET AuthorisationStatus='R'  
     ,ApprovedBy  =@ApprovedBy  
     ,DateApproved=@DateApproved  
     ,EffectiveToTimeKey =@EffectiveFromTimeKey-1  
    WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
      AND AccountID =@AccountID  
      AND AuthorisationStatus in('NP','MP','DP','RM','1A')   
  
    IF EXISTS(SELECT 1 FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@Timekey) AND AccountID=@AccountID)  
    BEGIN  
     UPDATE SaletoARCACFlaggingDetail  
      SET AuthorisationStatus='A'  
     WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
       AND AccountID =@AccountID  
       AND AuthorisationStatus IN('MP','DP','RM')    
    END  
  END    
---------------------------------------------------------------------  
  ELSE IF @OperationFlag=18  
 BEGIN  
  PRINT 18  
  SET @ApprovedBy=@CrModApBy  
  SET @DateApproved=GETDATE()  
  UPDATE SaletoARCACFlaggingDetail_Mod  
  SET AuthorisationStatus='RM'  
  WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
  AND AuthorisationStatus IN('NP','MP','DP','RM')  
  AND AccountId=@AccountID   
  
 END  

 ELSE IF @OperationFlag=16

		BEGIN

		SET @ApprovedBy	   = @CrModApBy 
		SET @DateApproved  = GETDATE()

		UPDATE SaletoARCACFlaggingDetail_Mod
						SET AuthorisationStatus ='1A'
							,ApprovedByFirstLevel=@ApprovedBy
							,DateApprovedFirstLevel=@DateApproved
							WHERE AccountId=@AccountID
							AND AuthorisationStatus in('NP','MP','DP','RM')

		END
  
 ELSE IF @OperationFlag=20 OR @AuthMode='N'  
  BEGIN  
     
   Print 'Authorise'  
 -------set parameter for  maker checker disabled  
   IF @AuthMode='N'  
   BEGIN  
    IF @OperationFlag=1  
     BEGIN  
      SET @CreatedBy = @CrModApBy  
      SET @DateCreated =GETDATE()  
     END  
    ELSE  
     BEGIN  
      SET @ModifiedBy  = @CrModApBy  
      SET @DateModified =GETDATE()  
      SELECT @CreatedBy=CreatedBy,@DateCreated=DATECreated  
      FROM  SaletoARCACFlaggingDetail  
      WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey >=@TimeKey )  
       AND AccountID=@AccountID   
       
     SET @ApprovedBy = @CrModApBy     
     SET @DateApproved=GETDATE()  
     END  
   END   
   ---set parameters and UPDATE mod table in case maker checker enabled  
   IF @AuthMode='Y'  
    BEGIN  
        Print 'B'  
     DECLARE @DelStatus CHAR(2)=''  
     DECLARE @CurrRecordFromTimeKey smallint=0  
  
     Print 'C'  
     SELECT @ExEntityKey= MAX(Entity_Key) FROM SaletoARCACFlaggingDetail_Mod  
      WHERE (EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey >=@Timekey)   
       AND AccountID=@AccountID  
       AND AuthorisationStatus IN('NP','MP','DP','RM','1A')   
  
     SELECT @DelStatus=AuthorisationStatus,@CreatedBy=CreatedBy,@DateCreated=DATECreated  
      ,@ModifiedBy=ModifiedBy, @DateModified=DateModified  
      FROM SaletoARCACFlaggingDetail_Mod  
      WHERE Entity_Key=@ExEntityKey  
       
     SET @ApprovedBy = @CrModApBy     
     SET @DateApproved=GETDATE()  
      
       
     DECLARE @CurEntityKey INT=0  
  
     SELECT @ExEntityKey= MIN(Entity_Key) FROM SaletoARCACFlaggingDetail_Mod
      WHERE (EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey >=@Timekey)   
       AND AccountID=@AccountID  
       AND AuthorisationStatus IN('NP','MP','DP','RM','1A')   
      
     SELECT @CurrRecordFromTimeKey=EffectiveFromTimeKey   
       FROM SaletoARCACFlaggingDetail_Mod  
       WHERE Entity_Key=@ExEntityKey  
  
     UPDATE SaletoARCACFlaggingDetail_Mod  
      SET  EffectiveToTimeKey =@CurrRecordFromTimeKey-1  
      WHERE (EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey >=@Timekey)  
      AND AccountID=@AccountID  
      AND AuthorisationStatus='A'   
  
  -------DELETE RECORD AUTHORISE  
     IF @DelStatus='DP'   
     BEGIN   
      UPDATE SaletoARCACFlaggingDetail_Mod
      SET AuthorisationStatus ='A'  
       ,ApprovedBy=@ApprovedBy  
       ,DateApproved=@DateApproved  
       ,EffectiveToTimeKey =@EffectiveFromTimeKey -1  
      WHERE AccountID=@AccountID  
       AND AuthorisationStatus in('NP','MP','DP','RM','1A')  
  
     IF EXISTS(SELECT 1 FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)   
          AND AccountID=@AccountID)  
      BEGIN  
        UPDATE SaletoARCACFlaggingDetail  
         SET AuthorisationStatus ='A'  
          ,ModifiedBy=@ModifiedBy  
          ,DateModified=@DateModified  
          ,ApprovedBy=@ApprovedBy  
          ,DateApproved=@DateApproved  
          ,EffectiveToTimeKey =@EffectiveFromTimeKey-1  
         WHERE (EffectiveFromTimeKey<=@Timekey AND EffectiveToTimeKey >=@Timekey)  
           AND AccountID=@AccountID  
      END  
     END -- END OF DELETE BLOCK  
  
     ELSE  -- OTHER THAN DELETE STATUS  
     BEGIN  
       UPDATE SaletoARCACFlaggingDetail_Mod  
        SET AuthorisationStatus ='A'  
         ,ApprovedBy=@ApprovedBy  
         ,DateApproved=@DateApproved  
        WHERE AccountID=@AccountID      
         AND AuthorisationStatus in('NP','MP','RM','1A')  
     END    
    END  
  
    IF @DelStatus <>'DP' OR @AuthMode ='N'  
    BEGIN  
      DECLARE @IsAvailable CHAR(1)='N'  
      ,@IsSCD2 CHAR(1)='N'  
  
      IF EXISTS(SELECT 1 FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)  
          AND AccountID=@AccountID)  
       BEGIN  
        SET @IsAvailable='Y'  
        SET @AuthorisationStatus='A'  
  
        IF EXISTS(SELECT 1 FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)   
            AND EffectiveFromTimeKey=@TimeKey AND AccountID=@AccountID)  
         BEGIN  
           PRINT 'BBBB'  
          UPDATE SaletoARCACFlaggingDetail SET  
                           
             AccountFlagAlt_Key =@AccountFlagAlt_Key  
             ,SourceAlt_Key  =@SourceAlt_Key   
             ,SourceName  =@SourceName  
             ,AccountID   =@AccountID   
             ,CustomerID  =@CustomerID    
             ,CustomerName  =@CustomerName    
             ,FlagAlt_Key  =@FlagAlt_Key    
             ,AccountBalance =@AccountBalance   
             ,POS    =@POS      
             ,InterestReceivable=@InterestReceivable
			 ,ExposureAmount=@ExposureAmount
            ,ModifiedBy=@ModifiedBy  
            ,DateModified=@DateModified  
            ,ApprovedBy     = CASE WHEN @AuthMode ='Y' THEN @ApprovedBy ELSE NULL END  
            ,DateApproved    = CASE WHEN @AuthMode ='Y' THEN @DateApproved ELSE NULL END  
            ,AuthorisationStatus  = CASE WHEN @AuthMode ='Y' THEN  'A' ELSE NULL END 
			,Remark=@Remark 
  
             WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey)   
            AND EffectiveFromTimeKey=@EffectiveFromTimeKey AND AccountID=@AccountID  
  
  
  
          END   
  
         ELSE  
          BEGIN  
           SET @IsSCD2='Y'  
          END  
        END  
              IF @IsAvailable='N' OR @IsSCD2='Y'  
         BEGIN  
          INSERT INTO SaletoARCACFlaggingDetail  
          (    --Entity_Key  
              AccountFlagAlt_Key  
             ,SourceAlt_Key  
             ,SourceName  
             ,AccountID  
             ,CustomerID  
             ,CustomerName  
             ,FlagAlt_Key  
             ,AccountBalance  
             ,POS  
             ,InterestReceivable
			 ,ExposureAmount
              ,AuthorisationStatus  
			  ,Remark
              ,EffectiveFromTimeKey  
              ,EffectiveToTimeKey  
              ,CreatedBy  
              ,DateCreated  
              ,ModifiedBy  
              ,DateModified  
              ,ApprovedBy  
              ,DateApproved  
             -- ,D2Ktimestamp  
			 ,DtofsaletoARC
			 ,DateofApproval
            )  
  
         VALUES     
           (   @AccountFlagAlt_Key  
             ,@SourceAlt_Key  
             ,@SourceName  
             ,@AccountID  
             ,@CustomerID  
             ,@CustomerName  
             ,@FlagAlt_Key  
             ,@AccountBalance  
             ,@POS  
             ,@InterestReceivable
			 ,@ExposureAmount
              --,trim(@AuthorisationStatus)
			  --,@AuthorisationStatus
			  ,CASE WHEN @AuthMode ='Y' THEN  'A' ELSE NULL END 
			  ,@Remark
              ,@EffectiveFromTimeKey  
              ,@EffectiveToTimeKey  
              ,@CreatedBy  
              ,@DateCreated  
              ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @ModifiedBy  ELSE NULL END  
              ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @DateModified  ELSE NULL END  
              ,CASE WHEN @AUTHMODE= 'Y' THEN    @ApprovedBy ELSE NULL END  
              ,CASE WHEN @AUTHMODE= 'Y' THEN    @DateApproved  ELSE NULL END  
             -- ,@D2Ktimestamp 
			 ,Case When ISNULL(@DtofsaletoARC,'')='' Then NULL Else Convert(Date,@DtofsaletoARC,105) End
			,Case When ISNULL(@DateofApproval,'')='' Then NULL Else Convert(Date,@DateofApproval,105) End 
              )  
  
  
  
  
  IF @FlagAlt_Key='Y'
        BEGIN  
          INSERT INTO SaletoARCFinalACFlagging  
          (    --Entity_Key  
              --AccountFlagAlt_Key  
             SourceSystem
			  ,CustomerID
			  ,CustomerName
			  ,AccountID
			  ,POS
			  ,InterestReceivable
			  ,ExposureAmount
			  ,SourceAlt_Key
			  ,FlagAlt_Key
			  ,AccountBalance
              ,AuthorisationStatus  
			  ,Remark
              ,EffectiveFromTimeKey  
              ,EffectiveToTimeKey  
              ,CreatedBy  
              ,DateCreated  
              ,ModifyBy  
              ,DateModified  
              ,ApprovedBy  
              ,DateApproved  
             -- ,D2Ktimestamp
			 ,DtofsaletoARC
			 ,DateofApproval  
            )  
  
         VALUES     
           (  -- @AccountFlagAlt_Key  
             @SourceName
			  ,@CustomerID
			  ,@CustomerName
			  ,@AccountID
			  ,@POS
			  ,@InterestReceivable
			  ,@ExposureAmount
			  ,@SourceAlt_Key
			  ,@FlagAlt_Key
			  ,@AccountBalance
			  --,trim(@AuthorisationStatus)
			  ,@AuthorisationStatus
			  ,@Remark
              ,@EffectiveFromTimeKey  
              ,@EffectiveToTimeKey  
              ,@CreatedBy  
              ,@DateCreated  
              ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @ModifiedBy  ELSE NULL END  
              ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @DateModified  ELSE NULL END  
              ,CASE WHEN @AUTHMODE= 'Y' THEN    @ApprovedBy ELSE NULL END  
              ,CASE WHEN @AUTHMODE= 'Y' THEN    @DateApproved  ELSE NULL END  
             -- ,@D2Ktimestamp
			 ,Case When ISNULL(@DtofsaletoARC,'')='' Then NULL Else Convert(Date,@DtofsaletoARC,105) End
			,Case When ISNULL(@DateofApproval,'')='' Then NULL Else Convert(Date,@DateofApproval,105) End  
              )  
		  /*Adding Flag ----------Pranay 21-03-2021*/
		  UPDATE A
			SET  
				A.SplFlag=CASE WHEN ISNULL(A.SplFlag,'')='' THEN 'SaleArc'     
								ELSE A.SplFlag+','+'SaleArc'     END
		   
		   FROM DBO.AdvAcOtherDetail A
		   Where A.EffectiveToTimeKey=49999 and A.RefSystemAcId=@AccountID
   

          END  
		  --ELSE
		  IF @FlagAlt_Key='N'

		  BEGIN
		   UPDATE SaletoARCFinalACFlagging SET  
          EffectiveToTimeKey=@EffectiveFromTimeKey-1  
          ,AuthorisationStatus =CASE WHEN @AUTHMODE='Y' THEN  'A' ELSE NULL END 
		  ,FlagAlt_Key=@FlagAlt_Key 
		  WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID  
         --WHERE (EffectiveFromTimeKey=EffectiveFromTimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID  
         --  AND EffectiveFromTimekey<@EffectiveFromTimeKey 

		 UPDATE SaletoARCACFlaggingDetail SET  
          EffectiveToTimeKey=@EffectiveFromTimeKey-1  
          --,AuthorisationStatus =CASE WHEN @AUTHMODE='Y' THEN  'A' ELSE NULL END  
		  WHERE (EffectiveFromTimeKey<=@TimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID 

		   ------------------REMOVE FLAG--------



				IF OBJECT_ID('TempDB..#Temp') IS NOT NULL
				DROP TABLE #Temp

				Select AccountentityID,SplFlag into #Temp from Curdat.AdvAcOtherDetail 
				where EffectiveToTimeKey=49999 AND RefSystemAcId=@AccountID AND splflag like '%SaleArc%'


				--Select * from #Temp


				IF OBJECT_ID('TEMPDB..#SplitValue')  IS NOT NULL
				DROP TABLE #SplitValue        
				SELECT AccountentityID,Split.a.value('.', 'VARCHAR(8000)') AS Businesscolvalues1  into #SplitValue
											FROM  (SELECT 
															CAST ('<M>' + REPLACE(SplFlag, ',', '</M><M>') + '</M>' AS XML) AS Businesscolvalues1,
															AccountentityID
															from #Temp 
													) AS A CROSS APPLY Businesscolvalues1.nodes ('/M') AS Split(a)
						


				 --Select * from #SplitValue 

				 DELETE FROM #SplitValue WHERE Businesscolvalues1='SaleArc'




				 IF OBJECT_ID('TEMPDB..#NEWTRANCHE')  IS NOT NULL
					DROP TABLE #NEWTRANCHE

					SELECT * INTO #NEWTRANCHE FROM(
					SELECT 
						 SS.AccountentityID,
						STUFF((SELECT ',' + US.BUSINESSCOLVALUES1 
							FROM #SPLITVALUE US
							WHERE US.AccountentityID = SS.AccountentityID
							FOR XML PATH('')), 1, 1, '') [REPORTIDSLIST]
						FROM #TEMP SS 
						GROUP BY SS.AccountentityID
						)B
						ORDER BY 1

						--Select * from #NEWTRANCHE

					--SELECT * 
					UPDATE A SET A.SplFlag=B.REPORTIDSLIST
					FROM DBO.AdvAcOtherDetail A
					INNER JOIN #NEWTRANCHE B ON A.AccountentityID=B.AccountentityID
					WHERE  A.EFFECTIVEFROMTIMEKEY<=@TimeKey AND A.EFFECTIVETOTIMEKEY>=@TimeKey



		  END






          END 
		  
 --BEGIN  
 --         INSERT INTO SaletoARCFinalACFlagging  
 --         (    --Entity_Key  
 --             SourceAlt_Key  
 --            ,SourceSystem  
 --            ,AccountID  
 --            ,CustomerID  
 --            ,CustomerName  
 --            ,FlagAlt_Key  
 --            ,AccountBalance  
 --            ,POS  
 --            ,InterestReceivable
	--		 ,ExposureAmount
 --             ,AuthorisationStatus  
	--		  ,Remark
 --             ,EffectiveFromTimeKey  
 --             ,EffectiveToTimeKey  
 --             ,CreatedBy  
 --             ,DateCreated  
 --             ,ModifyBy  
 --             ,DateModified  
 --             ,ApprovedBy  
 --             ,DateApproved  
 --            -- ,D2Ktimestamp  
 --           )  
  
 --        VALUES     
 --          (   @SourceAlt_Key  
 --            ,@SourceName  
 --            ,@AccountID  
 --            ,@CustomerID  
 --            ,@CustomerName  
 --            ,@FlagAlt_Key  
 --            ,@AccountBalance  
 --            ,@POS  
 --            ,@InterestReceivable
	--		 ,@ExposureAmount
 --             --,trim(@AuthorisationStatus)
	--		  ,@AuthorisationStatus
	--		  ,@Remark
 --             ,@EffectiveFromTimeKey  
 --             ,@EffectiveToTimeKey  
 --             ,@CreatedBy  
 --             ,@DateCreated  
 --             ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @ModifiedBy  ELSE NULL END  
 --             ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @DateModified  ELSE NULL END  
 --             ,CASE WHEN @AUTHMODE= 'Y' THEN    @ApprovedBy ELSE NULL END  
 --             ,CASE WHEN @AUTHMODE= 'Y' THEN    @DateApproved  ELSE NULL END  
 --            -- ,@D2Ktimestamp  
 --             )  
  

 --         END  
		   
  
  
         IF @IsSCD2='Y'   
        BEGIN  
        UPDATE SaletoARCACFlaggingDetail SET  
          EffectiveToTimeKey=@EffectiveFromTimeKey-1  
          ,AuthorisationStatus =CASE WHEN @AUTHMODE='Y' THEN  'A' ELSE NULL END  
         WHERE (EffectiveFromTimeKey=EffectiveFromTimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID  
           AND EffectiveFromTimekey<@EffectiveFromTimeKey  
        END  
       END  
  IF @AUTHMODE='N'  
   BEGIN  
     SET @AuthorisationStatus='A'  
     --GOTO AdvFacBillDetail_Insert  
     GOTO SaletoARCACFlaggingDetail_Insert  
     HistoryRecordInUp:  
   END        
  

  --------------------------------------

  --IF @FlagAlt_Key='Y'
  --      BEGIN  
  --        INSERT INTO SaletoARCFinalACFlagging  
  --        (    --Entity_Key  
  --            --AccountFlagAlt_Key  
  --           SourceSystem
		--	  ,CustomerID
		--	  ,CustomerName
		--	  ,AccountID
		--	  ,POS
		--	  ,InterestReceivable
		--	  ,ExposureAmount
		--	  ,SourceAlt_Key
		--	  ,FlagAlt_Key
		--	  ,AccountBalance
  --            ,AuthorisationStatus  
		--	  ,Remark
  --            ,EffectiveFromTimeKey  
  --            ,EffectiveToTimeKey  
  --            ,CreatedBy  
  --            ,DateCreated  
  --            ,ModifyBy  
  --            ,DateModified  
  --            ,ApprovedBy  
  --            ,DateApproved  
  --           -- ,D2Ktimestamp  
  --          )  
  
  --       VALUES     
  --         (  -- @AccountFlagAlt_Key  
  --           @SourceName
		--	  ,@CustomerID
		--	  ,@CustomerName
		--	  ,@AccountID
		--	  ,@POS
		--	  ,@InterestReceivable
		--	  ,@ExposureAmount
		--	  ,@SourceAlt_Key
		--	  ,@FlagAlt_Key
		--	  ,@AccountBalance
		--	  ,trim(@AuthorisationStatus)
		--	  ,@Remark
  --            ,@EffectiveFromTimeKey  
  --            ,@EffectiveToTimeKey  
  --            ,@CreatedBy  
  --            ,@DateCreated  
  --            ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @ModifiedBy  ELSE NULL END  
  --            ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @DateModified  ELSE NULL END  
  --            ,CASE WHEN @AUTHMODE= 'Y' THEN    @ApprovedBy ELSE NULL END  
  --            ,CASE WHEN @AUTHMODE= 'Y' THEN    @DateApproved  ELSE NULL END  
  --           -- ,@D2Ktimestamp  
  --            )  
		--  /*Adding Flag ----------Pranay 21-03-2021*/
		--  UPDATE A
		--	SET  
		--		A.SplFlag=CASE WHEN ISNULL(A.SplFlag,'')='' THEN 'SaleArc'     
		--						ELSE A.SplFlag+','+'SaleArc'     END
		   
		--   FROM DBO.AdvAcOtherDetail A
		--   Where A.EffectiveToTimeKey=49999 and A.RefSystemAcId=@AccountID
   

  --        END  
		--  ELSE
		--  BEGIN
		--   UPDATE SaletoARCFinalACFlagging SET  
  --        EffectiveToTimeKey=@EffectiveFromTimeKey-1  
  --        ,AuthorisationStatus =CASE WHEN @AUTHMODE='Y' THEN  'A' ELSE NULL END  
  --       WHERE (EffectiveFromTimeKey=EffectiveFromTimeKey AND EffectiveToTimeKey>=@TimeKey) AND AccountID=@AccountID  
  --         AND EffectiveFromTimekey<@EffectiveFromTimeKey 

		--   ------------------REMOVE FLAG--------



		--		IF OBJECT_ID('TempDB..#Temp') IS NOT NULL
		--		DROP TABLE #Temp

		--		Select AccountentityID,SplFlag into #Temp from Curdat.AdvAcOtherDetail 
		--		where EffectiveToTimeKey=49999 AND RefSystemAcId=@AccountID AND splflag like '%SaleArc%'


		--		--Select * from #Temp


		--		IF OBJECT_ID('TEMPDB..#SplitValue')  IS NOT NULL
		--		DROP TABLE #SplitValue        
		--		SELECT AccountentityID,Split.a.value('.', 'VARCHAR(8000)') AS Businesscolvalues1  into #SplitValue
		--									FROM  (SELECT 
		--													CAST ('<M>' + REPLACE(SplFlag, ',', '</M><M>') + '</M>' AS XML) AS Businesscolvalues1,
		--													AccountentityID
		--													from #Temp 
		--											) AS A CROSS APPLY Businesscolvalues1.nodes ('/M') AS Split(a)
						


		--		 --Select * from #SplitValue 

		--		 DELETE FROM #SplitValue WHERE Businesscolvalues1='SaleArc'




		--		 IF OBJECT_ID('TEMPDB..#NEWTRANCHE')  IS NOT NULL
		--			DROP TABLE #NEWTRANCHE

		--			SELECT * INTO #NEWTRANCHE FROM(
		--			SELECT 
		--				 SS.AccountentityID,
		--				STUFF((SELECT ',' + US.BUSINESSCOLVALUES1 
		--					FROM #SPLITVALUE US
		--					WHERE US.AccountentityID = SS.AccountentityID
		--					FOR XML PATH('')), 1, 1, '') [REPORTIDSLIST]
		--				FROM #TEMP SS 
		--				GROUP BY SS.AccountentityID
		--				)B
		--				ORDER BY 1

		--				--Select * from #NEWTRANCHE

		--			--SELECT * 
		--			UPDATE A SET A.SplFlag=B.REPORTIDSLIST
		--			FROM DBO.AdvAcOtherDetail A
		--			INNER JOIN #NEWTRANCHE B ON A.AccountentityID=B.AccountentityID
		--			WHERE  A.EFFECTIVEFROMTIMEKEY<=@TimeKey AND A.EFFECTIVETOTIMEKEY>=@TimeKey



		--  END
  
  
  END   
  
 PRINT 6  
SET @ErrorHandle=1  
  
SaletoARCACFlaggingDetail_Insert:  
IF @ErrorHandle=0  
 BEGIN  
   INSERT INTO SaletoARCACFlaggingDetail_Mod  
      ( --Entity_Key  
        AccountFlagAlt_Key  
       ,SourceAlt_Key  
       ,SourceName  
       ,AccountID  
       ,CustomerID  
       ,CustomerName  
       ,FlagAlt_Key  
       ,AccountBalance  
       ,POS  
       ,InterestReceivable
	   ,ExposureAmount
        ,AuthorisationStatus  
        ,Remark  
        --,ChangeFields  
        ,EffectiveFromTimeKey  
        ,EffectiveToTimeKey  
        ,CreatedBy  
        ,DateCreated  
        ,ModifiedBy  
        ,DateModified  
        ,ApprovedBy  
        ,DateApproved 
		,changefields
       -- ,D2Ktimestamp
	   ,DtofsaletoARC
	   ,DateofApproval  
      )  
  
    VALUES     
      (    @AccountFlagAlt_Key  
        ,@SourceAlt_Key  
        ,@SourceName  
        ,@AccountID  
        ,@CustomerID  
        ,@CustomerName  
        ,@FlagAlt_Key  
        ,@AccountBalance  
        ,@POS  
        ,@InterestReceivable
		,@ExposureAmount
         ,@AuthorisationStatus
         ,@Remark  
         --,@ChangeFields  
         ,@EffectiveFromTimeKey  
         ,@EffectiveToTimeKey  
         ,@CreatedBy  
         ,@DateCreated  
         ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @ModifiedBy ELSE NULL END  
         ,CASE WHEN @AuthMode='Y' OR @IsAvailable='Y' THEN @DateModified ELSE NULL END  
         ,CASE WHEN @AuthMode='Y' THEN @ApprovedBy    ELSE NULL END  
         ,CASE WHEN @AuthMode='Y' THEN @DateApproved  ELSE NULL END  
		 ,@SaletoARCACFlaggingDetail_changefields
        -- ,@D2Ktimestamp 
		,Case When ISNULL(@DtofsaletoARC,'')='' Then NULL Else Convert(Date,@DtofsaletoARC,105) End
		,Case When ISNULL(@DateofApproval,'')='' Then NULL Else Convert(Date,@DateofApproval,105) End 
         )  
		  DECLARE @Parameter3 varchar(50)
	DECLARE @FinalParameter3 varchar(50)
	SET @Parameter3 = (select STUFF((	SELECT Distinct ',' +ChangeFields
											from SaletoARCACFlaggingDetail_Mod  where AccountID=@AccountID  
											and ISNULL(AuthorisationStatus,'A')  in ( 'A','MP')
											 for XML PATH('')),1,1,'') )

											If OBJECT_ID('#AA') is not null
											drop table #AA

select DISTINCT VALUE 
into #AA 
from (
		SELECT 	CHARINDEX('|',VALUE) CHRIDX,VALUE
		FROM( SELECT VALUE FROM STRING_SPLIT(@Parameter3,',')
 ) A
 )X
 SET @FinalParameter3 = (select STUFF((	SELECT Distinct ',' + Value from #AA  for XML PATH('')),1,1,''))
 
							UPDATE		A
							set			a.ChangeFields = @FinalParameter3							 																																	
							from		SaletoARCACFlaggingDetail_Mod    A
							WHERE		(EffectiveFromTimeKey<=@tiMEKEY AND EffectiveToTimeKey>=@tiMEKEY) 
							and		AccountID=@AccountID  									
									
  
  
     
 IF @OperationFlag =1 AND @AUTHMODE='Y'  
     BEGIN  
      PRINT 3  
      GOTO SaletoARCACFlaggingDetail_Insert_Add  
     END  
    ELSE IF (@OperationFlag =2 OR @OperationFlag =3)AND @AUTHMODE='Y'  
     BEGIN  
      GOTO SaletoARCACFlaggingDetail_Insert_Edit_Delete  
     END   
  
END  
-------------------  
PRINT 7  
 -- COMMIT TRANSACTION  
  
  SELECT @D2Ktimestamp=CAST(D2Ktimestamp AS INT) FROM SaletoARCACFlaggingDetail WHERE (EffectiveFromTimeKey=EffectiveFromTimeKey AND EffectiveToTimeKey>=@TimeKey)   
                 AND AccountID=@AccountID  
  
  IF @OperationFlag =3  
   BEGIN  
    SET @Result=0
   END  
  ELSE  
   BEGIN  
    SET @Result=1  
   END  
END TRY  
BEGIN CATCH  
 --ROLLBACK TRAN  
 SELECT ERROR_MESSAGE()  
 RETURN -1  
  
END CATCH  
---------  
END  
 
GO
