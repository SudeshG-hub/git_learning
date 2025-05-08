SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[CollateralSecurityHistory_Old]

						@Code VARCHAR(50)

AS
	BEGIN

			Select	A.SecurityMappingAlt_Key,
					B.SourceName,
					B.SourceAlt_Key,
					A.SrcSysSecurityCode,
					A.SrcSysSecurityName,
					A.SecurityName,
					A.SecurityAlt_Key,
					A.CreatedBy, 
					Convert(Varchar(20),A.DateCreated,103) DateCreated,
					A.ApprovedBy, 
					Convert(Varchar(20),A.DateApproved,103) DateApproved,
					A.ModifiedBy, 
					Convert(Varchar(20),A.DateModified,103) DateModified
					FROM DimCollateralSecurityMapping A
					Inner join DIMSOURCEDB B
					ON A.SourceAlt_Key=B.SourceAlt_Key
					Where A.SrcSysSecurityCode=@Code

	END
GO
