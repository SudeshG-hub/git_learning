CREATE TABLE [dbo].[DimDashBoardETLAudit]
(
[EntityKey] [int] NOT NULL IDENTITY(1, 1),
[BandName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PackageTableName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [smalldatetime] NULL
) ON [PRIMARY]
GO
