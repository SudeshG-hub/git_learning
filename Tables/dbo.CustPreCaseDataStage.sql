CREATE TABLE [dbo].[CustPreCaseDataStage]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[CustomerEntityId] [int] NULL,
[CurrentStageAlt_Key] [smallint] NULL,
[NextStageAlt_Key] [smallint] NULL
) ON [PRIMARY]
GO
