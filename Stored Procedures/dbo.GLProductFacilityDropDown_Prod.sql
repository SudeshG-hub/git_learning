SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Proc [dbo].[GLProductFacilityDropDown_Prod]

AS

  BEGIN

Declare @Timekey as Int

Set @Timekey= (select Timekey from SysDataMatrix where currentstatus='C')

	BEGIN

	   Select 
		Parameter_Key
		,ParameterAlt_Key
		,ParameterName
		,'FacilityType' TableName
		
		 from DimParameter 
		Where EffectiveFromTimeKey<=@TimeKey
		And EffectiveToTimeKey>=@TimeKey
		And DimParameterName='DimGLProduct'
	 END

END
GO
