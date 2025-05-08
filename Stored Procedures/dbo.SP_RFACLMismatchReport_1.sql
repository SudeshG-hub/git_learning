SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_RFACLMismatchReport_1]
@Date date
AS 


select  'Ganaseva' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='Ganaseva'
			And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
			 UNION
	select 'Finacle ' as Flag, InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='Finacle'
			And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
			 UNION
select  'ECBF' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='ECBF'
			And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			 --AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
			 UNION
select  'INDUS' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='INDUS'
			 And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date		
			 UNION
			 select  'MIFIN' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='MIFIN'
			 And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
			 UNION
select  'VISIONPLUS' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='VISIONPLUS'
			 And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
select  'Calypso' as Flag,InitialAssetClassAlt_Key,FinalAssetClassAlt_Key,InitialNpaDt,FinalNpaDt,  * from ACL_NPA_DATA A
where SourceName='Calypso'
			 And InitialAssetClassAlt_Key>1 And FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key=A.FinalAssetClassAlt_Key and A.InitialNpaDt<>A.FinalNpaDt)
			-- AND InitialNpaDt<>FinalNpaDt
			 and convert(date,process_Date,105) = @Date
GO
