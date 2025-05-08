SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[EmailAlerts_Configuration_11012022]        
AS      
Begin    

SELECT *, 'Configuration' AS TableName FROM DimAlertsConfiguration
SELECT *, 'Recipient' AS TableName FROM AlertRecipient
select  convert(varchar,date, 105) as tdate from Automate_Advances where Ext_flg ='Y';
--select  convert(varchar,date, 105) as tdate from Automate_Advances where date=convert(varchar,'2021-12-31', 105) ;

END
---select * from SysDayMatrix where date='2021-12-31'---26296

---select * from Automate_Advances where Ext_flg ='Y'


GO
