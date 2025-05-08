SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[GLProductHistory_Prod]

				@ProductCode varchar(30)
AS
	BEGIN
				
				Select 		A.GLProductAlt_Key,
							B.ProductCode,
							B.ProductName,
							C.SourceName,
							C.SourceAlt_Key,
							D.ParameterName as FacilityType,
							A.AssetGLCode_STD,
							A.InterestReceivableGLCode_STD,
							A.InerestAccruedGLCode_STD,
							A.InterestIncome_STD,
							A.SuspendedAssetGLCode_NPA,
							A.SuspendedInterestReceivableGLCode_NPA,
							A.SuspendedInterestAccruedGLCode_NPA,
							A.SuspendedInterestIncomeGLCode_NPA,
							A.CreatedBy, 
                            Convert(Varchar(20),A.DateCreated,103) DateCreated,
							A.ApprovedBy, 
							Convert(Varchar(20),A.DateApproved,103) DateApproved,
							A.ModifiedBy, 
							Convert(Varchar(20),A.DateModified,103) DateModified
                     FROM Dimglproduct_AU A
					 Inner Join DimProduct B
					 ON A.ProductCode = B.ProductCode
					 Inner Join DIMSOURCEDB C
					 ON A.SourceAlt_key=C.SourceAlt_Key
					 Inner Join (Select ParameterAlt_Key,ParameterName,'Facility Type' as Tablename 
					 from DimParameter where DimParameterName='DimGLProduct')D
					 ON D.ParameterAlt_Key=A.FacilityTypeAlt_Key
					 WHERE A.ProductCode=@ProductCode
	END
GO
