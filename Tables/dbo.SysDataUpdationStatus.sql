CREATE TABLE [dbo].[SysDataUpdationStatus]
(
[Entity_Key] [int] NOT NULL IDENTITY(1, 1),
[BranchCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseNo] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseType] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerACID] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentStageAlt_key] [smallint] NULL,
[AuthorisationStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrModBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrModDate] [datetime] NULL,
[ParentEntityID] [int] NULL,
[CustomerID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseStatus] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEntityId] [int] NULL,
[NextStageAlt_Key] [int] NULL
) ON [PRIMARY]
GO
