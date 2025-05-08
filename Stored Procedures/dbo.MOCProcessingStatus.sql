SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[MOCProcessingStatus]
AS

Select MocStatus as ProcessingStatus
 from MOCMonitorStatus
Where EntityKey in(Select Max(EntityKey) From MOCMonitorStatus)
GO
