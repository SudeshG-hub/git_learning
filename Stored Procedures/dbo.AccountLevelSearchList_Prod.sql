SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- exec AccountLevelSearchList @AccountID=N'130',@OperationFlag=2


--[AccountLevelSearchList]

-- exec AccountLevelSearchList @AccountID=N'00283GLN500166',@OperationFlag=2

      --Main Screen Select 

 

 -- exec AccountLevelSearchList @AccountID=N'130',@OperationFlag=16

CREATE PROC [dbo].[AccountLevelSearchList_Prod]

--Declare

												

												--@PageNo         INT         = 1, 

													--@PageSize       INT         = 10, 

							

													

													--@PageNo         INT         = 1, 

													--@PageSize       INT         = 10, 

													@OperationFlag  INT        ,

													@AccountID	varchar(30)		,

													@TimeKey INT                =25992,

													@SourceSystem   varchar(20)   = ''

AS

    --25999 

	 BEGIN



SET NOCOUNT ON;



 --Declare @Timekey INT

 SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 



  SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 

    SET @SourceSystem = (select distinct SourceName 
						from [Pro].AccountCal_Hist A  
						INNER JOIN DIMSOURCEDB B 
						ON A.SourceAlt_key = B.SourceAlt_Key where CustomerAcID = @AccountID ) 



	PRINT '@Timekey'

	PRINT @Timekey

	--SET @Timekey=25992

Declare @CreatedBy Varchar(50)

Declare @DateCreated Date

Declare @ModifiedBy Varchar(50)

Declare @DateModified Date

Declare @ApprovedBy Varchar(50)

Declare @DateApproved Date

Declare @AuthorisationStatus Varchar(5)	
DEclare @MOCReason Varchar(500)
Declare @MocSource INT


Declare @ApprovedByFirstLevel	varchar(100)
Declare @DateApprovedFirstLevel	date

IF @OperationFlag NOT IN (16,20)

BEGIN
	SELECT  

	@CreatedBy=CreatedBy,@MocReason=MocReason,

	@DateCreated=DateCreated,@ModifiedBy=ModifyBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus	,@MocSource=MOCSource
	,@ApprovedByFirstLevel=ApprovedByFirstLevel,@DateApprovedFirstLevel=DateApprovedFirstLevel

	FROM AccountLevelMOC_Mod 

	where AuthorisationStatus in('MP','1A','A') AND AccountID=@AccountId

	AND  EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey

	AND  Entitykey in (select max(Entitykey) FROM AccountLevelMOC_Mod 

	where AuthorisationStatus in('MP','1A','A') AND AccountID=@AccountId

	AND  EffectiveFromTimeKey=@Timekey and EffectiveToTimeKey=@Timekey )
	
	END

		if @OperationFlag  = '16'

	BEGIN

	SELECT  

	@CreatedBy=CreatedBy,@MocReason=MocReason,

	@DateCreated=DateCreated,@ModifiedBy=ModifyBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus	,@MocSource=MOCSource
	,@ApprovedByFirstLevel=ApprovedByFirstLevel,@DateApprovedFirstLevel=DateApprovedFirstLevel

	FROM AccountLevelMOC_Mod 

	where AuthorisationStatus in('MP') AND AccountID=@AccountId

	AND  EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey

	AND SCREENFLAG <> ('U')

	END

	if @OperationFlag  = '20'

	BEGIN

	SELECT  

	@CreatedBy=CreatedBy,@MocReason=MocReason,

	@DateCreated=DateCreated,@ModifiedBy=ModifyBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus	,@MocSource=MOCSource
	,@ApprovedByFirstLevel=ApprovedByFirstLevel,@DateApprovedFirstLevel=DateApprovedFirstLevel

	FROM AccountLevelMOC_Mod 

	where AuthorisationStatus in('1A') AND AccountID=@AccountId

	AND  EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey

	AND SCREENFLAG <> ('U')

	END

	PRINT '@AuthorisationStatus'

	PRINT @AuthorisationStatus



BEGIN TRY

/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */





	Declare @DateOfData	 as DateTime

	Set @DateOfData= (Select CAST(B.Date as Date)Date1 from SysDataMatrix A

Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey

 where A.CurrentStatus='C')

 

DROP TABLE IF EXISTS #ACCOUNT_PREMOC



Select * INTO  #ACCOUNT_PREMOC from(

SELECT AccountEntityId,CustomerACID as AccountID
,FacilityType,CustomerEntityID as CustomerEntityID
,Balance,unserviedint as InterestReceivable
,FlgRestructure as RestructureFlag,RestructureDate,FLGFITL,DFVAmt,RePossession as RePossessionFlag,

RepossessionDate,WeakAccount as WeakAccountFlag,WeakAccountDate,Sarfaesi as SarfaesiFlag
,SarfaesiDate,FlgUnusualBounce as UnusualBounceflag,UnusualBounceDate,FlgUnClearedEffect as UnClearedEffectFlag,

UnClearedEffectDate,AddlProvision,FlgFraud as FraudAccountFlag,FraudDate,FlgMoc,@MocReason as MOCReason,

	UCIF_ID as UCICID,@AuthorisationStatus as AuthorisationStatus,@CreatedBy as CreatedBy,

	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,@DateApproved as DateApproved
	,@MocSource  AS MOCSource	,@ApprovedByFirstLevel as ApprovedByFirstLevel,
	@DateApprovedFirstLevel as DateApprovedFirstLevel,@SourceSystem as SourceSystem



FROM   [PreMoc].[AccountCal] where EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey 
--and  ISNULL(ScreenFlag,'')= CASE WHEN @OperationFlag =2   THEN 'U' 
--                               When @AuthorisationStatus  in('MP','1A') THEN 'U' END

AND  CustomerAcID=@AccountId

UNION all

SELECT AccountEntityId,CustomerACID as AccountID,FacilityType,CustomerEntityID as CustomerEntityID,Balance,unserviedint as InterestReceivable,FlgRestructure as RestructureFlag,RestructureDate,FLGFITL,DFVAmt,RePossession as RePossessionFlag,

RepossessionDate,WeakAccount as WeakAccountFlag,WeakAccountDate,Sarfaesi as SarfaesiFlag,SarfaesiDate,FlgUnusualBounce as UnusualBounceflag,UnusualBounceDate,FlgUnClearedEffect as UnClearedEffectFlag,

UnClearedEffectDate,AddlProvision,FlgFraud as FraudAccountFlag,FraudDate,FlgMoc,@MocReason as MOCReason,



	UCIF_ID as UCICID,@AuthorisationStatus as AuthorisationStatus,@CreatedBy as CreatedBy,

	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,@DateApproved as DateApproved
	,@MocSource  AS MOCSource	,@ApprovedByFirstLevel as ApprovedByFirstLevel
	,@DateApprovedFirstLevel as DateApprovedFirstLevel,@SourceSystem as SourceSystem
	

FROM   [Pro].[ACCOUNTCAL_HIST] where EffectiveFromTimeKey=@TimeKey 

AND EffectiveToTimeKey=@TimeKey and isnull(FlgMoc,'N')='N'

AND    CustomerAcID=@AccountId 

--and  ISNULL(ScreenFlag,'') = CASE WHEN @OperationFlag =2   THEN 'U' 
--                               When @AuthorisationStatus  in('MP','1A') THEN 'U' END

) X 



----POST 



--Select '#ACCOUNT_PREMOC',* from #ACCOUNT_PREMOC



DROP TABLE IF EXISTS #ACCOUNT_POSTMOC





    SELECT AccountEntityId,AccountID as AccountID,0  as CustomerEntityID, POS as Balance,InterestReceivable,RestructureFlag,RestructureDate,FITLFlag as FLGFITL,DFVAmount,RePossessionFlag as RePossessionFlag,

	RepossessionDate,InherentWeaknessFlag as WeakAccountFlag,InherentWeaknessDate as WeakAccountDate,SarfaesiFlag as SarfaesiFlag ,SARFAESIDate,UnusualBounceFlag as UnusualBounceFlag,

	UnusualBounceDate,UnclearedEffectsFlag as UnClearedEffectFlag,UnclearedEffectsDate,AdditionalProvisionAbsolute,FraudAccountFlag as FraudAccountFlag,FraudDate,

	'' as FlgMoc,@MocReason as MOCReason,

	Convert(Varchar(50),'') as UCICID,@AuthorisationStatus as AuthorisationStatus,@CreatedBy as CreatedBy,

	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,@DateApproved as DateApproved
	,@MocSource  AS MOCSource,@ApprovedByFirstLevel as ApprovedByFirstLevel
	,@DateApprovedFirstLevel as DateApprovedFirstLevel,@SourceSystem as SourceSystem
	
	INTO #ACCOUNT_POSTMOC

	FROM AccountLevelMOC_Mod 

	where AuthorisationStatus = CASE WHEN @OperationFlag =20 THEN '1A' ELSE 'MP' END

	AND  EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey AND AccountID=@AccountId
	--and  ISNULL(ScreenFlag,'')=CASE WHEN @OperationFlag =2   THEN 'U' 
 --                              When @AuthorisationStatus  in('MP','1A') THEN 'S' END

	AND SCREENFLAG not in (CASE WHEN @OperationFlag in (16,20) THEN 'U' END)



	

	--Drop Table  ACCOUNT_POSTMOC_HIST 

IF NOT EXISTS(SELECT 1 FROM #ACCOUNT_POSTMOC WHERE AccountID=@AccountId)

BEGIN



	INSERT  INTO  #ACCOUNT_POSTMOC

	SELECT AccountEntityId,CustomerACID as AccountID,CustomerEntityID as CustomerEntityID,Balance,unserviedint as InterestReceivable,FlgRestructure as RestructureFlag,RestructureDate,FLGFITL,DFVAmt,RePossession as RePossessionFlag,

    RepossessionDate,WeakAccount as WeakAccountFlag,WeakAccountDate,Sarfaesi as SarfaesiFlag,SarfaesiDate,FlgUnusualBounce as UnusualBounceflag,UnusualBounceDate,FlgUnClearedEffect as UnClearedEffectFlag,

    UnClearedEffectDate,AddlProvision as AdditionalProvisionAbsolute,FlgFraud as FraudAccountFlag,FraudDate,FlgMoc,@MocReason as MOCReason,



	UCIF_ID as UCICID,@AuthorisationStatus as AuthorisationStatus,@CreatedBy as CreatedBy,

	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,@DateApproved as DateApproved
	,@MocSource  AS MOCSource	,@ApprovedByFirstLevel as ApprovedByFirstLevel
	,@DateApprovedFirstLevel as DateApprovedFirstLevel,@SourceSystem as SourceSystem
	

	

	FROM   [Pro].[ACCOUNTCAL_HIST]

	WHERE EffectiveFromTimeKey=@TimeKey and EffectiveToTimeKey=@TimeKey and isnull(FlgMoc,'N')='Y'

	AND CustomerACID=@AccountId 
	
	--and  ISNULL(ScreenFlag,'')=CASE WHEN @OperationFlag =2   THEN 'U' 
 --                              When @AuthorisationStatus  in('MP','1A') THEN 'U' END

END

	--Select '#ACCOUNT_POSTMOC' ,* from #ACCOUNT_POSTMOC





BEGIN

			



         SELECT	

				A.AccountID

				,A.FacilityType

				,A.Balance as POS

				,A.InterestReceivable

				,C.RefCustomerID    CustomerID

				,C.CustomerName
				
				--,A.UCIC

				--,A.Segment

				--,A.BalanceOSPOS

				--,A.BalanceOSInterestReceivable

				--, 1 as  RestructureFlagAlt_Key

				,(case when A.RestructureFlag  IS NULL 
				       then 'No' 
					   when  A.RestructureFlag='Y'
					   THEN 'Yes'
					   When  A.RestructureFlag='N'
					   THEN 'No'
					   
					    end)  RestructureFlag

				,Convert(Varchar(10),A.RestructureDate,103) as RestructureDate

				--,A.FLGFITL  as FITLFlag
				,(case when A.FLGFITL  IS NULL 
				       then 'No' 
					   when  A.FLGFITL='Y'
					   THEN 'Yes'
					   When  A.FLGFITL='N'
					   THEN 'No'					   
					    end)  FITLFlag

				,A.DFVAmt as DFVAmount

				--, 1 as RePossessionFlagAlt_Key

				--,A.RePossessionFlag
					,(case when A.RePossessionFlag  IS NULL 
				       then 'No' 
					   when  A.RePossessionFlag='Y'
					   THEN 'Yes'
					   When  A.RePossessionFlag='N'
					   THEN 'No'					   
					    end)  RePossessionFlag

				,Convert(Varchar(10),A.RePossessionDate,103) as RePossessionDate

				--,1 as InherentWeaknessFlagAlt_Key

				--,A.WeakAccountFlag as InherentWeaknessFlag
				,(case when A.WeakAccountFlag  IS NULL 
				       then 'No' 
					   when  A.WeakAccountFlag='Y'
					   THEN 'Yes'
					   When  A.WeakAccountFlag='N'
					   THEN 'No'					   
					    end)  InherentWeaknessFlag

				,Convert(Varchar(10),A.WeakAccountDate,103) as InherentWeaknessDate

				--,1 as SARFAESIFlagAlt_Key

				--,A.SARFAESIFlag as SarfaesiFlag
				,(case when A.SARFAESIFlag  IS NULL 
				       then 'No' 
					   when  A.SARFAESIFlag='Y'
					   THEN 'Yes'
					   When  A.SARFAESIFlag='N'
					   THEN 'No'					   
					    end)  SarfaesiFlag

				,Convert(Varchar(10),A.SARFAESIDate,103) as SarfaesiDate

				--, 1 as UnusualBounceFlagAlt_Key

				--,A.UnusualBounceflag as UnusualBounceflag
				,(case when A.UnusualBounceflag  IS NULL 
				       then 'No' 
					   when  A.UnusualBounceflag='Y'
					   THEN 'Yes'
					   When  A.UnusualBounceflag='N'
					   THEN 'No'					   
					    end)  UnusualBounceflag

				,Convert(Varchar(10),A.UnusualBounceDate,103) as UnusualBounceDate

			

				--,1 as UnclearedEffectsFlagAlt_Key

				--,A.UnClearedEffectFlag as UnclearedEffectsFlag
				,(case when A.UnClearedEffectFlag  IS NULL 
				       then 'No' 
					   when  A.UnClearedEffectFlag='Y'
					   THEN 'Yes'
					   When  A.UnClearedEffectFlag='N'
					   THEN 'No'					   
					    end)  UnclearedEffectsFlag

				,Convert(Varchar(10),A.UnclearedEffectDate,103) as UnclearedEffectsDate

				,A.AddlProvision as AdditionalProvisionAbsolute

				--,1 as FraudAccountFlagAlt_key

				--,A.FraudAccountFlag as FraudAccountFlag
				,(case when A.FraudAccountFlag  IS NULL 
				       then 'No' 
					   when  A.FraudAccountFlag='Y'
					   THEN 'Yes'
					   When  A.FraudAccountFlag='N'
					   THEN 'No'					   
					    end)  FraudAccountFlag

				,Convert(Varchar(10),A.FraudDate,103) as FraudDate

				,A.MOCReason
				,A.MOCSource

				,C.AddlProvisionPer as AdditionalProvisionCustomerlevel

				
				 ,B.RestructureFlag 	as RestructureFlag_POS

				,NULL				as RestructureFlag_POS1

				, Convert(Varchar(10),B.RestructureDate,103) 		as RestructureDate_POS

				,B.FLGFITL			as FITLFlag_POS

				,NULL				as FITLFlag_POS1

				,B.DFVAmount			as DFVAmount_POS

				,B.RePossessionFlag		as RePossessionFlag_POS

				,NULL				as RePossessionFlag_POS1

				,Convert(Varchar(10),B.RePossessionDate,103)	as RePossessionDate_POS

				,B.WeakAccountFlag		as InherentWeaknessFlag_POS

				,NULL				as InherentWeaknessFlag_POS1

				, Convert(Varchar(10),B.WeakAccountDate,103)		as InherentWeaknessDate_POS

				,B.SARFAESIFlag			as SARFAESIFlag_POS

				,NULL				as SARFAESIFlag_POS1

				,Convert(Varchar(10),B.SARFAESIDate,103)			as SARFAESIDate_POS

				,B.UnusualBounceFlag		as UnusualBounceFlag_POS

				,NULL				as UnusualBounceFlag_POS1

				, Convert(Varchar(10),B.UnusualBounceDate,103)		as UnusualBounceDate_POS

				,B.UnClearedEffectFlag 	as UnclearedEffectsFlag_POS

				,NULL				as UnclearedEffectsFlag_POS1

				, Convert(Varchar(10),B.UnclearedEffectsDate,103)		as UnclearedEffectsDate_POS

				,C.AddlProvisionPer				as AdditionalProvisionCustomerlevel_POS

				,B.AdditionalProvisionAbsolute 		as AdditionalProvisionAbsolute_POS

				,B.FraudAccountFlag		as FraudAccountFlag_POS

				,NULL                           as FraudAccountFlag_POS1

				, Convert(Varchar(10),B.FraudDate ,103)                   as FraudDate_POS

				,B.Balance                     as POS_POS   ----new add 
				,B.InterestReceivable          as InterestReceivable_POS --new add

				,B.AuthorisationStatus
			
                ,@Timekey as EffectiveFromTimeKey

                ,@Timekey as EffectiveToTimeKey

                ,A.CreatedBy

 ,A.DateCreated 

                ,A.ApprovedBy 

                ,A.DateApproved

                ,A.ModifiedBy 

                ,A.DateModified

				,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy

				,IsNull(A.DateModified,A.DateCreated)as CrModDate

				,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy

				,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate

				,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy

				,ISNULL(A.DateApproved,A.DateModified) as ModAppDate



    , NULL as FraudDate_POS
	, 'Account' as TableName
	,B.ApprovedByFirstLevel
	,B.DateApprovedFirstLevel,
	A.SourceSystem
FROM #ACCOUNT_PREMOC A

	LEFT JOIN #ACCOUNT_POSTMOC B

		on A.AccountID =b.AccountID
    LEFT JOIN  [Pro].[CustomerCal_Hist] C ON A.CustomerEntityID=C.CustomerEntityID

	   AND  c.EffectiveFromTimeKey<=@TimeKey and c.EffectiveToTimeKey>=@TimeKey 

	 

	--LEFT Join (

	--					Select ParameterShortNameEnum as ParameterAlt_Key,ParameterName,'SARFAESIFlag' as Tablename 

	--					from DimParameter where DimParameterName='DimYesNo'

	--					And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)F

	--					ON F.ParameterAlt_Key=A.SARFAESIFlag



	--	LEFT join (select ACID,StatusType,StatusDate, 'SARFAESIDate' as TableName

	--					from ExceptionFinalStatusType where StatusType like '%SARFAESI%'

	--					AND EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) K

	--					ON A.AccountID=K.ACID	

						

	--	LEFT Join (

	--					Select ParameterShortNameEnum as ParameterAlt_Key,ParameterName,'FITLFlag' as Tablename 

	--					from DimParameter where DimParameterName='DimYesNo'

	--					And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)C

	--					ON C.ParameterAlt_Key=A.FLGFITL



	--	LEFT Join (Select ParameterShortNameEnum as ParameterAlt_Key,ParameterName,'RePossessionFlag' as Tablename 

	--					from DimParameter where DimParameterName='DimYesNo'

	--					And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey)D

	--					ON D.ParameterAlt_Key=A.RePossessionFlag









             END;



--END







PRINT 'Nitin'	



  IF OBJECT_ID('tempdb..#MOCAuthorisation') IS NOT NULL  

	  BEGIN  

	   DROP TABLE #MOCAuthorisation  

	  END





	  Select *,CAST('' AS varchar(MAX)) ErrorMessage,CAST('' AS varchar(MAX)) ErrorinColumn,CAST('' AS varchar(MAX)) Srnooferroneousrows

 	   into #MOCAuthorisation 

	   from AccountLevelMOC_Mod A

	   	Where A.EffectiveFromTimeKey<=@TimeKey And A.EffectiveToTimeKey>=@TimeKey

		and AccountID=@AccountID  and AccountID is not null

		   AND A.EntityKey IN

                     (

                         SELECT MAX(EntityKey)

                         FROM AccountLevelMOC_Mod

						WHERE EffectiveFromTimeKey <= @TimeKey

                               AND EffectiveToTimeKey >= @TimeKey

                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')

                         GROUP BY AccountID

                     )				



				

					

	   --Select ' #MOCAuthorisation',* from  #MOCAuthorisation

	   --where abc=1



	  UPDATE #MOCAuthorisation

	SET  

        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Account Level NPA MOC – Authorization’ menu'     

						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for this Account ID. Kindly authorize or Reject the record through ‘Accout Level NPZ MOC – Authorization’ menu'     END

		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'AccountID' ELSE   ErrorinColumn +','+SPACE(1)+'AccountID' END   

	

		FROM #MOCAuthorisation V  

  WHERE V.AuthorisationStatus in('NP','MP','DP','1A')

  AND AccountID=@AccountID

  AND @operationflag not in(16,17,20)



 



  UPDATE #MOCAuthorisation

	SET  

       ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'You cannot perform MOC, Record is pending for authorization for this Customer ID. Kindly authorize or Reject the record through ‘Customer Level NPA MOC – Authorization’ menu'     

						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for this Customer ID. Kindly authorize or Reject the record through ‘Customer Level NPA MOC – Authorization’ menu'     END

		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerID' END   

		

		FROM CustomerLevelMOC_Mod V 

		inner join AdvAcBasicDetail X On V.CustomerEntityId=X.CustomerEntityId

		Inner Join #MOCAuthorisation Z On X.CustomerACID=Z.AccountID

		

  WHERE X.AuthorisationStatus in('NP','MP','DP','1A')

  AND @operationflag not in(16,17,20)  AND Z.AccountID=@AccountID



  IF EXISTS(SELECT 1 FROM #MOCAuthorisation WHERE AccountID=@AccountID --AND ISNULL(ERRORDATA,'')<>''

		) 

	BEGIN

	PRINT 'ERROR'

	if(@operationflag not in(16,17,20))

	begin

		SELECT distinct ErrorMessage

		ErrorinColumn,'Validation'TableName

		FROM #MOCAuthorisation

		END





END



   

   END TRY

	BEGIN CATCH

	

	INSERT INTO dbo.Error_Log

				SELECT ERROR_LINE() as ErrorLine,ERROR_MESSAGE()ErrorMessage,ERROR_NUMBER()ErrorNumber

				,ERROR_PROCEDURE()ErrorProcedure,ERROR_SEVERITY()ErrorSeverity,ERROR_STATE()ErrorState

				,GETDATE()



	SELECT ERROR_MESSAGE()

	--RETURN -1

   

	END CATCH





  

  

    END;

	
































GO
