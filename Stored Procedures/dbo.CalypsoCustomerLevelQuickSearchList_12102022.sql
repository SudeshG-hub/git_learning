SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--USE [USFB_ENPADB]
--GO
--/****** Object:  StoredProcedure [dbo].[CalypsoCustomerLevelQuickSearchList]    Script Date: 18-11-2021 13:33:01 ******/
--DROP PROCEDURE [dbo].[CalypsoCustomerLevelQuickSearchList]
--GO
--/****** Object:  StoredProcedure [dbo].[CalypsoCustomerLevelQuickSearchList]    Script Date: 18-11-2021 13:33:01 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--exec CalypsoCustomerLevelQuickSearchList @CustomerId=N'22552793',@CustomerName=N'',@UCICID=N'',@OperationFlag=2,@newPage=1,@pageSize=1000
--go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE PROC [dbo].[CalypsoCustomerLevelQuickSearchList_12102022]
--declare
					--@UCICID VARCHAR(20)=''
					@CustomerName VARCHAR(100)=''
					,@UCICID VARCHAR(20)=''
					,@OperationFlag INT=2

					,@newPage SMALLINT =1     
					,@pageSize INT = 30000 
					
AS
	BEGIN

	Declare @Timekey INT

	  

DECLARE @PageFrom INT, @PageTo INT   
  
SET @PageFrom = (@pageSize*@newPage)-(@pageSize) +1  
SET @PageTo = @pageSize*@newPage  

	Declare @ExtDate Date
	SET @Timekey =(Select Timekey from SysDataMatrix Where ISNULL(MOC_Initialised,'N')='Y' AND ISNULL(MOC_Frozen,'N')='N') 

	SET @ExtDate=(Select Distinct ExtDate from SysDataMatrix Where ISNULL(MOC_Initialised,'N')='Y' AND ISNULL(MOC_Frozen,'N')='N') 
	
		print @Timekey
		---select customerid and auth status
	--	Drop Table  IF Exists #Temp

	
	--	select A.CustomerID,AuthorisationStatus into #Temp 
	--	from Customerlevelmoc_mod  A
	--	inner join(
	
	--SELECT MAX(Entity_Key) Entity_Key,CustomerID
 --                                        FROM Customerlevelmoc_mod
 --                                         WHERE EffectiveFromTimeKey <= @Timekey
 --                                             AND EffectiveToTimeKey >= @Timekey --AND ISNULL(ScreenFlag,'U') NOT IN('U','')
                             
 --                                     GROUP BY CustomerID) B on B.Entity_Key=A.Entity_Key 

	----Select '#Temp',* from #Temp
	IF (@UCICID ='' OR @UCICID IS NULL) 
	  
	  begin

		 if (@operationflag not in(16,20))
		BEGIN
		print '111'
		PRINT'54'


		--		DROP TABLE IF EXISTS #TEmp

		--select A.CustomerEntityID,AuthorisationStatus into #Temp from CustomerLevelMOC_Mod A
		--inner join(
		--select max(Entity_Key) EntityKey,CustomerEntityID 
		--                                 from CustomerLevelMOC_Mod
		--                                 where EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey
		--								 group by CustomerEntityID)B on B.EntityKey=A.Entity_Key
										 
		select distinct T.UcifId UCICID
					   ,T.IssuerName CustomerName
					   ,T.UCIFID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoInvMOC_ChangeDetails A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				 INNER  JOIN InvestmentIssuerDetail  T  ON
				 -- T.IssuerEntityID=A.CustomerEntityid
				 T.UcifId=@UCICID
				 AND  T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey  
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					   AND A.MOCType_Flag='CUST'
					   AND A.AuthorisationStatus='A'
					   AND  A.CustomerEntityID NOT IN (SELECT CustomerEntityId FROM CustomerLevelMOC_Mod 
					                                   WHERE AuthorisationStatus IN ('MP','NP','1A')
													   AND EffectiveFromTimeKey<=@Timekey
					                                   AND EffectiveToTimeKey >= @Timekey )
					 -- AND ISNULL(ScreenFlag,'U') NOT IN('U','')
					 --and t.IssuerId=@customerid and t.UcifId=@UCICID 
					 --AND t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' 
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 


				
	             UNION

				     	
		select distinct T.CustomerId
					   ,T.CustomerName
					   ,T.UCIC_ID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID  AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					    AND A.AuthorisationStatus IN ('MP','NP','1A')
						--and t.customerid=@CustomerId and t.Ucic_Id=@UCICID 
						--AND t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%' 
					 and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%' 
				
			--	select * from (
			--select distinct 
			--		   B.CustomerId
			--		   ,B.CustomerName
			--		   ,B.UCIF_ID as UCICID
			--		    ,case when C.AuthorisationStatus IN ('FM','MP','NP')
			--		         then 'Pending'
			--				 when C.AuthorisationStatus IN ('A','R')
			--				 Then 'Authorise'
			--				 else 'No MOC Done ' End As AuthorisationStatus 
			--		   ,'CustomerLevel' as TableName
			--		   ,Row_Number()over (order by (select 1)) RowNumber 
			--	 from MOC_ChangeDetails A
			--			 --inner join Pro.customercal_hist B ON A.CustomerEntityId=B.CustomerEntityId 
			--			 inner join CURDAT.CustomerBasicDetail B ON A.CustomerEntityId=B.CustomerEntityId 
			--			 AND B.EffectiveFromTimeKey <= @Timekey AND B.EffectiveToTimeKey >= @Timekey
			--			 --INNER JOIN Accountlevelmoc_mod C ON C.AccountID=A.CustomerAcID
			--			 LEFT JOIN #TEmp C on C.CustomerEntityID=A.CustomerEntityID
		 	


			--	 Where A.EffectiveFromTimeKey <= @Timekey
			--		   AND A.EffectiveToTimeKey >= @Timekey
			--		   --and C.EffectiveFromTimeKey <= @Timekey
			--		   --AND c.EffectiveToTimeKey >= @Timekey
			--		   ) A




	
	
END


		IF (@OperationFlag in (16))
		BEGIN
			print '113'
				     	
		select distinct T.IssuerID CustomerId
					   ,T.IssuerName CustomerName
					   ,T.UCIFID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				 INNER JOIN InvestmentIssuerDetail   T  ON 
				 T.UcifId=@UCICID
				 --T.IssuerEntityID=A.CustomerEntityID 
				 AND  T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					  AND A.AuthorisationStatus IN ('MP','NP','DP','RM')
					  AND A.MOCType_Flag='CUST'
					  --and t.IssuerId=@customerid
					  -- and t.UcifId=@UCICID 
					  --AND t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' 
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 
		
			             UNION

				     	
		select distinct T.CustomerId
					   ,T.CustomerName
					  ,T.UCIC_ID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					    AND A.AuthorisationStatus IN ('MP','NP','DP','RM')
						--and t.customerid=@customerid and t.Ucic_Id=@UCICID 
						--AND t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%' 
					 and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%' 
		
		
		END

		IF (@OperationFlag in (20))
		BEGIN
			print '114'
					     	
		select distinct T.IssuerID CustomerId
					   ,T.IssuerName CustomerName
			     	   ,T.UCIFID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				 INNER JOIN InvestmentIssuerDetail   T  ON T.UcifId=@UCICID AND  T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					  AND A.AuthorisationStatus IN ('1A')
					  AND A.MOCType_Flag='CUST'
					  --and IssuerId=@customerid and t.UcifId=@UCICID 
					  --AND t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' 
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 
		
		 UNION

				     	
		select distinct T.CustomerId
					   ,T.CustomerName
					   ,T.UCIC_ID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					    AND A.AuthorisationStatus IN ('1A')
						--and t.customerid=@customerid and t.Ucic_Id=@UCICID 
		--AND t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%' 
					 and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%' 
		
		
		END

	END


 ELSE
       Begin
	   DECLARE @CustomerEntityID INT
	   SET  @CustomerEntityID =(SELECT IssuerEntityID  FROM   InvestmentIssuerDetail  A
												WHERE A.UcifId=@UCICID  AND A.EffectiveFromTimeKey<=@Timekey
					                    AND A.EffectiveToTimeKey >= @Timekey)

	
	   PRINT 'Sac1'

	    if (@operationflag not in(16,20)) AND(@UCICID<>'' OR @UCICID<>NULL)
		Begin
		   IF EXISTS (SELECT 1 FROM CalypsoInvMOC_ChangeDetails WHERE CustomerEntityID =@CustomerEntityID  AND EffectiveFromTimeKey<=@Timekey
					                    AND EffectiveToTimeKey >= @Timekey  AND AuthorisationStatus='A')

		BEGIN
		print '111'
		PRINT  '45'
		select distinct T.IssuerID CustomerId
					   ,T.IssuerName CustomerName
					  ,T.UCIFID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoInvMOC_ChangeDetails A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER  JOIN InvestmentIssuerDetail  T  ON T.UcifId=@UCICID
				 AND  T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 
					   AND T.UcifId=@UCICID
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					   AND A.AuthorisationStatus='A'
					   AND A.MOCType_Flag='CUST'
					   AND T.UcifId=@UCICID
					 --  AND ISNULL(ScreenFlag,'U') NOT IN('U','')
					-- and IssuerId=@customerid and t.UcifId=@UCICID 
					--AND t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' 
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 

					 		 UNION

				     	
		select distinct T.CustomerId
					   ,T.CustomerName
					   ,T.UCIC_ID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID  AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					    AND A.AuthorisationStatus IN ('A')
						--and t.CustomerID =@CustomerId and t.Ucic_Id=@UCICID 
						--AND t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%' 
					 and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%' 
			END	
		
 ELSE IF EXISTS (SELECT 1 FROM CalypsoCustomerLevelMOC_Mod WHERE CustomerEntityID =@CustomerEntityID  AND EffectiveFromTimeKey<=@Timekey
					                    AND EffectiveToTimeKey >= @Timekey  AND AuthorisationStatus IN ('MP','NP','1A'))
BEGIN     	

 PRINT 'Sac2'
		select distinct T.IssuerID CustomerId
					   ,T.IssuerName CustomerName
					   ,T.UCIFID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				 INNER JOIN InvestmentIssuerDetail T  ON T.UcifId=@UCICID
				 AND  T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					  AND A.AuthorisationStatus IN ('MP','NP','1A')
					  AND A.MOCType_Flag='CUST'
					--AND A.CustomerId=@CustomerId and t.UcifId=@UCICID 
					--AND t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' 
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 
					
					 		 UNION

				     	
		select distinct T.CustomerId
					   ,T.CustomerName
					   ,T.UCIC_ID as UCICID
					   ,case when isnull(A.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(A.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(A.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey 
					    AND A.AuthorisationStatus IN ('MP','NP','1A')

						--and t.customerid=@customerid and t.Ucic_Id=@UCICID
						--AND t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%' 
					 and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%'  

END
ELSE 
BEGIN


 PRINT 'Sac3'
select distinct T.IssuerID CustomerId
					   ,T.IssuerName CustomerName
					,T.UCIFID as UCICID
					   ,'No MOC Done' AuthorisationStatus 
					   
					   	   ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate 
						   ,'CalypsoCustomerLevel' as TableName
				 from InvestmentIssuerDetail T  
				 where (T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey )
				
				--AND  (t.IssuerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.IssuerId ELSE @CustomerId END+'%' )
					  
					 and t.UcifId LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.UcifId ELSE @UCICID  END+'%' 


					UNION

				     	
		select distinct T.CustomerID CustomerId
					   ,T.CustomerName CustomerName
					  ,T.UCIC_ID as UCICID
					   ,'No MOC Done' AuthorisationStatus 
							 ,Convert(Varchar(10),@ExtDate,103) As MOCMonthEndDate
					   ,'CalypsoCustomerLevel' as TableName
				 from CalypsoCustomerLevelMOC_Mod A
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  INNER JOIN curdat.DerivativeDetail  T  ON T.UCIC_ID=@UCICID AND                                                   
				 T.EffectiveFromTimeKey<=@Timekey
					   AND T.EffectiveToTimeKey >= @Timekey 

				 where (A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey) --and T.CustomerId=@CustomerId
					   --AND (t.CustomerId LIKE '%'+CASE WHEN ISNULL(@CustomerId,'')='' THEN t.CustomerId ELSE @CustomerId END+'%')
					 
					and t.Ucic_Id LIKE '%'+CASE WHEN ISNULL(@UCICID ,'')='' THEN t.Ucic_Id ELSE @UCICID  END+'%' 	
END
END
END
END
GO
