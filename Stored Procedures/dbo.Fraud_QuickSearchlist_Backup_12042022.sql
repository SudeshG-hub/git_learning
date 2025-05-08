SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec [dbo].[Fraud_QuickSearchlist] 1,24738,'',1,1000
CREATE PROC [dbo].[Fraud_QuickSearchlist_Backup_12042022]

--Declare
--@PageNo         INT         = 1, 
--@PageSize       INT         = 10, 
@OperationFlag  INT         = 1
,@MenuID  INT  = 24738
,@Account_id VARCHAR(30)=''
	,@newPage SMALLINT =1     
,@pageSize INT = 10000
AS
     

     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
					
Declare @Authlevel InT
 
select @Authlevel=AuthLevel from SysCRisMacMenu  
 where MenuId=@MenuID
  --select * from 	SysCRisMacMenu where menucaption like '%Branch%'
BEGIN TRY


IF OBJECT_ID('TempDB..#CustNPADetail') is not null
Drop Table #CustNPADetail

Select A.RefCustomerID,A.Cust_AssetClassAlt_Key Into #CustNPADetail from dbo.AdvCustNPADetail A
Inner Join (Select RefCustomerID,Min(EffectiveFromTimeKey)EffectiveFromTimeKey from AdvCustNPADetail Group By RefCustomerID) B ON A.RefCustomerID=B.RefCustomerID 
And A.EffectiveFromTimeKey=B.EffectiveFromTimeKey




/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */
          IF (@Account_id ='' or (@Account_id is null)) 
		  Begin

		   IF(@OperationFlag not in (16,17,20))
             BEGIN
			 print 'Prashant'


			 IF OBJECT_ID('TempDB..#temp_Fraud') IS NOT NULL
                 DROP TABLE  #temp_Fraud;
                 SELECT		-- A.Account_ID
				            AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp_Fraud
                 FROM 
                 (
                     SELECT  --A.Account_ID
					       B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated as DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,NULL AS ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.ApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.DateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.ApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.DateApproved,A.DateModified) as ModAppDate		
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'A')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'A')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'A')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'A') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,'' AS changeFields
	                  FROM		  Fraud_Details A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND         A.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					 
					  WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey

						    AND ISNULL(A.AuthorisationStatus, 'A') = 'A'

                     UNION
					  SELECT 
                            B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate	
					       , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,a.changeFields
	                  FROM Fraud_Details_Mod A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
                           WHERE B.EffectiveFromTimeKey <= @TimeKey
						   and B.EffectiveToTimeKey >= @TimeKey
						   -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						    AND ISNULL(A.AuthorisationStatus, 'A') IN  ('NP', 'MP', 'DP', 'RM','1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN ('NP', 'MP', 'DP','D1', 'RM','1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY   AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--A.changeFields

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp_Fraud A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END
			 
 

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */

			 IF(@OperationFlag in (16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
print 'Prashant1'
                 SELECT		 AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp16
                 FROM 
                 (
                   SELECT 
                            B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate	
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1		
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM Fraud_Details_Mod A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						    AND ISNULL(A.AuthorisationStatus, 'A') IN  ('NP', 'MP')
                             AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN ('NP', 'MP', 'DP','D1', 'RM','1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY	 AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp16 A
						 
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

   

    IF (@OperationFlag =20)
             BEGIN

    IF OBJECT_ID('TempDB..#temp20') IS NOT NULL
                 DROP TABLE #temp20;
	print 'Prashant2'
                 SELECT		AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp20
                 FROM 
                 (
                    SELECT 
                             B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM Fraud_Details_Mod A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') IN('1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               --AND ISNULL(A.AuthorisationStatus, 'A') IN('1A')
							    AND (case when @AuthLevel =2  AND ISNULL(AuthorisationStatus, 'A') IN('1A','D1')
										THEN 1 
							           when @AuthLevel =1 AND ISNULL(AuthorisationStatus,'A') IN ('NP','MP','DP')
										THEN 1
										ELSE 0									
										END
									)=1
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY	 AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields


                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp20 A
						 
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)
  END
  END;

  ------------------------------------------------------------------------------------------------
  ELSE
  ------------------------------------------------------------
   BEGIN
        
		
		   IF(@OperationFlag not in (16,17,20))
             BEGIN
		
			 IF OBJECT_ID('TempDB..#temp_Fraud1') IS NOT NULL
                 DROP TABLE  #temp_Fraud1;
			IF (select count(1) 
				from Fraud_Details_Mod 
				where RefCustomerACID=@Account_id
				AND EffectiveFromTimeKey <= @TimeKey
                 AND EffectiveToTimeKey >= @TimeKey) = 0
				 	 
				 BEGIN

				 PRINT 'Sachin'
			 SELECT		-- A.Account_ID
				           AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
						
							--,A.changeFields
                 INTO #temp_Fraud11
                 FROM 
                 (
					  SELECT 
                             B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,cast(H.NPADt as date) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate
						   
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1		
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM Fraud_Details_Mod A 
				      Right JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.CustomerACID=@Account_id
					        AND B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						    --AND ISNULL(B.AuthorisationStatus, 'A') IN  ('NP', 'MP', 'DP', 'RM','1A')
                     --      AND A.EntityKey IN
                     --(
                     --    SELECT MAX(EntityKey)
                     --    FROM Fraud_AWO_Mod
                     --    WHERE EffectiveFromTimeKey <= @TimeKey
                     --          AND EffectiveToTimeKey >= @TimeKey
                     --          AND ISNULL(AuthorisationStatus, 'A') IN ('NP', 'MP', 'DP','D1', 'RM','1A')
                     --    GROUP BY Account_ID
                     --)
                 ) A 
                      
                 
                 GROUP BY   AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							
							--A.changeFields

							  SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp_Fraud11 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
							END

			ELSE 

			BEGIN
                 SELECT		-- A.Account_ID
				           AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp_Fraud1
                 FROM 
                 (
                     SELECT  --A.Account_ID
					       B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,NULL as ChangeFields
							,A.screenFlag
					 ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate		
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,a.changeFields
	                  FROM Fraud_Details A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.CustomerACID=@Account_id
					        AND B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						    AND ISNULL(A.AuthorisationStatus, 'A') = 'A'

                     UNION
					  SELECT 
                             B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate	
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM		  Fraud_Details_Mod A 
				      Right JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.CustomerACID=@Account_id
					        AND B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						    AND ISNULL(A.AuthorisationStatus, 'A') IN  ('NP', 'MP', 'DP', 'RM','1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN ('NP', 'MP', 'DP','D1', 'RM','1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY   AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
				            --,A.changeFields

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp_Fraud1 A
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
				  END
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             end
			 
 

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */

			 IF(@OperationFlag in (16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp161') IS NOT NULL
                 DROP TABLE #temp161;
	print 'Prashant4'
                 SELECT		AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp161
                 FROM 
                 (
                   SELECT 
                            B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate	
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1		
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM Fraud_Details_Mod A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.CustomerACID=@Account_id
					        AND B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   -- AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						    AND ISNULL(A.AuthorisationStatus, 'A') IN  ('NP', 'MP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY	AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 SELECT *
                 FROM
   (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp161 A
						 
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

   

    IF (@OperationFlag =20)
             BEGIN

    IF OBJECT_ID('TempDB..#temp201') IS NOT NULL
                 DROP TABLE #temp201;
	print 'Prashant5'
                 SELECT		AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 INTO #temp201
                 FROM 
                 (
                    SELECT 
                             B.AccountEntityId
							,B.CustomerEntityId
							,B.CustomerACID as RefCustomerACID
							,B.RefCustomerID
							,SourceName
							,E.BranchCode
							,E.BranchName
							,F.AcBuSegmentCode
							,F.AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,Balance as TOS				
							,PrincipalBalance as POS
							,(case when R.AssetClassName is null then 'STANDARD' else R.AssetClassName end) as AssetClassAtFraud
							,(CASE WHEN cast(NPA_DateAtFraud as date) = '01/01/1900' THEN '' ELSE cast(NPA_DateAtFraud as date) END) as NPADateAtFraud
							,RFA_ReportingByBank
							,(CASE WHEN cast(RFA_DateReportingByBank as date) = '01/01/1900' THEN '' ELSE cast(RFA_DateReportingByBank as date) END) RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,(CASE WHEN cast(RFA_OtherBankDate as date) = '01/01/1900' THEN '' ELSE cast(RFA_OtherBankDate as date) END) RFA_OtherBankDate
							,(CASE WHEN cast(FraudOccuranceDate as date) = '01/01/1900' THEN '' ELSE cast(FraudOccuranceDate as date) END) FraudOccuranceDate
							,(CASE WHEN cast(FraudDeclarationDate as date) = '01/01/1900' THEN '' ELSE cast(FraudDeclarationDate as date) END)FraudDeclarationDate
							,FraudNature
							,FraudArea
							,L.AssetClassName as CurrentAssetClassName
							,H.Cust_AssetClassAlt_Key  as CurrentAssetClassAltKey
							,cast(H.NPADt as date) as CurrentNPA_Date
							,ProvPref as Provisionpreference
							,(CASE WHEN A.AuthorisationStatus is not NULL THEN A.AuthorisationStatus ELSE NULL END)  AuthorisationStatus
							,B.EffectiveFromTimeKey
							,B.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated DateCreated
							,A.ModifiedBy
							,A.DateModified  DateModified
							,A.ApprovedBy
							,A.DateApproved DateApproved
							,FirstLevelApprovedBy as ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.FraudAccounts_ChangeFields as ChangeFields
							,A.screenFlag
					       ,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy  
                           ,IsNull(A.DateModified,A.DateCreated)as CrModDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.CreatedBy) as CrAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateCreated) as CrAppDate  
                           ,ISNULL(A.FirstLevelApprovedBy,A.ModifiedBy) as ModAppBy  
                           ,ISNULL(A.FirstLevelDateApproved,A.DateModified) as ModAppDate	
						   , CASE WHEN  ISNULL(A.AuthorisationStatus,'Z')='A' THEN 'Authorized'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='R' THEN 'Rejected'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z')='1A' THEN '2nd Level Authorization Pending'
								  WHEN  ISNULL(A.AuthorisationStatus,'Z') IN ('NP','MP') THEN '1st Level Authorization Pending' ELSE NULL END AS AuthorisationStatus_1	
								  --,a.changeFields
      --               FROM Fraud_AWO A
					 --WHERE A.EffectiveFromTimeKey <= @TimeKey
      --               AND A.EffectiveToTimeKey >= @TimeKey
      --               AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
	                  FROM Fraud_Details_Mod A 
				      INNER JOIN  AdvAcBasicDetail B
					  ON          A.RefCustomerAcid=B.CustomerACID  AND A.EffectiveFromTimeKey <= @TimeKey 
					  AND A.EffectiveToTimeKey >= @TimeKey
					   INNER JOIN  AdvAcBalanceDetail J
					  ON          B.AccountEntityId = J.AccountEntityId  AND J.EffectiveFromTimeKey <= @TimeKey 
					  AND         J.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMSOURCEDB C
					  ON          B.SourceAlt_Key=C.SourceAlt_Key 
					  AND         C.EffectiveFromTimeKey <= @TimeKey AND C.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  CustomerBasicDetail D
					  ON          D.CustomerId=B.RefCustomerId
					  AND         D.EffectiveFromTimeKey <= @TimeKey AND D.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMBRANCH E
					  ON          B.BranchCode=E.BranchCode
					  AND         E.EffectiveFromTimeKey <= @TimeKey AND E.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DimAcBuSegment  F
					  ON		  B.segmentcode=F.AcBuSegmentCode
					  AND         F.EffectiveFromTimeKey <= @TimeKey AND F.EffectiveToTimeKey >= @TimeKey
					  LEFT JOIN  DIMPRODUCT G
					  ON          B.ProductAlt_Key=G.ProductAlt_Key
					  AND         G.EffectiveFromTimeKey <= @TimeKey AND G.EffectiveToTimeKey >= @TimeKey
					  LEFT join  AdvCustNpaDetail H
					  ON          D.CustomerEntityId=H.CustomerEntityId
					  AND         H.EffectiveFromTimeKey <= @TimeKey AND H.EffectiveToTimeKey >= @TimeKey
					   LEFT JOIN  DIMASSETCLASS I
					  ON          A.AssetClassAtFraudAltKey=I.AssetClassAlt_Key
					  AND		I.EffectiveToTimeKey = 49999
					  LEFT JOIN  DIMASSETCLASS L
					  ON          H.Cust_AssetClassAlt_Key=L.AssetClassAlt_Key
					  AND         L.EffectiveToTimeKey = 49999
					  Left join  #CustNPADetail Q
					  ON         Q.RefCustomerID=D.CustomerId

					  LEFT JOIN   DimAssetClass R
					  ON          Q.Cust_AssetClassAlt_Key=R.AssetClassAlt_Key
					  AND         R.EffectiveToTimeKey = 49999
					  WHERE B.CustomerACID=@Account_id
					        AND B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') IN('1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM Fraud_Details_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               --AND ISNULL(A.AuthorisationStatus, 'A') IN('1A')
							    AND (case when @AuthLevel =2  AND ISNULL(AuthorisationStatus, 'A') IN('1A','D1')
										THEN 1 
							           when @AuthLevel =1 AND ISNULL(AuthorisationStatus,'A') IN ('NP','MP','DP')
										THEN 1
										ELSE 0									
										END
									)=1
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY	AccountEntityId
							,CustomerEntityId
							,RefCustomerACID
							,RefCustomerID
							,SourceName
							,BranchCode
							,BranchName
							,AcBuSegmentCode
							,AcBuSegmentDescription
							,UCIF_ID 							
							,CustomerName	
							,TOS				
							,POS
							,AssetClassAtFraud
							,NPADateAtFraud
							,RFA_ReportingByBank
							,RFA_DateReportingByBank
							,RFA_OtherBankAltKey
							,RFA_OtherBankDate
							,FraudOccuranceDate
							,FraudDeclarationDate
							,FraudNature
							,FraudArea
							,CurrentAssetClassName
							,CurrentAssetClassAltKey
							,CurrentNPA_Date
							,Provisionpreference
							,A.AuthorisationStatus
							,A.EffectiveFromTimeKey
							,A.EffectiveToTimeKey
							,A.CreatedBy
							,A.DateCreated
							,A.ModifiedBy
							,A.DateModified
							,A.ApprovedBy
							,A.DateApproved
							,ApprovedByFirstLevel
							,FirstLevelDateApproved 
							,A.ChangeFields
							,A.screenFlag
							,A.CrModBy
							,A.CrModDate
							,A.CrAppBy
							,A.CrAppDate
							,A.ModAppBy
							,A.ModAppDate
							,A.AuthorisationStatus_1
							--,A.changeFields
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY RefCustomerACID) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'Fraud' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp201 A
						 
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
				  Order By DataPointOwner.DateCreated Desc
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)
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
