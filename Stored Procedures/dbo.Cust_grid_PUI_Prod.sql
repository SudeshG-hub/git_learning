SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- [Cust_grid_PUI] '1714222715864042'
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc [dbo].[Cust_grid_PUI_Prod]
@AccountID Varchar(50)
as
Declare @Timekey Int
set @Timekey=(select Timekey from SysDataMatrix where CurrentStatus='C')

--SET @Timekey=25999
select
CustomerID
,UCIFID
,AccountID	
,CustomerName	
,ProjectCategoryAlt_Key	
,PC.ProjectCategoryDescription
,ProjectSubCategoryAlt_key
,PCS.ProjectCategorySubTypeDescription	
,ProjectOwnerShipAlt_Key
,ProjectAuthorityAlt_key	
,convert(varchar(10),OriginalDCCO,103) OriginalDCCO
,OriginalProjectCost	
,OriginalDebt
,ProjectSubCatDescription
,'UpdatePUI' TableName

 from AdvAcPUIDetailMain PUI

 inner join ProjectCategory PC            on PC.ProjectCategoryAltKey=PUI.ProjectCategoryAlt_Key
                                         and PUI.EffectiveFromTimeKey<=@Timekey and PUI.EffectiveToTimeKey>=@Timekey
										 and PC.EffectiveFromTimeKey<=@Timekey and PC.EffectiveToTimeKey>=@Timekey
  LEFT join ProjectCategorySubType PCS   on PCS.ProjectCategorySubTypeAltKey=PUI.ProjectSubCategoryAlt_key
                                             AND PC.ProjectCategoryAltKey=PCS.ProjectCategoryTypeAltKey
											 and PCS.EffectiveFromTimeKey<=@Timekey and PCS.EffectiveToTimeKey>=@Timekey
   where PUI.AccountID=@AccountID

   --select * from AdvAcPUIDetailMain
   --select * from ProjectCategory ---where ProjectCategoryAltKey=2
   --select * from ProjectCategorySubType



GO
