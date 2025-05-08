SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC [dbo].[CollateralValueEnquireSearchTaggingList_Prod]

--Declare
													
													--@PageNo         INT         = 1, 
													--@PageSize       INT         = 10, 
													--@OperationFlag  INT         = 1  --,
													--,@CustomerID	Varchar(100)	= NULL
													 @TaggingId		Varchar(100)	=NULL
													--,@UCICID		Varchar(12)	=	NULL
													,@Cust_AcID_UCIF  Varchar(100)	=NULL 
AS
     
	 --BEGIN


SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
					

			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
              
                     SELECT	  B.RefSystemAcId
					          ,B.UCICID
                             ,B.RefCustomerId

					         ,A.CollateralID
							,B.CollateralValueatSanctioninRs as CollateralValueatSanctioninRs
							,B.CollateralValueasonNPAdateinRs as CollateralValueasonNPAdateinRs
							,A.CurrentValue as CollateralValueatthetimeoflastreviewinRs
							--,A.ValuationSourceNameAlt_Key
							--,B.SourceName
							,convert(varchar(20),A.ValuationDate,103) ValuationDate
							,A.CurrentValue as LatestCollateralValueinRs
							,A.ExpiryBusinessRule
							,A.Periodinmonth
							,convert(varchar(20),A.ValuationExpiryDate,103) ValueExpirationDate
							--,C.ParameterName AS DisplayCollateralFor
							,B.TaggingAlt_Key
							,isnull(A.AuthorisationStatus, 'A') AuthorisationStatus, 
                            A.EffectiveFromTimeKey, 
                            A.EffectiveToTimeKey, 
                            A.CreatedBy, 
                            A.DateCreated, 
                            A.ApprovedBy, 
                            A.DateApproved, 
                            A.ModifiedBy, 
                            A.DateModified
							,(CASE WHEN B.TaggingAlt_Key=1 THEN B.RefCustomerId
							      WHEN B.TaggingAlt_Key=2 THEN B.RefSystemAcId
								  WHEN B.TaggingAlt_Key=4 THEN B.UCICID
								  END ) TaggingId
								  ,'CollateralSearchGridData' TableName
						INTO  #temp  
						
                     FROM Curdat.AdvSecurityDetail B
					 LEFT Join Curdat.AdvSecurityValueDetail A on  A.CollateralID = B.CollateralID
					 Inner Join DimParameter C on  B.TaggingAlt_Key = C.ParameterAlt_Key 
					                              AND C.DimParameterName='DimRatingType'

					 WHERE B.EffectiveFromTimeKey <= @TimeKey
                           AND B.EffectiveToTimeKey >= @TimeKey
						   AND A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'

						   AND @TaggingId=C.ParameterAlt_Key


						   AND (@TaggingId=1 AND B.RefCustomerId=@Cust_AcID_UCIF
						   OR   @TaggingId=2 AND B.RefSystemAcId=@Cust_AcID_UCIF
						   OR   @TaggingId=4 AND B.UCICID=@Cust_AcID_UCIF)
			
	select *   from #temp 
	  
	

	--select * from CollateralValueDetails
	--select * from CollateralMgmt
	--select * from DimParameter where DimParameterName='DimRatingType' 





GO
