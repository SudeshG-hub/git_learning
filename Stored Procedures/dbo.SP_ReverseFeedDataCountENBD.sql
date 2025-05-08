SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ReverseFeedDataCountENBD]
AS
BEGIN

Declare @TimeKey AS INT =(Select TimeKey from Automate_Advances where EXT_FLG='Y')

DELETE  from ReverseFeedDataCount where ProcessDate in (Select Date from Automate_Advances where EXT_FLG='Y')
INSERT into ReverseFeedDataCount
-----------------Asset Classification---------
select DateofData as ProcessDate,
GETDATE() as GenerationDate,'Asset Classification' as Name,
SourceSystemName as SourceName,count(1)Count
from ReversefeedData
where EffectiveFromTimeKey <= @Timekey and EffectiveToTimekey >= @Timekey
group by DateofData,SourceSystemName
UNION
-----------------Degrade---------
select DateofData as ProcessDate,
GETDATE() as GenerationDate,'Degrade' as Name,
SourceSystemName as SourceName,count(1)Count
from ReversefeedData
where EffectiveFromTimeKey <= @Timekey and EffectiveToTimekey >= @Timekey
and AssetSubClass <> 'STD'
group by DateofData,SourceSystemName
UNION
-----------------Upgrade---------
select DateofData as ProcessDate,
GETDATE() as GenerationDate,'Upgrade' as Name,
SourceSystemName as SourceName,count(1)Count
from ReversefeedData
where EffectiveFromTimeKey <= @Timekey and EffectiveToTimekey >= @Timekey
and AssetSubClass = 'STD'
group by DateofData,SourceSystemName

END

GO
