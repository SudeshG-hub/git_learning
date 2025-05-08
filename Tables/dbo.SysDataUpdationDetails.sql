CREATE TABLE [dbo].[SysDataUpdationDetails]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuID] [smallint] NULL,
[ParentEntityID] [int] NULL,
[EntityId] [int] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrModBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrModDate] [datetime] NULL,
[Remark] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StageAlt_Key] [smallint] NULL,
[CaseEntityId] [int] NULL,
[NextStageAlt_Key] [int] NULL
) ON [PRIMARY]
GO
