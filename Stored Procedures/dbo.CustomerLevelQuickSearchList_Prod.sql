SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





CREATE PROC [dbo].[CustomerLevelQuickSearchList_Prod]
--declare
					@CustomerId VARCHAR(20)='60'
					,@CustomerName VARCHAR(100)=''
					,@UCICID VARCHAR(12)=''
					,@OperationFlag INT=2

					,@newPage SMALLINT =1     
					,@pageSize INT = 30000 
					
AS
	BEGIN

	Declare @Timekey INT

DECLARE @PageFrom INT, @PageTo INT   
  
SET @PageFrom = (@pageSize*@newPage)-(@pageSize) +1  
SET @PageTo = @pageSize*@newPage  


	Set @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C') 
	 SET @Timekey =(Select LastMonthDateKey from SysDayMatrix where Timekey=@Timekey) 
		
		print @Timekey
		---select customerid and auth status
		Drop Table  IF Exists #Temp

		select A.CustomerID,AuthorisationStatus into #Temp 
		from Customerlevelmoc_mod  A with (nolock)
		inner join(
		SELECT MAX(Entity_Key) Entity_Key,CustomerID
                                         FROM Customerlevelmoc_mod with (nolock)
                                          WHERE EffectiveFromTimeKey <= @Timekey
                                              AND EffectiveToTimeKey >= @Timekey --AND ISNULL(ScreenFlag,'U') NOT IN('U','')
                             
                                      GROUP BY CustomerID) B on B.Entity_Key=A.Entity_Key 



		 	IF ((@CustomerId ='') AND  (@CustomerName='') AND (@UCICID ='' ) AND (@operationflag not in(16,20)))
		BEGIN
		print '111'
		
			DROP TABLE IF EXISTS #tmp
		

		Select  Row_Number()over (order by  MOC_Dt desc) RowNumber,* into #tmp from (
		select distinct A.RefCustomerID CustomerId
					   ,A.CustomerName
					   ,A.UCIF_ID as UCICID
					   ,case when isnull(T.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(T.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(T.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
					   ,'CustomerLevel' as TableName
					   ,A.MOC_Dt
					    
				 from PRO.CustomerCal_Hist A  with (nolock)
				  --inner join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				 left JOIN #Temp  T with (nolock)  ON T.CustomerID=A.RefCustomerID
				 where A.EffectiveFromTimeKey<=@Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					  
					 --  AND ISNULL(ScreenFlag,'U') NOT IN('U','')
					)	X
					order by 	X.MOC_Dt desc
					
				
	   
				 Select * from #tmp with (nolock)
				 WHERE RowNumber BETWEEN @PageFrom AND @PageTo
				 
				 return;
		END
	

		IF @CustomerId =''
		   SET @CustomerId=NULL

		IF @CustomerName =''
		   SET @CustomerName=NULL

		IF @UCICID =''
		   SET @UCICID=NULL

		   print '1'
		   
		  

		IF (@OperationFlag not in(16,20) )
		BEGIN
				print '112'
				DROP TABLE IF EXISTS #tmp1 

		select Row_Number()over (order by  MOC_Dt desc) RowNumber,* into #tmp1 from (
				select distinct A.RefCustomerID CustomerId
					   ,A.CustomerName
					   ,A.UCIF_ID as UCICID
					   ,case when isnull(T.AuthorisationStatus,'') IN ('FM','MP','NP')
					         then 'Pending'
					         when isnull(T.AuthorisationStatus,'') IN ('1A')
							 Then '2nd Approval Pending'
					         
							 when isnull(T.AuthorisationStatus,'') IN ('A','R')
							 Then 'Authorised'
							 else 'No MOC Done' End As AuthorisationStatus 
					   ,'CustomerLevel' as TableName
					  ,A.MOC_Dt
				 from PRO.CustomerCal_Hist A  with (nolock)

				 --Left join Customerlevelmoc_mod B ON B.CustomerID=A.RefCustomerID
				  left JOIN #Temp  T with (nolock) ON T.CustomerID=A.RefCustomerID
				  Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					       --AND ISNULL(A.ScreenFlag,'U') NOT IN('U','')
					  AND  (A.RefCustomerID=@CustomerId)
					    OR ( A.CustomerName like '%' + @CustomerName+ '%')
					   or  (A.UCIF_ID=@UCICID)
					   )R 
					    
						
						order by MOC_Dt desc  
						
				Select * from #tmp1 with (nolock)
				 WHERE RowNumber BETWEEN @PageFrom AND @PageTo

		END

		IF (@OperationFlag in (16))
		BEGIN
			print '113'
			DROP TABLE IF EXISTS #tmp2

		select Row_Number()over (order by  MOCDate desc) RowNumber,* into #tmp2 from (
				select A.CustomerId
					   ,A.CustomerName
					   ,B.UCIF_ID as UCICID
					    ,AuthorisationStatus
					   ,'CustomerLevel' as TableName 
					  ,A.MOCDate 
				 from Customerlevelmoc_mod A  with (nolock)
				 
				 inner join PRO.CustomerCal_Hist B with (nolock)
				 ON A.CustomerID=B.RefCustomerID
				
				 AND B.EffectiveFromTimeKey <= @Timekey
					   AND B.EffectiveToTimeKey >= @Timekey
					    
						Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					   AND ISNULL(A.AuthorisationStatus, 'A') IN ('NP', 'MP', 'DP', 'RM')
					   AND ISNULL(A.ScreenFlag,'G') NOT IN('U')
					   --AND  (A.CustomerId=@CustomerId)
					   --OR (A.CustomerName like '%' + @CustomerName+ '%')
					   --OR (B.UCIF_ID=@UCICID)
					    )R 
					  
						order by 	MOCDate desc 

				Select * from #tmp2
				 WHERE RowNumber BETWEEN @PageFrom AND @PageTo

		END

		IF (@OperationFlag in (20))
		BEGIN
			print '114'

				DROP TABLE IF EXISTS #tmp3
		select   Row_Number()over (order by  MOCDate desc) RowNumber,* into #tmp3 from (
				select A.CustomerId
					   ,A.CustomerName
					   ,B.UCIF_ID as UCICID
					    ,AuthorisationStatus
					   ,'CustomerLevel' as TableName
					    ,A.MOCDate
				 from Customerlevelmoc_mod A  with (nolock)
				 
				 inner join PRO.CustomerCal_Hist B with (nolock)
				  ON A.CustomerID=B.RefCustomerID
				
				 AND B.EffectiveFromTimeKey <= @Timekey
					   AND B.EffectiveToTimeKey >= @Timekey

						Where A.EffectiveFromTimeKey <= @Timekey
					   AND A.EffectiveToTimeKey >= @Timekey
					   AND ISNULL(A.AuthorisationStatus, 'A') IN ('1A')
					       AND ISNULL(A.ScreenFlag,'G') NOT IN('U')
					   --AND  (A.CustomerId=@CustomerId)
					   --OR (A.CustomerName like '%' + @CustomerName+ '%')
					   --OR (B.UCIF_ID=@UCICID)
					   )R 
					    
				       order by 	MOCDate desc 

				Select * from #tmp3
				 WHERE RowNumber BETWEEN @PageFrom AND @PageTo

		END

	END
GO
