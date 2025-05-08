SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- dbo.SelectAssetClassificationSourceTypeDataForUtility 'GANASEVA'

CREATE procedure [dbo].[SelectAssetClassificationSourceTypeDataForUtility]
@SourceType varchar(50)
AS
BEGIN
 Declare @TimeKey as Int =(Select distinct TimeKey from Automate_Advances where EXT_FLG='Y')
 Declare @Date as Date =(Select distinct Date from Automate_Advances where EXT_FLG='Y')

 --Declare @TimeKey as Int =(Select distinct TimeKey from Automate_Advances where Timekey =26298 )
 --Declare @Date as Date =(Select distinct Date from Automate_Advances where Timekey =26298 )
 
    IF (@SourceType ='Finacle')
	BEGIN
	  		--------------Finacle
			PRINT 'Finacle '
			Select * from(
			Select 'FinacleAssetClassification' AS TableName, A.CustomerID+'|'+A.UCIF_ID +'|'+ E.AssetClassShortNameEnum+'|'+E.AssetClassName+'|'+ Convert(Varchar(10),DateofData,105) +'|'+ ISNULL(Convert(Varchar(10),A.NPADate,105),'')  as DataUtility from ReverseFeedData A
			Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
			And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
			Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
			And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
			 where B.SourceName='Finacle'
			 --And A.AssetSubClass<>'STD'
			 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

			 UNION

			 Select 'FinacleAssetClassification' AS TableName, A.RefCustomerID+'|'+A.UCIF_ID +'|'+ E.AssetClassShortNameEnum+'|'+E.AssetClassName+'|'+ Convert(Varchar(10),@Date,105) +'|'+ ISNULL(Convert(Varchar(10),A.FinalNpaDt,105),'')  as DataUtility 
			 from Pro.AccountCal_hist A wITH (NOLOCK)
			Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
			And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
			Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
			And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
			 where B.SourceName='Finacle'
			 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
			 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
			 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

			 )A Group By TableName,DataUtility
     END
		IF (@SourceType ='Ganaseva')
		BEGIN
				--------------Ganaseva
				Select * from (
				Select 'GanasevaAssetClassification' AS TableName, A.UCIF_ID+'|'+Substring(A.CustomerID,2,8)+'|'+ E.SrcSysClassCode+'|'+E.SrcSysClassName+'|'+ Convert(Varchar(10),DateofData,103) +'|'+ ISNULL(Convert(Varchar(10),A.NPADate,103),'')  as DataUtility from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='Ganaseva'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 UNION 

				 Select 'GanasevaAssetClassification' AS TableName, A.UCIF_ID+'|'+Substring(A.RefCustomerID,2,8)+'|'+ E.SrcSysClassCode+'|'+E.SrcSysClassName+'|'+ Convert(Varchar(10),@Date,103) +'|'+ ISNULL(Convert(Varchar(10),A.FinalNpaDt,103),'')  as DataUtility 
				 from Pro.AccountCal_hist A wITH (NOLOCK)
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='Ganaseva'
				 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
				 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 )A Group By TableName,DataUtility
	    END
		
		IF (@SourceType ='ECBF')
		BEGIN
		         --------------ECBF
				 Select * from (
				Select A.CustomerID as CustomerID,A.UCIF_ID as UCIC,E.SrcSysClassCode as Asset_Code,E.SrcSysClassName as Description,Convert(Varchar(10),DateofData,105) as Asset_Code_Date,ISNULL(Convert(Varchar(10),A.NPADate,105),'')  as D2KNpaDate
				  from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='ECBF'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 UNION

				 Select A.RefCustomerID as CustomerID,A.UCIF_ID as UCIC,E.SrcSysClassCode as Asset_Code,E.SrcSysClassName as Description, Convert(Varchar(10),@Date,105) as Asset_Code_Date,ISNULL(Convert(Varchar(10),A.FinalNpaDt,105),'')  as D2KNpaDate
				  from Pro.AccountCal_hist A wITH (NOLOCK)
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='ECBF'
				 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
				 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 )A
				 Group By CustomerID,UCIC,Asset_Code,Description,Asset_Code_Date,D2KNpaDate
        END
		IF (@SourceType ='Indus')
		BEGIN
		       --------------Indus
			   Select * from (
				Select E.AssetClassShortNameEnum as asset_code,E.SrcSysClassName as description,Convert(Varchar(10),DateofData,105) as asset_code_date,ISNULL(Convert(Varchar(10),A.NPADate,105),'')  as [D2K NPA date],A.CustomerID as [Customer ID],A.UCIF_ID as UCIC from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='Indus'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 UNION 

				 Select E.AssetClassShortNameEnum as asset_code,E.SrcSysClassName as description,Convert(Varchar(10),@Date,105) as asset_code_date,ISNULL(Convert(Varchar(10),A.FinalNpaDt,105),'')  as [D2K NPA date],A.RefCustomerID as [Customer ID],A.UCIF_ID as UCIC 
				 from Pro.AccountCal_hist A wITH (NOLOCK)
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='Indus'
				 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
				 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 )A
				 Group By Asset_Code,Description,Asset_Code_Date,[D2K NPA date],[Customer ID],UCIC
        END
		IF (@SourceType ='MiFin')
		BEGIN
		        --------------MiFin
				Select * from (
				Select A.CustomerID,A.UCIF_ID,E.AssetClassShortNameEnum,E.AssetClassName,Replace(convert(varchar(20),DateofData,106),' ','-') as Asset_Code_Date,ISNULL(Replace(convert(varchar(20),A.NPADate,106),' ','-'),'')  as D2kNpaDate from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='MiFin'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 UNION 

				 Select A.RefCustomerID as CustomerID,A.UCIF_ID,E.AssetClassShortNameEnum,E.AssetClassName,Replace(convert(varchar(20),@Date,106),' ','-') as Asset_Code_Date,ISNULL(Replace(convert(varchar(20),A.FinalNpaDt,106),' ','-'),'')  as D2kNpaDate 
				 from Pro.AccountCal_hist A wITH (NOLOCK)
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='MiFin'
				 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
				 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 )A
				 Group By CustomerID,UCIF_ID,AssetClassShortNameEnum,AssetClassName,Asset_Code_Date,D2kNpaDate
        END
		IF (@SourceType ='VisionPlus')
		BEGIN
		        --------------VisionPlus
				Select * from(

				Select 'VisionPlusAssetClassification' AS TableName,('UCIC'+'|'+'CIF ID'+'|'+'asset_code'+'|'+'description'+'|'+'asset_code_date'+'|'+'D2K NPA date') as DataUtility
				UNION 
				Select'VisionPlusAssetClassification' AS TableName, (A.UCIF_ID+'|'+A.CustomerID+'|'+E.SrcSysClassCode+'|'+E.SrcSysClassName+'|'+Convert(Varchar(10),DateofData,105))+'|'+ISNULL(Convert(Varchar(10),A.NPADate,105),'')  as DataUtility
				  from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='VisionPlus'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey

				 UNION

				 Select'VisionPlusAssetClassification' AS TableName, (A.UCIF_ID+'|'+A.RefCustomerID+'|'+E.SrcSysClassCode+'|'+E.SrcSysClassName+'|'+Convert(Varchar(10),@Date,105))+'|'+ISNULL(Convert(Varchar(10),A.FinalNpaDt,105),'')  as DataUtility
				  from Pro.AccountCal_hist A wITH (NOLOCK)
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='VisionPlus'
				 And A.InitialAssetClassAlt_Key>1 And A.FinalAssetClassAlt_Key>1 
				 ANd (A.InitialAssetClassAlt_Key<>A.FinalAssetClassAlt_Key OR A.InitialNpaDt<>A.FinalNpaDt)        ------Added INitial and Final NPA Date
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey
				 )A Order By 2 Desc
		END	
		
		
------------MetaGrid
		IF (@SourceType ='MetaGrid')
		BEGIN
		       --------------MetaGrid
				Select A.CustomerID as 'CIF ID',A.UCIF_ID as 'UCIC',E.SrcSysClassCode as 'ENPA_ASSET_CODE',Case When E.AssetClassGroup='NPA' Then 'Non Performing' Else E.SrcSysClassName END as 'ENPA_DESCRIPTION',
				Replace(convert(varchar(20),DateofData,105),'-','')  as 'ENPA_ASSET_CODE_DATE',Case When A.AssetSubClass<>'STD' Then Replace(convert(varchar(20),A.NPADate,105),'-','') Else Null End as 'ENPA_D2K_NPA_DATE'
				 from ReverseFeedData A
				Inner JOIN DIMSOURCEDB B ON A.SourceAlt_Key=B.SourceAlt_key
				And B.EffectiveFromTimeKey<=@TimeKey And B.EffectiveToTimeKey>=@TimeKey
				Inner JOIN DimAssetClass E ON A.AssetSubClass=E.SrcSysClassCode
				And E.EffectiveFromTimeKey<=@TimeKey And E.EffectiveToTimeKey>=@TimeKey
				 where B.SourceName='MetaGrid'
				 --And A.AssetSubClass<>'STD'
				 AND A.EffectiveFromTimekey<=@TimeKey AND A.EffectiveToTimeKey>=@TimeKey
        END	
		
		------------Calypso
		IF (@SourceType ='Calypso')
		BEGIN
		       --------------Calypso
				
Select 
'AMEND' as [Action]
,Case When D.CP_EXTERNAL_REF IS NULL THEN '' Else D.CP_EXTERNAL_REF End  as [External Reference]
,Case When D.COUNTERPARTY_SHORTNAME IS NULL THEN '' Else D.COUNTERPARTY_SHORTNAME End as [ShortName]
,Case When D.COUNTERPARTY_FULLNAME IS NULL THEN '' Else D.COUNTERPARTY_FULLNAME End as [LongName]
,Case When D.COUNTERPARTY_COUNTRY IS NULL THEN '' Else D.COUNTERPARTY_COUNTRY End as [Country]
,Case When D.CP_FINANCIAL IS NULL THEN '' Else D.CP_FINANCIAL End as [Financial]
,Case When D.CP_PARENT IS NULL THEN '' Else D.CP_PARENT End as [Parent]       
,Case When D.CP_HOLIDAY IS NULL THEN '' Else D.CP_HOLIDAY End as [HolidayCode]
,Case When D.CP_COMMENT IS NULL THEN '' Else D.CP_COMMENT End as [Comment]
,Case When D.COUNTERPARTY_ROLE1 IS NULL THEN '' Else D.COUNTERPARTY_ROLE1 End as [Roles.Role]
,Case When D.COUNTERPARTY_ROLE2 IS NULL THEN '' Else D.COUNTERPARTY_ROLE2 End as [Roles.Role]
,Case When D.COUNTERPARTY_ROLE3 IS NULL THEN '' Else D.COUNTERPARTY_ROLE3 End as [Roles.Role]
,Case When D.COUNTERPARTY_ROLE4 IS NULL THEN '' Else D.COUNTERPARTY_ROLE4 End as [Roles.Role]
,Case When D.COUNTERPARTY_ROLE5 IS NULL THEN '' Else D.COUNTERPARTY_ROLE5 End as [Roles.Role]
,Case When D.CP_STATUS IS NULL THEN '' Else D.CP_STATUS End  as [Status]
,'ALL' as [Attribute.Role]
,'ALL'  as [Attribute.ProcessingOrg]
,'CIF_Id' as [Attribute.AttributeName]
,Case When D.CIF_ID  IS NULL THEN '' Else D.CIF_ID End   as [Attribute.AttributeValue]
,'ALL' as [Attribute.Role]
,'ALL' as [Attribute.ProcessingOrg]
,'UCIC' as [Attribute.AttributeName]
,Case When D.ucic_id  IS NULL THEN '' Else D.ucic_id End  as [Attribute.AttributeValue]
,'ALL' as [Attribute.Role]
,'ALL' as [Attribute.ProcessingOrg]
,'ENPA_ASSET_CODE' as [Attribute.AttributeName]
,Case When E.SrcSysClassCode  IS NULL THEN '' Else E.SrcSysClassCode End  as [Attribute.AttributeValue]
,'ALL' as [Attribute.Role]
,'ALL' as [Attribute.ProcessingOrg]
,'ENPA_DESCRIPTION'  as [Attribute.AttributeName]
,Case When E.SrcSysClassName  IS NULL Then '' Else E.SrcSysClassName END as [Attribute.AttributeValue]
,'ALL' as [Attribute.Role]
,'ALL' as [Attribute.ProcessingOrg]
,'ENPA_ASSET_CODE_DATE' as [Attribute.AttributeName]
,Case When A.NPIDt is null then ISNULL(Cast(A.NPIDt as varchar(20)),'') else Convert(varchar(20),A.NPIDt,105) end as [Attribute.AttributeValue]
,'ALL' as [Attribute.Role]
,'ALL' as [Attribute.ProcessingOrg]
,'ENPA_D2K_NPA_DATE' as [Attribute.AttributeName]
,Case When A.NPIDt is null then ISNULL(Cast(A.NPIDt as varchar(20)),'') else Convert(varchar(20),A.NPIDt,105) end  as [Attribute.AttributeValue]



 from dbo.InvestmentFinancialDetail A
Inner Join dbo.investmentbasicdetail B ON A.InvEntityId=B.InvEntityId
AND B.EffectiveFromTimeKey<=@Timekey And B.EffectiveToTimeKey>=@TimeKey
Inner Join dbo.InvestmentIssuerDetail C ON C.IssuerEntityId=B.IssuerEntityId
AND C.EffectiveFromTimeKey<=@Timekey And C.EffectiveToTimeKey>=@TimeKey
Inner Join ReverseFeedCalypso D ON D.issuerId=C.IssuerID
AND D.EffectiveFromTimeKey<=@Timekey And D.EffectiveToTimeKey>=@TimeKey
Inner Join DimAssetClass E ON A.FinalAssetClassAlt_Key=E.AssetClassAlt_Key
AND E.EffectiveFromTimeKey<=@Timekey And E.EffectiveToTimeKey>=@TimeKey
Where  A.EffectiveFromTimeKey<=@Timekey And A.EffectiveToTimeKey>=@TimeKey
AND A.FinalAssetClassAlt_Key<>A.InitialAssetAlt_key



        END		


END


GO
