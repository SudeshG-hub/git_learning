SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--USE [USFB_ENPADB]
--GO
--/****** Object:  StoredProcedure [dbo].[CustomerLevelNPAMOCSearchList]    Script Date: 18-11-2021 13:33:01 ******/
--DROP PROCEDURE [dbo].[CustomerLevelNPAMOCSearchList]
--GO
--/****** Object:  StoredProcedure [dbo].[CustomerLevelNPAMOCSearchList]    Script Date: 18-11-2021 13:33:01 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO


---- exec CustomerLevelNPAMOCSearchList @CustomerID=N'84',@OperationFlag=2

----go



--sp_helptext CustomerLevelNPAMOCSearchList



-------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



















--exec CustomerLevelNPAMOCSearchList @CustomerID=N'84',@OperationFlag=2

--go







--SELECT Top 100 * FROM [PRO].[CustomerCal_Hist]	where RefCustomerID ='95'

--And EffectiveFromTimeKey=25992 AND EffectiveToTimeKey=25992


--Exec [CustomerLevelNPAMOCfH.MOCSourceAltKeySearchList] @OperationFlag =, @CustomerID='161760505'		--Main screen select

--MOCSource

--MOCSourceAltKey

--exec CustomerLevelNPAMOCSearchList_Backup_14052021_1 @CustomerID=N'90',@OperationFlag=2

CREATE PROC [dbo].[CalypsoCustomerLevelNPAMOCSearchList_28092022]

--Declare



@OperationFlag  INT         = 2,

@CustomerID	varchar(20)		='84',

@TimeKey INT                =25841

AS

     

BEGIN



SET NOCOUNT ON;


 
	SET @Timekey =(Select Timekey from SysDataMatrix Where MOC_Initialised='Y' AND ISNULL(MOC_Frozen,'N')='N') 







Declare @MOCSourceAltkey Int

Declare @CreatedBy Varchar(50)

Declare @DateCreated Date

Declare @ModifiedBy Varchar(50)

Declare @DateModified Date

Declare @ApprovedBy Varchar(50)

Declare @DateApproved Date

Declare @AuthorisationStatus Varchar(5)

Declare @MocReason Varchar(50)

Declare @ApprovedByFirstLevel	varchar(100)
Declare @DateApprovedFirstLevel	date
Declare @MOC_ExpireDate date
DECLARE @MOC_TYPEFLAG varchar(4)

IF @OperationFlag NOT IN (16,20)

BEGIN
--,@MOC_ExpireDate=MOC_ExpireDate
SELECT  

	@MocReason=MocReason,@MOCSourceAltkey=MOCSourceAltkey,@CreatedBy=CreatedBy,

	@DateCreated=DateCreated,@ModifiedBy=ModifiedBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus,@ApprovedByFirstLevel=ApprovedByFirstLevel,
	@DateApprovedFirstLevel=DateApprovedFirstLevel,@MOC_TYPEFLAG=MOCType_Flag

	FROM CalypsoCustomerLevelMOC_Mod 

	where AuthorisationStatus in('MP','NP','1A','A') AND CUSTOMERID=@CustomerID

	AND  EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey 

	--AND  Entity_key in (select max(Entity_key) FROM CalypsoCustomerLevelMOC_Mod 

	--where AuthorisationStatus in('MP','1A','A') AND CUSTOMERID=@CustomerID

	--AND  EffectiveFromTimeKey=@Timekey and EffectiveToTimeKey=@Timekey )

	end

	if @OperationFlag  = '16'

	BEGIN
	--,@MOC_ExpireDate=MOC_ExpireDate
	SELECT  

	@MocReason=MocReason,@MOCSourceAltkey=MOCSourceAltkey,@CreatedBy=CreatedBy,

	@DateCreated=DateCreated,@ModifiedBy=ModifiedBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus,@ApprovedByFirstLevel=ApprovedByFirstLevel,
	@DateApprovedFirstLevel=DateApprovedFirstLevel,@MOC_TYPEFLAG=MOCType_Flag

	FROM CalypsoCustomerLevelMOC_Mod 

	where AuthorisationStatus in('MP','NP') AND CUSTOMERID=@CustomerID

	AND  EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey 

	--AND SCREENFLAG <> ('U')

	end

	if @OperationFlag = '20'
	--,@MOC_ExpireDate=MOC_ExpireDate
BEGIN

	SELECT  

	@MocReason=MocReason,@MOCSourceAltkey=MOCSourceAltkey,@CreatedBy=CreatedBy,

	@DateCreated=DateCreated,@ModifiedBy=ModifiedBy,@DateModified=DateModified,@ApprovedBy=ApprovedBy,@DateApproved=DateApproved,

	@AuthorisationStatus=AuthorisationStatus,@ApprovedByFirstLevel=ApprovedByFirstLevel,
	@DateApprovedFirstLevel=DateApprovedFirstLevel,@MOC_TYPEFLAG=MOCType_Flag

	FROM CalypsoCustomerLevelMOC_Mod 

	where AuthorisationStatus in('1A') AND CUSTOMERID=@CustomerID

	AND  EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey 

	--AND SCREENFLAG <> ('U')

	end
	

	PRINT @TimeKey

	PRINT '@AuthorisationStatus'

	PRINT @AuthorisationStatus

BEGIN TRY

	---PRE MOC



	
	Declare @DateOfData	 as DateTime

	Set @DateOfData= (Select CAST(B.Date as Date)Date1 from SysDataMatrix A

Inner Join SysDayMatrix B ON A.TimeKey=B.TimeKey

 where A.CurrentStatus='C')

 

DROP TABLE IF EXISTS #CUST_PREMOC


PRINT 'Prashant'
Select * 

INTO  #CUST_PREMOC 

from(




SELECT	distinct		B.InvEntityId,B.RefIssuerID as CustomerID ,I.IssuerName as CustomerName ,
                b.InvID as AccountID,c.StatusDate as FraudDate,E.StatusDate as TwoDate, 
				Interest_DividendDueAmount as InterestReceivable,

				case when A.FinalAssetClassAlt_Key is null then 1 else A.FinalAssetClassAlt_Key end AssetClassAlt_Key,A.NPIDt as NPADate,V.security_value  SecurityValue,
				B.RefIssuerID as UCICID, 0 as AdditionalProvision	
 FROM			InvestmentBasicDetail B
 INNER JOIN		InvestmentIssuerDetail I
 ON				B.RefIssuerID = I.IssuerID
 and			I.EffectiveFromTimeKey <= @timekey and I.EffectiveToTimeKey >= @Timekey
 INNER JOIN		InvestmentFinancialDetail A
 ON				A.RefInvID = B.InvID
 and			A.EffectiveFromTimeKey <= @timekey and A.EffectiveToTimeKey >= @Timekey
  left join  (select  CustomerID,ACID,StatusType,StatusDate from  ExceptionFinalStatusType
where StatusType='Fraud Committed'
  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) c
  on  b.InvID=c.ACID
  left join (select  CustomerID,ACID,StatusType,StatusDate from  ExceptionFinalStatusType
where StatusType='TWO'
  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) E
 
  on   b.InvID=E.ACID
LEFT JOIN		(select        a.InvID CustomerId,sum(a.SecurityValue) security_value
from          InvestmentBasicDetail a
where         a.EffectiveFromTimeKey<=@timekey and a.EffectiveToTimeKey>=@timekey 
and           a.InvID=@customerid   
group by      a.InvID      
			) V
ON				B.InvID=V.CustomerId
where			B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey 
AND				B.RefIssuerID=@CustomerID

UNION

SELECT	distinct		B.DerivativeEntityID,B.CustomerID ,B.CustomerName,
                b.DerivativeRefNo as AccountID,c.StatusDate as FraudDate,E.StatusDate as TwoDate,
				DueAmtReceivable as InterestReceivable,
				case when B.FinalAssetClassAlt_Key is null then 1 else B.FinalAssetClassAlt_Key end AssetClassAlt_Key,B.NPIDt,V.security_value  SecurityValue,
				B.UCIC_ID as UCICID, 0 as AdditionalProvision	
 FROM			curdat.DerivativeDetail B

 left join  (select  CustomerID,ACID,StatusType,StatusDate from  ExceptionFinalStatusType
where StatusType='Fraud Committed'
  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) c
  on   b.CustomerACID=c.ACID
  
    left join (select  CustomerID,ACID,StatusType,StatusDate from  ExceptionFinalStatusType
where StatusType='TWO'
  And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey) E
  on   b.CustomerACID=E.ACID 
LEFT JOIN		(select        a.CustomerId,0 security_value
from			curdat.DerivativeDetail a
where			a.EffectiveFromTimeKey<=@timekey and a.EffectiveToTimeKey>=@timekey 
and				a.CustomerID=@customerid   
group by		a.CustomerId      
				) V
ON				B.CustomerId=V.CustomerId
where			B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey 
AND				B.CustomerID=@CustomerID	
) X 



----POST 



--Select '#CUST_PREMOC',* from #CUST_PREMOC

PRINT 'jaydev'
DROP TABLE IF EXISTS #CUST_POSTMOC

	SELECT *
	INTO #CUST_POSTMOC
	FROM (	
    
		
	
	SELECT distinct  A.CustomerEntityID,B.RefIssuerID as CustomerID,C.IssuerName as CustomerName ,
	
	FinalAssetClassAlt_Key as AssetClassAlt_Key, A.NPADate,A.SecurityValue SecurityValue,
	A.BookValue,Convert(Varchar(20),A.SMADate,103) as SMADate, A.SMASubAssetClassValue,
		C.UcifId as UCICID, A.AdditionalProvision,
	@AuthorisationStatus as AuthorisationStatus,@MocReason as MOCReason_1,@MOCSourceAltkey as MOCSourceAltkey,@CreatedBy as CreatedBy,
	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,
	@DateApproved as DateApproved,@ApprovedByFirstLevel as ApprovedByFirstLevel,
	@DateApprovedFirstLevel as DateApprovedFirstLevel,@MOC_ExpireDate MOC_ExpireDate,@MOC_TYPEFLAG MOCType_Flag,MOCType,C.SourceAlt_key as SourceSystemAlt_Key1
	,Convert(Varchar(50),'') SourceName
	,0 as MOCReason
    FROM		CalypsoCustomerLevelMOC_Mod A
	INNER JOIN  InvestmentBasicDetail B
	ON          A.CustomerEntityID=B.IssuerEntityId
	AND         B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey 
	INNER JOIN  InvestmentIssuerDetail C
	ON          B.IssuerEntityId=C.IssuerEntityId
	AND         C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey 
	INNER JOIN  InvestmentFinancialDetail D
	ON          B.InvEntityId=D.InvEntityId
	AND         D.EffectiveFromTimeKey<=@TimeKey and D.EffectiveToTimeKey>=@TimeKey 
	WHERE       A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey 
	AND			 B.RefIssuerID=@CustomerID
	and         A.AuthorisationStatus in ('NP','MP','1A','A')

	UNION
	
	SELECT  distinct  A.CustomerEntityID,B.CustomerId ,B.CustomerName,AssetClassAlt_Key, A.NPADate,A.SecurityValue SecurityValue,
	A.BookValue,Convert(Varchar(20),A.SMADate,103) as SMADate, A.SMASubAssetClassValue,
		B.UCIC_ID as UCICID, A.AdditionalProvision,

	@AuthorisationStatus as AuthorisationStatus,@MocReason as MOCReason_1,@MOCSourceAltkey as MOCSourceAltkey,@CreatedBy as CreatedBy,

	@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,

	@DateApproved as DateApproved,@ApprovedByFirstLevel as ApprovedByFirstLevel,
	@DateApprovedFirstLevel as DateApprovedFirstLevel,@MOC_ExpireDate MOC_ExpireDate,@MOC_TYPEFLAG MOCType_Flag,MOCType,C.SourceAlt_Key as SourceSystemAlt_Key1
	,Convert(Varchar(50),'') SourceName

	,0 as MOCReason
    FROM		CalypsoCustomerLevelMOC_Mod A
	INNER JOIN  Curdat.DerivativeDetail B
	ON          A.CustomerID=B.CustomerID
	AND         B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey 
	INNER JOIN	DIMSOURCEDB C 
	ON			B.SourceSystem = C.SourceName
	WHERE       A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey AND B.CUSTOMERID=@CustomerID
	and         A.AuthorisationStatus in ('NP','MP','1A','A')

	)P


	IF NOT EXISTS(SELECT 1 FROM #CUST_POSTMOC WHERE CUSTOMERID=@CustomerID)

	BEGIN
	PRINT 'swapna'
	INSERT  INTO  #CUST_POSTMOC	

		

		SELECT distinct	B.IssuerEntityId,C.IssuerID,C.IssuerName,
		--d.RefInvID as AccountID,FraudDate,TwoDate,unserviedint as InterestReceivable,
		A.AssetClassAlt_Key,A.NPA_Date,A.CurntQtrRv  SecurityValue,
		            A.BookValue,Convert(Varchar(20),A.SMADate,103) as SMADate, A.SMASubAssetClassValue,
					C.UcifId as UCICID,AddlProvAbs as AdditionalProvision,@AuthorisationStatus as AuthorisationStatus,@MocReason as MOCReason_1,
					@MOCSourceAltkey as MOCSourceAltkey,@CreatedBy as CreatedBy,
					@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,
					@DateApproved as DateApproved
					,@ApprovedByFirstLevel as ApprovedByFirstLevel,@DateApprovedFirstLevel as DateApprovedFirstLevel,
					@MOC_ExpireDate MOC_ExpireDate,@MOC_TYPEFLAG MOCType_Flag,MOCType,C.SourceAlt_key as SourceSystemAlt_Key1,Convert(Varchar(50),'') SourceName
					,0 as MOCReason
		FROM		CalypsoInvMOC_ChangeDetails A
		INNER JOIN	InvestmentBasicDetail B
		ON			A.CustomerEntityID=B.IssuerEntityId 
		AND			B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey
		INNER JOIN	InvestmentIssuerDetail C
		ON			C.IssuerEntityId=B.IssuerEntityId 
		AND			C.EffectiveFromTimeKey<=@TimeKey and C.EffectiveToTimeKey>=@TimeKey
		INNER JOIN	InvestmentFinancialDetail D
		ON			B.InvEntityid=D.InvEntityid 
		AND			D.EffectiveFromTimeKey<=@TimeKey and D.EffectiveToTimeKey>=@TimeKey
		where		A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey 
		AND			B.RefIssuerID=@CustomerID
		AND			MOCType_Flag='CUST'

		UNION

		SELECT distinct	B.DerivativeEntityID,B.CustomerId,B.CustomerName,
		--b.DerivativeRefNo as AccountID,FraudDate,TwoDate,unserviedint as InterestReceivable,
		A.AssetClassAlt_Key,A.NPA_Date,A.CurntQtrRv  SecurityValue,
					A.BookValue,Convert(Varchar(20),A.SMADate,103) as SMADate, A.SMASubAssetClassValue,
					B.UCIC_ID as UCICID,AddlProvAbs as AdditionalProvision,@AuthorisationStatus as AuthorisationStatus,@MocReason as MOCReason_1,
					@MOCSourceAltkey as MOCSourceAltkey,@CreatedBy as CreatedBy,
					@DateCreated as DateCreated,@ModifiedBy as ModifiedBy,@DateModified as DateModified,@ApprovedBy as ApprovedBy,
					@DateApproved as DateApproved
					,@ApprovedByFirstLevel as ApprovedByFirstLevel,@DateApprovedFirstLevel as DateApprovedFirstLevel,
					@MOC_ExpireDate MOC_ExpireDate,@MOC_TYPEFLAG MOCType_Flag,MOCType,C.SourceAlt_Key as SourceSystemAlt_Key1,Convert(Varchar(50),'') SourceName
					,0 as MOCReason
		FROM		CalypsoDervMOC_ChangeDetails A
		INNER JOIN	curdat.DerivativeDetail B
		ON			A.CustomerID=B.CustomerID 
		AND			B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey
		INNER JOIN	DIMSOURCEDB C
		ON			B.SourceSystem= C.SourceName
		AND			B.EffectiveFromTimeKey<=@TimeKey and B.EffectiveToTimeKey>=@TimeKey
		where		A.EffectiveFromTimeKey<=@TimeKey and A.EffectiveToTimeKey>=@TimeKey 
		AND			B.CustomerID=@CustomerID
		AND			MOCType_Flag='CUST'



END

	PRINT 'Sudesh'

	Update A
	SET A.SourceName=B.SourceName
	From #CUST_POSTMOC A
	INNER JOIN DIMSOURCEDB B
	ON A.SourceSystemAlt_Key1=B.SourceAlt_Key

	--Select '#CUST_POSTMOC',MOCReason_1, * from #CUST_POSTMOC


	Update A
SET A.MOCReason=ISNULL(B.ParameterAlt_Key,'')
From #CUST_POSTMOC A
Left JOIN 
(select ParameterAlt_Key ,
			 ParameterName 
			 ,'MOCReason' as TableName
			 from DimParameter
			 where 
			 EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey and
			  DimParameterName	= 'DimMOCReason') B
			  ON A.MOCReason_1 =B.ParameterName

SELECT distinct 



	a.CustomerID CustomerId
	
	,a.CustomerName
	,a.AccountID 
	,a.FraudDate
	,a.TwoDate
	,a.InterestReceivable

	,C.AssetClassName AssetClass	

	,a.NPADate NPADate

	,a.SecurityValue	
	,B.BookValue
	,Convert(Varchar(20),B.SMADate,103) as SMADate
	,B.SMASubAssetClassValue

	,a.AdditionalProvision

	,d.AssetClassName AssetClass_Pos	

	,B.NPADate	NPADate_Pos

	,B.SecurityValue SecurityValue_Pos	

	,B.AdditionalProvision AdditionalProvision_Pos

	,A.UCICID as UCICID

	,d.AssetClassAlt_Key as AssetClassAlt_Key_Pos

	--,NULL as FraudAccountFlag

	--,F.STATUSTYPE as FraudAccountFlag_Pos

	--,H.FraudAccountFlagAlt_Key AS FraudAccountFlagAlt_Key

	--,convert(varchar(20),F.STATUSDATE,103) FraudDate	

	--,H.FraudDate as FraudDate_Pos

	--,B.MOCType as MOCType

	,B.MOCReason
	,B.MOCReason_1 

	--,B.MOCTypeAlt_Key                  

	--,Y.MOCTypeName as MOCSource

	,B.MOCSourceAltKey
	,case when B.MOCType='auto' then 1 else 2 end as MOCTypeAlt_Key

	--,X.TotalOSBalance

	--,X.TotalInterestReversal

	--,X.TotalPrincOSBalance

	--,X.TotalInterestReceivabl

	--,X.TotalProvision

,IsNull(B.ModifiedBy,B.CreatedBy)as CrModBy
,IsNull(B.DateModified,B.DateCreated)as CrModDate
,ISNULL(B.ApprovedByFirstLevel,B.CreatedBy) as CrAppBy
,ISNULL(B.DateApprovedFirstLevel,B.DateCreated) as CrAppDate
,ISNULL(B.ApprovedByFirstLevel,B.ModifiedBy) as ModAppBy
,ISNULL(B.DateApprovedFirstLevel,B.DateModified) as ModAppDate		

	, B.ModifiedBy		

	,B.AuthorisationStatus
	,B.ApprovedByFirstLevel
	,B.DateApprovedFirstLevel

	,convert(varchar(20),@DateOfData,103) DateOfData
	--,B.MOC_ExpireDate
	,B.MOCType_Flag
	,B.SourceName
FROM #CUST_PREMOC A

	left JOIN #CUST_POSTMOC B

		on A.CustomerID =b.CustomerID

	LEFT JOIN DimAssetClass c

		ON C.AssetClassAlt_Key=a.AssetClassAlt_Key

		and c.EffectiveFromTimeKey<=@TimeKey and c.EffectiveToTimeKey>=@TimeKey 

	LEFT JOIN DimAssetClass d

		ON d.AssetClassAlt_Key=b.AssetClassAlt_Key

		and d.EffectiveFromTimeKey<=@TimeKey and d.EffectiveToTimeKey>=@TimeKey
 
 --SELECT * FROM CURDAT.AdvAcBalanceDetail
	--left Join (	SELECT  RefCustomerId,

	--					EffectiveFromTimeKey,

	--											EffectiveToTimeKey ,

	--											SUM(T.Balance) As TotalOSBalance, 

	--											Sum(T.IntReverseAmt)as TotalInterestReversal,

	--											0 as TotalPrincOSBalance ,

	--											0 as TotalInterestReceivabl,

	--											Sum(T.TotalProv) as TotalProvision

	--										 --FROM PRO.AccountCal_Hist as T
	--										 FROM CURDAT.AdvAcBalanceDetail T
	--										 Where RefCustomerId=@CustomerID

	--										 AND EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

	--										Group by T.RefCustomerId,T.EffectiveFromTimeKey,T.EffectiveToTimeKey 

	--								)	X

	--									On X.RefCustomerId=A.CustomerID




IF OBJECT_ID('tempdb..#MOCAuthorisation') IS NOT NULL  

BEGIN  

	DROP TABLE #MOCAuthorisation  

END





	  Select *,CAST('' AS varchar(MAX)) ErrorMessage,CAST('' AS varchar(MAX)) ErrorinColumn,
	    CAST('' AS varchar(MAX)) Srnooferroneousrows

 	   into #MOCAuthorisation 

	   from CalypsoCustomerLevelMOC_Mod A

	   where A.CustomerID=@CustomerID

	   AND A.EffectiveFromTimeKey<=@Timekey And A.EffectiveToTimeKey>=@Timekey

	   AND CustomerId is not null



	    AND A.Entity_Key IN

                     (

                         SELECT MAX(Entity_Key)

                         FROM CalypsoCustomerLevelMOC_Mod

                         WHERE EffectiveFromTimeKey <= @TimeKey

                               AND EffectiveToTimeKey >= @TimeKey

                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')

                         GROUP BY CustomerID

                     )

	   --Select ' #MOCAuthorisation',* from  #MOCAuthorisation

	   --where abc=1



	  UPDATE #MOCAuthorisation

	SET  

        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'You cannot perform MOC, Record is pending for authorization for this Customer ID. Kindly authorize or Reject the record through ‘Customer Level MOC – Authorization’ menu'     

						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for this Customer ID. Kindly authorize or Reject the record through ‘Customer Level MOC – Authorization’ menu'     END

		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerID' END   

	    

		FROM #MOCAuthorisation V  

  WHERE V.AuthorisationStatus in('NP','MP','DP','1A')

  AND CustomerID=@CustomerID

  AND @Operationflag not in(16,17,20)







  UPDATE #MOCAuthorisation

	SET  

        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'You cannot perform MOC, Record is pending for authorization for an Account ID '+A.AccountId+' under this Customer ID. Kindly authorize or Reject the record through ‘Account Level MOC – Authorization’ menu'     

						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for an Account ID '+A.AccountId+' under this Customer ID. Kindly authorize or Reject the record through ‘Account Level MOC – Authorization’ menu'     END

		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerID' END   

	 FRom CalypsoAccountLevelMOC_mod A

INNER Join InvestmentBasicDetail F on A.AccountID=F.InvID

--INNER join CustomerBasicDetail B On F.CustomerEntityId=B.CustomerEntityId

INNER Join #MOCAuthorisation G ON F.RefIssuerID=G.CustomerID

  WHERE A.AuthorisationStatus in ('NP','MP','DP','1A','FM')

  AND G.CustomerID=@CustomerID

  AND @Operationflag not in (16,17,20)




  UPDATE #MOCAuthorisation

	SET  

        ErrorMessage=CASE WHEN ISNULL(ErrorMessage,'')='' THEN 'You cannot perform MOC, Record is pending for authorization for an Account ID '+A.AccountId+' under this Customer ID. Kindly authorize or Reject the record through ‘Account Level MOC – Authorization’ menu'     

						ELSE ErrorMessage+','+SPACE(1)+'You cannot perform MOC, Record is pending for authorization for an Account ID '+A.AccountId+' under this Customer ID. Kindly authorize or Reject the record through ‘Account Level MOC – Authorization’ menu'     END

		,ErrorinColumn=CASE WHEN ISNULL(ErrorinColumn,'')='' THEN 'CustomerID' ELSE   ErrorinColumn +','+SPACE(1)+'CustomerID' END   

	 FRom CalypsoAccountLevelMOC_mod A

INNER Join curdat.DerivativeDetail F on A.AccountID=F.DerivativeRefNo

--INNER join CustomerBasicDetail B On F.CustomerEntityId=B.CustomerEntityId

INNER Join #MOCAuthorisation G ON F.CustomerID = G.CustomerID

  WHERE A.AuthorisationStatus in ('NP','MP','DP','1A','FM')

  AND G.CustomerID=@CustomerID

  AND @Operationflag not in (16,17,20)






  IF EXISTS(SELECT 1 FROM #MOCAuthorisation WHERE Customerid=@CustomerID --AND ISNULL(ERRORDATA,'')<>''

		) 

	BEGIN

	PRINT 'ERROR'

	if(@operationflag not in(16,17,20))

	begin

		SELECT distinct ErrorMessage

		ErrorinColumn,'Validation'TableName

		FROM #MOCAuthorisation

		END



end



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

	





-------------------------------

--				ADVSECURITYDETAIL



--			select * from ADVSECURITYDETAIL --ExceptionFinalStatusType

--select * from AdvSecurityVALUEDetail 

-----AdvSecurityDetail

				



	










GO
