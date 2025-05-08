SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROC [dbo].[CalypsoAccountLevelDropDown_16092022]

  
AS
  BEGIN

  Declare @TimeKey as Int 

	Set @TimeKey = (Select Timekey from SysDataMatrix where CurrentStatus='C')
	
			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'RestructureFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'FITLFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'InherentWeaknessFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'SARFAESIFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'UnusualBounceFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'UnclearedEffectsFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			select ParameterShortNameEnum as ParameterAlt_Key
			,ParameterName
			,'RePossessionFlag' as TableName
			from dimparameter
			where DimParameterName='DimYesNo'
			And EffectiveFromTimeKey<=@TimeKey And EffectiveToTimeKey>=@TimeKey

			Select	 ParameterShortNameEnum as ParameterAlt_Key
					,ParameterName
					,'FraudAccountFlag' as Tablename 
			from DimParameter where DimParameterName ='DimYesNo'
							And	 EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey

      select MOCTypeAlt_Key,
			 MOCTypeName
			 ,'MOCSource' as TableName
			 from dimmoctype
			 where EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey

			 select ParameterAlt_Key ,
			 ParameterName 
			 ,'MOCReason' as TableName
			 from DimParameter
			 where EffectiveFromTimeKey<=@Timekey And EffectiveToTimeKey>=@Timekey and
			  DimParameterName	= 'DimMOCReason'

			 --=========Get MetaData for Changes Fields=======
			 SELECT *, 'CalypsoAccountLevelNPAMOC' AS TableName FROM MetaScreenFieldDetail WHERE ScreenName='CalypsoAccountLevelNPAMOC'
END
GO
