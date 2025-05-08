CREATE TABLE [dbo].[MetaDynamicMaster]
(
[Entitykey] [smallint] NOT NULL IDENTITY(1, 1),
[ControlID] [int] NULL,
[MasterTable] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayColumnName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Condition] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CodeColumn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameColumn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
