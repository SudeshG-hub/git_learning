SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Proc [dbo].[GetBranchMasterMeta]
--@Timekey Int
AS

	select *, 'BranchMasterMeta' AS TableName from MetaScreenFieldDetail 
	where ScreenName = 'BranchMaster'
GO
