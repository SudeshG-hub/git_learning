SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Parametertest]

 @Name varchar(10) = 'Yash'


AS


select * from Emp where EName = @Name


GO
