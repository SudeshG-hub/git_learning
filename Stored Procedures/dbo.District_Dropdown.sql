SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[District_Dropdown]
@Timekey Int
,@StateAlt_Key int

AS

--declare @Timekey int,@StateAlt_Key int  =10  --varchar(50)='BIHAR'
set @Timekey =(Select Timekey from sysdatamatrix where CurrentStatus='C')
select 
DistrictAlt_Key	
,DistrictName
,'DistrictNameList' as TableName
from DimGeography 
where EffectiveFromTimeKey<=@Timekey and 	EffectiveToTimeKey>=@Timekey
and StateAlt_Key =@StateAlt_Key
order by DistrictName
GO
