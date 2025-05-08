SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec [InvestmentIssuerQuickSearchlist] '0706','','',16
CREATE PROC [dbo].[InvestmentIssuerQuickSearchlist_24052022]
--Declare
													
													  @IssuerID			Varchar (100)		= ''
													 ,@IssuerName		Varchar (100)		= 'RAM'
													 ,@PanNo				varchar(10)			= ''
													--,@InvID				Varchar (100)		= ''
													--,@InstrTypeAlt_key	Varchar (100)		= ''
													--,@ISIN				varchar (100)		= ''
													 ,@OperationFlag		INT					= 1
AS
     
	 BEGIN

SET NOCOUNT ON;
Declare @TimeKey as Int
	SET @Timekey =(Select Timekey from SysDataMatrix where CurrentStatus='C')
				PRINT 	@Timekey


				
--		 	IF ((@PanNo ='') AND  (@IssuerID='') AND (@IssuerName ='' ) AND  (@operationflag not in(16,20)))
--		BEGIN
--		print '111'
--				 SELECT    A.SourceAlt_key,
--							B.SourceName,
--                            A.UcifId,
--                            A.PanNo,
--				            A.EntityKey,
--                            A.BranchCode,
--                            A.IssuerID,
--                            A.IssuerName,
--                            A.Ref_Txn_Sys_Cust_ID,
--                            A.Issuer_Category_Code,
--							S.IssuerCategoryName,
--                            A.GrpEntityOfBank,                       			
--                            A.AuthorisationStatus,
--                            A.EffectiveFromTimeKey,
--                            A.EffectiveToTimeKey,
--								A.CreatedBy,
--								A.DateCreated,
--								A.ModifiedBy,
--								A.DateModified,
--								A.ApprovedBy,
--								A.DateApproved
--                     INTO		#TEMP55

                                --InvestmentIssuerDetail_mod
--                     FROM		curdat.InvestmentIssuerDetail A 
--					 Left join	DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key										 
--					left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
--					  WHERE A.EffectiveFromTimeKey <= @TimeKey
--                           AND A.EffectiveToTimeKey >= @TimeKey
--                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
--					 UNION
--                     SELECT		
					       
--                          A.SourceAlt_key,
--							B.SourceName,
--                            A.UcifId,
--                            A.PanNo,
--				            A.EntityKey,
--                            A.BranchCode,
--                            A.IssuerID,
--                            A.IssuerName,
--                            A.Ref_Txn_Sys_Cust_ID,
--                            A.Issuer_Category_Code,
--							S.IssuerCategoryName,
--                            A.GrpEntityOfBank,                       
--                            A.AuthorisationStatus,
--                            A.EffectiveFromTimeKey,
--                            A.EffectiveToTimeKey,
--								A.CreatedBy,
--								A.DateCreated,
--								A.ModifiedBy,
--								A.DateModified,
--								A.ApprovedBy,
--								A.DateApproved
--                    FROM InvestmentIssuerDetail_Mod A 
--					 Left join DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key										
--						left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
--						Where A.EffectiveFromTimeKey <= @TimeKey
--                           AND A.EffectiveToTimeKey >= @TimeKey
--						AND A.EntityKey IN
--                     (
--                         SELECT MAX(EntityKey)
--                         FROM InvestmentIssuerDetail_Mod
--                         WHERE EffectiveFromTimeKey <= @TimeKey
--                               AND EffectiveToTimeKey >= @TimeKey
--                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')							  
--                         GROUP BY EntityKey
--                     )
--					        SELECT *
--                 FROM
--                 (
--                     SELECT ROW_NUMBER() OVER(ORDER BY EntityKey) AS RowNumber, 
--                            COUNT(*) OVER() AS TotalCount, 
--                            'InvestmentCodeMaster' TableName, 
--                            *
--                     FROM
--                     (
--                         SELECT *
--                         FROM #temp55 A
--                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
--                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
--                     ) AS DataPointOwner
--                 ) AS DataPointOwner
--                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
--                 --      AND RowNumber <= (@PageNo * @PageSize);
           
--				 return;
--		END
BEGIN TRY

--		--	IF @PanNo =''
--		--   SET @PanNo=NULL

--		--IF @IssuerID =''
--		--   SET @IssuerID=NULL

--		--IF @IssuerName =''
--		--   SET @IssuerName=NULL

--		   --IF @InvID =''
--		   --SET @InvID=NULL
		  

--		   --IF @ISIN =''
--		   --SET @ISIN=NULL

--		   --		   IF @InstrTypeAlt_key =''
--		   --SET @InstrTypeAlt_key=NULL


--		   print '1'
--/*  IT IS Used FOR GRID Search which are not Pending for Authorization And also used for Re-Edit    */

			IF(@OperationFlag not in (16,17,20))
             BEGIN
			 IF OBJECT_ID('TempDB..#temp') IS NOT NULL
                 DROP TABLE  #temp;
                 SELECT		
				            
                            --A.CustomerACID,
                            --A.CustomerID,
                            --A.CustomerName,
                            --A.DerivativeRefNo,
                            --A.Duedate,
                            --A.DueAmt,
                            --A.OsAmt,
                            --A.POS,
				 ---------------------------------
							 A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,                       
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved
                            
							
                 INTO #temp
                 FROM 
                 (
                     SELECT
                            --E.CustomerACID,
                            --E.CustomerID,
                            --E.CustomerName,
                            --E.DerivativeRefNo,
                            --E.Duedate,
                            --E.DueAmt,
                            --E.OsAmt,
                            --E.POS,
				 ---------------------------------
							A.SourceAlt_key,
							B.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							S.InstrumentTypeName IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified
								,IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
								,IsNull(A.DateModified,A.DateCreated)as CrModDate
								,A.ApprovedBy,
								A.DateApproved
                           
							--select * from  curdat.Advacbasicdetail
                  FROM curdat.InvestmentIssuerDetail A 
					 Left join DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key										
						--left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
						left join DimInstrumentType S on A.Issuer_Category_Code = S.SrcSysName
						 
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') = 'A'
						  	
							--OR(InvID	=@InvID)				
							--OR(InstrTypeAlt_key		=@InstrTypeAlt_key)	
							--OR(ISIN		=@ISIN)
							
                     UNION

                     SELECT		
					       
                         A.SourceAlt_key,
							B.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							S.InstrumentTypeName IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
						        IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							    ,IsNull(A.DateModified,A.DateCreated)as CrModDate
								,A.ApprovedBy,
								A.DateApproved
                            
                  FROM InvestmentIssuerDetail_mod A 
					 Left join DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key					
					 --Left join DimIndustry H on C.Industry_AltKey=H.IndustryAlt_Key
					 --Left join DimInstrumentType G on C.InstrTypeAlt_Key=G.InstrumentTypeAlt_Key
					 -- Left join Dimcurrency E on D.currencyAlt_Key=E.CurrencyAlt_Key
					 -- Left join DimAssetClass F on D.AssetClass_AltKey=F.AssetClassAlt_Key
					 -- left join DimParameter P on D.HoldingNature = P.ParameterName
					 --  left join DimParameter Q on D.PartialRedumptionSettledY_N = Q.ParameterName
					 --   left join DimParameter R on C.InvestmentNature = R.ParameterName
						--left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
						left join DimInstrumentType S on A.Issuer_Category_Code = S.SrcSysName
					 --inner join curdat.DerivativeDetail E on A.EntityKey=E.EntityKey
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
						 --   AND (
							--(A.PanNo   = @PanNo)				
						 --  OR (IssuerID =@IssuerID)			
							--OR (IssuerName like '%' + @IssuerName+ '%')		
							----OR(InvID	=@InvID)				
							----OR(InstrTypeAlt_key		=@InstrTypeAlt_key)	
							----OR(ISIN		=@ISIN)
							--)
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM InvestmentIssuerDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM','1A')							  
                         GROUP BY EntityKey
                     )
           ) A
                      
                 
                 GROUP BY    
				           
                            --A.CustomerACID,
                            --A.CustomerID,
                            --A.CustomerName,
                            --A.DerivativeRefNo,
                            --A.Duedate,
                            --A.DueAmt,
                            --A.OsAmt,
                            --A.POS,
				 ---------------------------------
				         A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved
                            

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY EntityKey) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'InvestmentCodeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp A
						  WHERE  ISNULL(IssuerID, '')				LIKE '%'+@IssuerID+'%'
						  AND ISNULL(IssuerName, '')			LIKE '%'+@IssuerName+'%'
						   AND ISNULL(PanNo, '')	LIKE '%'+@PanNo+'%'
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize);
             END;
             ELSE

			 /*  IT IS Used For GRID Search which are Pending for Authorization    */
			 IF (@OperationFlag in(16,17))

             BEGIN
			 IF OBJECT_ID('TempDB..#temp16') IS NOT NULL
                 DROP TABLE #temp16;
                 SELECT     

				           
                            --A.CustomerACID,
                            --A.CustomerID,
                            --A.CustomerName,
                            --A.DerivativeRefNo,
                            --A.Duedate,
                            --A.DueAmt,
                            --A.OsAmt,
                            --A.POS,
				 ---------------------------------
							A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved
                       
                            
                 INTO #temp16
                 FROM 
                 (
                     SELECT 

					        
                            --E.CustomerACID,
                            --E.CustomerID,
                            --E.CustomerName,
                            --E.DerivativeRefNo,
                            --E.Duedate,
                            --E.DueAmt,
                            --E.OsAmt,
                            --E.POS,
				 ---------------------------------
				          A.SourceAlt_key,
							B.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							S.InstrumentTypeName IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
						        IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							    ,IsNull(A.DateModified,A.DateCreated)as CrModDate,
								A.ApprovedBy,
								A.DateApproved
							
                 FROM InvestmentIssuerDetail_mod A 
					 Left join DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key					
					 --Left join DimIndustry H on C.Industry_AltKey=H.IndustryAlt_Key
					 --Left join DimInstrumentType G on C.InstrTypeAlt_Key=G.InstrumentTypeAlt_Key
					 -- Left join Dimcurrency E on D.currencyAlt_Key=E.CurrencyAlt_Key
					 -- Left join DimAssetClass F on D.AssetClass_AltKey=F.AssetClassAlt_Key
					 -- left join DimParameter P on D.HoldingNature = P.ParameterName
					 --  left join DimParameter Q on D.PartialRedumptionSettledY_N = Q.ParameterName
					 --   left join DimParameter R on C.InvestmentNature = R.ParameterName
						--left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
						left join DimInstrumentType S on A.Issuer_Category_Code = S.SrcSysName
					 --inner join curdat.DerivativeDetail E on A.EntityKey=E.EntityKey
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           --AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM InvestmentIssuerDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND ISNULL(AuthorisationStatus, 'A') IN('NP', 'MP', 'DP', 'RM')
							    GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY   

				            
                            --A.CustomerACID,
                            --A.CustomerID,
                            --A.CustomerName,
                            --A.DerivativeRefNo,
                            --A.Duedate,
                            --A.DueAmt,
                            --A.OsAmt,
                            --A.POS,
							A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved

                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY EntityKey) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'InvestmentCodeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp16 A
						 WHERE  ISNULL(IssuerID, '')				LIKE '%'+@IssuerID+'%'
						  AND ISNULL(IssuerName, '')			LIKE '%'+@IssuerName+'%'
						   AND ISNULL(PanNo, '')	LIKE '%'+@PanNo+'%'
						    --AND ISNULL(ISIN, '')				LIKE '%'+@ISIN+'%' 
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
                 ) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;

   Else

   IF (@OperationFlag =20)
             BEGIN
			 IF OBJECT_ID('TempDB..#temp20') IS NOT NULL
                 DROP TABLE #temp20;
                 SELECT   
				   A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved
                           
                 INTO #temp20
                 FROM 
                 (
                     SELECT 

					       
                            --E.CustomerACID,
                            --E.CustomerID,
                            --E.CustomerName,
                            --E.DerivativeRefNo,
                            --E.Duedate,
                            --E.DueAmt,
                            --E.OsAmt,
                            --E.POS,
				 ---------------------------------
				         A.SourceAlt_key,
							B.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							S.InstrumentTypeName IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
						    IsNull(A.ModifiedBy,A.CreatedBy)as CrModBy
							,IsNull(A.DateModified,A.DateCreated)as CrModDate,
								A.ApprovedBy,
								A.DateApproved
                         
                    FROM InvestmentIssuerDetail_mod A 
					 Left join DimsourceDb B on A.SourceAlt_Key=B.SourceAlt_Key					
					 --Left join DimIndustry H on C.Industry_AltKey=H.IndustryAlt_Key
					 --Left join DimInstrumentType G on C.InstrTypeAlt_Key=G.InstrumentTypeAlt_Key
					 -- Left join Dimcurrency E on D.currencyAlt_Key=E.CurrencyAlt_Key
					 -- Left join DimAssetClass F on D.AssetClass_AltKey=F.AssetClassAlt_Key
					 -- left join DimParameter P on D.HoldingNature = P.ParameterName
					 --  left join DimParameter Q on D.PartialRedumptionSettledY_N = Q.ParameterName
					 --   left join DimParameter R on C.InvestmentNature = R.ParameterName
						--left join DimIssuerCategory S on A.Issuer_Category_Code = S.IssuerCategoryAlt_Key
						left join DimInstrumentType S on A.Issuer_Category_Code = S.SrcSysName
					 WHERE A.EffectiveFromTimeKey <= @TimeKey
                           AND A.EffectiveToTimeKey >= @TimeKey
                           AND ISNULL(A.AuthorisationStatus, 'A') IN('1A')
                           AND A.EntityKey IN
                     (
                         SELECT MAX(EntityKey)
                         FROM InvestmentIssuerDetail_Mod
                         WHERE EffectiveFromTimeKey <= @TimeKey
                               AND EffectiveToTimeKey >= @TimeKey
                               AND AuthorisationStatus IN('1A')
                         GROUP BY EntityKey
                     )
                 ) A 
                      
                 
                 GROUP BY   
				         A.SourceAlt_key,
							A.SourceName,
                            A.UcifId,
                            A.PanNo,
				            A.EntityKey,
                            A.BranchCode,
							A.IssuerEntityId,
                            A.IssuerID,
                            A.IssuerName,
                            A.Ref_Txn_Sys_Cust_ID,
                            A.Issuer_Category_Code,
							A.IssuerCategoryName,
                            A.GrpEntityOfBank,
                       
                            
				 ----------------------------------------------------------------------------
				            
                            A.AuthorisationStatus,
                            A.EffectiveFromTimeKey,
                            A.EffectiveToTimeKey,
								A.CreatedBy,
								A.DateCreated,
								A.ModifiedBy,
								A.DateModified,
								A.CrModBy,
							    A.CrModDate,
								A.ApprovedBy,
								A.DateApproved
                          
                 SELECT *
                 FROM
                 (
                     SELECT ROW_NUMBER() OVER(ORDER BY EntityKey) AS RowNumber, 
                            COUNT(*) OVER() AS TotalCount, 
                            'InvestmentCodeMaster' TableName, 
                            *
                     FROM
                     (
                         SELECT *
                         FROM #temp20 A
						 WHERE ISNULL(IssuerID, '')				LIKE '%'+@IssuerID+'%'
						  AND ISNULL(IssuerName, '')			LIKE '%'+@IssuerName+'%'
						   AND ISNULL(PanNo, '')	LIKE '%'+@PanNo+'%'
                         --WHERE ISNULL(BankCode, '') LIKE '%'+@BankShortName+'%'
                         --      AND ISNULL(BankName, '') LIKE '%'+@BankName+'%'
                     ) AS DataPointOwner
) AS DataPointOwner
                 --WHERE RowNumber >= ((@PageNo - 1) * @PageSize) + 1
                 --      AND RowNumber <= (@PageNo * @PageSize)

   END;


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
