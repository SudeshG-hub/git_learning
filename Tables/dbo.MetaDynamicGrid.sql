CREATE TABLE [dbo].[MetaDynamicGrid]
(
[EntityKey] [int] NOT NULL,
[ControlId] [int] NULL,
[Label] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnableColumnMenu] [bit] NULL,
[HeaderToolTip] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EnableColumnResizing] [bit] NULL,
[Width] [smallint] NULL,
[CellTemplate] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
