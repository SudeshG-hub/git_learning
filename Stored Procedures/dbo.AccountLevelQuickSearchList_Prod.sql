SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE PROC [dbo].[AccountLevelQuickSearchList_Prod]
					@ACID varchar(30)=''
					,@CustomerId VARCHAR(20)=''
					,@CustomerName VARCHAR(20)=''
					,@UCICID VARCHAR(12)=''
					,@OperationFlag INT= 2
					,@newPage SMALLINT =1     
					,@pageSize INT = 30000
AS

	BEGIN
	
	Declare @Timekey INT

	DECLARE @PageFrom INT, @PageTo INT   
  
SET @PageFrom = (@pageSize*@newPage)-(@pageSize) +1  
SET @PageTo = @pageSize*@newPage 

 SET @Timekey =(Select TimeKey from SysDataMatrix where CurrentStatus='C') 

  SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 
	

		BEGIN
		print @Timekey

		DECLARE @AccountEntityID int = (select AccountEntityID from AdvAcBasicDetail where CustomerACID = @ACID and EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey)
		DECLARE @CustomerEntityID int
		if (@CustomerId != '')
		begin
		set @CustomerEntityID  = (select CustomerEntityID from CustomerBasicDetail where CustomerId = @CustomerId and EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey)
		end
		else
		begin
		set @CustomerEntityID  = (select CustomerEntityID from AdvAcBasicDetail where CustomerACID = @ACID and EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey)
		end 
		DECLARE @UCIFEntityID int = (select top 1 UcifEntityID from CustomerBasicDetail where UCIF_ID = @UCICID and EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey)

		DROP TABLE IF EXISTS #TEmp
		select A.AccountID,AuthorisationStatus into #Temp from Accountlevelmoc_mod A
		inner join(
		select max(EntityKey) EntityKey,AccountID 
		                                 from Accountlevelmoc_mod
		                                 where EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey
										 group by AccountID)B on B.EntityKey=A.EntityKey
			
		DROP TABLE IF EXISTS #ACCOUNTCAL_hIST
		DROP TABLE IF EXISTS #CUSTOMERCAL_hIST			 
SELECT * 
INTO #ACCOUNTCAL_hIST 
FROM [PRO].AccountCal_Hist 
WHERE EffectiveFromTimeKey = @Timekey AND EffectiveToTimeKey = @Timekey
AND  (						AccountEntityID=@AccountEntityID
								OR CustomerEntityID=@CustomerEntityID
								OR UcifEntityID=@UCIFEntityID
						)


SELECT * INTO #CustomerCAL_hIST 
FROM [PRO].CustomerCal_Hist 
WHERE EffectiveFromTimeKey = @Timekey 
AND EffectiveToTimeKey = @Timekey 
AND  ( CustomerEntityID=@CustomerEntityID
								--OR B.CustomerName like '%' + @CustomerName+ '%'
								OR UcifEntityID=@UCIFEntityID
						)
		
		 	IF ((@CustomerId ='') AND  (@CustomerName='') AND (@UCICID ='' ) AND (@ACID='')  AND (@operationflag not in(16,20)))
		BEGIN
		print '111'
		select * from (
			select distinct A.CustomerACID as ACID
					   ,A.RefCustomerId
					   ,B.CustomerName
					   ,B.UCIF_ID as UCICID
					    ,case when C.AuthorisationStatus IN ('FM','MP','NP')
					         then 'Pending'
							 when C.AuthorisationStatus IN ('A','R')
							 Then 'Authorise'
							 else 'No MOC Done ' End As AuthorisationStatus 
					   ,'AccountLevel' as TableName
					   ,Row_Number()over (order by (select 1)) RowNumber 
				 from #ACCOUNTCAL_hIST A
						 inner join #CustomerCAL_hIST B ON A.CustomerEntityId=B.CustomerEntityId 
						                                   
						 --INNER JOIN Accountlevelmoc_mod C ON C.AccountID=A.CustomerAcID
						 LEFT JOIN #TEmp C on C.AccountID=A.CustomerAcID
		 	


				 Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					   --and C.EffectiveFromTimeKey <= @Timekey
					   --AND c.EffectiveToTimeKey >= @Timekey
					   ) A
					    WHERE RowNumber BETWEEN @PageFrom AND @PageTo
						order by 	RowNumber 	 
				 return;
		END

		IF @CustomerId =''
		   SET @CustomerId=NULL

		IF @CustomerName =''
		   SET @CustomerName=NULL

		IF @UCICID =''
		   SET @UCICID=NULL

		IF (@OperationFlag not in(16,20))
		


				BEGIN
				
				select A.CustomerACID as ACID
					   ,A.RefCustomerId
					   ,B.CustomerName
					   ,B.UCIF_ID as UCICID
					   ,'AccountLevel' as TableName
				 from #ACCOUNTCAL_hIST A
						 inner join #CustomerCAL_hIST B
						 ON A.CustomerEntityId=B.CustomerEntityId
						
				
				END

		END

		IF (@OperationFlag in (16))
		BEGIN
				select * from (
				select A.AccountID as ACID
					   ,B.RefCustomerId
					   ,B.CustomerName
					   ,B.UCIF_ID as UCICID
					   ,'AccountLevel' as TableName
					    ,Row_Number()over (order by (select 1)) RowNumber 
				 from Accountlevelmoc_mod A
				        inner join #ACCOUNTCAL_hIST C ON C.CustomerAcID=A.AccountID
						 inner join #CustomerCAL_hIST B
						                 ON C.RefCustomerID=B.Refcustomerid
				 Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					  
					    AND ISNULL(A.AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM') 
					--AND  (A.AccountID=@ACID
					--OR B.RefCustomerId=@CustomerId
					--   OR B.CustomerName like '%' + @CustomerName+ '%'
					--   OR B.UCIF_ID=@UCICID)
					 ) A
					    WHERE RowNumber BETWEEN @PageFrom AND @PageTo
						order by 	RowNumber 



		END

		IF (@OperationFlag in (20))
		BEGIN
		select * from (
				select A.AccountID as ACID
					   ,B.RefCustomerId
					   ,B.CustomerName
					   ,B.UCIF_ID as UCICID
					   ,'AccountLevel' as TableName
					    ,Row_Number()over (order by (select 1)) RowNumber 
				from Accountlevelmoc_mod A
				        inner join #ACCOUNTCAL_hIST  C ON C.CustomerAcID=A.AccountID
						 inner join #CustomerCAL_hIST B
						                 ON C.RefCustomerID=B.Refcustomerid
						                 AND B.EffectiveFromTimeKey <= @Timekey
						                 AND B.EffectiveToTimeKey >= @Timekey
				 Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey					  
					    AND ISNULL(A.AuthorisationStatus, 'A') IN('1A') 
					--AND  (A.AccountID=@ACID
					--OR B.RefCustomerId=@CustomerId
					--   OR B.CustomerName like '%' + @CustomerName+ '%'
					--   OR B.UCIF_ID=@UCICID)
					 ) A
					    WHERE RowNumber BETWEEN @PageFrom AND @PageTo
						order by 	RowNumber
	END
	END









GO
