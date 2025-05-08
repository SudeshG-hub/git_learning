SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Proc [dbo].[ActivityName_dropdown_Prod]
--@Timekey int 
--,@ActivityName Varchar(200)
as

--declare @ActivityName varchar(200)='SOCIAL INFRA REAL ESTATE'
Declare @Timekey int=null
set @Timekey =(Select Timekey from sysdatamatrix where CurrentStatus='C')

select 
ActivityAlt_Key	 as Code
,ActivityName  as ActivityDesc
,'CrisMacDesc' TableName
from Dimactivity
where EffectiveFromTimeKey<=@Timekey and EffectiveToTimeKey>=@Timekey


GO
