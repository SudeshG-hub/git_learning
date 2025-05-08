SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[NPAAgeingHistory_Prod]

						@BusinessRule Varchar(1000)=''

AS
	BEGIN

			Select	NPAAlt_Key,
					BusinessRule,
					Cast(RefValue as Varchar(1000)) RefValue,
					CreatedBy, 
					Convert(Varchar(20),DateCreated,103) DateCreated,
					ApprovedBy, 
					Convert(Varchar(20),DateApproved,103) DateApproved,
					ModifiedBy, 
					Convert(Varchar(20),DateModified,103) DateModified
					FROM DimNPAAgeingMaster
					Where BusinessRule=@BusinessRule

	END
GO
