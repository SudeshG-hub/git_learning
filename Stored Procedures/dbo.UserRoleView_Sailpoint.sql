SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[UserRoleView_Sailpoint]

AS
BEGIN

select UserRoleAlt_Key,RoleDescription From DimUserRole where EffectiveToTimeKey = 49999


END
GO
