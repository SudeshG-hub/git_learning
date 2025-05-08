SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create Proc [dbo].[MOCProcessingStatus_19052022]
AS

Select MocStatus as ProcessingStatus
 from MOCMonitorStatus
Where EntityKey in(Select Max(EntityKey) From MOCMonitorStatus)
GO
